import 'dart:convert';
import 'package:app_anansi_mobile/components/drawer/navigation.dart';
import 'package:app_anansi_mobile/helpers/format_amount.dart';
import 'package:app_anansi_mobile/helpers/format_time.dart';
import 'package:app_anansi_mobile/main.dart';
import 'package:app_anansi_mobile/pages/accounts/account_details.dart';
import 'package:app_anansi_mobile/pages/buy-shares/shares_amount.dart';
import 'package:app_anansi_mobile/pages/deposit-savings/deposit_amount.dart';
import 'package:app_anansi_mobile/pages/guarantorship/guarantorship.dart';
import 'package:app_anansi_mobile/pages/invest/invest_amount.dart';
import 'package:app_anansi_mobile/pages/loan-applications/loan_application.dart';
import 'package:app_anansi_mobile/pages/loan-applications/loan_applications.dart';
import 'package:app_anansi_mobile/pages/loan-products/loan_products.dart';
import 'package:app_anansi_mobile/pages/loans/loan_details.dart';
import 'package:app_anansi_mobile/pages/loans/loans.dart';
import 'package:app_anansi_mobile/pages/notifications/notifications.dart';
import 'package:app_anansi_mobile/pages/profile/profile.dart';
import 'package:app_anansi_mobile/pages/statements/statements.dart';
import 'package:app_anansi_mobile/services/account_service.dart';
import 'package:app_anansi_mobile/services/error_service.dart';
import 'package:app_anansi_mobile/services/loan_application_service.dart';
import 'package:app_anansi_mobile/services/loan_service.dart';
import 'package:app_anansi_mobile/services/secure_storage_service.dart';
import 'package:app_anansi_mobile/shimmers/homepage/accounts.dart';
import 'package:app_anansi_mobile/shimmers/homepage/shares_summary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shimmer/shimmer.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  double currentShares = 0;
  final double targetShares = 10.0;
  bool _loading = false;
  bool _loadingApplications = false;
  bool _loadingLoans = false;
  bool _isLoading = false;
  List<Map<String, dynamic>> accounts = [];
  Map<String, dynamic> sharesSummary = {};
  Map<String, dynamic> sharesAccount = {};
  Map<String, dynamic> savingsAccount = {};
  Set<String> hiddenAccountIds = {};
  List<Map<String, dynamic>> applications = [];
  List<Map<String, dynamic>> loans = [];

  void _toggleVisibility(String accountId) {
    setState(() {
      if (hiddenAccountIds.contains(accountId)) {
        hiddenAccountIds.remove(accountId);
      } else {
        hiddenAccountIds.add(accountId);
      }
    });
  }

  Future<void> fetchCustomerDetails() async {
    _isLoading = true;
    try {
      final (response, errors) = await AccountService().customerDetails();
      if (errors != null) {
        ErrorService.showActionableError(
          context,
          title: errors[0],
          message: errors[1],
        );
      } else if (response != null) {
        final responseInfo = response.data['data'];
        await SecureStorageService().write("user", responseInfo);
        setState(() {
          accounts = List<Map<String, dynamic>>.from(
            responseInfo['accounts'] ?? [],
          );
          sharesAccount = accounts.firstWhere(
            (acc) => acc['product']?['name'] == "Shares",
            orElse: () => {},
          );
          savingsAccount = accounts.firstWhere(
            (acc) => acc['product']?['name'] == "Savings",
            orElse: () => {},
          );
        });
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<Map<String, dynamic>?> getUser() async {
    String? userJson = await SecureStorageService().read('user');
    if (userJson == null) return null;
    Map<String, dynamic> userMap = jsonDecode(userJson);
    return userMap;
  }

  Future<void> fetchSharesDetails() async {
    _loading = true;
    try {
      final user = await getUser();
      final (response, errors) = await AccountService().sharesSummary(
        publicId: user?['public_id'] ?? "",
      );
      if (errors != null) {
        ErrorService.showActionableError(
          context,
          title: errors[0],
          message: errors[1],
        );
      } else if (response != null) {
        setState(() {
          sharesSummary = response.data['data'] ?? {};
          currentShares =
              double.tryParse(
                response.data['data']['numberOfShares']?.toString() ?? '0',
              ) ??
              0.0;
        });
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> getActiveLoanApplications() async {
    _loadingApplications = true;
    try {
      final user = await getUser();
      final (response, errors) = await LoanApplicationService()
          .listActiveLoanApplications(customerId: user?['id'] ?? "");
      if (errors != null) {
        ErrorService.showActionableError(
          context,
          title: errors[0],
          message: errors[1],
        );
      } else if (response != null) {
        final responseInfo = response.data['data'];
        setState(() {
          applications = List<Map<String, dynamic>>.from(
            responseInfo['applications'] ?? [],
          );
        });
      }
    } finally {
      if (mounted) setState(() => _loadingApplications = false);
    }
  }

  Future<void> getActiveLoans() async {
    _loadingLoans = true;
    try {
      final user = await getUser();
      final (response, errors) = await LoanService().listActiveLoans(
        customerId: user?['id'] ?? "",
      );
      if (errors != null) {
        ErrorService.showActionableError(
          context,
          title: errors[0],
          message: errors[1],
        );
      } else if (response != null) {
        final responseInfo = response.data['data'];
        setState(() {
          loans = List<Map<String, dynamic>>.from(responseInfo['loans'] ?? []);
        });
      }
    } finally {
      if (mounted) setState(() => _loadingLoans = false);
    }
  }

  Future<void> _handleRefresh() async {
    await fetchCustomerDetails();
    await fetchSharesDetails();
    await getActiveLoanApplications();
    await getActiveLoans();
  }

  Color _getStatusColor(String? status) {
    if (status == null) {
      return const Color(0xFF94A3B8); // Default Slate Gray for null
    }

    switch (status.toLowerCase().trim()) {
      // Active & Healthy Statuses
      case 'approved':
      case 'active':
      case 'running':
      case 'current':
        return const Color(0xFF10B981); // Emerald Green

      // Waiting or Processing Statuses
      case 'pending':
      case 'processing':
      case 'under review':
      case 'applied':
        return const Color(0xFFF59E0B); // Amber Yellow

      // At Risk or Rejected Statuses
      case 'declined':
      case 'rejected':
      case 'defaulted':
      case 'overdue':
      case 'arrears':
        return const Color(0xFFEF4444); // Rose Red

      // Completed Statuses
      case 'settled':
      case 'paid':
      case 'closed':
        return const Color(0xFF3B82F6); // Info Blue

      // Fallback for any unmapped string values
      default:
        return const Color(0xFF64748B); // Neutral Cool Gray
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSharesDetails();
    fetchCustomerDetails();
    getActiveLoans();
    getActiveLoanApplications();
  }

  @override
  Widget build(BuildContext context) {
    final double currentShares =
        double.tryParse(sharesSummary['numberOfShares']?.toString() ?? '0') ??
        0.0;
    const double targetShares = 10.0;

    double percentage = (currentShares / targetShares).clamp(0.0, 1.0);

    bool shouldShowProgress = currentShares < targetShares;
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      drawer: Navigation(
        activePageRoute: AnansiRoutes.dashboard,
        onRouteSelected: (String targetNamedRoute) {
          Navigator.pop(context);
          if (targetNamedRoute == AnansiRoutes.dashboard) return;
          Navigator.pushNamed(context, targetNamedRoute);
        },
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildDashboardAppBar(context),
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              _handleRefresh();
            },
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Dashboard",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AnansiColors.darkBlue,
                    ),
                  ),
                  Text(
                    "Welcome back to your financial overview.",
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          if (_loading)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: buildMembershipProgressShimmer(),
              ),
            )
          else if (shouldShowProgress)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: _buildMembershipProgress(percentage),
              ),
            )
          else
            const SliverToBoxAdapter(child: SizedBox.shrink()),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    "ACCOUNTS",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: Colors.grey,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                if (_isLoading) ...[
                  buildAccountCardShimmer(),
                  const SizedBox(height: 16),
                  buildAccountCardShimmer(),
                ] else if (accounts.isEmpty)
                  _buildEmptyAccountsState()
                else
                  ...accounts.asMap().entries.map((entry) {
                    int index = entry.key;
                    var account = entry.value;
                    return Column(
                      children: [
                        _buildAccountCard(
                          id: account['id'] ?? "",
                          title:
                              account['product']['name']
                                  ?.toString()
                                  .toUpperCase() ??
                              "ACCOUNT",
                          accountNumber: account['account_number'] ?? "N/A",
                          balance: account['balance']?.toString() ?? "0",
                          isPrimary: index == 0,
                        ),
                        if (index != accounts.length - 1)
                          const SizedBox(height: 16),
                      ],
                    );
                  }),
              ]),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "QUICK ACTIONS",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: Colors.grey,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 16,
                    runSpacing: 20,
                    alignment: WrapAlignment.start,
                    children: [
                      _buildQuickAction(
                        label: "Quick\nInvest",
                        icon: Icons.trending_up_rounded,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const InvestAmount(),
                          ),
                        ),
                      ),
                      _buildQuickAction(
                        label: "Deposit\nSavings",
                        icon: Icons.account_balance_wallet_rounded,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DepositAmount(id: savingsAccount['id'] ?? ""),
                          ),
                        ),
                      ),
                      _buildQuickAction(
                        label: "Buy\nShares",
                        icon: Icons.pie_chart_rounded,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SharesAmount(id: sharesAccount['id'] ?? ""),
                          ),
                        ),
                      ),
                      _buildQuickAction(
                        label: "All\nLoans",
                        icon: CupertinoIcons.graph_square,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyLoans(),
                          ),
                        ),
                      ),
                      _buildQuickAction(
                        label: "All\nStatements",
                        icon: Icons.description_rounded,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Statements(),
                          ),
                        ),
                      ),
                      _buildQuickAction(
                        label: "Explore\nProducts",
                        icon: Icons.grid_view_rounded,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoanProducts(),
                          ),
                        ),
                      ),
                      _buildQuickAction(
                        label: "My\nGuarantorship",
                        icon: Icons.gavel_rounded,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Guarantorship(),
                          ),
                        ),
                      ),
                      _buildQuickAction(
                        label: "Loan\nApplications",
                        icon: CupertinoIcons.chart_bar_alt_fill,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoanApplications(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            sliver: SliverToBoxAdapter(
              child: _buildSectionHeader(
                "Active Applications",
                "${applications.length} Active",
              ),
            ),
          ),
          _loadingApplications
              ? _buildLoanApplicationsSkeleton()
              : applications.isNotEmpty
              ? SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final item = applications[index];
                      return _buildApplicationItem(
                        reference: item['application_number'] ?? "N/A",
                        title:
                            item['product']['name'] ??
                            "Loan Application",
                        date: formatPostgresDateWithTime(
                          item['application_date'],
                        ),
                        amount: formatAmount(item['applied_amount'] ?? 0),
                        status: item['status_label'] ?? "Pending",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  LoanApplication(appId: item['id'] ?? ""),
                            ),
                          );
                        },
                      );
                    }, childCount: applications.length),
                  ),
                )
              : _buildEmptyState(
                  title: "No Loan Applications",
                  description:
                      "You haven't submitted any loan applications yet. When you apply for a loan, your application progress, approval stages, and status tracking will appear here.",
                  icon: CupertinoIcons
                      .doc_text, // Form/document icon perfect for applications
                ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            sliver: SliverToBoxAdapter(
              child: _buildSectionHeader(
                "Recent Loans",
                "${loans.length} Active",
              ),
            ),
          ),
          _loadingLoans
              ? _buildLoansSkeletonList()
              : loans.isNotEmpty
              ? SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final loan = loans[index];
                      return _buildLoanItem(
                        title: loan['loan_type'],
                        id: loan['loan_code'],
                        amount: formatAmount(loan['loan_amount']),
                        balance: formatAmount(loan['outstanding_balance']),
                        status: loan['loan_status'],
                        statusColor: _getStatusColor(loan['loan_status']),
                        maturityDate: loan['loan_due_date'],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  LoanDetails(loanId: loan['id'] ?? ""),
                            ),
                          );
                        },
                      );
                    }, childCount: loans.length),
                  ),
                )
              : _buildEmptyState(
                  title: "No Active Loans",
                  description:
                      "You currently do not have any running or settled loans on your profile. When you accept a loan offer, its repayment tracker and balances will show up here.",
                  icon: CupertinoIcons
                      .creditcard, // Swapped to a credit card icon for loans
                ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required String title,
    required String description,
    required IconData icon,
  }) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              32,
            ), // Matches your app's high rounded aesthetic
            border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize
                .min, // Constrains the card height to wrap contents snugly
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Muted Circular Icon Wrapper
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFF1F5F9),
                    width: 1.5,
                  ),
                ),
                child: Icon(icon, size: 44, color: Colors.grey.shade400),
              ),
              const SizedBox(height: 24),

              // Description Headers
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AnansiColors.darkBlue,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.blueGrey.shade400,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String badge) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: Colors.grey,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2F1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              badge,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00796B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyAccountsState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFFF1F4F8)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Icon(
              CupertinoIcons.doc_text_search,
              color: Colors.grey.shade400,
              size: 32,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "No Accounts Found",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
              color: AnansiColors.darkBlue,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "We couldn't find any active accounts linked to your profile. Try refreshing or contact your Sacco admin.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.blueGrey.shade400,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          TextButton.icon(
            onPressed: () => fetchCustomerDetails(),
            icon: const Icon(CupertinoIcons.refresh, size: 16),
            label: const Text("Refresh Records"),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF17C6C6),
              textStyle: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoansSkeletonList() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Shimmer.fromColors(
              baseColor: Colors.grey.shade200,
              highlightColor: Colors.grey.shade50,
              period: const Duration(milliseconds: 1200),
              child: _buildLoanSkeletonItem(),
            );
          },
          childCount: 5, // Renders a uniform layout block of 5 items
        ),
      ),
    );
  }

  Widget _buildLoanSkeletonItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          // 1. Header Section Placeholder
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Loan Title Bar
                      Container(
                        width: 140,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Loan ID Tag block
                      Container(
                        width: 70,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ],
                  ),
                ),
                // Maturity Badge circle block
                Container(
                  width: 75,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),

          // 2. Main Stats Box Placeholder
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Principal Stat block
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 80,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
                // Internal Divider Element
                Container(
                  width: 1,
                  height: 30,
                  color: Colors.grey.withValues(alpha: 0.15),
                ),
                // Current Balance Stat block
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 75,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 90,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 3. Status Footer Placeholder
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Status Rounded Chip
                Container(
                  width: 85,
                  height: 22,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                // View Details Indicator Action
                Container(
                  width: 70,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      snap: true,
      backgroundColor: const Color(0xFFF8FAFC).withValues(alpha: 0.9),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leadingWidth: 72,
      leading: Builder(
        builder: (nestedContext) {
          return IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(
              CupertinoIcons.square_grid_2x2,
              size: 30,
              color: AnansiColors.darkBlue,
            ),
            onPressed: () {
              Scaffold.of(nestedContext).openDrawer();
            },
          );
        },
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Overview",
            style: TextStyle(
              color: AnansiColors.darkBlue,
              fontWeight: FontWeight.w900,
              fontSize: 16,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 1),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "MEMBER ACTIVE",
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 8,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Center(
            child: _buildGlassActionButton(
              icon: CupertinoIcons.bell,
              hasNotification: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Notifications(),
                  ),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Center(
            child: _buildGlassActionButton(
              icon: CupertinoIcons.person,
              hasNotification: false,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Profile()),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGlassActionButton({
    required IconData icon,
    required bool hasNotification,
    required VoidCallback onTap,
  }) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFF1F4F8), width: 1.5),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(icon, size: 18, color: AnansiColors.darkBlue),
            onPressed: onTap,
          ),
        ),
        if (hasNotification)
          Positioned(
            right: 2,
            top: 2,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildQuickAction({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double sidePadding = 48.0;
    final double spacing = 16.0;
    final double width = (screenWidth - sidePadding - (spacing * 3)) / 4;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: width,
          height: width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade100, width: 1),
            boxShadow: [
              BoxShadow(
                color: AnansiColors.darkBlue.withValues(alpha: 0.04),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap, // Callback implemented here
              borderRadius: BorderRadius.circular(24),
              splashColor: AnansiColors.darkBlue..withValues(alpha: 0.1),
              child: Center(
                child: Container(
                  width: width * 0.7,
                  height: width * 0.7,
                  decoration: BoxDecoration(
                    color: AnansiColors.darkBlue.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      size: width * 0.35,
                      color: AnansiColors.darkBlue,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AnansiColors.darkBlue.withValues(alpha: 0.9),
            letterSpacing: -0.1,
          ),
        ),
      ],
    );
  }

  Widget _buildMembershipProgress(double percentage) {
    bool isCompleted = percentage >= 1.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFFF1F4F8), width: 2),
        boxShadow: [
          BoxShadow(
            color: AnansiColors.darkBlue.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "MEMBERSHIP PROGRESS",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 10,
                        letterSpacing: 1.5,
                        color: AnansiColors.darkBlue.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              ),
              _buildCircularMiniIndicator(percentage),
            ],
          ),
          const SizedBox(height: 10),
          _buildGlowProgressBar(percentage),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${currentShares.toInt()} of 10 Shares",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  color: AnansiColors.darkBlue.withValues(alpha: 0.7),
                ),
              ),
              if (!isCompleted)
                Text(
                  "${((1.0 - percentage) * 10).toInt()} shares left",
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                    color: Color(0xFF17C6C6),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Unlock Institutional Credit Intelligence and full dividend rights.",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blueGrey.shade600,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SharesAmount(id: sharesAccount['id'] ?? ""),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AnansiColors.darkBlue,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 54),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Buy Shares",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(CupertinoIcons.arrow_right, size: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularMiniIndicator(double percentage) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF17C6C6).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "${(percentage * 100).toInt()}%",
        style: const TextStyle(
          color: Color(0xFF17C6C6),
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildGlowProgressBar(double percentage) {
    return Stack(
      children: [
        Container(
          height: 10,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 800),
          height: 10,
          width: (300 * percentage),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AnansiColors.darkBlue, Color(0xFF17C6C6)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF17C6C6).withValues(alpha: 0.4),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAccountCard({
    required String id,
    required String title,
    required String accountNumber,
    required String balance,
    required bool isPrimary,
  }) {
    bool isHidden = hiddenAccountIds.contains(id);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AccountDetails(accountId: id, accountNumber: accountNumber),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isPrimary ? AnansiColors.darkBlue : Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          border: isPrimary ? null : Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: isPrimary ? Colors.blue.shade200 : Colors.grey,
                      ),
                    ),
                    Text(
                      accountNumber,
                      style: TextStyle(
                        fontSize: 12,
                        color: isPrimary ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  child: Icon(
                    LucideIcons.wallet,
                    size: 20,
                    color: isPrimary
                        ? Colors.blue.shade200
                        : Colors.grey.shade300,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isHidden ? "KES ••••••••" : formatAmount(balance),
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w400,
                    fontSize: 24,
                    color: isPrimary ? Colors.white : AnansiColors.darkBlue,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: isPrimary
                        ? Colors.blue.shade200.withValues(alpha: 0.15)
                        : Colors.grey.shade300.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    iconSize: 20,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      isHidden ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                    ),
                    color: isPrimary ? Colors.blue.shade200 : Colors.grey,
                    style: IconButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () => _toggleVisibility(id),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoanItem({
    required String title,
    required String id,
    required String amount,
    required String balance,
    required String status,
    required Color statusColor,
    required String maturityDate,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30), // Match the container
        splashColor: const Color(
          0xFF17C6C6,
        ).withValues(alpha: 0.05), // Anansi Teal subtle splash
        highlightColor: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: AnansiColors.darkBlue.withValues(alpha: 0.04),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            children: [
              // 1. Header Section
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 14),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                              color: AnansiColors.darkBlue,
                              letterSpacing: -0.4,
                            ),
                          ),
                          _buildLoanIdTag(id),
                        ],
                      ),
                    ),
                    _buildMaturityBadge(maturityDate),
                  ],
                ),
              ),

              // 2. The Main Stats Box
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLoanStat("Principal", amount),
                    Container(
                      width: 1,
                      height: 30,
                      color: Colors.grey.withValues(alpha: 0.15),
                    ),
                    _buildLoanStat(
                      "Current Balance",
                      balance,
                      isHighlight: true,
                    ),
                  ],
                ),
              ),

              // 3. NEW REFINED STATUS FOOTER
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Status Chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            status.toUpperCase(),
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Simple "Manage" or "Details" Text
                    const Row(
                      children: [
                        Text(
                          "View Details",
                          style: TextStyle(
                            color: AnansiColors.darkBlue,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          CupertinoIcons.chevron_right,
                          size: 12,
                          color: AnansiColors.darkBlue,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoanStat(
    String label,
    String value, {
    bool isHighlight = false,
  }) {
    return Column(
      crossAxisAlignment: isHighlight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w800,
            color: Colors.grey.shade500,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  color: isHighlight ? AnansiColors.darkBlue : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoanIdTag(String id) {
    return Text(
      id.toUpperCase(),
      style: TextStyle(
        color: Colors.grey.shade600,
        fontSize: 13,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildMaturityBadge(String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "MATURITY",
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w800,
            color: Colors.grey.shade400,
            letterSpacing: 0.5,
          ),
        ),
        Text(
          date,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AnansiColors.darkBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildApplicationItem({
    required String reference,
    required String title,
    required String date,
    required String amount,
    required String status,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30), // Match the container
        splashColor: const Color(
          0xFF17C6C6,
        ).withValues(alpha: 0.05), // Anansi Teal subtle splash
        highlightColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.hourglass_empty_rounded,
                color: Colors.amber,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reference,
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: AnansiColors.darkBlue,
                      ),
                    ),
                    Text(
                      date,
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    amount,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: AnansiColors.darkBlue,
                    ),
                  ),
                  Text(
                    status,
                    style: const TextStyle(
                      color: Colors.amber,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoanApplicationsSkeleton() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Shimmer.fromColors(
              baseColor: Colors.grey.shade200,
              highlightColor: Colors.grey.shade50,
              period: const Duration(milliseconds: 1200),
              child: _buildApplicationSkeletonItem(),
            );
          },
          childCount: 6, // Enforces exactly 6 layout skeletons
        ),
      ),
    );
  }

  Widget _buildApplicationSkeletonItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
      ),
      child: Row(
        children: [
          // 1. Status Indicator Icon Placeholder
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),

          // 2. Main Details Placeholder
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Reference line
                Container(
                  width: 70,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 6),
                // Title line
                Container(
                  width: 140,
                  height: 13,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 6),
                // Date line
                Container(
                  width: 90,
                  height: 11,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),

          // 3. Amount and Status Badge Placeholder
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Amount line
              Container(
                width: 65,
                height: 13,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
              // Status Badge block
              Container(
                width: 60,
                height: 18,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

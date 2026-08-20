import 'dart:convert';
import 'package:app_anansi_mobile/components/drawer/navigation.dart';
import 'package:app_anansi_mobile/helpers/format_amount.dart';
import 'package:app_anansi_mobile/main.dart';
import 'package:app_anansi_mobile/pages/loan-products/loan_products.dart';
import 'package:app_anansi_mobile/pages/loans/loan_details.dart';
import 'package:app_anansi_mobile/pages/notifications/loan_notifications.dart';
import 'package:app_anansi_mobile/services/error_service.dart';
import 'package:app_anansi_mobile/services/loan_service.dart';
import 'package:app_anansi_mobile/services/secure_storage_service.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class MyLoans extends StatefulWidget {
  const MyLoans({super.key});

  @override
  State<MyLoans> createState() => _MyLoansState();
}

class _MyLoansState extends State<MyLoans> {
  List<Map<String, dynamic>> loans = [];
  bool _isLoading = false;

  Future<Map<String, dynamic>?> getUser() async {
    String? userJson = await SecureStorageService().read('user');
    if (userJson == null) return null;
    Map<String, dynamic> userMap = jsonDecode(userJson);
    return userMap;
  }

  Future<void> getLoans() async {
    _isLoading = true;
    try {
      final user = await getUser();
      final (response, errors) = await LoanService().listLoans(
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
          loans = List<Map<String, dynamic>>.from(
            responseInfo['loan_data'] ?? [],
          );
        });
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
    getLoans();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      drawer: Navigation(
        activePageRoute: AnansiRoutes.loans,
        onRouteSelected: (String targetNamedRoute) {
          Navigator.pop(context);
          if (targetNamedRoute == AnansiRoutes.dashboard) return;
          Navigator.pushNamed(context, targetNamedRoute);
        },
      ),
      body: CustomScrollView(
        slivers: [
          // 1. App Bar
          _buildAppBar(),

          // 2. Loan Summary Hero
          SliverToBoxAdapter(child: _buildLoanSummaryHero()),

          // 3. Application Action
          SliverToBoxAdapter(child: _buildApplyLoanAction(context)),

          // 4. Section Header with Filter
          SliverToBoxAdapter(child: _buildSectionHeader("Active Facilities")),

          // 5. The Loans List
          _isLoading
              ? _buildLoansSkeletonList()
              : loans.isNotEmpty
              ? SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final loan = loans[index];
                      return _buildLoanItem(
                        title: loan['loan_type'],
                        id: loan['loan_code'],
                        amount: formatAmount(loan['loan_amount']),
                        balance: formatAmount(loan['loan_Balance']),
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
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required String title,
    required String description,
    required IconData icon,
  }) {
    return SliverFillRemaining(
      hasScrollBody:
          false, // Ensures accurate layout calculation for filling the viewport
      child: Padding(
        // 20 matching padding to perfectly align with your app bars and summary cards
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Container(
          width:
              double.infinity, // Forces complete horizontal alignment stretch
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
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
            mainAxisAlignment: MainAxisAlignment
                .center, // Centers your contents vertically in the expanded card space
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

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      floating: true,
      backgroundColor: const Color(0xFFF8FAFC).withValues(alpha: 0.9),
      elevation: 0,
      centerTitle: true,
      leadingWidth: 64,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Loans",
            style: TextStyle(
              color: AnansiColors.darkBlue,
              fontWeight: FontWeight.w900,
              fontSize: 15,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "ALL LOANS",
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ],
      ),
      leading: Center(
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade100),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Builder(
            builder: (nestedContext) {
              return IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  CupertinoIcons.square_grid_2x2,
                  size: 20,
                  color: AnansiColors.darkBlue,
                ),
                onPressed: () {
                  Scaffold.of(nestedContext).openDrawer();
                },
              );
            },
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Center(
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  CupertinoIcons.bell,
                  size: 18,
                  color: AnansiColors.darkBlue,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoanNotifications(),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
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
    return Container(
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30), // Match the container
          splashColor: const Color(
            0xFF17C6C6,
          ).withValues(alpha: 0.05), // Anansi Teal subtle splash
          highlightColor: Colors.transparent,
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

  Widget _buildLoanSummaryHero() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AnansiColors.darkBlue, Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AnansiColors.darkBlue.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Total Outstanding",
            style: TextStyle(
              color: Colors.white60,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "KES 142,500.00",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _summaryMiniStat("Next Repayment", "15 May"),
              const SizedBox(width: 40),
              _summaryMiniStat("Loan Limit", "KES 500k"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryMiniStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white38, fontSize: 10),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildApplyLoanAction(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: InkWell(
        onTap: () => _handleNewApplication(context),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AnansiColors.darkBlue.withValues(alpha: 0.1),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: AnansiColors.darkBlue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  CupertinoIcons.add,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Apply for a new Loan",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: AnansiColors.darkBlue,
                      ),
                    ),
                    Text(
                      "Instant processing for eligible members",
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Icon(
                CupertinoIcons.chevron_right,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: AnansiColors.darkBlue,
              letterSpacing: -0.5,
            ),
          ),
          const Icon(
            CupertinoIcons.slider_horizontal_3,
            size: 20,
            color: AnansiColors.darkBlue,
          ),
        ],
      ),
    );
  }

  void _handleNewApplication(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoanProducts()),
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
}

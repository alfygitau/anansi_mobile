import 'package:app_anansi_mobile/components/drawer/navigation.dart';
import 'package:app_anansi_mobile/helpers/format_amount.dart';
import 'package:app_anansi_mobile/main.dart';
import 'package:app_anansi_mobile/pages/accounts/account_details.dart';
import 'package:app_anansi_mobile/services/account_service.dart';
import 'package:app_anansi_mobile/services/error_service.dart';
import 'package:app_anansi_mobile/services/secure_storage_service.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';

class AllAccounts extends StatefulWidget {
  const AllAccounts({super.key});

  @override
  State<AllAccounts> createState() => _AllAccountsState();
}

class _AllAccountsState extends State<AllAccounts> {
  List<Map<String, dynamic>> accounts = [];
  bool _isLoading = true;
  String? _errorMessage;

  final Set<String> _hiddenBalances = {};

  @override
  void initState() {
    super.initState();
    fetchCustomerDetails();
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
        });
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  (Color backgroundColor, Color textColor) _getStatusColors(String status) {
    switch (status.toLowerCase().trim()) {
      case 'active':
      case 'approved':
        return (
          const Color(0xFFE6F4EA), // Muted light green
          const Color(0xFF137333), // Dark premium green
        );
      case 'pending':
      case 'review':
        return (
          const Color(0xFFFEF7E0), // Muted light orange
          const Color(0xFFB06000), // Dark premium orange
        );
      case 'blocked':
      case 'inactive':
      case 'suspended':
        return (
          const Color(0xFFFCE8E6), // Muted light red
          const Color(0xFFC5221F), // Dark premium red
        );
      default:
        return (
          const Color(0xFFF1F3F5), // Default light grey
          const Color(0xFF495057), // Default dark grey
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    // THE FIX: Filter primary account specifically by checking if product name matches "Savings"
    final primaryAccounts = accounts
        .where(
          (acc) =>
              acc["product"]?["name"]?.toString().toLowerCase().trim() ==
              "savings",
        )
        .toList();

    final otherAccounts = accounts
        .where(
          (acc) =>
              acc["product"]?["name"]?.toString().toLowerCase().trim() !=
              "savings",
        )
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      drawer: Navigation(
        activePageRoute: AnansiRoutes.dashboard,
        onRouteSelected: (String targetNamedRoute) {
          Navigator.pushNamed(context, targetNamedRoute);
        },
      ),
      body: RefreshIndicator(
        onRefresh: fetchCustomerDetails,
        color: Theme.of(context).primaryColor,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            _buildAppBar(),
            if (_isLoading)
              _buildShimmerLoading()
            else if (_errorMessage != null)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              )
            else if (accounts.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: Text("No accounts found.")),
              )
            else ...[
              if (primaryAccounts.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 8.0,
                    ),
                    child: Text(
                      "PRIMARY ACCOUNT",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: Colors.grey[500],
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 0,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: _buildPremiumAccountCard(
                          context,
                          primaryAccounts[index],
                        ),
                      );
                    }, childCount: primaryAccounts.length),
                  ),
                ),
              ],

              // --- CATEGORY 2: OTHER ACCOUNTS ---
              if (otherAccounts.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 8.0,
                    ),
                    child: Text(
                      "OTHER ACCOUNTS",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: Colors.grey[500],
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 0,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: _buildPremiumAccountCard(
                          context,
                          otherAccounts[index],
                        ),
                      );
                    }, childCount: otherAccounts.length),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return _buildSkeletonCard();
        }, childCount: 5),
      ),
    );
  }

  Widget _buildSkeletonCard() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Shimmer.fromColors(
        baseColor: const Color(0xFFEAECEF),
        highlightColor: const Color(0xFFF8F9FA),
        child: Container(
          height: 160,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFEAECEF), width: 1),
          ),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 140,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 80,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 65,
                    height: 22,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Divider(color: Color(0xFFF1F3F5), height: 1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 110,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 50,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 60,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ],
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
      scrolledUnderElevation: 0,
      centerTitle: true,
      leadingWidth: 64,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "All Accounts",
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
                _isLoading
                    ? "UPDATING..."
                    : accounts.isEmpty
                    ? "NO ACCOUNTS FOUND"
                    : accounts.length == 1
                    ? "1 ACCOUNT ACTIVE"
                    : "${accounts.length} ACCOUNTS ACTIVE",
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 7,
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
                  Icons.refresh_rounded,
                  size: 18,
                  color: AnansiColors.darkBlue,
                ),
                onPressed: fetchCustomerDetails,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumAccountCard(
    BuildContext context,
    Map<String, dynamic> account,
  ) {
    final String rawProductName = account["product"]?["name"]?.toString() ?? "";
    // Evaluates condition: accounts matching "Savings" are treated as primary styled blocks
    final bool isSavingsAccount =
        rawProductName.toLowerCase().trim() == "savings";

    final String accountNumber = account["account_number"]?.toString() ?? "N/A";
    final String productName = rawProductName.toUpperCase().isEmpty
        ? "ACCOUNT"
        : rawProductName.toUpperCase();
    final String balance = formatAmount(account["balance"] ?? 0);
    final String status = account["status"]?.toString() ?? "Active";
    final (statusBg, statusText) = _getStatusColors(status);

    final bool isBalanceHidden = _hiddenBalances.contains(
      accountShiftKey(accountNumber, productName),
    );

    return GestureDetector(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AccountDetails(
              accountId: account['id'] ?? "",
              accountNumber: accountNumber,
            ),
          ),
        ),
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          // THE FIX: Use brand dark blue for Savings accounts, otherwise render pure white
          color: isSavingsAccount ? AnansiColors.darkBlue : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSavingsAccount
                ? AnansiColors.darkBlue
                : const Color(0xFFEAECEF),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: isSavingsAccount ? 0.04 : 0.015,
              ),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          productName,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            // Dynamic color matching to maximize font contrast configurations
                            color: isSavingsAccount
                                ? Colors.white
                                : Colors.black,
                            letterSpacing: 0.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(
                              ClipboardData(text: accountNumber),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Account number copied!"),
                                duration: Duration(seconds: 1),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                accountNumber,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isSavingsAccount
                                      ? Colors.white.withValues(alpha: 0.7)
                                      : Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.copy_rounded,
                                size: 12,
                                color: isSavingsAccount
                                    ? Colors.white.withValues(alpha: 0.5)
                                    : Colors.grey[400],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      status.toUpperCase(),
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        color: statusText,
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Divider(
                  color: isSavingsAccount
                      ? Colors.white.withValues(alpha: 0.15)
                      : const Color(0xFFF1F3F5),
                  height: 1,
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        isBalanceHidden ? "KES ••••••" : balance,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                          color: isSavingsAccount
                              ? Colors.white
                              : AnansiColors.darkBlue,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // THE FIX: Enclose view toggle button inside a clean circular background wrapper
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: isSavingsAccount
                              ? Colors.white.withValues(alpha: 0.12)
                              : const Color(0xFFF1F3F5),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            isBalanceHidden
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 13,
                            color: isSavingsAccount
                                ? Colors.white
                                : Colors.grey[600],
                          ),
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            final String key = accountShiftKey(
                              accountNumber,
                              productName,
                            );
                            setState(() {
                              if (isBalanceHidden) {
                                _hiddenBalances.remove(key);
                              } else {
                                _hiddenBalances.add(key);
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String accountShiftKey(String number, String fallbackName) {
    return "${number}_$fallbackName";
  }
}

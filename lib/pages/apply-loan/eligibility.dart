import 'dart:convert';

import 'package:app_anansi_mobile/helpers/format_amount.dart';
import 'package:app_anansi_mobile/pages/apply-loan/add_loan_details.dart';
import 'package:app_anansi_mobile/pages/help&support/help_support.dart';
import 'package:app_anansi_mobile/services/error_service.dart';
import 'package:app_anansi_mobile/services/loan_application_service.dart';
import 'package:app_anansi_mobile/services/secure_storage_service.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoanEligibility extends StatefulWidget {
  final String productId;
  const LoanEligibility({super.key, required this.productId});

  @override
  State<LoanEligibility> createState() => _LoanEligibilityState();
}

class _LoanEligibilityState extends State<LoanEligibility> {
  Map<String, dynamic> eligibility = {};
  List<Map<String, dynamic>> eligibilityChecks = [];
  bool _isLoading = false;

  Future<Map<String, dynamic>?> getUser() async {
    String? userJson = await SecureStorageService().read('user');
    if (userJson == null) return null;
    Map<String, dynamic> userMap = jsonDecode(userJson);
    return userMap;
  }

  Future<void> checkEligibility() async {
    _isLoading = true;
    try {
      final user = await getUser();
      final (response, errors) = await LoanApplicationService()
          .checkEligibility(
            customerId: user?['id'] ?? "",
            productId: widget.productId,
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
          eligibility = responseInfo ?? {};
          eligibilityChecks = List<Map<String, dynamic>>.from(
            responseInfo['checks'] ?? {},
          );
        });
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    checkEligibility();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context),

          // 1. DYNAMIC LIMIT HERO
          SliverToBoxAdapter(child: _buildLimitCapacityHeader()),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                24,
                12,
                24,
                0,
              ), // 32px top spacing down from the hero card
              child: Text(
                "ELIGIBILITY CHECKLIST",
                style: TextStyle(
                  color: const Color(0xFF0A2351).withValues(
                    alpha: 0.5,
                  ), // Matches your primary deep blue with a subtle label opacity
                  fontWeight: FontWeight.w900,
                  fontSize: 11,
                  letterSpacing: 1.3,
                ),
              ),
            ),
          ),

          // 2. SACCO RULES CHECKLIST
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            sliver: _isLoading
                ? _buildSaccoChecksSkeleton()
                : SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final check = eligibilityChecks[index];
                      return _buildSaccoCheck(
                        check,
                        isWarning: check['isWarning'] ?? false,
                      );
                    }, childCount: eligibilityChecks.length),
                  ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
      bottomSheet: _buildEligibilityActionDock(
        isQualified: eligibility['is_eligible'] ?? false,
      ),
    );
  }

  Widget _buildSaccoChecksSkeleton() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade200,
            highlightColor: Colors.grey.shade50,
            period: const Duration(milliseconds: 1200),
            child: _buildSaccoCheckSkeletonItem(),
          );
        },
        childCount: 6, // Renders an optimized number of list placeholders
      ),
    );
  }

  Widget _buildSaccoCheckSkeletonItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F4F8), width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. LEFT COLUMN: Circular Icon Placeholder (Matches size 38)
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),

          // 2. RIGHT COLUMN: Content Text Lines Block
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Metadata Header Alignment Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Formatted Rule Title Line Placeholder
                    Container(
                      width: 140,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Status Badge Text Line Placeholder
                    Container(
                      width: 45,
                      height: 9,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // 3. Multi-Line Rule Description Placeholders
                Container(
                  width: double.infinity,
                  height: 11,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 180, // Shorter secondary trailing line mimicry
                  height: 11,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      backgroundColor: const Color(0xFFF1F5F9).withValues(alpha: 0.9),
      elevation: 0,
      centerTitle: true,
      leadingWidth: 64,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Loan Application",
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
                "LOAN ELIGIBILITY",
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
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(
              CupertinoIcons.back,
              size: 18,
              color: AnansiColors.darkBlue,
            ),
            onPressed: () => Navigator.pop(context),
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
                  CupertinoIcons.question_circle,
                  size: 18,
                  color: AnansiColors.darkBlue,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HelpSupport(),
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

  // --- THE LIMIT HERO (The SACCO Multiplier View) ---
  Widget _buildLimitCapacityHeader() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFF0A2351),
        borderRadius: BorderRadius.circular(35),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0A2351), Color(0xFF1B3C73)],
        ),
      ),
      child: Column(
        children: [
          const Text(
            "YOUR BORROWING CAPACITY",
            style: TextStyle(
              color: Color(0xFF17C6C6),
              fontWeight: FontWeight.w900,
              fontSize: 10,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            formatAmount(eligibility['limit'] ?? 0),
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Based on 3x Deposit Multiplier",
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          const Divider(color: Colors.white10),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _headerStat(
                "Total Deposits",
                formatAmount(eligibility['total_savings'] ?? 0),
              ),
              Container(width: 1, height: 30, color: Colors.white10),
              _headerStat(
                "Share Capital",
                formatAmount(eligibility['total_shares'] ?? 0),
              ),
              Container(width: 1, height: 30, color: Colors.white10),
              _headerStat("Multiplier", "N/A"),
            ],
          ),
        ],
      ),
    );
  }

  // --- THE SACCO CHECK COMPONENT ---
  Widget _buildSaccoCheck(
    Map<String, dynamic> check, {
    bool isWarning = false,
  }) {
    // 1. Extract values safely from JSON structure
    final String rawRule = check['rule'] ?? 'unknown_rule';
    final String description =
        check['description'] ?? 'No description provided';
    final bool isMet = check['passed'] ?? false;

    final String formattedTitle = rawRule
        .split('_')
        .map(
          (word) => word.isNotEmpty
              ? '${word[0].toUpperCase()}${word.substring(1)}'
              : '',
        )
        .join(' ');

    // 3. Derive runtime status text based on the rule evaluation
    final String statusText = isMet
        ? "PASSED"
        : (isWarning ? "WARNING" : "FAILED");

    // 4. Determine thematic accent colors
    Color iconColor = isMet
        ? const Color(0xFF17C6C6)
        : (isWarning ? Colors.orange : Colors.orange);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F4F8), width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circular Icon Indicator Frame
          _buildCircularIcon(
            isMet
                ? CupertinoIcons.checkmark_seal_fill
                : (isWarning
                      ? CupertinoIcons.exclamationmark_triangle_fill
                      : CupertinoIcons
                            .clear_circled), // Swapped plain circle for clear_circled on failure
            iconColor,
          ),
          const SizedBox(width: 16),

          // Metadata text run lengths
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        formattedTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0A2351),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      statusText,
                      style: TextStyle(
                        color: iconColor,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 11,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularIcon(IconData icon, Color color, {double size = 38}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.15), width: 1),
      ),
      child: Center(
        child: Icon(icon, size: size * 0.45, color: color),
      ),
    );
  }

  Widget _headerStat(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.4),
            fontSize: 9,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildEligibilityActionDock({required bool isQualified}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
      ),
      child: ElevatedButton(
        onPressed: isQualified
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddLoanDetails(productId: widget.productId),
                  ),
                );
              }
            : null, // Disabled if not qualified
        style: ElevatedButton.styleFrom(
          backgroundColor: isQualified
              ? const Color(0xFF0A2351)
              : Colors.grey.shade300,
          minimumSize: const Size(double.infinity, 64),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        child: Text(
          isQualified ? "PROCEED TO APPLICATION" : "NOT ELIGIBLE YET",
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}

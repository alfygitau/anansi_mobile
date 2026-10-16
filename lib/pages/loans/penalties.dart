import 'package:app_anansi_mobile/helpers/format_amount.dart';
import 'package:app_anansi_mobile/helpers/format_time.dart';
import 'package:app_anansi_mobile/pages/help&support/help_support.dart';
import 'package:app_anansi_mobile/services/error_service.dart';
import 'package:app_anansi_mobile/services/loan_service.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoanPenalties extends StatefulWidget {
  final String loanId;
  const LoanPenalties({super.key, required this.loanId});

  @override
  State<LoanPenalties> createState() => _LoanPenaltiesState();
}

class _LoanPenaltiesState extends State<LoanPenalties> {
  List<Map<String, dynamic>> penalties = [];
  bool _isLoading = false;

  Future<void> getLoanPenalties() async {
    setState(() => _isLoading = true);
    try {
      final (response, errors) = await LoanService().getLoanPenalties(
        loanId: widget.loanId,
      );
      if (errors != null) {
        if (mounted) {
          ErrorService.showActionableError(
            context,
            title: errors[0],
            message: errors[1],
          );
        }
      } else if (response != null) {
        final responseInfo = response.data['data'];
        setState(() {
          penalties = List<Map<String, dynamic>>.from(responseInfo ?? []);
        });
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    getLoanPenalties();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(left: 16, top: 10, bottom: 5),
              child: Text(
                "DEFAULT & PENALTY ASSESSMENTS",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF94A3B8),
                  letterSpacing: 1.1,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: _isLoading
                ? _buildPenaltiesSkeletonList()
                : penalties.isNotEmpty
                ? SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final Map<String, dynamic> item = penalties[index];
                      final double amount =
                          double.tryParse(item['amount']?.toString() ?? '0') ??
                          0.0;
                      final bool isWaived = item['is_waived'] ?? false;
                      final bool isReversed = item['is_reversed'] ?? false;
                      final int daysOverdue =
                          int.tryParse(
                            item['days_overdue']?.toString() ?? '0',
                          ) ??
                          0;

                      return _buildPenaltyCard(
                        amount: formatAmount(amount),
                        reason:
                            item['reason']?.toString() ??
                            "Loan Repayment Penalty",
                        penaltyType:
                            item['penalty_type']?.toString() ??
                            "Default Charge",
                        daysOverdue: daysOverdue,
                        isWaived: isWaived,
                        isReversed: isReversed,
                        date: item['created_at'] != null
                            ? formatPostgresDateWithTime(item['created_at'])
                            : (item['penalty_date']?.toString() ?? "N/A"),
                      );
                    }, childCount: penalties.length),
                  )
                : _buildEmptyState(
                    title: "No Penalties Applied",
                    description:
                        "This loan is in good standing. No default charges, late fees, or overdue penalties are linked to this facility.",
                    icon: CupertinoIcons.shield_lefthalf_fill,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      backgroundColor: ThemeColors.background.withValues(alpha: 0.95),
      elevation: 0,
      centerTitle: true,
      title: Column(
        children: [
          const Text(
            "Loans",
            style: TextStyle(
              color: AnansiColors.darkBlue,
              fontWeight: FontWeight.w900,
              fontSize: 15,
            ),
          ),
          Text(
            "LOAN PENALTIES",
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
      leading: _buildCircleBackBtn(),
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

  Widget _buildCircleBackBtn() {
    return Center(
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade200),
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
    );
  }

  Widget _buildPenaltyCard({
    required String amount,
    required String reason,
    required String penaltyType,
    required int daysOverdue,
    required String date,
    bool isWaived = false,
    bool isReversed = false,
  }) {
    Color statusColor;
    IconData cardIcon;
    String statusBadgeText;
    Color badgeBg;
    Color badgeTextColor;

    if (isReversed) {
      statusColor = const Color(0xFF64748B);
      cardIcon = CupertinoIcons.arrow_counterclockwise_circle_fill;
      statusBadgeText = "REVERSED";
      badgeBg = const Color(0xFFF1F5F9);
      badgeTextColor = const Color(0xFF475569);
    } else if (isWaived) {
      statusColor = const Color(0xFF059669);
      cardIcon = CupertinoIcons.checkmark_shield_fill;
      statusBadgeText = "WAIVED";
      badgeBg = const Color(0xFFECFDF5);
      badgeTextColor = const Color(0xFF047857);
    } else {
      statusColor = const Color(0xFFDC2626); // Crimson
      cardIcon = Icons.gavel_rounded;
      statusBadgeText = "NOT PAID";
      badgeBg = const Color(0xFFFEF2F2);
      badgeTextColor = const Color(0xFFDC2626);
    }

    final bool isInactive = isWaived || isReversed;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isInactive ? const Color(0xFFF1F5F9) : const Color(0xFFFEE2E2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.015),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. Left Icon Container
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(cardIcon, color: statusColor, size: 22),
            ),
            const SizedBox(width: 14),

            // 2. Right Content Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top Row: Amount & Status Badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "KES $amount",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          color: isInactive
                              ? Colors.grey
                              : AnansiColors.darkBlue,
                          decoration: isInactive
                              ? TextDecoration.lineThrough
                              : null,
                          letterSpacing: -0.4,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: badgeBg,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          statusBadgeText,
                          style: TextStyle(
                            color: badgeTextColor,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Middle: Reason Text (wraps naturally)
                  Text(
                    reason,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      fontWeight: FontWeight.w600,
                      color: isInactive
                          ? Colors.grey.shade500
                          : const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Bottom: Date and Overdue Tag
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        date,
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (daysOverdue > 0 && !isInactive)
                        Text(
                          "$daysOverdue days overdue",
                          style: const TextStyle(
                            color: Color(0xFFB45309),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required String title,
    required String description,
    required IconData icon,
  }) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 7, 4, 24),
        child: Container(
          width: double.infinity,
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: ThemeColors.background,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFF1F5F9),
                    width: 1.5,
                  ),
                ),
                child: Icon(icon, size: 44, color: const Color(0xFF10B981)),
              ),
              const SizedBox(height: 24),
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

  Widget _buildPenaltiesSkeletonList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade200,
          highlightColor: Colors.grey.shade50,
          period: const Duration(milliseconds: 1200),
          child: Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 110,
                        height: 11,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 4),
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
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 70,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 45,
                      height: 16,
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
        );
      }, childCount: 6),
    );
  }
}

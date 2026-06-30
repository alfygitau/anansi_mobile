import 'package:app_anansi_mobile/helpers/format_amount.dart';
import 'package:app_anansi_mobile/helpers/format_time.dart';
import 'package:app_anansi_mobile/services/error_service.dart';
import 'package:app_anansi_mobile/services/loan_service.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoanHistory extends StatefulWidget {
  final String loanId;
  const LoanHistory({super.key, required this.loanId});

  @override
  State<LoanHistory> createState() => _LoanHistoryState();
}

class _LoanHistoryState extends State<LoanHistory> {
  List<Map<String, dynamic>> loanHistory = [];
  bool _isLoading = false;

  Future<void> getLoanTransactions() async {
    _isLoading = true;
    try {
      final (response, errors) = await LoanService().getLoanTransactions(
        loanId: widget.loanId,
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
          loanHistory = List<Map<String, dynamic>>.from(responseInfo ?? []);
        });
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    getLoanTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 24, top: 8),
              child: Text(
                "RECENT LOAN ACTIVITY",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF94A3B8),
                  letterSpacing: 1.1,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            sliver: _isLoading
                ? _buildTransactionsSkeletonList()
                : loanHistory.isNotEmpty
                ? SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final Map<String, dynamic> item = loanHistory[index];
                        final double amountPaid =
                            double.tryParse(
                              item['amount_paid']?.toString() ?? '0',
                            ) ??
                            0.0;
                        final double penaltyPaid =
                            double.tryParse(
                              item['penalty_paid']?.toString() ?? '0',
                            ) ??
                            0.0;

                        return _buildTransactionCard(
                          amount: formatAmount(amountPaid),
                          ref: item['transaction_ref']?.toString() ?? "N/A",
                          mode: item['payment_mode']?.toString() ?? "MPESA",
                          isLate: penaltyPaid > 0,
                          isReversed: item['is_reversed'] ?? false,
                          principal: item['principal_paid'] != null
                              ? formatAmount(
                                  double.tryParse(
                                        item['principal_paid'].toString(),
                                      ) ??
                                      0.0,
                                )
                              : null,
                          interest: item['interest_paid'] != null
                              ? formatAmount(
                                  double.tryParse(
                                        item['interest_paid'].toString(),
                                      ) ??
                                      0.0,
                                )
                              : null,
                          date: item['created_at'] != null
                              ? formatPostgresDateWithTime(item['created_at'])
                              : (item['payment_date']?.toString() ?? "N/A"),
                        );
                      },
                      childCount: loanHistory
                          .length, // Driven dynamically by the length of your state array
                    ),
                  )
                : _buildEmptyState(
                    title: "Transaction History Empty",
                    description:
                        "There are no payment clearing logs or financial allocations tied to this specific account. If you just made a repayment, please wait a brief moment for ledger reconciliation.",
                    icon: CupertinoIcons
                        .square_stack_3d_up_slash, // Beautiful abstract empty state icon
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      backgroundColor: const Color(0xFFF8FAFC).withValues(alpha: 0.95),
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
            "LOAN TRANSACTIONS",
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

  Widget _buildTransactionCard({
    required String amount,
    required String date,
    required String ref,
    required String mode,
    bool isLate = false,
    bool isReversed = false,
    String? principal,
    String? interest,
  }) {
    // 1. Dynamic Asset Mapping based on Payment Mode
    Color modeColor;
    IconData modeIcon;
    String displayTitle;

    switch (mode.toUpperCase().trim()) {
      case 'MPESA':
        modeColor = const Color(0xFF4CAF50); // M-Pesa Safari Green
        modeIcon = Icons.phone_android_rounded;
        displayTitle = "M-PESA Repayment";
        break;
      case 'BANK':
      case 'TRANSFER':
        modeColor = const Color(0xFF3B82F6); // Secure Blue
        modeIcon = CupertinoIcons.arrow_right_arrow_left_square_fill;
        displayTitle = "Bank Transfer";
        break;
      default:
        modeColor = const Color(0xFF64748B); // Slate Neutral
        modeIcon = Icons.account_balance_wallet_rounded;
        displayTitle = "$mode Repayment";
    }

    // Override visuals if the transaction was completely reversed
    if (isReversed) {
      modeColor = const Color(0xFFEF4444); // Alert Rose
      modeIcon = CupertinoIcons.arrow_counterclockwise_circle_fill;
      displayTitle = "$displayTitle (Reversed)";
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isReversed ? const Color(0xFFFEE2E2) : const Color(0xFFF1F5F9),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Hook into expanded transaction allocation lightboxes if needed
          },
          borderRadius: BorderRadius.circular(24),
          splashColor: modeColor.withValues(alpha: 0.04),
          highlightColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left side: Colored Icon Round Wrapper
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: modeColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(modeIcon, color: modeColor, size: 22),
                ),
                const SizedBox(width: 14),

                // Center Section: Meta Specifications
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayTitle,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: isReversed
                              ? Colors.grey.shade500
                              : AnansiColors.darkBlue,
                        ),
                      ),
                      const SizedBox(height: 3),

                      // Transaction Reference Line
                      Text(
                        "Ref: ${ref.toUpperCase()}",
                        style: const TextStyle(
                          fontFamily:
                              'monospace', // Gives reference codes a distinct tracking aesthetic
                          color: Color(0xFF94A3B8),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      // Timestamp Label
                      Text(
                        date,
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Right Section: Currencies & Status Pillars
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "KES $amount",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        color: isReversed ? Colors.grey : AnansiColors.darkBlue,
                        // Striking visual line-through indicator for reversals
                        decoration: isReversed
                            ? TextDecoration.lineThrough
                            : null,
                        letterSpacing: -0.3,
                      ),
                    ),

                    // Dynamic Badge Placement Stack
                    if (isReversed)
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          "REVERSED",
                          style: TextStyle(
                            color: Color(0xFFEF4444),
                            fontSize: 8,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.4,
                          ),
                        ),
                      )
                    else if (isLate)
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF7ED),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          "LATE",
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 8,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
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
      hasScrollBody:
          false, // Allows content to scale to viewport size without breaking scroll
      child: Padding(
        // 4 horizontal + 20 from parent SliverPadding = 24 total padding alignment
        padding: const EdgeInsets.fromLTRB(4, 16, 4, 24),
        child: Container(
          width: double.infinity, // Forces full horizontal growth
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
                .center, // Centers the content vertically in the expanded card
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Muted Circular Icon Container Base
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

              // Empty State Action Title
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

              // Informative Description Body Text
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

  Widget _buildTransactionsSkeletonList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade200,
            highlightColor: Colors.grey.shade50,
            period: const Duration(milliseconds: 1200),
            child: _buildTransactionCardSkeleton(),
          );
        },
        childCount: 8, // Renders an initial list block profile of 6 lines
      ),
    );
  }

  Widget _buildTransactionCardSkeleton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          // 1. M-PESA Themed Icon Round Box Template
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),

          // 2. Transaction String Details Columns
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Placeholder ("M-PESA Repayment")
                Container(
                  width: 130,
                  height: 15,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 6),
                // Reference ID Placeholder
                Container(
                  width: 100,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 4),
                // DateTime Timestamp Line
                Container(
                  width: 85,
                  height: 11,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),

          // 3. Amount Field Placeholder
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 75,
                height: 15,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              // Leave a tiny matching bottom offset space equivalent to status badges
              const SizedBox(height: 16),
            ],
          ),
        ],
      ),
    );
  }
}

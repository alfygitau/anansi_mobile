import 'package:app_anansi_mobile/helpers/format_amount.dart';
import 'package:app_anansi_mobile/helpers/format_short_date.dart';
import 'package:app_anansi_mobile/pages/help&support/help_support.dart';
import 'package:app_anansi_mobile/pages/loan-products/loan_products.dart';
import 'package:app_anansi_mobile/pages/loan-statements/statements.dart';
import 'package:app_anansi_mobile/pages/loans/loan_history.dart';
import 'package:app_anansi_mobile/services/error_service.dart';
import 'package:app_anansi_mobile/services/loan_service.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoanDetails extends StatefulWidget {
  final String loanId;
  const LoanDetails({super.key, required this.loanId});

  @override
  State<LoanDetails> createState() => _LoanDetailsState();
}

class _LoanDetailsState extends State<LoanDetails> {
  Map<String, dynamic> loan = {};
  bool _isLoading = false;

  Future<void> getLoan() async {
    _isLoading = true;
    try {
      final (response, errors) = await LoanService().getLoan(
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
          loan = responseInfo ?? {};
        });
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    getLoan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: _isLoading
                ? _buildTopMasterCardSkeleton()
                : _buildTopMasterCard(),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: _buildQuickActions(),
            ),
          ),
          if (_isLoading || loan['next_payment'] != null) ...[
            // 1. Header Section Title
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: _sectionTitle("Next Repayment Detail"),
              ),
            ),

            // 2. Next Repayment Card / Skeleton
            SliverToBoxAdapter(
              child: _isLoading
                  ? _buildNextPaymentCardSkeleton()
                  : _buildNextPaymentCard(),
            ),
          ],
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 8),
              child: _sectionTitle("Amortization Schedule"),
            ),
          ),
          _isLoading
              ? _buildSliverTimelineScheduleSkeleton()
              : _buildSliverTimelineSchedule(),
          const SliverPadding(padding: EdgeInsets.only(bottom: 140)),
        ],
      ),
      bottomSheet: _buildActionDock(),
    );
  }

  // --- NEW UPPER DESIGN: High-Impact Card ---
  Widget _buildTopMasterCardSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        padding: const EdgeInsets.all(28),
        height: 250, // Matches approximate height of master card
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35),
        ),
      ),
    );
  }

  // --- 2. NEXT PAYMENT BREAKDOWN SKELETON ---
  Widget _buildNextPaymentCardSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.all(24),
          height: 160, // Matches approximate height of breaking calculations
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
    );
  }

  // --- 3. AMORTIZATION TIMELINE SKELETON ---
  Widget _buildSliverTimelineScheduleSkeleton() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Shimmer.fromColors(
              baseColor: Colors.grey.shade200,
              highlightColor: Colors.grey.shade50,
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(18),
                height: 76, // Matches exact tile height profile
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            );
          },
          childCount: 4, // Renders a clean structural stack of placeholders
        ),
      ),
    );
  }

  Widget _buildAppBar() {
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
            "Loan Details",
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
                "EMERGENCY FUND LOAN",
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

  Widget _buildQuickActions() {
    return Row(
      children: [
        _buildActionItem(
          label: "Transactions",
          icon: Icons.sync,
          backgroundColor: const Color(0xFF17C6C6),
          contentColor: Colors.white,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoanHistory(loanId: loan['id'] ?? ""),
              ),
            );
          },
        ),
        const SizedBox(width: 12),
        _buildActionItem(
          label: "Statements",
          icon: CupertinoIcons.doc_text_fill,
          backgroundColor: Colors.white,
          contentColor: AnansiColors.darkBlue,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoanStatements()),
            );
          },
        ),
        const SizedBox(width: 12),
        _buildActionItem(
          label: "Products",
          icon: Icons.grid_view_rounded,
          backgroundColor: Colors.white,
          contentColor: AnansiColors.darkBlue,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoanProducts()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionItem({
    required String label,
    required IconData icon,
    required Color backgroundColor,
    required Color contentColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(24),
            border: backgroundColor == Colors.white
                ? Border.all(color: Colors.black.withValues(alpha: 0.05))
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, color: contentColor, size: 24),
              const SizedBox(height: 8),
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  color: contentColor,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- NEW CONTENT: Health & Progress ---
  Widget _buildTopMasterCard() {
    // 1. Extract and normalize all dynamic API values safely to Strings up front
    final String productName =
        loan['loan_product']?['product_name']?.toString() ?? "";
    final String loanStatus = loan['loan_status']?.toString() ?? "Pending";
    final String loanCode = loan['loan_code']?.toString() ?? "";
    final String loanPeriod = loan['loan_period']?.toString() ?? "";
    final String progressPercent =
        loan['repayment_progress_percent']?.toString() ?? "0";

    double progressFraction = 0.0;
    if (loan['repayment_progress_percent'] != null) {
      progressFraction =
          (double.tryParse(loan['repayment_progress_percent'].toString()) ??
              0.0) /
          100.0;
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0A2351), Color(0xFF152E5F)],
        ),
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0A2351).withValues(alpha: 0.15),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // PRODUCT NAME & STATUS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                productName,
                style: const TextStyle(
                  color: Color(0xFF17C6C6), // Anansi Teal
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.8,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  loanStatus,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "CURRENT BALANCE",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    // Handles case where loan_Balance might be returned as an int, double, or String
                    formatAmount(
                      loan['loan_Balance'] is String
                          ? loan['loan_Balance']
                          : loan['loan_Balance'] ?? 0,
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  CupertinoIcons.graph_square,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Repayment Progress",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "$progressPercent%",
                style: const TextStyle(
                  color: Color(0xFF17C6C6),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progressFraction.clamp(
                0.0,
                1.0,
              ), // Dynamically safely driven now!
              minHeight: 8,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              valueColor: const AlwaysStoppedAnimation(Color(0xFF17C6C6)),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white10),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _cardMiniDetail("Loan ID", loanCode),
              _cardMiniDetail(
                "Interest",
                "${double.parse((loan['loan_interest_per'] ?? 0).toString()).toStringAsFixed(1)}%",
              ),
              _cardMiniDetail("Period", "$loanPeriod months"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _cardMiniDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.4),
            fontSize: 9,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  // --- NEW CONTENT: Detailed Next Payment ---
  Widget _buildNextPaymentCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF17C6C6).withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFF17C6C6).withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          children: [
            _paymentRow(
              "Total Amount",
              formatAmount(loan['next_payment']['amount_due'] ?? 0),
            ),
            _paymentRow(
              "Interest Charged",
              formatAmount(loan['next_payment']['interest_due'] ?? 0),
            ),
            _paymentRow("Service Fee", formatAmount(0)),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1, color: Colors.black12),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Due (${formatShortDate(loan['next_payment']['due_date'])})",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                Text(
                  formatAmount(loan['next_payment']['balance_due'] ?? 0),
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.teal.shade900,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- IMPROVED SCHEDULE: Vertical Timeline ---
  Widget _buildSliverTimelineSchedule() {
    /// Dynamic math rule to calculate standard English ordinals (1st, 2nd, 3rd, 11th...)
    String getOrdinalValue(int number) {
      if (number >= 11 && number <= 13) {
        return '${number}th';
      }
      switch (number % 10) {
        case 1:
          return '${number}st';
        case 2:
          return '${number}nd';
        case 3:
          return '${number}rd';
        default:
          return '${number}th';
      }
    }

    /// Formats a raw ISO date string ("2026-07-17") to a presentation format ("17 Jul 2026")
    String formatDueDateString(String? dateStr) {
      if (dateStr == null || dateStr.isEmpty) return "N/A";
      try {
        final DateTime parsedDate = DateTime.parse(dateStr);
        final List<String> months = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ];
        return "${parsedDate.day} ${months[parsedDate.month - 1]} ${parsedDate.year}";
      } catch (_) {
        return dateStr; // Safe fallback to raw string from database if parsing breaks
      }
    }

    // 1. Extract the schedules list safely from your loan payload map
    final List<dynamic> schedules = loan['schedules'] is List
        ? loan['schedules']
        : [];

    // Fallback empty view if no schedule items have cleared yet
    if (schedules.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final Map<String, dynamic> schedule = schedules[index] ?? {};

            // 2. Drive the state from your true payload status string flag
            final String statusStr =
                schedule['status']?.toString().toLowerCase() ?? "pending";
            final bool isPaid = statusStr == 'paid' || statusStr == 'success';

            // 3. Dynamic Ordinal Generator (handles any number of items up to infinity safely)
            final int installmentNum =
                int.tryParse(
                  schedule['installment_number']?.toString() ?? '',
                ) ??
                (index + 1);
            final String installmentLabel =
                "${getOrdinalValue(installmentNum)} Installment";

            // 4. Safe parse dynamic amount metrics
            final double totalDueAmount =
                double.tryParse(schedule['total_due']?.toString() ?? '0') ??
                0.0;

            // 5. Raw Timestamp Parser to formatted UI presentation
            final String cleanDueDate = formatDueDateString(
              schedule['due_date']?.toString(),
            );

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Opacity(
                opacity: isPaid ? 0.6 : 1.0,
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isPaid
                          ? Colors.transparent
                          : const Color(0xFFF1F4F8),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Status Circle Indicator
                      _buildStatusMarker(isPaid),
                      const SizedBox(width: 16),

                      // Details Column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              installmentLabel,
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 14,
                                decoration: isPaid
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: isPaid
                                    ? Colors.grey
                                    : const Color(0xFF0A2351),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Due: $cleanDueDate",
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Amount / Verification Badge Context
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            formatAmount(totalDueAmount),
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                              color: isPaid ? Colors.grey : Colors.black,
                            ),
                          ),
                          if (isPaid)
                            const Text(
                              "SUCCESS",
                              style: TextStyle(
                                color: Color(0xFF17C6C6),
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          childCount: schedules
              .length, // Driven directly by the backend response list size
        ),
      ),
    );
  }

  Widget _buildStatusMarker(bool isPaid) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isPaid
            ? const Color(0xFF17C6C6).withValues(alpha: 0.1)
            : const Color(0xFFF8FAFC),
        shape: BoxShape.circle,
      ),
      child: Icon(
        isPaid ? CupertinoIcons.checkmark_seal_fill : CupertinoIcons.calendar,
        size: 16,
        color: isPaid ? const Color(0xFF17C6C6) : Colors.grey.shade400,
      ),
    );
  }

  Widget _paymentRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        color: Colors.blueGrey.shade800,
        fontWeight: FontWeight.w900,
        fontSize: 11,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildActionDock() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0A2351),
          minimumSize: const Size(double.infinity, 64),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        child: const Text(
          "REPAY LOAN",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}

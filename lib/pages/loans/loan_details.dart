import 'package:app_anansi_mobile/pages/help&support/help_support.dart';
import 'package:app_anansi_mobile/pages/loan_products/loan_products.dart';
import 'package:app_anansi_mobile/pages/loans/loan_history.dart';
import 'package:app_anansi_mobile/pages/statements/statements.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoanDetails extends StatefulWidget {
  const LoanDetails({super.key});

  @override
  State<LoanDetails> createState() => _LoanDetailsState();
}

class _LoanDetailsState extends State<LoanDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(child: _buildTopMasterCard()),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: _buildQuickActions(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: _sectionTitle("Next Repayment Detail"),
            ),
          ),
          SliverToBoxAdapter(child: _buildNextPaymentCard()),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 8),
              child: _sectionTitle("Amortization Schedule"),
            ),
          ),
          _buildSliverTimelineSchedule(),
          const SliverPadding(padding: EdgeInsets.only(bottom: 140)),
        ],
      ),
      bottomSheet: _buildActionDock(),
    );
  }

  // --- NEW UPPER DESIGN: High-Impact Card ---
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
              MaterialPageRoute(builder: (context) => LoanHistory()),
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
              MaterialPageRoute(builder: (context) => Statements()),
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
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        // Soft gradient for a more "premium" depth
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
                "EMERGENCY FUND LOAN", // Product Name
                style: TextStyle(
                  color: const Color(0xFF17C6C6), // Anansi Teal
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
                child: const Text(
                  "ACTIVE",
                  style: TextStyle(
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
                  const Text(
                    "KES 142,500.00",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              // Floating Graph Icon
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
                "65%",
                style: TextStyle(
                  color: const Color(0xFF17C6C6),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 0.65,
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
              _cardMiniDetail("Loan ID", "#L-9902"),
              _cardMiniDetail("Interest", "1.5%"),
              _cardMiniDetail("Period", "6 Months"),
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
            _paymentRow("Principal Amount", "KES 20,000.00"),
            _paymentRow("Interest Charged", "KES 3,500.00"),
            _paymentRow("Service Fee", "KES 1,000.00"),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1, color: Colors.black12),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Due (15 May)",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                Text(
                  "KES 24,500.00",
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
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          // Logic for paid state
          bool isPaid = index < 2; // Example: first two are paid

          // Dynamic Naming Logic (Ordinal)
          final List<String> ordinals = [
            "1st",
            "2nd",
            "3rd",
            "4th",
            "5th",
            "6th",
          ];
          String installmentLabel = "${ordinals[index]} Installment";

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            // If paid, we can slightly lower the opacity of the whole card
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
                    // 1. Status Indicator (Instead of a line, we use a simple Dot/Check)
                    _buildStatusMarker(isPaid),
                    const SizedBox(width: 16),

                    // 2. Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            installmentLabel,
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                              // Strikethrough for paid items
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
                            "Due: 15 ${['May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct'][index]} 2026",
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 3. Amount or Paid Badge
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "KES 24,500",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                            color: isPaid ? Colors.grey : Colors.black,
                          ),
                        ),
                        if (isPaid)
                          Text(
                            "SUCCESS",
                            style: TextStyle(
                              color: const Color(0xFF17C6C6),
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
        }, childCount: 6),
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

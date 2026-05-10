import 'package:app_anansi_mobile/pages/apply-loan/add_loan_details.dart';
import 'package:app_anansi_mobile/pages/help&support/help_support.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoanEligibility extends StatefulWidget {
  const LoanEligibility({super.key});

  @override
  State<LoanEligibility> createState() => _LoanEligibilityState();
}

class _LoanEligibilityState extends State<LoanEligibility> {
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

          // 2. SACCO RULES CHECKLIST
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _sectionTitle("Membership Qualification"),
                const SizedBox(height: 20),

                _buildSaccoCheck(
                  title: "Membership Tenure",
                  desc: "Minimum 6 months active membership required.",
                  status: "Active 8 Months",
                  isMet: true,
                ),
                _buildSaccoCheck(
                  title: "Share Capital",
                  desc: "Minimum share capital of KES 20,000 required.",
                  status: "KES 25,000",
                  isMet: true,
                ),
                _buildSaccoCheck(
                  title: "Savings Multiplier",
                  desc: "Your limit is 3x your current deposits.",
                  status: "KES 150,000 Deposits",
                  isMet: true,
                ),
                _buildSaccoCheck(
                  title: "Existing Obligations",
                  desc: "Must not have an active loan of the same type.",
                  status: "1 Active Loan Found",
                  isMet: false,
                  isWarning: true,
                ),
                _buildSaccoCheck(
                  title: "Guarantor Availability",
                  desc:
                      "Ability to provide at least 3 active members as guarantors.",
                  status: "Pending Check",
                  isMet: false,
                  isWarning: true
                ),

                const SizedBox(height: 120),
              ]),
            ),
          ),
        ],
      ),
      bottomSheet: _buildEligibilityActionDock(isQualified: true),
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
          const Text(
            "KES 450,000.00",
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
              color: Colors.white.withOpacity(0.5),
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
              _headerStat("Total Deposits", "KES 150k"),
              Container(width: 1, height: 30, color: Colors.white10),
              _headerStat("Share Capital", "KES 25k"),
              Container(width: 1, height: 30, color: Colors.white10),
              _headerStat("Multiplier", "3.0x"),
            ],
          ),
        ],
      ),
    );
  }

  // --- THE SACCO CHECK COMPONENT ---
  Widget _buildSaccoCheck({
    required String title,
    required String desc,
    required String status,
    required bool isMet,
    bool isWarning = false,
  }) {
    Color iconColor = isMet
        ? const Color(0xFF17C6C6)
        : (isWarning ? Colors.orange : Colors.grey.shade400);

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
          _buildCircularIcon(
            isMet
                ? CupertinoIcons.checkmark_seal_fill
                : (isWarning
                      ? CupertinoIcons.exclamationmark_triangle_fill
                      : CupertinoIcons.circle),
            iconColor,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0A2351),
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      status.toUpperCase(),
                      style: TextStyle(
                        color: iconColor,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
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
        // Soft semi-transparent background of the primary color
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        // A very thin border helps define the shape on white backgrounds
        border: Border.all(color: color.withValues(alpha: 0.15), width: 1),
      ),
      child: Center(
        child: Icon(
          icon,
          size: size * 0.45, // Proportional icon sizing
          color: color,
        ),
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
                  MaterialPageRoute(builder: (context) => AddLoanDetails()),
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

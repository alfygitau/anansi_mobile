import 'package:app_anansi_mobile/pages/membership/review_membership.dart';
import 'package:app_anansi_mobile/pages/membership/shares_savings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterInvest extends StatefulWidget {
  final String mobileNumber;
  const RegisterInvest({super.key, required this.mobileNumber});

  @override
  State<RegisterInvest> createState() => _RegisterInvestState();
}

class _RegisterInvestState extends State<RegisterInvest> {
  Future<void> _toBuyShares(BuildContext context) async {
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              SharesSavings(mobileNumber: widget.mobileNumber),
        ),
      );
    }
  }

  Future<void> _toRegisterOnly(BuildContext context) async {
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReviewMembership(
            phoneNumber: widget.mobileNumber,
            savingsAmount: 0,
            sharesAmount: 0,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F8),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 10, 24, 150),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const Text(
                  "Maximize Your Entry",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0A2351),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Would you like to purchase shares and deposit savings now? Combining these payments reduces your total M-PESA transaction fees.",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 22),
                _buildValueCard(),
              ]),
            ),
          ),
        ],
      ),
      bottomSheet: _buildPersistentFooter(context),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: const Color(0xFFF1F4F8).withValues(alpha: 0.95),
      elevation: 0,
      centerTitle: true,
      leadingWidth: 64,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Setup Membership",
            style: TextStyle(
              color: Color(0xFF0A2351),
              fontWeight: FontWeight.w900,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            "MEMBERSHIP BENEFITS",
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 7,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
      leading: Center(
        child: _buildCircleIconButton(
          icon: CupertinoIcons.multiply,
          onTap: () => Navigator.pop(context),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: _buildCircleIconButton(
            icon: CupertinoIcons.question_circle,
            onTap: () {
              // Help logic
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCircleIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 18, color: const Color(0xFF0A2351)),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildValueCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0A2351).withValues(alpha: 0.06),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDetailedBenefitRow(
            icon: CupertinoIcons.arrow_2_circlepath,
            title: "Consolidated Fees",
            subtitle:
                "Save up to KES 150 in M-PESA charges by processing shares and savings in a single push.",
            badgeText: "SAVINGS",
            badgeColor: const Color(0xFF17C6C6),
          ),
          _buildCustomDivider(),
          _buildDetailedBenefitRow(
            icon: CupertinoIcons.chart_pie_fill,
            title: "Dividend Accrual",
            subtitle:
                "Your shares begin earning dividends the moment the transaction is verified.",
            badgeText: "EARNING",
            badgeColor: Colors.orange.shade400,
          ),
          _buildCustomDivider(),
          _buildDetailedBenefitRow(
            icon: CupertinoIcons.rocket_fill,
            title: "Multiplier Effect",
            subtitle:
                "Increase your loan limit by 3x. Your savings act as security for future credit.",
            badgeText: "BOOST",
            badgeColor: const Color(0xFF0A2351),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedBenefitRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required String badgeText,
    required Color badgeColor,
  }) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 22, color: badgeColor),
          ),
          const SizedBox(width: 16),
          // Content
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
                        fontSize: 15,
                        letterSpacing: -0.3,
                      ),
                    ),
                    // Small "Micro-badge" for detail
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: badgeColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        badgeText,
                        style: TextStyle(
                          color: badgeColor,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                    height: 1.4,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomDivider() {
    return Divider(
      height: 1,
      indent: 80,
      endIndent: 20,
      color: const Color(0xFFF1F4F8),
    );
  }

  Widget _buildPersistentFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 30),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () => _toBuyShares(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A2351),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Text(
                "Buy Shares & Deposit Savings",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: OutlinedButton(
              onPressed: () => _toRegisterOnly(context),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                "No, Pay Registration Only",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

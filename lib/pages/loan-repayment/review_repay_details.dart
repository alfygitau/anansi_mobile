import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReviewRepayDetails extends StatefulWidget {
  final double amount;
  final String phoneNumber;

  const ReviewRepayDetails({
    super.key,
    required this.amount,
    required this.phoneNumber,
  });

  @override
  State<ReviewRepayDetails> createState() => _ReviewRepayDetailsState();
}

class _ReviewRepayDetailsState extends State<ReviewRepayDetails> {
  bool isProcessing = false;
  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormatter = NumberFormat.currency(
      symbol: "KES ",
      decimalDigits: 2,
    );
    final int currentYear = DateTime.now().year;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      bottomNavigationBar: _buildBottomActionButton(context),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 10, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Review Payment",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: AnansiColors.darkBlue,
                      letterSpacing: -0.6,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Verify the transaction details below.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Divider(color: Color(0xFFEAECEF), height: 1),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  width: double.infinity,
                  decoration: _cardDecoration(),
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 20,
                  ),
                  child: Column(
                    children: [
                      Text(
                        "TOTAL REPAYMENT",
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: Colors.grey.shade400,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currencyFormatter.format(widget.amount),
                        style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          color: AnansiColors.primary,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0, bottom: 10),
                  child: Text(
                    "TRANSACTION SUMMARY",
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey.shade400,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),

                Container(
                  decoration: _cardDecoration(),
                  child: Column(
                    children: [
                      _buildBreakdownRow(
                        icon: Icons.phone_android_rounded,
                        iconBg: const Color(0xFFE6F4EA),
                        iconColor: const Color(0xFF137333),
                        label: "Wallet Source",
                        value: widget.phoneNumber,
                        badgeLabel: "M-Pesa",
                        badgeBg: const Color(0xFFE6F4EA),
                        badgeText: const Color(0xFF137333),
                      ),
                      const Divider(
                        color: Color(0xFFF1F3F5),
                        height: 1,
                        thickness: 1,
                      ),
                      _buildBreakdownRow(
                        icon: Icons.numbers_rounded,
                        iconBg: const Color(0xFFE8F0FE),
                        iconColor: const Color(0xFF1A73E8),
                        label: "Loan Reference",
                        value: "LN-$currentYear-AX",
                        badgeLabel: "Facility",
                        badgeBg: const Color(0xFFE8F0FE),
                        badgeText: const Color(0xFF1A73E8),
                      ),
                      const Divider(
                        color: Color(0xFFF1F3F5),
                        height: 1,
                        thickness: 1,
                      ),
                      _buildBreakdownRow(
                        icon: Icons.auto_awesome_rounded,
                        iconBg: const Color(0xFFFEF7E0),
                        iconColor: const Color(0xFFB06000),
                        label: "Transaction Fee",
                        value: "Zero Charges",
                        badgeLabel: "Waived",
                        badgeBg: const Color(0xFFFEF7E0),
                        badgeText: const Color(0xFFB06000),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        "By clicking continue, an STK push will be sent to your device. Ensure you have the sufficient funds to complete the transaction.",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                          height: 1.5,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // --- COMPONENT MATRIX SPECIFIC METHOD BREAKDOWNS ---
  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      backgroundColor: const Color(0xFFF1F5F9).withValues(alpha: 0.9),
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      leadingWidth: 64,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Review Payment",
            style: TextStyle(
              color: AnansiColors.darkBlue,
              fontWeight: FontWeight.w900,
              fontSize: 15,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 2),
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
    );
  }

  Widget _buildBreakdownRow({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String label,
    required String value,
    required String badgeLabel,
    required Color badgeBg,
    required Color badgeText,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 18, color: iconColor),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label.toUpperCase(),
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey.shade400,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AnansiColors.darkBlue,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              badgeLabel.toUpperCase(),
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w800,
                color: badgeText,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        24,
        12,
        24,
        MediaQuery.paddingOf(context).bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade100, width: 1)),
      ),
      child: CupertinoButton(
        color: AnansiColors.darkBlue,
        disabledColor: AnansiColors.darkBlue.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        padding: const EdgeInsets.symmetric(vertical: 24),
        onPressed: isProcessing ? null : () {},
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: isProcessing
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator.adaptive(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text(
                  "Authorize & Pay Now",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: const Color(0xFFEAECEF), width: 1),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.012),
          blurRadius: 15,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }
}

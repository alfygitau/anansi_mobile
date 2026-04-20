import 'package:app_anansi_mobile/pages/membership/review_membership.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SharesSavings extends StatefulWidget {
  final String mobileNumber;
  const SharesSavings({super.key, required this.mobileNumber});

  @override
  SharesSavingsState createState() => SharesSavingsState();
}

class SharesSavingsState extends State<SharesSavings> {
  final TextEditingController _sharesController = TextEditingController(
    text: "0.00",
  );
  final TextEditingController _savingsController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final double sharePrice = 1000.0;

  Future<void> _toTransactionPage() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ReviewMembership(
            sharesAmount: 3000,
            savingsAmount: 2000,
            phoneNumber: "0769800600",
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
          _buildAppBar(),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 150),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                buildSectionHeader(
                  "ALLOCATE FUNDS",
                  subtitle:
                      "Beside registration, choose how much to save or invest in shares today.",
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: const Color(0xFFF1F4F8),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildInputField(
                        label: "Deposit Savings",
                        controller: _savingsController,
                        hint: "e.g 5000",
                        icon: Icons.account_balance_wallet_rounded,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(
                          color: Color(0xFFF1F4F8),
                          thickness: 1.5,
                        ),
                      ),
                      _buildInputField(
                        label: "Buy Shares",
                        controller: _amountController,
                        hint: "e.g 5000",
                        icon: Icons.insights_rounded,
                      ),
                      buildSharePreview(),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                buildSectionHeader("PAYMENT DETAILS"),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: const Color(0xFFF1F4F8),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildInputField(
                        label: "M-PESA Number",
                        controller: _mobileController,
                        hint: "07XX XXX XXX",
                        icon: Icons.phone_android_rounded,
                        isPhone: true,
                      ),
                      const SizedBox(height: 12),
                      buildRememberMeToggle(),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
                _buildSummaryFooterInfo(),
              ]),
            ),
          ),
        ],
      ),
      bottomSheet: _buildPersistentFooter(),
    );
  }

  Widget buildRememberMeToggle() {
    return Row(
      children: [
        Text(
          "You can invest with a different mobile number",
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        ),
      ],
    );
  }

  Widget buildSharePreview() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 4),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 14,
            color: Color(0xFF17C6C6),
          ),
          const SizedBox(width: 6),
          Text(
            "Equivalent to ${_sharesController.text} Shares",
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF17C6C6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPhone = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F4F8), width: 1.5),
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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF17C6C6).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 18, color: const Color(0xFF17C6C6)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label.toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFF9E9E9E),
                    fontWeight: FontWeight.w800,
                    fontSize: 9,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                TextField(
                  controller: controller,
                  keyboardType: isPhone
                      ? TextInputType.phone
                      : TextInputType.number,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: 17,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                      color: Colors.grey.shade300,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 4),
                    border: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSectionHeader(String title, {String? subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(
            color: AnansiColors.darkBlue.withValues(alpha: 0.5),
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.1,
          ),
        ),
        if (subtitle != null) ...[
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAppBar() {
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
            "Register, Deposit & Invest",
            style: TextStyle(
              color: Color(0xFF0A2351),
              fontWeight: FontWeight.w900,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            "CAPITAL ALLOCATION",
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
        child: _buildCircleAction(
          CupertinoIcons.multiply,
          () => Navigator.pop(context),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: _buildCircleAction(CupertinoIcons.question_circle, () {}),
        ),
      ],
    );
  }

  Widget _buildCircleAction(IconData icon, VoidCallback onTap) {
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

  Widget _buildSummaryFooterInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF17C6C6).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF17C6C6).withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.info_circle_fill,
            color: const Color(0xFF17C6C6),
            size: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Smart Consolidation",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0A2351),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Shares, savings, and registration fees are processed in a single STK push to minimize your M-PESA transaction costs.",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade700,
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

  Widget _buildPersistentFooter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: _toTransactionPage,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0A2351),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            elevation: 0,
          ),
          child: const Text(
            "Review and Pay",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

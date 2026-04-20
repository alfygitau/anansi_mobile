import 'package:app_anansi_mobile/pages/membership/await_stk_membership.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ReviewMembership extends StatefulWidget {
  final double savingsAmount;
  final double sharesAmount;
  final String phoneNumber;
  final double registrationFee = 1000.0;

  const ReviewMembership({
    super.key,
    required this.savingsAmount,
    required this.sharesAmount,
    required this.phoneNumber,
  });

  @override
  State<ReviewMembership> createState() => _ReviewMembershipState();
}

class _ReviewMembershipState extends State<ReviewMembership> {
  final double sharePrice = 1000.0;

  @override
  Widget build(BuildContext context) {
    // Calculation includes the mandatory registration fee
    final double subtotal = widget.savingsAmount + widget.sharesAmount;
    final double totalPayable = subtotal + widget.registrationFee;
    final double sharesCount = widget.sharesAmount / sharePrice;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildAppBar(context),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 16),
                    _buildSectionHeader("Financial Summary"),
                    const SizedBox(height: 12),
                    _buildTransactionCard(sharesCount, totalPayable),
                    const SizedBox(height: 22),
                    _buildSectionHeader("Security & Compliance"),
                    const SizedBox(height: 8),
                    _buildInfoTile(
                      title: "STK Push Authorization",
                      message:
                          "A secure prompt will appear on your Safaricom device. Enter your M-PESA PIN to finalize.",
                      icon: CupertinoIcons.shield_lefthalf_fill,
                      color: const Color(0xFF17C6C6),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoTile(
                      title: "Membership Status",
                      message:
                          "Your registration fee is a one-time capital contribution. This transaction is non-reversible.",
                      icon: CupertinoIcons.lock_shield_fill,
                      color: const Color(0xFF0A2351),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: _buildActionFooter(totalPayable),
    );
  }

  Widget _buildTransactionCard(double sharesCount, double total) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFFF1F4F8), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildAttributeRow(
              "Transaction Type",
              "Sacco Onboarding",
              isBold: true,
            ),
            _buildDivider(),
            _buildAttributeRow(
              "Registration Fee",
              "KES ${widget.registrationFee.toStringAsFixed(2)}",
            ),
            _buildAttributeRow(
              "Savings Deposit",
              "KES ${widget.savingsAmount.toStringAsFixed(2)}",
            ),
            _buildAttributeRow(
              "Shares Capital",
              "KES ${widget.sharesAmount.toStringAsFixed(2)}",
            ),
            _buildAttributeRow(
              "Units Allocated",
              "${sharesCount.toStringAsFixed(2)} Units",
              isDimmed: true,
            ),
            _buildDivider(),
            _buildAttributeRow("Payment Channel", "M-PESA"),
            _buildAttributeRow(
              "Recipient Line",
              widget.phoneNumber,
              isDimmed: true,
            ),
            _buildDivider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Payable",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0A2351),
                  ),
                ),
                Text(
                  "KES ${total.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF17C6C6),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: const Color(0xFFF8FAFC).withValues(alpha: 0.95),
      elevation: 0,
      centerTitle: true,
      leadingWidth: 64,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Review Membership",
            style: TextStyle(
              color: Color(0xFF0A2351),
              fontWeight: FontWeight.w900,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            "CONFIRM DETAILS",
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 7,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
      leading: Center(
        child: _buildCircleBtn(
          CupertinoIcons.back,
          () => Navigator.pop(context),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: _buildCircleBtn(CupertinoIcons.question_circle, () {}),
        ),
      ],
    );
  }

  Widget _buildCircleBtn(IconData icon, VoidCallback onTap) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 18, color: const Color(0xFF0A2351)),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Final Review",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Color(0xFF0A2351),
          ),
        ),
        Text(
          "Check your allocation before we send the M-PESA prompt.",
          style: TextStyle(
            color: Colors.blueGrey.shade400,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w900,
        color: Color(0xFF9E9E9E),
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildInfoTile({
    required String title,
    required String message,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.blueGrey.shade600,
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttributeRow(
    String label,
    String value, {
    bool isBold = false,
    bool isDimmed = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isDimmed ? Colors.grey.shade400 : Colors.blueGrey.shade600,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: const Color(0xFF0A2351),
              fontSize: 13,
              fontWeight: isBold ? FontWeight.w900 : FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() => const Padding(
    padding: EdgeInsets.symmetric(vertical: 8),
    child: Divider(color: Color(0xFFF1F4F8), thickness: 1.5),
  );

  Widget _buildActionFooter(double total) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: ElevatedButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const AwaitStkMembership(reference: "ANANSI-REG-772"),
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0A2351),
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        child: const Text(
          "Confirm & Authorize",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

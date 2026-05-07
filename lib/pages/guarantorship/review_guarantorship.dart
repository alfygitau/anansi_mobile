import 'package:app_anansi_mobile/pages/guarantorship/guarantorship.dart';
import 'package:app_anansi_mobile/services/error_service.dart';
import 'package:app_anansi_mobile/services/guarantorship_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:intl/intl.dart';

class ReviewGuarantorship extends StatefulWidget {
  final String guarantorAmount;
  final Map<String, dynamic> loanInfo;
  const ReviewGuarantorship({
    super.key,
    required this.guarantorAmount,
    required this.loanInfo,
  });

  @override
  State<ReviewGuarantorship> createState() => _ReviewGuarantorshipState();
}

class _ReviewGuarantorshipState extends State<ReviewGuarantorship> {
  bool _isChecked = false;
  bool _isSubmitting = false;

  String formatToKES(dynamic amount) {
    final value = double.tryParse(amount.toString()) ?? 0.0;
    return "KES ${NumberFormat('#,###.00').format(value)}";
  }

  void _submitRequest() async {
    setState(() {
      _isSubmitting = true;
    });
    try {
      final (
        response,
        errors,
      ) = await GuarantorshipService().respondToGuarantor(
        guarantor: widget.loanInfo['guarantorId'],
        requestor: widget.loanInfo['id'],
        isAccepted: true,
        status: "accepted",
        amount: widget.guarantorAmount,
        reason: "I have a strong faith in the borrower ability to repay a loan",
      );
      if (errors != null) {
        ErrorService.showActionableError(
          context,
          title: errors[0],
          message: errors[1],
        );
      } else if (response != null) {
        showGuarantorAcceptSheet(
          context,
          loanCode: widget.loanInfo['loancode'] ?? "",
          amount: widget.guarantorAmount,
          onAction: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Guarantorship()),
            );
          },
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildSliverAppBar(),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 10),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildSummaryHeader(),
                      const SizedBox(height: 24),

                      _buildSectionHeader("YOUR COMMITMENT"),
                      _buildGuarantorAmountCard(),

                      const SizedBox(height: 32),
                      _buildSectionHeader("LOAN & BORROWER OVERVIEW"),
                      _buildInfoGroupCard([
                        _infoRow("Borrower", widget.loanInfo['borrowerName']),
                        _infoRow("Phone", widget.loanInfo['borrowerPhone']),
                        const Divider(height: 32, thickness: 0.5),
                        _infoRow(
                          "Principal",
                          formatToKES(
                            widget.loanInfo['loanInfo']['loanamount'],
                          ),
                        ),
                        _infoRow(
                          "Interest",
                          "${widget.loanInfo['loanInfo']['loaninterest']}% p.m",
                        ),
                        _infoRow(
                          "Duration",
                          (widget.loanInfo['loanInfo']?['loanperiod'] ?? "0")
                              .toString(),
                        ),
                        _infoRow(
                          "Total Repayable",
                          formatToKES(
                            widget.loanInfo['loanInfo']['loanrepaymentamount'],
                          ),
                        ),
                      ]),

                      const SizedBox(height: 32),
                      _buildTermsAgreement(),
                      const SizedBox(height: 40),
                    ]),
                  ),
                ),
              ],
            ),
          ),
          _buildActionFooter(),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      pinned: true,
      floating: true,
      backgroundColor: const Color(0xFFF8FAFC).withValues(alpha: 0.9),
      elevation: 0,
      centerTitle: true,
      leadingWidth: 64,
      toolbarHeight: 70,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Guarantorship",
            style: TextStyle(
              color: AnansiColors.darkBlue,
              fontWeight: FontWeight.w900,
              fontSize: 15,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            "FINAL REVIEW",
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
      leading: _buildCircleAction(
        CupertinoIcons.back,
        () => Navigator.pop(context),
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
    return Center(
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
          icon: Icon(icon, size: 18, color: AnansiColors.darkBlue),
          onPressed: onTap,
        ),
      ),
    );
  }

  Widget _buildSummaryHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Review Details",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: AnansiColors.darkBlue,
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Please verify all the information below before finalizing your guarantorship.",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade500,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: Colors.grey.shade400,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildGuarantorAmountCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AnansiColors.darkBlue,
            AnansiColors.darkBlue.withValues(alpha: 0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AnansiColors.darkBlue.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "AMOUNT TO GUARANTEE",
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            formatToKES(widget.guarantorAmount),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoGroupCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AnansiColors.darkBlue,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsAgreement() {
    return Row(
      children: [
        Transform.scale(
          scale: 0.9,
          child: Checkbox(
            value: _isChecked,
            activeColor: AnansiColors.darkBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            onChanged: (v) => setState(() => _isChecked = v!),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => _showTermsModal(),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: AnansiColors.darkBlue,
                  fontSize: 12,
                  height: 1.4,
                ),
                children: [
                  const TextSpan(text: "I have read and agree to the "),
                  TextSpan(
                    text: "Terms & Conditions",
                    style: TextStyle(
                      color: AnansiColors.accentCyan,
                      fontWeight: FontWeight.w800,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showTermsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _TermsModal(),
    );
  }

  void showGuarantorAcceptSheet(
    BuildContext context, {
    required String loanCode,
    required String amount,
    required VoidCallback onAction,
  }) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              // Dynamic Success Icon
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.blue[600],
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withValues(alpha: 0.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.check_circle_outline,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Commitment Confirmed",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "You have officially accepted the request to guarantee this loan. Your digital signature has been timestamped.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 15, height: 1.4),
              ),
              const SizedBox(height: 24),
              // Loan Details Summary Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    _summaryRow("Loan Reference", loanCode, isWhite: true),
                    const Divider(color: Colors.white24, height: 24),
                    _summaryRow(
                      "Guaranteed Amount",
                      "KES $amount",
                      isWhite: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onAction();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Finish",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        );
      },
    );
  }

  Widget _summaryRow(String label, String value, {bool isWhite = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isWhite ? Colors.white70 : Colors.grey,
            fontSize: 13,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isWhite ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildActionFooter() {
    bool canContinue = _isChecked && !_isSubmitting;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
      decoration: BoxDecoration(
        color: Colors.white,
        // Slightly more prominent shadow for depth
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Column(
        // Using a column in case you want to add a "Cancel" link later
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 58, // Fixed height prevents distortion during loading
            child: ElevatedButton(
              onPressed: canContinue ? () => _submitRequest() : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AnansiColors.darkBlue,
                disabledBackgroundColor: Colors.grey.shade100,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                // Remove internal button padding to let SizedBox control size
                padding: EdgeInsets.zero,
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CupertinoActivityIndicator(
                          color: Colors.white,
                          radius: 10,
                        ),
                      )
                    : const Text(
                        "Confirm & Submit",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          fontSize: 15, // Explicit size for consistency
                          letterSpacing: 0.2,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TermsModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Terms & Conditions",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: AnansiColors.darkBlue,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Text(
                "1. Agreement\nBy acting as a guarantor, you agree to fulfill the financial obligations of the borrower in the event of default...\n\n" *
                    10, // Replace with your actual text
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                  height: 1.6,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AnansiColors.darkBlue,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              "I Understand",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

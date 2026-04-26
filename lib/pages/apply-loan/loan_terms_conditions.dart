import 'package:app_anansi_mobile/pages/help&support/help_support.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';

class LoanTermsConditions extends StatefulWidget {
  const LoanTermsConditions({super.key});

  @override
  State<LoanTermsConditions> createState() => _LoanTermsConditionsState();
}

class _LoanTermsConditionsState extends State<LoanTermsConditions> {
  bool _hasReadToBottom = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 50) {
        if (!_hasReadToBottom) setState(() => _hasReadToBottom = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildStandardAppBar(context),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderDescription(),
                  const SizedBox(height: 32),
                  _buildKeyHighlightsCard(),
                  const SizedBox(height: 32),
                  const Text(
                    "Full Legal Disclosure",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  _buildLegalText(),
                ],
              ),
            ),
          ),
          _buildAcceptanceAction(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildStandardAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white.withValues(alpha: 0.9),
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false, // We are providing a custom leading
      leadingWidth:
          70, // Slightly wider to accommodate the circle button padding
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
          Text(
            "TERMS & CONDITIONS",
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 8,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Center(
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

  Widget _buildHeaderDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Review your agreement",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: AnansiColors.darkBlue,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Please read the following terms carefully. This agreement outlines your responsibilities as a borrower and our commitment to you.",
          style: TextStyle(
            color: Colors.blueGrey.shade400,
            fontSize: 15,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildKeyHighlightsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AnansiColors.darkBlue.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          _buildHighlightRow(
            CupertinoIcons.percent,
            "Interest Rate",
            "1.2% Per Month",
          ),
          _buildHighlightRow(
            CupertinoIcons.calendar,
            "Loan Tenure",
            "12 Months",
          ),
          _buildHighlightRow(
            CupertinoIcons.shield,
            "Insurance Fee",
            "0.5% (One-off)",
          ),
          _buildHighlightRow(
            CupertinoIcons.info_circle,
            "Late Penalty",
            "5% of Arrears",
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AnansiColors.darkBlue),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildLegalText() {
    return Text(
      "1. Loan Disbursement: The Sacco shall disburse the funds via M-PESA or Bank Transfer upon successful verification of collateral and guarantors...\n\n"
      "2. Security & Collateral: The borrower hereby charges the assets listed in the Collateral Inventory as security for the repayment of the loan. In the event of default, the Sacco reserves the right to exercise its power of sale over the chattels...\n\n"
      "3. Default Provisions: A loan is considered in default if any installment remains unpaid for more than 30 days after the due date...",
      style: TextStyle(color: Colors.grey.shade700, fontSize: 14, height: 1.8),
    );
  }

  Widget _buildAcceptanceAction() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          if (!_hasReadToBottom)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                "Please scroll to the bottom to accept",
                style: TextStyle(
                  color: Colors.orange.shade800,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ElevatedButton(
            onPressed: _hasReadToBottom
                ? () {
                    /* Final Submit Logic */
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AnansiColors.darkBlue,
              disabledBackgroundColor: Colors.grey.shade300,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              "I Accept Terms & Conditions",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

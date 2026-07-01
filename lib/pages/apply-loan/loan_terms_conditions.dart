import 'dart:convert';

import 'package:app_anansi_mobile/pages/help&support/help_support.dart';
import 'package:app_anansi_mobile/pages/loan-applications/loan_applications.dart';
import 'package:app_anansi_mobile/services/error_service.dart';
import 'package:app_anansi_mobile/services/loan_application_service.dart';
import 'package:app_anansi_mobile/services/secure_storage_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';

class LoanTermsConditions extends StatefulWidget {
  final String appId;
  const LoanTermsConditions({super.key, required this.appId});

  @override
  State<LoanTermsConditions> createState() => _LoanTermsConditionsState();
}

class _LoanTermsConditionsState extends State<LoanTermsConditions> {
  bool _hasReadToBottom = false;
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

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

  Future<Map<String, dynamic>?> getUser() async {
    String? userJson = await SecureStorageService().read('user');
    if (userJson == null) return null;
    Map<String, dynamic> userMap = jsonDecode(userJson);
    return userMap;
  }

  Future<void> acceptTermsConditions() async {
    _isLoading = true;
    try {
      final user = await getUser();
      final (response, errors) = await LoanApplicationService()
          .acceptTermsConditions(
            applicationId: widget.appId,
            customerId: user?['id'] ?? "",
          );
      if (errors != null) {
        ErrorService.showActionableError(
          context,
          title: errors[0],
          message: errors[1],
        );
      } else if (response != null) {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoanApplications()),
          );
        }
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
                  const SizedBox(height: 22),
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
          _buildAcceptanceAction(onAcceptTerms: acceptTermsConditions),
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

  Widget _buildLegalText() {
    return Text(
      "1. Loan Disbursement & Conditions Precedent: The Sacco reserves the exclusive right to withhold, cancel, or vary the disbursement of loan funds at its sole discretion. Execution of disbursement via M-PESA, Bank Transfer, or any other approved financial channel is strictly contingent upon the successful physical, legal, and operational verification of all pledged collateral, as well as the formal, verified confirmation of all nominated guarantors. The borrower acknowledges that any administrative, transaction, or transfer fees incurred during the disbursement process shall be borne entirely by the borrower and may be deducted directly from the principal loan amount prior to payout.\n\n"
      "2. Security, Collateral Pledges & Asset Charge: The borrower hereby creates a first-priority, absolute legal charge over the assets, chattels, or logbooks detailed in the accompanying Collateral Inventory as security for the full and final repayment of the principal loan amount, interest, and any associated costs. The borrower covenants to maintain said assets in pristine, merchantable condition and shall not sell, lease, transfer, or further encumber the property without the express written consent of the Sacco. In the event of default, the Sacco is unconditionally authorized to track, seize, and exercise its statutory power of sale over the charged assets via public auction or private treaty, without the necessity of any further judicial intervention.\n\n"
      "3. Default Provisions, Penalties & Acceleration Clauses: A loan account shall be declared immediately in default if any scheduled installment—comprising principal, interest, or insurance premiums—remains unpaid either in part or in full for a period exceeding 30 calendar days past the designated due date. Upon the occurrence of a default event, the entire outstanding balance of the loan shall immediately become due and payable (the acceleration clause). Furthermore, the Sacco reserves the right to apply a cumulative late payment penalty fee, calculated at the maximum statutory rate per month on the entire overdue amount, until the account is fully regularized.\n\n"
      "4. Interest Accumulation, Adjustments & Statutory Levies: Interest shall accrue daily on the outstanding loan balance on either a flat-rate or reducing-balance model as specified by the active product profile. The Sacco reserves the right to review, modify, and adjust the prevailing interest rates and processing fees contextually in response to shifts in central bank regulations, economic parameters, or institutional cost of funds, subject to providing the borrower with statutory notice. All statutory levies, including excise duty on financial transactions and withholding taxes, shall be passed on directly to the borrower's ledger.\n\n"
      "5. Guarantor Obligations & Joint-and-Several Liability: By executing this application, each nominated guarantor accepts absolute joint-and-several liability as a principal debtor for the entirety of the outstanding loan obligations, including the principal, accrued interest, legal fees, and recovery costs. The Sacco is not obligated to exhaust its legal remedies against the primary borrower before seeking recovery from the guarantors. In the event of default, the Sacco is granted irrevocable authorization to immediately freeze, place a lien upon, and liquidate the accumulated shares, deposits, or savings of any or all guarantors to offset the outstanding debt.\n\n"
      "6. Absolute Right of Set-Off & Recovery Mechanics: The borrower grants the Sacco an unconditional, irrevocable right of set-off. The Sacco may, at any time and without prior notice, combine or consolidate any accounts held by the borrower and offset any overdue loan balances against the borrower's share capital, deposits, dividends, or any other funds held within the society. Where applicable, this authorization extends to the check-off system, allowing the Sacco to issue a direct statutory demand to the borrower’s employer to deduct repayments directly from salary remittances until the financial obligation is fully extinguished.",
      style: TextStyle(
        color: Colors.grey.shade700,
        fontSize: 13,
        height: 1.8,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildAcceptanceAction({required VoidCallback onAcceptTerms}) {
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
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Only display scroll warning if they haven't reached the bottom AND we aren't currently loading
          if (!_hasReadToBottom && !_isLoading)
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
            // 2. Safeguard: Only allow clicks if they read everything AND a request isn't already active
            onPressed: (_hasReadToBottom && !_isLoading) ? onAcceptTerms : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AnansiColors.darkBlue,
              // 3. Smart Styling: Tinted blue if processing, dull grey if they just haven't scrolled yet
              disabledBackgroundColor: _isLoading
                  ? AnansiColors.darkBlue.withValues(alpha: 0.7)
                  : Colors.grey.shade300,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            // 4. Dynamic Child Element: Swaps text out for a centered performance spinner
            child: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : const Text(
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

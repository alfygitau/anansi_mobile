import 'package:app_anansi_mobile/pages/guarantorship/review_guarantorship.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:intl/intl.dart';

class GuaranteeAmount extends StatefulWidget {
  final Map<String, dynamic> loanInfo;
  const GuaranteeAmount({super.key, required this.loanInfo});

  @override
  State<GuaranteeAmount> createState() => _GuaranteeAmountState();
}

class _GuaranteeAmountState extends State<GuaranteeAmount> {
  final TextEditingController _amountController = TextEditingController();
  bool _hasAgreed = false;
  final double _maxLimit = 150000.00;
  Map<String, String?> formErrors = {'amount': null, 'phone': null};
  final FocusNode _amountFocus = FocusNode();

  void _validateField(String key) {
    final amount = _amountController.text.trim();

    setState(() {
      if (key == 'amount') {
        if (amount.isEmpty) {
          formErrors['amount'] = "Amount is required";
        } else if (double.tryParse(amount) == null ||
            double.parse(amount) <= 0) {
          formErrors['amount'] = "Enter a valid investment amount";
        } else {
          formErrors['amount'] = null;
        }
      }
    });
  }

  @override
  void initState() {
    _amountFocus.addListener(() {
      if (!_amountFocus.hasFocus) {
        _validateField('amount');
      }
      setState(() {});
    });
    super.initState();
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
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildHeaderContext(),
                      const SizedBox(height: 24),

                      _buildInputField(
                        label: "Guarantee Amount",
                        controller: _amountController,
                        hint: "Enter amount in KES",
                        icon: CupertinoIcons.money_dollar_circle,
                        fieldKey: "amount",
                        focusNode: _amountFocus,
                        keyboardType: TextInputType.number,
                      ),

                      const SizedBox(height: 12),
                      _buildLimitIndicator(),

                      const SizedBox(height: 32),
                      _buildSectionHeader("LEGAL DISCLAIMER"),
                      _buildLegalCard(),
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

  // --- YOUR APP BAR DESIGN ---
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
            "GUARANTEE AMOUNT",
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

  // --- HEADER CONTEXT ---
  Widget _buildHeaderContext() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Financial Commitment",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: AnansiColors.darkBlue,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "You are providing a guarantee for ${widget.loanInfo['borrowerName']}. Please ensure you only commit an amount you can comfortably cover.",
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // --- YOUR INPUT FIELD DESIGN ---
  Widget _buildInputField({
    required String label,
    required String fieldKey,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required FocusNode focusNode,
    required TextInputType keyboardType,
  }) {
    final String? errorText = formErrors[fieldKey];
    final bool hasError = errorText != null;
    final bool isFocused = focusNode.hasFocus;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 4),
          child: Row(
            children: [
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  color: hasError
                      ? Colors.redAccent
                      : AnansiColors.darkBlue.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w900,
                  fontSize: 11,
                  letterSpacing: 1.2,
                ),
              ),
              if (hasError) ...[
                const SizedBox(width: 8),
                const Icon(
                  CupertinoIcons.exclamationmark_circle,
                  size: 12,
                  color: Colors.redAccent,
                ),
              ],
            ],
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: hasError
                  ? Colors.redAccent.withValues(alpha: 0.4)
                  : (isFocused ? Color(0xFFE2E8F0) : const Color(0xFFE2E8F0)),
              width: 1.8,
            ),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isFocused
                      ? AnansiColors.darkBlue
                      : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: isFocused
                      ? Colors.white
                      : AnansiColors.darkBlue.withValues(alpha: 0.4),
                ),
              ),
              Container(
                height: 24,
                width: 1.5,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                color: const Color(0xFFE2E8F0),
              ),
              Expanded(
                child: TextField(
                  focusNode: focusNode,
                  controller: controller,
                  keyboardType: keyboardType,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2,
                  ),
                  cursorColor: AnansiColors.darkBlue,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                      color: Colors.blueGrey.shade200,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onChanged: (val) {
                    if (formErrors[fieldKey] != null) {
                      setState(() => formErrors[fieldKey] = null);
                    }
                    setState(() {});
                  },
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                ),
              ),
            ],
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: SizedBox(
            height: hasError ? null : 0,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, top: 8),
              child: Text(
                errorText ?? "",
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLimitIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Icon(
            CupertinoIcons.info_circle,
            size: 12,
            color: Colors.grey.shade400,
          ),
          const SizedBox(width: 6),
          Text(
            "Max Guarantee: KES ${NumberFormat('#,###').format(_maxLimit)}",
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
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
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  // --- THE MODERN LEGAL CARD ---
  Widget _buildLegalCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _hasAgreed
              ? AnansiColors.accentCyan.withValues(alpha: 0.3)
              : Colors.transparent,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 24,
            width: 24,
            child: Checkbox(
              value: _hasAgreed,
              activeColor: AnansiColors.darkBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              onChanged: (v) => setState(() => _hasAgreed = v!),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              "I understand that by proceeding, I am legally liable for the repayment of this amount should the borrower default. This action is irrevocable once submitted.",
              style: TextStyle(
                fontSize: 12,
                color: AnansiColors.darkBlue,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- PINNED ACTION FOOTER ---
  Widget _buildActionFooter() {
    bool canContinue = _hasAgreed && _amountController.text.isNotEmpty;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: canContinue
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReviewGuarantorship(
                      loanInfo: widget.loanInfo,
                      guarantorAmount: _amountController.text.trim(),
                    ),
                  ),
                );
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AnansiColors.darkBlue,
          disabledBackgroundColor: Colors.grey.shade200,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Review & Confirm",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: canContinue ? Colors.white : Colors.grey.shade500,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              CupertinoIcons.arrow_right,
              size: 16,
              color: canContinue ? Colors.white : Colors.grey.shade500,
            ),
          ],
        ),
      ),
    );
  }
}

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
  final TextEditingController _sharesController = TextEditingController();
  final TextEditingController _savingsController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final double sharePrice = 1000.0;
  final FocusNode _savingsFocus = FocusNode();
  final FocusNode _sharesFocus = FocusNode();
  final FocusNode _mobileFocus = FocusNode();
  double _totalCost = 0.0;
  Map<String, String?> formErrors = {
    'savings': null,
    'shares': null,
    'mobile': null,
  };

  Future<void> _toTransactionPage() async {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ReviewMembership(
            sharesAmount: double.parse(_sharesController.text.trim()),
            savingsAmount: double.parse(_savingsController.text.trim()),
            phoneNumber: _mobileController.text.trim(),
          ),
        ),
      );
    }
  }

  void _calculateTotal() {
    final String text = _sharesController.text.replaceAll(',', '');
    if (text.isEmpty) {
      setState(() => _totalCost = 0.0);
      return;
    }

    final double? shares = double.tryParse(text);
    if (shares != null) {
      setState(() {
        _totalCost = shares / sharePrice;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _sharesController.addListener(_calculateTotal);
    setState(() {
      _mobileController.text = widget.mobileNumber;
    });

    _sharesFocus.addListener(() {
      if (!_sharesFocus.hasFocus) {
        _validateField('shares', _sharesController.text);
      }
    });

    _savingsFocus.addListener(() {
      if (!_savingsFocus.hasFocus) {
        _validateField('savings', _savingsController.text);
      }
    });

    _mobileFocus.addListener(() {
      if (!_mobileFocus.hasFocus) {
        _validateField('mobile', _mobileController.text);
      }
    });
  }

  void _validateField(String key, String value) {
    String? error;
    final trimmedValue = value.trim();

    switch (key) {
      case 'shares':
        if (trimmedValue.isEmpty) {
          error = "Shares amount is required";
        } else {
          final amount = double.tryParse(trimmedValue.replaceAll(',', ''));
          if (amount == null) {
            error = "Enter a valid number";
          }
        }
        break;

      case 'savings':
        if (trimmedValue.isEmpty) {
          error = "Savings target is required";
        } else if (double.tryParse(trimmedValue.replaceAll(',', '')) == null) {
          error = "Enter a valid amount";
        }
        break;

      case 'mobile':
        final RegExp kenyanRegex = RegExp(r'^(?:\+254|254|0)(7|1)[0-9]{8}$');
        if (trimmedValue.isEmpty) {
          error = "Mobile number is required";
        } else if (!kenyanRegex.hasMatch(trimmedValue.replaceAll(' ', ''))) {
          error = "Enter a valid Kenyan number (07... or 01...)";
        }
        break;
    }

    setState(() {
      formErrors[key] = error;
    });
  }

  bool get isInvestmentFormValid {
    // 1. Shares: Must be at least the minimum share price
    final double? shareAmount = double.tryParse(
      _sharesController.text.replaceAll(',', ''),
    );
    final bool sharesReady = shareAmount != null;

    // 2. Savings: Must not be empty and must be a valid number
    final double? savingsAmount = double.tryParse(
      _savingsController.text.replaceAll(',', ''),
    );
    final bool savingsReady = savingsAmount != null && savingsAmount > 0;

    // 3. Mobile: Must match the Kenyan RegEx pattern
    final String cleanPhone = _mobileController.text.trim().replaceAll(
      RegExp(r'[\s\-\+]'),
      '',
    );
    final bool mobileReady = RegExp(
      r'^(?:254|0)(7|1)[0-9]{8}$',
    ).hasMatch(cleanPhone);

    return sharesReady && savingsReady && mobileReady;
  }

  @override
  void dispose() {
    _sharesFocus.dispose();
    _savingsFocus.dispose();
    _mobileFocus.dispose();
    _sharesController.dispose();
    _savingsController.dispose();
    _mobileController.dispose();
    super.dispose();
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
                        focusNode: _savingsFocus,
                        fieldKey: "savings",
                        keyboardType: TextInputType.number,
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
                        controller: _sharesController,
                        hint: "e.g 5000",
                        icon: Icons.insights_rounded,
                        focusNode: _sharesFocus,
                        fieldKey: "shares",
                        keyboardType: TextInputType.number,
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
                        focusNode: _mobileFocus,
                        fieldKey: "mobile",
                        keyboardType: TextInputType.phone,
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
            "Equivalent to $_totalCost Shares",
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
    required String fieldKey,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required FocusNode focusNode,
    required TextInputType keyboardType,
    bool? readonly,
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
                  readOnly: readonly ?? false,
                  keyboardType: keyboardType,
                  style: const TextStyle(
                    fontSize: 17,
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
    final VoidCallback? action = (isInvestmentFormValid
        ? _toTransactionPage
        : null);

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: action,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0A2351),
            foregroundColor: Colors.white,
            // Color when isInvestmentFormValid is false
            disabledBackgroundColor: Colors.grey.shade200,
            disabledForegroundColor: Colors.grey.shade500,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            elevation: 0,
          ),
          child: Text(
            "Review and Pay",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
              color: isInvestmentFormValid
                  ? Colors.white
                  : Colors.grey.shade500,
            ),
          ),
        ),
      ),
    );
  }
}

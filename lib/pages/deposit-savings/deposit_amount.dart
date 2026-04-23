import 'package:app_anansi_mobile/pages/deposit-savings/review_deposit_savings.dart';
import 'package:app_anansi_mobile/state/auth_provider.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DepositAmount extends StatefulWidget {
  final String id;
  const DepositAmount({super.key, required this.id});

  @override
  State<DepositAmount> createState() => _DepositAmountState();
}

class _DepositAmountState extends State<DepositAmount> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _amountFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  Map<String, String?> formErrors = {'amount': null, 'phone': null};

  void clearAllErrors() => setState(() => formErrors.updateAll((k, v) => null));

  void _validateField(String key) {
    final amount = _amountController.text.trim();
    final phone = _phoneController.text.trim();
    final phoneRegex = RegExp(r'^(?:254|\+254|0)?([71][0-9]{8})$');

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

      if (key == 'phone') {
        if (phone.isEmpty) {
          formErrors['phone'] = "Phone number is required";
        } else if (!phoneRegex.hasMatch(phone)) {
          formErrors['phone'] = "Enter a valid Kenyan phone number";
        } else {
          formErrors['phone'] = null;
        }
      }
    });
  }

  bool _isFormValid() {
    final amount = _amountController.text.trim();
    final phone = _phoneController.text.trim();
    final phoneRegex = RegExp(r'^(?:254|\+254|0)?([71][0-9]{8})$');

    bool amountValid =
        amount.isNotEmpty &&
        double.tryParse(amount) != null &&
        double.parse(amount) > 0;
    bool phoneValid = phone.isNotEmpty && phoneRegex.hasMatch(phone);

    return amountValid &&
        phoneValid &&
        formErrors['amount'] == null &&
        formErrors['phone'] == null;
  }

  void _prefillUserData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.user != null && authProvider.user?['mobileno'] != null) {
      setState(() {
        _phoneController.text = authProvider.user?['mobileno'] ?? "".toString();
        _validateField('phone');
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _prefillUserData();

    _amountFocus.addListener(() {
      if (!_amountFocus.hasFocus) _validateField('amount');
      setState(() {});
    });

    _phoneFocus.addListener(() {
      if (!_phoneFocus.hasFocus) _validateField('phone');
      setState(() {});
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 5, 24, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      _buildSectionHeader("Deposit Savings Details"),
                      const SizedBox(height: 6),
                      Text(
                        "Enter the amount you wish to add to your savings. Funds will be moved from your M-PESA wallet instantly.",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blueGrey.shade400,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  _buildInputField(
                    label: "Deposit Amount (KES)",
                    controller: _amountController,
                    hint: "0.00",
                    icon: CupertinoIcons.money_dollar_circle_fill,
                    focusNode: _amountFocus,
                    fieldKey: "amount",
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 42),
                  _buildPremiumDisclaimer(
                    title: "Instant Processing",
                    message:
                        "M-PESA Express transactions usually reflect within 60 seconds of approval.",
                    icon: CupertinoIcons.bolt_fill,
                    baseColor: const Color(0xFF10B981),
                  ),
                  const SizedBox(height: 12),
                  _buildPremiumDisclaimer(
                    title: "Transaction Limits",
                    message:
                        "Your current daily deposit limit is KES 300,000.00.",
                    icon: CupertinoIcons.shield_lefthalf_fill,
                    baseColor: const Color(0xFF17C6C6),
                  ),
                  const SizedBox(height: 12),
                  _buildPremiumDisclaimer(
                    title: "Security Protocol",
                    message:
                        "Ensure you only input your PIN on the official M-PESA SIM Toolkit prompt.",
                    icon: CupertinoIcons.lock_shield_fill,
                    baseColor: const Color(0xFFF59E0B),
                  ),
                  const SizedBox(height: 42),
                  _buildInputField(
                    label: "Confirm Phone Number",
                    controller: _phoneController,
                    hint: "e.g. 0700,000,000",
                    icon: CupertinoIcons.phone,
                    focusNode: _phoneFocus,
                    fieldKey: "phone",
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 100),
                  _buildContinueButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      floating: true,
      backgroundColor: const Color(0xFFF8FAFC).withValues(alpha: 0.9),
      elevation: 0,
      centerTitle: true,
      leadingWidth: 64,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Deposit Amount",
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
                "SECURE TRANSACTION",
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
                onPressed: () {},
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w900,
        color: AnansiColors.darkBlue,
        letterSpacing: -0.5,
      ),
    );
  }

  // YOUR CUSTOM INPUT DESIGN
  Widget _buildInputField({
    required String label,
    required String fieldKey,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required FocusNode focusNode,
    required TextInputType keyboardType,
  }) {
    // 1. Extract the current state for this specific field
    final String? errorText = formErrors[fieldKey];
    final bool hasError = errorText != null;
    final bool isFocused = focusNode.hasFocus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            // BORDER LOGIC: Error > Focused > Neutral
            border: Border.all(
              color: hasError
                  ? Colors.redAccent.withValues(alpha: 0.6)
                  : (isFocused
                        ? const Color(0xFF17C6C6)
                        : const Color(0xFFF1F4F8)),
              width: 1.6,
            ),
            boxShadow: [
              BoxShadow(
                color: hasError
                    ? Colors.redAccent.withValues(alpha: 0.05)
                    : (isFocused
                          ? const Color(0xFF17C6C6).withValues(alpha: 0.08)
                          : Colors.black.withValues(alpha: 0.02)),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon Container reacts to state
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: hasError
                      ? Colors.redAccent.withValues(alpha: 0.08)
                      : const Color(0xFF17C6C6).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: hasError ? Colors.redAccent : const Color(0xFF17C6C6),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label.toUpperCase(),
                      style: TextStyle(
                        color: hasError
                            ? Colors.redAccent
                            : const Color(0xFF9E9E9E),
                        fontWeight: FontWeight.w800,
                        fontSize: 9,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    TextField(
                      focusNode: focusNode,
                      controller: controller,
                      keyboardType: keyboardType,
                      onChanged: (val) {
                        if (formErrors[fieldKey] != null) {
                          setState(() => formErrors[fieldKey] = null);
                        }
                        setState(() {});
                      },
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 17,
                      ),
                      onTapOutside: (event) {
                        FocusScope.of(context).unfocus();
                      },
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
        ),

        // ERROR MESSAGE: Animated Slide-in
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: SizedBox(
            height: hasError ? null : 0,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, top: 8),
              child: Text(
                errorText ?? "",
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // PREMIUM DETAILED DISCLAIMER
  Widget _buildPremiumDisclaimer({
    required String title,
    required String message,
    required IconData icon,
    required Color baseColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: baseColor.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: baseColor.withValues(alpha: 0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: baseColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: baseColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: baseColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.blueGrey.shade700,
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

  Widget _buildContinueButton() {
    final bool isValid = _isFormValid();

    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: isValid
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReviewDepositSavings(
                      amount: _amountController.text.trim(),
                      phone: _phoneController.text.trim(),
                      id: widget.id,
                    ),
                  ),
                );
              }
            : null, // This is what tells the button to be disabled and turn grey
        style: ElevatedButton.styleFrom(
          backgroundColor: AnansiColors.darkBlue,
          // The button automatically uses disabledBackgroundColor when onPressed is null
          disabledBackgroundColor: Colors.grey.shade300,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: isValid ? 12 : 0, // Remove elevation when disabled
          shadowColor: AnansiColors.darkBlue.withValues(alpha: 0.3),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Continue",
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

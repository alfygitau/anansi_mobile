import 'package:app_anansi_mobile/pages/invest/review_invest_details.dart';
import 'package:app_anansi_mobile/state/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class InvestAmount extends StatefulWidget {
  const InvestAmount({super.key});

  @override
  InvestAmountState createState() => InvestAmountState();
}

class InvestAmountState extends State<InvestAmount> {
  final TextEditingController _sharesController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final double sharePrice = 1000.0;
  double _calculatedShares = 0.0;
  final FocusNode _amountFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _sharesFocus = FocusNode();
  Map<String, String?> formErrors = {
    'amount': null,
    'phone': null,
    "shares": null,
  };

  void clearAllErrors() => setState(() => formErrors.updateAll((k, v) => null));

  @override
  void initState() {
    super.initState();
    _prefillUserData();
    _sharesController.addListener(_calculateShares);

    _amountFocus.addListener(() {
      if (!_amountFocus.hasFocus) _validateField('amount');
      setState(() {});
    });

    _phoneFocus.addListener(() {
      if (!_phoneFocus.hasFocus) _validateField('phone');
      setState(() {});
    });

    _sharesFocus.addListener(() {
      if (!_sharesFocus.hasFocus) _validateField('shares');
      setState(() {});
    });
  }

  void _validateField(String key) {
    final amount = _amountController.text.trim();
    final shares = _sharesController.text.trim();
    final phone = _mobileController.text.trim();
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

      if (key == 'shares') {
        if (shares.isEmpty) {
          formErrors['shares'] = "Shares amount is required";
        } else if (double.tryParse(shares) == null ||
            double.parse(shares) <= 0) {
          formErrors['shares'] = "Enter a valid shares amount";
        } else {
          formErrors['shares'] = null;
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
    final phone = _mobileController.text.trim();
    final shares = _sharesController.text.trim();
    final phoneRegex = RegExp(r'^(?:254|\+254|0)?([71][0-9]{8})$');

    bool amountValid =
        amount.isNotEmpty &&
        double.tryParse(amount) != null &&
        double.parse(amount) > 0;
    bool sharesValid =
        shares.isNotEmpty &&
        double.tryParse(shares) != null &&
        double.parse(shares) > 0;
    bool phoneValid = phone.isNotEmpty && phoneRegex.hasMatch(phone);

    return amountValid &&
        sharesValid &&
        phoneValid &&
        formErrors['amount'] == null &&
        formErrors['shares'] == null &&
        formErrors['phone'] == null;
  }

  void _prefillUserData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.user != null && authProvider.user?['mobileno'] != null) {
      setState(() {
        _mobileController.text =
            authProvider.user?['mobileno'] ?? "".toString();
        _validateField('phone');
      });
    }
  }

  void _calculateShares() {
    final text = _sharesController.text;
    if (text.isEmpty) {
      setState(() => _calculatedShares = 0.0);
      return;
    }
    final amount = double.tryParse(text) ?? 0.0;
    setState(() {
      _calculatedShares = amount / sharePrice;
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _mobileController.dispose();
    _sharesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildSectionHeader(
                    "ALLOCATE FUNDS",
                    subtitle:
                        "Choose how much to save or invest in shares today.",
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
                          controller: _amountController,
                          hint: "e.g 5000",
                          icon: Icons.account_balance_wallet_rounded,
                          fieldKey: "amount",
                          focusNode: _amountFocus,
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
                        _buildSharesTranslationCard(),
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
                          keyboardType: TextInputType.phone,
                          fieldKey: "phone",
                          focusNode: _phoneFocus,
                        ),
                        const SizedBox(height: 12),
                        buildRememberMeToggle(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),
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
                  const SizedBox(height: 40),
                  buildPayButton(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- APP BAR ---
  Widget buildAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      backgroundColor: const Color(0xFFF8FAFC).withOpacity(0.9),
      elevation: 0,
      centerTitle: true,
      leadingWidth: 64,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Quick Invest & Save",
            style: TextStyle(
              color: AnansiColors.darkBlue,
              fontWeight: FontWeight.w900,
              fontSize: 15,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 2),
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
      leading: Center(
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

  // --- REUSABLE INPUT ---
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

  Widget _buildSharesTranslationCard() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF17C6C6).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF17C6C6).withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Equivalent Units",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.blueGrey,
            ),
          ),
          Text(
            "${_calculatedShares.toStringAsFixed(3)} SHARES",
            style: GoogleFonts.robotoMono(
              fontWeight: FontWeight.w900,
              fontSize: 14,
              color: const Color(0xFF17C6C6),
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
            color: AnansiColors.darkBlue.withOpacity(0.5),
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

  Widget buildDisclaimer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(CupertinoIcons.shield_fill, color: Color(0xFF17C6C6), size: 18),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Transactions are KES protected and regulated by SASRA. Ensure your M-PESA is active.",
              style: TextStyle(
                fontSize: 11,
                height: 1.5,
                color: Colors.blueGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPayButton() {
    final bool isValid = _isFormValid();
    return ElevatedButton(
      onPressed: isValid
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReviewInvestDetails(
                    savingsAmount: _amountController.text.trim(),
                    sharesAmount: _sharesController.text.trim(),
                    phoneNumber: _mobileController.text.trim(),
                  ),
                ),
              );
            }
          : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: AnansiColors.darkBlue,
        disabledBackgroundColor: Colors.grey.shade300,
        minimumSize: const Size(double.infinity, 60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
      ),
      child: const Text(
        "Continue",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: 16,
        ),
      ),
    );
  }
}

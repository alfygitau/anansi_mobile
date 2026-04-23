import 'package:app_anansi_mobile/pages/buy-shares/review_purchase_shares.dart';
import 'package:app_anansi_mobile/state/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SharesAmount extends StatefulWidget {
  final String id;
  const SharesAmount({super.key, required this.id});

  @override
  State<SharesAmount> createState() => _SharesAmountState();
}

class _SharesAmountState extends State<SharesAmount> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _amountFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  Map<String, String?> formErrors = {'amount': null, 'phone': null};
  final double sharePrice = 1000.0;
  double _calculatedShares = 0.0;

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
    _amountController.addListener(_calculateShares);

    _amountFocus.addListener(() {
      if (!_amountFocus.hasFocus) _validateField('amount');
      setState(() {});
    });

    _phoneFocus.addListener(() {
      if (!_phoneFocus.hasFocus) _validateField('phone');
      setState(() {});
    });
  }

  void _calculateShares() {
    final text = _amountController.text;
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
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 10, 24, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader("Purchase Shares"),
                  const SizedBox(height: 6),
                  Text(
                    "Expand your ownership in the SACCO. Buying shares increases your dividend earnings and borrowing power.",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blueGrey.shade400,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // INPUT FIELD WITH MONOSPACE INTEGRATION
                  _buildInputField(
                    label: "Investment Amount (KES)",
                    controller: _amountController,
                    hint: "0.00",
                    icon: CupertinoIcons.chart_pie_fill,
                    focusNode: _amountFocus,
                    fieldKey: "amount",
                    keyboardType: TextInputType.number,
                  ),

                  // THE SHARES TRANSLATION BOX
                  _buildSharesTranslationCard(),

                  const SizedBox(height: 32),
                  _buildPremiumDisclaimer(
                    title: "Equity & Ownership",
                    message:
                        "Share capital is non-withdrawable but can be transferred to another member upon exit.",
                    icon: CupertinoIcons.shield_fill,
                    baseColor: AnansiColors.darkBlue,
                  ),
                  const SizedBox(height: 12),
                  _buildPremiumDisclaimer(
                    title: "Dividend Eligibility",
                    message:
                        "Dividends are calculated based on your weighted average shareholding throughout the fiscal year.",
                    icon: CupertinoIcons.graph_circle_fill,
                    baseColor: const Color(0xFF17C6C6),
                  ),

                  const SizedBox(height: 32),
                  _buildInputField(
                    label: "M-PESA Phone Number",
                    controller: _phoneController,
                    hint: "07xx xxx xxx",
                    icon: CupertinoIcons.phone_fill,
                    focusNode: _phoneFocus,
                    fieldKey: "phone",
                    keyboardType: TextInputType.phone,
                  ),

                  const SizedBox(height: 80),
                  _buildContinueButton(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
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

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      backgroundColor: const Color(0xFFF1F5F9).withValues(alpha: 0.95),
      elevation: 0,
      centerTitle: true,
      leadingWidth: 64,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Equity Investment",
            style: TextStyle(
              color: AnansiColors.darkBlue,
              fontWeight: FontWeight.w900,
              fontSize: 15,
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
            border: Border.all(color: Colors.grey.shade200),
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

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w900,
        color: AnansiColors.darkBlue,
        letterSpacing: -0.8,
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

  Widget _buildPremiumDisclaimer({
    required String title,
    required String message,
    required IconData icon,
    required Color baseColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: baseColor.withValues(alpha: 0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: baseColor),
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
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
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

  Widget _buildContinueButton() {
    final bool isValid = _isFormValid();

    return SizedBox(
      width: double.infinity,
      height: 62,
      child: ElevatedButton(
        onPressed: isValid
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReviewPurchaseShares(
                      amount: _amountController.text.trim(),
                      phone: _phoneController.text.trim(),
                      id: widget.id,
                    ),
                  ),
                );
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AnansiColors.darkBlue,
          disabledBackgroundColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        child: Text(
          "Continue to Review",
          style: TextStyle(
            color: isValid ? Colors.white : Colors.grey.shade500,
            fontWeight: FontWeight.w900,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

import 'package:app_anansi_mobile/theme/app_theme.dart'; // Assuming your AnansiColors are here
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChangePhoneNumber extends StatefulWidget {
  const ChangePhoneNumber({super.key});

  @override
  State<ChangePhoneNumber> createState() => _ChangePhoneNumberState();
}

class _ChangePhoneNumberState extends State<ChangePhoneNumber> {
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocus = FocusNode();
  bool _isLoading = false;

  // Using your map-based error tracking
  Map<String, String?> formErrors = {'phone': null};

  @override
  void initState() {
    super.initState();
    _phoneFocus.addListener(() {
      if (!_phoneFocus.hasFocus) {
        _validatePhone(_phoneController.text);
      }
    });
  }

  // 1. Kenyan Phone Validation Logic
  void _validatePhone(String value) {
    // Regex matches: 07..., 01..., 254..., or +254...
    final bool phoneValid = RegExp(
      r'^(?:254|\+254|0)?(7|1)(?:[0-9]){8}$',
    ).hasMatch(value);

    setState(() {
      if (value.isEmpty) {
        formErrors['phone'] = "Mobile number is required";
      } else if (!phoneValid) {
        formErrors['phone'] = "Enter a valid Kenyan mobile number";
      } else {
        formErrors['phone'] = null;
      }
    });
  }

  // 2. Real-time Button Logic (Independent of formErrors for instant feedback)
  bool get _isButtonEnabled {
    final bool phoneValid = RegExp(
      r'^(?:254|\+254|0)?(7|1)(?:[0-9]){8}$',
    ).hasMatch(_phoneController.text);
    return phoneValid && formErrors['phone'] == null;
  }

  Future<void> _handleUpdate() async {
    setState(() => _isLoading = true);
    // Add your API logic here
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildAppBar(),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 20),
                  _buildHeader(),
                  const SizedBox(height: 40),
                  _buildInputField(
                    label: "New Mobile Number",
                    hint: "0712 345 678",
                    controller: _phoneController,
                    icon: CupertinoIcons.phone_fill,
                    fieldKey: "phone",
                    focusNode: _phoneFocus,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 32),
                  _buildSubmitButton(),
                  const SizedBox(height: 40),
                  _buildSecurityProtocolCard(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          CupertinoIcons.chevron_left,
          color: AnansiColors.darkBlue,
          size: 20,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        "Change Mobile Number",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w900,
          color: AnansiColors.darkBlue,
        ),
      ),
      centerTitle: false,
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "UPDATE YOUR\nMOBILE NUMBER",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w900,
            color: Color(0xFF0F172A),
            height: 1.1,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "This number will be used for M-PESA transactions, SMS alerts, and secure account recovery.",
          style: TextStyle(
            fontSize: 16,
            color: Colors.blueGrey.shade400,
            height: 1.5,
          ),
        ),
      ],
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
    final String? errorText = formErrors[fieldKey];
    final bool hasError = errorText != null;
    final bool isFocused = focusNode.hasFocus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: hasError
                  ? Colors.redAccent
                  : (isFocused
                        ? const Color(0xFFF1F4F8)
                        : const Color(0xFFF1F4F8)),
              width: 1.6,
            ),
            boxShadow: [
              BoxShadow(
                color: isFocused
                    ? const Color(0xFF17C6C6).withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.02),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: hasError
                      ? Colors.redAccent.withValues(alpha: 0.08)
                      : AnansiColors.darkBlue.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: hasError ? Colors.redAccent : AnansiColors.darkBlue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        fontSize: 17,
                      ),
                      decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: TextStyle(
                          color: Colors.grey.shade300,
                          fontSize: 14,
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
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 8),
            child: Text(
              errorText,
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    final bool valid = _isButtonEnabled;
    return ElevatedButton(
      onPressed: (valid && !_isLoading) ? _handleUpdate : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: AnansiColors.darkBlue,
        disabledBackgroundColor: Colors.grey.shade200,
        minimumSize: const Size(double.infinity, 72),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        elevation: valid ? 8 : 0,
      ),
      child: _isLoading
          ? const CupertinoActivityIndicator(color: Colors.white)
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "VERIFY NUMBER",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 12),
                Icon(CupertinoIcons.arrow_right, size: 18, color: Colors.white),
              ],
            ),
    );
  }

  Widget _buildSecurityProtocolCard() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                CupertinoIcons.device_phone_portrait,
                color: Color(0xFF17C6C6),
                size: 20,
              ),
              const SizedBox(width: 12),
              const Text(
                "SMS VERIFICATION",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            "To confirm this change, we will send a 6-digit OTP via SMS to the new number. Carrier charges may apply.",
            style: TextStyle(
              fontSize: 13,
              color: Colors.blueGrey.shade600,
              height: 1.6,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: Color(0xFFE2E8F0)),
          ),
          Text(
            "Note: Ensure your SIM card is active and has signal bars to receive the code instantly.",
            style: TextStyle(
              fontSize: 12,
              color: Colors.blueGrey.shade400,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

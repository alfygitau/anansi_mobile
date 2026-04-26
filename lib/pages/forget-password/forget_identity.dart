import 'package:app_anansi_mobile/pages/forget-password/forget_otp_access.dart';
import 'package:app_anansi_mobile/services/error_service.dart';
import 'package:app_anansi_mobile/services/recovery_service.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ForgetIdentity extends StatefulWidget {
  final String method;

  const ForgetIdentity({super.key, required this.method});

  @override
  State<ForgetIdentity> createState() => _ForgetIdentityState();
}

class _ForgetIdentityState extends State<ForgetIdentity> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isLoading = false;
  Map<String, String?> formErrors = {};

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _validateField();
      }
      setState(() {});
    });
  }

  void _validateField() {
    final String value = _controller.text.trim();
    final bool isEmail = widget.method == "email";

    final emailRegex = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );
    final phoneRegex = RegExp(r"^\+?[0-9]{10,15}$");

    setState(() {
      if (value.isEmpty) {
        formErrors["identifier"] = "This field is required to continue";
      } else if (isEmail && !emailRegex.hasMatch(value)) {
        formErrors["identifier"] = "Please enter a valid email address";
      } else if (!isEmail && !phoneRegex.hasMatch(value)) {
        formErrors["identifier"] = "Please enter a valid phone number";
      } else {
        formErrors["identifier"] = null;
      }
    });
  }

  bool _isInputValid() {
    final String value = _controller.text.trim();
    final bool isEmail = widget.method == "email";
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );
    final phoneRegex = RegExp(r"^\+?[0-9]{10,15}$");

    if (isEmail) {
      return emailRegex.hasMatch(value);
    } else {
      return phoneRegex.hasMatch(value);
    }
  }

  void _handleSubmit() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final (response, errors) = await RecoveryService().forgetEmail(
        email: _controller.text.trim(),
      );
      if (errors != null) {
        ErrorService.showActionableError(
          context,
          title: errors[0],
          message: errors[1],
        );
      } else if (response != null) {
        HapticFeedback.lightImpact();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ForgetOtpAccess(
              method: widget.method,
              identity: _controller.text.trim(),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isEmail = widget.method == "email";

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 20),
                  _buildPageHeader(isEmail),
                  const SizedBox(height: 16),
                  Text(
                    "To regain access to your account, please provide the ${isEmail ? 'email address' : 'mobile number'} associated with your profile. We will send a secure verification code to verify your identity.",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade600,
                      height: 1.6,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildInputField(
                    label: isEmail ? "Email Address" : "Phone Number",
                    fieldKey: "identifier",
                    controller: _controller,
                    hint: isEmail ? "example@domain.com" : "0712 345 678",
                    icon: isEmail ? CupertinoIcons.mail : CupertinoIcons.phone,
                    focusNode: _focusNode,
                    keyboardType: isEmail
                        ? TextInputType.emailAddress
                        : TextInputType.phone,
                  ),
                  const SizedBox(height: 40),
                  _buildDisclaimers(),
                  const SizedBox(height: 150),
                ]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: !_isInputValid()
                  ? null
                  : (_isLoading ? () {} : _handleSubmit),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF074073),
                disabledBackgroundColor: Colors.grey.shade300,
                disabledForegroundColor: Colors.grey.shade500,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? const CupertinoActivityIndicator(color: Colors.white)
                  : const Text(
                      "Send Code",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageHeader(bool isEmail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF074073).withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            isEmail
                ? CupertinoIcons.lock_shield
                : CupertinoIcons.device_phone_portrait,
            color: const Color(0xFF074073),
            size: 28,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          isEmail ? "Recovery via Email" : "Recovery via SMS",
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Color(0xFF074073),
            letterSpacing: -0.8,
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required String fieldKey, // The key in our formErrors dictionary
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
                        ? const Color(0xFFF1F4F8)
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

  Widget _buildDisclaimers() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F4F8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "IMPORTANT NOTICE",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: Color(0xFF074073),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          _disclaimerItem(
            "Verification codes expire after 10 minutes for your security.",
          ),
          _disclaimerItem(
            "If you no longer have access to this contact method, please visit the nearest branch with your National ID.",
          ),
          _disclaimerItem(
            "Anansi will never ask for your password or OTP via phone call or SMS.",
          ),
        ],
      ),
    );
  }

  Widget _disclaimerItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Icon(Icons.circle, size: 4, color: Colors.grey),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:app_anansi_mobile/services/error_service.dart';
import 'package:app_anansi_mobile/services/recovery_service.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ResetPassword extends StatefulWidget {
  final String identity;
  const ResetPassword({super.key, required this.identity});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  final FocusNode _passFocus = FocusNode();
  final FocusNode _confirmFocus = FocusNode();
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  Map<String, String?> formErrors = {};
  bool _has8Chars = false;
  bool _hasSpecialChar = false;
  bool _hasNumber = false;
  bool _hasUppercase = false;

  @override
  void initState() {
    super.initState();
    _passFocus.addListener(() {
      if (!_passFocus.hasFocus) {
        _validatePasswordOnFocus();
        if (_confirmPassController.text.isNotEmpty) _validateConfirm();
      }
    });

    _confirmFocus.addListener(() {
      if (!_confirmFocus.hasFocus) {
        _validateConfirm();
      }
    });
  }

  void _validatePasswordOnFocus() {
    setState(() {
      final pass = _passController.text;
      if (pass.isEmpty) {
        formErrors['password'] = "Password is required";
        return;
      }
      List<String> missingRequirements = [];
      if (pass.length < 8) {
        missingRequirements.add("at least 8 characters");
      }
      if (!pass.contains(RegExp(r'[A-Z]'))) {
        missingRequirements.add("one uppercase letter");
      }
      if (!pass.contains(RegExp(r'[0-9]'))) {
        missingRequirements.add("one number");
      }
      if (!pass.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
        missingRequirements.add("one special character");
      }
      if (missingRequirements.isNotEmpty) {
        String errorMessage =
            "Password needs ${missingRequirements.join(', ')}.";
        if (missingRequirements.length > 1) {
          int lastComma = errorMessage.lastIndexOf(',');
          errorMessage = errorMessage.replaceRange(
            lastComma,
            lastComma + 1,
            " and",
          );
        }
        formErrors['password'] = errorMessage;
      } else {
        formErrors['password'] = null;
      }
    });
  }

  void _validateConfirm() {
    setState(() {
      final pass = _passController.text;
      final confirm = _confirmPassController.text;

      if (confirm.isEmpty) {
        formErrors['confirm'] = "Confirm password cannot be empty";
      } else if (pass != confirm) {
        formErrors['confirm'] = "Passwords do not match";
      } else {
        formErrors['confirm'] = null;
      }
    });
  }

  void _updateValidationStates(String value) {
    setState(() {
      _has8Chars = value.length >= 8;
      _hasUppercase = value.contains(RegExp(r'[A-Z]'));
      _hasNumber = value.contains(RegExp(r'[0-9]'));
      _hasSpecialChar = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
      if (formErrors['password'] != null) {
        formErrors['password'] = null;
      }
    });
  }

  void _validatePassword(String value) {
    setState(() {
      _has8Chars = value.length >= 8;
      _hasSpecialChar = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
      _hasNumber = value.contains(RegExp(r'[0-9]'));
      _hasUppercase = value.contains(RegExp(r'[A-Z]'));
    });
  }

  void _handleReset() async {
    if (_passController.text != _confirmPassController.text) {
      setState(() => formErrors['confirm'] = "Passwords do not match");
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      final (response, errors) = await RecoveryService().setNewPassword(
        email: widget.identity,
        password: _passController.text.trim(),
      );
      if (errors != null) {
        ErrorService.showActionableError(
          context,
          title: errors[0],
          message: errors[1],
        );
      } else if (response != null) {
        HapticFeedback.lightImpact();
        _showSuccessSheet(context);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool passwordsMatch =
        _passController.text == _confirmPassController.text;
    final bool isNotEmpty =
        _passController.text.isNotEmpty &&
        _confirmPassController.text.isNotEmpty;

    bool allRequirementsMet =
        _has8Chars &&
        _hasUppercase &&
        _hasNumber &&
        _hasSpecialChar &&
        passwordsMatch &&
        isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(),
              const SizedBox(height: 32),
              _buildValidationCard(),
              const SizedBox(height: 24),
              _buildPasswordField(
                label: "New Password",
                fieldKey: "password",
                controller: _passController,
                hint: "••••••••",
                icon: CupertinoIcons.lock_fill,
                focusNode: _passFocus,
                onChanged: _validatePassword,
              ),
              const SizedBox(height: 20),
              _buildPasswordField(
                label: "Confirm Password",
                fieldKey: "confirm",
                controller: _confirmPassController,
                hint: "••••••••",
                icon: CupertinoIcons.checkmark_shield_fill,
                focusNode: _confirmFocus,
              ),
              const SizedBox(height: 32),
              _buildDisclaimerBox(),
              const SizedBox(height: 60),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: !allRequirementsMet
                      ? null
                      : (_isLoading ? () {} : _handleReset),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF074073),
                    disabledBackgroundColor: const Color(0xFFF1F4F8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const CupertinoActivityIndicator(color: Colors.white)
                      : Text(
                          "Update Password",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                            color: allRequirementsMet
                                ? Colors.white
                                : Colors.grey.shade400,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF074073).withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            CupertinoIcons.shield_fill,
            color: Color(0xFF074073),
            size: 28,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          "Secure Reset",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Color(0xFF074073),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Ensure your new password is unique and difficult to guess to protect your account.",
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildValidationCard() {
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
            "COMPLIANCE CHECKLIST",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: Color(0xFF074073),
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 16),
          _buildValidationTile("At least 8 characters", _has8Chars),
          _buildValidationTile("One uppercase letter (A-Z)", _hasUppercase),
          _buildValidationTile("One numeric digit (0-9)", _hasNumber),
          _buildValidationTile("One special character (!@#)", _hasSpecialChar),
        ],
      ),
    );
  }

  Widget _buildDisclaimerBox() {
    return Column(
      children: [
        _disclaimerRow(
          CupertinoIcons.info_circle,
          "Changing your password will sign you out of all other active sessions.",
        ),
        const SizedBox(height: 12),
        _disclaimerRow(
          CupertinoIcons.lock_shield,
          "Anansi uses end-to-end encryption to secure your credentials.",
        ),
      ],
    );
  }

  Widget _disclaimerRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: Icon(icon, size: 14, color: Colors.grey.shade400),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildValidationTile(String label, bool isMet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isMet
                  ? const Color(0xFF17C6C6).withValues(alpha: 0.1)
                  : Colors.transparent,
            ),
            child: Icon(
              isMet
                  ? CupertinoIcons.checkmark_circle_fill
                  : CupertinoIcons.circle,
              size: 16,
              color: isMet ? const Color(0xFF17C6C6) : Colors.grey.shade300,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isMet ? FontWeight.w700 : FontWeight.w500,
              color: isMet ? const Color(0xFF074073) : Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required String fieldKey,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required FocusNode focusNode,
    Function(String)? onChanged,
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
                    TextField(
                      focusNode: focusNode,
                      onTapOutside: (event) {
                        FocusScope.of(context).unfocus();
                      },
                      controller: controller,
                      obscureText: !_isPasswordVisible,
                      onChanged: (val) {
                        if (onChanged != null) onChanged(val);
                        if (formErrors[fieldKey] != null) {
                          setState(() => formErrors[fieldKey] = null);
                        }
                        _updateValidationStates(val);
                      },
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: TextStyle(
                          color: Colors.grey.shade300,
                          fontSize: 14,
                        ),
                        isDense: true,
                        border: InputBorder.none,
                        suffixIconConstraints: const BoxConstraints(
                          minWidth: 30,
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () => setState(
                            () => _isPasswordVisible = !_isPasswordVisible,
                          ),
                          child: Icon(
                            _isPasswordVisible
                                ? CupertinoIcons.eye_slash_fill
                                : CupertinoIcons.eye_fill,
                            size: 18,
                            color: Colors.grey.shade400,
                          ),
                        ),
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
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }

  void _showSuccessSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF17C6C6).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      CupertinoIcons.checkmark_seal_fill,
                      color: Color(0xFF17C6C6),
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  "Password Updated",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF074073),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Your account security has been successfully restored. All other active sessions have been signed out for your safety.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        CupertinoIcons.lock_shield,
                        size: 14,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Last updated: Just now",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).pushNamedAndRemoveUntil('/login', (route) => false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF074073),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Back to Login",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }
}

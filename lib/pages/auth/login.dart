// ignore_for_file: use_build_context_synchronously
import 'package:app_anansi_mobile/pages/auth/otp_access.dart';
import 'package:app_anansi_mobile/pages/continue-onboarding/continue_onboarding.dart';
import 'package:app_anansi_mobile/pages/forget-password/otp_type.dart';
import 'package:app_anansi_mobile/pages/homepage/homepage.dart';
import 'package:app_anansi_mobile/pages/membership/intro_membership.dart';
import 'package:app_anansi_mobile/pages/onboarding/introduction.dart';
import 'package:app_anansi_mobile/pages/pending-account/pending_account.dart';
import 'package:app_anansi_mobile/services/auth_service.dart';
import 'package:app_anansi_mobile/services/biometric_service.dart';
import 'package:app_anansi_mobile/services/error_service.dart';
import 'package:app_anansi_mobile/services/secure_storage_service.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Map<String, String?> formErrors = {'email': null, 'password': null};
  final FocusNode _passFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  bool _isPasswordVisible = true;
  String loginType = "Biometric";
  bool _isLoading = false;
  Future<bool>? _biometricSupportFuture;

  void clearAllErrors() => setState(() => formErrors.updateAll((k, v) => null));

  void _validateField(String key, String value) {
    setState(() {
      if (value.trim().isEmpty) {
        formErrors[key] = "This field is required to authorize access";
      } else {
        formErrors[key] = null;
      }
    });
  }

  bool get _isFormValid {
    final bool hasData =
        _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
    final bool hasNoErrors = formErrors.values.every((error) => error == null);
    return hasData && hasNoErrors && !_isLoading;
  }

  void login() async {
    if (_isLoading) return;

    _validateField('email', _emailController.text);
    _validateField('password', _passwordController.text);

    if (formErrors.values.any((e) => e != null)) {
      HapticFeedback.vibrate();
      return;
    }
    setState(() => _isLoading = true);
    try {
      final (response, error) = await AuthService().login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (error != null) {

        ErrorService.showActionableError(
          context,
          title: error[0],
          message: error[1],
        );
      } else if (response != null) {
        
        final responseInfo = response.data['data'];
        HapticFeedback.lightImpact();
        await storeUserInfo(responseInfo, context);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _biometricSupportFuture = BiometricService().canUseBiometrics();

    _emailFocus.addListener(() {
      if (!_emailFocus.hasFocus) {
        _validateField('email', _emailController.text);
      }
      setState(() {});
    });
    _passFocus.addListener(() {
      if (!_passFocus.hasFocus) {
        _validateField('password', _passwordController.text);
      }
      setState(() {});
    });
  }

  Future<void> storeUserInfo(
    Map<String, dynamic> data,
    BuildContext context,
  ) async {
    final user = data['user'];
    final tokens = data['tokens'];

    if (user != null) {
      await SecureStorageService().write("user", user);
    }
    if (tokens == null) {
      _rootNavigate(context, const OtpAccess());
    } else {
      await SecureStorageService().write("accessToken", tokens['access_token']);
      navigateBasedOnStatus(context, user);
    }
  }

  void navigateBasedOnStatus(BuildContext context, Map<String, dynamic> user) {
    final String status = user['status']?.toString().toLowerCase() ?? '';
    final String stage =
        user['onboardingStage']?.toString().toLowerCase() ?? '';
    final bool isTempPass = user['temporary_password'] ?? false;
    final bool isMember = user['member'] ?? false;
    if (status == 'active' && isTempPass) {
      // _rootNavigate(context, const CreateUsername());
      return;
    }
    if (!isMember && status == "incomplete" && stage != 'completed') {
      _replaceNavigate(context, const ContinueOnboarding());
      return;
    }
    if (!isMember && !isTempPass) {
      _rootNavigate(context, const IntroMember());
      return;
    }
    if (stage == 'completed' && status == 'pending') {
      _replaceNavigate(context, const PendingAccount());
      return;
    }
    _replaceNavigate(context, const Homepage());
  }

  void _rootNavigate(BuildContext context, Widget page) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => page),
      (_) => false,
    );
  }

  void _replaceNavigate(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Future<void> _handleAuthentication(BuildContext context) async {
    final biometricService = BiometricService();
    bool canAuth = await biometricService.canUseBiometrics();
    if (canAuth) {
      bool success = await biometricService.authenticateUser();
      if (success) {
        final user = await BiometricService().getUser();
        navigateBasedOnStatus(context, user ?? {});
      } else {
        ErrorService.showError(
          context,
          "Authentication failed. Please use your password to log in.",
        );
      }
    } else {
      _replaceNavigate(context, const Login());
    }
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _passFocus.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildBrandIdentity(),
              const SizedBox(height: 20),
              const Text(
                "Welcome Back",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AnansiColors.darkBlue,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "Please provide your authenticated credentials to access your secure wealth portal. Our multi-layered encryption ensures that your institutional-grade savings and credit assets remain protected within our vault infrastructure.",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade500,
                  height: 1.6,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.1,
                ),
              ),
              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildInputField(
                      label: "Username or Email Address",
                      controller: _emailController,
                      hint: "name@gmail.com",
                      icon: Icons.person_2_outlined,
                      fieldKey: "email",
                      focusNode: _emailFocus,
                    ),
                    const SizedBox(height: 24),
                    _buildPasswordField(
                      label: "Enter Password",
                      controller: _passwordController,
                      hint: "Enter your security key",
                      icon: CupertinoIcons.lock_shield_fill,
                      fieldKey: "password",
                      focusNode: _passFocus,
                      keyboardType: TextInputType.text,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OtpType(),
                            ),
                          );
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Color(0xFF17C6C6),
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildLoginButton(),
                    SizedBox(height: 30),
                    _buildConditionalBiometricButton(),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              _buildSignUpPrompt(),
              _buildComplianceFooter(),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConditionalBiometricButton() {
    return FutureBuilder<bool>(
      future: _biometricSupportFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.data == false) {
          return const SizedBox.shrink();
        }
        return _buildBiometricTrigger();
      },
    );
  }

  Widget _buildBiometricTrigger() {
    return FutureBuilder<IconData?>(
      future: BiometricService().getBiometricIcon(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.data == null) {
          return const SizedBox.shrink();
        }
        final IconData displayIcon = snapshot.data!;
        return GestureDetector(
          onTap: () => _handleAuthentication(context),
          child: Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(displayIcon, size: 28, color: const Color(0xFF042159)),
          ),
        );
      },
    );
  }

  Widget _buildBrandIdentity() {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AnansiColors.darkBlue,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AnansiColors.darkBlue.withValues(alpha: 0.2),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              "A",
              style: TextStyle(
                color: Color(0xFF17C6C6),
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "ANANSI",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 18,
                letterSpacing: 2,
                color: AnansiColors.darkBlue,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    final bool active = _isFormValid;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: active
                ? AnansiColors.darkBlue.withValues(alpha: 0.25)
                : Colors.transparent,
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: active ? login : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AnansiColors.darkBlue,
          disabledBackgroundColor: _isLoading
              ? AnansiColors.darkBlue
              : Colors.grey.shade300,
          foregroundColor: Colors.white,
          disabledForegroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const CupertinoActivityIndicator(color: Colors.white)
            : const Text(
                "Authorize Access",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  Widget _buildSignUpPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Not an institutional member?",
          style: TextStyle(color: Colors.grey.shade600),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Introduction()),
            );
          },
          child: const Text(
            "Register",
            style: TextStyle(
              color: AnansiColors.darkBlue,
              fontWeight: FontWeight.w800,
            ),
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

  Widget _buildPasswordField({
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
        // 1. External Label
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

        // 2. Main Input Container
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: hasError
                  ? Colors.redAccent.withValues(alpha: 0.4)
                  : const Color(0xFFE2E8F0),
              width: 1.8,
            ),
          ),
          child: Row(
            children: [
              // Icon Anchor
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

              // Vertical Separator
              Container(
                height: 24,
                width: 1.5,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                color: const Color(0xFFE2E8F0),
              ),

              // Password Field Area
              Expanded(
                child: TextField(
                  focusNode: focusNode,
                  controller: controller,
                  obscureText: _isPasswordVisible,
                  obscuringCharacter: '●',
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
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                ),
              ),

              // Show/Hide Toggle Button
              IconButton(
                onPressed: () {
                  setState(() => _isPasswordVisible = !_isPasswordVisible);
                },
                icon: Icon(
                  _isPasswordVisible
                      ? CupertinoIcons.eye_slash
                      : CupertinoIcons.eye,
                  color: isFocused
                      ? AnansiColors.darkBlue
                      : Colors.blueGrey.shade200,
                  size: 20,
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

  Widget _buildComplianceFooter() {
    return Opacity(
      opacity: 0.6,
      child: Column(
        children: [
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.security, size: 14, color: Color(0xFF17C6C6)),
              const SizedBox(width: 8),
              Text(
                "SECURED BY ANANSI PROTOCOLS",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AnansiColors.darkBlue,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

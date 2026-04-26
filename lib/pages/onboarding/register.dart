import 'package:app_anansi_mobile/helpers/format_mobile.dart';
import 'package:app_anansi_mobile/pages/auth/login.dart';
import 'package:app_anansi_mobile/pages/onboarding/verify_email.dart';
import 'package:app_anansi_mobile/services/auth_service.dart';
import 'package:app_anansi_mobile/services/error_service.dart';
import 'package:app_anansi_mobile/services/onboarding_service.dart';
import 'package:app_anansi_mobile/services/secure_storage_service.dart';
import 'package:app_anansi_mobile/state/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isChecked = false;
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  Map<String, dynamic> user = {};
  Map<String, String?> formErrors = {
    'email': null,
    'password': null,
    "username": null,
    "mobile": null,
    "confirmPassword": null,
  };
  final FocusNode _passFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _mobileFocus = FocusNode();
  final FocusNode _confirmPassFocus = FocusNode();

  void _validateUsername(String value) {
    setState(() {
      if (value.isEmpty) {
        formErrors['username'] = "Username is required";
      } else if (value.length < 3) {
        formErrors['username'] = "Too short";
      } else {
        formErrors['username'] = null;
      }
    });
  }

  // 2. Email: Standard RFC format
  void _validateEmail(String value) {
    setState(() {
      final bool emailValid = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
      ).hasMatch(value);
      if (value.isEmpty) {
        formErrors['email'] = "Email address is required";
      } else if (!emailValid) {
        formErrors['email'] = "Please enter a valid email address";
      } else {
        formErrors['email'] = null;
      }
    });
  }

  // 3. Phone: Kenyan format (07... or +254...)
  void _validatePhone(String value) {
    setState(() {
      // Matches 07XXXXXXXX, 01XXXXXXXX, or +254...
      final bool phoneValid = RegExp(
        r'^(?:254|\+254|0)?(7|1)(?:[0-9]){8}$',
      ).hasMatch(value);
      if (value.isEmpty) {
        formErrors['mobile'] = "Mobile number is required";
      } else if (!phoneValid) {
        formErrors['mobile'] = "Enter a valid Kenyan mobile number";
      } else {
        formErrors['mobile'] = null;
      }
    });
  }

  // 4. Password: Min 8 chars, 1 Letter, 1 Number
  void _validatePassword(String value) {
    setState(() {
      bool hasUppercase = value.contains(RegExp(r'[A-Z]'));
      bool hasDigits = value.contains(RegExp(r'[0-9]'));

      if (value.isEmpty) {
        formErrors['password'] = "Secure your account with a password";
      } else if (value.length < 8) {
        formErrors['password'] = "Password must be at least 8 characters";
      } else if (!hasUppercase || !hasDigits) {
        formErrors['password'] =
            "Include at least one capital letter and a number";
      } else {
        formErrors['password'] = null;
      }

      // Always re-validate confirm password if it's not empty
      if (_confirmPasswordController.text.isNotEmpty) {
        _validateConfirmPassword(_confirmPasswordController.text);
      }
    });
  }

  // 5. Confirm Password: Must match _passwordController
  void _validateConfirmPassword(String value) {
    setState(() {
      if (value.isEmpty) {
        formErrors['confirmPassword'] = "Please confirm your password";
      } else if (value != _passwordController.text) {
        formErrors['confirmPassword'] = "Passwords do not match";
      } else {
        formErrors['confirmPassword'] = null;
      }
    });
  }

  @override
  void initState() {
    super.initState();

    // Username Listener
    _usernameFocus.addListener(() {
      if (!_usernameFocus.hasFocus) {
        _validateUsername(_usernameController.text);
      }
    });

    // Email Listener
    _emailFocus.addListener(() {
      if (!_emailFocus.hasFocus) {
        _validateEmail(_emailController.text);
      }
    });

    // Phone Listener
    _mobileFocus.addListener(() {
      if (!_mobileFocus.hasFocus) {
        _validatePhone(_phoneController.text);
      }
    });

    // Password Listener
    _passFocus.addListener(() {
      if (!_passFocus.hasFocus) {
        _validatePassword(_passwordController.text);
      }
    });

    // Confirm Password Listener
    _confirmPassFocus.addListener(() {
      if (!_confirmPassFocus.hasFocus) {
        _validateConfirmPassword(_confirmPasswordController.text);
      }
    });
  }

  bool _isEverythingValid() {
    // 1. Username: 3+ characters
    final bool isUsernameValid = _usernameController.text.trim().length >= 3;

    // 2. Email: Simple Regex check
    final bool isEmailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(_emailController.text.trim());

    // 3. Phone: Kenyan Format (7 or 1 prefix + 8 digits)
    final bool isPhoneValid = RegExp(
      r'^(?:254|\+254|0)?(7|1)(?:[0-9]){8}$',
    ).hasMatch(_phoneController.text.trim());

    // 4. Password: Min 8 chars + 1 Uppercase + 1 Number
    final String pass = _passwordController.text;
    final bool isPasswordSecure =
        pass.length >= 8 &&
        pass.contains(RegExp(r'[A-Z]')) &&
        pass.contains(RegExp(r'[0-9]'));

    // 5. Match & Agreement
    final bool passwordsMatch = pass == _confirmPasswordController.text;
    final bool hasAgreed = _isChecked;

    // Final aggregate check
    return isUsernameValid &&
        isEmailValid &&
        isPhoneValid &&
        isPasswordSecure &&
        passwordsMatch &&
        hasAgreed;
  }

  void createProfile() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final (response, errors) = await OnboardingService().createProfile(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        username: _usernameController.text.trim(),
        phoneNumber: formatToKenyanPhone(_phoneController.text.trim()) ?? "",
      );
      if (errors != null) {
        ErrorService.showActionableError(
          context,
          title: errors[0],
          message: errors[1],
        );
      } else if (response != null) {
        await login();
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> login() async {
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
      HapticFeedback.lightImpact();
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final responseInfo = response.data['data'];
      authProvider.setUser(responseInfo['user'] ?? {});
      final tokens = responseInfo['tokens'];
      print(tokens);
      await SecureStorageService().write("accessToken", tokens['access_token']);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const VerifyEmail()),
      );
    }
  }

  @override
  void dispose() {
    _usernameFocus.dispose();
    _emailFocus.dispose();
    _mobileFocus.dispose();
    _passFocus.dispose();
    _confirmPassFocus.dispose();

    _usernameFocus.dispose();
    _emailFocus.dispose();
    _mobileFocus.dispose();
    _passFocus.dispose();
    _confirmPassFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool canSubmit = _isEverythingValid();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              const Text(
                "Create & Verify Profile",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AnansiColors.darkBlue,
                  letterSpacing: -1.5,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Create your Anansi profile today to manage your assets and track your financial progress.",
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 15,
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 15),
              _buildSectionLabel("PROFILE INFORMATION"),
              const SizedBox(height: 10),
              _buildInputField(
                label: "Username",
                hint: "Your unique username",
                controller: _usernameController,
                icon: Icons.person_2_outlined,
                fieldKey: "username",
                focusNode: _usernameFocus,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                label: "Email Address",
                hint: "name@example.com",
                controller: _emailController,
                icon: Icons.alternate_email_rounded,
                fieldKey: "email",
                focusNode: _emailFocus,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                label: "Phone Number",
                controller: _phoneController,
                hint: "e.g 0712345678",
                icon: CupertinoIcons.phone_fill,
                fieldKey: "mobile",
                focusNode: _mobileFocus,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 26),
              _buildSectionLabel("SECURE YOUR PROFILE"),
              const SizedBox(height: 10),
              _buildPasswordField(
                label: "Create Password",
                controller: _passwordController,
                hint: "Enter your security key",
                icon: CupertinoIcons.lock_shield_fill,
                fieldKey: "password",
                focusNode: _passFocus,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 16),
              _buildPasswordField(
                label: "Confirm Password",
                controller: _confirmPasswordController,
                hint: "Repeat your security key",
                icon: CupertinoIcons.lock_shield_fill,
                fieldKey: "confirmPassword",
                focusNode: _confirmPassFocus,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 32),
              _buildAgreementSection(),
              const SizedBox(height: 30),
              _buildPremiumSubmit(canSubmit),
              const SizedBox(height: 12),
              _buildSignInFooter(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.5,
        color: Color(0xFFBDBDBD),
      ),
    );
  }

  // YOUR REQUESTED BUILD INPUT
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
                    fontWeight: FontWeight.w700,
                    color: AnansiColors.darkBlue,
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
              if (controller.text.isNotEmpty && !hasError)
                const Icon(
                  CupertinoIcons.checkmark_circle_fill,
                  color: Colors.teal,
                  size: 18,
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
                  obscureText: _isPasswordVisible, // The logic for hiding text
                  obscuringCharacter: '●', // Premium look for password dots
                  keyboardType: keyboardType,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AnansiColors.darkBlue,
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
                  _isPasswordVisible ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                  color: isFocused
                      ? AnansiColors.darkBlue
                      : Colors.blueGrey.shade200,
                  size: 20,
                ),
              ),
            ],
          ),
        ),

        // 3. Error Area
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

  Widget _buildAgreementSection() {
    return GestureDetector(
      onTap: () => setState(() => _isChecked = !_isChecked),
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: SizedBox(
              height: 18,
              width: 18,
              child: Checkbox(
                value: _isChecked,
                activeColor: AnansiColors.darkBlue,
                side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                onChanged: (val) => setState(() => _isChecked = val ?? false),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: TextStyle(
                  color: Colors.blueGrey.shade400,
                  fontSize: 12,
                  height: 1.4,
                ),
                children: [
                  const TextSpan(text: "I acknowledge and agree to the "),
                  TextSpan(
                    text: "Privacy Policy",
                    style: const TextStyle(
                      color: AnansiColors.darkBlue,
                      fontWeight: FontWeight.w900,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => _showPrivacyPolicy(context),
                  ),
                  const TextSpan(
                    text: " and the terms & conditions of Anansi SACCO.",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumSubmit(bool isValid) {
    return ElevatedButton(
      // When isValid is false, onPressed is null, disabling the button
      onPressed: isValid ? createProfile : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: AnansiColors.darkBlue,
        foregroundColor: Colors.white,
        // This is the color used when onPressed is null
        disabledBackgroundColor: Colors.grey.shade200,
        // This is the text color when disabled
        disabledForegroundColor: Colors.grey.shade500,
        minimumSize: const Size(double.infinity, 64),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        // Premium touch: only show elevation/shadow when the form is valid
        elevation: isValid ? 4 : 0,
        shadowColor: AnansiColors.darkBlue.withValues(alpha: 0.3),
      ),
      child: _isLoading
          ? const CupertinoActivityIndicator(color: Colors.white)
          : Text(
              "CREATE PROFILE",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 14,
                letterSpacing: 1.5,
                // Ensure the text looks "muted" when disabled
                color: isValid ? Colors.white : Colors.grey.shade500,
              ),
            ),
    );
  }

  Widget _buildSignInFooter() {
    return Center(
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        ),
        child: Text.rich(
          TextSpan(
            style: const TextStyle(color: Colors.grey, fontSize: 14),
            children: [
              const TextSpan(text: "Already a member? "),
              TextSpan(
                text: "Sign In",
                style: TextStyle(
                  color: AnansiColors.darkBlue,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.96,
          builder: (_, controller) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // Modern Drag Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  // Premium Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Legal & Privacy",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: AnansiColors.darkBlue,
                          letterSpacing: -0.5,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 20,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 32),

                  // Content Area
                  Expanded(
                    child: ListView(
                      controller: controller,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        Text(
                          "Anansi SACCO Privacy Protocol",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
                            color: const Color(
                              0xFF17C6C6,
                            ).withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildPremiumParagraph(
                          "Anansi SACCO (“we,” “our,” or “us”) values the privacy of our users. This Privacy Policy explains how we collect, use, disclose, and protect your personal information when you use our mobile application. By accessing the App, you agree to the collection and use of information in accordance with this Privacy Policy.",
                        ),
                        const SizedBox(height: 32),

                        _buildPremiumSection("1. Information Intelligence", [
                          "Personal Identity: Full Name, Email, Phone, DOB, and KYC documentation.",
                          "Financial Data: Bank account details, savings patterns, and loan history.",
                          "Technical Footprint: Device type, IP Address, and OS versioning.",
                          "Geolocation: Precision data to provide location-based services.",
                          "Tracking: Secure cookies to enhance user session performance.",
                        ]),

                        _buildPremiumSection("2. Purpose of Processing", [
                          "Execution of financial transactions and account management.",
                          "Personalization of the wealth-engineering experience.",
                          "Compliance with regulatory KYC and AML legal obligations.",
                          "Continuous optimization of the Anansi digital infrastructure.",
                        ]),

                        _buildPremiumSection("3. Data Sovereignty", [
                          "We do not sell user data. Sharing occurs only with verified partners to deliver core services or comply with legal mandates.",
                        ]),

                        _buildPremiumSection("4. Security Measures", [
                          "We utilize industry-leading encryption and secure firewalls. While we implement rigorous safeguards, no digital transmission is 100% immune.",
                        ]),

                        _buildPremiumSection("Contact Protocols", [
                          "ANANSI SACCO Headquarters",
                          "Email: anansisacco@gmail.com",
                          "Location: Ngong Lane Plaza, Nairobi, Kenya",
                        ]),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),

                  // Bottom Action
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AnansiColors.darkBlue,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "I UNDERSTAND",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPremiumParagraph(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 15,
        height: 1.6,
        color: Colors.grey.shade700,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildPremiumSection(String title, List<String> points) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: AnansiColors.darkBlue,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 12),
          ...points.map(
            (p) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF17C6C6),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      p,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

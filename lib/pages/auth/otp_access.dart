import 'dart:async';
import 'dart:convert';
import 'package:app_anansi_mobile/pages/continue-onboarding/continue_onboarding.dart';
import 'package:app_anansi_mobile/pages/homepage/homepage.dart';
import 'package:app_anansi_mobile/pages/membership/intro_membership.dart';
import 'package:app_anansi_mobile/pages/pending-account/pending_account.dart';
import 'package:app_anansi_mobile/services/auth_service.dart';
import 'package:app_anansi_mobile/services/error_service.dart';
import 'package:app_anansi_mobile/services/secure_storage_service.dart';
import 'package:app_anansi_mobile/state/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:app_anansi_mobile/components/otp_boxes.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class OtpAccess extends StatefulWidget {
  const OtpAccess({super.key});

  @override
  State<OtpAccess> createState() => _OtpAccessState();
}

class _OtpAccessState extends State<OtpAccess> {
  final _controller = TextEditingController();
  final _focus = FocusNode();
  Timer? _timer;
  int _secondsRemaining = 59;
  String? _errorText;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _startTimer();

    _controller.addListener(() {
      if (_errorText != null) {
        setState(() => _errorText = null);
      }
      setState(() {});
    });
  }

  bool get _isOtpReady => _controller.text.length == 6 && !_isLoading;

  void _startTimer() {
    _secondsRemaining = 59;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_secondsRemaining > 0) {
            _secondsRemaining--;
          } else {
            _timer?.cancel();
          }
        });
      }
    });
  }

  void _verifyLogin() async {
    if (!_isOtpReady) return;

    setState(() {
      _isLoading = true;
      _errorText = null;
    });
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final (response, error) = await AuthService().verifyLogin(
        email: authProvider.user?['email'],
        oneTimePassword: _controller.text.trim(),
        mobile: authProvider.user?['mobileno'],
        customerId: authProvider.user?['id'],
      );
      if (error != null) {
        ErrorService.showActionableError(
          context,
          title: error[0],
          message: error[1],
        );
      } else if (response != null) {
        HapticFeedback.lightImpact();
        final responseInfo = response.data['data'] ?? {};
        await storeUserInfo(responseInfo);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<Map<String, dynamic>?> getUser() async {
    String? userJson = await SecureStorageService().read('user');
    if (userJson == null) return null;
    Map<String, dynamic> userMap = jsonDecode(userJson);
    return userMap;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> storeUserInfo(Map<String, dynamic> responseInfo) async {
    if (!mounted) return;

    final String token = responseInfo['tokens']?['access_token'] ?? "";
    await SecureStorageService().write("accessToken", token);

    final user = await getUser();
    if (user == null) return;

    final String status = user['status']?.toString().toLowerCase() ?? "";
    final String stage =
        user['onboardingStage']?.toString().toLowerCase() ?? "";
    final bool isMember = user['member'] == true;
    final bool isTempPass = user['temporary_password'] == true;
    final bool isOnboarded = stage == 'completed';
    if (status == 'active' && isTempPass) {
      return;
    }
    if (isOnboarded && !isMember && !isTempPass) {
      _navigateTo(const IntroMember());
      return;
    }
    if (isOnboarded && status == 'pending') {
      _navigateTo(const PendingAccount());
      return;
    }
    if (!isMember && status == "incomplete" && !isOnboarded) {
      _navigateTo(const ContinueOnboarding());
      return;
    }
    _navigateTo(const Homepage());
  }

  void _navigateTo(Widget page) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => page),
      (route) => false,
    );
  }

  void _resendOtp() async {
    _controller.clear();
    _startTimer();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final (response, errors) = await AuthService().sendMobileOtp(
      userId: authProvider.user?['id'],
    );
    if (errors != null) {
      ErrorService.showActionableError(
        context,
        title: errors[0],
        message: errors[1],
      );
      return;
    } else if (response != null) {
      if (mounted) {
        ErrorService.showProgressiveResponse(
          context,
          "A new code has been sent to your phone",
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildIconHeader(),
                    const SizedBox(height: 10),
                    const Text(
                      "Verify your phone",
                      style: TextStyle(
                        color: AnansiColors.darkBlue,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1.0,
                      ),
                    ),
                    const SizedBox(height: 5),
                    _buildMobileDescription(),
                    const SizedBox(height: 40),
                    OtpBoxes(
                      controller: _controller,
                      focusNode: _focus,
                      onCompleted: (_) => () {},
                    ),
                    const SizedBox(height: 20),
                    _buildResendLogic(),
                    const SizedBox(height: 20),
                    _buildInstitutionalDisclaimer(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            _buildFixedBottomAction(),
          ],
        ),
      ),
    );
  }

  Widget _buildIconHeader() {
    return Container(
      height: 64,
      width: 64,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F4F8)),
      ),
      child: const Icon(
        CupertinoIcons.phone,
        color: AnansiColors.darkBlue,
        size: 28,
      ),
    );
  }

  Widget _buildMobileDescription() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "We've sent a 6-digit verification code to the mobile number ${authProvider.user?['mobileno'] ?? "0700000000"}. Please check your messages.",
          style: TextStyle(
            color: Colors.blueGrey.shade400,
            fontSize: 15,
            height: 1.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Trouble receiving the code?",
                style: TextStyle(
                  color: Color(0xFF17C6C6),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                CupertinoIcons.question_circle_fill,
                size: 14,
                color: const Color(0xFF17C6C6).withValues(alpha: 0.8),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResendLogic() {
    return Row(
      children: [
        Text(
          "Didn't receive an SMS?",
          style: TextStyle(
            color: Colors.blueGrey.shade400,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        _secondsRemaining > 0
            ? Text(
                "Retry in ${_secondsRemaining}s",
                style: const TextStyle(
                  color: AnansiColors.darkBlue,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              )
            : GestureDetector(
                onTap: _resendOtp,
                child: const Text(
                  "Resend Code",
                  style: TextStyle(
                    color: Color(0xFF17C6C6),
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
      ],
    );
  }

  Widget _buildInstitutionalDisclaimer() {
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
          const Row(
            children: [
              Icon(
                CupertinoIcons.lock_shield_fill,
                size: 16,
                color: AnansiColors.darkBlue,
              ),
              SizedBox(width: 10),
              Text(
                "SECURITY NOTICE",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  color: AnansiColors.darkBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "For your security, never share your verification code with anyone. Anansi staff will never ask for this code via phone call or SMS.",
            style: TextStyle(
              color: Colors.blueGrey.shade400,
              fontSize: 12,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFixedBottomAction() {
    final bool active = _isOtpReady;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 20),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_errorText != null) ...[
            Text(
              _errorText!,
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
          ],
          ElevatedButton(
            onPressed: active ? _verifyLogin : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AnansiColors.darkBlue,
              // Keep blue background while loading so loader is visible
              disabledBackgroundColor: _isLoading
                  ? AnansiColors.darkBlue
                  : Colors.grey.shade200,
              foregroundColor: Colors.white,
              disabledForegroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 64),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
            ),
            child: _isLoading
                ? const CupertinoActivityIndicator(color: Colors.white)
                : const Text(
                    "VERIFY MOBILE NUMBER",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                      fontSize: 14,
                    ),
                  ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.checkmark_seal_fill,
                size: 14,
                color: Colors.grey.shade300,
              ),
              const SizedBox(width: 8),
              Text(
                "ENCRYPTED BY ANANSI PROTOCOLS",
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: Colors.grey.shade400,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

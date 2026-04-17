import 'dart:async';
import 'package:app_anansi_mobile/pages/onboarding/account_success.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:app_anansi_mobile/components/otp_boxes.dart';

class VerifyMobile extends StatefulWidget {
  final String phoneNumber;
  const VerifyMobile({super.key, this.phoneNumber = "+254 700 000 000"});

  @override
  State<VerifyMobile> createState() => _VerifyMobileState();
}

class _VerifyMobileState extends State<VerifyMobile> {
  final _controller = TextEditingController();
  final _focus = FocusNode();
  Timer? _timer;
  int _secondsRemaining = 59;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

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

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _focus.dispose();
    super.dispose();
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "We've sent a 6-digit verification code to the mobile number ${widget.phoneNumber}. Please check your messages.",
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
            Navigator.pop(context); // Go back to change number
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Want to change your number?",
                style: TextStyle(
                  color: Color(0xFF17C6C6),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                CupertinoIcons.create,
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
                onTap: _startTimer,
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
              const Text(
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
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 20),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountSuccess()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AnansiColors.darkBlue,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 64),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
            ),
            child: const Text(
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

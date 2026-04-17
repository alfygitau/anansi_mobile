import 'dart:async';
import 'package:app_anansi_mobile/pages/onboarding/verify_mobile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:app_anansi_mobile/components/otp_boxes.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
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
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 32),
              const Text(
                "ANANSI",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                  fontSize: 24,
                  color: AnansiColors.darkBlue,
                ),
              ),
              const SizedBox(height: 64),
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDFA),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: const Icon(
                        Icons.mail_outline_rounded,
                        color: AnansiColors.darkBlue,
                        size: 32,
                      ),
                    ),
                    Positioned(
                      top: -6,
                      right: -6,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF17C6C6),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: const Icon(
                          Icons.shield_outlined,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                "Check your inbox",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AnansiColors.darkBlue,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              _buildEmailDescription(),
              const SizedBox(height: 50),
              OtpBoxes(
                controller: _controller,
                focusNode: _focus,
                onCompleted: (_) => () {},
              ),
              const SizedBox(height: 50),
              _buildContinueButton(),
              const SizedBox(height: 32),
              _buildResendLogic(),
              const SizedBox(height: 64),
              _buildSecurityFooter(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailDescription() {
    return Column(
      children: [
        Text(
          "We've sent a 6-digit verification code to",
          style: TextStyle(color: Colors.grey.shade500, fontSize: 15),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "email@example.com",
              style: const TextStyle(
                color: AnansiColors.darkBlue,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {},
              child: const Icon(
                CupertinoIcons.create,
                size: 20,
                color: Color(0xFF17C6C6),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VerifyMobile()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AnansiColors.darkBlue,
        foregroundColor: Colors.white,
        disabledBackgroundColor: Colors.grey.shade200,
        minimumSize: const Size(double.infinity, 64),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "CONTINUE",
            style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2),
          ),
          SizedBox(width: 8),
          Icon(Icons.arrow_forward_rounded, size: 20),
        ],
      ),
    );
  }

  Widget _buildResendLogic() {
    return _secondsRemaining > 0
        ? Text(
            "RESEND CODE IN ${_secondsRemaining}S",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              color: Colors.grey.shade400,
            ),
          )
        : TextButton.icon(
            onPressed: () {
              setState(() => _startTimer());
            },
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: const Text(
              "RESEND VERIFICATION CODE",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF17C6C6),
            ),
          );
  }

  Widget _buildSecurityFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shield_rounded, size: 14, color: Colors.grey.shade300),
          const SizedBox(width: 8),
          Text(
            "SECURED BY ANANSI PROTOCOLS",
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}

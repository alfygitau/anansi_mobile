import 'dart:async';
import 'package:app_anansi_mobile/pages/onboarding/account_success.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:app_anansi_mobile/components/otp_boxes.dart';

class VerifyMobile extends StatefulWidget {
  const VerifyMobile({super.key});

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
    _controller.dispose();
    _focus.dispose();
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
                        CupertinoIcons.device_phone_portrait,
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
                          Icons.check_circle_outline_rounded,
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
                "Verify Mobile Number",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AnansiColors.darkBlue,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              _buildMobileDescription(),
              const SizedBox(height: 50),
              OtpBoxes(
                controller: _controller,
                focusNode: _focus,
                onCompleted: (code) {},
              ),

              const SizedBox(height: 50),
              _buildContinueButton(),
              const SizedBox(height: 32),
              _buildResendLogic(),
              const SizedBox(height: 65),
              _buildSecurityFooter(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileDescription() {
    return Column(
      children: [
        Text(
          "We've sent a 6-digit SMS code to",
          style: TextStyle(color: Colors.grey.shade500, fontSize: 15),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "0769404436",
              style: const TextStyle(
                color: AnansiColors.darkBlue,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                CupertinoIcons.create,
                size: 22,
                color: Color(0xFF17C6C6),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AnansiColors.darkBlue.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AccountSuccess()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AnansiColors.darkBlue,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.shade200,
          minimumSize: const Size(double.infinity, 64),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "VERIFY & PROCEED",
              style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward_rounded, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildResendLogic() {
    return _secondsRemaining > 0
        ? Text(
            "RESEND SMS IN ${_secondsRemaining}S",
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
              // Add resend SMS logic here
            },
            icon: const Icon(Icons.textsms_outlined, size: 16),
            label: const Text(
              "RESEND SECURITY CODE",
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
          Icon(
            Icons.lock_outline_rounded,
            size: 14,
            color: Colors.grey.shade300,
          ),
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

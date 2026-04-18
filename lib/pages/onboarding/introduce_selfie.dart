import 'dart:io';
import 'package:app_anansi_mobile/pages/onboarding/selfie_preview.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class IntroduceSelfie extends StatefulWidget {
  const IntroduceSelfie({super.key});

  @override
  State<IntroduceSelfie> createState() => _IntroduceSelfieState();
}

class _IntroduceSelfieState extends State<IntroduceSelfie> {
  final ImagePicker _picker = ImagePicker();

  Future<File?> captureSelfie() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        imageQuality: 90,
      );
      if (photo != null) {
        return File(photo.path);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  void _continue() async {
    final File? capturedFile = await captureSelfie();
    if (capturedFile != null && mounted) {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => SelfiePreview(imageFile: capturedFile),
        ),
      );
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
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    _buildBrandHeader(context),
                    const SizedBox(height: 20),
                    _buildStepHeader(),
                    const SizedBox(height: 10),
                    _buildLivenessIllustration(),
                    const SizedBox(height: 20),
                    _buildRequirementItem(
                      icon: CupertinoIcons.sun_max,
                      text: "Optimal Lighting",
                      description:
                          "Find a spot with clear, even lighting. Avoid strong backlighting or deep shadows on your face.",
                    ),
                    _buildRequirementItem(
                      icon: CupertinoIcons.person_crop_circle_badge_checkmark,
                      text: "Clear Visibility",
                      description:
                          "Please remove any glasses, masks, or hats. Your entire face must be visible within the frame.",
                    ),
                    _buildRequirementItem(
                      icon: CupertinoIcons.device_phone_portrait,
                      text: "Eye Level Positioning",
                      description:
                          "Hold your phone at eye level and keep a neutral expression until the scan is complete.",
                    ),
                    _buildPrivacyDisclaimer(),
                    const SizedBox(height: 22),
                  ],
                ),
              ),
            ),
            _buildActionDock(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AnansiColors.darkBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  "A",
                  style: TextStyle(
                    color: Color(0xFF17C6C6),
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "ONBOARDING",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                    letterSpacing: 1.5,
                    color: AnansiColors.darkBlue,
                  ),
                ),
                Text(
                  "Selfie Capture",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              CupertinoIcons.xmark,
              size: 18,
              color: AnansiColors.darkBlue,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Face Verification",
          style: TextStyle(
            color: AnansiColors.darkBlue,
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          "To secure your account, we need to perform a quick liveness check. This ensures that you are a real person and matches you to your identification.",
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 15,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildLivenessIllustration() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF17C6C6).withValues(alpha: 0.03),
            ),
          ),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF17C6C6).withValues(alpha: 0.05),
              border: Border.all(
                color: const Color(0xFF17C6C6).withValues(alpha: 0.1),
                width: 1,
              ),
            ),
          ),
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF17C6C6).withValues(alpha: 0.2),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                CupertinoIcons.person_fill,
                size: 50,
                color: AnansiColors.darkBlue,
              ),
            ),
          ),
          Positioned(
            right: 40,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: AnansiColors.darkBlue,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                CupertinoIcons.viewfinder,
                color: Color(0xFF17C6C6),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementItem({
    required IconData icon,
    required String text,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        // Thin, crisp border for that "Institutional" feel
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // The Refined Icon Anchor
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9), // Slate 100
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: AnansiColors.darkBlue, // Darker icon for more authority
              size: 20,
            ),
          ),
          const SizedBox(width: 16),

          // Detailed Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    color: AnansiColors.darkBlue,
                    fontWeight: FontWeight.w900, // Heavy weight for headlines
                    fontSize: 15,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.blueGrey.shade400,
                    fontSize: 12,
                    height: 1.6,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyDisclaimer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFDE7E7).withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                CupertinoIcons.shield_fill,
                size: 14,
                color: Color(0xFFFF5757),
              ),
              const SizedBox(width: 8),
              Text(
                "BIOMETRIC DATA CONSENT",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: Colors.grey.shade500,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "By continuing, you consent to HELACRED LIMITED processing your facial biometric data to verify your identity. Data is encrypted and managed according to the Data Protection Act (2019).",
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionDock(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
      decoration: BoxDecoration(color: Colors.white),
      child: ElevatedButton(
        onPressed: () {
          _continue();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AnansiColors.darkBlue,
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
              "CONTINUE TO CAMERA",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

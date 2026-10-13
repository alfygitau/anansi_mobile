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
        preferredCameraDevice: CameraDevice.front,
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
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              pinned: true,
              floating: false,
              backgroundColor: Colors.white,
              surfaceTintColor:
                  Colors.transparent, // Prevents M3 scroll overlay tint
              elevation: 0,
              scrolledUnderElevation: 0,
              automaticallyImplyLeading: false,
              titleSpacing: 24,
              centerTitle: false,
              title: const Text(
                "Verify Identity",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AnansiColors.darkBlue,
                  letterSpacing: -1.5,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    _buildStepHeader(),
                    const SizedBox(height: 20),
                    _buildLivenessIllustration(),
                    const SizedBox(height: 10),
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
                    const SizedBox(height: 12),
                    _buildPrivacyDisclaimer(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Fixed Bottom Docked Action
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 25),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.95)),
        child: _buildActionDock(context),
      ),
    );
  }

  Widget _buildStepHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Face Verification",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AnansiColors.darkBlue,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "To secure your account, we need to perform a quick liveness check. This ensures that you are a real person and matches you to your identification.",
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.5,
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
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF17C6C6).withValues(alpha: 0.03),
            ),
          ),
          Container(
            width: 110,
            height: 110,
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
            width: 80,
            height: 80,
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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AnansiColors.darkBlue, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    color: AnansiColors.darkBlue,
                    fontWeight: FontWeight.w900,
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
            "By continuing, you consent to HELACRED LIMITED processing your facial biometric data to verify your identity. Data is encrypted and managed according to the Data Protection Act.",
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
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: ElevatedButton(
        onPressed: _continue,
        style: ElevatedButton.styleFrom(
          backgroundColor: AnansiColors.darkBlue,
          foregroundColor: Colors.white,
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
                fontSize: 13,
              ),
            ),
            SizedBox(width: 10),
            Icon(CupertinoIcons.camera_fill, size: 18),
          ],
        ),
      ),
    );
  }
}

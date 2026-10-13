import 'dart:convert';
import 'dart:io';
import 'package:app_anansi_mobile/pages/onboarding/personal_information.dart';
import 'package:app_anansi_mobile/services/error_service.dart';
import 'package:app_anansi_mobile/services/ocr_service.dart';
import 'package:app_anansi_mobile/services/secure_storage_service.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SelfiePreview extends StatefulWidget {
  final File imageFile;

  const SelfiePreview({super.key, required this.imageFile});

  @override
  State<SelfiePreview> createState() => _SelfiePreviewState();
}

class _SelfiePreviewState extends State<SelfiePreview> {
  bool _isLoading = false;

  Future<Map<String, dynamic>?> getUser() async {
    String? userJson = await SecureStorageService().read('user');
    if (userJson == null) return null;
    Map<String, dynamic> userMap = jsonDecode(userJson);
    return userMap;
  }

  void uploadFile() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final user = await getUser();
      final (response, errors) = await OcrService().uploadSelfie(
        file: widget.imageFile,
        id: user?['id'] ?? "",
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
          MaterialPageRoute(builder: (context) => const PersonalInformation()),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
            // Pinned Header Bar
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

            // Scrollable Body Content
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    _buildStepHeader(),
                    const SizedBox(height: 24),
                    Center(child: _buildBiometricPreview()),
                    const SizedBox(height: 28),
                    Text(
                      "BEFORE YOU PROCEED",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                        color: AnansiColors.darkBlue.withValues(alpha: 0.4),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildVerificationChecklist(),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Fixed Bottom Docked Actions
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
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
          "Confirm Facial Scan",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AnansiColors.darkBlue,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Please ensure your face is well-lit and centered within the frame. This scan will be matched against your ID portrait to finalize verification.",
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

  Widget _buildBiometricPreview() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 280,
          height: 280,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF17C6C6).withValues(alpha: 0.05),
          ),
        ),
        Container(
          width: 250,
          height: 250,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF17C6C6), width: 3),
            boxShadow: [
              BoxShadow(
                color: AnansiColors.darkBlue.withValues(alpha: 0.15),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.file(
              widget.imageFile,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade50,
                  child: Center(
                    child: Icon(
                      CupertinoIcons.person_crop_circle_badge_exclam,
                      color: Colors.grey.shade400,
                      size: 48,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const Positioned(
          top: 10,
          left: 10,
          child: Icon(
            CupertinoIcons.viewfinder,
            color: Color(0xFF17C6C6),
            size: 40,
          ),
        ),
      ],
    );
  }

  Widget _buildVerificationChecklist() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailedCheckItem(
            title: "Sharp Focus & Centered",
            subtitle:
                "Confirm your face is centered within the frame and free from motion blur.",
            icon: CupertinoIcons.scope,
          ),
          _buildDivider(),
          _buildDetailedCheckItem(
            title: "Clear Facial Features",
            subtitle:
                "Ensure your eyes are open and no glasses, hats, or masks obscure your face.",
            icon: CupertinoIcons.eye,
          ),
          _buildDivider(),
          _buildDetailedCheckItem(
            title: "Balanced Lighting",
            subtitle:
                "Check that there are no strong backlights or deep shadows falling on your face.",
            icon: CupertinoIcons.brightness,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedCheckItem({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF17C6C6).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF17C6C6), size: 18),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AnansiColors.darkBlue,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Divider(color: Colors.grey.shade100, height: 1, indent: 48),
    );
  }

  Widget _buildActionDock(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: double.infinity,
          height: 64,
          child: ElevatedButton(
            onPressed: _isLoading ? null : uploadFile,
            style: ElevatedButton.styleFrom(
              backgroundColor: AnansiColors.darkBlue,
              foregroundColor: Colors.white,
              disabledBackgroundColor: AnansiColors.darkBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
            ),
            child: _isLoading
                ? const CupertinoActivityIndicator(color: Colors.white)
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "SUBMIT BIOMETRIC SCAN",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward_rounded, size: 18),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 14),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          behavior: HitTestBehavior.opaque,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.refresh,
                size: 14,
                color: Colors.grey.shade400,
              ),
              const SizedBox(width: 8),
              Text(
                "RETAKE SELFIE",
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w900,
                  fontSize: 11,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

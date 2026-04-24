import 'dart:io';
import 'package:app_anansi_mobile/pages/onboarding/personal_information.dart';
import 'package:app_anansi_mobile/services/error_service.dart';
import 'package:app_anansi_mobile/services/ocr_service.dart';
import 'package:app_anansi_mobile/services/onboarding_service.dart';
import 'package:app_anansi_mobile/state/auth_provider.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelfiePreview extends StatefulWidget {
  final File imageFile;

  const SelfiePreview({super.key, required this.imageFile});

  @override
  State<SelfiePreview> createState() => _SelfiePreviewState();
}

class _SelfiePreviewState extends State<SelfiePreview> {
  bool _isLoading = false;

  void uploadFile() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final (response, errors) = await OcrService().uploadSingleFile(
        file: widget.imageFile,
      );
      if (errors != null) {
        ErrorService.showActionableError(
          context,
          title: errors[0],
          message: errors[1],
        );
      } else if (response != null) {
        final String url = response.data['data']['url'] ?? "";
        await updateCustomerSelfie(url);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> updateCustomerSelfie(String url) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final (response, errors) = await OnboardingService().updateSelfie(
      id: authProvider.user?['id'] ?? "",
      url: url,
    );
    if (errors != null) {
      ErrorService.showActionableError(
        context,
        title: errors[0],
        message: errors[1],
      );
    } else if (response != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PersonalInformation()),
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
                  children: [
                    const SizedBox(height: 10),
                    _buildStepHeader(),
                    const SizedBox(height: 22),
                    _buildBiometricPreview(),
                    const SizedBox(height: 22),
                    _buildVerificationChecklist(),
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

  Widget _buildStepHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          "Verify Identity",
          style: TextStyle(
            color: AnansiColors.darkBlue,
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          "Please ensure your face is well-lit and centered within the frame. The system will compare this biometric scan against the portrait on your government-issued ID to securely finalize your identity verification.",
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 15,
            height: 1.6,
            letterSpacing: 0.2,
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(110),
            child: Image.file(widget.imageFile, fit: BoxFit.cover),
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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(
          28,
        ), // More rounded for premium feel
        border: Border.all(color: Colors.grey.shade100, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "QUALITY ASSESSMENT",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 20),
          _buildDetailedCheckItem(
            title: "Focus & Alignment",
            subtitle: "Face is centered and sharp with no motion blur.",
            icon: CupertinoIcons.scope,
          ),
          _buildDivider(),
          _buildDetailedCheckItem(
            title: "Facial Expression",
            subtitle: "Eyes are open and face is clearly recognizable.",
            icon: CupertinoIcons.eye,
          ),
          _buildDivider(),
          _buildDetailedCheckItem(
            title: "Environmental Lighting",
            subtitle: "No harsh shadows or overexposed highlights.",
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF17C6C6).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
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
        const Icon(
          CupertinoIcons.checkmark_circle_fill,
          color: Color(0xFF17C6C6),
          size: 20,
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Divider(color: Colors.grey.shade200, height: 1, indent: 44),
    );
  }

  Widget _buildActionDock(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 0),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: _isLoading ? () {} : uploadFile,
            style: ElevatedButton.styleFrom(
              backgroundColor: AnansiColors.darkBlue,
              minimumSize: const Size(double.infinity, 64),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CupertinoActivityIndicator(color: Colors.white),
                  )
                : const Text(
                    "SUBMIT IMAGE",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                      color: Colors.white,
                    ),
                  ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            behavior: HitTestBehavior.opaque,
            child: Text(
              "RETAKE SELFIE",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w900,
                fontSize: 12,
                letterSpacing: 1.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

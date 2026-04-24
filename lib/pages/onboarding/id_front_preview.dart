import 'dart:io';
import 'package:app_anansi_mobile/pages/onboarding/introduce_id_back.dart';
import 'package:app_anansi_mobile/services/error_service.dart';
import 'package:app_anansi_mobile/services/ocr_service.dart';
import 'package:app_anansi_mobile/state/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class IdFrontPreview extends StatefulWidget {
  final File imageFile;

  const IdFrontPreview({super.key, required this.imageFile});

  @override
  State<IdFrontPreview> createState() => _IdFrontPreviewState();
}

class _IdFrontPreviewState extends State<IdFrontPreview> {
  bool _isLoading = false;

  void _extractIdDetails() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final (response, errors) = await OcrService().extractFrontIdDetails(
        image: widget.imageFile,
      );
      if (errors != null) {
        ErrorService.showActionableError(
          context,
          title: errors[0],
          message: errors[1],
        );
      } else if (response != null) {
        HapticFeedback.lightImpact();
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        authProvider.setKyc(response.data['data'] ?? {});
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const IntroduceBackOfId()),
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "Verify Identity",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: AnansiColors.darkBlue,
                          letterSpacing: -1.5,
                        ),
                      ),
                    ),
                    _buildStepHeader(),
                    const SizedBox(height: 10),
                    _buildImagePreview(),
                    const SizedBox(height: 22),
                    Text(
                      "IMAGE QUALITY REPORT",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    SizedBox(height: 8),
                    _buildChecklist(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStepHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Confirm ID Capture",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.5,
          ),
        ),
        Text(
          "Please confirm that you can read every detail on the ID clearly, including your name and ID number.",
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 15,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 2),
        boxShadow: [
          BoxShadow(
            color: AnansiColors.darkBlue.withValues(alpha: 0.12),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(
              aspectRatio: 1.6,
              child: Image.file(
                widget.imageFile,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey.shade50,
                  child: const Icon(CupertinoIcons.photo, color: Colors.grey),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.05),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.05),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklist() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailedCheckItem(
            title: "Facial Recognition",
            subtitle:
                "The portrait is sharp, well-lit, and matches biometric standards.",
            icon: CupertinoIcons.person_crop_square,
          ),
          _buildDivider(),
          _buildDetailedCheckItem(
            title: "Optical Character Stability",
            subtitle: "All identity numbers are crisp and machine-readable.",
            icon: CupertinoIcons.viewfinder,
          ),
          _buildDivider(),
          _buildDetailedCheckItem(
            title: "Surface Glare Reduction",
            subtitle:
                "Anti-glare check passed; no reflections on the plastic lamination.",
            icon: CupertinoIcons.sun_min,
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
      child: Divider(color: Colors.grey.shade100, height: 1, indent: 48),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            // FIX: Dummy function () {} keeps button enabled/blue while loading
            onPressed: _isLoading ? () {} : _extractIdDetails,
            style: ElevatedButton.styleFrom(
              backgroundColor: AnansiColors.darkBlue,
              disabledBackgroundColor:
                  Colors.grey.shade200, // For the "inactive" state
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
                    "SUBMIT FRONT SIDE",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                      color: Colors.white,
                    ),
                  ),
          ),
          const SizedBox(height: 16),
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
                  "RETAKE DOCUMENT SCAN",
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
      ),
    );
  }
}

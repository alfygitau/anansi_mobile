import 'dart:io';
import 'package:app_anansi_mobile/pages/onboarding/id_front_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:image_picker/image_picker.dart';

class IntroduceFrontOfId extends StatefulWidget {
  const IntroduceFrontOfId({super.key});

  @override
  State<IntroduceFrontOfId> createState() => _IntroduceFrontOfIdState();
}

class _IntroduceFrontOfIdState extends State<IntroduceFrontOfId> {
  final ImagePicker _picker = ImagePicker();

  Future<File?> captureIdFront() async {
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
    final File? capturedFile = await captureIdFront();
    if (capturedFile != null && mounted) {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => IdFrontPreview(imageFile: capturedFile),
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
                  children: [
                    const SizedBox(height: 10),
                    _buildBrandIdentity(),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "Verify Your Identification",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: AnansiColors.darkBlue,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Position the front side of your National ID or Passport within the frame. Ensure the details are sharp and legible.",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 25),
                    _buildIdFramePreview(),
                    const SizedBox(height: 25),
                    _buildRequirementItem(
                      icon: CupertinoIcons.sun_max,
                      text: "Optimal Lighting Conditions",
                      description:
                          "Position yourself in a well-lit area. Avoid direct overhead lights or camera flash that could create glare on the ID's holographic surfaces.",
                    ),
                    _buildRequirementItem(
                      icon: CupertinoIcons.viewfinder,
                      text: "Precise Frame Alignment",
                      description:
                          "Ensure the document is laid on a flat, dark surface. Align all four edges within the guide markers to allow for automated edge detection.",
                    ),
                    _buildRequirementItem(
                      icon: CupertinoIcons.doc_text_search,
                      text: "Legibility & Data Integrity",
                      description:
                          "Check that all text, serial numbers, and your portrait are sharp and in focus. Blurred images will fail our automated security verification.",
                    ),
                    const SizedBox(height: 10),
                    _buildLegalDisclaimer(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            _buildCaptureButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandIdentity() {
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
                  "ID or Passport Details",
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

  Widget _buildIdFramePreview() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.grey.shade100, width: 2),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              color: const Color(0xFF17C6C6).withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
          ),
          const Opacity(
            opacity: 0.6,
            child: Icon(
              CupertinoIcons.doc_text_viewfinder,
              size: 100,
              color: AnansiColors.darkBlue,
            ),
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: ViewfinderPainter(color: const Color(0xFF17C6C6)),
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
        crossAxisAlignment: CrossAxisAlignment.start,
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

  Widget _buildLegalDisclaimer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.gavel_rounded, size: 14, color: Colors.grey.shade400),
              const SizedBox(width: 8),
              Text(
                "REGULATORY DISCLOSURE",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: Colors.grey.shade400,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "By proceeding, you authorize HELACRED LIMITED to process your biometric data for the purpose of identity verification in compliance with the Data Protection Act (2019). We do not share your documents with third-party marketing entities.",
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade500,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaptureButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 10),
      decoration: BoxDecoration(color: Colors.white),
      child: ElevatedButton(
        onPressed: () async {
          _continue();
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
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "CONTINUE TO CAMERA",
              style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Painter for those premium viewfinder corners
class ViewfinderPainter extends CustomPainter {
  final Color color;
  ViewfinderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    const length = 20.0;
    const padding = 20.0;

    // Top Left
    canvas.drawPath(
      Path()
        ..moveTo(padding, padding + length)
        ..lineTo(padding, padding)
        ..lineTo(padding + length, padding),
      paint,
    );
    // Top Right
    canvas.drawPath(
      Path()
        ..moveTo(size.width - padding - length, padding)
        ..lineTo(size.width - padding, padding)
        ..lineTo(size.width - padding, padding + length),
      paint,
    );
    // Bottom Left
    canvas.drawPath(
      Path()
        ..moveTo(padding, size.height - padding - length)
        ..lineTo(padding, size.height - padding)
        ..lineTo(padding + length, size.height - padding),
      paint,
    );
    // Bottom Right
    canvas.drawPath(
      Path()
        ..moveTo(size.width - padding - length, size.height - padding)
        ..lineTo(size.width - padding, size.height - padding)
        ..lineTo(size.width - padding, size.height - padding - length),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

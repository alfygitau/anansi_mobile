import 'dart:io';
import 'package:app_anansi_mobile/pages/onboarding/id_back_preview.dart';
import 'package:app_anansi_mobile/pages/onboarding/introduce_id_front.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:image_picker/image_picker.dart';

class IntroduceBackOfId extends StatefulWidget {
  const IntroduceBackOfId({super.key});

  @override
  State<IntroduceBackOfId> createState() => _IntroduceBackOfIdState();
}

class _IntroduceBackOfIdState extends State<IntroduceBackOfId> {
  final ImagePicker _picker = ImagePicker();

  Future<File?> captureIdBack() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        imageQuality: 90,
      );
      if (photo != null) return File(photo.path);
      return null;
    } catch (e) {
      return null;
    }
  }

  void _handleCapture() async {
    final File? capturedFile = await captureIdBack();
    if (capturedFile != null && mounted) {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => IdBackPreview(imageFile: capturedFile),
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
                    SizedBox(height: 20),
                    const Text(
                      "Capture ID (Back)",
                      style: TextStyle(
                        color: AnansiColors.darkBlue,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Now, please provide a clear scan of the back of your document. This is required to verify security features and the document serial number.",
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 22),
                    _buildIdFramePreview(),
                    const SizedBox(height: 22),
                    _buildRequirementItem(
                      icon: CupertinoIcons.barcode_viewfinder,
                      text: "Barcode Legibility",
                      description:
                          "Ensure the barcode or Machine Readable Zone (MRZ) at the bottom is not obscured by shadows or your fingers.",
                    ),
                    _buildRequirementItem(
                      icon: CupertinoIcons.doc_text_viewfinder,
                      text: "Serial Integrity",
                      description:
                          "The document number on the back must match the front. Ensure all numerical strings are sharp and in-focus.",
                    ),
                    _buildRequirementItem(
                      icon: CupertinoIcons.lock_shield,
                      text: "Security Patterns",
                      description:
                          "Avoid tilting the card too much; we need to verify the micro-print and security background patterns.",
                    ),
                    _buildSecurityNote(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            _buildCaptureButton(),
          ],
        ),
      ),
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
          // Decorative "Reverse Side" Iconography
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF17C6C6).withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
          ),
          const Opacity(
            opacity: 0.6,
            child: Icon(
              CupertinoIcons.arrow_2_squarepath, // Implies "the other side"
              size: 50,
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F7F6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: const Color(0xFF17C6C6), size: 20),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    color: AnansiColors.darkBlue,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
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

  Widget _buildSecurityNote() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF17C6C6).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(
            CupertinoIcons.lock_shield_fill,
            color: Color(0xFF17C6C6),
            size: 16,
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              "Your document data is processed locally on-device before being encrypted for secure transmission.",
              style: TextStyle(
                fontSize: 11,
                color: AnansiColors.darkBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaptureButton() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade100)),
      ),
      child: ElevatedButton(
        onPressed: _handleCapture,
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
              "CAPTURE BACK SIDE",
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

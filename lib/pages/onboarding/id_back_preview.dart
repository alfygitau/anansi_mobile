import 'dart:io';
import 'package:app_anansi_mobile/pages/onboarding/id_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';

class IdBackPreview extends StatelessWidget {
  final File imageFile;

  const IdBackPreview({super.key, required this.imageFile});

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
                    _buildBrandHeader(context),
                    SizedBox(height: 20),
                    _buildStepHeader(),
                    const SizedBox(height: 22),
                    _buildImagePreview(),
                    const SizedBox(height: 22),
                    _buildChecklist(),
                    const SizedBox(height: 22),
                    _buildSecurityAssurance(),
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

  Widget _buildSecurityAssurance() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          CupertinoIcons.lock_shield,
          size: 14,
          color: Color(0xFF17C6C6),
        ),
        const SizedBox(width: 8),
        Text(
          "SECURED BY ANANSI PROTOCOLS",
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: Colors.grey.shade400,
            letterSpacing: 1,
          ),
        ),
      ],
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

  Widget _buildStepHeader() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Confirm Legibility",
          style: TextStyle(
            color: AnansiColors.darkBlue,
            fontSize: 24,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "The back of your ID contains critical security markers and barcodes. Please ensure these are not blurry or obscured.",
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 15,
            height: 1.5,
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
        border: Border.all(color: Colors.grey.shade100, width: 2),
        boxShadow: [
          BoxShadow(
            color: AnansiColors.darkBlue.withOpacity(0.08),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: AspectRatio(
          aspectRatio: 1.98,
          child: Image.file(imageFile, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _buildChecklist() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(
          28,
        ), // Smoother rounding for premium feel
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "DOCUMENT INTEGRITY CHECK",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 24),
          _buildDetailedCheckItem(
            title: "Data Readability",
            subtitle: "Barcode and MRZ zones are sharp and machine-readable.",
            icon: CupertinoIcons.barcode_viewfinder,
          ),
          _buildDivider(),
          _buildDetailedCheckItem(
            title: "Cross-Reference Validation",
            subtitle: "Serial numbers and identifiers match the primary side.",
            icon: CupertinoIcons.doc_on_doc,
          ),
          _buildDivider(),
          _buildDetailedCheckItem(
            title: "Edge Recognition",
            subtitle:
                "All four corners of the document are within the focus area.",
            icon: CupertinoIcons.layers_alt,
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
            color: const Color(0xFF17C6C6).withOpacity(0.08),
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
          size: 22,
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Divider(
        color: Colors.grey.shade100,
        height: 1,
        indent: 48, // Aligns with the start of the text, leaving icons clear
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const IdDetails()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AnansiColors.darkBlue,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 64),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 0,
            ),
            child: const Text(
              "SUBMIT BACK SIDE",
              style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              // ADD THIS LINE
              padding: const EdgeInsets.symmetric(vertical: 20),

              side: BorderSide(color: Colors.grey.shade200, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              foregroundColor: Colors.grey.shade600,
              backgroundColor: Colors.white,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.refresh, size: 16),
                SizedBox(width: 10),
                Text(
                  "RETAKE DOCUMENT SCAN",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    letterSpacing: 1.1,
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

import 'package:app_anansi_mobile/pages/onboarding/introduce_selfie.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IdDetails extends StatefulWidget {
  const IdDetails({super.key});

  @override
  State<IdDetails> createState() => _IdDetailsState();
}

class _IdDetailsState extends State<IdDetails> {
  String firstName = 'ALFY';
  String middleName = 'KARIUKI';
  String lastName = 'GITAU';
  String idNumber = '38492011';
  String birthDate = '12/04/1996';
  String gender = 'MALE';
  String frontImageUrl =
      'https://images.unsplash.com/photo-1554774853-719586f82d77?q=80&w=500';
  String backImageUrl =
      'https://images.unsplash.com/photo-1554774853-719586f82d77?q=80&w=500';

  bool get hasValidNames {
    int count = 0;
    if (firstName.isNotEmpty) count++;
    if (middleName.isNotEmpty) count++;
    if (lastName.isNotEmpty) count++;
    return count >= 2;
  }

  bool get hasAllRequiredFields {
    return idNumber.isNotEmpty &&
        birthDate.isNotEmpty &&
        gender.isNotEmpty &&
        hasValidNames;
  }

  final Map<String, IconData> _labelIcons = {
    'ID Number': CupertinoIcons.creditcard,
    'First Name': CupertinoIcons.person,
    'Middle Name': CupertinoIcons.person_badge_minus,
    'Last Name': CupertinoIcons.text_badge_checkmark,
    'Gender': CupertinoIcons.person_2,
    'Date of Birth': CupertinoIcons.calendar,
  };

  void _onContinue() {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => const IntroduceSelfie()),
    );
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
                    _buildBrandHeader(context),
                    const SizedBox(height: 20),
                    _buildStepHeader(),
                    const SizedBox(height: 20),
                    _buildImageThumbnails(),
                    const SizedBox(height: 20),
                    _buildSectionLabel("EXTRACTED INFORMATION"),
                    const SizedBox(height: 16),
                    _buildDetailRow('ID Number', idNumber),
                    _buildDetailRow('First Name', firstName),
                    _buildDetailRow('Middle Name', middleName),
                    _buildDetailRow('Last Name', lastName),
                    _buildDetailRow('Gender', gender),
                    _buildDetailRow('Date of Birth', birthDate),
                    const SizedBox(height: 20),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Confirm Details",
          style: TextStyle(
            color: AnansiColors.darkBlue,
            fontSize: 24,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          hasAllRequiredFields
              ? "We've analyzed your document. Please verify that the details below exactly match your government ID."
              : "Some details were obscured during the scan. Please provide the missing information manually.",
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 15,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildImageThumbnails() {
    return Row(
      children: [
        _buildThumbnail("Front Side", frontImageUrl),
        const SizedBox(width: 16),
        _buildThumbnail("Back Side", backImageUrl),
      ],
    );
  }

  Widget _buildThumbnail(String label, String url) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade100, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.network(
                url,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w900,
                color: Colors.grey.shade400,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.5,
        color: Colors.grey.shade400,
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    bool isEmpty = value.isEmpty;
    IconData? icon = _labelIcons[label] ?? CupertinoIcons.doc_text;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isEmpty ? const Color(0xFFFFF8F8) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isEmpty ? Colors.red.shade100 : Colors.grey.shade100,
            width: 1.5,
          ),
          boxShadow: [
            if (!isEmpty)
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isEmpty ? Colors.red.shade50 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 16,
                color: isEmpty
                    ? Colors.red.shade300
                    : AnansiColors.darkBlue.withOpacity(0.6),
              ),
            ),
            const SizedBox(width: 16),

            // Label
            Expanded(
              flex: 4,
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Value
            Expanded(
              flex: 6,
              child: Text(
                isEmpty ? "Missing Info" : value,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: isEmpty ? Colors.red.shade400 : AnansiColors.darkBlue,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionDock(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasAllRequiredFields) ...[
            ElevatedButton(
              onPressed: _onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: AnansiColors.darkBlue,
                minimumSize: const Size(double.infinity, 64),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
              ),
              child: const Text(
                "YES, DATA IS ACCURATE",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                side: const BorderSide(color: Color(0xFFFF5757), width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Center(
                child: Text(
                  "RESCAN DOCUMENT",
                  style: TextStyle(
                    color: Color(0xFFFF5757),
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
            ),
          ] else ...[
            ElevatedButton(
              onPressed: () => {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (_) => const IdManualFill()),
                // ),
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AnansiColors.darkBlue,
                minimumSize: const Size(double.infinity, 64),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                "COMPLETE MANUALLY",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

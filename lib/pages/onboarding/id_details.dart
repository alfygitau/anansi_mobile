import 'dart:io';
import 'package:app_anansi_mobile/pages/onboarding/introduce_id_front.dart';
import 'package:app_anansi_mobile/pages/onboarding/introduce_selfie.dart';
import 'package:app_anansi_mobile/services/error_service.dart';
import 'package:app_anansi_mobile/services/onboarding_service.dart';
import 'package:app_anansi_mobile/state/auth_provider.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class IdDetails extends StatefulWidget {
  final File frontFile;
  final File backFile;
  const IdDetails({super.key, required this.backFile, required this.frontFile});

  @override
  State<IdDetails> createState() => _IdDetailsState();
}

class _IdDetailsState extends State<IdDetails> {
  bool _isLoading = false;
  bool hasValidNames(Map<String, dynamic>? kycDetails) {
    if (kycDetails == null) return false;
    final String fullName = kycDetails['fullNames'] ?? '';
    final List<String> nameParts = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((s) => s.isNotEmpty)
        .toList();
    return nameParts.length >= 2;
  }

  bool hasAllRequiredFields(Map<String, dynamic>? kycDetails) {
    if (kycDetails == null) return false;
    final bool hasId =
        (kycDetails['idNumber']?.toString().trim().isNotEmpty ?? false);
    final bool hasDob =
        (kycDetails['dateOfBirth']?.toString().trim().isNotEmpty ?? false);
    final bool hasGender =
        (kycDetails['sex']?.toString().trim().isNotEmpty ?? false);
    return hasId && hasDob && hasGender && hasValidNames(kycDetails);
  }

  final Map<String, IconData> _labelIcons = {
    'ID Number': CupertinoIcons.creditcard,
    'First Name': CupertinoIcons.person,
    'Middle Name': CupertinoIcons.person_badge_minus,
    'Last Name': CupertinoIcons.text_badge_checkmark,
    'Gender': CupertinoIcons.person_2,
    'Date of Birth': CupertinoIcons.calendar,
  };

  void _onContinue() async {
    setState(() {
      _isLoading = true;
    });
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final kycData = authProvider.kycDetails;

    final String idNumber = kycData?['idNumber'] ?? '';
    final String dob = kycData?['dateOfBirth'] ?? '';
    final String gender = kycData?['sex'] ?? '';

    final String fullName = kycData?['fullNames'] ?? '';
    final List<String> nameParts = fullName.trim().isEmpty
        ? []
        : fullName.trim().split(RegExp(r'\s+'));

    final String firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final String lastName = nameParts.length > 1 ? nameParts.last : '';

    final String middleName = nameParts.length > 2
        ? nameParts.sublist(1, nameParts.length - 1).join(' ')
        : '';
    try {
      final (response, errors) = await OnboardingService().updateIdentity(
        id: authProvider.user?['id'] ?? "",
        firstName: firstName,
        middleName: middleName,
        lastName: lastName,
        idNumber: idNumber,
        gender: gender,
        birthDate: dob,
      );
      if (errors != null) {
        ErrorService.showActionableError(
          context,
          title: errors[0],
          message: errors[1],
        );
      } else if (response != null) {
        await _updateCustomer();
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _updateCustomer() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final (response, errors) = await OnboardingService().updateIdImages(
      id: authProvider.user?['id'] ?? "",
      frontImage: widget.frontFile,
      backImage: widget.backFile,
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
        CupertinoPageRoute(builder: (context) => const IntroduceSelfie()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final kycData = authProvider.kycDetails;

    final String idNumber = kycData?['idNumber'] ?? '';
    final String dob = kycData?['dateOfBirth'] ?? '';
    final String gender = kycData?['sex'] ?? '';

    final String fullName = kycData?['fullNames'] ?? '';
    final List<String> nameParts = fullName.trim().isEmpty
        ? []
        : fullName.trim().split(RegExp(r'\s+'));

    final String firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final String lastName = nameParts.length > 1 ? nameParts.last : '';

    final String middleName = nameParts.length > 2
        ? nameParts.sublist(1, nameParts.length - 1).join(' ')
        : '';
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
                    const Text(
                      "Verify Identity",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: AnansiColors.darkBlue,
                        letterSpacing: -1.5,
                      ),
                    ),
                    const SizedBox(height: 10),
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
                    _buildDetailRow('Date of Birth', dob),
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

  Widget _buildStepHeader() {
    final authProvider = context.watch<AuthProvider>();
    final kycData = authProvider.kycDetails;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Confirm Details",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          hasAllRequiredFields(kycData)
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
        _buildThumbnail("Front Side", widget.frontFile),
        const SizedBox(width: 16),
        _buildThumbnail("Back Side", widget.backFile),
      ],
    );
  }

  Widget _buildThumbnail(String label, File url) {
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
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.file(url, fit: BoxFit.cover, width: double.infinity),
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
                color: Colors.black.withValues(alpha: 0.02),
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
                    : AnansiColors.darkBlue.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(width: 16),
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
    final authProvider = context.watch<AuthProvider>();
    final kycData = authProvider.kycDetails;
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 5),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasAllRequiredFields(kycData)) ...[
            ElevatedButton(
              onPressed: _isLoading ? () {} : _onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: AnansiColors.darkBlue,
                disabledBackgroundColor: Colors.grey.shade200,
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
                      "YES, DATA IS ACCURATE",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.1,
                        color: Colors.white,
                      ),
                    ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const IntroduceFrontOfId()),
                );
              },
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
            GestureDetector(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (_) => const IntroduceFrontOfId()),
                // );
              },
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

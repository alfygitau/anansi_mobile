import 'dart:convert';
import 'package:app_anansi_mobile/pages/onboarding/introduce_id_front.dart';
import 'package:app_anansi_mobile/services/error_service.dart';
import 'package:app_anansi_mobile/services/onboarding_service.dart';
import 'package:app_anansi_mobile/services/secure_storage_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/services.dart';

class IdType extends StatefulWidget {
  const IdType({super.key});

  @override
  State<IdType> createState() => _IdTypeState();
}

class _IdTypeState extends State<IdType> {
  String? selectedCountry;
  String? selectedIdType;
  bool _isLoading = false;

  bool get _isFormValid {
    return selectedCountry != null &&
        selectedCountry!.isNotEmpty &&
        selectedIdType != null;
  }

  Future<Map<String, dynamic>?> getUser() async {
    String? userJson = await SecureStorageService().read('user');
    if (userJson == null) return null;
    Map<String, dynamic> userMap = jsonDecode(userJson);
    return userMap;
  }

  Future<void> _updateCustomer() async {
    setState(() {
      _isLoading = true;
    });
    final user = await getUser();
    try {
      final (response, errors) = await OnboardingService().updateIdType(
        id: user?['id'] ?? "",
        idType: selectedIdType ?? "",
        citizenship: selectedCountry ?? "",
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
          MaterialPageRoute(builder: (context) => const IntroduceFrontOfId()),
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
                    const Text(
                      "Verify Identity",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: AnansiColors.darkBlue,
                        letterSpacing: -1.5,
                      ),
                    ),
                    _buildHeader(),
                    const SizedBox(height: 20),
                    _buildSectionLabel("CITIZENSHIP"),
                    const SizedBox(height: 12),
                    _buildDropdownField(
                      label: "Country of citizenship",
                      value: selectedCountry,
                      items: ['Kenya', 'United States'],
                      icon: CupertinoIcons.briefcase,
                      onChanged: (val) => setState(() => selectedCountry = val),
                    ),
                    const SizedBox(height: 32),
                    _buildSectionLabel("IDENTIFICATION TYPE"),
                    const SizedBox(height: 12),
                    _buildIdTypeTile(
                      type: "National ID",
                      subtitle: "Standard for Kenyan Citizens",
                      icon: CupertinoIcons.doc_text_viewfinder,
                    ),
                    _buildIdTypeTile(
                      type: "Passport",
                      subtitle: "International Travel Document",
                      icon: CupertinoIcons.globe,
                    ),
                  ],
                ),
              ),
            ),
            _buildContinueButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Type of Identification",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          "To provide you with secure access to our financial suite, please specify your country of citizenship and select a preferred government-issued document. This information allows our systems to cross-reference global compliance standards and ensure your identity is protected against unauthorized access.",
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 14,
            height: 1.6,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w900,
        color: AnansiColors.darkBlue.withValues(alpha: 0.3),
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required IconData icon,
    required Function(String?) onChanged,
  }) {
    bool hasValue = value != null && value.isNotEmpty && items.contains(value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 4),
          child: Text(
            label.toUpperCase(),
            style: TextStyle(
              color: AnansiColors.darkBlue.withValues(alpha: 0.6),
              fontWeight: FontWeight.w900,
              fontSize: 11,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          height: 64, // Fixed height to match text inputs perfectly
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1.8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown:
                  true, // This aligns the menu width with the button width
              child: DropdownButton<String>(
                value: hasValue ? value : null,
                isExpanded: true, // Forces the content to span the Row
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(22),
                icon: const Padding(
                  padding: EdgeInsets.only(right: 14),
                  child: Icon(
                    CupertinoIcons.chevron_down,
                    size: 14,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                // We use the hint/selectedItem to build your custom Row inside the button
                hint: _buildDropdownRow(icon, "Select $label", isHint: true),
                selectedItemBuilder: (context) {
                  return items.map((String item) {
                    return _buildDropdownRow(icon, item, isHint: false);
                  }).toList();
                },
                items: items.map((String item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Helper to keep the Icon Anchor and Separator consistent
  Widget _buildDropdownRow(IconData icon, String text, {required bool isHint}) {
    return Row(
      children: [
        // Icon Anchor
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            size: 20,
            color: AnansiColors.darkBlue.withValues(alpha: 0.4),
          ),
        ),
        // Vertical Separator
        Container(
          height: 24,
          width: 1.5,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          color: const Color(0xFFE2E8F0),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isHint ? Colors.blueGrey.shade200 : Colors.black,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIdTypeTile({
    required String type,
    required String subtitle,
    required IconData icon,
  }) {
    bool isSelected = selectedIdType == type;
    return GestureDetector(
      onTap: () => setState(() => selectedIdType = type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE0F7F6) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF17C6C6) : Colors.grey.shade100,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: const Color(0xFF17C6C6).withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? const Color(0xFF17C6C6)
                  : AnansiColors.darkBlue.withValues(alpha: 0.4),
              size: 28,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type,
                    style: TextStyle(
                      color: AnansiColors.darkBlue,
                      fontWeight: isSelected
                          ? FontWeight.w900
                          : FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                CupertinoIcons.checkmark_circle_fill,
                color: Color(0xFF17C6C6),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 10),
      decoration: const BoxDecoration(color: Colors.white),
      child: ElevatedButton(
        // LOGIC:
        // 1. If loading -> stay enabled but do nothing () {}
        // 2. If valid -> allow _updateCustomer
        // 3. Otherwise -> disable (null)
        onPressed: _isLoading ? () {} : (_isFormValid ? _updateCustomer : null),
        style: ElevatedButton.styleFrom(
          backgroundColor: AnansiColors.darkBlue,
          disabledBackgroundColor: Colors.grey.shade200,
          minimumSize: const Size(double.infinity, 64),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: (_isFormValid && !_isLoading) ? 4 : 0,
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CupertinoActivityIndicator(color: Colors.white),
              )
            : Text(
                "CONTINUE",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                  color: _isFormValid ? Colors.white : Colors.grey.shade500,
                ),
              ),
      ),
    );
  }
}

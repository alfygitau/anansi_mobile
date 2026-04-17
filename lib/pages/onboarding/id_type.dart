import 'package:app_anansi_mobile/pages/onboarding/introduce_id_front.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';

class IdType extends StatefulWidget {
  const IdType({super.key});

  @override
  State<IdType> createState() => _IdTypeState();
}

class _IdTypeState extends State<IdType> {
  String? selectedCountry = "Kenya";
  String? selectedIdType;

  Future<void> _updateCustomer() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const IntroduceFrontOfId()),
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
                    const SizedBox(height: 10),
                    _buildBrandIdentity(),
                    const SizedBox(height: 20),
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
          "Identity Details",
          style: TextStyle(
            color: AnansiColors.darkBlue,
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 12),
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
        color: AnansiColors.darkBlue.withOpacity(0.3),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F4F8), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<String>(
            value: hasValue ? value : null,
            isExpanded: true,
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(20),
            icon: const SizedBox.shrink(),
            hint: _buildDropdownContent(label, value, icon, isHint: true),
            selectedItemBuilder: (BuildContext context) {
              return items.map<Widget>((String item) {
                return _buildDropdownContent(label, item, icon, isHint: false);
              }).toList();
            },
            items: items.map((String item) {
              return DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownContent(
    String label,
    String? value,
    IconData icon, {
    required bool isHint,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF17C6C6).withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: const Color(0xFF17C6C6)),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label.toUpperCase(),
                style: const TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontWeight: FontWeight.w800,
                  fontSize: 9,
                  letterSpacing: 1.2,
                ),
              ),
              Text(
                isHint ? "Select $label" : value!,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isHint ? Colors.grey.shade300 : Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        const Icon(
          CupertinoIcons.chevron_down,
          size: 14,
          color: AnansiColors.darkBlue,
        ),
        const SizedBox(width: 16), // Padding on the far right
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
                color: const Color(0xFF17C6C6).withOpacity(0.1),
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
                  : AnansiColors.darkBlue.withOpacity(0.4),
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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white),
      child: ElevatedButton(
        onPressed: _updateCustomer,
        style: ElevatedButton.styleFrom(
          backgroundColor: AnansiColors.darkBlue,
          minimumSize: const Size(double.infinity, 64),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 0,
        ),
        child: const Text(
          "CONTINUE",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
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
                  "Type of identification",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),

        // Close/Retake Action
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
}

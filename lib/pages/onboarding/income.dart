import 'package:app_anansi_mobile/pages/onboarding/next_of_kin.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IncomeInformation extends StatefulWidget {
  const IncomeInformation({super.key});

  @override
  State<IncomeInformation> createState() => _IncomeInformationState();
}

class _IncomeInformationState extends State<IncomeInformation> {
  String? employmentType;
  final TextEditingController _kraController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _incomeController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _updateCustomer() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NextOfKin()),
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
                    _buildBrandHeader(),
                    const SizedBox(height: 16),
                    _buildStepHeader(),
                    const SizedBox(height: 22),

                    _buildSectionLabel("EMPLOYMENT STATUS"),
                    const SizedBox(height: 16),
                    _buildDropdownField(
                      label: "Employment Type",
                      value: employmentType,
                      items: [
                        'Employed',
                        'Self employment',
                        'Contractor',
                        'Unemployed',
                      ],
                      icon: CupertinoIcons.briefcase,
                      onChanged: (val) => setState(() => employmentType = val),
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      label: "Job Title",
                      controller: _occupationController,
                      hint: "e.g. Software Engineer",
                      icon: CupertinoIcons.person_badge_plus,
                    ),
                    const SizedBox(height: 32),
                    _buildSectionLabel("FINANCIAL PROFILE"),
                    const SizedBox(height: 16),
                    _buildInputField(
                      label: "Monthly Income (KES)",
                      controller: _incomeController,
                      hint: "Enter net monthly salary",
                      icon: CupertinoIcons.money_dollar_circle,
                      isNumber: true,
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      label: "KRA PIN (Optional)",
                      controller: _kraController,
                      hint: "e.g. A012345678X",
                      icon: CupertinoIcons.doc_text_search,
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            _buildActionDock(),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandHeader() {
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
                  "Financial Profile",
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
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Income Details",
          style: TextStyle(
            color: AnansiColors.darkBlue,
            fontSize: 24,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 12),
        Text(
          "Please provide your current income information. This data helps us establish your credit limit and ensures we offer financial products tailored to your repayment capability.",
          style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 15, height: 1.6),
        ),
      ],
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.5,
        color: Color(0xFFBDBDBD),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isNumber = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F4F8), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF17C6C6).withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 18, color: const Color(0xFF17C6C6)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
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
                const SizedBox(height: 2),
                TextField(
                  controller: controller,
                  keyboardType: isNumber
                      ? TextInputType.number
                      : TextInputType.text,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                      color: Colors.grey.shade300,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 4),
                    border: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
        ],
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
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildActionDock() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(color: Colors.white),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _updateCustomer,
        style: ElevatedButton.styleFrom(
          backgroundColor: AnansiColors.darkBlue,
          minimumSize: const Size(double.infinity, 64),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const CupertinoActivityIndicator(color: Colors.white)
            : const Text(
                "SAVE AND CONTINUE",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}

import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ManualEntry extends StatefulWidget {
  const ManualEntry({super.key});

  @override
  State<ManualEntry> createState() => _ManualEntryState();
}

class _ManualEntryState extends State<ManualEntry> {
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _mNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  String? selectedGender;
  final FocusNode _fNameFocus = FocusNode();
  final FocusNode _mNameFocus = FocusNode();
  final FocusNode _lNameFocus = FocusNode();
  final FocusNode _idFocus = FocusNode();

  Map<String, String?> formErrors = {};
  bool _isLoading = false;

  // Validation Logic (Global Check for Button)
  bool get isFormValid {
    return _fNameController.text.isNotEmpty &&
        _lNameController.text.isNotEmpty &&
        _idController.text.length >= 6 &&
        _dobController.text.isNotEmpty;
  }

  String formatDate(DateTime dateTime) {
    return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF17C6C6)),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() => _dobController.text = formatDate(picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFDFF),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Manual ID Entry",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0A2351),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Please ensure the details match your National ID exactly to avoid verification delays.",
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // NAME SECTION
                    _sectionTitle("Personal Information"),
                    _buildInputField(
                      label: "First Name",
                      fieldKey: "fname",
                      controller: _fNameController,
                      hint: "Your first name",
                      icon: CupertinoIcons.person,
                      focusNode: _fNameFocus,
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      label: "Middle Name",
                      fieldKey: "mname",
                      controller: _mNameController,
                      hint: "Your middle name",
                      icon: CupertinoIcons.person,
                      focusNode: _mNameFocus,
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      label: "Last Name",
                      fieldKey: "lname",
                      controller: _lNameController,
                      hint: "Your last name",
                      icon: CupertinoIcons.person,
                      focusNode: _lNameFocus,
                      keyboardType: TextInputType.name,
                    ),

                    const SizedBox(height: 32),
                    _sectionTitle("Document Details"),
                    _buildInputField(
                      label: "ID Number",
                      fieldKey: "id",
                      controller: _idController,
                      hint: "National ID Number",
                      icon: CupertinoIcons.doc_plaintext,
                      focusNode: _idFocus,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),

                    // Special Input: Date of Birth
                    _buildDateSelector(),
                    const SizedBox(height: 16),

                    // Special Input: Gender
                    _buildDropdownField(
                      label: "Gender",
                      value: selectedGender,
                      items: ['Male', 'Female'],
                      icon: CupertinoIcons.briefcase,
                      onChanged: (val) => setState(() => selectedGender = val),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildActionDock(),
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

  Widget _buildDateSelector() {
    final bool hasDate = _dobController.text.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 10),
          child: Text(
            "DATE OF BIRTH",
            style: TextStyle(
              color: AnansiColors.darkBlue.withValues(alpha: 0.6),
              fontWeight: FontWeight.w900,
              fontSize: 11,
              letterSpacing: 1.2,
            ),
          ),
        ),
        GestureDetector(
          onTap: () => _selectDate(context),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1.8),
              boxShadow: [
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
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    CupertinoIcons.calendar,
                    size: 20,
                    color: AnansiColors.darkBlue,
                  ),
                ),
                Container(
                  height: 24,
                  width: 1.5,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  color: const Color(0xFFE2E8F0),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        hasDate ? _dobController.text : "Select kin's birthday",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: hasDate
                              ? Colors.black
                              : Colors.blueGrey.shade200,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  CupertinoIcons.chevron_right,
                  size: 14,
                  color: Colors.blueGrey.shade200,
                ),
                const SizedBox(width: 4),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.grey.shade400,
          fontWeight: FontWeight.w900,
          fontSize: 11,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildActionDock() {
    final bool ready = isFormValid;
    final VoidCallback? action = _isLoading
        ? () {}
        : (ready ? _submitForm : null);

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 30),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: action,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0A2351),
          disabledBackgroundColor: Colors.grey.shade200,
          minimumSize: const Size(double.infinity, 64),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const CupertinoActivityIndicator(color: Colors.white)
            : Text(
                "VERIFY DETAILS",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1,
                  color: ready ? Colors.white : Colors.grey.shade400,
                ),
              ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String fieldKey,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required FocusNode focusNode,
    required TextInputType keyboardType,
  }) {
    final String? errorText = formErrors[fieldKey];
    final bool hasError = errorText != null;
    final bool isFocused = focusNode.hasFocus;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 4),
          child: Row(
            children: [
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  color: hasError
                      ? Colors.redAccent
                      : AnansiColors.darkBlue.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w900,
                  fontSize: 11,
                  letterSpacing: 1.2,
                ),
              ),
              if (hasError) ...[
                const SizedBox(width: 8),
                const Icon(
                  CupertinoIcons.exclamationmark_circle,
                  size: 12,
                  color: Colors.redAccent,
                ),
              ],
            ],
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: hasError
                  ? Colors.redAccent.withValues(alpha: 0.4)
                  : (isFocused ? Color(0xFFE2E8F0) : const Color(0xFFE2E8F0)),
              width: 1.8,
            ),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isFocused
                      ? AnansiColors.darkBlue
                      : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: isFocused
                      ? Colors.white
                      : AnansiColors.darkBlue.withValues(alpha: 0.4),
                ),
              ),
              Container(
                height: 24,
                width: 1.5,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                color: const Color(0xFFE2E8F0),
              ),
              Expanded(
                child: TextField(
                  focusNode: focusNode,
                  controller: controller,
                  keyboardType: keyboardType,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AnansiColors.darkBlue,
                    letterSpacing: 0.2,
                  ),
                  cursorColor: AnansiColors.darkBlue,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                      color: Colors.blueGrey.shade200,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onChanged: (val) {
                    if (formErrors[fieldKey] != null) {
                      setState(() => formErrors[fieldKey] = null);
                    }
                    setState(() {});
                  },
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                ),
              ),
              if (controller.text.isNotEmpty && !hasError)
                const Icon(
                  CupertinoIcons.checkmark_circle_fill,
                  color: Colors.teal,
                  size: 18,
                ),
            ],
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: SizedBox(
            height: hasError ? null : 0,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, top: 8),
              child: Text(
                errorText ?? "",
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _submitForm() {
    setState(() => _isLoading = true); /* API Call */
  }
}

import 'dart:convert';

import 'package:app_anansi_mobile/pages/onboarding/introduce_selfie.dart';
import 'package:app_anansi_mobile/services/error_service.dart';
import 'package:app_anansi_mobile/services/onboarding_service.dart';
import 'package:app_anansi_mobile/services/secure_storage_service.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  final FocusNode _fNameFocus = FocusNode();
  final FocusNode _mNameFocus = FocusNode();
  final FocusNode _lNameFocus = FocusNode();
  final FocusNode _idFocus = FocusNode();

  String? selectedGender;
  bool _isLoading = false;

  Map<String, String?> formErrors = {
    'fname': null,
    'mname': null,
    'lname': null,
    'id': null,
    'dob': null,
    'gender': null,
  };

  @override
  void initState() {
    super.initState();

    _fNameFocus.addListener(() {
      if (!_fNameFocus.hasFocus) {
        _validateField('fname', _fNameController.text);
      }
    });

    _lNameFocus.addListener(() {
      if (!_lNameFocus.hasFocus) {
        _validateField('lname', _lNameController.text);
      }
    });

    _idFocus.addListener(() {
      if (!_idFocus.hasFocus) {
        _validateField('id', _idController.text);
      }
    });
  }

  void _validateField(String key, String value) {
    String? error;

    switch (key) {
      case 'fname':
        if (value.trim().isEmpty) {
          error = "First name is required";
        } else if (value.trim().length < 2) {
          error = "Name is too short";
        }
        break;

      case 'lname':
        if (value.trim().isEmpty) {
          error = "Last name is required";
        } else if (value.trim().length < 2) {
          error = "Name is too short";
        }
        break;

      case 'id':
        if (value.trim().isEmpty) {
          error = "National ID is required";
        } else if (value.trim().length < 6 || value.trim().length > 10) {
          error = "Enter a valid National ID number";
        }
        break;

      case 'dob':
        if (value.trim().isEmpty) {
          error = "Date of birth is required";
        }
        break;

      case 'gender':
        if (value.isEmpty || value.toLowerCase().contains('select')) {
          error = "Please select your gender";
        }
        break;

      default:
        error = null;
    }

    setState(() {
      formErrors[key] = error;
    });
  }

  void _validateEverything() {
    _validateField('fname', _fNameController.text);
    _validateField('lname', _lNameController.text);
    _validateField('id', _idController.text);
    _validateField('dob', _dobController.text);
    _validateField('gender', selectedGender ?? '');
  }

  bool get isFormValid {
    return _fNameController.text.trim().length >= 2 &&
        _lNameController.text.trim().length >= 2 &&
        _idController.text.trim().length >= 6 &&
        _dobController.text.isNotEmpty &&
        selectedGender != null &&
        selectedGender!.isNotEmpty;
  }

  String formatDate(DateTime dateTime) {
    return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1930),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AnansiColors.darkBlue,
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: AnansiColors.darkBlue,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() {
        _dobController.text = formatDate(picked);
        formErrors['dob'] = null;
      });
    }
  }

  @override
  void dispose() {
    _fNameController.dispose();
    _mNameController.dispose();
    _lNameController.dispose();
    _idController.dispose();
    _dobController.dispose();

    _fNameFocus.dispose();
    _mNameFocus.dispose();
    _lNameFocus.dispose();
    _idFocus.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>?> getUser() async {
    String? userJson = await SecureStorageService().read('user');
    if (userJson == null) return null;
    Map<String, dynamic> userMap = jsonDecode(userJson);
    return userMap;
  }

  void _submitForm() async {
    _validateEverything();
    if (!isFormValid) {
      HapticFeedback.vibrate();
      return;
    }
    try {
      final user = await getUser();
      final (response, errors) = await OnboardingService().updateManualEntry(
        id: user?['id'] ?? "",
        firstName: _fNameController.text.trim(),
        middleName: _mNameController.text.trim(),
        lastName: _lNameController.text.trim(),
        idNumber: _idController.text.trim(),
        gender: selectedGender ?? "",
        birthDate: _dobController.text.trim(),
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
          MaterialPageRoute(builder: (context) => const IntroduceSelfie()),
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
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Pinned Top App Bar
            SliverAppBar(
              pinned: true,
              floating: false,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              scrolledUnderElevation: 0,
              automaticallyImplyLeading: false,
              titleSpacing: 24,
              centerTitle: false,
              title: const Text(
                "Identity Verification",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AnansiColors.darkBlue,
                  letterSpacing: -1.5,
                ),
              ),
            ),

            // Form Body Content
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    _buildStepHeader(),
                    const SizedBox(height: 24),

                    // Section 1: Names
                    _buildSectionLabel("PERSONAL INFORMATION"),
                    const SizedBox(height: 14),
                    _buildInputField(
                      label: "First Name",
                      fieldKey: "fname",
                      controller: _fNameController,
                      hint: "e.g. John",
                      icon: CupertinoIcons.person,
                      focusNode: _fNameFocus,
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      label: "Middle Name (Optional)",
                      fieldKey: "mname",
                      controller: _mNameController,
                      hint: "e.g. Kipchoge",
                      icon: CupertinoIcons.person,
                      focusNode: _mNameFocus,
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      label: "Last Name",
                      fieldKey: "lname",
                      controller: _lNameController,
                      hint: "e.g. Mwangi",
                      icon: CupertinoIcons.person,
                      focusNode: _lNameFocus,
                      keyboardType: TextInputType.name,
                    ),

                    const SizedBox(height: 28),

                    // Section 2: Document Info
                    _buildSectionLabel("DOCUMENT DETAILS"),
                    const SizedBox(height: 14),
                    _buildInputField(
                      label: "National ID Number",
                      fieldKey: "id",
                      controller: _idController,
                      hint: "e.g. 12345678",
                      icon: CupertinoIcons.doc_plaintext,
                      focusNode: _idFocus,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(9),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildDateSelector(),
                    const SizedBox(height: 16),
                    _buildDropdownField(
                      label: "Gender",
                      value: selectedGender,
                      items: const ['Male', 'Female'],
                      icon: CupertinoIcons.person_2,
                      onChanged: (val) {
                        setState(() => selectedGender = val);
                        _validateField('gender', val ?? '');
                      },
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        maintainBottomViewPadding: true,
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 5),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: _buildActionDock(),
        ),
      ),
    );
  }

  Widget _buildStepHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Manual ID Entry",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AnansiColors.darkBlue,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Please ensure the details match your official National ID card exactly to avoid verification delays.",
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.5,
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
        letterSpacing: 1.5,
        color: AnansiColors.darkBlue.withValues(alpha: 0.4),
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
    List<TextInputFormatter>? inputFormatters,
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
                  : const Color(0xFFE2E8F0),
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
                      : ThemeColors.background,
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
                  inputFormatters: inputFormatters,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                    color: AnansiColors.darkBlue,
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
                  onTapOutside: (_) => FocusScope.of(context).unfocus(),
                ),
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

  Widget _buildDateSelector() {
    final bool hasDate = _dobController.text.isNotEmpty;
    final String? errorText = formErrors['dob'];
    final bool hasError = errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 4),
          child: Row(
            children: [
              Text(
                "DATE OF BIRTH",
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
        GestureDetector(
          onTap: () => _selectDate(context),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: hasError
                    ? Colors.redAccent.withValues(alpha: 0.4)
                    : const Color(0xFFE2E8F0),
                width: 1.8,
              ),
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
                    color: ThemeColors.background,
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
                  child: Text(
                    hasDate ? _dobController.text : "Select date of birth",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: hasDate
                          ? AnansiColors.darkBlue
                          : Colors.blueGrey.shade200,
                      letterSpacing: 0.2,
                    ),
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

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required IconData icon,
    required Function(String?) onChanged,
  }) {
    final bool hasValue =
        value != null && value.isNotEmpty && items.contains(value);
    final String? errorText = formErrors['gender'];
    final bool hasError = errorText != null;

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
        Container(
          height: 64,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: hasError
                  ? Colors.redAccent.withValues(alpha: 0.4)
                  : const Color(0xFFE2E8F0),
              width: 1.8,
            ),
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
              alignedDropdown: true,
              child: DropdownButton<String>(
                value: hasValue ? value : null,
                isExpanded: true,
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
                        fontWeight: FontWeight.w600,
                        color: AnansiColors.darkBlue,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
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

  Widget _buildDropdownRow(IconData icon, String text, {required bool isHint}) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: ThemeColors.background,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            size: 20,
            color: AnansiColors.darkBlue.withValues(alpha: 0.4),
          ),
        ),
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
              fontWeight: isHint ? FontWeight.w500 : FontWeight.w600,
              color: isHint ? Colors.blueGrey.shade200 : AnansiColors.darkBlue,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionDock() {
    final VoidCallback? action = _isLoading ? null : _submitForm;

    return SizedBox(
      width: double.infinity,
      height: 64,
      child: ElevatedButton(
        onPressed: action,
        style: ElevatedButton.styleFrom(
          backgroundColor: isFormValid
              ? AnansiColors.darkBlue
              : Colors.grey.shade300,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AnansiColors.darkBlue,
          disabledForegroundColor: Colors.grey.shade500,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const CupertinoActivityIndicator(color: Colors.white)
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "CONFIRM AND CONTINUE",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.1,
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_forward_rounded, size: 18),
                ],
              ),
      ),
    );
  }
}

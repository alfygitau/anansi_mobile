import 'package:app_anansi_mobile/pages/onboarding/terms_conditions.dart';
import 'package:app_anansi_mobile/services/error_service.dart';
import 'package:app_anansi_mobile/services/onboarding_service.dart';
import 'package:app_anansi_mobile/state/auth_provider.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class NextOfKin extends StatefulWidget {
  const NextOfKin({super.key});

  @override
  State<NextOfKin> createState() => _NextOfKinState();
}

class _NextOfKinState extends State<NextOfKin> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _relationshipController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  bool _isLoading = false;
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _relationshipFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _locationFocus = FocusNode();
  Map<String, String?> formErrors = {
    'name': null,
    'dob': null,
    'relationship': null,
    'phone': null,
    'location': null,
  };

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

  Future<void> submitKin() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final (response, errors) = await OnboardingService().addKin(
        id: authProvider.user?['id'] ?? "",
        fullName: _fullNameController.text.trim(),
        birthDate: _dobController.text.trim(),
        relationship: _relationshipController.text.trim(),
        phone: _phoneNumberController.text.trim(),
        location: _locationController.text.trim(),
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
          MaterialPageRoute(builder: (context) => const TermsConditions()),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _validateField(String key, String value) {
    String? error;
    switch (key) {
      case 'name':
        if (value.trim().isEmpty) {
          error = "Full name is required";
        } else if (value.trim().split(' ').length < 2) {
          error = "Please enter at least two names";
        }
        break;

      case 'dob':
        if (value.trim().isEmpty) error = "Date of birth is required";
        break;

      case 'relationship':
        if (value.trim().isEmpty) error = "Relationship is required";
        break;

      case 'phone':
        if (value.trim().isEmpty) {
          error = "Phone number is required";
        } else if (value.trim().length < 9) {
          error = "Enter a valid phone number";
        }
        break;

      case 'location':
        if (value.trim().isEmpty) error = "Location/Address is required";
        break;
    }
    setState(() {
      formErrors[key] = error;
    });
  }

  @override
  void initState() {
    super.initState();

    _nameFocus.addListener(() {
      if (!_nameFocus.hasFocus) {
        _validateField('name', _fullNameController.text);
      }
    });

    _relationshipFocus.addListener(() {
      if (!_relationshipFocus.hasFocus) {
        _validateField('relationship', _relationshipController.text);
      }
    });

    _phoneFocus.addListener(() {
      if (!_phoneFocus.hasFocus) {
        _validateField('phone', _phoneNumberController.text);
      }
    });

    _locationFocus.addListener(() {
      if (!_locationFocus.hasFocus) {
        _validateField('location', _locationController.text);
      }
    });
  }

  bool get isNextOfKinValid {
    final bool nameReady = _fullNameController.text.trim().length >= 3;
    final bool dobReady = _dobController.text.trim().isNotEmpty;
    final bool relationshipReady = _relationshipController.text
        .trim()
        .isNotEmpty;
    final bool phoneReady = _phoneNumberController.text.trim().length >= 9;
    final bool locationReady = _locationController.text.trim().isNotEmpty;
    return nameReady &&
        dobReady &&
        relationshipReady &&
        phoneReady &&
        locationReady;
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
                    _buildStepHeader(),
                    const SizedBox(height: 22),

                    _buildSectionLabel("KIN IDENTIFICATION"),
                    const SizedBox(height: 16),
                    _buildInputField(
                      label: "Full Name",
                      controller: _fullNameController,
                      hint: "Enter kin's legal name",
                      icon: CupertinoIcons.person_solid,
                      focusNode: _nameFocus,
                      fieldKey: "name",
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      label: "Relationship",
                      controller: _relationshipController,
                      hint: "e.g. Spouse, Sibling, Parent",
                      icon: CupertinoIcons.group_solid,
                      focusNode: _relationshipFocus,
                      fieldKey: "relationship",
                      keyboardType: TextInputType.text,
                    ),

                    const SizedBox(height: 32),
                    _buildSectionLabel("CONTACT & LOGISTICS"),
                    const SizedBox(height: 16),
                    _buildInputField(
                      label: "Phone Number",
                      controller: _phoneNumberController,
                      hint: "e.g 0712345678",
                      icon: CupertinoIcons.phone_fill,
                      focusNode: _phoneFocus,
                      fieldKey: "phone",
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      label: "Primary Location",
                      controller: _locationController,
                      hint: "City or Residential Area",
                      icon: CupertinoIcons.location_solid,
                      focusNode: _locationFocus,
                      fieldKey: "location",
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 16),
                    _buildDateSelector(),
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

  Widget _buildStepHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Next of Kin",
          style: TextStyle(
            color: AnansiColors.darkBlue,
            fontSize: 24,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 12),
        Text(
          "To ensure the security of your account and your membership safety, we require information about your next of kin. This data remains strictly confidential and is only accessed during emergency protocols.",
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
    required String fieldKey,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required FocusNode focusNode,
    required TextInputType keyboardType,
  }) {
    // 1. Extract the current state for this specific field
    final String? errorText = formErrors[fieldKey];
    final bool hasError = errorText != null;
    final bool isFocused = focusNode.hasFocus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            // BORDER LOGIC: Error > Focused > Neutral
            border: Border.all(
              color: hasError
                  ? Colors.redAccent.withValues(alpha: 0.6)
                  : (isFocused
                        ? const Color(0xFF17C6C6)
                        : const Color(0xFFF1F4F8)),
              width: 1.6,
            ),
            boxShadow: [
              BoxShadow(
                color: hasError
                    ? Colors.redAccent.withValues(alpha: 0.05)
                    : (isFocused
                          ? const Color(0xFF17C6C6).withValues(alpha: 0.08)
                          : Colors.black.withValues(alpha: 0.02)),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon Container reacts to state
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: hasError
                      ? Colors.redAccent.withValues(alpha: 0.08)
                      : const Color(0xFF17C6C6).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: hasError ? Colors.redAccent : const Color(0xFF17C6C6),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label.toUpperCase(),
                      style: TextStyle(
                        color: hasError
                            ? Colors.redAccent
                            : const Color(0xFF9E9E9E),
                        fontWeight: FontWeight.w800,
                        fontSize: 9,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    TextField(
                      focusNode: focusNode,
                      controller: controller,
                      keyboardType: keyboardType,
                      onChanged: (val) {
                        if (formErrors[fieldKey] != null) {
                          setState(() => formErrors[fieldKey] = null);
                        }
                        setState(() {});
                      },
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 17,
                      ),
                      onTapOutside: (event) {
                        FocusScope.of(context).unfocus();
                      },
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
        ),

        // ERROR MESSAGE: Animated Slide-in
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: SizedBox(
            height: hasError ? null : 0,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, top: 8),
              child: Text(
                errorText ?? "",
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelector() {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFF1F4F8), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF17C6C6).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                CupertinoIcons.calendar,
                size: 18,
                color: Color(0xFF17C6C6),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "DATE OF BIRTH",
                  style: TextStyle(
                    color: Color(0xFF9E9E9E),
                    fontWeight: FontWeight.w800,
                    fontSize: 9,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _dobController.text.isEmpty
                      ? "Select kin's birthday"
                      : _dobController.text,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: _dobController.text.isEmpty
                        ? Colors.grey.shade300
                        : AnansiColors.darkBlue,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionDock() {
    final VoidCallback? action = _isLoading
        ? () {}
        : (isNextOfKinValid ? submitKin : null);

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF1F4F8), width: 1)),
      ),
      child: ElevatedButton(
        onPressed: action,
        style: ElevatedButton.styleFrom(
          backgroundColor: AnansiColors.darkBlue,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.shade200,
          disabledForegroundColor: Colors.grey.shade500,
          minimumSize: const Size(double.infinity, 64),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CupertinoActivityIndicator(color: Colors.white),
              )
            : Text(
                "FINALIZE REGISTRATION",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1,
                  color: isNextOfKinValid || _isLoading
                      ? Colors.white
                      : Colors.grey.shade500,
                ),
              ),
      ),
    );
  }
}

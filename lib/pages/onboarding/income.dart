import 'package:app_anansi_mobile/pages/onboarding/next_of_kin.dart';
import 'package:app_anansi_mobile/services/error_service.dart';
import 'package:app_anansi_mobile/services/onboarding_service.dart';
import 'package:app_anansi_mobile/state/auth_provider.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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
  final FocusNode _jobTitleFocus = FocusNode();
  final FocusNode _incomeFocus = FocusNode();
  final FocusNode _kraFocus = FocusNode();
  Map<String, String?> formErrors = {
    'jobTitle': null,
    'income': null,
    'kraPin': null,
  };

  @override
  void initState() {
    super.initState();

    _kraFocus.addListener(() {
      if (!_kraFocus.hasFocus) {
        _validateField('kra', _kraController.text);
      }
    });

    _jobTitleFocus.addListener(() {
      if (!_jobTitleFocus.hasFocus) {
        _validateField('occupation', _occupationController.text);
      }
    });

    _incomeFocus.addListener(() {
      if (!_incomeFocus.hasFocus) {
        _validateField('income', _incomeController.text);
      }
    });
  }

  void _validateField(String key, String value) {
    String? error;

    switch (key) {
      case 'kra':
        final kraRegex = RegExp(r'^[A-Z]\d{9}[A-Z]$');
        if (value.trim().isEmpty) {
          error = "KRA PIN is required";
        } else if (!kraRegex.hasMatch(value.toUpperCase())) {
          error = "Enter a valid KRA PIN (e.g., A123456789B)";
        }
        break;

      case 'jobTitle':
        if (value.trim().isEmpty) {
          error = "Please enter your occupation";
        }
        break;

      case 'income':
        if (value.trim().isEmpty) {
          error = "Monthly income is required";
        } else if (double.tryParse(value.replaceAll(',', '')) == null) {
          error = "Please enter a valid amount";
        }
        break;
    }

    setState(() {
      formErrors[key] = error;
    });
  }

  Future<void> _updateCustomer() async {
    setState(() {
      _isLoading = true;
    });
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      final (response, errors) = await OnboardingService().updateFinancials(
        id: authProvider.user?['id'] ?? "",
        countryOfResidence: "Kenya",
        employmentType: employmentType ?? "",
        kra: _kraController.text.trim(),
        jobTitle: _occupationController.text.trim(),
        income: _incomeController.text.trim(),
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
          MaterialPageRoute(builder: (context) => const NextOfKin()),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  bool get isFinancialFormValid {
    final bool kraReady = _kraController.text.trim().length == 11;
    final bool occupationReady = _occupationController.text.trim().isNotEmpty;
    final bool incomeReady = _incomeController.text.trim().isNotEmpty;
    final bool dropdownsReady =
        (employmentType != null &&
        !employmentType!.toLowerCase().contains('select'));

    return kraReady && occupationReady && incomeReady && dropdownsReady;
  }

  @override
  void dispose() {
    _kraFocus.dispose();
    _jobTitleFocus.dispose();
    _incomeFocus.dispose();
    _kraController.dispose();
    _occupationController.dispose();
    _incomeController.dispose();
    super.dispose();
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
                      focusNode: _jobTitleFocus,
                      fieldKey: "jobTitle",
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 32),
                    _buildSectionLabel("FINANCIAL PROFILE"),
                    const SizedBox(height: 16),
                    _buildInputField(
                      label: "Monthly Income (KES)",
                      controller: _incomeController,
                      hint: "Enter net monthly salary",
                      icon: CupertinoIcons.money_dollar_circle,
                      focusNode: _incomeFocus,
                      fieldKey: "income",
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      label: "KRA PIN (Optional)",
                      controller: _kraController,
                      hint: "e.g. A012345678X",
                      icon: CupertinoIcons.doc_text_search,
                      focusNode: _kraFocus,
                      fieldKey: "kraPin",
                      keyboardType: TextInputType.text,
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
            color: Colors.black.withValues(alpha: 0.02),
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
            color: const Color(0xFF17C6C6).withValues(alpha: 0.08),
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
    // Logic:
    // 1. If loading, give it an empty function to keep it blue/active.
    // 2. If not loading but form is invalid, give it null (turns it grey).
    // 3. Otherwise, give it the update function.
    final VoidCallback? action = _isLoading
        ? () {}
        : (isFinancialFormValid ? _updateCustomer : null);

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
          // Shows grey when the form is actually invalid
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
                "SAVE AND CONTINUE",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1,
                  // Text is white if the button is clickable OR currently loading
                  color: isFinancialFormValid || _isLoading
                      ? Colors.white
                      : Colors.grey.shade500,
                ),
              ),
      ),
    );
  }
}

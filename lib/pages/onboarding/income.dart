import 'dart:convert';
import 'package:app_anansi_mobile/pages/onboarding/next_of_kin.dart';
import 'package:app_anansi_mobile/services/error_service.dart';
import 'package:app_anansi_mobile/services/onboarding_service.dart';
import 'package:app_anansi_mobile/services/secure_storage_service.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  void validateInputs() {
    _validateField('kra', _kraController.text);
    _validateField('jobTitle', _occupationController.text);
    _validateField('income', _incomeController.text);
  }

  void _validateField(String key, String value) {
    String? error;

    switch (key) {
      case 'kra':
        final kraRegex = RegExp(r'^[A-Z]\d{9}[A-Z]$');
        if (value.trim().isNotEmpty &&
            !kraRegex.hasMatch(value.toUpperCase())) {
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

  Future<Map<String, dynamic>?> getUser() async {
    String? userJson = await SecureStorageService().read('user');
    if (userJson == null) return null;
    Map<String, dynamic> userMap = jsonDecode(userJson);
    return userMap;
  }

  Future<void> _updateCustomer() async {
    validateInputs();
    if (!isFinancialFormValid) {
      HapticFeedback.vibrate();
      return;
    }
    setState(() {
      _isLoading = true;
    });
    final user = await getUser();
    try {
      final (response, errors) = await OnboardingService().updateFinancials(
        id: user?['id'] ?? "",
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
    final bool occupationReady = _occupationController.text.trim().isNotEmpty;
    final bool incomeReady = _incomeController.text.trim().isNotEmpty;
    final bool dropdownsReady =
        (employmentType != null &&
        !employmentType!.toLowerCase().contains('select'));

    return occupationReady && incomeReady && dropdownsReady;
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
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Pinned Header Bar
            SliverAppBar(
              pinned: true,
              floating: false,
              backgroundColor: Colors.white,
              surfaceTintColor:
                  Colors.transparent, // Prevents M3 scroll overlay tint
              elevation: 0,
              scrolledUnderElevation: 0,
              automaticallyImplyLeading: false,
              titleSpacing: 24,
              centerTitle: false,
              title: const Text(
                "Profile Information",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AnansiColors.darkBlue,
                  letterSpacing: -1.5,
                ),
              ),
            ),

            // Scrollable Body Content
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    _buildStepHeader(),
                    const SizedBox(height: 24),
                    _buildSectionLabel("EMPLOYMENT STATUS"),
                    const SizedBox(height: 14),
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
                    const SizedBox(height: 14),
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

                    // Buffer space so fields clear the bottom dock on scroll
                    const SizedBox(height: 140),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Fixed Bottom Action Dock
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 25),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.95)),
        child: _buildActionDock(),
      ),
    );
  }

  Widget _buildStepHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Income Details",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AnansiColors.darkBlue,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Please provide your income details to help us establish your credit limit and tailor financial products to your profile.",
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
                  : (isFocused
                        ? const Color(0xFFE2E8F0)
                        : const Color(0xFFE2E8F0)),
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
                    fontWeight: FontWeight.w500,
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
          height: 64,
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

  Widget _buildDropdownRow(IconData icon, String text, {required bool isHint}) {
    return Row(
      children: [
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

  Widget _buildActionDock() {
    final VoidCallback? action = _isLoading ? null : _updateCustomer;

    return SizedBox(
      width: double.infinity,
      height: 64,
      child: ElevatedButton(
        onPressed: action,
        style: ElevatedButton.styleFrom(
          backgroundColor: isFinancialFormValid
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
                    "SAVE AND CONTINUE",
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

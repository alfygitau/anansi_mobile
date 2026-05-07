import 'package:app_anansi_mobile/components/profile_success.dart';
import 'package:app_anansi_mobile/pages/profile/profile.dart';
import 'package:app_anansi_mobile/services/error_service.dart';
import 'package:app_anansi_mobile/services/profile_service.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditFinancialsPage extends StatefulWidget {
  final Map<String, dynamic> customer;
  const EditFinancialsPage({super.key, required this.customer});

  @override
  State<EditFinancialsPage> createState() => _EditFinancialsPageState();
}

class _EditFinancialsPageState extends State<EditFinancialsPage> {
  late TextEditingController _jobTitleController;
  late TextEditingController _incomeController;
  late TextEditingController _kraPinController;
  Map<String, String?> formErrors = {'email': null, 'password': null};
  String? _selectedJobType;
  final List<String> _jobTypes = [
    "Permanent",
    "Contract",
    "Self-Employed",
    "Unemployed",
    "Employed",
  ];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _jobTitleController = TextEditingController(
      text: widget.customer['occupation'],
    );
    _kraPinController = TextEditingController(text: widget.customer['kraPin']);
    _incomeController = TextEditingController(
      text: widget.customer['income_range'],
    );
    _selectedJobType = widget.customer['employment_type'];
  }

  Future<void> _editFinance() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final (response, errors) = await ProfileService().updateFinancials(
        id: widget.customer['id'] ?? "",
        employmentType: _selectedJobType ?? "",
        kra: _kraPinController.text.trim(),
        jobTitle: _jobTitleController.text.trim(),
        income: _incomeController.text.trim(),
      );
      if (errors != null) {
        ErrorService.showActionableError(
          context,
          title: errors[0],
          message: errors[1],
        );
      } else if (response != null) {
        showProfileSuccessSheet(
          context,
          title: "Financials Updated!",
          onAction: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Profile()),
            );
          },
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSectionTitle("Employment Information"),
                _buildInputField(
                  label: "Job Title",
                  controller: _jobTitleController,
                  hint: "e.g. Senior Accountant",
                  icon: CupertinoIcons.briefcase,
                  fieldKey: "jobTitle",
                  focusNode: FocusNode(),
                ),
                const SizedBox(height: 16),
                _buildDropdownField(
                  label: "Employment Type",
                  value: _selectedJobType,
                  items: _jobTypes,
                  icon: CupertinoIcons.rectangle_stack_person_crop,
                  onChanged: (val) => setState(() => _selectedJobType = val),
                ),

                const SizedBox(height: 32),
                _buildSectionTitle("Financial Records"),
                _buildInputField(
                  label: "KRA PIN",
                  controller: _kraPinController,
                  hint: "A00XXXXXXXXZ",
                  icon: CupertinoIcons.doc_text,
                  fieldKey: "kra",
                  focusNode: FocusNode(),
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  label: "Monthly Income (KES)",
                  controller: _incomeController,
                  hint: "e.g 200000",
                  icon: CupertinoIcons.doc_text,
                  fieldKey: "income",
                  focusNode: FocusNode(),
                ),
                const SizedBox(height: 24),
                _buildComplianceNote(),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildPersistentFooter(),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      backgroundColor: ThemeColors.background.withValues(alpha: 0.95),
      elevation: 0,
      centerTitle: true,
      leadingWidth: 64,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "My Profile",
            style: TextStyle(
              color: AnansiColors.darkBlue,
              fontWeight: FontWeight.w900,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            "EDIT FINANCIAL DETAILS",
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
      leading: Center(
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(
              CupertinoIcons.back,
              size: 18,
              color: AnansiColors.darkBlue,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: _buildCircleAction(CupertinoIcons.question_circle, () {}),
        ),
      ],
    );
  }

  Widget _buildCircleAction(IconData icon, VoidCallback onTap) {
    return Center(
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(icon, size: 18, color: AnansiColors.darkBlue),
          onPressed: onTap,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 16),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w900,
          color: Color(0xFF17C6C6),
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildComplianceNote() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF17C6C6).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF17C6C6).withValues(alpha: 0.1),
        ),
      ),
      child: const Row(
        children: [
          Icon(
            CupertinoIcons.info_circle_fill,
            color: Color(0xFF17C6C6),
            size: 20,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Your financial data is encrypted and used only for credit scoring and Sacco compliance.",
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF0A2351),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersistentFooter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      color: Colors.white,
      child: SizedBox(
        width: double.infinity,
        height: 58,
        child: ElevatedButton(
          onPressed: _isLoading ? () {} : _editFinance,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0A2351),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: _isLoading
              ? const CupertinoActivityIndicator(color: Colors.white)
              : const Text(
                  "Update Records",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }

  // Include the _buildInputField and _buildDropdownField methods here as previously defined
  Widget _buildInputField({
    required String label,
    required String fieldKey,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required FocusNode focusNode,
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
                  style: const TextStyle(
                    fontSize: 17,
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
}

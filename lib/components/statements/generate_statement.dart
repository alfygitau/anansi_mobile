import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GenerateStatement extends StatefulWidget {
  final List<Map<String, dynamic>> accounts;
  final VoidCallback onSubmit;
  final bool isLoading;

  const GenerateStatement({
    super.key,
    required this.accounts,
    required this.onSubmit,
    required this.isLoading,
  });

  @override
  State<GenerateStatement> createState() => _GenerateStatementState();
}

class _GenerateStatementState extends State<GenerateStatement> {
  // Local Form Model Parameters
  String? _selectedAccountId;
  String? _selectedDuration;
  DateTime? _startDate;
  DateTime? _endDate;

  // Track field state validations precisely
  final Map<String, String?> _formErrors = {};

  // Track node focus to drive high-fidelity icon badge animations
  final FocusNode _accountFocusNode = FocusNode();
  final FocusNode _durationFocusNode = FocusNode();
  final FocusNode _startDateFocusNode = FocusNode();
  final FocusNode _endDateFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Re-render design hooks dynamically when focus bounds shift
    _accountFocusNode.addListener(() => setState(() {}));
    _durationFocusNode.addListener(() => setState(() {}));
    _startDateFocusNode.addListener(() => setState(() {}));
    _endDateFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _accountFocusNode.dispose();
    _durationFocusNode.dispose();
    _startDateFocusNode.dispose();
    _endDateFocusNode.dispose();
    super.dispose();
  }

  void _validateFields() {
    _formErrors.clear();

    if (_selectedAccountId == null || _selectedAccountId!.isEmpty) {
      _formErrors['accountId'] = "Please select a target account";
    }

    final hasPreset =
        _selectedDuration != null && _selectedDuration!.isNotEmpty;
    final hasCustomRange = _startDate != null && _endDate != null;

    if (!hasPreset && !hasCustomRange) {
      _formErrors['dateRange'] =
          "Please pick a preset duration or set custom dates";
    }
    setState(() {});
  }

  bool _isFormInvalid() {
    if (_selectedAccountId == null || _selectedAccountId!.isEmpty) return true;
    final hasPreset =
        _selectedDuration != null && _selectedDuration!.isNotEmpty;
    final hasCustomRange = _startDate != null && _endDate != null;
    return !((hasPreset && !hasCustomRange) || (hasCustomRange && !hasPreset));
  }

  String _formatDisplayDate(DateTime? date) {
    if (date == null) return '';
    final List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return "${date.day} ${months[date.month - 1]} ${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    final double keyboardPadding = MediaQuery.of(context).viewInsets.bottom;
    final bool isPresetDisabled = _startDate != null || _endDate != null;
    final bool isCustomDisabled =
        _selectedDuration != null && _selectedDuration!.isNotEmpty;
    final bool isSubmitDisabled = widget.isLoading || _isFormInvalid();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      padding: EdgeInsets.fromLTRB(20, 10, 20, 24 + keyboardPadding),
      // ⚡ Crucial: Letting content define sheet height layout implicitly
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.only(bottom: 20, top: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0), // Muted slate pull bar color
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Custom Statement",
                      style: TextStyle(
                        color: AnansiColors.darkBlue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Select your preferences below",
                      style: TextStyle(
                        color: AnansiColors.darkBlue.withValues(alpha: 0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              "Configure your preferences below. The system will compile your requested account details into a secure document.",
              style: TextStyle(
                color: Color(0xFF64748B),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
          Builder(
            builder: (context) {
              // Map the complex list of objects to simple display strings for the dropdown menu
              final List<String> accountOptions = widget.accounts.map((acc) {
                final String name = acc['product']?['name'] ?? 'Account';
                final String num =
                    acc['account_number']?.toString().substring(
                      acc['account_number'].toString().length - 4,
                    ) ??
                    '****';
                return "$name (****$num)";
              }).toList();

              // Determine the current matching display string value from local state ID
              String? currentSelectedOption;
              try {
                final matchedAcc = widget.accounts.firstWhere(
                  (element) => element['id'].toString() == _selectedAccountId,
                );
                final String name = matchedAcc['product']?['name'] ?? 'Account';
                final String num =
                    matchedAcc['account_number']?.toString().substring(
                      matchedAcc['account_number'].toString().length - 4,
                    ) ??
                    '****';
                currentSelectedOption = "$name (****$num)";
              } catch (_) {
                currentSelectedOption = null;
              }

              return _buildDropdownField(
                label: "Target Account",
                value: currentSelectedOption,
                items: accountOptions,
                icon: CupertinoIcons.creditcard,
                onChanged: (String? selectedDisplayString) {
                  if (selectedDisplayString == null) return;

                  // Find the corresponding ID from the matching display string index
                  final int matchedIndex = accountOptions.indexOf(
                    selectedDisplayString,
                  );
                  final String trueId = widget.accounts[matchedIndex]['id']
                      .toString();

                  setState(() {
                    _selectedAccountId = trueId;
                  });
                  _validateFields();
                },
              );
            },
          ),
          const SizedBox(height: 20),
          Opacity(
            opacity: isPresetDisabled ? 0.4 : 1.0,
            child: _buildDropdownField(
              label: "Statement Duration",
              value: _selectedDuration == "month_to_date"
                  ? "This Month"
                  : _selectedDuration == "last_month"
                  ? "Last Month"
                  : _selectedDuration == "three_months"
                  ? "Last 3 Months"
                  : _selectedDuration == "six_months"
                  ? "Last 6 Months"
                  : _selectedDuration,
              items: const [
                "This Month",
                "Last Month",
                "Last 3 Months",
                "Last 6 Months",
              ],
              icon: CupertinoIcons.time,
              // ⚡ FIX: Swap null for an empty action placeholder method block to satisfy Dart static checking profiles
              onChanged: isPresetDisabled
                  ? (_) {}
                  : (String? selectedOption) {
                      String? internalValue;
                      if (selectedOption == "This Month") {
                        internalValue = "month_to_date";
                      }
                      if (selectedOption == "Last Month") {
                        internalValue = "last_month";
                      }
                      if (selectedOption == "Last 3 Months") {
                        internalValue = "three_months";
                      }
                      if (selectedOption == "Last 6 Months") {
                        internalValue = "six_months";
                      }

                      setState(() {
                        _selectedDuration = internalValue;
                        _startDate = null;
                        _endDate = null;
                      });
                      _validateFields();
                    },
            ),
          ),
          if (_selectedDuration == null &&
              _startDate == null &&
              _endDate == null) ...[
            const SizedBox(height: 16),
            const Center(
              child: Text(
                "— OR —",
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFCBD5E1),
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ] else ...[
            const SizedBox(height: 20),
          ],
          Opacity(
            opacity: isCustomDisabled ? 0.4 : 1.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: isCustomDisabled
                      ? null
                      : () async {
                          _startDateFocusNode.requestFocus();
                          final selected = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          if (selected != null) {
                            setState(() {
                              _startDate = selected;
                              _selectedDuration = null;
                              _formErrors['dateRange'] = null;
                            });
                            _validateFields();
                          }
                          _startDateFocusNode.unfocus();
                        },
                  child: _buildFormInputWrapper(
                    label: "Start Date",
                    fieldKey: "startDate",
                    icon: CupertinoIcons.calendar,
                    focusNode: _startDateFocusNode,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        _startDate != null
                            ? _formatDisplayDate(_startDate)
                            : "Select start date",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: _startDate != null
                              ? AnansiColors.darkBlue
                              : Colors.blueGrey.shade200,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: isCustomDisabled
                      ? null
                      : () async {
                          _endDateFocusNode.requestFocus();
                          final selected = await showDatePicker(
                            context: context,
                            initialDate: _startDate ?? DateTime.now(),
                            firstDate: _startDate ?? DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          if (selected != null) {
                            setState(() {
                              _endDate = selected;
                              _selectedDuration = null;
                              _formErrors['dateRange'] = null;
                            });
                            _validateFields();
                          }
                          _endDateFocusNode.unfocus();
                        },
                  child: _buildFormInputWrapper(
                    label: "End Date",
                    fieldKey: "endDate",
                    icon: CupertinoIcons.calendar,
                    focusNode: _endDateFocusNode,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        _endDate != null
                            ? _formatDisplayDate(_endDate)
                            : "Select end date",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: _endDate != null
                              ? AnansiColors.darkBlue
                              : Colors.blueGrey.shade200,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_formErrors['dateRange'] != null) ...[
            const SizedBox(height: 12),
            Text(
              _formErrors['dateRange']!,
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          const SizedBox(height: 58),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: isSubmitDisabled
                  ? null
                  : () {
                      Navigator.pop(context);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AnansiColors.darkBlue,
                disabledBackgroundColor: const Color(0xFFF1F5F9),
                elevation: isSubmitDisabled ? 0 : 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              child: widget.isLoading
                  ? const CupertinoActivityIndicator(color: Colors.white)
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.doc_text,
                          color: Colors.white,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Generate Statement",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  // Helper template wrapping layout elements exactly like your local design function
  Widget _buildFormInputWrapper({
    required String label,
    required String fieldKey,
    required IconData icon,
    required FocusNode focusNode,
    required Widget child,
  }) {
    final String? errorText = _formErrors[fieldKey];
    final bool hasError = errorText != null;
    final bool isFocused = focusNode.hasFocus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 6),
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
              Expanded(child: child),
            ],
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 8),
            child: Text(
              errorText,
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
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

// Inline styling parsing helper extension
extension on TextStyle {
  Widget toTextHint(String value) => Text(value, style: this);
}

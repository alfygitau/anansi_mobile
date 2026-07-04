import 'package:app_anansi_mobile/services/error_service.dart';
import 'package:app_anansi_mobile/services/statement_service.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GenerateStatement extends StatefulWidget {
  final List<Map<String, dynamic>> accounts;
  final VoidCallback onRefreshParent;

  const GenerateStatement({
    super.key,
    required this.accounts,
    required this.onRefreshParent,
  });

  @override
  State<GenerateStatement> createState() => _GenerateStatementState();
}

class _GenerateStatementState extends State<GenerateStatement> {
  // Local Form Model Parameters
  String? _selectedAccountId;
  String? _selectedDuration;
  bool _isLoading = false; // Internal isolated state manager for the spinner

  // Track field state validations precisely
  final Map<String, String?> _formErrors = {};

  // Track node focus to drive high-fidelity icon badge animations
  final FocusNode _accountFocusNode = FocusNode();
  final FocusNode _durationFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _accountFocusNode.addListener(() => setState(() {}));
    _durationFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _accountFocusNode.dispose();
    _durationFocusNode.dispose();
    super.dispose();
  }

  void _validateFields() {
    _formErrors.clear();

    if (_selectedAccountId == null || _selectedAccountId!.isEmpty) {
      _formErrors['accountId'] = "Please select a target account";
    }

    if (_selectedDuration == null || _selectedDuration!.isEmpty) {
      _formErrors['duration'] = "Please pick a statement duration";
    }
    setState(() {});
  }

  bool _isFormInvalid() {
    if (_selectedAccountId == null || _selectedAccountId!.isEmpty) return true;
    if (_selectedDuration == null || _selectedDuration!.isEmpty) return true;
    return false;
  }

  Future<void> _handleGenerateStatement() async {
    if (_isFormInvalid()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final (response, error) = await StatementService().generateStatement(
        duration: _selectedDuration!,
        accountId: _selectedAccountId!,
      );

      if (error != null) {
        if (mounted) {
          ErrorService.showActionableError(
            context,
            title: error[0],
            message: error[1],
          );
        }
      } else if (response != null) {
        if (mounted) {
          widget.onRefreshParent();
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ErrorService.showActionableError(
          context,
          title: "System Exception",
          message: e.toString(),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double keyboardPadding = MediaQuery.of(context).viewInsets.bottom;
    final bool isSubmitDisabled = _isFormInvalid();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      padding: EdgeInsets.fromLTRB(20, 10, 20, 24 + keyboardPadding),
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
                color: const Color(0xFFE2E8F0),
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
              final List<String> accountOptions = widget.accounts.map((acc) {
                final String name = acc['product']?['name'] ?? 'Account';
                final String num =
                    acc['account_number']?.toString().substring(
                      acc['account_number'].toString().length - 4,
                    ) ??
                    '****';
                return "$name (****$num)";
              }).toList();

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
          _buildDropdownField(
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
            onChanged: (String? selectedOption) {
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
              });
              _validateFields();
            },
          ),
          const SizedBox(height: 58),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              // ⚡ Intercept click if already loading, otherwise fire the submission logic
              onPressed: isSubmitDisabled || _isLoading
                  ? null
                  : _handleGenerateStatement,
              style: ElevatedButton.styleFrom(
                // ⚡ If loading, force the background to stay darkBlue instead of turning grey
                backgroundColor: _isLoading
                    ? AnansiColors.darkBlue
                    : AnansiColors.darkBlue,
                disabledBackgroundColor: _isLoading
                    ? AnansiColors
                          .darkBlue // Keeps it blue while loading
                    : const Color(0xFFF1F5F9), // Normal form-invalid grey style
                elevation: isSubmitDisabled ? 0 : 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              child: _isLoading
                  ? const CupertinoActivityIndicator(
                      color: Colors.white,
                    ) // White spinner on blue looks great
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
          const SizedBox(height: 20),
        ],
      ),
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

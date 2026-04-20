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
  late TextEditingController _kraPinController;

  String? _selectedIncome;
  String? _selectedJobType;

  // Static options for Sacco compliance
  final List<String> _incomeRanges = [
    "Below 50,000",
    "50,000 - 100,000",
    "100,000 - 250,000",
    "250,000 - 500,000",
    "Above 500,000",
  ];

  final List<String> _jobTypes = [
    "Permanent",
    "Contract",
    "Self-Employed",
    "Unemployed",
  ];

  @override
  void initState() {
    super.initState();
    _jobTitleController = TextEditingController(
      text: widget.customer['occupation'],
    );
    _kraPinController = TextEditingController(text: widget.customer['kraPin']);
    _selectedIncome = widget.customer['income_range'];
    _selectedJobType = widget.customer['employment_type'];
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
                ),
                const SizedBox(height: 16),
                _buildDropdownField(
                  label: "Monthly Income (KES)",
                  value: _selectedIncome,
                  items: _incomeRanges,
                  icon: CupertinoIcons.money_dollar_circle,
                  onChanged: (val) => setState(() => _selectedIncome = val),
                ),

                const SizedBox(height: 24),
                _buildComplianceNote(),
              ]),
            ),
          ),
        ],
      ),
      bottomSheet: _buildPersistentFooter(),
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
        color: const Color(0xFF17C6C6).withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF17C6C6).withOpacity(0.1)),
      ),
      child: const Row(
        children: [
          Icon(
            CupertinoIcons.info_circle_fill,
            color: Color(0xFF17C6C6),
            size: 20,
          ),
          const SizedBox(width: 12),
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
          onPressed: () {
            // Logic to update financials
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0A2351),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: const Text(
            "Update Records",
            style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
          ),
        ),
      ),
    );
  }

  // Include the _buildInputField and _buildDropdownField methods here as previously defined
  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPhone = false,
    bool readOnly = false, // Add this
    VoidCallback? onTap, // Add this
  }) {
    return GestureDetector(
      onTap: onTap, // Allows the whole container to be tappable
      child: Container(
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
                    readOnly: readOnly, // Set this
                    enabled: !readOnly, // And this
                    keyboardType: isPhone
                        ? TextInputType.phone
                        : TextInputType.text,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontSize: 17,
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
            if (readOnly) // Show a small chevron for selection fields
              Icon(
                CupertinoIcons.chevron_right,
                size: 14,
                color: Colors.grey.shade300,
              ),
          ],
        ),
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
                  fontSize: 17,
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
}

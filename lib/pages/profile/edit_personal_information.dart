import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditPersonalInformation extends StatefulWidget {
  final Map<String, dynamic> customer;
  const EditPersonalInformation({super.key, required this.customer});

  @override
  State<EditPersonalInformation> createState() =>
      _EditPersonalInformationState();
}

class _EditPersonalInformationState extends State<EditPersonalInformation> {
  // Controllers initialized with your static data
  late TextEditingController _firstNameController;
  late TextEditingController _middleNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _idNumberController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  Map<String, String?> formErrors = {'email': null, 'password': null};
  late String _selectedGender;
  DateTime? _selectedDob;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(
      text: widget.customer['firstname'],
    );
    _middleNameController = TextEditingController(
      text: widget.customer['middlename'] ?? "",
    );
    _lastNameController = TextEditingController(
      text: widget.customer['lastname'],
    );
    _idNumberController = TextEditingController(
      text: widget.customer['identification'],
    );
    _emailController = TextEditingController(text: widget.customer['email']);
    _phoneController = TextEditingController(text: widget.customer['mobileno']);
    _selectedGender = widget.customer['gender'] ?? "Male";
    _selectedDob = DateTime.tryParse(widget.customer['dob'] ?? "");
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
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 150),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSectionTitle("Legal Identity"),
                _buildInputField(
                  label: "First Name",
                  controller: _firstNameController,
                  hint: "Enter first name",
                  icon: CupertinoIcons.person,
                  fieldKey: "firstName",
                  focusNode: FocusNode(),
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  label: "Middle Name",
                  controller: _middleNameController,
                  hint: "Enter middle name (optional)",
                  icon: CupertinoIcons.person_crop_rectangle,
                  fieldKey: "middleName",
                  focusNode: FocusNode(),
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  label: "Last Name",
                  controller: _lastNameController,
                  hint: "Enter last name",
                  icon: CupertinoIcons.person_2,
                  fieldKey: "lastName",
                  focusNode: FocusNode(),
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  label: "ID Number",
                  controller: _idNumberController,
                  hint: "Enter national ID",
                  icon: CupertinoIcons.doc_plaintext,
                  fieldKey: "idNumber",
                  focusNode: FocusNode(),
                ),

                const SizedBox(height: 32),
                _buildSectionTitle("Contact & Demographics"),
                _buildInputField(
                  label: "Email Address",
                  controller: _emailController,
                  hint: "name@example.com",
                  icon: CupertinoIcons.mail,
                  fieldKey: "email",
                  focusNode: FocusNode(),
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  label: "Phone Number",
                  controller: _phoneController,
                  hint: "0712...",
                  icon: CupertinoIcons.phone,
                  fieldKey: "mobile",
                  focusNode: FocusNode(),
                ),
                const SizedBox(height: 16),

                // For Gender and DOB, we use a similar style but customized for selection
                _buildDropdownField(
                  label: "Gender",
                  value: _selectedGender,
                  items: ["Male", "Female", "Other"],
                  icon: CupertinoIcons.person_circle,
                  onChanged: (val) => setState(() => _selectedGender = val!),
                ),
                const SizedBox(height: 16),
                _buildDatePickerField(),
              ]),
            ),
          ),
        ],
      ),
      bottomSheet: _buildPersistentFooter(),
    );
  }

  // 1. The Selection Field Widget
  Widget _buildDatePickerField() {
    return _buildInputField(
      label: "Date of Birth",
      controller: TextEditingController(
        text: _selectedDob == null
            ? ""
            : "${_selectedDob!.day}/${_selectedDob!.month}/${_selectedDob!.year}",
      ),
      hint: "Select your birthday",
      icon: CupertinoIcons.calendar,
      fieldKey: "dob",
      focusNode: FocusNode(),
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
            "EDIT MEMBER INFORMATION",
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
          color: AnansiColors.darkBlue,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  // Your custom Input Field
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

  Widget _buildPersistentFooter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 58,
        child: ElevatedButton(
          onPressed: () {
            // Save logic
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0A2351),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            elevation: 0,
          ),
          child: const Text(
            "Save Changes",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
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

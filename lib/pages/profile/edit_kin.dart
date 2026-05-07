import 'package:app_anansi_mobile/components/profile_success.dart';
import 'package:app_anansi_mobile/pages/profile/profile.dart';
import 'package:app_anansi_mobile/services/error_service.dart';
import 'package:app_anansi_mobile/services/profile_service.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditNextOfKin extends StatefulWidget {
  final Map<String, dynamic> nextOfKin;
  const EditNextOfKin({super.key, required this.nextOfKin});

  @override
  State<EditNextOfKin> createState() => _EditNextOfKinState();
}

class _EditNextOfKinState extends State<EditNextOfKin> {
  late TextEditingController _nameController;
  late TextEditingController _mobileController;
  late TextEditingController _locationController;
  late TextEditingController _dobController;
  late TextEditingController _relationshipController;
  bool _isLoading = false;
  Map<String, String?> formErrors = {
    "name": null,
    "mobile": null,
    "location": null,
    "relationship": null,
    "dob": null,
  };

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _mobileFocus = FocusNode();
  final FocusNode _locationFocus = FocusNode();
  final FocusNode _relationshipFocus = FocusNode();
  final FocusNode _dobFocus = FocusNode();

  void _validateMobile(String value) {
    setState(() {
      final bool phoneValid = RegExp(
        r'^(?:254|\+254|0)?(7|1)(?:[0-9]){8}$',
      ).hasMatch(value);
      if (!phoneValid) {
        formErrors['mobile'] = "Enter a valid Kenyan number (e.g. 0712...)";
      } else {
        formErrors['mobile'] = null;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.nextOfKin['name'] ?? "",
    );
    _mobileController = TextEditingController(
      text: widget.nextOfKin['phoneNumber'] ?? "",
    );
    _locationController = TextEditingController(
      text: widget.nextOfKin['location'] ?? "",
    );
    _dobController = TextEditingController(
      text: widget.nextOfKin['dateOfBirth'] ?? "",
    );
    _relationshipController = TextEditingController(
      text: widget.nextOfKin['relationship'] ?? "",
    );

    _mobileFocus.addListener(() {
      if (!_mobileFocus.hasFocus) _validateMobile(_mobileController.text);
    });
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 6570)),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AnansiColors.darkBlue,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _editOfKin() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final (response, errors) = await ProfileService().updateKin(
        id: widget.nextOfKin['id'] ?? "",
        fullName: _nameController.text.trim(),
        birthDate: _dobController.text.trim(),
        relationship: _relationshipController.text.trim(),
        phone: _mobileController.text.trim(),
        location: _locationController.text.trim(),
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
          title: "Kin Updated!",
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
                _buildSectionTitle("Personal Details"),
                _buildInputField(
                  label: "Full Name",
                  controller: _nameController,
                  hint: "Enter kin's legal name",
                  icon: CupertinoIcons.person,
                  fieldKey: "name",
                  keyboardType: TextInputType.name,
                  focusNode: _nameFocus,
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  label: "Relationship",
                  controller: _relationshipController,
                  hint: "Enter relationship",
                  icon: CupertinoIcons.phone,
                  fieldKey: "relationship",
                  keyboardType: TextInputType.phone,
                  focusNode: _relationshipFocus,
                ),
                const SizedBox(height: 32),
                _buildSectionTitle("Contact & Verification"),
                _buildInputField(
                  label: "Mobile Number",
                  controller: _mobileController,
                  hint: "07XX XXX XXX",
                  icon: CupertinoIcons.phone,
                  fieldKey: "mobile",
                  keyboardType: TextInputType.phone,
                  focusNode: _mobileFocus,
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: _selectDate,
                  child: AbsorbPointer(
                    child: _buildInputField(
                      label: "Date of Birth",
                      controller: _dobController,
                      hint: "YYYY-MM-DD",
                      icon: CupertinoIcons.calendar,
                      fieldKey: "dob",
                      keyboardType: TextInputType.datetime,
                      focusNode: _dobFocus,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  label: "Residential Location",
                  controller: _locationController,
                  hint: "Area, Town or Estate",
                  icon: CupertinoIcons.location,
                  fieldKey: "location",
                  keyboardType: TextInputType.text,
                  focusNode: _locationFocus,
                ),
                const SizedBox(height: 24),
                _buildSecurityNote(),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildPersistentFooter(),
    );
  }

  // --- UI Components (Adapted to Next of Kin) ---
  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      backgroundColor: const Color(0xFFF8FAFC).withValues(alpha: 0.95),
      elevation: 0,
      centerTitle: true,
      title: Column(
        children: [
          const Text(
            "My Profile",
            style: TextStyle(
              color: AnansiColors.darkBlue,
              fontWeight: FontWeight.w900,
              fontSize: 15,
            ),
          ),
          Text(
            "NEXT OF KIN DETAILS",
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
      leading: _buildCircleBackBtn(),
    );
  }

  Widget _buildCircleBackBtn() {
    return Center(
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

  Widget _buildSecurityNote() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F4F8)),
      ),
      child: const Row(
        children: [
          Icon(CupertinoIcons.shield, color: Colors.teal, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Ensure these details are accurate as they are required for legal and emergency benefit processing.",
              style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.4),
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
          onPressed: _isLoading ? () {} : _editOfKin,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0A2351),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            elevation: 0,
          ),
          child: _isLoading
              ? const CupertinoActivityIndicator(color: Colors.white)
              : const Text(
                  "Save Details",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
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
}

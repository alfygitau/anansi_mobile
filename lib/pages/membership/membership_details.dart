import 'dart:convert';
import 'package:app_anansi_mobile/pages/membership/register_invest.dart';
import 'package:app_anansi_mobile/services/secure_storage_service.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MembershipDetails extends StatefulWidget {
  const MembershipDetails({super.key});

  @override
  State<MembershipDetails> createState() => _MembershipDetailsState();
}

class _MembershipDetailsState extends State<MembershipDetails> {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _amountController = TextEditingController(
    text: "1,000.00",
  );
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _feeFocus = FocusNode();
  Map<String, String?> formErrors = {'phone': null};
  Map<String, dynamic>? user;

  void _validateField(String key, String value) {
    String? error;
    switch (key) {
      case 'phone':
        final String phone = value.trim();
        final RegExp kenyanRegex = RegExp(r'^(?:\+254|254|0)(7|1)[0-9]{8}$');
        if (phone.isEmpty) {
          error = "Phone number is required";
        } else if (!kenyanRegex.hasMatch(phone.replaceAll(' ', ''))) {
          error = "Enter a valid Kenyan number (e.g. 0712345678)";
        }
        break;
    }
    setState(() {
      formErrors[key] = error;
    });
  }

  bool get isPhoneValid {
    // 1. Remove all spaces, dashes, and the + sign for testing
    final cleanPhone = _mobileController.text.trim().replaceAll(
      RegExp(r'[\s\-\+]'),
      '',
    );

    // 2. Kenyan RegEx: Starts with 07, 01, 2547, or 2541 followed by 8 digits
    final RegExp kenyanRegex = RegExp(r'^(?:254|0)(7|1)[0-9]{8}$');

    return kenyanRegex.hasMatch(cleanPhone);
  }

  Future<Map<String, dynamic>?> getUser() async {
    String? userJson = await SecureStorageService().read('user');
    if (userJson == null) return null;
    Map<String, dynamic> userMap = jsonDecode(userJson);
    return userMap;
  }

  @override
  void initState() {
    super.initState();
    _initializeInfo();

    _phoneFocus.addListener(() {
      if (!_phoneFocus.hasFocus) {
        _validateField('phone', _mobileController.text);
      }
    });
  }

  Future<void> _initializeInfo() async {
    final myUser = await getUser();
    setState(() {
      user = myUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F8),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  "Please verify your details and confirm your M-PESA number to proceed. An STK push for the KES 1,000 membership fee will be sent to your phone.",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20),
                _buildSectionTitle("Registration Summary"),
                _buildSummaryCard(),

                const SizedBox(height: 24),
                _buildSectionTitle("Fee Details"),
                _buildInputField(
                  label: "Membership Share",
                  controller: _amountController,
                  hint: "1,000.00",
                  icon: CupertinoIcons.money_dollar_circle,
                  readonly: true,
                  focusNode: _feeFocus,
                  fieldKey: "membership",
                  keyboardType: TextInputType.number,
                ),

                const SizedBox(height: 24),
                _buildSectionTitle("Payment Verification"),
                _buildInputField(
                  label: "M-PESA Phone Number",
                  controller: _mobileController,
                  hint: "07XXXXXXXX",
                  icon: CupertinoIcons.phone_fill,
                  focusNode: _phoneFocus,
                  fieldKey: "phone",
                  keyboardType: TextInputType.phone,
                  readonly: false,
                ),

                const SizedBox(height: 32),
                _buildDetailedDisclaimers(),
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
      backgroundColor: const Color(0xFFF1F4F8).withValues(alpha: 0.95),
      elevation: 0,
      centerTitle: true,
      leadingWidth: 64,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Setup Membership",
            style: TextStyle(
              color: Color(0xFF0A2351),
              fontWeight: FontWeight.w900,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            "MEMBER INFORMATION",
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 7,
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
              color: Color(0xFF0A2351),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: _buildCircleAction(CupertinoIcons.question_circle, () {
            // Help logic
          }),
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
          icon: Icon(icon, size: 18, color: const Color(0xFF0A2351)),
          onPressed: onTap,
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    final String firstName = user?["firstname"] ?? "Guest";
    final String middleName = user?["middlename"] ?? "";
    final String lastName = user?["lastname"] ?? "User";
    final String email = user?["email"] ?? "Not provided";
    final String fullName =
        [
          firstName,
          middleName,
          lastName,
        ].map((s) => s.trim()).where((s) => s.isNotEmpty).join(' ').isEmpty
        ? "Anansi User"
        : [
            firstName,
            middleName,
            lastName,
          ].map((s) => s.trim()).where((s) => s.isNotEmpty).join(' ');
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0A2351).withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSummaryRow(CupertinoIcons.person, "Full Name", fullName),
          const Divider(height: 32, color: Color(0xFFF1F4F8)),
          _buildSummaryRow(CupertinoIcons.mail, "Email Address", email),
          const Divider(height: 32, color: Color(0xFFF1F4F8)),
          _buildSummaryRow(
            CupertinoIcons.tag,
            "Account Type",
            "Individual Member",
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF17C6C6)),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF0A2351),
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w900,
          color: Color(0xFF17C6C6),
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildDetailedDisclaimers() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0A2351).withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Icon(
            CupertinoIcons.shield_lefthalf_fill,
            color: Color(0xFF0A2351),
            size: 24,
          ),
          const SizedBox(height: 12),
          const Text(
            "Sacco Compliance Notice",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: Color(0xFF0A2351),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "This KES 1,000 fee is a non-refundable one-time share capital contribution required by Kenyan Sacco bylaws. By proceeding, you authorize an STK Push to your registered M-PESA line.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersistentFooter() {
    final VoidCallback? action = isPhoneValid
        ? () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    RegisterInvest(mobileNumber: _mobileController.text.trim()),
              ),
            );
          }
        : null;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 15, 30),
      color: Colors.white,
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: action,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0A2351),
            // Background color when the button is disabled
            disabledBackgroundColor: Colors.grey.shade200,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            elevation: 0,
          ),
          child: Text(
            "Continue",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
              // Change text color based on validity
              color: isPhoneValid ? Colors.white : Colors.grey.shade500,
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
    bool? readonly,
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
                  readOnly: readonly ?? false,
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

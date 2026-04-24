import 'package:app_anansi_mobile/pages/membership/register_invest.dart';
import 'package:app_anansi_mobile/state/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final mobile = authProvider.user?['mobileno'] ?? "";
    setState(() {
      _mobileController.text = mobile;
    });

    _phoneFocus.addListener(() {
      if (!_phoneFocus.hasFocus) {
        _validateField('phone', _mobileController.text);
      }
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
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
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
      bottomSheet: _buildPersistentFooter(),
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
    final authProvider = context.watch<AuthProvider>();
    final String firstName = authProvider.user?["firstname"] ?? "Guest";
    final String middleName = authProvider.user?["middlename"] ?? "";
    final String lastName = authProvider.user?["lastname"] ?? "User";
    final String email = authProvider.user?["email"] ?? "Not provided";
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
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 15, 30),
      color: Colors.white,
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const RegisterInvest(mobileNumber: "0755300300"),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0A2351),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            elevation: 0,
          ),
          child: const Text(
            "Continue",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.white,
              fontSize: 16,
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
    required bool readonly,
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
                      readOnly: readonly,
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
}

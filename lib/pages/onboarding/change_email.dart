import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChangeEmail extends StatefulWidget {
  const ChangeEmail({super.key});

  @override
  State<ChangeEmail> createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  String? _errorMessage;
  bool _isLoading = false;
  Map<String, String?> formErrors = {'email': null};

  @override
  void initState() {
    super.initState();
    _emailFocus.addListener(() {
      if (!_emailFocus.hasFocus) {
        _validateEmail(_emailController.text);
      }
    });
  }

  void _validateEmail(String value) {
    final pattern = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,3}$",
    );
    setState(() {
      if (value.isEmpty) {
        _errorMessage = "Email address is required";
      } else if (!pattern.hasMatch(value)) {
        _errorMessage = "Please enter a valid email address";
      } else {
        _errorMessage = null;
      }
    });
  }

  bool get _isButtonEnabled {
    final pattern = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,3}$",
    );
    return pattern.hasMatch(_emailController.text) && _errorMessage == null;
  }

  Future<void> _handleUpdate() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: CustomScrollView(
              slivers: [
                _buildAppBar(),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: 20),
                      _buildHeader(),
                      const SizedBox(height: 40),
                      _buildInputField(
                        label: "Email Address",
                        hint: "name@example.com",
                        controller: _emailController,
                        icon: Icons.alternate_email_rounded,
                        fieldKey: "email",
                        focusNode: _emailFocus,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 32),
                      _buildSubmitButton(),
                      const SizedBox(height: 40),
                      _buildSecurityProtocolCard(),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: const IconThemeData(color: AnansiColors.darkBlue),
      leading: IconButton(
        icon: const Icon(
          CupertinoIcons.chevron_left,
          color: AnansiColors.darkBlue,
          size: 20,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        "Change Email Address",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w900,
          color: AnansiColors.darkBlue,
        ),
      ),
      centerTitle: false,
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "UPDATE YOUR\nEMAIL ADDRESS",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w900,
            color: Color(0xFF0F172A),
            height: 1.1,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "This email will be used for two-factor authentication, account recovery, and official Anansi Sacco communications.",
          style: TextStyle(
            fontSize: 16,
            color: Colors.blueGrey.shade400,
            height: 1.5,
          ),
        ),
      ],
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

  Widget _buildSubmitButton() {
    final bool valid = _isButtonEnabled;
    return ElevatedButton(
      onPressed: (valid && !_isLoading) ? _handleUpdate : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: AnansiColors.darkBlue,
        disabledBackgroundColor: Colors.grey.shade200,
        minimumSize: const Size(double.infinity, 72),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        elevation: valid ? 8 : 0,
        shadowColor: const Color(0xFF0F172A).withValues(alpha: 0.3),
      ),
      child: _isLoading
          ? const CupertinoActivityIndicator(color: Colors.white)
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "CHANGE EMAIL",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 12),
                Icon(CupertinoIcons.arrow_right, size: 18, color: Colors.white),
              ],
            ),
    );
  }

  Widget _buildSecurityProtocolCard() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF17C6C6).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  CupertinoIcons.shield_lefthalf_fill,
                  color: Color(0xFF17C6C6),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "SECURITY PROTOCOL",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            "Upon clicking \"Change Email\", our system will generate a unique 6-digit secure authentication code dispatched immediately to your inbox.",
            style: TextStyle(
              fontSize: 13,
              color: Colors.blueGrey.shade600,
              height: 1.6,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: Color(0xFFE2E8F0)),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Note: ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              Expanded(
                child: Text(
                  "Check your Spam folder if the code doesn't arrive within 60 seconds.",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blueGrey.shade400,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

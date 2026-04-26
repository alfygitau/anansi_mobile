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
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AnansiColors.darkBlue,
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

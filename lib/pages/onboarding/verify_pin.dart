import 'dart:convert';
import 'package:app_anansi_mobile/pages/onboarding/next_of_kin.dart';
import 'package:app_anansi_mobile/services/error_service.dart';
import 'package:app_anansi_mobile/services/onboarding_service.dart';
import 'package:app_anansi_mobile/services/secure_storage_service.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VerifyPin extends StatefulWidget {
  const VerifyPin({super.key});

  @override
  State<VerifyPin> createState() => _VerifyPinState();
}

class _VerifyPinState extends State<VerifyPin> {
  final TextEditingController _kraPinController = TextEditingController();
  final FocusNode _kraPinFocus = FocusNode();

  String? _kraError;
  bool _loading = false;
  bool _declarationAccepted = true;
  static final RegExp _kraRegex = RegExp(r'^[A-Za-z]\d{9}[A-Za-z]$');

  @override
  void initState() {
    super.initState();
    _kraPinFocus.addListener(() {
      if (!_kraPinFocus.hasFocus) {
        _validateKraPin(_kraPinController.text);
      }
    });
  }

  void _validateKraPin(String value) {
    final clean = value.trim().toUpperCase();
    String? error;

    if (clean.isEmpty) {
      error = "KRA PIN is required";
    } else if (clean.length != 11) {
      error = "KRA PIN must be exactly 11 characters";
    } else if (!_kraRegex.hasMatch(clean)) {
      error = "Invalid KRA PIN format (e.g. A123456789Z)";
    }

    setState(() {
      _kraError = error;
    });
  }

  bool get isFormValid {
    final clean = _kraPinController.text.trim().toUpperCase();
    return clean.isNotEmpty &&
        clean.length == 11 &&
        _kraRegex.hasMatch(clean) &&
        _declarationAccepted;
  }

  @override
  void dispose() {
    _kraPinController.dispose();
    _kraPinFocus.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>?> getUser() async {
    String? userJson = await SecureStorageService().read('user');
    if (userJson == null) return null;
    return jsonDecode(userJson) as Map<String, dynamic>;
  }

  Future<void> submitKraPin() async {
    _validateKraPin(_kraPinController.text);
    if (!isFormValid) {
      HapticFeedback.vibrate();
      return;
    }

    setState(() => _loading = true);
    try {
      final (response, errors) = await OnboardingService().verifyPin(
        kraPin: _kraPinController.text.trim().toUpperCase(),
      );
      if (errors != null) {
        if (mounted) {
          _showValidationFailedSheet(errors[0], errors[1]);
        }
      } else if (response != null) {
        HapticFeedback.lightImpact();
        if (mounted) {
          _updateCustomer();
        }
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _updateCustomer() async {
    final user = await getUser();
    try {
      final (response, errors) = await OnboardingService().updateKraPin(
        id: user?['id'] ?? "",
        kraPin: _kraPinController.text.trim(),
      );
      if (errors != null) {
        ErrorService.showActionableError(
          context,
          title: errors[0],
          message: errors[1],
        );
      } else if (response != null) {
        HapticFeedback.lightImpact();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NextOfKin()),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _updateCustomerManually() async {
    final user = await getUser();
    try {
      final (response, errors) = await OnboardingService().updateKraPinManually(
        id: user?['id'] ?? "",
        kraPin: _kraPinController.text.trim(),
      );
      if (errors != null) {
        ErrorService.showActionableError(
          context,
          title: errors[0],
          message: errors[1],
        );
      } else if (response != null) {
        HapticFeedback.lightImpact();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NextOfKin()),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showValidationFailedSheet(String errorTitle, String errorMessage) {
    HapticFeedback.heavyImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(24, 24, 24, 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 5,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Warning Icon
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    CupertinoIcons.exclamationmark_triangle_fill,
                    color: Colors.redAccent,
                    size: 38,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  errorTitle,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AnansiColors.darkBlue,
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  errorMessage,
                  style: TextStyle(
                    fontSize: 14.5,
                    color: Colors.grey.shade600,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 36),

                // Actions
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _updateCustomerManually();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AnansiColors.darkBlue,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: AnansiColors.darkBlue.withValues(alpha: 0.2),
                          width: 1.5,
                        ),
                      ),
                    ),
                    child: const Text(
                      "CONTINUE IN PENDING STATE",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _kraPinFocus.requestFocus();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AnansiColors.darkBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      "EDIT KRA PIN",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.1,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Pinned Header
            SliverAppBar(
              pinned: true,
              floating: false,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              scrolledUnderElevation: 0,
              automaticallyImplyLeading: false,
              titleSpacing: 24,
              centerTitle: false,
              title: const Text(
                "Tax Identification",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AnansiColors.darkBlue,
                  letterSpacing: -1.5,
                ),
              ),
            ),

            // Form Body
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    _buildStepHeader(),
                    const SizedBox(height: 24),
                    _buildSectionLabel("STATUTORY DETAILS"),
                    const SizedBox(height: 14),
                    _buildKraInputField(),
                    const SizedBox(height: 20),
                    _buildComplianceCard(),
                    const SizedBox(height: 20),
                    _buildDeclarationToggle(),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 25),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.95)),
        child: _buildActionDock(),
      ),
    );
  }

  Widget _buildStepHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "KRA PIN Verification",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AnansiColors.darkBlue,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Provide your 11-character Kenya Revenue Authority Personal Identification Number to verify tax compliance and validate your identity.",
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.5,
        color: AnansiColors.darkBlue.withValues(alpha: 0.4),
      ),
    );
  }

  Widget _buildKraInputField() {
    final bool hasError = _kraError != null;
    final bool isFocused = _kraPinFocus.hasFocus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 4),
          child: Row(
            children: [
              Text(
                "KRA PIN NUMBER",
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
                      : ThemeColors.background,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  CupertinoIcons.doc_text_viewfinder,
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
                  focusNode: _kraPinFocus,
                  controller: _kraPinController,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.characters,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(11),
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                    _UpperCaseTextFormatter(),
                  ],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2.0,
                  ),
                  cursorColor: AnansiColors.darkBlue,
                  decoration: InputDecoration(
                    hintText: "e.g. A012345678Z",
                    hintStyle: TextStyle(
                      color: Colors.blueGrey.shade200,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.0,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onChanged: (val) {
                    if (_kraError != null) {
                      setState(() => _kraError = null);
                    }
                    setState(() {});
                  },
                  onTapOutside: (_) => FocusScope.of(context).unfocus(),
                ),
              ),
              if (_kraPinController.text.length == 11 &&
                  _kraRegex.hasMatch(_kraPinController.text.toUpperCase()))
                const Padding(
                  padding: EdgeInsets.only(right: 6),
                  child: Icon(
                    CupertinoIcons.checkmark_seal_fill,
                    size: 20,
                    color: Color(0xFF10B981),
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
                _kraError ?? "",
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

  Widget _buildComplianceCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeColors.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AnansiColors.darkBlue.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              CupertinoIcons.shield_lefthalf_fill,
              size: 20,
              color: AnansiColors.darkBlue,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Why is KRA PIN required?",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AnansiColors.darkBlue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "In compliance with SASRA regulations and national financial anti-fraud requirements, all member accounts must have a verified KRA PIN linked.",
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.45,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeclarationToggle() {
    return GestureDetector(
      onTap: () {
        setState(() => _declarationAccepted = !_declarationAccepted);
      },
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: _declarationAccepted
                    ? AnansiColors.darkBlue
                    : Colors.white,
                borderRadius: BorderRadius.circular(7),
                border: Border.all(
                  color: _declarationAccepted
                      ? AnansiColors.darkBlue
                      : const Color(0xFFCBD5E1),
                  width: 1.8,
                ),
              ),
              child: _declarationAccepted
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "I confirm that this KRA PIN belongs to me and is legally valid for tax identification.",
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionDock() {
    final VoidCallback? action = _loading ? null : submitKraPin;

    return SizedBox(
      width: double.infinity,
      height: 64,
      child: ElevatedButton(
        onPressed: action,
        style: ElevatedButton.styleFrom(
          backgroundColor: isFormValid
              ? AnansiColors.darkBlue
              : Colors.grey.shade300,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AnansiColors.darkBlue,
          disabledForegroundColor: Colors.grey.shade500,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        child: _loading
            ? const CupertinoActivityIndicator(color: Colors.white)
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "VERIFY AND CONTINUE",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.1,
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_forward_rounded, size: 18),
                ],
              ),
      ),
    );
  }
}

class _UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

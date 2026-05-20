import 'dart:convert';
import 'package:app_anansi_mobile/pages/membership/intro_membership.dart';
import 'package:app_anansi_mobile/services/account_service.dart';
import 'package:app_anansi_mobile/services/error_service.dart';
import 'package:app_anansi_mobile/services/onboarding_service.dart';
import 'package:app_anansi_mobile/services/secure_storage_service.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TermsConditions extends StatefulWidget {
  const TermsConditions({super.key});

  @override
  State<TermsConditions> createState() => _TermsConditionsState();
}

class _TermsConditionsState extends State<TermsConditions> {
  final ScrollController _scrollController = ScrollController();
  bool _hasScrolledToBottom = false;
  bool _isLoading = false;

  Future<Map<String, dynamic>?> getUser() async {
    String? userJson = await SecureStorageService().read('user');
    if (userJson == null) return null;
    Map<String, dynamic> userMap = jsonDecode(userJson);
    return userMap;
  }

  void _updateCustomer() async {
    final user = await getUser();
    try {
      final (response, errors) = await OnboardingService()
          .updateCustomerStatuses(id: user?['id'] ?? "");
      if (errors != null) {
        ErrorService.showActionableError(
          context,
          title: errors[0],
          message: errors[1],
        );
      } else if (response != null) {
        HapticFeedback.lightImpact();
        showSuccessSheet(context);
      }
    } finally {}
  }

  void _createProducts() async {
    setState(() {
      _isLoading = true;
    });
    final user = await getUser();
    try {
      final (response, errors) = await AccountService().createProducts(
        id: user?['id'] ?? "",
      );
      if (errors != null) {
        ErrorService.showActionableError(
          context,
          title: errors[0],
          message: errors[1],
        );
      } else if (response != null) {
        _updateCustomer();
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_checkScrollPosition);
  }

  void _checkScrollPosition() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50) {
      if (!_hasScrolledToBottom) {
        setState(() => _hasScrolledToBottom = true);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(24, 10, 24, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPageIntro(),
                        const SizedBox(height: 32),

                        _buildLegalSection(
                          "1. Introduction",
                          "ANANSI SACCO is a member-based Savings and Credit Cooperative (SACCO) providing financial services to its members, including shares, savings, and digital credit facilities.",
                          items: [
                            "The platform is operated by Anansi Technology Limited.",
                            "Access is restricted to registered and verified members only.",
                          ],
                        ),
                        _buildLegalSection(
                          "2. Membership & Eligibility",
                          "By using this application, you warrant that you are at least 18 years of age and possess the legal capacity to enter into binding financial contracts in Kenya.",
                          items: [
                            "Information provided must be truthful and accurate.",
                            "Anansi reserves the right to terminate accounts with false data.",
                          ],
                        ),

                        _buildLegalSection(
                          "3. Security & Liability",
                          "You are solely responsible for the confidentiality of your login credentials and any transactions performed under your profile.",
                        ),

                        _buildContactCard(),
                        const SizedBox(
                          height: 100,
                        ), // Buffer for the button dock
                      ],
                    ),
                  ),
                  if (!_hasScrolledToBottom)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withValues(alpha: 0),
                              Colors.white.withValues(alpha: 0.9),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            _buildActionDock(),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIntro() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Terms and Conditions",
          style: TextStyle(
            color: AnansiColors.darkBlue,
            fontSize: 24,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Please review the General Terms & Conditions governing the ANANSI SACCO financial ecosystem. Your acceptance constitutes a legal agreement between you and the SACCO.",
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 15,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildLegalSection(String title, String body, {List<String>? items}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFF17C6C6),
              fontWeight: FontWeight.w800,
              fontSize: 11,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: TextStyle(
              color: Colors.grey.shade800,
              fontSize: 14,
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (items != null) ...[
            const SizedBox(height: 12),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: const Icon(
                        Icons.circle,
                        size: 6,
                        color: Color(0xFF17C6C6),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContactCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "QUERIES & SUPPORT",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 10,
              color: AnansiColors.darkBlue,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          _contactRow(CupertinoIcons.mail, "anansisacco@gmail.com"),
          _contactRow(CupertinoIcons.phone, "+254 750 633 766"),
          _contactRow(CupertinoIcons.location, "Ngong Lane Plaza, Nairobi"),
        ],
      ),
    );
  }

  Widget _contactRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 14, color: const Color(0xFF17C6C6)),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AnansiColors.darkBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionDock() {
    final VoidCallback? action = _isLoading
        ? () {}
        : (_hasScrolledToBottom ? _createProducts : null);

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 30),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!_hasScrolledToBottom && !_isLoading)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                "Please scroll to read the full agreement",
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ElevatedButton(
            onPressed: action,
            style: ElevatedButton.styleFrom(
              backgroundColor: AnansiColors.darkBlue,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey.shade200,
              minimumSize: const Size(double.infinity, 64),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
              splashFactory: _isLoading ? NoSplash.splashFactory : null,
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CupertinoActivityIndicator(color: Colors.white),
                  )
                : Text(
                    "ACCEPT & FINISH",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.1,
                      color: _hasScrolledToBottom
                          ? Colors.white
                          : Colors.grey.shade400,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void showSuccessSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AnansiColors.darkBlue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  CupertinoIcons.checkmark_seal_fill,
                  color: AnansiColors.darkBlue,
                  size: 40,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Terms Accepted!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Your digital signature has been successfully recorded. You now have full access to the Anansi ecosystem.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                height: 1.5,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF1F4F8)),
              ),
              child: Column(
                children: [
                  _buildDetailRow("Document", "General T&Cs v2.4"),
                  const Divider(height: 24),
                  _buildDetailRow("Signed On", "April 24, 2026"),
                  const Divider(height: 24),
                  _buildDetailRow("Reference", "AN-992-X"),
                ],
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const IntroMember()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AnansiColors.darkBlue,
                minimumSize: const Size(double.infinity, 64),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
              ),
              child: const Text(
                "CONTINUE TO MEMBERSHIP",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

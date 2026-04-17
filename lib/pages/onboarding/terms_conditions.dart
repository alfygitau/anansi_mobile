import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TermsConditions extends StatefulWidget {
  const TermsConditions({super.key});

  @override
  State<TermsConditions> createState() => _TermsConditionsState();
}

class _TermsConditionsState extends State<TermsConditions> {
  final ScrollController _scrollController = ScrollController();
  bool _hasScrolledToBottom = false;
  bool _isLoading = false;

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
            _buildBrandHeader(),
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

  Widget _buildBrandHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AnansiColors.darkBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    "A",
                    style: TextStyle(
                      color: Color(0xFF17C6C6),
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "AGREEMENT",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                      letterSpacing: 1.5,
                      color: AnansiColors.darkBlue,
                    ),
                  ),
                  Text(
                    "Terms & Conditions",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              CupertinoIcons.xmark_circle_fill,
              color: Color(0xFFE0E0E0),
              size: 28,
            ),
          ),
        ],
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
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
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
          if (!_hasScrolledToBottom)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                "Please scroll to read the full agreement",
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ElevatedButton(
            onPressed: (_hasScrolledToBottom && !_isLoading) ? () {} : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AnansiColors.darkBlue,
              disabledBackgroundColor: Colors.grey.shade200,
              minimumSize: const Size(double.infinity, 64),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
            ),
            child: _isLoading
                ? const CupertinoActivityIndicator(color: Colors.white)
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
}

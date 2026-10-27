import 'package:app_anansi_mobile/constants/constants.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context, "Privacy Policy"),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 36),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLastUpdated("October 16, 2026"),
                  const SizedBox(height: 24),
                  _buildContentCard(
                    title: "1. Data Collection",
                    body:
                        "In compliance with the Kenya Data Protection Act (KDPA), $saccoName SACCO collects personal and financial information necessary to provide banking and credit services. This includes your National ID, KRA PIN, biometrics, mobile number, and financial transaction history.",
                  ),
                  const SizedBox(height: 16),
                  _buildContentCard(
                    title: "2. How We Use Your Data",
                    body:
                        "Your data is used strictly to verify your identity, process loan appraisals, manage your FOSA/BOSA accounts, process dividend allocations, and meet regulatory Anti-Money Laundering (AML) reporting standards.",
                  ),
                  const SizedBox(height: 16),
                  _buildContentCard(
                    title: "3. Information Sharing",
                    body:
                        "$saccoName SACCO does not sell your data. We only share data with authorized third parties such as Credit Reference Bureaus (CRBs) for loan scoring, the Sacco Societies Regulatory Authority (SASRA) for compliance, and designated guarantors during loan applications.",
                  ),
                  const SizedBox(height: 16),
                  _buildContentCard(
                    title: "4. Data Security",
                    body:
                        "All data is secured using AES-256 bank-grade encryption. Access to your app requires multi-factor authentication, including PIN and biometric verification, to prevent unauthorized access.",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Common UI Builders below...
  Widget _buildAppBar(BuildContext context, String title) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: ThemeColors.background.withValues(alpha: 0.9),
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      leadingWidth: 64,
      title: Text(
        title,
        style: const TextStyle(
          color: AnansiColors.darkBlue,
          fontWeight: FontWeight.w900,
          fontSize: 18,
          letterSpacing: -0.5,
        ),
      ),
      leading: Center(
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(CupertinoIcons.back, size: 18, color: AnansiColors.darkBlue),
            onPressed: () => Navigator.maybePop(context),
          ),
        ),
      ),
    );
  }

  Widget _buildLastUpdated(String date) {
    return Row(
      children: [
        const Icon(CupertinoIcons.clock, size: 14, color: Color(0xFF94A3B8)),
        const SizedBox(width: 8),
        Text(
          "Last Updated: $date",
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF94A3B8),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildContentCard({required String title, required String body}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w800,
              color: AnansiColors.darkBlue,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            body,
            style: TextStyle(
              fontSize: 13.5,
              color: Colors.grey.shade600,
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
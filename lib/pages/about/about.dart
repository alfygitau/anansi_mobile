import 'package:app_anansi_mobile/pages/help&support/help_support.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildAppBar(context),
            // Content Body
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    _buildHeroCard(),
                    const SizedBox(height: 28),

                    _buildSectionLabel("CORE PILLARS"),
                    const SizedBox(height: 14),
                    _buildFeatureGrid(),
                    const SizedBox(height: 28),

                    _buildSectionLabel("LEGAL & COMPLIANCE"),
                    const SizedBox(height: 14),
                    _buildLegalCard(context),
                    const SizedBox(height: 28),

                    _buildSectionLabel("SUPPORT & COMMUNITY"),
                    const SizedBox(height: 14),
                    _buildActionCard(
                      icon: CupertinoIcons.chat_bubble_2_fill,
                      title: "Contact Member Support",
                      subtitle: "Reach our dedicated member care desk",
                      onTap: () {
                        // Open support or email composer
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildActionCard(
                      icon: CupertinoIcons.globe,
                      title: "Official Website",
                      subtitle: "Visit anansi.co.ke for notices and reports",
                      onTap: () {
                        // Launch browser URL
                      },
                    ),
                    const SizedBox(height: 36),

                    _buildFooter(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: ThemeColors.background.withValues(alpha: 0.9),
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      leadingWidth: 64,
      title: const Text(
        "About Anansi",
        style: TextStyle(
          color: AnansiColors.darkBlue,
          fontWeight: FontWeight.w900,
          fontSize: 18,
          letterSpacing: -0.5,
        ),
      ),
      leading: _buildCircledIcon(
        icon: CupertinoIcons.back,
        onTap: () => Navigator.of(context).maybePop(),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: _buildCircledIcon(
            icon: CupertinoIcons.question_circle,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpSupport()),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCircledIcon({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Center(
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
          icon: Icon(icon, size: 18, color: AnansiColors.darkBlue),
          onPressed: onTap,
        ),
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: ThemeColors.background,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
      ),
      child: Column(
        children: [
          // App Logo Container
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AnansiColors.logoBg,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: AnansiColors.logoBg.withValues(alpha: 0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                CupertinoIcons.shield_fill,
                size: 36,
                color: AnansiColors.accentCyan,
              ),
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            "Anansi Mobile",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AnansiColors.darkBlue,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),

          // Version Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Text(
              "Version 1.4.0 (Build 2026.1)",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
              ),
            ),
          ),
          const SizedBox(height: 14),

          Text(
            "Empowering member cooperatives and financial communities with secure identity verification, transparent credit access, and collective wealth creation.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid() {
    return Column(
      children: [
        _buildPillarTile(
          icon: CupertinoIcons.lock_shield_fill,
          title: "Bank-Grade Encryption",
          description:
              "All personal data and tax credentials are cryptographically protected in compliance with Data Protection regulations.",
        ),
        const SizedBox(height: 12),
        _buildPillarTile(
          icon: CupertinoIcons.sparkles,
          title: "Automated Credit Scoring",
          description:
              "Streamlined loan appraisals and instant status tracking without manual paperwork delays.",
        ),
        const SizedBox(height: 12),
        _buildPillarTile(
          icon: CupertinoIcons.person_3_fill,
          title: "Member Governance",
          description:
              "Transparent dividend tracking, welfare fund access, and verified democratic community participation.",
        ),
      ],
    );
  }

  Widget _buildPillarTile({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: ThemeColors.background,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 20, color: AnansiColors.darkBlue),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AnansiColors.darkBlue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegalCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
      ),
      child: Column(
        children: [
          _buildLegalRow(
            title: "Privacy Policy",
            onTap: () {
              // Navigate to Privacy Policy screen or web view
            },
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          _buildLegalRow(
            title: "Terms of Service",
            onTap: () {
              // Navigate to Terms of Service
            },
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          _buildLegalRow(
            title: "SASRA & Regulatory Disclosures",
            onTap: () {
              // Open Regulatory page
            },
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          _buildLegalRow(
            title: "Open Source Licenses",
            onTap: () {
              showLicensePage(
                context: context,
                applicationName: "Anansi Mobile",
                applicationVersion: "1.4.0",
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLegalRow({required String title, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AnansiColors.darkBlue,
              ),
            ),
            const Icon(
              CupertinoIcons.chevron_right,
              size: 14,
              color: Color(0xFF94A3B8),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: ThemeColors.background,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, size: 20, color: AnansiColors.darkBlue),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AnansiColors.darkBlue,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
            const Icon(
              CupertinoIcons.arrow_up_right,
              size: 14,
              color: Color(0xFF94A3B8),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AnansiColors.accentCyan,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                "All Systems Operational",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF059669),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "© 2026 Anansi Technologies Ltd. All rights reserved.",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}

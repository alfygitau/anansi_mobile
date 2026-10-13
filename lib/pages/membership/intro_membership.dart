import 'package:app_anansi_mobile/pages/membership/membership_details.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IntroMember extends StatefulWidget {
  const IntroMember({super.key});

  @override
  State<IntroMember> createState() => _IntroMemberState();
}

class _IntroMemberState extends State<IntroMember> {
  String getFormattedCurrentDateTime() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(now);
  }

  Future<void> createSharesAccount() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MembershipDetails()),
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
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    _buildIconHeader(),
                    const SizedBox(height: 22),
                    _buildTextContent(),
                    const SizedBox(height: 32),

                    _buildFeatureCard(
                      icon: CupertinoIcons.sparkles,
                      title: "Exclusive Rates",
                      subtitle:
                          "Access high-yield dividends and competitive loan interest rates designed for growth.",
                    ),
                    _buildFeatureCard(
                      icon: CupertinoIcons.shield,
                      title: "Secure Guarantorship",
                      subtitle:
                          "Leverage our community-driven trust system to secure credit without traditional collateral.",
                    ),
                    _buildFeatureCard(
                      icon: CupertinoIcons.chart_bar_alt_fill,
                      title: "Financial Insights",
                      subtitle:
                          "Detailed reporting on your contributions, shares, and wealth progression.",
                    ),
                    const SizedBox(height: 12),
                    _buildPaymentNotice(),
                    const SizedBox(height: 100),
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
        child: _buildSubmitButton(),
      ),
    );
  }

  Widget _buildIconHeader() {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(
        child: Icon(
          CupertinoIcons.checkmark_seal_fill,
          color: Color(0xFF17C6C6),
          size: 28,
        ),
      ),
    );
  }

  Widget _buildTextContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Setup Anansi Membership',
          style: TextStyle(
            color: AnansiColors.darkBlue,
            fontSize: 30,
            height: 1.1,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Become a member today and start your journey toward financial freedom with Kenya\'s most modern Sacco community.',
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 15,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF17C6C6), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AnansiColors.darkBlue,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 13,
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

  Widget _buildPaymentNotice() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AnansiColors.darkBlue.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AnansiColors.darkBlue.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            CupertinoIcons.creditcard,
            size: 20,
            color: AnansiColors.darkBlue,
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              "One-time joining fee",
              style: TextStyle(
                fontSize: 13,
                color: AnansiColors.darkBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Text(
            "KES 1,000",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: AnansiColors.darkBlue,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: double.infinity,
          height: 64,
          child: ElevatedButton(
            onPressed: createSharesAccount,
            style: ElevatedButton.styleFrom(
              backgroundColor: AnansiColors.darkBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "SETUP MEMBERSHIP",
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
        ),
      ],
    );
  }
}

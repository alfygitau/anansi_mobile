import 'package:app_anansi_mobile/pages/membership/membership_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IntroMember extends StatefulWidget {
  const IntroMember({super.key});

  @override
  State<IntroMember> createState() => _IntroMemberState();
}

class _IntroMemberState extends State<IntroMember> {
  bool _isLoading = false;

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              _buildIconHeader(),
              const SizedBox(height: 22),
              _buildTextContent(),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
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
                    ],
                  ),
                ),
              ),
              _buildPaymentNotice(),
              const SizedBox(height: 20),
              _buildSubmitButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconHeader() {
    return Container(
      height: 64,
      width: 64,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(
        child: Icon(
          CupertinoIcons.checkmark_seal_fill,
          color: Color(0xFF17C6C6),
          size: 32,
        ),
      ),
    );
  }

  Widget _buildTextContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Join Anansi\nMembership',
          style: TextStyle(
            color: Color(0xFF0A2351),
            fontSize: 32,
            height: 1.1,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Become a member today and start your journey toward financial freedom with Kenya\'s most modern Sacco community.',
          style: TextStyle(
            color: Colors.grey.shade600,
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
        border: Border.all(color: const Color(0xFFF1F4F8)),
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
                    color: Color(0xFF0A2351),
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade600,
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
        color: const Color(0xFF0A2351).withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF0A2351).withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            CupertinoIcons.creditcard,
            size: 20,
            color: Color(0xFF0A2351),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              "One-time joining fee",
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF0A2351),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Text(
            "KES 1,000",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: Color(0xFF0A2351),
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: _isLoading ? null : createSharesAccount,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0A2351),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const CupertinoActivityIndicator(color: Colors.white)
            : const Text(
                'Setup Membership',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }
}

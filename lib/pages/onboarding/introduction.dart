import 'package:app_anansi_mobile/pages/onboarding/register.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Introduction extends StatefulWidget {
  const Introduction({super.key});

  @override
  State<Introduction> createState() => _IntroductionState();
}

class _IntroductionState extends State<Introduction> {
  static final List<Map<String, dynamic>> onboardingSteps = [
    {
      "title": "Create Profile",
      "subtitle": "Set up your secure digital vault",
      "icon": CupertinoIcons.person_crop_circle_fill,
      "color": const Color(0xFF3B82F6),
      "processDescription":
          "You'll provide your primary contact details and set a strong, encrypted password to secure your future funds.",
      "resultDescription":
          "Your personal profile is created, allowing you to track your application progress in real-time.",
    },
    {
      "title": "Verify Identity",
      "subtitle": "Validate your membership status",
      "icon": CupertinoIcons.shield_fill,
      "color": const Color(0xFF8B5CF6),
      "processDescription":
          "Our AI-powered system will perform a biometric scan of your ID and verify your presence via a quick 3D face map.",
      "resultDescription":
          "Your identity is authenticated against national registries, unlocking higher transaction limits instantly.",
    },
    {
      "title": "Additional Info",
      "subtitle": "Customizing your financial path",
      "icon": CupertinoIcons.doc_text_fill,
      "color": const Color(0xFFF59E0B),
      "processDescription":
          "Tell us about your financial goals and your next of kin to ensure your assets are always protected and managed.",
      "resultDescription":
          "We generate your tailored risk profile, making you eligible for specific loan products and investment pools.",
    },
    {
      "title": "Membership",
      "subtitle": "Finalize your official entry",
      "icon": CupertinoIcons.star_fill,
      "color": const Color(0xFF10B981),
      "processDescription":
          "A one-time registration fee is processed via M-PESA to activate your share capital and voting rights in the SACCO.",
      "resultDescription":
          "You receive your digital Member Certificate and full access to all savings, loans, and dividend features.",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Elegant Header Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 10, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Onboarding Steps",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: AnansiColors.darkBlue,
                        letterSpacing: -1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Complete these stages to activate your full membership benefits.",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.blueGrey.shade400,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // The Premium Cards List
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) =>
                      _buildPremiumStepCard(onboardingSteps[index]),
                  childCount: onboardingSteps.length,
                ),
              ),
            ),

            // Bottom spacing for the sticky-style button
            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),

      // Fixed Action Button for high conversion
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC).withValues(alpha: 0.9),
          border: Border(top: BorderSide(color: Colors.grey.shade100)),
        ),
        child: SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Register()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AnansiColors.darkBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
            ),
            child: const Text(
              "Get Started",
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumStepCard(Map<String, dynamic> step) {
    final Color baseColor = step['color'];

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: baseColor.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. ICON DESIGN
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: baseColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(step['icon'], color: baseColor, size: 32),
                ),
                const SizedBox(width: 20),

                // 2. TEXT CONTENT
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step['title'].toUpperCase(),
                        style: TextStyle(
                          color: baseColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 10,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        step['subtitle'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: AnansiColors.darkBlue,
                          letterSpacing: -0.5,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 3. THE "WHAT HAPPENS" TRAY (Narrative Style)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(32),
              ),
              border: Border(top: BorderSide(color: Colors.grey.shade100)),
            ),
            child: Column(
              children: [
                _buildProcessRow(
                  icon: CupertinoIcons.arrow_right_circle,
                  label: "THE PROCESS",
                  // This describes the "What happens"
                  desc: step['processDescription'],
                  accentColor: baseColor,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(height: 1, color: Color(0xFFE2E8F0)),
                ),
                _buildProcessRow(
                  icon: CupertinoIcons.check_mark_circled,
                  label: "THE RESULT",
                  // This describes the "End state"
                  desc: step['resultDescription'],
                  accentColor: const Color(0xFF10B981), // Success Green
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessRow({
    required IconData icon,
    required String label,
    required String desc,
    required Color accentColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: accentColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  color: Colors.blueGrey.shade300,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AnansiColors.darkBlue,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

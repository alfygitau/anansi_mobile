import 'package:app_anansi_mobile/pages/onboarding/id_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';

class AccountSuccess extends StatefulWidget {
  const AccountSuccess({super.key});

  @override
  State<AccountSuccess> createState() => _AccountSuccessState();
}

class _AccountSuccessState extends State<AccountSuccess> {
  bool _isLoading = false;

  void _handleStart() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const IdType()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [_buildCelebrationHeader(), _buildRoadmapContent()],
          ),
        ),
      ),
    );
  }

  Widget _buildCelebrationHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 110,
                width: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green.withOpacity(0.05),
                ),
              ),
              Container(
                height: 75,
                width: 75,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green,
                  size: 44,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            "Welcome Aboard!",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AnansiColors.darkBlue,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 12),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 15,
                height: 1.5,
              ),
              children: [
                const TextSpan(text: "Your account is ready, "),
                TextSpan(
                  text: "Alfy",
                  style: const TextStyle(
                    color: Color(0xFF17C6C6),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(
                  text: ".\nYou're one step away from full institutional access.",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoadmapContent() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "ONBOARDING PROCESS",
            style: TextStyle(
              color: AnansiColors.darkBlue.withOpacity(0.4),
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 5),
          _buildStepCard(
            icon: CupertinoIcons.shield_lefthalf_fill,
            title: "Identity Verification",
            subtitle:
                "Our institutional-grade verification requires a valid Government ID and a biometric liveness check (selfie).",
            isPrimary: true,
          ),
          const SizedBox(height: 16),
          _buildStepCard(
            icon: CupertinoIcons.house_fill,
            title: "Residential Details",
            subtitle:
                "To establish your regional eligibility and facilitate official communication, please provide your current physical address.",
            isPrimary: false,
          ),
          const SizedBox(height: 16),
          _buildStepCard(
            icon: CupertinoIcons.signature,
            title: "Institutional Agreements",
            subtitle:
                "Carefully review and digitally sign the SACCO Terms of Service and Privacy Framework. This formalizes your membership and secures your rights within the ecosystem.",
            isPrimary: false,
          ),
          const SizedBox(height: 42),
          _buildStartButton(),
          const SizedBox(height: 30),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.shield_outlined,
                  size: 14,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(width: 8),
                Text(
                  "SECURED BY ANANSI PROTOCOLS",
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: Colors.grey.shade400,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildStepCard({
    required IconData icon,
    required String title,
    required String subtitle,
    bool isPrimary = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: isPrimary
                  ? const Color(0xFF17C6C6).withOpacity(0.1)
                  : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: isPrimary
                  ? const Color(0xFF17C6C6)
                  : AnansiColors.darkBlue.withOpacity(0.4),
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AnansiColors.darkBlue,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
              ],
            ),
          ),
          Icon(
            CupertinoIcons.chevron_right,
            color: Colors.grey.shade300,
            size: 14,
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton() {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleStart,
        style: ElevatedButton.styleFrom(
          backgroundColor: AnansiColors.darkBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const CupertinoActivityIndicator(color: Colors.white)
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "START VERIFICATION",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(width: 12),
                  Icon(Icons.arrow_forward_rounded, size: 18),
                ],
              ),
      ),
    );
  }
}

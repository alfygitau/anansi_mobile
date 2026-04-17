import 'package:app_anansi_mobile/pages/auth/login.dart';
import 'package:app_anansi_mobile/pages/onboarding/register.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/material.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AnansiColors.darkBlue,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      // Brand Icon Container
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF17C6C6,
                          ).withOpacity(0.15), // Subtle background
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF17C6C6).withOpacity(0.5),
                            width: 1.5,
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "A",
                            style: TextStyle(
                              color: Color(0xFF17C6C6),
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        "ANANSI",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 6.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    "Digital-First\nWealth Engineering",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    height: 2,
                    width: 60,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF17C6C6), Colors.transparent],
                      ),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Experience a sophisticated evolution of cooperative banking. From encrypted high-yield savings accounts to smart credit lines powered by AI-driven risk assessment—ANANSI provides the tools you need to engineer lasting financial legacy.",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 16,
                      height: 1.6,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const Spacer(),
                  _buildPrimaryButton(
                    text: "Sign In",
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSecondaryButton(
                    text: "Create Account",
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Register()),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildModernFooter(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF17C6C6), Color(0xFF12A5A5)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF17C6C6).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF001B33),
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.white.withOpacity(0.2)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildModernFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "SASRA REGULATED",
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 11,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

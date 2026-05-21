import 'dart:convert';
import 'package:app_anansi_mobile/services/secure_storage_service.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContinueOnboarding extends StatefulWidget {
  const ContinueOnboarding({super.key});

  @override
  State<ContinueOnboarding> createState() => _ContinueOnboardingState();
}

class _ContinueOnboardingState extends State<ContinueOnboarding> {
  Map<String, dynamic>? user;

  void _handleContinue() {
    final String stage = user?['onboarding_stage'] ?? 'personal-information';
    final Map<String, String> routes = {
      "facial-identity": "/onboarding/facial-identity",
      "review-identity": "/onboarding/verify-identity",
      "registration": "/onboarding/verify-email",
      "terms-conditions": "/onboarding/terms-conditions",
      "personal-information": "/onboarding/personal-information",
      "income-information": "/onboarding/income-information",
      "nextOfKin": "/onboarding/next-of-kin",
      "verify-mobile": "/onboarding/verify-mobile",
      "account-success": "/onboarding/account-success",
    };

    if (stage == "registration") {
      // Trigger your resendEmailOtp logic here
    }
    Navigator.pushReplacementNamed(context, routes[stage] ?? "/");
  }

  Future<Map<String, dynamic>?> getUser() async {
    String? userJson = await SecureStorageService().read('user');
    if (userJson == null) return null;
    Map<String, dynamic> userMap = jsonDecode(userJson);
    return userMap;
  }

  @override
  initState() async {
    super.initState();
    _initializeInfo();
  }

  Future<void> _initializeInfo() async {
    final myUser = await getUser();
    setState(() {
      user = myUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String firstName = user?['firstname'] ?? "Member";
    final String currentStage = (user?['onboarding_stage'] ?? "Unknown")
        .toString()
        .replaceAll('-', ' ');

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 10, 30, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AnansiColors.darkBlue.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        CupertinoIcons.shield_fill,
                        color: AnansiColors.darkBlue,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Finish Your\nRegistration",
                      style: TextStyle(
                        color: AnansiColors.darkBlue,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "You are only a few steps away from accessing your full member benefits.",
                      style: TextStyle(
                        color: Colors.blueGrey.shade400,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(color: Color(0xFFF1F5F9), thickness: 1.5),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 16, 30, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 2. Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "ACCOUNT STATUS: PARTIAL SETUP",
                        style: TextStyle(
                          color: AnansiColors.darkBlue,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Welcome Back, $firstName!",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: AnansiColors.darkBlue,
                      ),
                    ),
                    const SizedBox(height: 12),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                          height: 1.5,
                        ),
                        children: [
                          const TextSpan(
                            text: "Your progress was saved at the ",
                          ),
                          TextSpan(
                            text: currentStage.toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              color: AnansiColors.darkBlue,
                            ),
                          ),
                          const TextSpan(text: " stage."),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),
                    Row(
                      children: [
                        _buildInfoCard(
                          icon: CupertinoIcons.doc_text_fill,
                          title: "KYC COMPLIANCE",
                          desc:
                              "Mandatory verification as per Data Protection Act.",
                        ),
                        const SizedBox(width: 12),
                        _buildInfoCard(
                          icon: CupertinoIcons.lock_shield_fill,
                          title: "DATA HANDLING",
                          desc:
                              "Information is encrypted end-to-end (ISO Certified).",
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 64,
                      child: ElevatedButton(
                        onPressed: _handleContinue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AnansiColors.darkBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          elevation: 10,
                          shadowColor: AnansiColors.darkBlue.withValues(
                            alpha: 0.3,
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "RESUME REGISTRATION",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.5,
                              ),
                            ),
                            SizedBox(width: 12),
                            Icon(
                              CupertinoIcons.arrow_right,
                              color: Colors.white,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    const Center(
                      child: Text(
                        "By continuing, you agree to our Terms of Service.",
                        style: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // 5. Footer Actions
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            "LOGOUT SESSION",
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(
                            CupertinoIcons.question_circle,
                            size: 14,
                          ),
                          label: const Text(
                            "HELP CENTER",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: AnansiColors.darkBlue),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              desc,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade500,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

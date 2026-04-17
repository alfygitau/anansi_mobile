import 'package:app_anansi_mobile/pages/auth/login.dart';
import 'package:app_anansi_mobile/pages/onboarding/create_password.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  Map<String, dynamic> user = {};

  @override
  Widget build(BuildContext context) {
    final bool isFormValid =
        _usernameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              _buildBrandIdentity(),
              const SizedBox(height: 20),
              Text(
                "Hello there! We're excited to have you. Create your Anansi account today to start managing your assets, tracking your progress, and mastering your financial journey.",
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 15,
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 15),
              _buildDisclaimerCard(),
              const SizedBox(height: 10),
              _buildInputField(
                label: "Username",
                hint: "Your unique handle",
                controller: _usernameController,
                icon: Icons.person_2_outlined,
              ),
              const SizedBox(height: 24),
              _buildInputField(
                label: "Email Address",
                hint: "name@example.com",
                controller: _emailController,
                icon: Icons.alternate_email_rounded,
              ),
              const SizedBox(height: 24),
              _buildInputField(
                label: "Phone Number",
                controller: _phoneController,
                hint: "e.g 0712345678",
                icon: CupertinoIcons.phone_fill,
                isPhone: true,
              ),
              const SizedBox(height: 36),
              _buildPremiumSubmit(isFormValid),
              const SizedBox(height: 32),
              _buildSignInFooter(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDisclaimerCard() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDFA),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF17C6C6).withValues(alpha: 0.15),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF17C6C6).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  CupertinoIcons.shield_lefthalf_fill,
                  color: Color(0xFF17C6C6),
                  size: 18,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "DATA PROTECTION & CONSENT",
                      style: TextStyle(
                        color: AnansiColors.darkBlue.withValues(alpha: 0.8),
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: AnansiColors.darkBlue.withValues(alpha: 0.6),
                          fontSize: 13,
                          height: 1.6,
                          fontWeight: FontWeight.w500,
                        ),
                        children: [
                          const TextSpan(
                            text:
                                "By proceeding, you acknowledge that you have read and agreed to the Anansi ",
                          ),
                          TextSpan(
                            text: "Terms of Service",
                            style: const TextStyle(
                              color: Color(0xFF17C6C6),
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => _showPrivacyPolicy(context),
                          ),
                          const TextSpan(text: " and our "),
                          TextSpan(
                            text: "Privacy & Data Policy",
                            style: const TextStyle(
                              color: Color(0xFF17C6C6),
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => _showPrivacyPolicy(context),
                          ),
                          const TextSpan(
                            text:
                                ". Your data is used strictly for credit assessment and is never shared with unauthorized third parties.",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBrandIdentity() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AnansiColors.darkBlue,
                borderRadius: BorderRadius.circular(12),
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
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "ONBOARDING",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                    letterSpacing: 1.5,
                    color: AnansiColors.darkBlue,
                  ),
                ),
                Text(
                  "Contact Details",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              CupertinoIcons.xmark,
              size: 18,
              color: AnansiColors.darkBlue,
            ),
          ),
        ),
      ],
    );
  }

  // YOUR REQUESTED BUILD INPUT
  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPhone = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F4F8), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF17C6C6).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 18, color: const Color(0xFF17C6C6)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label.toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFF9E9E9E),
                    fontWeight: FontWeight.w800,
                    fontSize: 9,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                TextField(
                  controller: controller,
                  keyboardType: isPhone
                      ? TextInputType.phone
                      : TextInputType.text,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: 17,
                  ),
                  decoration: InputDecoration(
                    prefixStyle: const TextStyle(
                      color: Color(0xFF17C6C6),
                      fontWeight: FontWeight.w900,
                    ),
                    hintText: hint,
                    hintStyle: TextStyle(
                      color: Colors.grey.shade300,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 4),
                    border: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumSubmit(bool isValid) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CreatePassword(user: user)),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AnansiColors.darkBlue,
        foregroundColor: Colors.white,
        disabledBackgroundColor: Colors.grey.shade200,
        minimumSize: const Size(double.infinity, 64),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 0,
      ),
      child: const Text(
        "CREATE ACCOUNT",
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 14,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildSignInFooter() {
    return Center(
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        ),
        child: RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.grey, fontSize: 14),
            children: [
              const TextSpan(text: "Already a member? "),
              TextSpan(
                text: "Sign In",
                style: TextStyle(
                  color: AnansiColors.darkBlue,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.96,
          builder: (_, controller) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // Modern Drag Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  // Premium Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Legal & Privacy",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: AnansiColors.darkBlue,
                          letterSpacing: -0.5,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 20,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 32),

                  // Content Area
                  Expanded(
                    child: ListView(
                      controller: controller,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        Text(
                          "Anansi SACCO Privacy Protocol",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
                            color: const Color(
                              0xFF17C6C6,
                            ).withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildPremiumParagraph(
                          "Anansi SACCO (“we,” “our,” or “us”) values the privacy of our users. This Privacy Policy explains how we collect, use, disclose, and protect your personal information when you use our mobile application. By accessing the App, you agree to the collection and use of information in accordance with this Privacy Policy.",
                        ),
                        const SizedBox(height: 32),

                        _buildPremiumSection("1. Information Intelligence", [
                          "Personal Identity: Full Name, Email, Phone, DOB, and KYC documentation.",
                          "Financial Data: Bank account details, savings patterns, and loan history.",
                          "Technical Footprint: Device type, IP Address, and OS versioning.",
                          "Geolocation: Precision data to provide location-based services.",
                          "Tracking: Secure cookies to enhance user session performance.",
                        ]),

                        _buildPremiumSection("2. Purpose of Processing", [
                          "Execution of financial transactions and account management.",
                          "Personalization of the wealth-engineering experience.",
                          "Compliance with regulatory KYC and AML legal obligations.",
                          "Continuous optimization of the Anansi digital infrastructure.",
                        ]),

                        _buildPremiumSection("3. Data Sovereignty", [
                          "We do not sell user data. Sharing occurs only with verified partners to deliver core services or comply with legal mandates.",
                        ]),

                        _buildPremiumSection("4. Security Measures", [
                          "We utilize industry-leading encryption and secure firewalls. While we implement rigorous safeguards, no digital transmission is 100% immune.",
                        ]),

                        _buildPremiumSection("Contact Protocols", [
                          "ANANSI SACCO Headquarters",
                          "Email: anansisacco@gmail.com",
                          "Location: Ngong Lane Plaza, Nairobi, Kenya",
                        ]),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),

                  // Bottom Action
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AnansiColors.darkBlue,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "I UNDERSTAND",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPremiumParagraph(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 15,
        height: 1.6,
        color: Colors.grey.shade700,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildPremiumSection(String title, List<String> points) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: AnansiColors.darkBlue,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 12),
          ...points.map(
            (p) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF17C6C6),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      p,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

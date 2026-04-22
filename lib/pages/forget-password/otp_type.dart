import 'package:app_anansi_mobile/pages/forget-password/forget_identity.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum MyOtpType { email, mobile }

class OtpType extends StatefulWidget {
  const OtpType({super.key});

  @override
  State<OtpType> createState() => _OtpTypeState();
}

class _OtpTypeState extends State<OtpType> {
  String _selectedMethod = "";

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
              SizedBox(height: 10),
              _buildPageHeader(),
              const SizedBox(height: 12),
              Text(
                "To protect your account, choose a verification method to receive a one-time security code.",
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),

              _buildDetailedOTPMethod(
                title: "Mobile Phone (SMS)",
                description:
                    "We'll send a code directly to your registered phone number via SMS.",
                deliveryEstimate: "INSTANT",
                icon: CupertinoIcons.device_phone_portrait,
                isSelected: _selectedMethod == "mobile",
                onTap: () => setState(() => _selectedMethod = "mobile"),
              ),

              _buildDetailedOTPMethod(
                title: "Email Address",
                description:
                    "A secure link or code will be sent to your inbox. Check your spam folder if it doesn't arrive.",
                deliveryEstimate: "1-2 MINS",
                icon: CupertinoIcons.mail_solid,
                isSelected: _selectedMethod == "email",
                onTap: () => setState(() => _selectedMethod = "email"),
              ),

              const Spacer(),

              // Helpful Hint
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F9FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    Icon(
                      CupertinoIcons.info_circle_fill,
                      color: Color(0xFF0EA5E9),
                      size: 18,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Make sure you have access to the device or email associated with your Anansi account.",
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF0369A1),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ForgetIdentity(otpType: MyOtpType.mobile),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AnansiColors.darkBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF074073).withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            CupertinoIcons.lock_shield,
            color: const Color(0xFF074073),
            size: 28,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "Account Recovery",
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Color(0xFF074073),
            letterSpacing: -0.8,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedOTPMethod({
    required String title,
    required String description,
    required String deliveryEstimate,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AnansiColors.darkBlue : const Color(0xFFE2E8F0),
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AnansiColors.darkBlue.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ]
              : [],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon with a soft background
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? AnansiColors.darkBlue : Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AnansiColors.darkBlue,
                size: 26,
              ),
            ),
            const SizedBox(width: 16),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          color: AnansiColors.darkBlue,
                        ),
                      ),
                      // Delivery Indicator
                      Text(
                        deliveryEstimate,
                        style: TextStyle(
                          color: isSelected
                              ? AnansiColors.darkBlue
                              : Colors.grey.shade500,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

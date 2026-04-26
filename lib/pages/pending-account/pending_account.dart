import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PendingAccount extends StatefulWidget {
  const PendingAccount({super.key});

  @override
  State<PendingAccount> createState() => _PendingAccountState();
}

class _PendingAccountState extends State<PendingAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "Verification in Progress",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: AnansiColors.darkBlue,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Text(
                      "Your documents were submitted via manual entry. To ensure the security of your account, our compliance team is manually verifying your ID/Passport and KRA details.",
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: Colors.blueGrey.shade400,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "VERIFICATION CHECKLIST",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        color: AnansiColors.darkBlue,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildCheckItem(
                      "ID / Passport Document",
                      "Pending manual audit",
                    ),
                    _buildCheckItem(
                      "KRA Pin Validation",
                      "Queued for verification",
                    ),
                    _buildCheckItem(
                      "Facial Identity Match",
                      "System verified",
                      isDone: false,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "NEED ASSISTANCE?",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        color: AnansiColors.darkBlue,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildContactMethod(
                      icon: CupertinoIcons.mail_solid,
                      title: "Email Support",
                      subtitle: "support@anansi.com",
                      onTap: () => () {},
                    ),
                    const SizedBox(height: 12),
                    _buildContactMethod(
                      icon: CupertinoIcons.phone_fill,
                      title: "Call Admin",
                      subtitle: "+254 717 393 483",
                      onTap: () => () {},
                    ),
                    const SizedBox(height: 12),
                    _buildContactMethod(
                      icon: CupertinoIcons.chat_bubble_2_fill,
                      title: "WhatsApp",
                      subtitle: "Typical response: 5 mins",
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: TextButton(
                onPressed: () {},
                child: Text(
                  "LOG OUT OF SESSION",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    color: Colors.blueGrey.shade300,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckItem(String title, String status, {bool isDone = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDone ? const Color(0xFFF0FDF4) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDone ? const Color(0xFFBBF7D0) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isDone
                ? CupertinoIcons.check_mark_circled_solid
                : CupertinoIcons.clock_fill,
            size: 20,
            color: isDone
                ? const Color(0xFF16A34A)
                : AnansiColors.darkBlue.withOpacity(0.4),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blueGrey.shade400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactMethod({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, color: AnansiColors.darkBlue, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.blueGrey.shade400,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              CupertinoIcons.chevron_right,
              size: 14,
              color: Color(0xFFCBD5E1),
            ),
          ],
        ),
      ),
    );
  }
}

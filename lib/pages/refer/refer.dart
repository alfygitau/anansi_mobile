import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class Refer extends StatefulWidget {
  final String referralCode;

  const Refer({
    super.key,
    this.referralCode = "ANANSI-8924",
  });

  @override
  State<Refer> createState() => _ReferState();
}

class _ReferState extends State<Refer> {
  void _copyToClipboard(String code) {
    Clipboard.setData(ClipboardData(text: code));
    HapticFeedback.lightImpact();

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AnansiColors.darkBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: const Row(
            children: [
              Icon(
                CupertinoIcons.checkmark_circle_fill,
                color: AnansiColors.accentCyan,
                size: 18,
              ),
              SizedBox(width: 10),
              Text(
                "Referral code copied to clipboard",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
  }

  Future<void> _shareToWhatsApp(String code) async {
    final String message = Uri.encodeComponent(
      "Join me on Anansi SACCO and grow your wealth! Use my referral code *$code* when signing up: https://anansi.co.ke/join?ref=$code",
    );
    final Uri appUri = Uri.parse("whatsapp://send?text=$message");
    final Uri webUri = Uri.parse("https://wa.me/?text=$message");

    if (await canLaunchUrl(appUri)) {
      await launchUrl(appUri);
    } else if (await canLaunchUrl(webUri)) {
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _shareViaEmail(String code) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      queryParameters: {
        'subject': 'Invitation to join Anansi SACCO',
        'body':
            'Hi,\n\nI invite you to join Anansi SACCO and explore easy savings and credit access.\n\nDownload the mobile app and use my referral code: $code during registration to get started.\n\nJoin here: https://anansi.co.ke/join?ref=$code',
      },
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  _buildHeroCard(),
                  const SizedBox(height: 20),
                  _buildCodeCard(),
                  const SizedBox(height: 20),
                  _buildSectionHeader("HOW IT WORKS"),
                  const SizedBox(height: 14),
                  _buildHowItWorksTimeline(),
                  const SizedBox(height: 36),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      backgroundColor: ThemeColors.background.withValues(alpha: 0.9),
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      leadingWidth: 64,
      title: const Text(
        "Refer a Friend",
        style: TextStyle(
          color: AnansiColors.darkBlue,
          fontWeight: FontWeight.w900,
          fontSize: 18,
          letterSpacing: -0.5,
        ),
      ),
      leading: _buildCircledIcon(
        icon: CupertinoIcons.back,
        onTap: () => Navigator.pop(context),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Center(
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  CupertinoIcons.question_circle,
                  size: 18,
                  color: AnansiColors.darkBlue,
                ),
                onPressed: () {
                  // Help / terms modal
                },
              ),
            ),
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
          color: AnansiColors.darkBlue.withValues(alpha: 0.45),
        ),
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: AnansiColors.accentCyan.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                CupertinoIcons.gift_fill,
                color: AnansiColors.accentCyan,
                size: 28,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Earn KES 300.00",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AnansiColors.darkBlue,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Invite colleagues and friends to join the SACCO and earn a direct reward on their activation.",
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

  Widget _buildCodeCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "YOUR UNIQUE REFERRAL CODE",
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
              color: Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 12),

          // Code Pill + Copy Action
          Container(
            padding: const EdgeInsets.fromLTRB(18, 10, 10, 10),
            decoration: BoxDecoration(
              color: ThemeColors.background,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.referralCode,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 2.0,
                    color: AnansiColors.darkBlue,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _copyToClipboard(widget.referralCode),
                  icon: const Icon(CupertinoIcons.doc_on_doc, size: 14),
                  label: const Text(
                    "COPY",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AnansiColors.darkBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Share Options (WhatsApp & Email)
          Row(
            children: [
              Expanded(
                child: _buildShareButton(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: "WhatsApp",
                  accentColor: const Color(0xFF25D366),
                  onTap: () => _shareToWhatsApp(widget.referralCode),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildShareButton(
                  icon: CupertinoIcons.mail,
                  label: "Email",
                  accentColor: AnansiColors.darkBlue,
                  onTap: () => _shareViaEmail(widget.referralCode),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShareButton({
    required IconData icon,
    required String label,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: accentColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: accentColor.withValues(alpha: 0.2),
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: accentColor),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHowItWorksTimeline() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildStepRow(
            stepNumber: "1",
            title: "Invite your friend",
            description: "Just share your code with friends, family, or colleagues.",
            isLast: false,
          ),
          _buildStepRow(
            stepNumber: "2",
            title: "They pay registration fee",
            description: "They complete onboarding by paying the KES 1,500.00 registration fee.",
            isLast: false,
          ),
          _buildStepRow(
            stepNumber: "3",
            title: "Earn a reward",
            description: "You earn KES 300.00 directly credited to your active FOSA account.",
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildStepRow({
    required String stepNumber,
    required String title,
    required String description,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Stepper Indicator Column
        Column(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AnansiColors.darkBlue,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AnansiColors.darkBlue.withValues(alpha: 0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  stepNumber,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 48,
                margin: const EdgeInsets.symmetric(vertical: 4),
                color: const Color(0xFFE2E8F0),
              ),
          ],
        ),
        const SizedBox(width: 16),

        // Step Content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: AnansiColors.darkBlue,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.grey.shade600,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
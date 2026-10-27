import 'package:app_anansi_mobile/components/drawer/navigation.dart';
import 'package:app_anansi_mobile/constants/constants.dart';
import 'package:app_anansi_mobile/main.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupport extends StatefulWidget {
  const HelpSupport({super.key});

  @override
  State<HelpSupport> createState() => _HelpSupportState();
}

class _HelpSupportState extends State<HelpSupport> {
  final List<Map<String, String>> _loanFaqs = [
    {
      "q": "How long does loan approval take?",
      "a":
          "Most loans are processed within 24 hours. Emergency loans may be approved faster depending on your credit score and the speed of your guarantors' signatures.",
    },
    {
      "q": "Can I have two active loans?",
      "a":
          "Currently, members are limited to one active long-term loan. However, you may apply for a short-term 'Instant Advance' or 'Salary Advance' if your credit limit allows.",
    },
    {
      "q": "How is the interest rate calculated?",
      "a":
          "$saccoName uses a reducing balance method. This means interest is only charged on the remaining principal balance, making it cheaper as you continue to repay.",
    },
    {
      "q": "What happens if my guarantor declines?",
      "a":
          "If a guarantor declines your request, the application will be paused. You will receive a notification allowing you to select an alternative member to guarantee the loan.",
    },
    {
      "q": "Can I clear my loan early?",
      "a":
          "Yes! You can settle your loan in full at any time through the 'Settle Loan' option in your dashboard. There are no penalties for early repayment.",
    },
    {
      "q": "Are there any hidden processing fees?",
      "a":
          "$saccoName is transparent. We only charge a one-time insurance fee (1%) and a small processing fee which are clearly displayed before you confirm your application.",
    },
    {
      "q": "What determines my maximum loan limit?",
      "a":
          "Your limit is based on your total savings (Multiplied by 3 or 4), your repayment history with $saccoName, and your overall credit health.",
    },
  ];

  final List<Map<String, String>> _accountFaqs = [
    {
      "q": "How do I update my KES withdrawal limit?",
      "a":
          "Withdrawal limits can be adjusted under 'Security Settings' after performing a secondary biometrics check or entering your secure PIN.",
    },
    {
      "q": "Why is my balance not updating?",
      "a":
          "Transactions usually reflect instantly. If yours hasn't, please pull to refresh your dashboard. If the issue persists, check your internet connection or 'Transaction History'.",
    },
    {
      "q": "How do I change my primary phone number?",
      "a":
          "For security reasons, phone number changes require a manual verification. Please contact our support team directly through the 'Call Us' option above.",
    },
    {
      "q": "What should I do if I lose my phone?",
      "a":
          "Contact support immediately to freeze your account. You can also log into the $saccoName Web portal from another device to remotely de-authorize your lost phone.",
    },
    {
      "q": "Can I download my transaction statements?",
      "a":
          "Yes. Navigate to the 'Accounts' tab, select a specific account, and tap the 'Export' icon to download a PDF statement for any date range.",
    },
    {
      "q": "How do I add or change my Next of Kin?",
      "a":
          "You can update your beneficiary details under 'Profile Settings' > 'Nominal Roll'. Changes are updated instantly in our secure database.",
    },
    {
      "q": "How is my data kept secure?",
      "a":
          "$saccoName uses bank-grade AES-256 encryption. We are fully compliant with the Kenya Data Protection Act, ensuring your financial info is never shared with third parties.",
    },
  ];

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  Future<void> _openWhatsApp(String phone) async {
    final Uri appUri = Uri.parse("whatsapp://send?phone=$phone&text=Hello%$saccoName%20Support");
    final Uri webUri = Uri.parse("https://wa.me/$phone?text=Hello%$saccoName%20Support");

    if (await canLaunchUrl(appUri)) {
      await launchUrl(appUri);
    } else if (await canLaunchUrl(webUri)) {
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.background,
      drawer: Navigation(
        activePageRoute: AnansiRoutes.dashboard,
        onRouteSelected: (String targetNamedRoute) {
          Navigator.pushNamed(context, targetNamedRoute);
        },
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 36),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader("DIRECT SUPPORT"),
                  const SizedBox(height: 12),
                  _buildContactSection(),
                  const SizedBox(height: 28),

                  _buildSectionHeader("LOAN INQUIRIES"),
                  const SizedBox(height: 12),
                  ..._loanFaqs.map((faq) => _buildAccordion(faq['q']!, faq['a']!)),
                  const SizedBox(height: 28),

                  _buildSectionHeader("ACCOUNT & SECURITY"),
                  const SizedBox(height: 12),
                  ..._accountFaqs.map((faq) => _buildAccordion(faq['q']!, faq['a']!)),
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
        "Help & Support",
        style: TextStyle(
          color: AnansiColors.darkBlue,
          fontWeight: FontWeight.w900,
          fontSize: 18,
          letterSpacing: -0.5,
        ),
      ),
      leading: _buildCircledIcon(
        icon: CupertinoIcons.back,
        onTap: () => Navigator.maybePop(context),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: _buildCircledIcon(
            icon: CupertinoIcons.phone_fill,
            onTap: () => _makePhoneCall("+254700000000"),
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

  Widget _buildContactSection() {
    return Row(
      children: [
        _contactCard(
          icon: CupertinoIcons.phone_fill,
          title: "Call Us",
          sub: "+254 700 000 000",
          accentColor: AnansiColors.darkBlue,
          onTap: () => _makePhoneCall("+254700000000"),
        ),
        const SizedBox(width: 12),
        _contactCard(
          icon: CupertinoIcons.chat_bubble_2_fill,
          title: "WhatsApp",
          sub: "Chat Now",
          accentColor: const Color(0xFF25D366),
          onTap: () => _openWhatsApp("+254700000000"),
        ),
      ],
    );
  }

  Widget _contactCard({
    required IconData icon,
    required String title,
    required String sub,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          splashColor: accentColor.withValues(alpha: 0.08),
          highlightColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(icon, color: accentColor, size: 20),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: AnansiColors.darkBlue,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  sub,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccordion(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.015),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
              splashColor: AnansiColors.darkBlue.withValues(alpha: 0.04),
              highlightColor: Colors.transparent,
            ),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 6,
              ),
              iconColor: AnansiColors.darkBlue,
              collapsedIconColor: const Color(0xFF94A3B8),
              title: Text(
                question,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AnansiColors.darkBlue,
                  letterSpacing: -0.2,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      answer,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                        height: 1.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:app_anansi_mobile/components/drawer/navigation.dart';
import 'package:app_anansi_mobile/main.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
          "Anansi uses a reducing balance method. This means interest is only charged on the remaining principal balance, making it cheaper as you continue to repay.",
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
          "Anansi is transparent. We only charge a one-time insurance fee (1%) and a small processing fee which are clearly displayed before you confirm your application.",
    },
    {
      "q": "What determines my maximum loan limit?",
      "a":
          "Your limit is based on your total savings (Multiplied by 3 or 4), your repayment history with Anansi, and your overall credit health.",
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
          "Contact support immediately to freeze your account. You can also log into the Anansi Web portal from another device to remotely de-authorize your lost phone.",
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
          "Anansi uses bank-grade AES-256 encryption. We are fully compliant with the Kenya Data Protection Act, ensuring your financial info is never shared with third parties.",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      drawer: Navigation(
        activePageRoute: AnansiRoutes.dashboard,
        onRouteSelected: (String targetNamedRoute) {
          Navigator.pushNamed(context, targetNamedRoute);
        },
      ),
      appBar: AppBar(
        title: const Text(
          "Help & Support",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: AnansiColors.darkBlue,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        children: [
          _buildContactSection(),
          const SizedBox(height: 32),
          _buildFaqSection("Loan Queries", _loanFaqs),
          const SizedBox(height: 24),
          _buildFaqSection("Account Queries", _accountFaqs),
        ],
      ),
    );
  }

  // --- CONTACT CARDS ---
  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Get in Touch",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: AnansiColors.darkBlue,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _contactCard(
              CupertinoIcons.phone_fill,
              "Call Us",
              "+254 700 000 000",
            ),
            const SizedBox(width: 12),
            _contactCard(
              CupertinoIcons.chat_bubble_2_fill,
              "WhatsApp",
              "Chat Now",
            ),
          ],
        ),
      ],
    );
  }

  Widget _contactCard(IconData icon, String title, String sub) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFF1F5F9)),
        ),
        child: Column(
          children: [
            Icon(icon, color: AnansiColors.darkBlue, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
            ),
            Text(
              sub,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  // --- ACCORDION GROUP ---
  Widget _buildFaqSection(String title, List<Map<String, String>> faqs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: AnansiColors.darkBlue,
          ),
        ),
        const SizedBox(height: 12),
        ...faqs.map((faq) => _buildAccordion(faq['q']!, faq['a']!)),
      ],
    );
  }

  Widget _buildAccordion(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      // 1. Add ClipRRect to ensure the Material child doesn't bleed past corners
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          // 2. Add Material widget here
          color:
              Colors.transparent, // Keep it transparent to show Container color
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
              // 3. Ensure splash colors are visible against white
              splashColor: AnansiColors.darkBlue.withValues(alpha: 0.05),
              highlightColor: Colors.transparent,
            ),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 4,
              ),
              title: Text(
                question,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AnansiColors.darkBlue,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Text(
                    answer,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                      height: 1.5,
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

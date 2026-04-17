import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final double currentShares = 4.5;
  final double targetShares = 10.0;
  bool _isBalanceVisible = true;

  @override
  Widget build(BuildContext context) {
    double percentage = (currentShares / targetShares).clamp(0.0, 1.0);
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 10),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Dashboard",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AnansiColors.darkBlue,
                    ),
                  ),
                  Text(
                    "Welcome back to your financial overview.",
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: _buildMembershipProgress(percentage),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "ACCOUNTS",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: Colors.grey,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                _buildAccountCard(
                  title: "SAVINGS",
                  accountNumber: "ACC-092834",
                  balance: "KES 450,230.50",
                  isPrimary: true,
                ),
                const SizedBox(height: 16),
                _buildAccountCard(
                  title: "SHARES",
                  accountNumber: "INV-882103",
                  balance: "KES 12,000.00",
                  isPrimary: false,
                ),
              ]),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "QUICK ACTIONS",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: Colors.grey,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 16,
                    runSpacing: 20,
                    alignment: WrapAlignment.start,
                    children: [
                      _buildQuickAction("Invest", Icons.trending_up_rounded),
                      _buildQuickAction(
                        "Deposit",
                        Icons.account_balance_wallet_rounded,
                      ),
                      _buildQuickAction("Shares", Icons.pie_chart_rounded),
                      _buildQuickAction("Calculator", Icons.calculate_rounded),
                      _buildQuickAction(
                        "Statements",
                        Icons.description_rounded,
                      ),
                      _buildQuickAction("Products", Icons.grid_view_rounded),
                      _buildQuickAction("Guarantorship", Icons.gavel_rounded),
                      _buildQuickAction(
                        "Loans",
                        CupertinoIcons.chart_bar_alt_fill,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            sliver: SliverToBoxAdapter(
              child: _buildSectionHeader("Active Applications", "2 Active"),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildApplicationItem(
                    title: "Emergency Medical Credit",
                    date: "Applied Today, 10:45 AM",
                    amount: "KES 50,000.00",
                    status: "UNDER REVIEW",
                  ),
                  const SizedBox(height: 12),
                  _buildApplicationItem(
                    title: "Asset Finance: MacBook Pro",
                    date: "Applied 15 Mar 2026",
                    amount: "KES 320,000.00",
                    status: "DOCUMENTS PENDING",
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            sliver: SliverToBoxAdapter(
              child: _buildSectionHeader("Recent Loans", "2 Active"),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildLoanItem(
                    title: "Business Growth Loan",
                    id: "LN-SEC-2026-0042",
                    amount: "KES 1,200,000.00",
                    balance: "KES 740,500.00",
                    progress: 0.38,
                    status: "Active",
                    statusColor: const Color(0xFF17C6C6),
                    maturityDate: "19th/09/2026",
                  ),
                  const SizedBox(height: 16),
                  _buildLoanItem(
                    title: "Executive Personal Credit",
                    id: "LN-SEC-2025-0918",
                    amount: "KES 150,000.00",
                    balance: "KES 12,000.00",
                    progress: 0.92,
                    status: "Near Completion",
                    statusColor: Colors.green.shade400,
                    maturityDate: "20th/01/2027",
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String badge) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: Colors.grey,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2F1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              badge,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00796B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(String label, IconData icon) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double sidePadding = 48.0;
    final double spacing = 16.0;
    final double width = (screenWidth - sidePadding - (spacing * 3)) / 4;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: width,
          height: width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade100, width: 1),
            boxShadow: [
              BoxShadow(
                color: AnansiColors.darkBlue.withValues(alpha: 0.04),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(24),
              splashColor: const Color(0xFF17C6C6).withValues(alpha: 0.1),
              child: Center(
                child: Container(
                  width: width * 0.7,
                  height: width * 0.7,
                  decoration: BoxDecoration(
                    color: const Color(0xFF17C6C6).withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(icon, size: 32, color: const Color(0xFF17C6C6)),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AnansiColors.darkBlue.withValues(alpha: 0.9),
            letterSpacing: -0.1,
          ),
        ),
      ],
    );
  }

  Widget _buildMembershipProgress(double percentage) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            const Color(0xFFF0FFFE).withValues(alpha: 0.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: AnansiColors.darkBlue.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AnansiColors.darkBlue,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: AnansiColors.darkBlue.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.verified_user_rounded,
                      color: Color(0xFF17C6C6),
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "SHARES STATUS",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 10,
                          letterSpacing: 1.5,
                          color: AnansiColors.darkBlue.withValues(alpha: 0.5),
                        ),
                      ),
                      const Text(
                        "Membership",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          color: AnansiColors.darkBlue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              _buildCircularMiniIndicator(percentage),
            ],
          ),
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black54,
                height: 1.5,
              ),
              children: [
                const TextSpan(text: "Acquire "),
                TextSpan(
                  text: "10 Shares ",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AnansiColors.darkBlue,
                  ),
                ),
                const TextSpan(text: "to unlock "),
                TextSpan(text: "Institutional Credit Intelligence"),
                const TextSpan(text: " and full dividend rights."),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildGlowProgressBar(percentage),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildProgressMetric(
                "Current Shares Holding",
                "${currentShares.toInt()} Shares",
              ),
              _buildProgressMetric("Target", "10.0 Shares", isEnd: true),
            ],
          ),
        ],
      ),
    );
  }

  // HELPER: Small circular percentage badge
  Widget _buildCircularMiniIndicator(double percentage) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF17C6C6).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "${(percentage * 100).toInt()}%",
        style: const TextStyle(
          color: Color(0xFF17C6C6),
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );
  }

  // HELPER: Glow Progress Bar
  Widget _buildGlowProgressBar(double percentage) {
    return Stack(
      children: [
        Container(
          height: 10,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 800),
          height: 10,
          width: (300 * percentage),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AnansiColors.darkBlue, Color(0xFF17C6C6)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF17C6C6).withValues(alpha: 0.4),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // HELPER: Small Metric Item
  Widget _buildProgressMetric(
    String label,
    String value, {
    bool isEnd = false,
  }) {
    return Column(
      crossAxisAlignment: isEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade400,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w900,
            color: AnansiColors.darkBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildAccountCard({
    required String title,
    required String accountNumber,
    required String balance,
    required bool isPrimary,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isPrimary ? AnansiColors.darkBlue : Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: isPrimary ? null : Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: isPrimary ? Colors.blue.shade200 : Colors.grey,
                    ),
                  ),
                  Text(
                    accountNumber,
                    style: TextStyle(
                      fontSize: 12,
                      color: isPrimary ? Colors.white60 : Colors.black54,
                    ),
                  ),
                ],
              ),
              Icon(
                CupertinoIcons.creditcard,
                color: isPrimary ? Colors.blue.shade200 : Colors.grey.shade300,
              ),
            ],
          ),
          const SizedBox(height: 35),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _isBalanceVisible ? balance : "KES ••••••••",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isPrimary ? Colors.white : AnansiColors.darkBlue,
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  _isBalanceVisible
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                ),
                color: isPrimary ? Colors.blue.shade200 : Colors.grey,
                style: IconButton.styleFrom(
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () =>
                    setState(() => _isBalanceVisible = !_isBalanceVisible),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoanItem({
    required String title,
    required String id,
    required String amount,
    required String balance,
    required double progress,
    required String status,
    required Color statusColor,
    required String maturityDate,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AnansiColors.darkBlue.withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 10, 24, 14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          color: AnansiColors.darkBlue,
                          letterSpacing: -0.4,
                        ),
                      ),
                      _buildLoanIdTag(id),
                    ],
                  ),
                ),
                _buildMaturityBadge(maturityDate),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLoanStat("Principal", amount),
                Container(width: 1, height: 30, color: Colors.grey.shade400),
                _buildLoanStat("Current Balance", balance, isHighlight: true),
              ],
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildLoanStat(
    String label,
    String value, {
    bool isHighlight = false,
  }) {
    return Column(
      crossAxisAlignment: isHighlight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w800,
            color: Colors.grey.shade500,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: isHighlight
                      ? const Color(0xFF17C6C6)
                      : AnansiColors.darkBlue,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoanIdTag(String id) {
    return Text(
      id.toUpperCase(),
      style: TextStyle(
        color: Colors.grey.shade600,
        fontSize: 13,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        fontFamily: 'Courier',
      ),
    );
  }

  // Helper: Modern Maturity Badge
  Widget _buildMaturityBadge(String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "MATURITY",
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w800,
            color: Colors.grey.shade400,
            letterSpacing: 0.5,
          ),
        ),
        Text(
          date,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AnansiColors.darkBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildApplicationItem({
    required String title,
    required String date,
    required String amount,
    required String status,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.hourglass_empty_rounded,
            color: Colors.amber,
            size: 20,
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
                    fontSize: 13,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  color: AnansiColors.darkBlue,
                ),
              ),
              Text(
                status,
                style: const TextStyle(
                  color: Colors.amber,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

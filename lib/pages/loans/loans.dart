import 'package:app_anansi_mobile/helpers/format_amount.dart';
import 'package:app_anansi_mobile/pages/help&support/help_support.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyLoans extends StatefulWidget {
  const MyLoans({super.key});

  @override
  State<MyLoans> createState() => _MyLoansState();
}

class _MyLoansState extends State<MyLoans> {
  final List<Map<String, dynamic>> loanData = [
    {
      "title": "Business Growth Loan",
      "id": "LN-2026-001",
      "amount": 250000.0,
      "balance": 185000.0,
      "status": "Active",
      "color": const Color(0xFF17C6C6), // Teal
      "maturity": "15 Dec, 2026",
    },
    {
      "title": "Emergency Medical",
      "id": "LN-2026-042",
      "amount": 50000.0,
      "balance": 12400.0,
      "status": "Active",
      "color": const Color(0xFF17C6C6),
      "maturity": "20 May, 2026",
    },
    {
      "title": "School Fees Advance",
      "id": "LN-2026-115",
      "amount": 75000.0,
      "balance": 0.0,
      "status": "Settled",
      "color": const Color(0xFF10B981), // Emerald/Green
      "maturity": "01 Apr, 2026",
    },
    {
      "title": "Personal Asset Loan",
      "id": "LN-2026-209",
      "amount": 120000.0,
      "balance": 120000.0,
      "status": "Overdue",
      "color": const Color(0xFFEF4444), // Rose/Red
      "maturity": "10 Mar, 2026",
    },
    {
      "title": "Agri-Input Credit",
      "id": "LN-2026-330",
      "amount": 35000.0,
      "balance": 15000.0,
      "status": "Active",
      "color": const Color(0xFF17C6C6),
      "maturity": "30 Jun, 2026",
    },
    {
      "title": "Instant Salary Loan",
      "id": "LN-2026-405",
      "amount": 20000.0,
      "balance": 5000.0,
      "status": "Active",
      "color": const Color(0xFF17C6C6),
      "maturity": "28 Apr, 2026",
    },
    {
      "title": "Home Improvement",
      "id": "LN-2026-512",
      "amount": 400000.0,
      "balance": 390000.0,
      "status": "Grace Period",
      "color": const Color(0xFFF59E0B), // Amber
      "maturity": "12 Jan, 2027",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          // 1. App Bar
          _buildAppBar(),

          // 2. Loan Summary Hero
          SliverToBoxAdapter(child: _buildLoanSummaryHero()),

          // 3. Application Action
          SliverToBoxAdapter(child: _buildApplyLoanAction(context)),

          // 4. Section Header with Filter
          SliverToBoxAdapter(child: _buildSectionHeader("Active Facilities")),

          // 5. The Loans List
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final loan = loanData[index];
                return _buildLoanItem(
                  title: loan['title'],
                  id: loan['id'],
                  amount: formatAmount(loan['amount']),
                  balance: formatAmount(loan['balance']),
                  status: loan['status'],
                  statusColor: loan['color'],
                  maturityDate: loan['maturity'],
                );
              }, childCount: loanData.length),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      floating: true,
      backgroundColor: const Color(0xFFF8FAFC).withValues(alpha: 0.9),
      elevation: 0,
      centerTitle: true,
      leadingWidth: 64,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Loans",
            style: TextStyle(
              color: AnansiColors.darkBlue,
              fontWeight: FontWeight.w900,
              fontSize: 15,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "ALL LOANS",
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ],
      ),
      leading: Center(
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade100),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(
              CupertinoIcons.back,
              size: 18,
              color: AnansiColors.darkBlue,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HelpSupport(),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoanItem({
    required String title,
    required String id,
    required String amount,
    required String balance,
    required String status,
    required Color statusColor,
    required String maturityDate,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          // 1. Header Section
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 14),
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

          // 2. The Main Stats Box
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
                Container(
                  width: 1,
                  height: 30,
                  color: Colors.grey.withValues(alpha: 0.15),
                ),
                _buildLoanStat("Current Balance", balance, isHighlight: true),
              ],
            ),
          ),

          // 3. NEW REFINED STATUS FOOTER
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Status Chip
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        status.toUpperCase(),
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                // Simple "Manage" or "Details" Text
                const Row(
                  children: [
                    Text(
                      "View Details",
                      style: TextStyle(
                        color: AnansiColors.darkBlue,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      CupertinoIcons.chevron_right,
                      size: 12,
                      color: AnansiColors.darkBlue,
                    ),
                  ],
                ),
              ],
            ),
          ),
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
                style: GoogleFonts.robotoMono(
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
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
      ),
    );
  }

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

  Widget _buildLoanSummaryHero() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AnansiColors.darkBlue, Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AnansiColors.darkBlue.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Total Outstanding",
            style: TextStyle(
              color: Colors.white60,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "KES 142,500.00",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _summaryMiniStat("Next Repayment", "15 May"),
              const SizedBox(width: 40),
              _summaryMiniStat("Loan Limit", "KES 500k"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryMiniStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white38, fontSize: 10),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildApplyLoanAction(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: InkWell(
        onTap: () => _handleNewApplication(context),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AnansiColors.darkBlue.withValues(alpha: 0.1),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: AnansiColors.darkBlue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  CupertinoIcons.add,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Apply for a new Loan",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: AnansiColors.darkBlue,
                      ),
                    ),
                    Text(
                      "Instant processing for eligible members",
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Icon(
                CupertinoIcons.chevron_right,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: AnansiColors.darkBlue,
              letterSpacing: -0.5,
            ),
          ),
          const Icon(
            CupertinoIcons.slider_horizontal_3,
            size: 20,
            color: AnansiColors.darkBlue,
          ),
        ],
      ),
    );
  }

  void _handleNewApplication(BuildContext context) {
    // Logic to open Application page
  }
}

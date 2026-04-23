import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Statements extends StatefulWidget {
  const Statements({super.key});

  @override
  State<Statements> createState() => _StatementsState();
}

class _StatementsState extends State<Statements> {
  int _activeSegment = 0;
  final List<Map<String, dynamic>> accountStatements = [
    {
      "title": "Savings Deposit",
      "ref": "DEP-8842",
      "date": "Oct 28, 2025",
      "amount": "15,000.00",
      "type": "Credit",
    },
    {
      "title": "Share Capital",
      "ref": "SHR-0021",
      "date": "Oct 24, 2025",
      "amount": "5,000.00",
      "type": "Credit",
    },
    {
      "title": "Withdrawal",
      "ref": "WDL-1109",
      "date": "Oct 22, 2025",
      "amount": "2,500.00",
      "type": "Debit",
    },
    {
      "title": "Dividend Payout",
      "ref": "DIV-2025",
      "date": "Oct 18, 2025",
      "amount": "8,750.00",
      "type": "Credit",
    },
    {
      "title": "Interest Earned",
      "ref": "INT-4491",
      "date": "Oct 15, 2025",
      "amount": "420.50",
      "type": "Credit",
    },
    {
      "title": "Monthly Contribution",
      "ref": "CON-7732",
      "date": "Oct 10, 2025",
      "amount": "3,000.00",
      "type": "Credit",
    },
    {
      "title": "Account Maintenance",
      "ref": "FEE-0044",
      "date": "Oct 05, 2025",
      "amount": "100.00",
      "type": "Debit",
    },
    {
      "title": "Festive Savings",
      "ref": "SAV-3321",
      "date": "Oct 01, 2025",
      "amount": "10,000.00",
      "type": "Credit",
    },
  ];

  final List<Map<String, dynamic>> loanStatements = [
    {
      "title": "Emergency Loan",
      "ref": "REP-9901",
      "date": "Oct 27, 2025",
      "amount": "2,400.00",
      "type": "Repayment",
    },
    {
      "title": "Asset Finance",
      "ref": "REP-8821",
      "date": "Oct 25, 2025",
      "amount": "12,500.00",
      "type": "Repayment",
    },
    {
      "title": "Loan Disbursement",
      "ref": "DIS-4402",
      "date": "Oct 20, 2025",
      "amount": "150,000.00",
      "type": "Credit",
    },
    {
      "title": "Development Loan",
      "ref": "REP-4420",
      "date": "Oct 15, 2025",
      "amount": "15,200.00",
      "type": "Repayment",
    },
    {
      "title": "Interest Charged",
      "ref": "CHG-1122",
      "date": "Oct 12, 2025",
      "amount": "1,850.00",
      "type": "Debit",
    },
    {
      "title": "Salary Advance",
      "ref": "REP-0032",
      "date": "Oct 08, 2025",
      "amount": "4,000.00",
      "type": "Repayment",
    },
    {
      "title": "Education Loan",
      "ref": "REP-7761",
      "date": "Oct 05, 2025",
      "amount": "8,000.00",
      "type": "Repayment",
    },
    {
      "title": "Processing Fee",
      "ref": "FEE-9932",
      "date": "Oct 02, 2025",
      "amount": "1,500.00",
      "type": "Debit",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: InkWell(
                onTap: () => {},
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AnansiColors.darkBlue.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AnansiColors.darkBlue.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AnansiColors.darkBlue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          CupertinoIcons.calendar_badge_plus,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Custom Statement",
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 14,
                                color: AnansiColors.darkBlue,
                              ),
                            ),
                            Text(
                              "Filter by specific dates or categories",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        CupertinoIcons.chevron_right,
                        size: 14,
                        color: AnansiColors.darkBlue.withValues(alpha: 0.3),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 1. Modern Segmented Picker
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    _buildSegmentItem(0, "Accounts"),
                    _buildSegmentItem(1, "Loans"),
                  ],
                ),
              ),
            ),
          ),

          // 2. Search/Filter Row
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "RECENT STATEMENTS",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: Colors.blueGrey.shade300,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Icon(
                    CupertinoIcons.slider_horizontal_3,
                    size: 18,
                    color: Colors.blueGrey.shade300,
                  ),
                ],
              ),
            ),
          ),

          // 3. Dynamic List Content
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final data = _activeSegment == 0
                      ? accountStatements
                      : loanStatements;
                  return _buildStatementCard(data[index]);
                },
                childCount: _activeSegment == 0
                    ? accountStatements.length
                    : loanStatements.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentItem(int index, String label) {
    bool isActive = _activeSegment == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeSegment = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isActive ? FontWeight.w900 : FontWeight.w600,
              color: isActive
                  ? AnansiColors.darkBlue
                  : Colors.blueGrey.shade400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatementCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F4F8)),
      ),
      child: Row(
        children: [
          // Icon based on Credit/Debit
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AnansiColors.darkBlue.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _activeSegment == 0
                  ? CupertinoIcons.doc_text
                  : CupertinoIcons.briefcase,
              color: AnansiColors.darkBlue,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: AnansiColors.darkBlue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Ref: ${item['ref']} • ${item['date']}",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.blueGrey.shade400,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "KES ${item['amount']}",
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  color: AnansiColors.darkBlue,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  item['type'].toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFF10B981),
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      backgroundColor: const Color(0xFFF8FAFC).withValues(alpha: 0.9),
      elevation: 0,
      centerTitle: true,
      leadingWidth: 64,
      title: const Text(
        "Statements",
        style: TextStyle(
          color: AnansiColors.darkBlue,
          fontWeight: FontWeight.w900,
          fontSize: 18,
          letterSpacing: -0.5,
        ),
      ),
      leading: _buildCircledIcon(
        CupertinoIcons.back,
        () => Navigator.pop(context),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: _buildCircledIcon(CupertinoIcons.cloud_download, () {}),
        ),
      ],
    );
  }

  Widget _buildCircledIcon(IconData icon, VoidCallback onTap) {
    return Center(
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(icon, size: 18, color: AnansiColors.darkBlue),
          onPressed: onTap,
        ),
      ),
    );
  }
}

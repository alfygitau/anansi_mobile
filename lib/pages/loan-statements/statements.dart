import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoanStatements extends StatefulWidget {
  const LoanStatements({super.key});

  @override
  State<LoanStatements> createState() => _LoanStatementsState();
}

class _LoanStatementsState extends State<LoanStatements> {
  final List<Map<String, dynamic>> loanStatements = [
    {
      "id": "STMT-LN-201",
      "type": "loan",
      "status": "active",
      "start_date": "2026-01-15T09:00:00Z",
      "end_date": "2026-02-15T09:00:00Z",
      "amount": "30,000.00",
      "ref": "ANS/LN/EMG-881",
      "product": {
        "id": "PROD-EMERGENCY-LOAN",
        "name": "Instant Emergency Loan",
        "interest_rate": "6.0",
      },
    },
    {
      "id": "STMT-LN-202",
      "type": "loan",
      "status": "active",
      "start_date": "2026-02-25T14:30:00Z",
      "end_date": "2026-03-25T14:30:00Z",
      "amount": "15,000.00",
      "ref": "ANS/LN/SAL-042",
      "product": {
        "id": "PROD-SALARY-ADVANCE",
        "name": "Salary Advance Booster",
        "interest_rate": "4.5",
      },
    },
    {
      "id": "STMT-LN-203",
      "type": "loan",
      "status": "settled",
      "start_date": "2025-03-01T10:00:00Z",
      "end_date": "2026-03-01T10:00:00Z",
      "amount": "450,000.00",
      "ref": "ANS/LN/AST-990",
      "product": {
        "id": "PROD-ASSET-FINANCE",
        "name": "Asset & Motor Vehicle Financing",
        "interest_rate": "13.5",
      },
    },
    {
      "id": "STMT-LN-204",
      "type": "loan",
      "status": "active",
      "start_date": "2026-04-10T11:15:00Z",
      "end_date": "2026-10-10T11:15:00Z",
      "amount": "180,000.00",
      "ref": "ANS/LN/DEV-332",
      "product": {
        "id": "PROD-DEVELOPMENT-LN",
        "name": "6-Month Development Capital",
        "interest_rate": "10.0",
      },
    },
    {
      "id": "STMT-LN-205",
      "type": "loan",
      "status": "default_warning",
      "start_date": "2026-01-05T08:00:00Z",
      "end_date": "2026-04-05T08:00:00Z",
      "amount": "60,000.00",
      "ref": "ANS/LN/EDU-114",
      "product": {
        "id": "PROD-EDUCATION-LOAN",
        "name": "School Fees Flexi-Loan",
        "interest_rate": "5.0",
      },
    },
    {
      "id": "STMT-LN-206",
      "type": "loan",
      "status": "pending_approval",
      "start_date": "2026-05-20T16:45:00Z",
      "end_date": "2026-06-20T16:45:00Z",
      "amount": "250,000.00",
      "ref": "ANS/LN/BIZ-607",
      "product": {
        "id": "PROD-BIZ-GROWTH",
        "name": "SME Business Working Capital",
        "interest_rate": "12.0",
      },
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
              delegate: SliverChildBuilderDelegate((context, index) {
                final data = loanStatements;
                return _buildStatementCard(data[index], () {});
              }, childCount: loanStatements.length),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatementCard(
    Map<String, dynamic> item,
    VoidCallback onDownload,
  ) {
    final String productName =
        item['product']?['name'] ?? item['title'] ?? 'Statement';
    final String statementType = item['type'] ?? 'account';
    final String reference = item['ref'] ?? '—';
    final bool isLoan = statementType.toLowerCase() == 'loan';

    String formatDate(dynamic dateVal) {
      if (dateVal == null) return '—';
      try {
        final DateTime parsed = DateTime.parse(dateVal.toString());
        final List<String> months = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ];
        return "${parsed.day} ${months[parsed.month - 1]} ${parsed.year}";
      } catch (_) {
        return dateVal.toString();
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                // Icon Node
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: isLoan
                        ? const Color(0xFFEFF6FF)
                        : const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    isLoan ? CupertinoIcons.shield : CupertinoIcons.creditcard,
                    color: isLoan
                        ? const Color(0xFF2563EB)
                        : const Color(0xFF16A34A),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),

                // Product Text Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: AnansiColors.darkBlue,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "REF: $reference",
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF64748B),
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        "Repayment Summary",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF334155),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(23),
                bottomRight: Radius.circular(23),
              ),
              border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Meta Block 1: Start Date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "START DATE",
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF94A3B8),
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formatDate(item['start_date'] ?? item['date']),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF334155),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "END DATE",
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF94A3B8),
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formatDate(item['end_date'] ?? item['date']),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF334155),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: onDownload,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            CupertinoIcons.cloud_download,
                            color: AnansiColors.darkBlue,
                            size: 14,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "PDF",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              color: AnansiColors.darkBlue,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
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

import 'package:app_anansi_mobile/components/statements/generate_statement.dart';
import 'package:app_anansi_mobile/services/account_service.dart';
import 'package:app_anansi_mobile/services/error_service.dart';
import 'package:app_anansi_mobile/services/secure_storage_service.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Statements extends StatefulWidget {
  const Statements({super.key});

  @override
  State<Statements> createState() => _StatementsState();
}

class _StatementsState extends State<Statements> {
  List<Map<String, dynamic>> accounts = [];
  final List<Map<String, dynamic>> accountStatements = [
    {
      "id": "STMT-ACC-091",
      "type": "account",
      "status": "completed",
      "start_date": "2026-01-01T00:00:00Z",
      "end_date": "2026-01-31T23:59:59Z",
      "amount": "84,500.00",
      "ref": "ANS/SAV/4821",
      "product": {
        "id": "PROD-ORDINARY-SAVINGS",
        "name": "Ordinary Savings Ledger",
        "interest_rate": "4.5",
      },
    },
    {
      "id": "STMT-ACC-092",
      "type": "account",
      "status": "completed",
      "start_date": "2026-02-01T00:00:00Z",
      "end_date": "2026-02-28T23:59:59Z",
      "amount": "350,000.00",
      "ref": "ANS/SHR/9024",
      "product": {
        "id": "PROD-MEMBER-SHARES",
        "name": "Core Member Capital Shares",
        "interest_rate": "11.2",
      },
    },
    {
      "id": "STMT-ACC-093",
      "type": "account",
      "status": "completed",
      "start_date": "2026-03-01T00:00:00Z",
      "end_date": "2026-03-31T23:59:59Z",
      "amount": "1,200,000.00",
      "ref": "ANS/INV/3115",
      "product": {
        "id": "PROD-WEALTH-GROWTH",
        "name": "Alpha Investment Fund",
        "interest_rate": "9.8",
      },
    },
    {
      "id": "STMT-ACC-094",
      "type": "account",
      "status": "completed",
      "start_date": "2025-12-01T00:00:00Z",
      "end_date": "2026-05-01T00:00:00Z",
      "amount": "500,000.00",
      "ref": "ANS/FXD/7762",
      "product": {
        "id": "PROD-FIXED-DEPOSIT",
        "name": "6-Month Fixed Term Lock-In",
        "interest_rate": "8.75",
      },
    },
    {
      "id": "STMT-ACC-095",
      "type": "account",
      "status": "completed",
      "start_date": "2026-04-01T00:00:00Z",
      "end_date": "2026-04-30T23:59:59Z",
      "amount": "12,450.25",
      "ref": "ANS/CHG/1089",
      "product": {
        "id": "PROD-HOLIDAY-CLUB",
        "name": "Christmas & Holiday Savings",
        "interest_rate": "5.0",
      },
    },
    {
      "id": "STMT-ACC-096",
      "type": "account",
      "status": "completed",
      "start_date": "2026-05-01T00:00:00Z",
      "end_date": "2026-05-24T18:00:00Z",
      "amount": "96,320.00",
      "ref": "ANS/VOL/5541",
      "product": {
        "id": "PROD-VOLUNTARY-DEP",
        "name": "Voluntary Micro-Deposits",
        "interest_rate": "6.2",
      },
    },
  ];

  void showGenerateStatementSheet(
    BuildContext context, {
    required List<Map<String, dynamic>> accounts,
    required VoidCallback onSubmit,
    bool isLoading = false,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0xFF0F172A).withValues(alpha: 0.6),
      builder: (context) => GenerateStatement(
        accounts: accounts,
        onSubmit: onSubmit,
        isLoading: isLoading,
      ),
    );
  }

  Future<void> fetchCustomerDetails() async {
    final (response, errors) = await AccountService().customerDetails();
    if (errors != null) {
      ErrorService.showActionableError(
        context,
        title: errors[0],
        message: errors[1],
      );
    } else if (response != null) {
      final responseInfo = response.data['data'];
      await SecureStorageService().write("user", responseInfo);
      setState(() {
        accounts = List<Map<String, dynamic>>.from(
          responseInfo['accounts'] ?? [],
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCustomerDetails();
  }

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
                onTap: () => {
                  showGenerateStatementSheet(
                    context,
                    accounts: accounts,
                    onSubmit: () => {},
                  ),
                },
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
                              "Generate Statement",
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 14,
                                color: AnansiColors.darkBlue,
                              ),
                            ),
                            Text(
                              "Instant processing of statements",
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
                final data = accountStatements;
                return _buildStatementCard(data[index], () {});
              }, childCount: accountStatements.length),
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
                        "Account Summary",
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

                // Meta Block 2: End Date
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
                // Meta Block 4: Download trigger button node
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

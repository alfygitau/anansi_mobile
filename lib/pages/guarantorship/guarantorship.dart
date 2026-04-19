import 'package:app_anansi_mobile/helpers/format_amount.dart';
import 'package:app_anansi_mobile/pages/guarantorship/view_request.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Guarantorship extends StatefulWidget {
  const Guarantorship({super.key});

  @override
  State<Guarantorship> createState() => _GuarantorshipState();
}

class _GuarantorshipState extends State<Guarantorship> {
  String activeTab = 'Requests';

  final Map<String, dynamic> loanStatus = {
    'availableBalance': 485000.00,
    'totalAmountAlreadyGuaranteed': 312500.00,
    'guaranteedLoans': [
      {
        'borrowerName': 'David Kamau',
        'amountGuaranteed': 50000.0,
        'loanInfo': {
          'loancode': 'LN-992',
          'loanamount': 150000.0,
          'duration': '12 Months',
        },
        'phone': '0712345678',
      },
      {
        'borrowerName': 'Sarah Wanjiku',
        'amountGuaranteed': 70500.0,
        'loanInfo': {
          'loancode': 'LN-441',
          'loanamount': 200000.0,
          'duration': '24 Months',
        },
        'phone': '0722000111',
      },
      {
        'borrowerName': 'Michael Otieno',
        'amountGuaranteed': 25000.0,
        'loanInfo': {
          'loancode': 'LN-102',
          'loanamount': 50000.0,
          'duration': '6 Months',
        },
        'phone': '0733000222',
      },
      {
        'borrowerName': 'Faith Mutua',
        'amountGuaranteed': 100000.0,
        'loanInfo': {
          'loancode': 'LN-558',
          'loanamount': 500000.0,
          'duration': '36 Months',
        },
        'phone': '0744000333',
      },
      {
        'borrowerName': 'Brian Kipkorir',
        'amountGuaranteed': 15000.0,
        'loanInfo': {
          'loancode': 'LN-229',
          'loanamount': 30000.0,
          'duration': '3 Months',
        },
        'phone': '0755000444',
      },
      {
        'borrowerName': 'Alice Njeri',
        'amountGuaranteed': 40000.0,
        'loanInfo': {
          'loancode': 'LN-881',
          'loanamount': 120000.0,
          'duration': '12 Months',
        },
        'phone': '0766000555',
      },
      {
        'borrowerName': 'James Omondi',
        'amountGuaranteed': 12000.0,
        'loanInfo': {
          'loancode': 'LN-337',
          'loanamount': 25000.0,
          'duration': '6 Months',
        },
        'phone': '0777000666',
      },
    ],
  };

  final Map<String, dynamic> sampleLoanRequest = {
    'borrowerName': 'Alfred Kariuki',
    'borrowerPhone': '0712 345 678',
    'status': 'pending', 
    'date': '2026-04-19',
    'loanInfo': {
      'loancode': 'LN-AN-8821',
      'loanamount': 75000.00,
      'loanInterest': 3.5,
      'duration': '12 Months',
      'loanRepaymentAmount': 84000.00, 
    },
  };

  final List<Map<String, dynamic>> myRequests = [
    {
      'name': 'John Doe',
      'msg': 'Guarantorship for KES 45,000 Personal Loan',
      'status': 'pending',
      'date': '2026-04-18',
    },
    {
      'name': 'Jane Smith',
      'msg': 'Guarantorship for KES 100,000 Business Loan',
      'status': 'accepted',
      'date': '2026-04-17',
    },
    {
      'name': 'Peter Parker',
      'msg': 'Guarantorship for KES 15,000 Emergency Loan',
      'status': 'rejected',
      'date': '2026-04-16',
    },
    {
      'name': 'Mary Jane',
      'msg': 'Guarantorship for KES 200,000 School Fees',
      'status': 'pending',
      'date': '2026-04-15',
    },
    {
      'name': 'Bruce Wayne',
      'msg': 'Guarantorship for KES 50,000 Tech Loan',
      'status': 'accepted',
      'date': '2026-04-14',
    },
    {
      'name': 'Clark Kent',
      'msg': 'Guarantorship for KES 30,000 Travel Loan',
      'status': 'pending',
      'date': '2026-04-13',
    },
    {
      'name': 'Diana Prince',
      'msg': 'Guarantorship for KES 75,000 Asset Finance',
      'status': 'accepted',
      'date': '2026-04-12',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(child: _buildBalanceDashboard()),
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabDelegate(_buildTabRow()),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: activeTab == 'Requests'
                ? _buildRequestSliverList()
                : _buildLoanSliverList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      floating: true,
      backgroundColor: const Color(0xFFF1F5F9).withValues(alpha: 0.9),
      elevation: 0,
      centerTitle: true,
      leadingWidth: 64,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Guarantorship",
            style: TextStyle(
              color: AnansiColors.darkBlue,
              fontWeight: FontWeight.w900,
              fontSize: 15,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            "LOAN MANAGEMENT",
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 7,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
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
              ),
              child: const Icon(
                CupertinoIcons.question_circle,
                size: 18,
                color: AnansiColors.darkBlue,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceDashboard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _headerStat(
                "Available",
                loanStatus['availableBalance'],
                AnansiColors.iconBlue,
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.grey.withValues(alpha: 0.2),
              ),
              _headerStat(
                "Guaranteed",
                loanStatus['totalAmountAlreadyGuaranteed'],
                AnansiColors.darkBlue,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: AnansiColors.darkBlue.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 18,
                  color: AnansiColors.darkBlue,
                ),
                const SizedBox(width: 10),
                Text(
                  "You are currently guaranteeing ${loanStatus['guaranteedLoans'].length} active loans.",
                  style: const TextStyle(
                    fontSize: 12,
                    color: AnansiColors.darkBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerStat(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          formatAmount(value),
          style: GoogleFonts.robotoMono(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: -1,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildTabRow() {
    return Container(
      color: const Color(0xFFF1F5F9),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: ['Requests', 'Guaranteed Loans'].map((tab) {
            bool isSel = activeTab == tab;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => activeTab = tab),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSel ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    tab,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                      color: isSel ? AnansiColors.darkBlue : Colors.grey,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildRequestSliverList() {
    if (myRequests.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: _buildEmptyState(
          icon: CupertinoIcons.bell_slash,
          title: "No Pending Requests",
          description:
              "You don't have any new guarantorship requests at the moment.",
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, i) {
        final req = myRequests[i];
        return _modernCard(
          title: req['name'],
          subtitle: req['msg'],
          trailing: _statusBadge(req['status']),
          date: req['date'],
          icon: Icons.person_add_alt_1_rounded,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewRequest(loanInfo: sampleLoanRequest),
              ),
            );
          },
        );
      }, childCount: myRequests.length),
    );
  }

  Widget _buildLoanSliverList() {
    final loans = loanStatus['guaranteedLoans'] as List;

    if (loans.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: _buildEmptyState(
          icon: Icons.shield_outlined,
          title: "No Active Guarantees",
          description:
              "Loans you guarantee for others will appear here once approved.",
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, i) {
        final loan = loans[i];
        return _modernCard(
          title: loan['borrowerName'],
          subtitle: "Loan ID: ${loan['loanInfo']['loancode']}",
          trailing: Text(
            "KES ${NumberFormat('#,###').format(loan['amountGuaranteed'])}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AnansiColors.darkBlue,
            ),
          ),
          date: loan['phone'],
          icon: Icons.shield_outlined,
          onTap: () => _showDetailedSheet(loan),
        );
      }, childCount: loans.length),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: AnansiColors.logoBg.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 60,
              color: AnansiColors.iconBlue.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AnansiColors.darkBlue,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _modernCard({
    required String title,
    required String subtitle,
    required Widget trailing,
    required String date,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AnansiColors.logoBg.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: AnansiColors.iconBlue),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AnansiColors.darkBlue,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    date,
                    style: const TextStyle(
                      color: AnansiColors.iconBlue,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color c = status == 'pending'
        ? Colors.orange
        : (status == 'accepted' ? AnansiColors.accentCyan : Colors.red);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: c, fontSize: 9, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showDetailedSheet(Map<String, dynamic> loan) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Color(0xFFF8FAFC),
          borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 36,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Text(
                        "Loan Details",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 22,
                          color: AnansiColors.darkBlue,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Reference #${loan['loanInfo']['loancode']}",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        _buildDetailCard(
                          title: "Borrower Information",
                          icon: CupertinoIcons.person_fill,
                          children: [
                            _infoRow("Full Name", loan['borrowerName']),
                            _infoRow("Mobile Number", loan['phone'] ?? "N/A"),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildDetailCard(
                          title: "Loan Figures",
                          icon: CupertinoIcons.money_dollar_circle_fill,
                          children: [
                            _infoRow(
                              "Total Loan",
                              "KES ${NumberFormat('#,###').format(loan['loanInfo']['loanamount'])}",
                            ),
                            _infoRow("Duration", loan['loanInfo']['duration']),
                            const Divider(height: 30, thickness: 0.5),
                            _infoRow(
                              "Your Guarantee",
                              "KES ${NumberFormat('#,###').format(loan['amountGuaranteed'])}",
                              isHighlight: true,
                            ),
                          ],
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Action Button (Pinned to Bottom with Gradient Overlay)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFFF8FAFC).withOpacity(0),
                      const Color(0xFFF8FAFC),
                    ],
                  ),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AnansiColors.darkBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Dismiss Details",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Custom Card Wrapper for "Premium" look
  Widget _buildDetailCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AnansiColors.iconBlue),
              const SizedBox(width: 8),
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: Colors.grey.shade400,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  // Refined Info Row
  Widget _infoRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isHighlight
                  ? AnansiColors.accentCyan
                  : AnansiColors.darkBlue,
              fontSize: isHighlight ? 16 : 14,
              fontWeight: isHighlight ? FontWeight.w900 : FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _TabDelegate(this.child);
  @override
  double get minExtent => 60;
  @override
  double get maxExtent => 60;
  @override
  Widget build(context, double shrink, bool overlaps) => child;
  @override
  bool shouldRebuild(_TabDelegate old) => true;
}

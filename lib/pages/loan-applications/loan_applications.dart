import 'package:app_anansi_mobile/helpers/format_amount.dart';
import 'package:app_anansi_mobile/helpers/format_time.dart';
import 'package:app_anansi_mobile/pages/help&support/help_support.dart';
import 'package:app_anansi_mobile/pages/loan-applications/loan_application.dart';
import 'package:app_anansi_mobile/pages/loan-products/loan_products.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoanApplications extends StatefulWidget {
  const LoanApplications({super.key});

  @override
  State<LoanApplications> createState() => _LoanApplicationsState();
}

class _LoanApplicationsState extends State<LoanApplications> {
  final List<Map<String, dynamic>> applicationData = [
    {
      "reference": "LN-2026-901",
      "title": "Emergency Personal Loan",
      "createdAt": "2026-04-21T10:30:00Z",
      "amount": 45000.0,
      "status": "Pending",
    },
    {
      "reference": "LN-2026-885",
      "title": "Business Expansion",
      "createdAt": "2026-04-15T14:20:00Z",
      "amount": 120000.0,
      "status": "Under Review",
    },
    {
      "reference": "LN-2026-872",
      "title": "Medical Expense Cover",
      "createdAt": "2026-04-12T08:45:00Z",
      "amount": 35000.0,
      "status": "Approved",
    },
    {
      "reference": "LN-2026-810",
      "title": "Home Improvement",
      "createdAt": "2026-04-02T16:10:00Z",
      "amount": 250000.0,
      "status": "Pending",
    },
    {
      "reference": "LN-2026-772",
      "title": "School Fees Loan",
      "createdAt": "2026-03-10T09:15:00Z",
      "amount": 25000.0,
      "status": "Declined",
    },
    {
      "reference": "LN-2026-654",
      "title": "Agribusiness Startup",
      "createdAt": "2026-02-28T11:20:00Z",
      "amount": 150000.0,
      "status": "Approved",
    },
    {
      "reference": "LN-2026-512",
      "title": "Vehicle Maintenance",
      "createdAt": "2026-02-14T13:00:00Z",
      "amount": 15000.0,
      "status": "Approved",
    },
    {
      "reference": "LN-2026-440",
      "title": "Rent Advancement",
      "createdAt": "2026-01-25T10:00:00Z",
      "amount": 60000.0,
      "status": "Approved",
    },
  ];

  void _handleNewApplication(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoanProducts()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(child: _buildApplicationSummary()),
          SliverToBoxAdapter(child: _buildApplyLoanAction(context)),
          SliverToBoxAdapter(child: _buildSectionHeader("Application History")),
          // 3. Application Action
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final item = applicationData[index];
                return _buildApplicationItem(
                  reference: item['reference'] ?? "N/A",
                  title: item['title'] ?? "Loan Application",
                  date: formatPostgresDateWithTime(item['createdAt']),
                  amount: formatAmount(item['amount'] ?? 0),
                  status: item['status'] ?? "Pending",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoanApplication(),
                      ),
                    );
                  },
                );
              }, childCount: applicationData.length),
            ),
          ),
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
            "Loan Applications",
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
                "ALL APPLICATIONS",
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 7,
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

  Widget _buildApplicationSummary() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AnansiColors.darkBlue, Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AnansiColors.darkBlue.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Better spacing for 3 items
        children: [
          _statItem("In Review", "2", CupertinoIcons.refresh_thick),
          // The "Hero" Center Item: Focusing on what's available to the client
          _statItem(
            "Credit Limit",
            "KES 500k",
            CupertinoIcons.graph_square,
            isHero: true,
          ),
          _statItem("Successful", "12", CupertinoIcons.checkmark_seal),
        ],
      ),
    );
  }

  Widget _statItem(
    String label,
    String value,
    IconData icon, {
    bool isHero = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isHero ? const Color(0xFF17C6C6) : Colors.white38,
          size: isHero ? 24 : 18,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: isHero ? 18 : 14,
            letterSpacing: -0.5,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: isHero ? Colors.white70 : Colors.white38,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 24,
                height: 3,
                decoration: BoxDecoration(
                  color: const Color(0xFF17C6C6),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
          // The Filter Icon
          GestureDetector(
            onTap: () {
              // Trigger filter bottom sheet
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF1F5F9)),
              ),
              child: const Icon(
                CupertinoIcons.slider_horizontal_3,
                size: 18,
                color: AnansiColors.darkBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationItem({
    required String reference,
    required String title,
    required String date,
    required String amount,
    required String status,
    required VoidCallback onTap,
  }) {
    // Logic to determine color based on status
    Color statusColor;
    IconData statusIcon;

    switch (status.toLowerCase()) {
      case 'approved':
        statusColor = const Color(0xFF10B981); // Emerald
        statusIcon = CupertinoIcons.checkmark_circle_fill;
        break;
      case 'declined':
        statusColor = const Color(0xFFEF4444); // Rose
        statusIcon = CupertinoIcons.xmark_circle_fill;
        break;
      case 'pending':
      default:
        statusColor = const Color(0xFFF59E0B); // Amber
        statusIcon = CupertinoIcons.clock_fill;
        break;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30), // Match the container
        splashColor: const Color(
          0xFF17C6C6,
        ).withValues(alpha: 0.05), // Anansi Teal subtle splash
        highlightColor: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // 1. Status Indicator Icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(statusIcon, color: statusColor, size: 20),
              ),
              const SizedBox(width: 16),

              // 2. Main Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reference.toUpperCase(),
                      style: GoogleFonts.robotoMono(
                        color: Colors.grey.shade400,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        color: AnansiColors.darkBlue,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          CupertinoIcons.calendar,
                          size: 10,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          date,
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 3. Amount and Status Badge
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    amount,
                    style: GoogleFonts.robotoMono(
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                      color: AnansiColors.darkBlue,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      status.toUpperCase(),
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

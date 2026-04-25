import 'package:app_anansi_mobile/pages/help&support/help_support.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoanApplication extends StatefulWidget {
  const LoanApplication({super.key});

  @override
  State<LoanApplication> createState() => _LoanApplicationState();
}

class _LoanApplicationState extends State<LoanApplication> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(child: _buildApplicationStatusHeader()),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: _sectionTitle("Potential Terms"),
            ),
          ),
          SliverToBoxAdapter(child: _buildPotentialParameters()),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 8),
              child: _sectionTitle("Requirements Checklist"),
            ),
          ),
          _buildRequirementsList(),
          const SliverPadding(padding: EdgeInsets.only(bottom: 140)),
        ],
      ),
      bottomSheet: _buildContinuationDock(),
    );
  }

  // --- 1. THE STATUS HEADER ---
  Widget _buildApplicationStatusHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0A2351), Color(0xFF1A3A7A)],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: -20,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white.withValues(alpha: 0.03),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                children: [
                  // 1. TOP BAR: ID & GLOSS STATUS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "APPLICATION ID",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.4),
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const Text(
                            "AN-8821-026",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      _buildPremiumStatusBadge(
                        "UNDER REVIEW",
                        const Color(0xFFFFB300),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    "POTENTIAL LOAN AMOUNT",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "KES 45,000.00",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Divider(color: Colors.white12, height: 1),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(
                        CupertinoIcons.info_circle,
                        color: Color(0xFF17C6C6),
                        size: 16,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Verification in progress. Expect a response within 24 hours.",
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- SUB-COMPONENTS FOR DETAIL ---

  Widget _buildPremiumStatusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  // --- 2. POTENTIAL PARAMETERS ---
  Widget _buildPotentialParameters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0xFFF1F4F8), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // 1. PRODUCT BRANDING LINE
            Row(
              children: [
                _buildCircularIcon(
                  CupertinoIcons.shield_fill,
                  const Color(0xFF0A2351),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "LOAN PRODUCT",
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                    const Text(
                      "Emergency Fund Plus",
                      style: TextStyle(
                        color: Color(0xFF0A2351),
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Divider(color: Color(0xFFF1F4F8), height: 1),
            ),

            // 2. DATA GRID (2x3 Layout)
            Table(
              children: [
                TableRow(
                  children: [
                    _detailCell(
                      "Interest Rate",
                      "1.5% / Mo",
                      CupertinoIcons.percent,
                    ),
                    _detailCell(
                      "Loan Period",
                      "6 Months",
                      CupertinoIcons.calendar,
                    ),
                  ],
                ),
                const TableRow(
                  children: [SizedBox(height: 20), SizedBox(height: 20)],
                ),
                TableRow(
                  children: [
                    _detailCell("Frequency", "Monthly", CupertinoIcons.repeat),
                    _detailCell(
                      "Processing Fee",
                      "KES 500",
                      CupertinoIcons.doc_text_viewfinder,
                    ),
                  ],
                ),
                const TableRow(
                  children: [SizedBox(height: 20), SizedBox(height: 20)],
                ),
                TableRow(
                  children: [
                    _detailCell(
                      "Insurance Fee",
                      "KES 150",
                      CupertinoIcons.lock_shield,
                    ),
                    _detailCell(
                      "Excise Duty",
                      "KES 100",
                      CupertinoIcons.briefcase,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- REFINED SUB-COMPONENTS ---
  Widget _detailCell(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF17C6C6)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 8,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF0A2351),
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCircularIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 18, color: color),
    );
  }

  // --- 3. REQUIREMENTS LIST ---
  Widget _buildRequirementsList() {
    final reqs = [
      {
        'title': 'Identity Verification',
        'subtitle': 'National ID & Selfie',
        'status': 'Verified',
        'isDone': true,
        'icon': CupertinoIcons.person_crop_circle_fill,
      },
      {
        'title': 'Eligibility Check',
        'subtitle': 'Credit score & history',
        'status': 'Cleared',
        'isDone': true,
        'icon': CupertinoIcons.gauge,
      },
      {
        'title': 'Bank Statements',
        'subtitle': 'Last 3 months (PDF)',
        'status': 'Under Review',
        'isDone': false,
        'isPending': true,
        'icon': CupertinoIcons.doc_text_search,
      },
      {
        'title': 'Guarantor Approval',
        'subtitle': '2 guarantors required',
        'status': '1/2 Approved',
        'isDone': false,
        'icon': CupertinoIcons.drop_fill,
      },
      {
        'title': 'Assets & Chattels',
        'subtitle': 'Logbook or Household items',
        'status': 'Action Required',
        'isDone': false,
        'icon': CupertinoIcons.cube_box_fill,
      },
      {
        'title': 'Legal Agreement',
        'subtitle': 'Sign loan contract',
        'status': 'Locked',
        'isDone': false,
        'icon': CupertinoIcons.signature,
      },
    ];

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final req = reqs[index];
          bool isDone = req['isDone'] as bool;
          bool isPending = (req['isDone'] as bool?) ?? false;

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDone
                  ? Colors.white.withValues(alpha: 0.5)
                  : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDone ? Colors.transparent : const Color(0xFFF1F4F8),
                width: 1.5,
              ),
              boxShadow: [
                if (!isDone)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
              ],
            ),
            child: Row(
              children: [
                // 1. DYNAMIC ICON HOUSING
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _getRequirementColor(
                      isDone,
                      isPending,
                    ).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isDone
                        ? CupertinoIcons.checkmark_circle_fill
                        : req['icon'] as IconData,
                    size: 20,
                    color: _getRequirementColor(isDone, isPending),
                  ),
                ),
                const SizedBox(width: 18),

                // 2. TEXT CONTENT
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        req['title'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                          color: isDone ? Colors.grey : const Color(0xFF0A2351),
                          decoration: isDone
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        req['subtitle'] as String,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // 3. STATUS BADGE
                _buildMiniStatus(req['status'] as String, isDone, isPending),

                if (!isDone && !isPending)
                  const Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: Icon(
                      CupertinoIcons.chevron_right,
                      size: 14,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
          );
        }, childCount: reqs.length),
      ),
    );
  }

  // --- HELPER LOGIC ---

  Color _getRequirementColor(bool isDone, bool isPending) {
    if (isDone) return const Color(0xFF17C6C6); // Anansi Teal
    if (isPending) return const Color(0xFFFFB300); // Amber
    return const Color(0xFF0A2351); // Navy
  }

  Widget _buildMiniStatus(String status, bool isDone, bool isPending) {
    Color color = _getRequirementColor(isDone, isPending);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 8,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildContinuationDock() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0A2351),
          minimumSize: const Size(double.infinity, 64),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          "CONTINUE APPLICATION",
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        color: Colors.blueGrey.shade800,
        fontWeight: FontWeight.w900,
        fontSize: 11,
        letterSpacing: 1.2,
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
            "Loan Application Details",
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
                "EMERGENCY FUND LOAN",
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
}

import 'package:app_anansi_mobile/helpers/format_amount.dart';
import 'package:app_anansi_mobile/pages/help&support/help_support.dart';
import 'package:app_anansi_mobile/services/error_service.dart';
import 'package:app_anansi_mobile/services/loan_application_service.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoanApplication extends StatefulWidget {
  final String appId;
  const LoanApplication({super.key, required this.appId});

  @override
  State<LoanApplication> createState() => _LoanApplicationState();
}

class _LoanApplicationState extends State<LoanApplication> {
  Map<String, dynamic> application = {};
  bool _isLoading = false;

  Future<void> getLoanApplication() async {
    _isLoading = true;
    try {
      final (response, errors) = await LoanApplicationService()
          .listLoanApplication(appId: widget.appId);
      if (errors != null) {
        ErrorService.showActionableError(
          context,
          title: errors[0],
          message: errors[1],
        );
      } else if (response != null) {
        final responseInfo = response.data['data'];
        setState(() {
          application = responseInfo ?? {};
        });
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    getLoanApplication();
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
            child: _isLoading
                ? _buildApplicationStatusHeaderSkeleton()
                : _buildApplicationStatusHeader(),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: _sectionTitle("Potential Terms"),
            ),
          ),
          SliverToBoxAdapter(
            child: _isLoading
                ? _buildPotentialParametersSkeleton()
                : _buildPotentialParameters(),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 8),
              child: _sectionTitle("Application Checklist"),
            ),
          ),
          _buildRequirementsList(application['progress']?['steps']),
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
                          Text(
                            application['application_number'] ?? "",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      _buildPremiumStatusBadge(
                        application['current_stage_label'] ?? "Pending",
                        const Color(0xFFFFB300),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    "LOAN AMOUNT",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    formatAmount(application['applied_amount'] ?? 0),
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

  Widget _buildApplicationStatusHeaderSkeleton() {
    final skeletonColor = Colors.white.withValues(alpha: 0.12);

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
            // Background design layer
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
                  // 1. TOP BAR SKELETON
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
                          const SizedBox(height: 4),
                          // ID string replacement box
                          Container(
                            width: 85,
                            height: 12,
                            decoration: BoxDecoration(
                              color: skeletonColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                      // Badge replacement box
                      Container(
                        width: 75,
                        height: 24,
                        decoration: BoxDecoration(
                          color: skeletonColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    "LOAN AMOUNT",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Huge dynamic loan amount replacement box
                  Container(
                    width: 170,
                    height: 36,
                    decoration: BoxDecoration(
                      color: skeletonColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Divider(color: Colors.white12, height: 1),
                  const SizedBox(height: 20),
                  // Bottom descriptive block loading strings
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: skeletonColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 10,
                              decoration: BoxDecoration(
                                color: skeletonColor,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              width: 140,
                              height: 10,
                              decoration: BoxDecoration(
                                color: skeletonColor,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ],
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
                    Text(
                      application['loan_product']['product_name'] ??
                          "No Product Name",
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
                      "${double.parse(application['loan_product']['interest_rate'].toString()).toStringAsFixed(1)}% / Mo",
                      CupertinoIcons.percent,
                    ),
                    _detailCell(
                      "Loan Period",
                      "${application['loan_period'].toString()} Months",
                      CupertinoIcons.calendar,
                    ),
                  ],
                ),
                const TableRow(
                  children: [SizedBox(height: 20), SizedBox(height: 20)],
                ),
                TableRow(
                  children: [
                    _detailCell(
                      "Frequency",
                      application['loan_interval'] ?? "",
                      CupertinoIcons.repeat,
                    ),
                    _detailCell(
                      "Processing Fee",
                      formatAmount(0),
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
                      formatAmount(0),
                      CupertinoIcons.lock_shield,
                    ),
                    _detailCell(
                      "Excise Duty",
                      formatAmount(0),
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

  Widget _buildPotentialParametersSkeleton() {
    final baseColor = Colors.grey.shade200;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0xFFF1F4F8), width: 1.5),
        ),
        child: Column(
          children: [
            // 1. PRODUCT BRANDING LINE SKELETON
            Row(
              children: [
                // Mock Circular Icon
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: baseColor,
                    shape: BoxShape.circle,
                  ),
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
                    const SizedBox(height: 4),
                    // Mock Product Name String
                    Container(
                      width: 120,
                      height: 14,
                      decoration: BoxDecoration(
                        color: baseColor,
                        borderRadius: BorderRadius.circular(4),
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

            // 2. DATA GRID SKELETON (2x3 Layout)
            Table(
              children: [
                TableRow(
                  children: [
                    _buildDetailCellSkeleton(baseColor),
                    _buildDetailCellSkeleton(baseColor),
                  ],
                ),
                const TableRow(
                  children: [SizedBox(height: 20), SizedBox(height: 20)],
                ),
                TableRow(
                  children: [
                    _buildDetailCellSkeleton(baseColor),
                    _buildDetailCellSkeleton(baseColor),
                  ],
                ),
                const TableRow(
                  children: [SizedBox(height: 20), SizedBox(height: 20)],
                ),
                TableRow(
                  children: [
                    _buildDetailCellSkeleton(baseColor),
                    _buildDetailCellSkeleton(baseColor),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // HELPER TO SHAPE EACH DATA CELL INSIDE THE TABLE GRID
  Widget _buildDetailCellSkeleton(Color baseColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Mock icon footprint
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(color: baseColor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mock Label Line (e.g. "Interest Rate")
            Container(
              width: 60,
              height: 9,
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 5),
            // Mock Value Line (e.g. "12.0% / Mo")
            Container(
              width: 80,
              height: 12,
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ],
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
  // 1. FIXED: Made the list nullable (?) so it doesn't crash at the method gate
  Widget _buildRequirementsList(List<dynamic>? dynamicRequirements) {
    // 2. FIXED: If loading or data is missing entirely, show the skeleton safely
    if (_isLoading || dynamicRequirements == null) {
      return _buildRequirementsSkeleton();
    }

    // 3. LOADED BUT NO DATA -> SHOW EMPTY UI
    if (dynamicRequirements.isEmpty) {
      return _buildRequirementsEmptyState();
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          // 4. FIXED: Changed cast to loose 'Map' to prevent '_Map<dynamic, dynamic>' runtime TypeErrors
          final req = dynamicRequirements[index] as Map;

          // 5. DYNAMIC STATUS LOGIC BASED ON YOUR DATA
          final String rawStatus = req['status']?.toString() ?? 'pending';
          final bool isDone = [
            'completed',
            'done',
            'verified',
            'cleared',
            'skipped',
          ].contains(rawStatus);
          final bool isPending = [
            'pending',
            'under_review',
            'processing',
          ].contains(rawStatus);

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDone
                  ? Colors.white.withValues(alpha: 0.5)
                  : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFF1F4F8), width: 1),
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
                // DYNAMIC ICON HOUSING
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
                        : _getIconForStage(
                            (req['stage'] ?? req['key'] ?? '').toString(),
                          ),
                    size: 20,
                    color: _getRequirementColor(isDone, isPending),
                  ),
                ),
                const SizedBox(width: 18),

                // TEXT CONTENT
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        req['label']?.toString() ?? 'Requirement',
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
                        req['summary']?.toString() ?? '',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // STATUS BADGE
                _buildMiniStatus(
                  _formatStatusText(rawStatus),
                  isDone,
                  isPending,
                ),

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
        }, childCount: dynamicRequirements.length),
      ),
    );
  }

  Widget _buildRequirementsEmptyState() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFF1F4F8), width: 1.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F4F8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  CupertinoIcons.doc_plaintext,
                  size: 32,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "No Requirements Found",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: Color(0xFF0A2351),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "There are no verification steps or history available for this loan profile.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequirementsSkeleton() {
    final baseColor = Colors.grey.shade200;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFF1F4F8), width: 1.5),
            ),
            child: Row(
              children: [
                // Circular Icon Placeholder
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: baseColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 18),

                // Text Blocks Placeholders
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title skeleton line
                      Container(
                        width: 140,
                        height: 14,
                        decoration: BoxDecoration(
                          color: baseColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Subtitle skeleton line
                      Container(
                        width: 200,
                        height: 10,
                        decoration: BoxDecoration(
                          color: baseColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),

                // Status Badge Placeholder
                Container(
                  width: 65,
                  height: 22,
                  decoration: BoxDecoration(
                    color: baseColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
          );
        }, childCount: 6), // Forces exactly 6 items
      ),
    );
  }

  // 2. HELPER TO MATCH YOUR BACKEND KEYS TO CUPERTINO ICONS
  IconData _getIconForStage(String stage) {
    switch (stage.toLowerCase()) {
      case 'identity':
      case 'verification':
        return CupertinoIcons.person_crop_circle_fill;
      case 'eligibility':
        return CupertinoIcons.gauge;
      case 'loan_details':
        return CupertinoIcons.doc;
      case 'documents':
      case 'bank_statements':
        return CupertinoIcons.doc_text_search;
      case 'guarantor':
        return CupertinoIcons.drop_fill;
      case 'assets':
      case 'chattels':
        return CupertinoIcons.cube_box_fill;
      case 'legal':
      case 'agreement':
        return CupertinoIcons.signature;
      default:
        return CupertinoIcons.doc; // Fallback icon
    }
  }

  // 3. HELPER TO CLEAN UP SNAKE_CASE STATUS STRINGS FOR THE UI BADGE
  String _formatStatusText(String status) {
    if (status.isEmpty) return '';
    return status
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
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

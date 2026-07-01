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

  Color _getBadgeColor(String stage) {
    switch (stage.toLowerCase().trim()) {
      // SUCCESS / ACTIVE STATES (Vibrant Greens)
      case 'approved':
      case 'cleared':
      case 'verified':
      case 'completed':
      case 'disbursed':
      case 'active':
        return const Color(0xFF10B981); // Emerald Green

      // PROCESSING / WAITING STATES (Warm Ambers)
      case 'pending':
      case 'pending committee approval':
      case 'pending manager approval':
      case 'manager review':
      case 'under_review':
      case 'processing':
      case 'submitted':
        return const Color(0xFFFFB300); // Premium Amber/Gold

      // USER INTERVENTION STATES (Vivid Oranges)
      case 'action_required':
      case 'correction':
      case '1/2 approved': // From your guarantor list pattern
        return const Color(0xFFF97316); // Warning Orange

      // TERMINATED / NEGATIVE STATES (Alert Reds)
      case 'rejected':
      case 'declined':
      case 'cancelled':
      case 'failed':
        return const Color(0xFFEF4444); // Rose Crimson

      // MUTED / INACTIVE STATES (Slate Grays)
      case 'locked':
      case 'skipped':
      case 'draft':
      default:
        return const Color(0xFF64748B); // Slate Neutral
    }
  }

  @override
  void initState() {
    super.initState();
    getLoanApplication();
  }

  @override
  Widget build(BuildContext context) {
    final String currentStage =
        (application['current_stage_label'] ?? "Pending").toLowerCase().trim();
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
                ? _buildApplicationActionsSkeleton()
                : _buildApplicationActions(),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 8),
              child: _sectionTitle("Application Milestone"),
            ),
          ),
          _buildRequirementsList(application['progress']?['steps']),
          const SliverPadding(padding: EdgeInsets.only(bottom: 140)),
        ],
      ),
      bottomSheet: _buildContinuationDock(currentStage),
    );
  }

  Widget _buildApplicationActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // GUARANTORS ACTION CARD
          _buildActionCard(
            title: "Guarantors Management",
            subtitle: "Add or check status of your 2 required guarantors",
            icon: CupertinoIcons.person_3_fill,
            iconBgColor: const Color(0xFFEFF6FF),
            iconColor: const Color(0xFF2563EB), // Blue
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) => ApplicationGuarantors(appId: widget.appId)));
            },
          ),
          const SizedBox(height: 14),

          // COLLATERALS ACTION CARD
          _buildActionCard(
            title: "Assets & Collateral",
            subtitle:
                "Submit or update your vehicle logbook or household items",
            icon: CupertinoIcons.cube_box_fill,
            iconBgColor: const Color(0xFFFDF2F8),
            iconColor: const Color(0xFFDB2777), // Pink/Crimson
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) => ApplicationCollaterals(appId: widget.appId)));
            },
          ),
          const SizedBox(height: 14),

          // DOCUMENTS ACTION CARD
          _buildActionCard(
            title: "Supportive Documents",
            subtitle: "Upload your latest 3 months bank statements (PDF)",
            icon: CupertinoIcons.doc_on_doc_fill,
            iconBgColor: const Color(0xFFECFDF5),
            iconColor: const Color(0xFF059669), // Emerald Green
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) => ApplicationDocuments(appId: widget.appId)));
            },
          ),
        ],
      ),
    );
  }

  // 2. DYNAMIC BLUEPRINT FOR INDIVIDUAL ACTION CARDS
  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.015),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          splashColor: iconColor.withValues(alpha: 0.04),
          highlightColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Left: Feature Icon housing Wrapper
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 16),

                // Center: Descriptive Labels text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                          color: AnansiColors.darkBlue,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Right: Navigation Chevron Arrow Indicator
                const Icon(
                  CupertinoIcons.chevron_right,
                  size: 14,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 3. ACTIONS LIST SKELETON LOADER
  Widget _buildApplicationActionsSkeleton() {
    final baseColor = Colors.grey.shade200;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: List.generate(3, (index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
            ),
            child: Row(
              children: [
                // Circle Icon loader box
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: baseColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 16),

                // Multi line text line templates
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 140,
                        height: 14,
                        decoration: BoxDecoration(
                          color: baseColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        height: 10,
                        decoration: BoxDecoration(
                          color: baseColor,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // Arrow right container template
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: baseColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // --- 1. THE STATUS HEADER ---
  Widget _buildApplicationStatusHeader() {
    final String currentStage = application['current_stage_label'] ?? "Pending";

    // SAFE PARSING FOR INTEREST RATE (Prevents FormatException crashes)
    final double interestValue =
        double.tryParse(
          application['loan_product']?['interest_rate']?.toString() ?? '0',
        ) ??
        0.0;

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
                            application['application_number'] ?? "N/A",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      _buildPremiumStatusBadge(
                        currentStage,
                        _getBadgeColor(currentStage),
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
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Divider(color: Colors.white12, height: 1),
                  const SizedBox(height: 20),

                  // 2. FIXED SECURE SPLIT GRID ROW
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        // TENURE COLUMN
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "TENURE",
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.4),
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.1,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${application['loan_period'] ?? 0} Mos",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // VERTICAL BORDER ONE
                        Container(
                          width: 1,
                          margin: const EdgeInsets.symmetric(vertical: 2),
                          color: Colors.white.withValues(alpha: 0.12),
                        ),
                        const SizedBox(width: 16),

                        // INTEREST RATE COLUMN
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "INTEREST RATE",
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.4),
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.1,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${interestValue.toStringAsFixed(1)}% / Mo",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // VERTICAL BORDER TWO
                        Container(
                          width: 1,
                          margin: const EdgeInsets.symmetric(vertical: 2),
                          color: Colors.white.withValues(alpha: 0.12),
                        ),
                        const SizedBox(width: 16),

                        // FREQUENCY COLUMN
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "FREQUENCY",
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.4),
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.1,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                (application['loan_interval'] ?? "Monthly")
                                    .toString()
                                    .toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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

  // --- 3. REQUIREMENTS LIST ---
  Widget _buildRequirementsList(List<dynamic>? dynamicRequirements) {
    if (_isLoading || dynamicRequirements == null) {
      return _buildRequirementsSkeleton();
    }

    if (dynamicRequirements.isEmpty) {
      return _buildRequirementsEmptyState();
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final req = dynamicRequirements[index] as Map;
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

  Widget? _buildContinuationDock(String stage) {
    if (_isLoading || application.isEmpty) return null;

    // 1. Fully Processed / Disbursed Success States
    if (['approved', 'disbursed', 'active', 'completed'].contains(stage)) {
      return Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
        color: Colors.white,
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(
              context,
            ); // Send them back to the active facilities page
          },
          icon: const Icon(
            CupertinoIcons.checkmark_seal_fill,
            color: Colors.white,
            size: 18,
          ),
          label: const Text(
            "VIEW ACTIVE FACILITY",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF10B981), // Emerald Success
            minimumSize: const Size(double.infinity, 64),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      );
    }

    // 2. Read-Only Process States (Pending Internal Team Review Checks)
    if ([
      'pending',
      'under_review',
      'processing',
      'submitted',
      'pending committee approval',
      'pending manager approval',
      'manager review',
    ].contains(stage)) {
      return Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
        color: Colors.white,
        child: ElevatedButton(
          onPressed:
              null, // Setting to null safely disables interactions entirely
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF1F5F9),
            disabledBackgroundColor: const Color(0xFFF1F5F9),
            minimumSize: const Size(double.infinity, 64),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CupertinoActivityIndicator(radius: 7),
              const SizedBox(width: 12),
              Text(
                "APPLICATION UNDER REVIEW",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Colors.grey.shade500,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // 3. User Interventions Needed (Corrections or Missing documents)
    if (['action_required', 'correction'].contains(stage)) {
      return Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
        color: Colors.white,
        child: ElevatedButton.icon(
          onPressed: () {
            // Re-route user back to document upload or guarantor correction flows
          },
          icon: const Icon(
            CupertinoIcons.exclamationmark_triangle_fill,
            color: Colors.white,
            size: 16,
          ),
          label: const Text(
            "RESOLVE REQUIRED ITEMS",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(
              0xFFF97316,
            ), // Attention Warning Orange
            minimumSize: const Size(double.infinity, 64),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      );
    }

    // 4. Closed Negative / Dead States
    if (['rejected', 'declined', 'failed', 'cancelled'].contains(stage)) {
      return null; // Return null to completely strip the bottom sheet from view hierarchy
    }

    // 5. Default Fallback State (Draft Form)
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: ElevatedButton(
        onPressed: () {
          // Normal continuation navigation code execution hook goes here
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0A2351),
          minimumSize: const Size(double.infinity, 64),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          "CONTINUE APPLICATION",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
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
                application['loan_product']['product_name'] ??
                    "No Product Name",
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
}

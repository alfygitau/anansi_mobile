import 'dart:convert';
import 'package:app_anansi_mobile/components/drawer/navigation.dart';
import 'package:app_anansi_mobile/helpers/format_amount.dart';
import 'package:app_anansi_mobile/helpers/format_time.dart';
import 'package:app_anansi_mobile/main.dart';
import 'package:app_anansi_mobile/pages/loan-applications/loan_application.dart';
import 'package:app_anansi_mobile/pages/loan-products/loan_products.dart';
import 'package:app_anansi_mobile/pages/notifications/loan_notifications.dart';
import 'package:app_anansi_mobile/services/error_service.dart';
import 'package:app_anansi_mobile/services/loan_application_service.dart';
import 'package:app_anansi_mobile/services/secure_storage_service.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class LoanApplications extends StatefulWidget {
  const LoanApplications({super.key});

  @override
  State<LoanApplications> createState() => _LoanApplicationsState();
}

class _LoanApplicationsState extends State<LoanApplications> {
  List<Map<String, dynamic>> applications = [];
  ({int active, int cancelled, int inReview, int total}) summary = (
    active: 0,
    cancelled: 0,
    inReview: 0,
    total: 0,
  );
  bool _loading = false;

  Future<Map<String, dynamic>?> getUser() async {
    String? userJson = await SecureStorageService().read('user');
    if (userJson == null) return null;
    Map<String, dynamic> userMap = jsonDecode(userJson);
    return userMap;
  }

  Future<void> getLoanApplications() async {
    _loading = true;
    try {
      final user = await getUser();
      final (response, errors) = await LoanApplicationService()
          .listLoanApplications(customerId: user?['id'] ?? "");
      if (errors != null) {
        ErrorService.showActionableError(
          context,
          title: errors[0],
          message: errors[1],
        );
      } else if (response != null) {
        final responseInfo = response.data['data'];
        setState(() {
          applications = List<Map<String, dynamic>>.from(
            responseInfo['applications'] ?? [],
          );
          summary = getLoanStats(
            List<Map<String, dynamic>>.from(responseInfo['applications'] ?? []),
          );
        });
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _handleNewApplication(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoanProducts()),
    );
  }

  ({int active, int inReview, int cancelled, int total}) getLoanStats(
    List<Map<String, dynamic>> applications,
  ) {
    int active = 0;
    int inReview = 0;
    int cancelled = 0;

    for (final app in applications) {
      final status = (app['status_label'] ?? '')
          .toString()
          .toLowerCase()
          .trim();

      if (status == 'disbursed') {
        active++;
      } else if (status.contains('pending')) {
        inReview++;
      } else if (status.contains('cancel')) {
        cancelled++;
      }
    }
    return (
      active: active,
      inReview: inReview,
      cancelled: cancelled,
      total: applications.length,
    );
  }

  @override
  void initState() {
    super.initState();
    getLoanApplications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.background,
      drawer: Navigation(
        activePageRoute: AnansiRoutes.applications,
        onRouteSelected: (String targetNamedRoute) {
          Navigator.pushNamed(context, targetNamedRoute);
        },
      ),
      body: RefreshIndicator(
        onRefresh: getLoanApplications,
        color: Theme.of(context).primaryColor,
        child: CustomScrollView(
          slivers: [
            _buildAppBar(),
            SliverToBoxAdapter(
              child: _loading
                  ? _buildApplicationSummarySkeleton()
                  : _buildApplicationSummary(),
            ),
            SliverToBoxAdapter(child: _buildApplyLoanAction(context)),
            SliverToBoxAdapter(
              child: _buildSectionHeader("Application History"),
            ),
            _loading
                ? _buildLoanApplicationsSkeleton()
                : applications.isNotEmpty
                ? SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final item = applications[index];
                        return _buildApplicationItem(
                          reference: item['application_number'] ?? "N/A",
                          title:
                              item['product']['product_name'] ??
                              "Loan Application",
                          date: formatPostgresDateWithTime(item['created_at']),
                          amount: formatAmount(item['applied_amount'] ?? 0),
                          status: item['status_label'] ?? "Pending",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    LoanApplication(appId: item['id'] ?? ""),
                              ),
                            );
                          },
                        );
                      }, childCount: applications.length),
                    ),
                  )
                : _buildEmptyState(
                    title: "No Loan Applications",
                    description:
                        "You haven't submitted any loan applications yet. When you apply for a loan, your application progress, approval stages, and status tracking will appear here.",
                    icon: CupertinoIcons
                        .doc_text, // Form/document icon perfect for applications
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required String title,
    required String description,
    required IconData icon,
  }) {
    return SliverFillRemaining(
      hasScrollBody:
          false, // Ensures accurate layout calculation for filling the viewport
      child: Padding(
        // 20 matching padding to perfectly align with your app bars and summary cards
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Container(
          width:
              double.infinity, // Forces complete horizontal alignment stretch
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment
                .center, // Centers your contents vertically in the expanded card space
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Muted Circular Icon Wrapper
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: ThemeColors.background,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFF1F5F9),
                    width: 1.5,
                  ),
                ),
                child: Icon(icon, size: 44, color: Colors.grey.shade400),
              ),
              const SizedBox(height: 24),

              // Description Headers
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AnansiColors.darkBlue,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.blueGrey.shade400,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      floating: true,
      backgroundColor: ThemeColors.background.withValues(alpha: 0.9),
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
          child: Builder(
            builder: (nestedContext) {
              return IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  CupertinoIcons.square_grid_2x2,
                  size: 20,
                  color: AnansiColors.darkBlue,
                ),
                onPressed: () {
                  Scaffold.of(nestedContext).openDrawer();
                },
              );
            },
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
                  CupertinoIcons.bell,
                  size: 18,
                  color: AnansiColors.darkBlue,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoanNotifications(),
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
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFE2E8F0), // Slate 200 border
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Header Row ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Applications",
                style: TextStyle(
                  color: Color(0xFF0F172A), // Slate 900
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9), // Slate 100 pill
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${summary.total} Total",
                  style: const TextStyle(
                    color: Color(0xFF64748B), // Slate 500
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _statTile(
                  label: "Total Applications",
                  value: "${summary.total}",
                  icon: CupertinoIcons.doc_text_fill,
                  accentColor: AnansiColors.primary, // Sapphire Blue
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _statTile(
                  label: "Active",
                  value: "${summary.active}",
                  icon: CupertinoIcons.checkmark_circle_fill,
                  accentColor: const Color(0xFF059669), // Emerald Green
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _statTile(
                  label: "In Review",
                  value: "${summary.inReview}",
                  icon: CupertinoIcons.clock_fill,
                  accentColor: const Color(0xFFD97706), // Amber
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _statTile(
                  label: "Cancelled",
                  value: "${summary.cancelled}",
                  icon: CupertinoIcons.xmark_circle_fill,
                  accentColor: const Color(0xFFDC2626), // Crimson Red
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statTile({
    required String label,
    required String value,
    required IconData icon,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: ThemeColors.background, // Slate 50 light fill
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE2E8F0), // Slate 200
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: accentColor),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF0F172A), // Slate 900
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF64748B), // Slate 500
                    fontSize: 11,
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
                  color: AnansiColors.accentCyan,
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
      case 'disbursed':
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
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: AnansiColors.darkBlue,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
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

Widget _buildLoanApplicationsSkeleton() {
  return SliverPadding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    sliver: SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade200,
            highlightColor: Colors.grey.shade50,
            period: const Duration(milliseconds: 1200),
            child: _buildApplicationSkeletonItem(),
          );
        },
        childCount: 6, // Enforces exactly 6 layout skeletons
      ),
    ),
  );
}

Widget _buildApplicationSkeletonItem() {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
    ),
    child: Row(
      children: [
        // 1. Status Indicator Icon Placeholder
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 16),

        // 2. Main Details Placeholder
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Reference line
              Container(
                width: 70,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 6),
              // Title line
              Container(
                width: 140,
                height: 13,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 6),
              // Date line
              Container(
                width: 90,
                height: 11,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),

        // 3. Amount and Status Badge Placeholder
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Amount line
            Container(
              width: 65,
              height: 13,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8),
            // Status Badge block
            Container(
              width: 60,
              height: 18,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildApplicationSummarySkeleton() {
  const baseColor = Color(0xFFE2E8F0); // Slate 200
  const highlightColor = Color(0xFFF8FAFC); // Slate 50

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Header Row Skeleton ---
        Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Title placeholder
              Container(
                width: 100,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              // Pill badge placeholder
              Container(
                width: 65,
                height: 22,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // --- Row 1 ---
        Row(
          children: [
            Expanded(child: _statTileSkeleton(baseColor, highlightColor)),
            const SizedBox(width: 8),
            Expanded(child: _statTileSkeleton(baseColor, highlightColor)),
          ],
        ),

        const SizedBox(height: 8),

        // --- Row 2 ---
        Row(
          children: [
            Expanded(child: _statTileSkeleton(baseColor, highlightColor)),
            const SizedBox(width: 8),
            Expanded(child: _statTileSkeleton(baseColor, highlightColor)),
          ],
        ),
      ],
    ),
  );
}

Widget _statTileSkeleton(Color baseColor, Color highlightColor) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFFF8FAFC), // Preserves Slate 50 tile background
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFFF1F5F9)),
    ),
    child: Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon circle placeholder
              Container(
                width: 26,
                height: 26,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              // Value number placeholder
              Container(
                width: 28,
                height: 18,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Label placeholder
          Container(
            width: 76,
            height: 10,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    ),
  );
}

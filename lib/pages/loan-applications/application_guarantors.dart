import 'package:app_anansi_mobile/services/error_service.dart';
import 'package:app_anansi_mobile/services/loan_application_service.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shimmer/shimmer.dart';

class ApplicationGuarantors extends StatefulWidget {
  final String appId;

  const ApplicationGuarantors({super.key, required this.appId});

  @override
  State<ApplicationGuarantors> createState() => _ApplicationGuarantorsState();
}

class _ApplicationGuarantorsState extends State<ApplicationGuarantors> {
  List<Map<String, dynamic>> guarantors = [];
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
          guarantors = List<Map<String, dynamic>>.from(
            responseInfo['guarantors'] ?? [],
          );
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
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          _buildAppBar(),
          if (_isLoading)
            _buildGuarantorsSkeleton()
          else if (guarantors.isEmpty)
            SliverFillRemaining(hasScrollBody: false, child: _buildEmptyState())
          else
            _buildSliverGuarantorList(),
        ],
      ),
      bottomNavigationBar: _buildAddButton(),
    );
  }

  // MARK: - Core Sliver App Bar
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
            "Guarantors Management",
            style: TextStyle(
              color: AnansiColors.darkBlue,
              fontWeight: FontWeight.w900,
              fontSize: 15,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            "Guarantors",
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 10,
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
                onPressed: () {}, // Handle Help & Support
              ),
            ),
          ),
        ),
      ],
    );
  }

  // MARK: - Sliver List Wrap
  Widget _buildSliverGuarantorList() {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final guarantor = guarantors[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _buildImprovedGuarantorCard(guarantor),
          );
        }, childCount: guarantors.length),
      ),
    );
  }

  Widget _buildImprovedGuarantorCard(Map<String, dynamic> g) {
    // Extract fields safely
    final String name = g['guarantor_name'] ?? 'Unknown';
    final String mobile = g['guarantor_mobile'] ?? '';
    final String? createdAt = g['created_at'] ?? g['createdAt'];
    final String status = g['status'] ?? 'Pending';

    // Get initial character for avatar
    final String initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    // Dynamic Status Badge Color Scheme (Tailwind Equivalents)
    final bool isApproved = status.toLowerCase() == 'approved';
    final Color badgeBg = isApproved
        ? const Color(0xFFECFDF5)
        : const Color(0xFFFFFBEB); // emerald-50 / amber-50
    final Color badgeText = isApproved
        ? const Color(0xFF059669)
        : const Color(0xFFD97706); // emerald-600 / amber-600
    final Color badgeBorder = isApproved
        ? const Color(0xFFD1FAE5).withValues(alpha: 0.5)
        : const Color(
            0xFFFEF3C7,
          ).withValues(alpha: 0.5); // emerald-100/50 / amber-100/50

    return Container(
      padding: const EdgeInsets.all(16), // p-4
      decoration: BoxDecoration(
        color: Colors.white, // bg-white
        borderRadius: BorderRadius.circular(16), // rounded-2xl
        border: Border.all(color: const Color(0xFFF1F5F9)), // border-slate-100
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.01,
            ), // shadow-[...rgba(0,0,0,0.01)]
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // justify-between
        crossAxisAlignment: CrossAxisAlignment.center, // items-center
        children: [
          // LEFT CONTENT FRAME (flex items-center gap-3 min-w-0)
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // INITIAL AVATAR BOX
                Container(
                  width: 36, // size-9 (9 * 4px)
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC), // bg-slate-50
                    borderRadius: BorderRadius.circular(12), // rounded-xl
                    border: Border.all(
                      color: const Color(0xFFF1F5F9),
                    ), // border-slate-100
                  ),
                  child: Text(
                    initial,
                    style: const TextStyle(
                      color: Color(0xFF0A2351), // text-[#0A2351]
                      fontWeight: FontWeight.bold, // font-bold
                      fontSize: 12, // text-xs
                    ),
                  ),
                ),
                const SizedBox(width: 12), // gap-3 (3 * 4px)
                // TEXT META GROUP (space-y-0.5 min-w-0)
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Guarantor Name
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis, // truncate
                        style: const TextStyle(
                          color: Color(0xFF0F172A), // text-slate-900
                          fontWeight: FontWeight.bold, // font-bold
                          fontSize: 12, // text-xs
                          letterSpacing: -0.2, // tracking-tight
                        ),
                      ),
                      const SizedBox(height: 2), // space-y-0.5
                      // Mobile String
                      Text(
                        mobile,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis, // truncate
                        style: const TextStyle(
                          color: Color(0xFF94A3B8), // text-slate-400
                          fontWeight: FontWeight.w500, // font-semibold
                          fontSize: 9, // text-[9px]
                          letterSpacing: 0.5, // tracking-wider
                        ),
                      ),

                      // Optional Date Stamp
                      if (createdAt != null) ...[
                        const SizedBox(height: 2),
                        RichText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 10, // text-[10px]
                              fontWeight: FontWeight.w500, // font-medium
                              color: Color(0xFF94A3B8), // text-slate-400
                            ),
                            children: [
                              const TextSpan(text: "Date: "),
                              TextSpan(
                                text: createdAt, // Parsed/Formatted date value
                                style: const TextStyle(
                                  color: Color(0xFF64748B), // text-slate-500
                                  fontWeight: FontWeight.w500, // font-semibold
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 12,
          ), // Keeps badge safely spaced apart from text run-outs
          // RIGHT CONTENT FRAME (Status Badge)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 2,
            ), // px-2 py-0.5
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(4), // rounded
              border: Border.all(color: badgeBorder),
            ),
            child: Text(
              status.toUpperCase(), // uppercase
              style: TextStyle(
                color: badgeText,
                fontSize: 8, // text-[8px]
                fontWeight: FontWeight.bold, // font-bold
                letterSpacing: 0.5, // tracking-wider
              ),
            ),
          ),
        ],
      ),
    );
  }

  // MARK: - Empty State
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: Color(0xFFEFF6FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                CupertinoIcons.person_3_fill,
                color: AnansiColors.darkBlue,
                size: 28,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "No Guarantors Added",
              style: TextStyle(
                color: AnansiColors.darkBlue,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Add up to 2 required guarantors to secure this request.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // MARK: - Action Footer Button
  Widget _buildAddButton() {
    final bool isLimitReached = guarantors.length >= 2;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        0,
        24,
        MediaQuery.of(context).padding.bottom,
      ),
      child: ElevatedButton.icon(
        onPressed: isLimitReached ? null : () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AnansiColors.darkBlue,
          disabledBackgroundColor: Colors.grey.shade200,
          foregroundColor: Colors.white,
          disabledForegroundColor: Colors.grey.shade400,
          elevation: 0,
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        icon: const Icon(CupertinoIcons.add, size: 16),
        label: Text(
          isLimitReached ? "Guarantor Limit Met" : "Add New Guarantor",
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildGuarantorsSkeleton() {
    return SliverPadding(
      // Match the 24px padding system used on your guarantor page
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Shimmer.fromColors(
              baseColor: Colors.grey.shade200,
              highlightColor: Colors.grey.shade50,
              period: const Duration(milliseconds: 1200),
              child: _buildGuarantorSkeletonItem(),
            );
          },
          childCount: 8, // Safely simulates typical list capacity placeholders
        ),
      ),
    );
  }

  Widget _buildGuarantorSkeletonItem() {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 14,
      ), // Matches item gaps in active list
      padding: const EdgeInsets.all(16), // Match p-4
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16), // Match rounded-2xl
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // LEFT CONTENT FRAME (Avatar + Info Strings)
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 1. Initial Avatar Placeholder (size-9)
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12), // Match rounded-xl
                  ),
                ),
                const SizedBox(width: 12), // Match gap-3
                // 2. Text Metadata Group (space-y-0.5)
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name block (text-xs)
                      Container(
                        width: 130,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 5),

                      // Mobile block (text-[9px])
                      Container(
                        width: 80,
                        height: 9,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(height: 5),

                      // Date block (text-[10px])
                      Container(
                        width: 105,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // 3. Right Status Badge Placeholder
          Container(
            width: 54, // Matches target badge dimensions
            height: 16,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4), // Match rounded
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:app_anansi_mobile/helpers/format_amount.dart';
import 'package:app_anansi_mobile/pages/apply-loan/add_collateral.dart';
import 'package:app_anansi_mobile/pages/apply-loan/loan_terms_conditions.dart';
import 'package:app_anansi_mobile/pages/help&support/help_support.dart';
import 'package:app_anansi_mobile/services/error_service.dart';
import 'package:app_anansi_mobile/services/loan_application_service.dart';
import 'package:app_anansi_mobile/services/loan_products_service.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Collaterals extends StatefulWidget {
  final String appId;
  final String productId;
  const Collaterals({super.key, required this.appId, required this.productId});

  @override
  State<Collaterals> createState() => _CollateralsState();
}

class _CollateralsState extends State<Collaterals> {
  List<Map<String, dynamic>> collaterals = [];
  Map<String, dynamic> loanProduct = {};
  bool isFetching = false;
  bool isLoading = false;
  bool isDeleting = false;

  Future<void> fetchCollaterals() async {
    try {
      isFetching = true;
      final (response, errors) = await LoanApplicationService().fetchChattels(
        applicationId: widget.appId,
      );
      if (errors != null) {
        ErrorService.showActionableError(
          context,
          title: errors[0],
          message: errors[1],
        );
      } else if (response != null) {
        final responseInfo = response.data['data'];
        setState(() {
          collaterals = List<Map<String, dynamic>>.from(responseInfo ?? []);
        });
      }
    } finally {
      if (mounted) setState(() => isFetching = false);
    }
  }

  Future<void> deleteChattel(String chattelId) async {
    try {
      isDeleting = true;
      final (response, errors) = await LoanApplicationService().removeChattel(
        applicationId: widget.appId,
        chattelId: chattelId,
      );
      if (errors != null) {
        ErrorService.showActionableError(
          context,
          title: errors[0],
          message: errors[1],
        );
      } else if (response != null) {
        if (mounted) {
          fetchCollaterals();
          Navigator.of(context).pop();
        }
      }
    } finally {
      if (mounted) setState(() => isDeleting = false);
    }
  }

  Future<void> getLoanProduct() async {
    isLoading = true;
    try {
      final (response, errors) = await LoanProductsService().listLoanProduct(
        productId: widget.productId,
      );
      if (errors != null) {
        ErrorService.showActionableError(
          context,
          title: errors[0],
          message: errors[1],
        );
      } else if (response != null) {
        final responseInfo = response.data['data'];
        setState(() {
          loanProduct = responseInfo ?? {};
        });
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCollaterals();
    getLoanProduct();
  }

  @override
  Widget build(BuildContext context) {
    final items = collaterals;
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          _buildPageDescription(),
          SliverToBoxAdapter(child: _buildApplyLoanAction(context)),
          isFetching
              ? _buildShimmerLoading()
              : items.isEmpty
              ? _buildEmptyState()
              : SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          _buildCollateralItemCard(items[index]),
                      childCount: items.length,
                    ),
                  ),
                ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      bottomNavigationBar: _buildBottomAction(context),
    );
  }

  void _showCollateralActionsBottomSheet(
    BuildContext context,
    Map<String, dynamic> item, {
    required VoidCallback onView,
    required Future<void> Function() onDelete,
  }) {
    const Color primaryColor = Color(0xFF074073);
    final String status = item['status']?.toString() ?? "Pending";
    final bool isEditable =
        status.toLowerCase().trim() == "pending" ||
        status.toLowerCase().trim() == "draft";

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      elevation: 0,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        // Declared outside inner builder function scope so state changes persist across frames
        bool isRemoving = false;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setSheetState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 14, 24, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- THE PULL INDICATOR CHASSIS ---
                    Center(
                      child: Container(
                        width: 38,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2E8F0), // Clean gray tint
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // --- CONTEXT SYNOPSIS BLOCK ---
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFF1F5F9)),
                      ),
                      child: Row(
                        children: [
                          // Recycled category thumbnail space
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFE2E8F0),
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                _getCategoryIcon(item['asset_category'] ?? ""),
                                color: primaryColor.withValues(alpha: 0.6),
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['asset_name'] ?? "Asset Item",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14,
                                    color: primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  (item['asset_category'] ?? "N/A")
                                      .toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.blueGrey.shade300,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 9,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            formatAmount(item['estimated_value'] ?? 0),
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1E3A8A),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 1. VIEW ACTION ITEM
                    InkWell(
                      onTap: isRemoving
                          ? null // Block interaction if deletion is in progress
                          : () {
                              Navigator.pop(context); // Dismiss sheet first
                              onView();
                            },
                      borderRadius: BorderRadius.circular(16),
                      child: Opacity(
                        opacity: isRemoving ? 0.45 : 1.0,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: primaryColor.withValues(alpha: 0.05),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  CupertinoIcons.eye_fill,
                                  color: primaryColor,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "View Asset",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      "Inspect current imagery data and uploaded files",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                CupertinoIcons.chevron_right,
                                size: 14,
                                color: Color(0xFFCBD5E1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.0),
                      child: Divider(color: Color(0xFFF1F5F9), height: 1),
                    ),
                    InkWell(
                      onTap: (!isEditable || isRemoving)
                          ? null
                          : () async {
                              setSheetState(() => isRemoving = true);
                              await onDelete();
                              if (context.mounted) {
                                setSheetState(() => isRemoving = false);
                              }
                            },
                      borderRadius: BorderRadius.circular(16),
                      child: Opacity(
                        opacity: (isEditable && !isRemoving)
                            ? 1.0
                            : 0.45, // Gray out row if un-editable or executing
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: isEditable
                                      ? Colors.redAccent.withValues(alpha: 0.08)
                                      : Colors.grey.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: isRemoving
                                    ? const Center(
                                        child: SizedBox(
                                          width: 14,
                                          height: 14,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.0,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.redAccent,
                                                ),
                                          ),
                                        ),
                                      )
                                    : Icon(
                                        isEditable
                                            ? CupertinoIcons.trash_fill
                                            : CupertinoIcons.lock_fill,
                                        color: isEditable
                                            ? Colors.redAccent
                                            : Colors.grey.shade600,
                                        size: 16,
                                      ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isRemoving
                                          ? "Removing Asset..."
                                          : "Remove from Application",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 14,
                                        color: isEditable
                                            ? Colors.redAccent
                                            : Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      isRemoving
                                          ? "Disconnecting asset from records..."
                                          : (isEditable
                                                ? "Permanently unbind this chattel parameter entry"
                                                : "Cannot remove items currently locked under audit review"),
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isEditable && !isRemoving)
                                const Icon(
                                  CupertinoIcons.chevron_right,
                                  size: 14,
                                  color: Color(0xFFCBD5E1),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Ensure all physical assets are documented.",
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      LoanTermsConditions(appId: widget.appId),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AnansiColors.darkBlue,
              minimumSize: const Size(double.infinity, 56),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Continue Application",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: 8),
                Icon(CupertinoIcons.arrow_right, color: Colors.white, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageDescription() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Asset Inventory",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: AnansiColors.darkBlue,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Manage your pledged chattels and documentation to maintain your credit health.",
              style: TextStyle(
                fontSize: 15,
                color: Colors.blueGrey.shade400,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplyLoanAction(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddCollateral(
                appId: widget.appId,
                productId: widget.productId,
              ),
            ),
          );
        },
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
                      "Add a new collateral",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: AnansiColors.darkBlue,
                      ),
                    ),
                    Text(
                      "Excellent way to guarantee your loan",
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

  Widget _buildEmptyState() {
    return SliverFillRemaining(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(CupertinoIcons.cube_box, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            "No Collateral Added",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AnansiColors.darkBlue,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "Add your assets like electronics or motor vehicles to increase your loan limit.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'verified':
        bgColor = Colors.green.withValues(alpha: 0.1);
        textColor = Colors.green.shade700;
        break;
      case 'pending':
        bgColor = Colors.orange.withValues(alpha: 0.1);
        textColor = Colors.orange.shade800;
        break;
      default:
        bgColor = Colors.grey.withValues(alpha: 0.1);
        textColor = Colors.grey.shade600;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w800,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
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
            "Loan Application",
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
                "CHATTELS",
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

  // The skeleton loop context handler
  Widget _buildShimmerLoading() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Shimmer.fromColors(
              baseColor: Colors.grey.shade200,
              highlightColor: Colors.grey.shade50,
              period: const Duration(milliseconds: 1200),
              child: _buildSkeletonCollateralCard(),
            );
          },
          childCount: 6, // Enforces exactly 6 layout skeletons
        ),
      ),
    );
  }

  // The isolated structural placeholder card
  Widget _buildSkeletonCollateralCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1),
      ),
      child: Row(
        children: [
          // LEFT: Thumbnail Box Skeleton
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(width: 16),

          // MIDDLE: Asset Details Stack Skeletons
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Asset Name Placeholder
                Container(
                  width: 140,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                // Asset Category Placeholder
                Container(
                  width: 70,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 12),
                // Estimated Value Placeholder
                Container(
                  width: 90,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),

          // RIGHT: Status Badge & Metadata Column Skeletons
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Status Badge Placeholder
              Container(
                width: 65,
                height: 22,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              const SizedBox(height: 16),
              // Document / Chevron Placeholder
              Container(
                width: 35,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCollateralItemCard(dynamic item) {
    final List<dynamic> imageUrls = item['image_urls'] ?? [];
    final String? imageUrl = imageUrls.isNotEmpty
        ? imageUrls[0].toString()
        : null;
    return GestureDetector(
      onTap: () => _showCollateralActionsBottomSheet(
        context,
        item,
        onView: () {},
        onDelete: () async {
          final String chattelId = item['id']?.toString() ?? "";
          await deleteChattel(chattelId);
        },
      ),
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(color: const Color(0xFFF1F5F9), width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(
                  0xFFF1F5F9,
                ), // Slate-100 placeholder background
                borderRadius: BorderRadius.circular(16),
              ),
              child: imageUrl == null || imageUrl.trim().isEmpty
                  ? _buildDefaultCategoryIcon(item['asset_category'] ?? "")
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        // FALLBACK: Triggers if the S3 URL is broken, expired, or returns a 404
                        errorBuilder: (context, error, stackTrace) =>
                            _buildDefaultCategoryIcon(
                              item['asset_category'] ?? "",
                            ),

                        // PROGRESSIVE: Shows a micro-spinner while downloading the asset file
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AnansiColors.darkBlue,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['asset_name'] ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: AnansiColors.darkBlue,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item['asset_category'] ?? "N/A".toUpperCase(),
                    style: TextStyle(
                      color: Colors.blueGrey.shade300,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formatAmount(item['estimated_value'] ?? 0),
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1E3A8A),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildStatusBadge(item['status'] ?? "Pending"),
                const SizedBox(height: 12),
                if (item['doc_urls']?.isNotEmpty)
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.doc_text,
                        size: 12,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${item['doc_urls'].length} Docs",
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                else
                  const Icon(
                    CupertinoIcons.chevron_right,
                    size: 14,
                    color: Color(0xFFCBD5E1),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultCategoryIcon(String assetCategory) {
    return Center(
      child: Icon(
        _getCategoryIcon(assetCategory),
        color: AnansiColors.darkBlue.withValues(alpha: 0.35),
        size: 24,
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'motor vehicle':
        return CupertinoIcons.car_detailed;
      case 'electronics':
        return CupertinoIcons.device_laptop;
      case 'appliances':
        return CupertinoIcons.settings;
      default:
        return CupertinoIcons.cube_box;
    }
  }
}

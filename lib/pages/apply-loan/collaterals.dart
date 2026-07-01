import 'dart:io';
import 'package:app_anansi_mobile/models/collateral.dart';
import 'package:app_anansi_mobile/pages/apply-loan/add_collateral.dart';
import 'package:app_anansi_mobile/pages/apply-loan/loan_terms_conditions.dart';
import 'package:app_anansi_mobile/pages/help&support/help_support.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Collaterals extends StatefulWidget {
  final String appId;
  final String productId;
  const Collaterals({super.key, required this.appId, required this.productId});

  @override
  State<Collaterals> createState() => _CollateralsState();
}

class _CollateralsState extends State<Collaterals> {
  final List<Collateral> staticCollateralItems = [
    Collateral(
      name: "Samsung 55' UHD Smart TV",
      category: "Electronics",
      value: "85,000",
      images: [],
      documents: ["receipt.pdf"],
      status: "Verified",
    ),
    Collateral(
      name: "Toyota Passo (KDL 123X)",
      category: "Motor Vehicle",
      value: "850,000",
      images: [],
      documents: ["logbook.pdf", "insurance.pdf"],
      status: "Pending",
    ),
    Collateral(
      name: "Double Door Fridge",
      category: "Appliances",
      value: "45,000",
      images: [],
      documents: [],
      status: "Rejected",
    ),
  ];
  @override
  Widget build(BuildContext context) {
    final items = staticCollateralItems;
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          _buildPageDescription(),
          SliverToBoxAdapter(child: _buildApplyLoanAction(context)),
          items.isEmpty
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
            MaterialPageRoute(builder: (context) => const AddCollateral()),
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

  Widget _buildCollateralItemCard(dynamic item) {
    return Container(
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
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16),
              image: item.images.isNotEmpty
                  ? DecorationImage(
                      image: FileImage(File(item.images[0])),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: item.images.isEmpty
                ? Icon(
                    _getCategoryIcon(item.category),
                    color: AnansiColors.darkBlue.withValues(alpha: 0.2),
                    size: 28,
                  )
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
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
                  item.category.toUpperCase(),
                  style: TextStyle(
                    color: Colors.blueGrey.shade300,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "KES ${item.value}",
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
              _buildStatusBadge(item.status ?? "Pending"),
              const SizedBox(height: 12),
              if (item.documents.isNotEmpty)
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.doc_text,
                      size: 12,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${item.documents.length} Docs",
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

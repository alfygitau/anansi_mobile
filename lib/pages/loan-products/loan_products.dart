import 'package:app_anansi_mobile/pages/apply-loan/eligibility.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoanProducts extends StatefulWidget {
  const LoanProducts({super.key});

  @override
  State<LoanProducts> createState() => _LoanProductsState();
}

class _LoanProductsState extends State<LoanProducts> {
  final List<Map<String, dynamic>> loanProducts = [
    {
      "name": "Emergency Loan",
      "icon": CupertinoIcons.bolt_fill,
      "rate": "1.5%",
      "period": "1 Month",
      "color": const Color(0xFFEF4444),
      "description": "Instant funds for urgent needs.",
      "maxAmount": "50,000",
    },
    {
      "name": "Development Loan",
      "icon": CupertinoIcons.house_fill,
      "rate": "12%",
      "period": "36 Months",
      "color": const Color(0xFF3B82F6),
      "description": "Long-term financing for projects.",
      "maxAmount": "2,000,000",
    },
    {
      "name": "Education Loan",
      "icon": CupertinoIcons.book_fill,
      "rate": "10%",
      "period": "12 Months",
      "color": const Color(0xFF10B981),
      "description": "Invest in your future knowledge.",
      "maxAmount": "200,000",
    },
    {
      "name": "Asset Finance",
      "icon": CupertinoIcons.car_detailed,
      "rate": "13.5%",
      "period": "48 Months",
      "color": const Color(0xFF8B5CF6),
      "description": "Acquire vehicles or machinery.",
      "maxAmount": "5,000,000",
    },
    {
      "name": "Salary Advance",
      "icon": CupertinoIcons.money_dollar_circle_fill,
      "rate": "5%",
      "period": "1 Month",
      "color": const Color(0xFFF59E0B),
      "description": "Bridge the gap to your next payday.",
      "maxAmount": "100,000",
    },
    {
      "name": "Agri-Business",
      "icon": CupertinoIcons.clear_fill,
      "rate": "8%",
      "period": "24 Months",
      "color": const Color(0xFF065F46),
      "description": "Boost your farm's productivity.",
      "maxAmount": "1,500,000",
    },
    {
      "name": "Instant Mobile",
      "icon": CupertinoIcons.device_phone_portrait,
      "rate": "10%",
      "period": "2 Weeks",
      "color": const Color(0xFFEC4899),
      "description": "Quick app-based micro-loans.",
      "maxAmount": "15,000",
    },
    {
      "name": "Business Growth",
      "icon": CupertinoIcons.briefcase_fill,
      "rate": "11%",
      "period": "18 Months",
      "color": const Color(0xFF6366F1),
      "description": "Expand your SME operations.",
      "maxAmount": "3,000,000",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: const Color(0xFFF8FAFC).withValues(alpha: 0.9),
            elevation: 0,
            centerTitle: true,
            leadingWidth:
                64, // Added width to give the circled icon breathing room
            title: const Text(
              "Loan Offerings",
              style: TextStyle(
                color: AnansiColors.darkBlue,
                fontWeight: FontWeight.w900,
                fontSize:
                    18, // Slightly adjusted for better balance with circled icons
                letterSpacing: -0.5,
              ),
            ),
            // 1. Circled Back Button
            leading: Center(
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    CupertinoIcons.back,
                    size: 20,
                    color: AnansiColors.darkBlue,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            // 2. Circled Action Button
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        CupertinoIcons.search,
                        size: 20,
                        color: AnansiColors.darkBlue,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text(
                "Select a specialized plan to view eligibility and terms.",
                style: TextStyle(
                  color: Colors.blueGrey.shade400,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final product = loanProducts[index];
                return _buildDetailedLoanCard(
                  context,
                  product,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoanEligibility(),
                      ),
                    );
                  },
                );
              }, childCount: loanProducts.length),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedLoanCard(
    BuildContext context,
    Map<String, dynamic> product, {
    required VoidCallback onTap,
  }) {
    final Color baseColor = product['color'];

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: baseColor.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: baseColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(product['icon'], color: baseColor, size: 28),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        "${product['rate']} p.a",
                        style: const TextStyle(
                          color: AnansiColors.darkBlue,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Name and Description
                Text(
                  product['name'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: AnansiColors.darkBlue,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  product['description'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blueGrey.shade400,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),

                // Details Grid
                Row(
                  children: [
                    _buildInfoColumn(
                      "MAX AMOUNT",
                      "KES ${product['maxAmount']}",
                    ),
                    const Spacer(),
                    _buildInfoColumn("TENURE", product['period']),
                    const Spacer(),
                    _buildInfoColumn("REPAYMENT", "Monthly"),
                  ],
                ),
              ],
            ),
          ),

          // Bottom Action Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(32),
              ),
              border: Border(top: BorderSide(color: Colors.grey.shade100)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Terms & Conditions apply",
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AnansiColors.darkBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Apply Now",
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w800,
            color: Colors.blueGrey.shade200,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: AnansiColors.darkBlue,
          ),
        ),
      ],
    );
  }
}

import 'package:app_anansi_mobile/main.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ⚡ Unified Type Definition for Application Page Routes

class Navigation extends StatefulWidget {
  final String activePageRoute;
  final Function(String namedRoute) onRouteSelected;

  const Navigation({
    super.key,
    required this.activePageRoute,
    required this.onRouteSelected,
  });

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  @override
  Widget build(BuildContext context) {
    final double topSafeArea = MediaQuery.of(context).padding.top;
    final double bottomSafeArea = MediaQuery.of(context).padding.bottom;

    return Drawer(
      backgroundColor: Colors.white,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // ====== HEADER LAYER BLOCK ======
          Padding(
            padding: EdgeInsets.fromLTRB(20, topSafeArea + 20, 20, 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AnansiColors.darkBlue,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        CupertinoIcons.shield_fill,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "ANANSI SACCO",
                            style: TextStyle(
                              color: AnansiColors.darkBlue,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.8,
                            ),
                          ),
                          Text(
                            "Financial Prosperity Hub",
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
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
          // ====== MAIN NAVIGATION LIST LINKS ======
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 12, top: 14, bottom: 8),
                    child: Text(
                      "FINANCIAL CORE",
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF94A3B8),
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  _buildDrawerItem(
                    title: "Homepage",
                    icon: CupertinoIcons.house,
                    targetPageRoute:
                        AnansiRoutes.dashboard, // ⚡ Updated mapping logic
                  ),
                  _buildDrawerItem(
                    title: "Loan Applications",
                    icon: CupertinoIcons
                        .doc_text_viewfinder, // Modern application tracking look
                    targetPageRoute:
                        AnansiRoutes.applications, // Updated from savings route
                  ),
                  _buildDrawerItem(
                    title: "Loan Facilities",
                    icon: CupertinoIcons
                        .briefcase, // Institutional asset/facility portfolio
                    targetPageRoute: AnansiRoutes.loans,
                  ),
                  _buildDrawerItem(
                    title: "Account Statements",
                    icon: CupertinoIcons
                        .creditcard, // Matches standard accounts/savings ledger tracking
                    targetPageRoute: AnansiRoutes.statements,
                  ),
                  _buildDrawerItem(
                    title: "Loan Statements",
                    icon: CupertinoIcons
                        .doc_plaintext, // Differentiates from regular statements icon
                    targetPageRoute: AnansiRoutes
                        .loanstatements, // Points to statements page logic
                  ),
                  _buildDrawerItem(
                    title: "Loan Products",
                    icon: CupertinoIcons
                        .square_grid_2x2, // Grid layout representation for product cataloging
                    targetPageRoute: AnansiRoutes.products,
                  ),

                  const Padding(
                    padding: EdgeInsets.only(left: 12, top: 24, bottom: 8),
                    child: Text(
                      "MEMBERSHIP OPERATIONS",
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF94A3B8),
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  _buildDrawerItem(
                    title: "Guarantorship",
                    icon: CupertinoIcons.group,
                    targetPageRoute: AnansiRoutes.guarantorship,
                  ),
                  _buildDrawerItem(
                    title: "Settings",
                    icon: CupertinoIcons.settings,
                    targetPageRoute: AnansiRoutes.settings,
                  ),
                  _buildDrawerItem(
                    title: "Profile",
                    icon: CupertinoIcons.settings,
                    targetPageRoute: AnansiRoutes.profile,
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 16 + bottomSafeArea),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(24)),
            ),
            child: InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                // Execute core security session teardown logic here
              },
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 12,
                ),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.start, // Left-aligned layout mapping
                  children: [
                    const Icon(
                      CupertinoIcons.power,
                      color: Color(
                        0xFFEF4444,
                      ), // Clear signature warning red icon
                      size: 18,
                    ),
                    const SizedBox(
                      width: 12,
                    ), // Strict proportional tracking gap spacer
                    const Text(
                      "LOGOUT",
                      style: TextStyle(
                        color: Color(
                          0xFFEF4444,
                        ), // Clean flat red typography execution
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ====== DRAWER SELECTION ROUTE ITEM LINK ======
  Widget _buildDrawerItem({
    required String title,
    required IconData icon,
    required String targetPageRoute, // ⚡ Structured Named Route Hook Parameter
    String? badgeText,
    Color? badgeColor,
    Color? badgeTextColor,
  }) {
    final bool isActive = widget.activePageRoute == targetPageRoute;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          Navigator.pop(context);
          widget.onRouteSelected(targetPageRoute);
        },
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isActive
                ? AnansiColors.darkBlue.withValues(alpha: 0.04)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive
                  ? AnansiColors.darkBlue.withValues(alpha: 0.02)
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isActive
                    ? AnansiColors.darkBlue
                    : const Color(0xFF94A3B8),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                    color: isActive
                        ? AnansiColors.darkBlue
                        : const Color(0xFF475569),
                  ),
                ),
              ),
              if (badgeText != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor ?? const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    badgeText,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: badgeTextColor ?? const Color(0xFF475569),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

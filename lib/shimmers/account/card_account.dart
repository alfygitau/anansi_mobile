import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget buildBalanceHeroSkeleton() {
  return Container(
    height: 200,
    width: double.infinity,
    decoration: BoxDecoration(
      color: AnansiColors.darkBlue,
      borderRadius: BorderRadius.circular(32),
      boxShadow: [
        BoxShadow(
          color: AnansiColors.darkBlue.withValues(alpha: 0.3),
          blurRadius: 30,
          offset: const Offset(0, 15),
        ),
      ],
    ),
    child: Shimmer.fromColors(
      // Light grey/white shimmers look premium on dark backgrounds
      baseColor: Colors.white.withValues(alpha: 0.1),
      highlightColor: Colors.white.withValues(alpha: 0.2),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top Section: Label and Balance
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.white, // Mask for indicator
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 60,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 180,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Bottom Section: Account Info
            Container(
              padding: const EdgeInsets.only(top: 20),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.white10)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            width: 120,
                            height: 18,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(width: 14, height: 14, color: Colors.white),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildTransactionListSkeleton() {
  return ListView.separated(
    shrinkWrap: true,
    padding: EdgeInsets.zero,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: 6, // Matches your real list count
    separatorBuilder: (_, __) => const SizedBox(height: 12),
    itemBuilder: (context, index) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white, // Keep static white
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFF1F5F9)),
        ),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade200,
          highlightColor: Colors.white,
          child: Row(
            children: [
              // Icon Box Skeleton
              Container(
                width: 44, // Matches padding(12) + icon(20)
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              const SizedBox(width: 16),
              
              // Text Info Skeleton
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // M-PESA Title
                    Container(height: 12, width: 60, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(4))),
                    const SizedBox(height: 6),
                    // Reference Line
                    Container(height: 8, width: 100, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(2))),
                    const SizedBox(height: 4),
                    // Date Line
                    Container(height: 8, width: 70, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(2))),
                  ],
                ),
              ),
              
              // Amount and Status Skeleton
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Amount
                  Container(height: 12, width: 50, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(4))),
                  const SizedBox(height: 6),
                  // Status Label
                  Container(height: 8, width: 40, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(2))),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

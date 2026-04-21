import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget buildBalanceDashboardSkeleton() {
  return Container(
    margin: const EdgeInsets.all(16),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.03),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left Stat Skeleton (Available)
              Expanded(child: _headerStatSkeleton()),

              // Static Divider
              Container(
                width: 1,
                height: 40,
                color: Colors.grey.withValues(alpha: 0.2),
              ),

              // Right Stat Skeleton (Guaranteed)
              Expanded(child: _headerStatSkeleton()),
            ],
          ),
          const SizedBox(height: 20),

          // Bottom Info Banner Skeleton
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.black, // Mask for shimmer
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 200,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
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

// Helper to maintain the look of _headerStat
Widget _headerStatSkeleton() {
  return Column(
    children: [
      Container(
        width: 60,
        height: 10,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      const SizedBox(height: 8),
      Container(
        width: 80,
        height: 18,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    ],
  );
}

Widget buildModernCardListSkeleton() {
  return ListView.separated(
    shrinkWrap: true,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    physics: const NeverScrollableScrollPhysics(),
    itemCount: 5, // Typical number of items for a dashboard view
    separatorBuilder: (_, __) => const SizedBox(height: 12),
    itemBuilder: (context, index) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade200,
          highlightColor: Colors.white,
          child: Row(
            children: [
              // Icon Box Skeleton
              Container(
                width: 48, // Padding (12*2) + Icon (24)
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              const SizedBox(width: 16),

              // Text Content Skeleton
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Container(
                      height: 14,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Subtitle
                    Container(
                      height: 10,
                      width: 180,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Date
                    Container(
                      height: 10,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),

              // Trailing Widget Skeleton
              Container(
                width: 40,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

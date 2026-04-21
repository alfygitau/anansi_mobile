import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget buildProfileSkeleton() {
  return Column(
    children: [
      // 1. Personal Information Card (Grid/Wrap)
      _buildInfoCardSkeleton(
        child: Wrap(
          spacing: 20,
          runSpacing: 20,
          children: List.generate(
            6,
            (i) => _buildDataFieldSkeleton(isFullWidth: false),
          ),
        ),
      ),

      // 2. Residential Address Card (Column)
      _buildInfoCardSkeleton(
        child: Column(
          children: List.generate(
            4,
            (i) => _buildDataFieldSkeleton(isFullWidth: true),
          ),
        ),
      ),

      // 3. Employment & Financials (Column)
      _buildInfoCardSkeleton(
        child: Column(
          children: List.generate(
            4,
            (i) => _buildDataFieldSkeleton(isFullWidth: true),
          ),
        ),
      ),

      // 4. Next of Kin (Column)
      _buildInfoCardSkeleton(
        child: Column(
          children: List.generate(
            5,
            (i) => _buildDataFieldSkeleton(isFullWidth: true),
          ),
        ),
      ),
    ],
  );
}

Widget _buildInfoCardSkeleton({required Widget child}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(24),
    margin: const EdgeInsets.only(bottom: 20),
    decoration: BoxDecoration(
      color: Colors.white, // Keep this OUTSIDE the shimmer
      borderRadius: BorderRadius.circular(28),
      border: Border.all(color: Colors.grey.shade100),
    ),
    child: Shimmer.fromColors(
      baseColor: Colors.grey.shade200, // The grey color of your lines
      highlightColor: Colors.grey.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER SECTION SKELETON
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(width: 120, height: 12, color: Colors.black),
                ],
              ),
              Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // DATA FIELDS SECTION
          child,
        ],
      ),
    ),
  );
}

Widget _buildDataFieldSkeleton({required bool isFullWidth}) {
  return Builder(
    builder: (context) {
      return SizedBox(
        width: isFullWidth
            ? double.infinity
            : MediaQuery.of(context).size.width * 0.38,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // LABEL LINE (Tiny grey line)
            Container(
              height: 8,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.black, // Mask color for shimmer
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 6),
            // VALUE LINE (Thicker grey line)
            Container(
              height: 14,
              width: isFullWidth ? double.infinity : 110,
              decoration: BoxDecoration(
                color: Colors.black, // Mask color for shimmer
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            if (isFullWidth) const SizedBox(height: 16),
          ],
        ),
      );
    },
  );
}

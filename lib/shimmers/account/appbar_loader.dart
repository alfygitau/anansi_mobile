import 'package:flutter/material.dart';

Widget buildAppBarSkeleton() {
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
        // Title Skeleton
        _buildSkeletonBox(width: 100, height: 14, radius: 4),
        const SizedBox(height: 6),
        // Subtitle Skeleton
        _buildSkeletonBox(width: 60, height: 8, radius: 2),
      ],
    ),
    leading: Center(
      child: Container(
        width: 38,
        height: 38,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        // Placeholder for the back icon
        child: Center(
          child: _buildSkeletonBox(width: 18, height: 18, radius: 9),
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
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            // Placeholder for the action icon
            child: Center(
              child: _buildSkeletonBox(width: 18, height: 18, radius: 9),
            ),
          ),
        ),
      ),
    ],
  );
}

// Helper for the "bone" of the skeleton
Widget _buildSkeletonBox({
  required double width, 
  required double height, 
  required double radius
}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(radius),
    ),
  );
}
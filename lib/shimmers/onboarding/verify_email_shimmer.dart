import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class VerifyEmailShimmer extends StatelessWidget {
  const VerifyEmailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    // Helper to build a gray shimmer block
    Widget shimmerBlock({
      required double width,
      required double height,
      double borderRadius = 8,
    }) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade200,
        highlightColor: Colors.grey.shade50,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    // Icon Header Skeleton
                    shimmerBlock(width: 64, height: 64, borderRadius: 20),
                    const SizedBox(height: 20),
                    // Title Skeleton
                    shimmerBlock(width: 200, height: 28),
                    const SizedBox(height: 12),
                    // Description Lines
                    shimmerBlock(width: double.infinity, height: 14),
                    const SizedBox(height: 8),
                    shimmerBlock(width: double.infinity, height: 14),
                    const SizedBox(height: 8),
                    shimmerBlock(width: 150, height: 14),
                    const SizedBox(height: 40),
                    // OTP Boxes Skeleton
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        6,
                        (index) => shimmerBlock(width: 45, height: 55, borderRadius: 12),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Resend Logic Skeleton
                    shimmerBlock(width: 180, height: 12),
                    const SizedBox(height: 30),
                    // Security Disclaimer Box Skeleton
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade100),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          shimmerBlock(width: 120, height: 10),
                          const SizedBox(height: 12),
                          shimmerBlock(width: double.infinity, height: 10),
                          const SizedBox(height: 8),
                          shimmerBlock(width: double.infinity, height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bottom Action Skeleton
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: shimmerBlock(width: double.infinity, height: 64, borderRadius: 20),
            ),
          ],
        ),
      ),
    );
  }
}
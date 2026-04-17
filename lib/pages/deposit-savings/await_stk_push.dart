import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';

class AwaitStkPush extends StatefulWidget {
  final String reference;

  const AwaitStkPush({super.key, required this.reference});

  @override
  State<AwaitStkPush> createState() => _AwaitStkPushState();
}

class _AwaitStkPushState extends State<AwaitStkPush>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSuccessBanner(),
                  const SizedBox(height: 10),
                  _buildModernPulseAnimation(),
                  const SizedBox(height: 10),
                  const Text(
                    "Awaiting Verification",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AnansiColors.darkBlue,
                      fontWeight: FontWeight.w900,
                      fontSize: 22,
                      letterSpacing: -0.6,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Hang tight! We’re communicating with M-PESA to confirm your payment.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blueGrey.shade400,
                      fontSize: 14,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildChecklistCard(),
                  const SizedBox(height: 20),
                  _buildSecurityBadges(),
                  const SizedBox(height: 20),
                  _buildReferencePill(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernPulseAnimation() {
    return SizedBox(
      height: 160,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ...List.generate(2, (index) {
            return AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                double progress =
                    (_pulseController.value + (index * 0.5)) % 1.0;
                return Container(
                  width: 70 + (progress * 80),
                  height: 70 + (progress * 80),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(
                      0xFF22C55E,
                    ).withValues(alpha: 0.15 * (1 - progress)),
                  ),
                );
              },
            );
          }),
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFF0FDF4), width: 5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              CupertinoIcons.device_phone_portrait,
              size: 40, // Scaled down icon
              color: Color(0xFF22C55E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF22C55E).withValues(alpha: 0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF166534).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFF22C55E),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              CupertinoIcons.checkmark,
              size: 14,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Text(
                      "Request Sent",
                      style: TextStyle(
                        color: Color(0xFF166534),
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF166534).withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        "SENT",
                        style: TextStyle(
                          color: Color(0xFF166534),
                          fontSize: 8,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "M-PESA checkout session is now active.",
                  style: TextStyle(
                    color: const Color(0xFF166534).withValues(alpha: 0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.clock,
                      size: 10,
                      color: const Color(0xFF166534).withValues(alpha: 0.3),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Sent at ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}",
                      style: TextStyle(
                        color: const Color(0xFF166534).withValues(alpha: 0.4),
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFFF1F4F8), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "PRE-AUTHORIZATION CHECK",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: Colors.blueGrey.shade300,
                  letterSpacing: 1.5,
                ),
              ),
              const Icon(
                CupertinoIcons.checkmark_shield_fill,
                size: 14,
                color: Color(0xFF22C55E),
              ),
            ],
          ),
          const SizedBox(height: 24),

          _buildDetailedCheckItem(
            icon: CupertinoIcons.antenna_radiowaves_left_right,
            title: "Network Connectivity",
            description:
                "Ensure your Safaricom SIM is active and has a stable signal to receive the STK push.",
            isLast: false,
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1, color: Color(0xFFF1F4F8)),
          ),

          _buildDetailedCheckItem(
            icon: CupertinoIcons.lock_shield_fill,
            title: "M-PESA Authentication",
            description:
                "Have your M-PESA PIN ready. The prompt will expire in 60 seconds if not authorized.",
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedCheckItem({
    required IconData icon,
    required String title,
    required String description,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, size: 18, color: const Color(0xFF22C55E)),
        ),
        const SizedBox(width: 16),

        // Text Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AnansiColors.darkBlue,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  color: Colors.blueGrey.shade400,
                  fontSize: 12,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityBadges() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildBadge(CupertinoIcons.shield_lefthalf_fill, "SECURE"),
        const SizedBox(width: 12),
        _buildBadge(CupertinoIcons.lock_fill, "ENCRYPTED"),
        const SizedBox(width: 12),
        _buildBadge(CupertinoIcons.checkmark_seal_fill, "CBK REG"),
      ],
    );
  }

  Widget _buildBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 10, color: AnansiColors.darkBlue),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w900,
              color: AnansiColors.darkBlue,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReferencePill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AnansiColors.darkBlue.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        "ID: ${widget.reference.toUpperCase()}",
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: AnansiColors.darkBlue.withValues(alpha: 0.5),
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

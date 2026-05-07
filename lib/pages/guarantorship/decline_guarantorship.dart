import 'package:app_anansi_mobile/pages/guarantorship/guarantorship.dart';
import 'package:app_anansi_mobile/services/error_service.dart';
import 'package:app_anansi_mobile/services/guarantorship_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class DeclineGuarantorship extends StatefulWidget {
  final Map<String, dynamic>? loanInfo;
  const DeclineGuarantorship({super.key, required this.loanInfo});

  @override
  State<DeclineGuarantorship> createState() => _DeclineGuarantorshipState();
}

class _DeclineGuarantorshipState extends State<DeclineGuarantorship> {
  String? _selectedReason;
  bool _isSubmitting = false;

  final List<String> _reasons = [
    "I do not know the borrower",
    "I'm uncomfortable with the amount",
    "I've reached my guarantee limit",
    "I do not wish to guarantee this loan",
  ];

  void _submitDecline() async {
    setState(() {
      _isSubmitting = true;
    });
    try {
      final (response, errors) = await GuarantorshipService()
          .respondToGuarantor(
            guarantor: widget.loanInfo?['guarantorId'],
            requestor: widget.loanInfo?['id'],
            isAccepted: false,
            status: "declined",
            amount: "0",
            reason: _selectedReason ?? "",
          );
      if (errors != null) {
        ErrorService.showActionableError(
          context,
          title: errors[0],
          message: errors[1],
        );
      } else if (response != null) {
        showGuarantorDeclineSheet(
          context,
          onAction: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Guarantorship()),
            );
          },
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildSliverAppBar(),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 10),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildIllustrativeHeader(),
                      const SizedBox(height: 32),
                      _buildSectionHeader("REASON FOR DECLINING"),
                      const SizedBox(height: 8),
                      ..._reasons.map((reason) => _buildReasonOption(reason)),
                      const SizedBox(height: 24),
                      _buildSecurityNote(),
                    ]),
                  ),
                ),
              ],
            ),
          ),
          _buildActionFooter(),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      pinned: true,
      floating: true,
      backgroundColor: const Color(0xFFF8FAFC).withValues(alpha: 0.9),
      elevation: 0,
      centerTitle: true,
      leadingWidth: 64,
      toolbarHeight: 70,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Guarantorship",
            style: TextStyle(
              color: AnansiColors.darkBlue,
              fontWeight: FontWeight.w900,
              fontSize: 15,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            "DECLINE REQUEST",
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
      leading: _buildCircleAction(
        CupertinoIcons.back,
        () => Navigator.pop(context),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: _buildCircleAction(CupertinoIcons.question_circle, () {}),
        ),
      ],
    );
  }

  Widget _buildCircleAction(IconData icon, VoidCallback onTap) {
    return Center(
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
          icon: Icon(icon, size: 18, color: AnansiColors.darkBlue),
          onPressed: onTap,
        ),
      ),
    );
  }

  Widget _buildIllustrativeHeader() {
    return Column(
      children: [
        Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.05),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(
              CupertinoIcons.xmark_shield_fill,
              size: 54,
              color: Colors.redAccent,
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          "Decline Guarantorship?",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: AnansiColors.darkBlue,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "This will notify the borrower that you are unable to guarantee their loan. This action cannot be undone.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w800,
        color: Colors.grey.shade400,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildReasonOption(String reason) {
    bool isSelected = _selectedReason == reason;
    return GestureDetector(
      onTap: () => setState(() => _selectedReason = reason),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AnansiColors.darkBlue : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                reason,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? AnansiColors.darkBlue
                      : Colors.grey.shade600,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                CupertinoIcons.checkmark_circle_fill,
                color: AnansiColors.darkBlue,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityNote() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            CupertinoIcons.lock_shield,
            size: 16,
            color: Colors.grey.shade400,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Your feedback helps us improve our security and verification processes.",
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionFooter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 58,
        child: ElevatedButton(
          onPressed: (_selectedReason != null && !_isSubmitting)
              ? () => _submitDecline()
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            disabledBackgroundColor: Colors.grey.shade100,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: _isSubmitting
              ? const CupertinoActivityIndicator(color: Colors.white)
              : const Text(
                  "Confirm Decline",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
        ),
      ),
    );
  }

  void showGuarantorDeclineSheet(
    BuildContext context, {
    required VoidCallback onAction,
  }) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              // Decline Icon
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_rounded,
                  size: 40,
                  color: Colors.redAccent,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Request Declined",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "You have declined the invitation to act as a guarantor. The borrower has been notified and the request is now void.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 15, height: 1.4),
              ),
              const SizedBox(height: 30),
              // Simple Action Notification
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[200]!),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.info, color: Colors.amber, size: 20),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        "No legal or financial obligations have been created.",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onAction();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    "Return to Dashboard",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        );
      },
    );
  }
}

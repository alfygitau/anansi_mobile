import 'dart:convert';
import 'dart:math';
import 'package:app_anansi_mobile/helpers/format_amount.dart';
import 'package:app_anansi_mobile/helpers/format_mobile.dart';
import 'package:app_anansi_mobile/pages/help&support/help_support.dart';
import 'package:app_anansi_mobile/pages/invest/invest_stk_push.dart';
import 'package:app_anansi_mobile/services/account_service.dart';
import 'package:app_anansi_mobile/services/error_service.dart';
import 'package:app_anansi_mobile/services/secure_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/services.dart';

class ReviewInvestDetails extends StatefulWidget {
  final String savingsAmount;
  final String sharesAmount;
  final String phoneNumber;

  const ReviewInvestDetails({
    super.key,
    required this.savingsAmount,
    required this.sharesAmount,
    required this.phoneNumber,
  });

  @override
  State<ReviewInvestDetails> createState() => _ReviewInvestDetailsState();
}

class _ReviewInvestDetailsState extends State<ReviewInvestDetails> {
  final double sharePrice = 1000.0;
  String? _reference;
  bool _isLoading = false;

  String generateAlphaNumericId([int length = 8]) {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final random = Random.secure();

    return Iterable.generate(
      length,
      (_) => chars[random.nextInt(chars.length)],
    ).join();
  }

  Future<Map<String, dynamic>?> getUser() async {
    String? userJson = await SecureStorageService().read('user');
    if (userJson == null) return null;
    Map<String, dynamic> userMap = jsonDecode(userJson);
    return userMap;
  }

  void quickInvest() async {
    final String ref = generateAlphaNumericId();
    setState(() {
      _isLoading = true;
      _reference = ref;
    });
    try {
      final user = await getUser();
      final (response, errors) = await AccountService().quickInvest(
        savingsAmount: widget.savingsAmount.toString(),
        reference: ref,
        sharesAmount: widget.sharesAmount.toString(),
        id: user?['id'] ?? "",
        mobile: formatToKenyanPhone(widget.phoneNumber) ?? "",
      );
      if (errors != null) {
        ErrorService.showActionableError(
          context,
          title: errors[0],
          message: errors[1],
        );
      } else if (response != null) {
        HapticFeedback.lightImpact();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InvestStkPush(reference: _reference ?? ""),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double savings = double.tryParse(widget.savingsAmount) ?? 0.0;
    final double shares = double.tryParse(widget.sharesAmount) ?? 0.0;

    // 2. Perform the calculations
    final double total = savings + shares;
    final double sharesCount = shares / sharePrice;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildAppBar(context),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 16),
                    _buildSectionHeader("Transaction Breakdown"),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                          color: const Color(0xFFF1F4F8),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              24.0,
                              18,
                              24,
                              18,
                            ),
                            child: Column(
                              children: [
                                _buildAttributeRow(
                                  "Type",
                                  "Investment Allocation",
                                  isBold: true,
                                ),
                                _buildDivider(),
                                _buildAttributeRow(
                                  "Savings",
                                  formatAmount(widget.savingsAmount),
                                ),
                                _buildDivider(),
                                _buildAttributeRow(
                                  "Shares",
                                  formatAmount(widget.sharesAmount),
                                ),
                                _buildAttributeRow(
                                  "Number of shares",
                                  "${sharesCount.toStringAsFixed(2)} Units",
                                  isDimmed: true,
                                ),
                                _buildDivider(),
                                _buildAttributeRow("Wallet", "M-PESA"),
                                _buildAttributeRow(
                                  "Phone Number",
                                  widget.phoneNumber,
                                  isDimmed: true,
                                ),
                                _buildDivider(),
                                _buildAttributeRow(
                                  "Total Payable",
                                  formatAmount(total),
                                  color: const Color(0xFF17C6C6),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildSectionHeader("Compliance & Safety"),
                    const SizedBox(height: 10),
                    _buildDetailedDisclaimer(
                      title: "SIM Toolkit Authorization",
                      message:
                          "A prompt will appear on your Safaricom line. Do not share your M-PESA PIN with anyone.",
                      icon: CupertinoIcons.device_phone_portrait,
                      color: const Color(0xFF17C6C6),
                    ),
                    const SizedBox(height: 12),
                    _buildDetailedDisclaimer(
                      title: "Transaction Reversal",
                      message:
                          "Deposits to savings are non-reversible via M-PESA once the STK push is successfully authorized.",
                      icon: CupertinoIcons.info_circle_fill,
                      color: Colors.orange.shade700,
                    ),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: _buildActionFooter(total),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w900,
        color: Color(0xFF9E9E9E),
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildDetailedDisclaimer({
    required String title,
    required String message,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.blueGrey.shade600,
                    fontSize: 11,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- INTEGRATED CUSTOM APP BAR ---
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
            "Quick Invest & Save",
            style: TextStyle(
              color: AnansiColors.darkBlue,
              fontWeight: FontWeight.w900,
              fontSize: 15,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            "SECURE TRANSACTION",
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 7,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
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

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Review Details",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: AnansiColors.darkBlue,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 4),
        Text(
          "Please verify your transaction details before proceeding to authorization.",
          style: TextStyle(
            color: Colors.blueGrey.shade400,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildAttributeRow(
    String label,
    String value, {
    bool isBold = false,
    bool isDimmed = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isDimmed ? Colors.grey.shade400 : Colors.blueGrey.shade600,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color ?? AnansiColors.darkBlue,
              fontSize: 13,
              fontWeight: isBold ? FontWeight.w900 : FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Divider(color: Color(0xFFF1F4F8), thickness: 1.5),
    );
  }

  Widget _buildActionFooter(double total) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
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
      child: ElevatedButton(
        onPressed: _isLoading ? () {} : quickInvest,
        style: ElevatedButton.styleFrom(
          backgroundColor: AnansiColors.darkBlue,
          disabledBackgroundColor: _isLoading
              ? AnansiColors.darkBlue
              : Colors.grey.shade300,
          foregroundColor: Colors.white,
          disabledForegroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const CupertinoActivityIndicator(color: Colors.white)
            : const Text(
                "Confirm & Authorize",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }
}

import 'package:app_anansi_mobile/helpers/format_amount.dart';
import 'package:app_anansi_mobile/pages/guarantorship/decline_guarantorship.dart';
import 'package:app_anansi_mobile/pages/guarantorship/guarantee_amount.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewRequest extends StatefulWidget {
  final Map<String, dynamic> loanInfo;
  const ViewRequest({super.key, required this.loanInfo});

  @override
  State<ViewRequest> createState() => _ViewRequestState();
}

class _ViewRequestState extends State<ViewRequest> {
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
                  padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildContextBadge(),
                      SizedBox(height: 10),
                      _buildSecurityNotice(),
                      const SizedBox(height: 32),

                      _buildSectionHeader(
                        "BORROWER DETAILS",
                        CupertinoIcons.person_crop_circle,
                      ),
                      _buildInfoCard([
                        _infoRow(
                          "Full Name",
                          widget.loanInfo['borrowerName'] ?? "N/A",
                        ),
                        _infoRow(
                          "Phone Number",
                          widget.loanInfo['borrowerPhone'] ?? "N/A",
                        ),
                      ]),

                      const SizedBox(height: 32),

                      _buildSectionHeader(
                        "LOAN TERMS",
                        CupertinoIcons.doc_text,
                      ),
                      _buildInfoCard([
                        _infoRowNumber(
                          "Principal Amount",
                          formatAmount(
                            widget.loanInfo['loanInfo']['loanamount'] ?? 0,
                          ),
                        ),
                        _infoRow(
                          "Interest Rate",
                          "${widget.loanInfo['loanInfo']['loaninterest'] ?? '0'}% per month",
                        ),
                        _infoRow(
                          "Repayment Period",
                          "${widget.loanInfo['loanInfo']['loanperiod']} days",
                        ),
                        const Divider(height: 32, thickness: 0.5),
                        _infoRowNumber(
                          "Total Repayable",
                          formatAmount(
                            widget.loanInfo['loanInfo']['loanrepaymentamount'] ??
                                0,
                          ),
                          isHighlight: true,
                        ),
                      ]),
                      const SizedBox(height: 24),
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
            "VIEW REQUEST",
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
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                CupertinoIcons.question_circle,
                size: 18,
                color: AnansiColors.darkBlue,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- Supporting UI components remain consistent with your premium design ---

  Widget _buildSecurityNotice() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AnansiColors.darkBlue.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AnansiColors.darkBlue.withValues(alpha: 0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            CupertinoIcons.shield_lefthalf_fill,
            size: 18,
            color: AnansiColors.darkBlue,
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Please verify the borrower\'s identity. By continuing, you agree to be legally responsible if the borrower fails to repay.',
              style: TextStyle(
                color: AnansiColors.darkBlue,
                fontSize: 11,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade400),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: Colors.grey.shade500,
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _infoRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isHighlight
                  ? AnansiColors.accentCyan
                  : AnansiColors.darkBlue,
              fontSize: isHighlight ? 15 : 13,
              fontWeight: isHighlight ? FontWeight.w900 : FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRowNumber(
    String label,
    String value, {
    bool isHighlight = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.robotoMono(
              fontWeight: isHighlight ? FontWeight.w900 : FontWeight.w700,
              fontSize: isHighlight ? 15 : 13,
              letterSpacing: -1,
              color: isHighlight
                  ? AnansiColors.accentCyan
                  : AnansiColors.darkBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContextBadge() {
    final status =
        widget.loanInfo['status']?.toString().toLowerCase() ?? 'pending';
    final Map<String, dynamic> config =
        {
          'pending': {
            'color': Colors.orange,
            'icon': CupertinoIcons.clock,
            'text': 'AWAITING YOUR REVIEW',
            'showExpiry': true,
          },
          'accepted': {
            'color': AnansiColors.accentCyan,
            'icon': CupertinoIcons.checkmark_shield_fill,
            'text': 'GUARANTORSHIP ACTIVE',
            'showExpiry': false,
          },
          'declined': {
            'color': Colors.redAccent,
            'icon': CupertinoIcons.xmark_shield_fill,
            'text': 'REQUEST DECLINED',
            'showExpiry': false,
          },
        }[status] ??
        {
          'color': Colors.grey,
          'icon': CupertinoIcons.info,
          'text': 'STATUS UNKNOWN',
          'showExpiry': false,
        };

    final Color baseColor = config['color'];

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: baseColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: baseColor.withValues(alpha: 0.2),
                width: 0.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(config['icon'], size: 12, color: baseColor),
                const SizedBox(width: 6),
                Text(
                  config['text'],
                  style: TextStyle(
                    color: baseColor is MaterialColor
                        ? (baseColor).shade800
                        : baseColor,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          if (config['showExpiry'])
            Text(
              "Expires in 48h",
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            )
          else
            Text(
              widget.loanInfo['date'] ?? "",
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionFooter() {
    final status = widget.loanInfo['status'];
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
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
      child: status == 'pending'
          ? Row(
              children: [
                Expanded(
                  flex: 2,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DeclineGuarantorship(loanInfo: widget.loanInfo),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Colors.redAccent,
                        width: 1.5,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      "Decline",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              GuaranteeAmount(loanInfo: widget.loanInfo),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AnansiColors.darkBlue,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      "Continue",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : SizedBox(
              width: double.infinity,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: status == 'accepted'
                      ? AnansiColors.accentCyan.withValues(alpha: 0.1)
                      : Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  status.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: status == 'accepted'
                        ? AnansiColors.accentCyan
                        : Colors.red,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
    );
  }
}

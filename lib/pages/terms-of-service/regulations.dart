import 'package:app_anansi_mobile/constants/constants.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Regulations extends StatelessWidget {
  const Regulations({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context, "Regulatory & SASRA"),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 36),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLastUpdated("January 1, 2026"),
                  const SizedBox(height: 24),
                  
                  // Authority Badge Header
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: AnansiColors.darkBlue.withValues(alpha: 0.05),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              CupertinoIcons.building_2_fill,
                              color: AnansiColors.darkBlue,
                              size: 32,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Regulated by SASRA",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: AnansiColors.darkBlue,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  _buildContentCard(
                    title: "SASRA Licensing",
                    body:
                        "$saccoName SACCO is licensed and regulated as a Deposit-Taking SACCO by the Sacco Societies Regulatory Authority (SASRA). Our operations, liquidity margins, and capital adequacy strictly adhere to the Sacco Societies Act.",
                  ),
                  const SizedBox(height: 16),
                  _buildContentCard(
                    title: "Deposit Guarantee Fund",
                    body:
                        "In compliance with Kenyan law, member deposits in the FOSA are protected under the Deposit Guarantee Fund framework, ensuring your liquid savings remain secure against institutional risk.",
                  ),
                  const SizedBox(height: 16),
                  _buildContentCard(
                    title: "Anti-Money Laundering (AML)",
                    body:
                        "We conform strictly to the Central Bank of Kenya (CBK) and Financial Reporting Centre (FRC) guidelines. Transactions exceeding KES 1,000,000 or exhibiting suspicious patterns may require mandatory declaration of the source of funds.",
                  ),
                  const SizedBox(height: 16),
                  _buildContentCard(
                    title: "Tax Disclosures",
                    body:
                        "As per KRA regulations, withholding tax is automatically applied to interest earned on FOSA deposits and declared dividends before final payout. Your KRA PIN is used to remit these deductions.",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, String title) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: ThemeColors.background.withValues(alpha: 0.9),
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      leadingWidth: 64,
      title: Text(
        title,
        style: const TextStyle(
          color: AnansiColors.darkBlue,
          fontWeight: FontWeight.w900,
          fontSize: 18,
          letterSpacing: -0.5,
        ),
      ),
      leading: Center(
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(CupertinoIcons.back, size: 18, color: AnansiColors.darkBlue),
            onPressed: () => Navigator.maybePop(context),
          ),
        ),
      ),
    );
  }

  Widget _buildLastUpdated(String date) {
    return Row(
      children: [
        const Icon(CupertinoIcons.checkmark_shield_fill, size: 14, color: Color(0xFF059669)),
        const SizedBox(width: 8),
        Text(
          "Compliance Verified: $date",
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF059669),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildContentCard({required String title, required String body}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w800,
              color: AnansiColors.darkBlue,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            body,
            style: TextStyle(
              fontSize: 13.5,
              color: Colors.grey.shade600,
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
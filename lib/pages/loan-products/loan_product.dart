import 'package:app_anansi_mobile/pages/apply-loan/eligibility.dart';
import 'package:app_anansi_mobile/services/error_service.dart';
import 'package:app_anansi_mobile/services/loan_products_service.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart'; // Ensure AnansiColors is exported here
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LoanProduct extends StatefulWidget {
  final String productId;

  const LoanProduct({super.key, required this.productId});

  @override
  State<LoanProduct> createState() => _LoanProductState();
}

class _LoanProductState extends State<LoanProduct> {
  bool _isLoading = false;
  Map<String, dynamic> loanProduct = {};

  final NumberFormat _currencyFormatter = NumberFormat.currency(
    symbol: "KES ",
    decimalDigits: 0, // Zero decimals for cleaner modern text layout
  );

  Future<void> getLoanProduct() async {
    setState(() => _isLoading = true);
    try {
      final (response, errors) = await LoanProductsService().listLoanProduct(
        productId: widget.productId,
      );
      if (errors != null) {
        ErrorService.showActionableError(
          context,
          title: errors[0],
          message: errors[1],
        );
      } else if (response != null) {
        final responseInfo = response.data['data'];
        setState(() {
          loanProduct = responseInfo ?? {};
        });
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    getLoanProduct();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && loanProduct.isEmpty) {
      return const Scaffold(
        backgroundColor: Color(0xFFF8FAFC),
        body: Center(
          child: CircularProgressIndicator.adaptive(strokeWidth: 2.5),
        ),
      );
    }

    final String productName = loanProduct['product_name'] ?? "Loan Product";
    final List<dynamic> features = loanProduct['features'] ?? [];
    final String collateralDesc =
        loanProduct['collateral_description'] ?? "N/A";
    final String termsAndConditions =
        loanProduct['terms_and_conditions'] ?? "N/A";

    final minAmount =
        double.tryParse(loanProduct['min_amount']?.toString() ?? '0') ?? 0.0;
    final maxAmount =
        double.tryParse(loanProduct['max_amount']?.toString() ?? '0') ?? 0.0;
    final minPeriod = loanProduct['min_period']?.toString() ?? '0';
    final maxPeriod = loanProduct['max_period']?.toString() ?? '0';
    final double interestRate =
        double.tryParse(loanProduct['interest_rate']?.toString() ?? '0') ?? 0.0;
    final interestMethod = (loanProduct['interest_method']?.toString() ?? '')
        .replaceAll('_', ' ')
        .toUpperCase();
    final double processingFeePercent =
        double.tryParse(
          loanProduct['processing_fee_value']?.toString() ?? '0',
        ) ??
        0.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      bottomNavigationBar: _buildBottomActionButton(),
      body: RefreshIndicator(
        onRefresh: getLoanProduct,
        color: AnansiColors.primary,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            _buildAppBar(productName),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AnansiColors.successBg,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        (loanProduct['is_active'] ?? false)
                            ? "AVAILABLE TO APPLY"
                            : "INACTIVE",
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: AnansiColors.successText,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      productName,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: AnansiColors.darkBlue,
                        letterSpacing: -0.8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      loanProduct['description'] ?? "",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "FINANCIAL STRUCTURE",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: _cardDecoration(),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _buildInlineRowItem(
                            "Limit Range",
                            "${_currencyFormatter.format(minAmount)} - ${_currencyFormatter.format(maxAmount)}",
                          ),
                          const Divider(color: Color(0xFFF1F3F5), height: 24),
                          _buildInlineRowItem(
                            "Duration Options",
                            "$minPeriod to $maxPeriod Months",
                          ),
                          const Divider(color: Color(0xFFF1F3F5), height: 24),
                          _buildInlineRowItem(
                            "Interest Rate",
                            "${interestRate.toStringAsFixed(2)}% per month",
                          ),
                          const Divider(color: Color(0xFFF1F3F5), height: 24),
                          _buildInlineRowItem(
                            "Amortization Method",
                            interestMethod,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --- SECTION 2: FEES & OPERATIONAL PARAMETERS ---
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildMetricBlock(
                        "Processing Fee",
                        "${processingFeePercent.toStringAsFixed(2)}% ${loanProduct['deduct_fee_from_principal'] == true ? '(Deducted)' : ''}",
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMetricBlock(
                        "Grace Period",
                        "${loanProduct['grace_period_days'] ?? 0} Days",
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --- SECTION 3: FEATURES ---
            if (features.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "PRODUCT FEATURES",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: Colors.grey,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: _cardDecoration(),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: features
                              .map(
                                (feature) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6.0,
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.check_circle_outline_rounded,
                                        size: 18,
                                        color: AnansiColors.primary,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          feature.toString(),
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: AnansiColors.darkBlue,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // --- SECTION 4: REQUIREMENTS & COMPLIANCE ---
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "ELIGIBILITY & COMPLIANCE",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: Colors.grey,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: _cardDecoration(),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildRequirementRow(
                            "Guarantor Requirements",
                            loanProduct['requires_guarantor'] == true
                                ? "Requires minimum ${loanProduct['min_guarantors']} and up to ${loanProduct['max_guarantors']} verified guarantors covering ${loanProduct['guarantor_coverage_percent']}% of the amount."
                                : "No guarantors required for this product.",
                          ),
                          const Divider(color: Color(0xFFF1F3F5), height: 24),
                          _buildRequirementRow(
                            "Security & Collateral",
                            collateralDesc,
                          ),
                          const Divider(color: Color(0xFFF1F3F5), height: 24),
                          _buildRequirementRow(
                            "Institutional Prerequisites",
                            "Must maintain active membership for at least ${loanProduct['min_membership_months'] ?? 0} months. Minimum shares mandatory valuation threshold rests at ${_currencyFormatter.format(double.tryParse(loanProduct['min_shares_amount']?.toString() ?? '0') ?? 0)}.",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --- SECTION 5: LEGAL TERMS AND CONDITIONS ---
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "TERMS & CONDITIONS",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: Colors.grey,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      termsAndConditions,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- COMPONENT COMPOSITIONS ---

  Widget _buildAppBar(String productName) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      backgroundColor: const Color(0xFFF8FAFC).withValues(alpha: 0.9),
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      leadingWidth: 64,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            productName,
            style: const TextStyle(
              color: AnansiColors.darkBlue,
              fontWeight: FontWeight.w900,
              fontSize: 15,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            "PRODUCT DETAILS",
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
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
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
    );
  }

  Widget _buildInlineRowItem(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AnansiColors.darkBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricBlock(String label, String value) {
    return Container(
      decoration: _cardDecoration(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              color: Colors.grey.shade400,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AnansiColors.darkBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementRow(String headline, String detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          headline,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: AnansiColors.darkBlue,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          detail,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActionButton() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        24,
        12,
        24,
        MediaQuery.paddingOf(context).bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade100, width: 1)),
      ),
      child: CupertinoButton(
        color: AnansiColors.darkBlue,
        borderRadius: BorderRadius.circular(14),
        padding: const EdgeInsets.symmetric(vertical: 20),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  LoanEligibility(productId: loanProduct['id'] ?? ""),
            ),
          );
        },
        child: const Text(
          "Proceed to Application",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: const Color(0xFFEAECEF), width: 1),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.012),
          blurRadius: 15,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }
}

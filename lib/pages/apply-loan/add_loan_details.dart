import 'dart:convert';
import 'package:app_anansi_mobile/pages/apply-loan/add_guarantors.dart';
import 'package:app_anansi_mobile/pages/apply-loan/add_statements.dart';
import 'package:app_anansi_mobile/pages/apply-loan/collaterals.dart';
import 'package:app_anansi_mobile/pages/apply-loan/loan_terms_conditions.dart';
import 'package:app_anansi_mobile/pages/help&support/help_support.dart';
import 'package:app_anansi_mobile/services/error_service.dart';
import 'package:app_anansi_mobile/services/loan_application_service.dart';
import 'package:app_anansi_mobile/services/loan_products_service.dart';
import 'package:app_anansi_mobile/services/secure_storage_service.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AddLoanDetails extends StatefulWidget {
  final String productId;
  const AddLoanDetails({super.key, required this.productId});

  @override
  State<AddLoanDetails> createState() => _AddLoanDetailsState();
}

class _AddLoanDetailsState extends State<AddLoanDetails> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();
  String _selectedFrequency = "Monthly";
  final FocusNode _amountFocus = FocusNode();
  double _selectedTenure = 0;
  Map<String, String?> formErrors = {'amount': null};
  Map<String, dynamic> loanProduct = {};
  bool _isLoading = false;
  bool _loading = false;

  Future<Map<String, dynamic>?> getUser() async {
    String? userJson = await SecureStorageService().read('user');
    if (userJson == null) return null;
    Map<String, dynamic> userMap = jsonDecode(userJson);
    return userMap;
  }

  Future<void> getLoanProduct() async {
    _isLoading = true;
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
          _selectedTenure =
              double.tryParse(responseInfo['min_period']?.toString() ?? "") ??
              0.0;
        });
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> createLoanApplication(
    Widget Function(String appId, String productId) nextScreenBuilder,
  ) async {
    _validateField('amount', _amountController.text);

    setState(() => _loading = true);
    try {
      final user = await getUser();
      final (response, errors) = await LoanApplicationService()
          .createApplication(
            productId: widget.productId,
            customerId: user?['id'] ?? "",
            amount: _amountController.text.trim(),
            duration: _selectedTenure.toString(),
            applicantName: '${user?['firstname']} ${user?['lastname']}',
            applicantMobile: user?['mobileno'] ?? "",
            purpose: _purposeController.text.trim(),
          );

      if (errors != null) {
        ErrorService.showActionableError(
          context,
          title: errors[0],
          message: errors[1],
        );
      } else if (response != null) {
        final responseInfo = response.data['data'] ?? {};
        final String applicationId = responseInfo['id']?.toString() ?? "";

        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  nextScreenBuilder(applicationId, widget.productId),
            ),
          );
        }
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _validateField(String key, String value) {
    setState(() {
      final String trimmedValue = value.trim();
      if (trimmedValue.isEmpty) {
        formErrors[key] = "This field is required to apply loan";
        return;
      }
      final double? inputAmount = double.tryParse(trimmedValue);
      if (inputAmount == null) {
        formErrors[key] = "Please enter a valid numerical amount";
        return;
      }
      final double maxAmount =
          double.tryParse(loanProduct['max_amount']?.toString() ?? '') ?? 0.0;
      final double minAmount =
          double.tryParse(loanProduct['min_amount']?.toString() ?? '') ?? 0.0;
      if (inputAmount > maxAmount) {
        formErrors[key] =
            "Maximum allowable amount is KES ${maxAmount.toStringAsFixed(0)}";
      } else if (inputAmount < minAmount) {
        formErrors[key] =
            "Minimum required amount is KES ${minAmount.toStringAsFixed(0)}";
      } else {
        formErrors[key] = null;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getLoanProduct();

    _amountFocus.addListener(() {
      if (!_amountFocus.hasFocus) {
        _validateField('amount', _amountController.text);
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _amountFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: _isLoading
                ? _buildProductIdentitySkeleton()
                : _buildProductIdentityCard(),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _sectionTitle("Configure your loan"),
                const SizedBox(height: 8),
                _buildInputField(
                  label: "Loan Amount",
                  hint: "Enter Amount",
                  icon: CupertinoIcons.money_dollar,
                  focusNode: _amountFocus,
                  fieldKey: "amount",
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 25),
                _sectionTitle("Repayment Tenure"),
                const SizedBox(height: 10),
                _buildTenureSelector(),
                const SizedBox(height: 30),
                _sectionTitle("Repayment Frequency"),
                const SizedBox(height: 16),
                _buildFrequencySelector(),
                const SizedBox(height: 25),
                _sectionTitle("Loan Purpose"),
                const SizedBox(height: 5),
                _buildTextAreaCard(controller: _purposeController),
                const SizedBox(height: 120),
              ]),
            ),
          ),
        ],
      ),
      bottomSheet: _buildActionDock(
        onCreateApplication: (nextRoute) => createLoanApplication(nextRoute),
      ),
    );
  }

  Widget _buildAppBar() {
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
            "Loan Application",
            style: TextStyle(
              color: AnansiColors.darkBlue,
              fontWeight: FontWeight.w900,
              fontSize: 15,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "LOAN DETAILS",
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 7,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
            ],
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

  Widget _sectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        color: Colors.blueGrey.shade800,
        fontWeight: FontWeight.w900,
        fontSize: 11,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String fieldKey,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required FocusNode focusNode,
    required TextInputType keyboardType,
  }) {
    final String? errorText = formErrors[fieldKey];
    final bool hasError = errorText != null;
    final bool isFocused = focusNode.hasFocus;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 4),
          child: Row(
            children: [
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  color: hasError
                      ? Colors.redAccent
                      : AnansiColors.darkBlue.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w900,
                  fontSize: 11,
                  letterSpacing: 1.2,
                ),
              ),
              if (hasError) ...[
                const SizedBox(width: 8),
                const Icon(
                  CupertinoIcons.exclamationmark_circle,
                  size: 12,
                  color: Colors.redAccent,
                ),
              ],
            ],
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: hasError
                  ? Colors.redAccent.withValues(alpha: 0.4)
                  : (isFocused ? Color(0xFFE2E8F0) : const Color(0xFFE2E8F0)),
              width: 1.8,
            ),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isFocused
                      ? AnansiColors.darkBlue
                      : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: isFocused
                      ? Colors.white
                      : AnansiColors.darkBlue.withValues(alpha: 0.4),
                ),
              ),
              Container(
                height: 24,
                width: 1.5,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                color: const Color(0xFFE2E8F0),
              ),
              Expanded(
                child: TextField(
                  focusNode: focusNode,
                  controller: controller,
                  keyboardType: keyboardType,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2,
                  ),
                  cursorColor: AnansiColors.darkBlue,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                      color: Colors.blueGrey.shade200,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onChanged: (val) {
                    if (formErrors[fieldKey] != null) {
                      setState(() => formErrors[fieldKey] = null);
                    }
                    setState(() {});
                  },
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                ),
              ),
            ],
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: SizedBox(
            height: hasError ? null : 0,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, top: 8),
              child: Text(
                errorText ?? "",
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCircularIcon(IconData icon, Color color, {double size = 38}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.15), width: 1),
      ),
      child: Center(
        child: Icon(icon, size: size * 0.45, color: color),
      ),
    );
  }

  // --- 1. PRODUCT IDENTITY CARD ---
  Widget _buildProductIdentityCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFF1F4F8), width: 0.7),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: Row(
              children: [
                _buildCircularIcon(
                  CupertinoIcons.shield_lefthalf_fill,
                  const Color(0xFF0A2351),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "LOAN PRODUCT",
                      style: TextStyle(
                        color: Color(0xFF17C6C6),
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      loanProduct['product_name'] ?? "Unknown",
                      style: TextStyle(
                        color: Color(0xFF0A2351),
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
            decoration: BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(20),
              border: Border.symmetric(
                horizontal: BorderSide(color: Color(0xFFF1F4F8)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFeatureDetail(
                  "Interest",
                  (double.tryParse(
                            loanProduct['interest_rate']?.toString() ?? '',
                          ) ??
                          0.0)
                      .toStringAsFixed(2),
                  "p.m",
                ),
                _buildVerticalDivider(),
                _buildFeatureDetail(
                  "Tenure",
                  (loanProduct['max_period'] ?? 1).toString(),
                  "Months",
                ),
                _buildVerticalDivider(),
                _buildFeatureDetail("Multiplier", 'N/A', "x"),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
            child: Row(
              children: [
                const Icon(
                  CupertinoIcons.info_circle,
                  size: 14,
                  color: Colors.grey,
                ),
                const SizedBox(width: 10),
                Text(
                  loanProduct['interest_method'] == 'flat_rate'
                      ? "Flat rate model applied to all repayments"
                      : "Reducing balance model applied to all repayments",
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductIdentitySkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      period: const Duration(milliseconds: 1200),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFFF1F4F8), width: 0.7),
        ),
        child: Column(
          children: [
            // 1. HEADER ROW PLACEHOLDER
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              child: Row(
                children: [
                  // Circular Avatar/Icon Bone
                  Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // "LOAN PRODUCT" label line
                      Container(
                        width: 70,
                        height: 9,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Main Title Line
                      Container(
                        width: 150,
                        height: 15,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 2. MIDDLE FEATURE GRID PLACEHOLDER
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.symmetric(
                  horizontal: BorderSide(color: Colors.grey.shade200, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Interest Parameter Blocks
                  _buildFeatureDetailSkeleton(labelWidth: 40, valueWidth: 50),
                  _buildVerticalDividerPlaceholder(),

                  // Tenure Parameter Blocks
                  _buildFeatureDetailSkeleton(labelWidth: 35, valueWidth: 45),
                  _buildVerticalDividerPlaceholder(),

                  // Multiplier Parameter Blocks
                  _buildFeatureDetailSkeleton(labelWidth: 50, valueWidth: 30),
                ],
              ),
            ),

            // 3. FOOTER INFO TRAILING PLACEHOLDER
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 14, 20, 14),
              child: Row(
                children: [
                  // Info Small Icon Circle
                  Container(
                    width: 14,
                    height: 14,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Footer Explainer Text Line
                  Expanded(
                    child: Container(
                      height: 11,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ), // Retains safe edge padding parameters
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Compact Sub-Layout Structural Helpers
  Widget _buildFeatureDetailSkeleton({
    required double labelWidth,
    required double valueWidth,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: labelWidth,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: valueWidth,
          height: 16,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDividerPlaceholder() {
    return Container(width: 1, height: 25, color: Colors.white);
  }

  // --- REFINED SUB-COMPONENTS ---
  Widget _buildFeatureDetail(String label, String value, String unit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 8,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Color(0xFF0A2351),
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(width: 2),
            Text(
              unit,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(width: 1, height: 25, color: const Color(0xFFF1F4F8));
  }

  // --- 2. CONFIGURATION TOOLS ---
  Widget _buildTenureSelector() {
    // 1. Safely extract values converting them to String first, then parsing to double
    final double minPeriod =
        double.tryParse(loanProduct['min_period']?.toString() ?? '') ?? 0.0;
    final double maxPeriod =
        double.tryParse(loanProduct['max_period']?.toString() ?? '') ?? 0.0;

    // 2. Guard constraint: Ensure slider value stays within the parsed min/max range
    // This prevents Slider assertion crashes if data changes dynamically
    final double safeValue = _selectedTenure.clamp(
      minPeriod,
      maxPeriod > minPeriod ? maxPeriod : minPeriod + 1,
    );

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${safeValue.toInt()} Months",
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: Color(0xFF0A2351),
              ),
            ),
            Text(
              // Cleaned up string interpolation (handles null automatically)
              "Max: ${loanProduct['max_period'] ?? 0} Months",
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderThemeData(
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 0.0),
            activeTrackColor: const Color(0xFF0A2351),
            inactiveTrackColor: const Color(0xFFF1F4F8),
            thumbColor: const Color(0xFF17C6C6),
            overlayColor: const Color(0xFF17C6C6).withValues(alpha: 0.2),
          ),
          child: Slider(
            value: safeValue,
            min: minPeriod,
            max: maxPeriod > minPeriod ? maxPeriod : minPeriod + 1,
            onChanged: (val) {
              setState(() {
                _selectedTenure = val;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFrequencySelector() {
    final options = ["Weekly", "Monthly", "Quarterly"];
    return Row(
      children: options.map((opt) {
        bool isSelected = _selectedFrequency == opt;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedFrequency = opt),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF17C6C6) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : const Color(0xFFF1F4F8),
                ),
              ),
              child: Center(
                child: Text(
                  opt,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF0A2351),
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // --- 3. LIVE PREVIEW CARD ---
  Widget _buildTextAreaCard({
    required TextEditingController controller,
    String hintText = "Provide additional reasons or application notes here...",
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(
            0xFFF1F4F8,
          ), // Neutral border matching your form inputs
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        minLines: 4, // Gives it a clear "textarea" vertical footprint
        maxLines:
            null, // Allows it to expand dynamically if they type a long essay
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none, // Removes native Material border lines
          isDense: true, // Collapses unnecessary field padding
          contentPadding: EdgeInsets
              .zero, // Allows our custom container wrapper to control padding
        ),
      ),
    );
  }

  // --- HELPERS ---
  Widget _buildActionDock({
    // Signature updated to pass down the runtime builder closure
    required Function(
      Widget Function(String appId, String productId) nextRouteBuilder,
    )
    onCreateApplication,
  }) {
    final bool requiresGuarantor = loanProduct['requires_guarantor'] ?? false;
    final bool requiresChattels = loanProduct['requires_collateral'] ?? false;
    final bool requiresDocuments = loanProduct['requires_documents'] ?? false;

    // Change variable type to hold a blueprint function instead of a fixed Widget instance
    Widget Function(String appId, String productId) destinationBuilder;
    String buttonLabel;

    if (requiresGuarantor) {
      destinationBuilder = (id, productId) => AddGuarantors(appId: id);
      buttonLabel = "CONTINUE TO GUARANTORS";
    } else if (requiresChattels) {
      destinationBuilder = (id, productId) =>
          Collaterals(appId: id); // Assuming your pages accept appId
      buttonLabel = "CONTINUE TO COLLATERALS";
    } else if (requiresDocuments) {
      destinationBuilder = (id, productId) => AddStatements(appId: id);
      buttonLabel = "CONTINUE TO DOCUMENTS";
    } else {
      destinationBuilder = (id, productId) => LoanTermsConditions(appId: id);
      buttonLabel = "PROCEED TO TERMS";
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
      color: Colors.white,
      child: ElevatedButton(
        onPressed: _loading
            ? null
            : () {
                _validateField('amount', _amountController.text);
                if (formErrors['amount'] != null) return;

                // Passes the blueprint down to your server submit request handler
                onCreateApplication(destinationBuilder);
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0A2351),
          disabledBackgroundColor: const Color(
            0xFF0A2351,
          ).withValues(alpha: 0.7),
          minimumSize: const Size(double.infinity, 64),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: _loading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                buttonLabel,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
      ),
    );
  }
}

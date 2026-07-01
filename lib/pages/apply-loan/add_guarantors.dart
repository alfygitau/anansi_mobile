import 'package:app_anansi_mobile/pages/apply-loan/add_statements.dart';
import 'package:app_anansi_mobile/pages/apply-loan/collaterals.dart';
import 'package:app_anansi_mobile/pages/apply-loan/loan_terms_conditions.dart';
import 'package:app_anansi_mobile/pages/help&support/help_support.dart';
import 'package:app_anansi_mobile/services/error_service.dart';
import 'package:app_anansi_mobile/services/loan_application_service.dart';
import 'package:app_anansi_mobile/services/loan_products_service.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AddGuarantors extends StatefulWidget {
  final String appId;
  final String productId;
  const AddGuarantors({
    super.key,
    required this.appId,
    required this.productId,
  });

  @override
  State<AddGuarantors> createState() => _AddGuarantorsState();
}

class _AddGuarantorsState extends State<AddGuarantors> {
  List<Map<String, dynamic>> guarantors = [];
  Map<String, String?> formErrors = {'name': null, "mobile": null};
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _mobileFocus = FocusNode();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  Map<String, dynamic> loanProduct = {};
  bool _isLoading = false;
  bool _loading = false;
  bool adding = false;
  bool _deleting = false;
  bool _committing = false;

  bool get _isFormValid {
    return _nameController.text.trim().isNotEmpty &&
        _mobileController.text.trim().isNotEmpty;
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
        });
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> getGuarantors() async {
    _loading = true;
    try {
      final (response, errors) = await LoanApplicationService().fetchGuarantors(
        applicationId: widget.appId,
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
          guarantors = List<Map<String, dynamic>>.from(
            responseInfo['guarantors'] ?? [],
          );
        });
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> removeGuarantors(String id) async {
    _deleting = true;
    try {
      final (response, errors) = await LoanApplicationService()
          .removeGuarantors(applicationId: widget.appId, guarantorId: id);
      if (errors != null) {
        ErrorService.showActionableError(
          context,
          title: errors[0],
          message: errors[1],
        );
      } else if (response != null) {
        await getGuarantors();
      }
    } finally {
      if (mounted) setState(() => _deleting = false);
    }
  }

  Future<void> commitGuarantors(Widget nextScreen) async {
    _committing = true;
    try {
      final (response, errors) = await LoanApplicationService().commitGuarantor(
        applicationId: widget.appId,
      );
      if (errors != null) {
        ErrorService.showActionableError(
          context,
          title: errors[0],
          message: errors[1],
        );
      } else if (response != null) {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => nextScreen),
          );
        }
      }
    } finally {
      if (mounted) setState(() => _committing = false);
    }
  }

  Future<void> addGuarantors() async {
    _validateField('name', _nameController.text);
    _validateField('mobile', _mobileController.text);
    adding = true;
    try {
      final (response, errors) = await LoanApplicationService().addGuarantor(
        applicationId: widget.appId,
        name: _nameController.text.trim(),
        phone: _mobileController.text.trim(),
      );
      if (errors != null) {
        ErrorService.showActionableError(
          context,
          title: errors[0],
          message: errors[1],
        );
      } else if (response != null) {
        setState(() {
          _nameController.text = "";
          _mobileController.text = "";
        });
        await getGuarantors();
      }
    } finally {
      if (mounted) setState(() => adding = false);
    }
  }

  void _validateField(String key, String value) {
    setState(() {
      if (value.trim().isEmpty) {
        formErrors[key] = "This field is required to add guarantor";
      } else {
        formErrors[key] = null;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getLoanProduct();
    getGuarantors();

    _nameController.addListener(() => setState(() {}));
    _mobileController.addListener(() => setState(() {}));

    _nameFocus.addListener(() {
      if (!_nameFocus.hasFocus) {
        _validateField('name', _nameController.text);
      }
      setState(() {});
    });

    _mobileFocus.addListener(() {
      if (!_mobileFocus.hasFocus) {
        _validateField('mobile', _mobileController.text);
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _nameFocus.dispose();
    _mobileFocus.dispose();
    _nameController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),

          // 2. SEARCH & ADD SECTION
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPageHeader(),
                  SizedBox(height: 16),
                  _sectionTitle("Find Guarantors"),
                  const SizedBox(height: 8),
                  _isLoading
                      ? _buildGuarantorSearchSkeleton()
                      : _buildGuarantorSearchSection(),
                ],
              ),
            ),
          ),

          // 3. SELECTED GUARANTORS LIST
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  _sectionTitle("SELECTED GUARANTORS"),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),

          // 2. DYNAMIC CONTENT AREA: Handled cleanly via conditional slivers
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: _loading
                ? _buildGuarantorsSliverSkeleton()
                : guarantors.isEmpty
                ? SliverToBoxAdapter(child: _buildEmptyGuarantorState())
                : SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final g = guarantors[index];
                      final Map<dynamic, dynamic> guarantorData =
                          g['guarantor'] as Map<dynamic, dynamic>? ?? {};
                      final String guarantorId = g['id']?.toString() ?? '';
                      return _buildGuarantorCard(
                        name: guarantorData['name']?.toString() ?? "",
                        mobile: guarantorData['mobile']?.toString() ?? "",
                        onDelete: () => removeGuarantors(guarantorId),
                      );
                    }, childCount: guarantors.length),
                  ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
      bottomSheet: _buildActionDock(
        onProceed: (nextRoute) => commitGuarantors(nextRoute),
      ),
    );
  }

  Widget _buildGuarantorsSliverSkeleton() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade200,
            highlightColor: Colors.grey.shade50,
            period: const Duration(milliseconds: 1200),
            child: _buildGuarantorSkeletonItem(),
          );
        },
        childCount: 3, // Renders an optimized count of placeholder bone cards
      ),
    );
  }

  Widget _buildGuarantorSkeletonItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC), // Matches bg-slate-50
        borderRadius: BorderRadius.circular(16), // Matches rounded-2xl
        border: Border.all(
          color: const Color(0xFFE2E8F0), // Matches border-slate-200
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          // 1. LEFT SECTION: AVATAR & METADATA BONES
          Expanded(
            child: Row(
              children: [
                // Minimalist Square-Round Avatar Box Bone (Matches size 40x40)
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(width: 16), // Matches gap-4
                // Metadata Lines Block
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name Line + Verification Check Seal Row
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Name text placeholder line
                          Container(
                            width: 130,
                            height: 14,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 6),
                          // Verification Check Circle Icon bone
                          Container(
                            width: 14,
                            height: 14,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Phone Details Row Placeholder
                      Row(
                        children: [
                          // Smartphone icon placeholder bone
                          Container(
                            width: 10,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 6),
                          // "TEL: 07XXXXXXXX" full text block bone
                          Container(
                            width: 110,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2. RIGHT SECTION: TRASH DOCK ACTION PLACEHOLDER (Matches size 38x38)
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyGuarantorState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey[50], // Light background to distinguish the area
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.group_add_outlined, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            "No Guarantors Selected",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Add at least two guarantors to proceed with your loan application.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildPageHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Guarantee Coverage",
          style: TextStyle(
            color: Color(0xFF0A2351),
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Invite fellow members to vouch for your loan application to meet the required security threshold.",
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 12,
            height: 1.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
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
                "ADD GUARANTORS",
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

  // --- 3. THE GUARANTOR CARD (White Premium) ---
  Widget _buildGuarantorCard({
    required String name,
    required String mobile,
    required VoidCallback onDelete,
  }) {
    // Safe extraction for avatar initial string to prevent index range crashes
    final String cleanName = name.trim();
    final String avatarInitial = cleanName.isNotEmpty
        ? cleanName[0].toUpperCase()
        : 'G';

    // 1. MOTION ANIMATION PIPELINE: Replicates <motion.div initial={{ opacity: 0, scale: 0.95 }} animate={{ opacity: 1, scale: 1 }}>
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      builder: (context, animationValue, child) {
        return Transform.scale(
          scale:
              0.95 +
              (0.05 * animationValue), // Scales gracefully from 0.95 to 1.0
          child: Opacity(
            opacity: animationValue, // Fades smoothly from 0.0 to 1.0
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16), // Matches p-4
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC), // Matches bg-slate-50
          borderRadius: BorderRadius.circular(16), // Matches rounded-2xl
          border: Border.all(
            color: const Color(0xFFE2E8F0), // Matches border-slate-200
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            // 2. LEFT SECTION: AVATAR & METADATA BLOCK
            Expanded(
              child: Row(
                children: [
                  // Minimalist Premium Square-Round Avatar Box (size-10)
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        12,
                      ), // Matches rounded-xl
                      border: Border.all(
                        color: const Color(0xFFE2E8F0).withValues(alpha: 0.6),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        avatarInitial,
                        style: const TextStyle(
                          color: Color(0xFF334155), // Matches text-slate-700
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16), // Matches gap-4
                  // Metadata Rows
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name Line + Verification Check Seal
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                cleanName.isNotEmpty
                                    ? cleanName
                                    : "Unnamed Guarantor",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(
                                    0xFF0F172A,
                                  ), // Matches text-slate-900
                                  fontSize: 14,
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.check_circle, // Matches CheckCircle2 icon
                              size: 14,
                              color: Color(
                                0xFF10B981,
                              ), // Matches text-emerald-500
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),

                        // Aligned Details Tracking String
                        Row(
                          children: [
                            const Icon(
                              CupertinoIcons
                                  .device_phone_portrait, // Matches Smartphone icon
                              size: 12,
                              color: Color(
                                0xFFCBD5E1,
                              ), // Matches text-slate-300
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "TEL: ",
                              style: TextStyle(
                                color: const Color(
                                  0xFF94A3B8,
                                ), // Matches text-slate-400
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1.2,
                              ),
                            ),
                            Text(
                              mobile,
                              style: const TextStyle(
                                color: Color(
                                  0xFF475569,
                                ), // Matches text-slate-600
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 3. RIGHT SECTION: PREMIUM ACTION TRASH DOCK
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: InkWell(
                // 1. Double-Tap Protection: Disable interactions while the delete network request is pending
                onTap: _deleting ? null : onDelete,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFE2E8F0).withValues(alpha: 0.8),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    // 2. State Toggle: Replace the trash icon with a layout-locked spinner bone
                    child: _deleting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              color: Color(
                                0xFFFF6B6B,
                              ), // Seamlessly matches your coral-red icon theme
                              strokeWidth:
                                  2.0, // Slightly thinner line profile to look crisp in small boxes
                            ),
                          )
                        : const Icon(
                            CupertinoIcons.trash,
                            size: 15,
                            color: Color(0xFFFF6B6B),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionDock({required Function(Widget nextRoute) onProceed}) {
    final bool requiresCollateral = loanProduct['requires_collateral'] ?? false;
    final bool requiresDocuments = loanProduct['requires_documents'] ?? false;

    Widget destinationPage;
    String buttonLabel;

    if (requiresDocuments) {
      destinationPage = AddStatements(
        appId: widget.appId,
        productId: widget.productId,
      );
      buttonLabel = "CONTINUE TO STATEMENTS";
    } else if (requiresCollateral) {
      destinationPage = Collaterals(
        appId: widget.appId,
        productId: widget.productId,
      );
      buttonLabel = "CONTINUE TO COLLATERALS";
    } else {
      destinationPage = LoanTermsConditions(appId: widget.appId);
      buttonLabel = "PROCEED TO TERMS";
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
      color: Colors.white,
      child: ElevatedButton(
        // The button automatically locks down while the application is loading
        onPressed: _committing
            ? null
            : () {
                onProceed(destinationPage);
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
        child: _committing
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
                  letterSpacing: 1.2,
                ),
              ),
      ),
    );
  }

  Widget _buildGuarantorSearchSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFF1F4F8), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0A2351).withValues(alpha: 0.02),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputField(
            hint: "e.g. Alfred Kariuki Gitau",
            icon: CupertinoIcons.person_fill,
            label: "Full Name",
            fieldKey: "name",
            controller: _nameController,
            focusNode: _nameFocus,
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: 20),
          _buildInputField(
            hint: "e.g. 0712 345 678",
            icon: CupertinoIcons.phone_fill,
            keyboardType: TextInputType.phone,
            fieldKey: "mobile",
            focusNode: _mobileFocus,
            label: "Mobile Number",
            controller: _mobileController,
          ),

          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 58,
            child: ElevatedButton(
              onPressed: (_isFormValid && !adding)
                  ? () {
                      addGuarantors();
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A2351),
                foregroundColor: Colors.white,
                disabledBackgroundColor: adding
                    ? const Color(0xFF0A2351).withValues(alpha: 0.7)
                    : Colors.grey.shade300,
                disabledForegroundColor: adding
                    ? Colors.white
                    : Colors.grey.shade500,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: adding
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(CupertinoIcons.search, size: 18),
                        const SizedBox(width: 12),
                        Text(
                          "FIND GUARANTOR",
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuarantorSearchSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      period: const Duration(milliseconds: 1200),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFFF1F4F8), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Full Name Input Box Placeholder
            _buildInputFieldSkeleton(labelWidth: 70),
            const SizedBox(height: 20),

            // 2. Mobile Number Input Box Placeholder
            _buildInputFieldSkeleton(labelWidth: 100),
            const SizedBox(height: 24),

            // 3. "FIND GUARANTOR" Primary Action Button Placeholder
            Container(
              width: double.infinity,
              height: 58,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Custom Input Element Structuring Helper
  Widget _buildInputFieldSkeleton({required double labelWidth}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Field Label Line Bone
        Container(
          width: labelWidth,
          height: 12,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(height: 8),

        // Text Input Box Frame Bone
        Container(
          width: double.infinity,
          height: 54, // Matches standard mobile text form field height scales
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              14,
            ), // Gives clean input aesthetics
          ),
        ),
      ],
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
}

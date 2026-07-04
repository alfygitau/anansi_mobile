import 'package:app_anansi_mobile/components/statements/generate_statement.dart';
import 'package:app_anansi_mobile/helpers/download.dart';
import 'package:app_anansi_mobile/services/account_service.dart';
import 'package:app_anansi_mobile/services/error_service.dart';
import 'package:app_anansi_mobile/services/secure_storage_service.dart';
import 'package:app_anansi_mobile/services/statement_service.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Statements extends StatefulWidget {
  const Statements({super.key});

  @override
  State<Statements> createState() => _StatementsState();
}

class _StatementsState extends State<Statements> {
  List<Map<String, dynamic>> accounts = [];
  bool _isLoading = false;
  List<Map<String, dynamic>> accountStatements = [];
  String? selectedYear;
  String? selectedAccountId;
  String? loadingItemId;

  Future<void> fetchStatements() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final (response, error) = await StatementService().getStatements(
        year: selectedYear,
        accountId: selectedAccountId,
      );
      if (error != null) {
        ErrorService.showActionableError(
          context,
          title: error[0],
          message: error[1],
        );
      } else if (response != null) {
        final responseInfo = response.data['data'];
        setState(() {
          accountStatements = List<Map<String, dynamic>>.from(
            responseInfo ?? [],
          );
        });
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _handleFilterReset() {
    fetchStatements();
  }

  Future<void> fetchCustomerDetails() async {
    final (response, errors) = await AccountService().customerDetails();
    if (errors != null) {
      ErrorService.showActionableError(
        context,
        title: errors[0],
        message: errors[1],
      );
    } else if (response != null) {
      final responseInfo = response.data['data'];
      await SecureStorageService().write("user", responseInfo);
      setState(() {
        accounts = List<Map<String, dynamic>>.from(
          responseInfo['accounts'] ?? [],
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCustomerDetails();
    fetchStatements();
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => GenerateStatement(
                      accounts: accounts,
                      onRefreshParent:
                          fetchStatements, // Simply pass the reference here
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AnansiColors.darkBlue.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AnansiColors.darkBlue.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AnansiColors.darkBlue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          CupertinoIcons.calendar_badge_plus,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Generate Statement",
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 14,
                                color: AnansiColors.darkBlue,
                              ),
                            ),
                            Text(
                              "Instant processing of statements",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        CupertinoIcons.chevron_right,
                        size: 14,
                        color: AnansiColors.darkBlue.withValues(alpha: 0.3),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // 2. Search/Filter Row
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "RECENT STATEMENTS",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: Colors.blueGrey.shade300,
                      letterSpacing: 1.2,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showFilterBottomSheet(
                        context: context,
                        accounts: accounts,
                        currentYear: selectedYear,
                        currentAccountId: selectedAccountId,
                        onFilterApplied: (year, accountId) {
                          setState(() {
                            selectedYear = year;
                            selectedAccountId = accountId;
                          });
                          fetchStatements();
                        },
                      );
                    },
                    child: Icon(
                      CupertinoIcons.slider_horizontal_3,
                      size: 18,
                      color: Colors.blueGrey.shade300,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 3. Dynamic List Content
          // 1. Show the skeleton shimmers while loading
          if (_isLoading)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildStatementCardShimmer(),
                  childCount: 6,
                ),
              ),
            )
          else if (accountStatements.isEmpty)
            _buildStatementEmptyState(
              onResetFilters: () {
                // Clear your active query states here
                _handleFilterReset();
              },
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final statement = accountStatements[index];
                  final String statementId =
                      "${statement['id'] ?? statement['start_date'] ?? 'statement'}_$index";
                  final String uniqueFileName =
                      "Account_Statement_$statementId";
                  return _buildStatementCard(
                    statement,
                    statementId,
                    loadingItemId,
                    (id) => setState(() => loadingItemId = id),
                    () => setState(() => loadingItemId = null),
                    () async {
                      await downloadAndOpenStatement(
                        context: context,
                        url: statement['url'] ?? "",
                        fileName: uniqueFileName,
                      );
                    },
                  );
                }, childCount: accountStatements.length),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatementCard(
    Map<String, dynamic> item,
    String itemId,
    String? currentLoadingId,
    Function(String id) onStartLoading,
    Function() onEndLoading,
    Future<void> Function() onDownload,
  ) {
    final bool isThisCardDownloading = currentLoadingId == itemId;
    final String productName =
        item['product']?['name'] ?? item['title'] ?? 'Statement';
    final String statementType = item['type'] ?? 'account';
    final String reference = item['account_number'] ?? '—';
    final bool isLoan = statementType.toLowerCase() == 'loan';

    String formatDate(dynamic dateVal) {
      if (dateVal == null) return '—';
      try {
        final DateTime parsed = DateTime.parse(dateVal.toString());
        final List<String> months = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ];
        return "${parsed.day} ${months[parsed.month - 1]} ${parsed.year}";
      } catch (_) {
        return dateVal.toString();
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                // Icon Node
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: isLoan
                        ? const Color(0xFFEFF6FF)
                        : const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    isLoan ? CupertinoIcons.shield : CupertinoIcons.creditcard,
                    color: isLoan
                        ? const Color(0xFF2563EB)
                        : const Color(0xFF16A34A),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),

                // Product Text Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: AnansiColors.darkBlue,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "REF: $reference",
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF64748B),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        "Account Summary",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF334155),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(23),
                bottomRight: Radius.circular(23),
              ),
              border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Meta Block 1: Start Date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "START DATE",
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF94A3B8),
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formatDate(item['start_date'] ?? item['date']),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF334155),
                      ),
                    ),
                  ],
                ),

                // Meta Block 2: End Date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "END DATE",
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF94A3B8),
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formatDate(item['end_date'] ?? item['date']),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF334155),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: currentLoadingId != null
                      ? null
                      : () async {
                          onStartLoading(itemId);
                          try {
                            await onDownload();
                          } finally {
                            onEndLoading();
                          }
                        },
                  child: MouseRegion(
                    cursor: isThisCardDownloading
                        ? SystemMouseCursors.forbidden
                        : SystemMouseCursors.click,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: isThisCardDownloading ? 0.6 : 1.0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            isThisCardDownloading
                                ? const SizedBox(
                                    width: 14,
                                    height: 14,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AnansiColors.darkBlue,
                                      ),
                                    ),
                                  )
                                : const Icon(
                                    CupertinoIcons.cloud_download,
                                    color: AnansiColors.darkBlue,
                                    size: 14,
                                  ),
                            const SizedBox(width: 6),
                            Text(
                              isThisCardDownloading ? "SAVING..." : "PDF",
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: AnansiColors.darkBlue,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      backgroundColor: const Color(0xFFF8FAFC).withValues(alpha: 0.9),
      elevation: 0,
      centerTitle: true,
      leadingWidth: 64,
      title: const Text(
        "Account Statements",
        style: TextStyle(
          color: AnansiColors.darkBlue,
          fontWeight: FontWeight.w900,
          fontSize: 18,
          letterSpacing: -0.5,
        ),
      ),
      leading: _buildCircledIcon(
        CupertinoIcons.back,
        () => Navigator.pop(context),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: _buildCircledIcon(CupertinoIcons.cloud_download, () {}),
        ),
      ],
    );
  }

  Widget _buildStatementCardShimmer() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top section header shimmer layout
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                // Icon block placeholder
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                const SizedBox(width: 14),

                // Text info placeholder bars
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 140,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 90,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 110,
                        height: 11,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom metadata strip placeholder
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(23),
                bottomRight: Radius.circular(23),
              ),
              border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Meta Block 1: Start Date Shimmer
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      height: 8,
                      color: Colors.grey.shade100,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 70,
                      height: 12,
                      color: Colors.grey.shade100,
                    ),
                  ],
                ),

                // Meta Block 2: End Date Shimmer
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      height: 8,
                      color: Colors.grey.shade100,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 70,
                      height: 12,
                      color: Colors.grey.shade100,
                    ),
                  ],
                ),

                // Meta Block 3: Action Button Shimmer
                Container(
                  width: 55,
                  height: 26,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatementEmptyState({
    required VoidCallback onResetFilters,
    String title = "No Statements Found",
    String description =
        "We couldn't find any ledger statements matching your selected account or year criteria. Try clearing your filters or changing dates.",
  }) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withValues(alpha: 0.02),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment
              .center, // Vertically centers internal assets within the expanded frame
          children: [
            // Center Graphic Icon Container
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  CupertinoIcons.doc_text_search,
                  color: Color(0xFF94A3B8),
                  size: 36,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Color(0xFF0F172A),
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                description,
                textAlign: TextAlign.center,
                maxLines: 3,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748B),
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Reset Action Button
            TextButton.icon(
              onPressed: onResetFilters,
              icon: const Icon(CupertinoIcons.refresh_bold, size: 14),
              label: const Text(
                "RESET ACTIVE FILTERS",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF2563EB),
                backgroundColor: const Color(0xFFEFF6FF),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircledIcon(IconData icon, VoidCallback onTap) {
    return Center(
      child: Container(
        width: 40,
        height: 40,
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

  void _showFilterBottomSheet({
    required BuildContext context,
    required List<Map<String, dynamic>> accounts,
    required String? currentYear,
    required String? currentAccountId,
    required Function(String? year, String? accountId) onFilterApplied,
  }) {
    // Initialize temporary state mirrors to passed selections
    String? tempYear = currentYear;
    String? tempAccountId = currentAccountId;

    // Generate the first 5 years dynamically including the current one (2026)
    final int currentSystemYear = DateTime.now().year;
    final List<String> availableYears = List.generate(
      5,
      (index) => (currentSystemYear - index).toString(),
    );

    // Map incoming dynamic account objects safely into a string list for the dropdown UI
    final List<String> availableAccounts = accounts.map((acc) {
      return acc['product']?['name']?.toString() ??
          acc['account_number']?.toString() ??
          "Unknown Account";
    }).toList();

    // Helper utility to match the selected ID token back to its readable product name string
    String? getAccountNameFromId(String? id) {
      if (id == null) return null;
      final match = accounts.firstWhere(
        (acc) => acc['id'].toString() == id,
        orElse: () => {},
      );
      return match['product']?['name']?.toString() ??
          match['account_number']?.toString();
    }

    // Helper utility to find the true ID token from the selected text string name
    String? getAccountIdFromName(String? name) {
      if (name == null) return null;
      final match = accounts.firstWhere(
        (acc) =>
            (acc['product']?['name']?.toString() ??
                acc['account_number']?.toString()) ==
            name,
        orElse: () => {},
      );
      return match['id']?.toString();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: EdgeInsets.fromLTRB(
                24,
                16,
                24,
                24 +
                    MediaQuery.of(context).viewInsets.bottom +
                    MediaQuery.of(context).padding.bottom,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(36),
                  topRight: Radius.circular(36),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 48,
                      height: 5,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Filter Statements",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: AnansiColors.darkBlue,
                              letterSpacing: -0.3,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Refine ledger records by year and facility asset type",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                      if (tempYear != null || tempAccountId != null)
                        IconButton(
                          onPressed: () {
                            setModalState(() {
                              tempYear = null;
                              tempAccountId = null;
                            });
                          },
                          icon: const Icon(
                            CupertinoIcons.clear_circled_solid,
                            color: Color(0xFF94A3B8),
                            size: 22,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Dropdown 1: Year Parameter Selector
                  _buildDropdownField(
                    label: "Statement Year",
                    value: tempYear,
                    items: availableYears,
                    icon: CupertinoIcons.calendar,
                    onChanged: (String? val) {
                      setModalState(() => tempYear = val);
                    },
                  ),
                  const SizedBox(height: 24),

                  // Dropdown 2: Accounts Array Selector
                  _buildDropdownField(
                    label: "Select Account",
                    value: getAccountNameFromId(tempAccountId),
                    items: availableAccounts,
                    icon: CupertinoIcons.creditcard,
                    onChanged: (String? selectedName) {
                      setModalState(() {
                        tempAccountId = getAccountIdFromName(selectedName);
                      });
                    },
                  ),
                  const SizedBox(height: 36),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 56),
                            side: const BorderSide(
                              color: Color(0xFFE2E8F0),
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            foregroundColor: const Color(0xFF64748B),
                          ),
                          child: const Text(
                            "CANCEL",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);

                            // Pass the local variables back to the parent component via the callback hook ⚡
                            onFilterApplied(tempYear, tempAccountId);
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 56),
                            backgroundColor: AnansiColors.darkBlue,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            "APPLY FILTERS",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required IconData icon,
    required Function(String?) onChanged,
  }) {
    bool hasValue = value != null && value.isNotEmpty && items.contains(value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 4),
          child: Text(
            label.toUpperCase(),
            style: TextStyle(
              color: AnansiColors.darkBlue.withValues(alpha: 0.6),
              fontWeight: FontWeight.w900,
              fontSize: 11,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          height: 64, // Fixed height to match text inputs perfectly
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1.8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown:
                  true, // This aligns the menu width with the button width
              child: DropdownButton<String>(
                value: hasValue ? value : null,
                isExpanded: true, // Forces the content to span the Row
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(22),
                icon: const Padding(
                  padding: EdgeInsets.only(right: 14),
                  child: Icon(
                    CupertinoIcons.chevron_down,
                    size: 14,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                // We use the hint/selectedItem to build your custom Row inside the button
                hint: _buildDropdownRow(icon, "Select $label", isHint: true),
                selectedItemBuilder: (context) {
                  return items.map((String item) {
                    return _buildDropdownRow(icon, item, isHint: false);
                  }).toList();
                },
                items: items.map((String item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownRow(IconData icon, String text, {required bool isHint}) {
    return Row(
      children: [
        // Icon Anchor
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            size: 20,
            color: AnansiColors.darkBlue.withValues(alpha: 0.4),
          ),
        ),
        // Vertical Separator
        Container(
          height: 24,
          width: 1.5,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          color: const Color(0xFFE2E8F0),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isHint ? Colors.blueGrey.shade200 : Colors.black,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ],
    );
  }
}

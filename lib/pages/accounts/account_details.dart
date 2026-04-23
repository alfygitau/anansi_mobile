import 'package:app_anansi_mobile/helpers/format_amount.dart';
import 'package:app_anansi_mobile/helpers/format_time.dart';
import 'package:app_anansi_mobile/pages/buy-shares/shares_amount.dart';
import 'package:app_anansi_mobile/pages/deposit-savings/deposit_amount.dart';
import 'package:app_anansi_mobile/pages/help&support/help_support.dart';
import 'package:app_anansi_mobile/pages/invest/invest_amount.dart';
import 'package:app_anansi_mobile/services/account_service.dart';
import 'package:app_anansi_mobile/services/error_service.dart';
import 'package:app_anansi_mobile/shimmers/account/appbar_loader.dart';
import 'package:app_anansi_mobile/shimmers/account/card_account.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountDetails extends StatefulWidget {
  final String accountId;
  final String accountNumber;

  const AccountDetails({
    super.key,
    required this.accountId,
    required this.accountNumber,
  });

  @override
  State<AccountDetails> createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  bool _balanceVisible = true;
  bool _loading = false;
  bool _isLoading = false;
  List<Map<String, dynamic>> transactions = [];
  Map<String, dynamic> accountInfo = {};

  void fetchAccount() async {
    _isLoading = true;
    try {
      final (response, errors) = await AccountService().accounts(
        accountId: widget.accountId,
      );
      if (errors != null) {
        ErrorService.showActionableError(
          context,
          title: errors[0],
          message: errors[1],
        );
      } else if (response != null) {
        setState(() {
          accountInfo = response.data['data'] ?? {};
        });
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void fetchTransactions() async {
    _loading = true;
    try {
      final (response, errors) = await AccountService().transactions(
        accountNumber: widget.accountNumber,
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
          transactions = List<Map<String, dynamic>>.from(responseInfo ?? []);
        });
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void initState() {
    fetchAccount();
    fetchTransactions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _isLoading ? buildAppBarSkeleton() : _buildAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _getHeroState(),
                  const SizedBox(height: 24),
                  _buildQuickActions(),
                  const SizedBox(height: 20),
                  _buildTransactionHeader(),
                  _loading
                      ? buildTransactionListSkeleton()
                      : transactions.isEmpty
                      ? _buildEmptyTransactions()
                      : _buildTransactionList(),
                  const SizedBox(height: 20),
                  _buildSecurityCard(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getHeroState() {
    if (_isLoading) return buildBalanceHeroSkeleton();

    if (accountInfo.isEmpty || !accountInfo.containsKey('id')) {
      return _buildEmptyBalanceHero();
    }

    return _buildBalanceHero();
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
            "Account Details",
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
                accountInfo['product']['name']?.toString().toUpperCase() ??
                    "SAVINGS",
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

  Widget _buildEmptyTransactions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AnansiColors.darkBlue.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              CupertinoIcons.square_list,
              size: 50,
              color: AnansiColors.darkBlue.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "No Transactions Yet",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: AnansiColors.darkBlue,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Your financial journey with Anansi starts here. Once you make your first payment or receive a loan, it will appear in this list.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AnansiColors.darkBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                "Make a Deposit",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceHero() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AnansiColors.darkBlue,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AnansiColors.darkBlue.withValues(alpha: 0.3),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF17C6C6),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          accountInfo['product']['name'] ?? "N/A",
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _balanceVisible
                                ? formatAmount(accountInfo['balance'] ?? 0)
                                : "KES ••••••••",
                            style: GoogleFonts.robotoMono(
                              fontWeight: FontWeight.w900,
                              fontSize: 24,
                              color: Colors.white,
                              letterSpacing: -1,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => setState(
                            () => _balanceVisible = !_balanceVisible,
                          ),
                          icon: Icon(
                            _balanceVisible
                                ? CupertinoIcons.eye_slash_fill
                                : CupertinoIcons.eye_fill,
                            color: Colors.white38,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    border: const Border(
                      top: BorderSide(color: Colors.white10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "ACCOUNT NUMBER",
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                accountInfo['account_number'] ?? "N/A",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Monospace',
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                CupertinoIcons.doc_on_doc,
                                color: Color(0xFF17C6C6),
                                size: 14,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Icon(
                        CupertinoIcons.creditcard_fill,
                        color: Colors.white24,
                        size: 28,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyBalanceHero() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AnansiColors.darkBlue,
        borderRadius: BorderRadius.circular(32),
        // Subtle glow to keep it premium even when empty
        boxShadow: [
          BoxShadow(
            color: AnansiColors.darkBlue.withValues(alpha: 0.2),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Decorative Graphic (Optional for "Premium" feel)
          Positioned(
            right: -20,
            top: -20,
            child: Icon(
              CupertinoIcons.sparkles,
              size: 150,
              color: Colors.white.withValues(alpha: 0.03),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.white24, // Muted indicator
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "SAVINGS",
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      formatAmount(0),
                      style: GoogleFonts.robotoMono(
                        fontWeight: FontWeight.w900,
                        fontSize: 28,
                        color: Colors.white.withValues(
                          alpha: 0.5,
                        ), // Desaturated
                        letterSpacing: -1,
                      ),
                    ),
                  ],
                ),

                // Action Area for Empty State
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "No active savings yet",
                      style: TextStyle(
                        color: Colors.white24,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        // Navigate to Deposit/Top-up
                      },
                      icon: const Icon(
                        CupertinoIcons.add_circled_solid,
                        size: 18,
                      ),
                      label: const Text("Start Saving"),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF17C6C6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        backgroundColor: Colors.white.withValues(alpha: 0.05),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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

  Widget _buildQuickActions() {
    return Row(
      children: [
        (accountInfo["product"]?['name'] ?? "") == "Savings"
            ? _buildActionItem(
                label: "Save",
                icon: CupertinoIcons.arrow_down_circle_fill,
                backgroundColor: const Color(0xFF17C6C6),
                contentColor: Colors.white,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DepositAmount(id: accountInfo['id'] ?? ""),
                    ),
                  );
                },
              )
            : _buildActionItem(
                label: "Buy Shares",
                icon: Icons.pie_chart_rounded,
                backgroundColor: const Color(0xFF17C6C6),
                contentColor: Colors.white,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SharesAmount(id: accountInfo['id'] ?? ""),
                    ),
                  );
                },
              ),
        const SizedBox(width: 12),
        _buildActionItem(
          label: "Statements",
          icon: CupertinoIcons.doc_text_fill,
          backgroundColor: Colors.white,
          contentColor: AnansiColors.darkBlue,
          onTap: () {},
        ),
        const SizedBox(width: 12),
        _buildActionItem(
          label: "Invest",
          icon: CupertinoIcons.graph_square_fill,
          backgroundColor: Colors.white,
          contentColor: AnansiColors.darkBlue,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const InvestAmount()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionItem({
    required String label,
    required IconData icon,
    required Color backgroundColor,
    required Color contentColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(24),
            border: backgroundColor == Colors.white
                ? Border.all(color: Colors.black.withValues(alpha: 0.05))
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, color: contentColor, size: 24),
              const SizedBox(height: 8),
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  color: contentColor,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Recent Transactions",
          style: TextStyle(
            color: AnansiColors.darkBlue,
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(CupertinoIcons.slider_horizontal_3, size: 14),
          label: const Text(
            "FILTER",
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionList() {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final tx = transactions[index];
        final bool isDeposit = tx['status'] == 'completed';
        final Color amountColor = isDeposit
            ? const Color(0xFF10B981)
            : Colors.orange.shade700;
        return GestureDetector(
          onTap: () {
            showTransactionDetailSheet(context, tx);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFF1F5F9)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    CupertinoIcons.device_phone_portrait,
                    color: Colors.blueGrey,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tx['type'] ?? "MPESA",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                          color: AnansiColors.darkBlue,
                        ),
                      ),
                      Text(
                        "REF: ${tx['ref_number'] ?? "GFD654345WH"}",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        formatPostgresDateWithTime(
                          tx['createdAt'] ?? tx['updatedAt'],
                        ),
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formatAmount(tx['amount'] ?? 0),
                      style: TextStyle(
                        color: amountColor,
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      tx['amount'] ?? "0.0".toString().toUpperCase(),
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSecurityCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF17C6C6).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: const Color(0xFF17C6C6).withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            CupertinoIcons.shield_fill,
            color: Color(0xFF17C6C6),
            size: 32,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "SECURED BY ANANSI",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 11,
                    letterSpacing: 1,
                    color: Color(0xFF17C6C6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Your transactions are protected by 256-bit institutional grade encryption.",
                  style: TextStyle(
                    color: Colors.blueGrey.shade700,
                    fontSize: 12,
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

  void showTransactionDetailSheet(
    BuildContext context,
    Map<String, dynamic> tx,
  ) {
    final bool isDeposit = tx['deposit_method'] == 'MPESA';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 32),

            tx['status'] == 'completed'
                ? Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      CupertinoIcons.checkmark_circle_fill,
                      color: Color(0xFF10B981),
                      size: 40,
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      CupertinoIcons.timer,
                      color: Color(0xFFF59E0B),
                      size: 40,
                    ),
                  ),
            const SizedBox(height: 16),
            Text(
              tx['status'] == 'completed'
                  ? "Transaction Successful"
                  : "Transaction Pending",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),

            // Hero Amount
            Text(
              "${isDeposit ? '+' : '-'} ${formatAmount(tx['amount'])}",
              style: GoogleFonts.robotoMono(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: AnansiColors.darkBlue,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 32),

            // Detailed Info Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFF1F5F9)),
              ),
              child: Column(
                children: [
                  _buildDetailRow("Transaction Type", tx['type'] ?? "MPESA"),
                  _buildDivider(),
                  _buildDetailRow(
                    "Reference",
                    tx['ref_number'] ?? "N/A",
                    isCopyable: true,
                  ),
                  _buildDivider(),
                  _buildDetailRow(
                    "Date & Time",
                    formatPostgresDateWithTime(tx['createdAt'] ?? "N/A"),
                  ),
                  _buildDivider(),
                  _buildDetailRow("Payment Method", "M-PESA Wallet"),
                  _buildDivider(),
                  _buildDetailRow(
                    "Status",
                    "${tx['status'] ?? 'COMPLETED'}",
                    isStatus: tx['status'] == 'completed',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: CupertinoIcons.share,
                    label: "Share",
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildActionButton(
                    icon: CupertinoIcons.cloud_download,
                    label: "PDF Receipt",
                    onTap: () {},
                    isPrimary: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // --- Internal UI Helpers ---
  Widget _buildDetailRow(
    String label,
    String value, {
    bool isCopyable = false,
    bool isStatus = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
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
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  color: isStatus
                      ? const Color(0xFF10B981)
                      : AnansiColors.darkBlue,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (isCopyable) ...[
                const SizedBox(width: 6),
                const Icon(
                  CupertinoIcons.doc_on_doc,
                  size: 14,
                  color: Colors.blue,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() => Divider(color: Colors.grey.shade200, height: 1);

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isPrimary ? AnansiColors.darkBlue : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isPrimary ? Colors.transparent : Colors.grey.shade200,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isPrimary ? Colors.white : AnansiColors.darkBlue,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isPrimary ? Colors.white : AnansiColors.darkBlue,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

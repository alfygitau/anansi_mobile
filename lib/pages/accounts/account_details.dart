import 'package:app_anansi_mobile/helpers/format_amount.dart';
import 'package:app_anansi_mobile/pages/deposit-savings/deposit_amount.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
              padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBalanceHero(),
                  const SizedBox(height: 24),
                  _buildQuickActions(),
                  const SizedBox(height: 20),
                  _buildTransactionHeader(),
                  _buildTransactionList(),
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
                "SAVINGS ACCOUNT",
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
                onPressed: () {},
              ),
            ),
          ),
        ),
      ],
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
                        const Text(
                          "SAVINGS",
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
                                ? formatAmount(230000)
                                : "KES ••••••••",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
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
                                widget.accountNumber,
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

  Widget _buildQuickActions() {
    return Row(
      children: [
        _buildActionItem(
          label: "Deposit",
          icon: CupertinoIcons.arrow_down_circle_fill,
          backgroundColor: const Color(0xFF17C6C6),
          contentColor: Colors.white,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DepositAmount()),
            );
          },
        ),
        const SizedBox(width: 12),
        _buildActionItem(
          label: "Statement",
          icon: CupertinoIcons.doc_text_fill,
          backgroundColor: Colors.white,
          contentColor: AnansiColors.darkBlue,
          onTap: () => print("Deposit clicked"),
        ),
        const SizedBox(width: 12),
        _buildActionItem(
          label: "Invest",
          icon: CupertinoIcons.graph_square_fill,
          backgroundColor: Colors.white,
          contentColor: AnansiColors.darkBlue,
          onTap: () => print("Deposit clicked"),
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
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return Container(
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
                    const Text(
                      "M-PESA DEPOSIT",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        color: AnansiColors.darkBlue,
                      ),
                    ),
                    Text(
                      "12 Apr, 2026 • REF: XJ92K...",
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
                    formatAmount("2500"),
                    style: TextStyle(
                      color: Color(0xFF10B981),
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "SUCCESS",
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
}

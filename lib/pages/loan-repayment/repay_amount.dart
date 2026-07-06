import 'dart:convert';
import 'package:app_anansi_mobile/pages/help&support/help_support.dart';
import 'package:app_anansi_mobile/pages/loan-repayment/add_amount.dart';
import 'package:app_anansi_mobile/pages/loan-repayment/review_repay_details.dart';
import 'package:app_anansi_mobile/services/secure_storage_service.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RepayAmount extends StatefulWidget {
  final Map<String, dynamic>? loan;

  const RepayAmount({super.key, this.loan});

  @override
  State<RepayAmount> createState() => _RepayAmountState();
}

class _RepayAmountState extends State<RepayAmount> {
  String? _selectedOptionId;
  double? _selectedAmount;

  final NumberFormat _currencyFormatter = NumberFormat.currency(
    symbol: "KES ",
    decimalDigits: 2,
  );

  List<Map<String, dynamic>> _getPaymentOptions() {
    final nextPayment = widget.loan?['next_payment'];
    final double scheduledAmount =
        double.tryParse(nextPayment?['balance_due']?.toString() ?? '0') ?? 0.0;
    final double fullAmount =
        double.tryParse(widget.loan?['loan_Balance']?.toString() ?? '0') ?? 0.0;

    return [
      {
        "id": "minimum",
        "title": "Scheduled Payment",
        "description":
            "Cover interest and required principal to keep your loan in good standing.",
        "amount": scheduledAmount,
      },
      {
        "id": "full",
        "title": "Pay in Full",
        "description":
            "Settle the entire remaining balance and close this loan account today.",
        "amount": fullAmount,
      },
      {
        "id": "custom",
        "title": "Custom Amount",
        "description":
            "Maintain flexibility by paying any specific amount toward your balance.",
        "amount": null,
      },
    ];
  }

  void _handleOptionSelect(Map<String, dynamic> option) {
    setState(() {
      _selectedOptionId = option['id'];
      _selectedAmount = option['amount'];
    });
  }

  Future<Map<String, dynamic>?> getUser() async {
    String? userJson = await SecureStorageService().read('user');
    if (userJson == null) return null;
    Map<String, dynamic> userMap = jsonDecode(userJson);
    return userMap;
  }

  void _handleContinue() async {
    final user = await getUser();
    if (_selectedOptionId == "custom") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddAmount()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReviewRepayDetails(
            amount: double.parse(_selectedAmount?.toString() ?? "0"),
            phoneNumber: user?['mobileno'] ?? "",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final paymentOptions = _getPaymentOptions();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      bottomNavigationBar: _buildBottomActionButton(),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 10, 24, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Repayment Option",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: AnansiColors.darkBlue,
                      letterSpacing: -0.6,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Select your preferred method to settle your balance.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Divider(color: Color(0xFFE2E8F0), height: 1),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final option = paymentOptions[index];
                final bool isSelected = _selectedOptionId == option['id'];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: GestureDetector(
                    onTap: () => _handleOptionSelect(option),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AnansiColors.primary.withValues(alpha: 0.02)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? AnansiColors.primary
                              : const Color(0xFFEAECEF),
                          width: isSelected ? 2.0 : 1.5,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AnansiColors.primary.withValues(
                                    alpha: 0.06,
                                  ),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.01),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Left Section: Radio Indicator Circle
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? AnansiColors.primary
                                    : const Color(0xFFCBD5E1),
                                width: 2,
                              ),
                              color: isSelected
                                  ? AnansiColors.primary
                                  : Colors.transparent,
                            ),
                            child: isSelected
                                ? Center(
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 16),

                          // Middle Section: Title & Description
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  option['title'],
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: isSelected
                                        ? AnansiColors.primary
                                        : AnansiColors.darkBlue,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    option['description'],
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade500,
                                      fontWeight: FontWeight.w500,
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Right Section: Metric Amount Tag
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "AMOUNT",
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.grey.shade400,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                option['amount'] != null
                                    ? _currencyFormatter.format(
                                        option['amount'],
                                      )
                                    : "Flexible",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: isSelected
                                      ? AnansiColors.primary
                                      : AnansiColors.darkBlue,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }, childCount: paymentOptions.length),
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
      backgroundColor: const Color(0xFFF1F5F9).withValues(alpha: 0.9),
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      leadingWidth: 64,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Repay Loan",
            style: TextStyle(
              color: AnansiColors.darkBlue,
              fontWeight: FontWeight.w900,
              fontSize: 15,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            "EMERGENCY FUND LOAN",
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

  Widget _buildBottomActionButton() {
    final bool hasSelection = _selectedOptionId != null;

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
        disabledColor: AnansiColors.darkBlue.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        padding: const EdgeInsets.symmetric(vertical: 24),
        onPressed: hasSelection ? _handleContinue : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Continue",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
            SizedBox(width: 8),
            Icon(CupertinoIcons.arrow_right, size: 16, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

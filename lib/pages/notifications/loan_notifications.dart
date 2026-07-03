import 'dart:convert';

import 'package:app_anansi_mobile/helpers/format_time.dart';
import 'package:app_anansi_mobile/services/error_service.dart';
import 'package:app_anansi_mobile/services/notification_service.dart';
import 'package:app_anansi_mobile/services/secure_storage_service.dart';
import 'package:app_anansi_mobile/shimmers/notifications/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';

class LoanNotifications extends StatefulWidget {
  const LoanNotifications({super.key});

  @override
  State<LoanNotifications> createState() => _LoanNotificationsState();
}

class _LoanNotificationsState extends State<LoanNotifications> {
  List<Map<String, dynamic>> notifications = [];
  bool _isLoading = false;
  int? _loadingNotificationId;

  Future<Map<String, dynamic>?> getUser() async {
    String? userJson = await SecureStorageService().read('user');
    if (userJson == null) return null;
    Map<String, dynamic> userMap = jsonDecode(userJson);
    return userMap;
  }

  void fetchNotifications() async {
    _isLoading = true;
    try {
      final user = await getUser();
      final (response, errors) = await NotificationService().loanNotifications(
        customerId: user?['id'] ?? "",
      );
      if (errors != null) {
        ErrorService.showActionableError(
          context,
          title: errors[0],
          message: errors[1],
        );
      } else if (response != null) {
        notifications = List<Map<String, dynamic>>.from(
          response.data['data']['items'] ?? [],
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> readNotification(String id) async {
    final user = await getUser();
    final (response, errors) = await NotificationService().readLoanNotification(
      notificationId: id,
      customerId: user?['id'] ?? "",
    );
    if (errors != null) {
      ErrorService.showActionableError(
        context,
        title: errors[0],
        message: errors[1],
      );
    } else if (response != null) {
      if (mounted) {
        fetchNotifications();
      }
    }
  }

  @override
  void initState() {
    fetchNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          const SliverPadding(padding: EdgeInsets.only(bottom: 20)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "RECENT UPDATES",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                      height: 1,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      "Mark all as read",
                      style: TextStyle(
                        color: Color(0xFF17C6C6),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 5)),
          if (_isLoading)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => buildNotificationSkeleton(),
                childCount: 10,
              ),
            )
          else if (notifications.isEmpty)
            _buildEmptyNotifications()
          else
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final item = notifications[index];
                final bool isThisItemLoading = _loadingNotificationId == index;
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 0,
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: (_isLoading || _loadingNotificationId != null)
                        ? null
                        : () async {
                            setState(() => _loadingNotificationId = index);
                            await readNotification(item['id']);
                            setState(() => _loadingNotificationId = null);
                            showNotificationDetailSheet(context, item);
                          },
                    child: Stack(
                      children: [
                        _buildNotificationCard(
                          title: item['title'],
                          message: item['message'],
                          time: formatPostgresDateWithTime(item['created_at']),
                          type: item['type'],
                          isUnread: !item['is_read'],
                        ),
                        if (isThisItemLoading)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: const Center(
                                child: CupertinoActivityIndicator(radius: 10),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }, childCount: notifications.length),
            ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
        ],
      ),
    );
  }

  Widget _buildEmptyNotifications() {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AnansiColors.darkBlue.withValues(alpha: 0.03),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: AnansiColors.darkBlue.withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    CupertinoIcons.bell_slash,
                    size: 32,
                    color: AnansiColors.darkBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // 2. Clear, Reassuring Text
            const Text(
              "All Caught Up!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AnansiColors.darkBlue,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Your inbox is empty. We'll notify you here when there's an update on your account or marketplace orders.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40),
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: const Text(
                "Go Back",
                style: TextStyle(
                  color: AnansiColors.darkBlue,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: const Color(0xFFF8FAFC).withValues(alpha: 0.9),
      elevation: 0,
      centerTitle: true,
      leadingWidth: 64,
      title: const Text(
        "Loan Notifications",
        style: TextStyle(
          color: AnansiColors.darkBlue,
          fontWeight: FontWeight.w900,
          fontSize: 16,
        ),
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
        IconButton(
          icon: const Icon(
            CupertinoIcons.slider_horizontal_3,
            color: AnansiColors.darkBlue,
            size: 20,
          ),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  void showNotificationDetailSheet(
    BuildContext context,
    Map<String, dynamic> item,
  ) {
    IconData icon;
    Color color;
    String actionText;

    switch (item['title']) {
      case "transaction":
        icon = CupertinoIcons.arrow_up_right_circle_fill;
        color = const Color(0xFF17C6C6);
        actionText = "Guarantor response received";
        break;
      case "security":
        icon = CupertinoIcons.shield_fill;
        color = Colors.orange;
        actionText = "Secure Account";
        break;
      case "action":
        icon = CupertinoIcons.person_2_fill;
        color = AnansiColors.darkBlue;
        actionText = "View Profile";
        break;
      case "update":
      default:
        icon = CupertinoIcons.bell_fill;
        color = Colors.blue;
        actionText = "Check Update";
        break;
    }
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: color, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    item['title'].toString().toUpperCase(),
                    style: TextStyle(
                      color: color,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              item['title'].toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: AnansiColors.darkBlue,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              item['message'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              formatPostgresDateWithTime(item['created_at']),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      side: BorderSide(color: Colors.grey.shade200),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      "Close",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AnansiColors.darkBlue,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      actionText,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard({
    required String title,
    required String message,
    required String time,
    required String type,
    required bool isUnread,
  }) {
    IconData icon;
    Color color;
    switch (type) {
      case "transaction":
        icon = CupertinoIcons.arrow_up_right_circle_fill;
        color = const Color(0xFF17C6C6);
        break;
      case "security":
        icon = CupertinoIcons.shield_fill;
        color = Colors.orange;
        break;
      case "action":
        icon = CupertinoIcons.person_2_fill;
        color = AnansiColors.darkBlue;
        break;
      case "update":
      default:
        icon = CupertinoIcons.bell_fill;
        color = Colors.blue;
        break;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isUnread
              ? color.withValues(alpha: 0.2)
              : const Color(0xFFF1F4F8),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              if (isUnread)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: isUnread
                            ? AnansiColors.darkBlue
                            : Colors.blueGrey,
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                    height: 1.4,
                    fontWeight: isUnread ? FontWeight.w500 : FontWeight.w400,
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

enum NotificationType { transaction, security, action, update }

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final List<Map<String, dynamic>> notificationData = [
    {
      "title": "Investment Successful",
      "message":
          "Your deposit of KES 5,000.00 to Anansi Shares has been processed.",
      "time": "2 mins ago",
      "type": "transaction",
      "isUnread": true,
    },
    {
      "title": "Security Alert",
      "message": "New login detected from a Chrome browser on Windows.",
      "time": "1 hour ago",
      "type": "security",
      "isUnread": true,
    },
    {
      "title": "Loan Approved",
      "message":
          "Your emergency loan application of KES 15,000 has been approved.",
      "time": "Yesterday",
      "type": "update",
      "isUnread": false,
    },
    {
      "title": "Guarantor Request",
      "message": "Alfred Gitau has requested you to be a guarantor for a loan.",
      "time": "2 days ago",
      "type": "action",
      "isUnread": false,
    },
    {
      "title": "Interest Earned",
      "message":
          "You have earned KES 450.20 in interest from your savings account.",
      "time": "3 days ago",
      "type": "transaction",
      "isUnread": false,
    },
    {
      "title": "KYC Update",
      "message":
          "Please update your KRA Pin details to continue enjoying full services.",
      "time": "4 days ago",
      "type": "update",
      "isUnread": true,
    },
    {
      "title": "Password Changed",
      "message": "Your Anansi account password was successfully updated.",
      "time": "1 week ago",
      "type": "security",
      "isUnread": false,
    },
    {
      "title": "New Product",
      "message":
          "Check out the new 'Elimu' Education fund with 12% annual returns.",
      "time": "2 weeks ago",
      "type": "update",
      "isUnread": false,
    },
  ];
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
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final item = notificationData[index];
              return _buildNotificationCard(
                title: item['title'],
                message: item['message'],
                time: item['time'],
                type: item['type'],
                isUnread: item['isUnread'],
              );
            }, childCount: notificationData.length),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
        ],
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
        "Notifications",
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

  Widget _buildNotificationCard({
    required String title,
    required String message,
    required String time,
    required String type, // 👈 Change this from NotificationType to String
    required bool isUnread,
  }) {
    IconData icon;
    Color color;

    // Use String keys to match the values in your notificationData map
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
        crossAxisAlignment: CrossAxisAlignment.start,
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

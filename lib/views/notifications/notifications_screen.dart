import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Notifications',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '2 unread notifications',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 10,
              ),
            ),
          ],
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: GestureDetector(
                onTap: () {},
                child: const Text(
                  'Mark all read',
                  style: TextStyle(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildNotificationItem(
              icon: Icons.location_on_outlined,
              iconColor: Colors.blue,
              title: 'Collector Arriving',
              time: '5 min ago',
              description: 'Your waste collector is 5 minutes away',
              isUnread: true,
            ),
            const SizedBox(height: 12),
            _buildNotificationItem(
              icon: Icons.card_giftcard,
              iconColor: Colors.orange,
              title: 'EcoPoints Earned!',
              time: '2 hr ago',
              description: 'You earned 100 points for completing a pickup 2 hours ago',
              isUnread: true,
            ),
            const SizedBox(height: 12),
            _buildNotificationItem(
              icon: Icons.error_outline,
              iconColor: Colors.red,
              title: 'Bin Nearly Full',
              time: '5 hr ago',
              description: 'Your Landfill Bin is 92% full. Schedule a pickup soon.',
              isUnread: false,
            ),
            const SizedBox(height: 12),
            _buildNotificationItem(
              icon: Icons.check_circle_outline,
              iconColor: Colors.green,
              title: 'Pickup Completed',
              time: '1 day ago',
              description: 'Your general waste has been successfully collected',
              isUnread: false,
            ),
            const SizedBox(height: 12),
            _buildNotificationItem(
              icon: Icons.delete_outline,
              iconColor: Colors.grey,
              title: 'Weekly Reminder',
              time: '2 days ago',
              description: 'Don\'t forget to schedule your weekly waste pickup',
              isUnread: false,
            ),
            const SizedBox(height: 40),
            Center(
              child: Column(
                children: const [
                  Icon(Icons.notifications_none, size: 48, color: AppColors.primary),
                  SizedBox(height: 16),
                  Text(
                    'You\'re all caught up!',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String time,
    required String description,
    required bool isUnread,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUnread ? AppColors.primary : AppColors.border,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor),
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
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          time,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (isUnread)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

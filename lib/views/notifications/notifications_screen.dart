import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_images.dart';

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
          children: [
            Text(
              AppLocalizations.of(context)!.notifications,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              AppLocalizations.of(context)!.unreadNotifications('2'),
              style: const TextStyle(
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
                child: Text(
                  AppLocalizations.of(context)!.markAllRead,
                  style: const TextStyle(
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
              title: AppLocalizations.of(context)!.collectorArriving,
              time: AppLocalizations.of(context)!.minAgo('5'),
              description: AppLocalizations.of(context)!.collectorArrivingDesc,
              isUnread: true,
            ),
            const SizedBox(height: 12),
            _buildNotificationItem(
              appSvg: AppSvgs.giftImage,
              iconColor: Colors.orange,
              title: AppLocalizations.of(context)!.ecoPointsEarned,
              time: AppLocalizations.of(context)!.hrAgo('2'),
              description: AppLocalizations.of(context)!.ecoPointsEarnedDesc,
              isUnread: true,
            ),
            const SizedBox(height: 12),
            _buildNotificationItem(
              icon: Icons.error_outline,
              iconColor: Colors.red,
              title: AppLocalizations.of(context)!.binNearlyFull,
              time: AppLocalizations.of(context)!.hrAgo('5'),
              description: AppLocalizations.of(context)!.binNearlyFullDesc,
              isUnread: false,
            ),
            const SizedBox(height: 12),
            _buildNotificationItem(
              icon: Icons.check_circle_outline,
              iconColor: Colors.green,
              title: AppLocalizations.of(context)!.pickupCompleted,
              time: AppLocalizations.of(context)!.daysAgo('1'),
              description: AppLocalizations.of(context)!.pickupCompletedDesc,
              isUnread: false,
            ),
            const SizedBox(height: 12),
            _buildNotificationItem(
              appSvg: AppSvgs.binImage,
              iconColor: Colors.grey,
              title: AppLocalizations.of(context)!.weeklyReminder,
              time: AppLocalizations.of(context)!.daysAgo('2'),
              description: AppLocalizations.of(context)!.weeklyReminderDesc,
              isUnread: false,
            ),
            const SizedBox(height: 40),
            Center(
              child: Column(
                children: [
                  const Icon(Icons.notifications_none, size: 48, color: AppColors.primary),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.allCaughtUp,
                    style: const TextStyle(
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
    IconData? icon,
    String? appSvg,
    required Color iconColor,
    required String title,
    required String time,
    required String description,
    required bool isUnread,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isUnread ? AppColors.primary : AppColors.border,
              width: 1,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: appSvg != null 
                    ? SvgPicture.asset(appSvg, colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn), width: 24, height: 24)
                    : Icon(icon, color: iconColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
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
        ),
        if (isUnread)
          Positioned(
            right: -3,
            top: -3,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.background,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

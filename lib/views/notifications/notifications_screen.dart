import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_images.dart';
import '../../services/api_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  String? _error;
  int _unreadCount = 0;
  List<Map<String, dynamic>> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final response = await _apiService.get('/notifications');
      final data = (response['data'] as List<dynamic>? ?? [])
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();

      if (!mounted) return;
      setState(() {
        _notifications = data;
        _unreadCount = (response['unreadCount'] as num?)?.toInt() ?? 0;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _markAllAsRead() async {
    try {
      await _apiService.patch('/notifications/read-all', {});
      await _loadNotifications();
    } catch (_) {}
  }

  String _timeAgo(DateTime sentAt, AppLocalizations l10n) {
    final diff = DateTime.now().difference(sentAt);
    if (diff.inMinutes < 60) return l10n.minAgo('${diff.inMinutes.clamp(1, 59)}');
    if (diff.inHours < 24) return l10n.hrAgo('${diff.inHours}');
    return l10n.daysAgo('${diff.inDays}');
  }

  ({IconData? icon, String? appSvg, Color color}) _notificationVisual(String? title, String? type) {
    final normalized = (title ?? '').toLowerCase();
    if (normalized.contains('collector')) {
      return (icon: Icons.location_on_outlined, appSvg: null, color: Colors.blue);
    }
    if (normalized.contains('point')) {
      return (icon: null, appSvg: AppSvgs.giftImage, color: Colors.orange);
    }
    if (normalized.contains('full') || normalized.contains('issue')) {
      return (icon: Icons.error_outline, appSvg: null, color: Colors.red);
    }
    if (normalized.contains('completed')) {
      return (icon: Icons.check_circle_outline, appSvg: null, color: Colors.green);
    }
    if ((type ?? '').toUpperCase() == 'PUSH') {
      return (icon: Icons.notifications_active_outlined, appSvg: null, color: AppColors.primary);
    }
    return (icon: Icons.notifications_none, appSvg: null, color: Colors.grey);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
              l10n.notifications,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              l10n.unreadNotifications('$_unreadCount'),
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 10,
              ),
            ),
          ],
        ),
        actions: [
          if (_unreadCount > 0)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: GestureDetector(
                  onTap: _markAllAsRead,
                  child: Text(
                    l10n.markAllRead,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline, color: AppColors.error, size: 40),
                        const SizedBox(height: 12),
                        Text(
                          'Failed to load notifications',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                        ),
                        const SizedBox(height: 12),
                        TextButton(onPressed: _loadNotifications, child: const Text('Retry')),
                      ],
                    ),
                  ),
                )
              : _notifications.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.notifications_none, size: 48, color: AppColors.primary),
                          const SizedBox(height: 16),
                          Text(
                            l10n.allCaughtUp,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadNotifications,
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: _notifications.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = _notifications[index];
                          final title = (item['title'] ?? '').toString();
                          final body = (item['body'] ?? '').toString();
                          final isUnread = item['isRead'] != true;
                          final sentAt = DateTime.tryParse((item['sentAt'] ?? '').toString()) ?? DateTime.now();
                          final visual = _notificationVisual(title, item['type']?.toString());

                          return _buildNotificationItem(
                            icon: visual.icon,
                            appSvg: visual.appSvg,
                            iconColor: visual.color,
                            title: title,
                            time: _timeAgo(sentAt, l10n),
                            description: body,
                            isUnread: isUnread,
                          );
                        },
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
            color: isUnread ? AppColors.primary.withOpacity(0.05) : Colors.white,
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
                            style: TextStyle(
                              color: isUnread ? AppColors.textPrimary : AppColors.textSecondary,
                              fontSize: 16,
                              fontWeight: isUnread ? FontWeight.bold : FontWeight.w500,
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

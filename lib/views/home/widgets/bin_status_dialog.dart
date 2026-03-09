import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class BinStatusDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final double percentage;
  final Color color;
  final String capacity;
  final String lastEmptied;
  final String avgFillRate;
  final IconData icon;

  const BinStatusDialog({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.percentage,
    required this.color,
    required this.capacity,
    required this.lastEmptied,
    required this.avgFillRate,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isFull = percentage >= 0.75;
    final String statusText = percentage >= 0.9 ? 'Full' : (percentage >= 0.75 ? 'Nearly Full' : 'Ok');

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: AppColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 120,
                  width: 120,
                  child: CircularProgressIndicator(
                    value: percentage,
                    backgroundColor: AppColors.border.withOpacity(0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    strokeWidth: 8,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '${(percentage * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 12,
                        color: isFull ? color : AppColors.success,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildInfoColumn(Icons.delete_outline, 'Capacity', capacity),
                Container(width: 1, height: 30, color: AppColors.border),
                _buildInfoColumn(Icons.calendar_today, 'Last Emptied', lastEmptied),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.show_chart, color: AppColors.textSecondary, size: 16),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Avg Fill Rate',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    ),
                    Text(
                      avgFillRate,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (isFull) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Schedule Pickup', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(IconData icon, String label, String value) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 14),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

void showBinStatusDialog(
  BuildContext context, {
  required String title,
  required String subtitle,
  required double percentage,
  required Color color,
  required String capacity,
  required String lastEmptied,
  required String avgFillRate,
  required IconData icon,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return BinStatusDialog(
        title: title,
        subtitle: subtitle,
        percentage: percentage,
        color: color,
        capacity: capacity,
        lastEmptied: lastEmptied,
        avgFillRate: avgFillRate,
        icon: icon,
      );
    },
  );
}

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../main_layout.dart';

class PickupSuccessScreen extends StatelessWidget {
  final String date;
  final String time;
  final String reference;

  const PickupSuccessScreen({
    super.key,
    required this.date,
    required this.time,
    required this.reference,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const MainLayout()),
              (route) => false,
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: AppColors.primary,
                size: 48,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              AppLocalizations.of(context)!.pickupScheduledSuccessTitle,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.wastePickupConfirmed,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              AppLocalizations.of(context)!.referenceNumber,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              reference,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, color: AppColors.textSecondary, size: 20),
                      const SizedBox(width: 12),
                      Text(date, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.access_time_outlined, color: AppColors.textSecondary, size: 20),
                      const SizedBox(width: 12),
                      Text(time, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Text(
                    '🎉 ',
                    style: TextStyle(fontSize: 16),
                  ),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: AppLocalizations.of(context)!.earnedPointsText1,
                        style: const TextStyle(color: Colors.black87, fontSize: 12),
                        children: [
                          TextSpan(text: AppLocalizations.of(context)!.earnedPointsText2, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                          TextSpan(text: AppLocalizations.of(context)!.earnedPointsText3),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const MainLayout()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
              ),
              child: Text(AppLocalizations.of(context)!.continueBtn, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../controller/auth_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_images.dart';
import '../../l10n/app_localizations.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  int _selectedTab = 0; // 0: Overview, 1: Redeem, 2: History

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                if (Navigator.canPop(context))
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                    onPressed: () => Navigator.pop(context),
                  ),
                Text(
                  AppLocalizations.of(context)!.rewardsTitle,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1, color: Colors.grey.shade200),

          // Tabs
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                _buildTab(0, AppLocalizations.of(context)!.overview),
                const SizedBox(width: 8),
                _buildTab(1, AppLocalizations.of(context)!.redeem),
                const SizedBox(width: 8),
                _buildTab(2, AppLocalizations.of(context)!.history),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBalanceAndProgress(),
                  const SizedBox(height: 24),
                  if (_selectedTab == 0) _buildOverviewTab(),
                  if (_selectedTab == 1) _buildRedeemTab(),
                  if (_selectedTab == 2) _buildHistoryTab(),
                  const SizedBox(height: 80), // Fab space
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(int index, String title) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.orange : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceAndProgress() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,// Light beige background
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Balance Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F3E9),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orangeAccent),
            ),
            child: Column(
              children: [
                Text(AppLocalizations.of(context)!.yourBalance, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                const SizedBox(height: 8),
                const Text('2450', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text(AppLocalizations.of(context)!.ecoPoints, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
              ],
            ),
          ),
          SizedBox(height: 16),
          // Progress Card
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8F3E9),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Icons.workspace_premium_outlined, color: AppColors.textPrimary, size: 20),
                            const SizedBox(width: 8),
                            Expanded(child: Text(AppLocalizations.of(context)!.ecoWarrior, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis)),
                          ],
                        ),
                      ),
                      const Text('2450 / 5,000', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: 2450 / 5000,
                      backgroundColor: Colors.white,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(AppLocalizations.of(context)!.pointsToTierDetailed('2550', AppLocalizations.of(context)!.ecoChampion), style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ====================== OVERVIEW TAB ======================
  Widget _buildOverviewTab() {
    return Column(
      children: [
        Text(AppLocalizations.of(context)!.membershipTiers, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        const SizedBox(height: 12),
        _buildTierCard(
          title: AppLocalizations.of(context)!.ecoStarter,
          points: AppLocalizations.of(context)!.ecoStarterPoints,
          icon: Icons.star_border,
          iconColor: Colors.grey,
          isCurrent: false,
        ),
        _buildTierCard(
          title: AppLocalizations.of(context)!.ecoWarrior,
          points: AppLocalizations.of(context)!.ecoWarriorPoints,
          icon: Icons.workspace_premium_outlined,
          iconColor: AppColors.primary,
          isCurrent: true,
        ),
        _buildTierCard(
          title: AppLocalizations.of(context)!.ecoChampion,
          points: AppLocalizations.of(context)!.ecoChampionPoints,
          icon: Icons.emoji_events_outlined,
          iconColor: Colors.orange,
          isCurrent: false,
        ),
        const SizedBox(height: 24),
        Text(AppLocalizations.of(context)!.waysToEarn, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        const SizedBox(height: 12),
        _buildEarnCard(title: AppLocalizations.of(context)!.schedulePickup, subtitle: AppLocalizations.of(context)!.earnPerBooking, points: '+50', svgPath: AppSvgs.calenderImage, iconColor: AppColors.primary, iconBg: AppColors.primaryLight),
        _buildEarnCard(title: AppLocalizations.of(context)!.completePickup, subtitle: AppLocalizations.of(context)!.earnPerCompletion, points: '+100', svgPath: AppSvgs.leafImage, iconColor: Colors.blue, iconBg: Colors.blue.shade50),
        _buildEarnCard(title: AppLocalizations.of(context)!.referFriend, subtitle: AppLocalizations.of(context)!.bothGetPoints, points: '+150', svgPath: AppSvgs.profileImage, iconColor: Colors.orange, iconBg: Colors.orange.shade50),
        
        const SizedBox(height: 24),
        // Invite Friends container
        Consumer<AuthController>(
          builder: (context, auth, _) {
            final referralCode = auth.user?.referralCode ?? '—';
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.group_add_outlined, color: AppColors.primary, size: 32),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppLocalizations.of(context)!.inviteFriends, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
                        const SizedBox(height: 4),
                        Text.rich(
                          TextSpan(
                            text: AppLocalizations.of(context)!.shareYourCode,
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                            children: [
                              TextSpan(text: referralCode, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => _showShareBottomSheet(context, referralCode),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(120, 36),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            elevation: 0,
                          ),
                          child: Text(AppLocalizations.of(context)!.shareCode),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  void _showShareBottomSheet(BuildContext context, String code) {
    final shareText = 'Join SmartEco and earn eco points! Use my referral code: $code\nhttps://smarteco.app/invite';
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Share Your Code', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Invite friends and both of you earn +150 pts', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                const SizedBox(height: 20),
                // Code display box
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(code, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary, letterSpacing: 2)),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: code));
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Code copied to clipboard!'),
                              backgroundColor: AppColors.primary,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.copy, size: 18, color: AppColors.primary),
                            SizedBox(width: 4),
                            Text('Copy', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Share.share(shareText, subject: 'Join SmartEco with my referral code!');
                    },
                    icon: const Icon(Icons.share, color: Colors.white),
                    label: const Text('Share via Apps', style: TextStyle(color: Colors.white, fontSize: 15)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTierCard({required String title, required String points, required IconData icon, required Color iconColor, required bool isCurrent}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isCurrent ? AppColors.primary : Colors.grey.shade200, width: isCurrent ? 1.5 : 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(points, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          if (isCurrent)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(AppLocalizations.of(context)!.current, style: const TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }

  Widget _buildEarnCard({required String title, required String subtitle, required String points, required String svgPath, required Color iconColor, required Color iconBg}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(8)),
            child: SvgPicture.asset(
              svgPath,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              width: 20,
              height: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          Text(points, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.success, fontSize: 14)),
        ],
      ),
    );
  }

  // ====================== REDEEM TAB ======================
  Widget _buildRedeemTab() {
    return Column(
      children: [
        _buildRedeemCard(title: 'MTN Airtime', subtitle: '1,000 RWF airtime', points: '500', icon: Icons.phone_android, isLocked: false),
        _buildRedeemCard(title: 'Coffee Voucher', subtitle: 'Free coffee at local cafes', points: '300', icon: Icons.coffee_outlined, isLocked: false),
        _buildRedeemCard(title: 'Shopping Discount', subtitle: '10% off at partner stores', points: '800', icon: Icons.shopping_bag_outlined, isLocked: false),
        _buildRedeemCard(title: 'Premium Features', subtitle: '1 month premium access', points: '1500', icon: Icons.bolt, isLocked: true),
      ],
    );
  }

  Widget _buildRedeemCard({required String title, required String subtitle, required String points, required IconData icon, required bool isLocked}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isLocked ? Colors.grey.shade100 : Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8)
            ),
            child: Icon(icon, color: isLocked ? Colors.grey : Colors.orange, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isLocked ? AppColors.textSecondary : AppColors.textPrimary)),
                  Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        AppSvgs.giftImage,
                        colorFilter: ColorFilter.mode(
                          isLocked ? Colors.grey : Colors.orange,
                          BlendMode.srcIn,
                        ),
                        width: 14,
                        height: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(AppLocalizations.of(context)!.pointsCount(points), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: isLocked ? Colors.grey : Colors.black87)),
                    ],
                  ),
               ],
            ),
          ),
          if (isLocked)
            Container(
               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
               decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
               child: Text(AppLocalizations.of(context)!.locked, style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold, fontSize: 12)),
            )
          else
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(80, 36),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                backgroundColor: AppColors.primary,
                elevation: 0,
              ),
              child: Text(AppLocalizations.of(context)!.redeem, style: const TextStyle(fontSize: 12, color: Colors.white)),
            ),
        ],
      ),
    );
  }

  // ====================== HISTORY TAB ======================
  Widget _buildHistoryTab() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
         children: [
           _buildHistoryItem(context, AppLocalizations.of(context)!.schedulePickup, AppLocalizations.of(context)!.hoursAgo('2'), '+50', true),
           const Divider(height: 1),
           _buildHistoryItem(context, AppLocalizations.of(context)!.completePickup, AppLocalizations.of(context)!.daysAgo('1'), '+100', true),
           const Divider(height: 1),
           _buildHistoryItem(context, AppLocalizations.of(context)!.airtimeVoucher, AppLocalizations.of(context)!.daysAgo('2'), '-200', false),
           const Divider(height: 1),
           _buildHistoryItem(context, AppLocalizations.of(context)!.referralBonus, AppLocalizations.of(context)!.daysAgo('3'), '+150', true),
           const Divider(height: 1),
           _buildHistoryItem(context, AppLocalizations.of(context)!.weeklyStreak, AppLocalizations.of(context)!.daysAgo('5'), '+75', true),
         ],
      ),
    );
  }

  Widget _buildHistoryItem(BuildContext context, String title, String time, String points, bool isPositive) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
           Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text(time, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
             ],
           ),
           Text(points, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isPositive ? AppColors.success : AppColors.error)),
         ],
      ),
    );
  }
}

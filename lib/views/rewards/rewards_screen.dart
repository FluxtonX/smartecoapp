import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../controller/auth_controller.dart';
import '../../controller/eco_points_controller.dart';
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EcoPointsController>(context, listen: false).fetchBalanceAndHistory();
    });
  }

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
    return Consumer<EcoPointsController>(
      builder: (context, controller, _) {
        if (controller.isLoading && controller.balance == null) {
          return const Center(child: Padding(
            padding: EdgeInsets.all(24.0),
            child: CircularProgressIndicator(),
          ));
        }

        final balance = controller.balance;
        final totalPoints = balance?.totalPoints ?? 0;
        final tier = balance?.tier ?? 'ECO_STARTER';
        final nextTier = balance?.nextTier ?? 'ECO_CHAMPION';
        final pointsToNextTier = balance?.pointsToNextTier ?? 0;
        final progressPercent = (balance?.progressPercent ?? 0.0) / 100.0;
        
        String currentTierLabel = AppLocalizations.of(context)!.ecoStarter;
        if (tier == 'ECO_WARRIOR') currentTierLabel = AppLocalizations.of(context)!.ecoWarrior;
        if (tier == 'ECO_CHAMPION') currentTierLabel = AppLocalizations.of(context)!.ecoChampion;

        String nextTierLabel = AppLocalizations.of(context)!.ecoChampion;
        if (nextTier == 'ECO_WARRIOR') nextTierLabel = AppLocalizations.of(context)!.ecoWarrior;

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.transparent,
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
                    Text('$totalPoints', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    const SizedBox(height: 4),
                    Text(AppLocalizations.of(context)!.ecoPoints, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Progress Card
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF8F3E9),
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
                                Expanded(child: Text(currentTierLabel, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                          ),
                          Text('$totalPoints / ${totalPoints + pointsToNextTier}', style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progressPercent,
                          backgroundColor: Colors.white,
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (tier != 'ECO_CHAMPION')
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(AppLocalizations.of(context)!.pointsToTierDetailed('$pointsToNextTier', nextTierLabel), style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ====================== OVERVIEW TAB ======================
  Widget _buildOverviewTab() {
    return Consumer<EcoPointsController>(
      builder: (context, controller, _) {
        final tier = controller.balance?.tier ?? 'ECO_STARTER';
        return Column(
          children: [
            Text(AppLocalizations.of(context)!.membershipTiers, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 12),
            _buildTierCard(
              title: AppLocalizations.of(context)!.ecoStarter,
              points: AppLocalizations.of(context)!.ecoStarterPoints,
              icon: Icons.star_border,
              iconColor: Colors.grey,
              isCurrent: tier == 'ECO_STARTER',
            ),
            _buildTierCard(
              title: AppLocalizations.of(context)!.ecoWarrior,
              points: AppLocalizations.of(context)!.ecoWarriorPoints,
              icon: Icons.workspace_premium_outlined,
              iconColor: AppColors.primary,
              isCurrent: tier == 'ECO_WARRIOR',
            ),
            _buildTierCard(
              title: AppLocalizations.of(context)!.ecoChampion,
              points: AppLocalizations.of(context)!.ecoChampionPoints,
              icon: Icons.emoji_events_outlined,
              iconColor: Colors.orange,
              isCurrent: tier == 'ECO_CHAMPION',
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
      },
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
    return Consumer<EcoPointsController>(
      builder: (context, controller, _) {
        final totalPoints = controller.balance?.totalPoints ?? 0;
        return Column(
          children: [
            _buildRedeemCard(context, controller, 'MTN_AIRTIME', 'MTN Airtime', '1,000 RWF airtime', 500, Icons.phone_android, totalPoints < 500),
            _buildRedeemCard(context, controller, 'COFFEE_VOUCHER', 'Coffee Voucher', 'Free coffee at local cafes', 300, Icons.coffee_outlined, totalPoints < 300),
            _buildRedeemCard(context, controller, 'SHOPPING_DISCOUNT', 'Shopping Discount', '10% off at partner stores', 800, Icons.shopping_bag_outlined, totalPoints < 800),
            _buildRedeemCard(context, controller, 'PREMIUM_ACCESS', 'Premium Features', '1 month premium access', 1500, Icons.bolt, totalPoints < 1500),
          ],
        );
      },
    );
  }

  Widget _buildRedeemCard(BuildContext context, EcoPointsController controller, String rewardId, String title, String subtitle, int points, IconData icon, bool isLocked) {
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
                      Text(AppLocalizations.of(context)!.pointsCount(points.toString()), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: isLocked ? Colors.grey : Colors.black87)),
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
              onPressed: controller.isLoading ? null : () async {
                final success = await controller.redeemReward(rewardId, points, '$title - $subtitle');
                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Successfully redeemed $title!'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                } else if (context.mounted && controller.error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to redeem: ${controller.error}'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(80, 36),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                backgroundColor: AppColors.primary,
                elevation: 0,
              ),
              child: controller.isLoading 
                ? const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Text(AppLocalizations.of(context)!.redeem, style: const TextStyle(fontSize: 12, color: Colors.white)),
            ),
        ],
      ),
    );
  }

  // ====================== HISTORY TAB ======================
  Widget _buildHistoryTab() {
    return Consumer<EcoPointsController>(
      builder: (context, controller, _) {
        if (controller.isLoading && controller.history.isEmpty) {
          return const Center(child: Padding(
            padding: EdgeInsets.all(24.0),
            child: CircularProgressIndicator(),
          ));
        }

        if (controller.history.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(32),
            alignment: Alignment.center,
            child: const Text('No transactions found', style: TextStyle(color: AppColors.textSecondary)),
          );
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: controller.history.map((tx) {
              final isPositive = tx.points >= 0;
              final pointsStr = isPositive ? '+${tx.points}' : '${tx.points}';
              
              final diff = DateTime.now().difference(tx.createdAt);
              String timeStr;
              if (diff.inDays > 0) {
                timeStr = AppLocalizations.of(context)!.daysAgo(diff.inDays.toString());
              } else if (diff.inHours > 0) {
                timeStr = AppLocalizations.of(context)!.hoursAgo(diff.inHours.toString());
              } else {
                timeStr = AppLocalizations.of(context)!.minAgo(diff.inMinutes.toString());
              }

              return Column(
                children: [
                  _buildHistoryItem(
                    context, 
                    tx.description ?? tx.action.replaceAll('_', ' '), 
                    timeStr, 
                    pointsStr, 
                    isPositive
                  ),
                  if (tx != controller.history.last) const Divider(height: 1),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildHistoryItem(BuildContext context, String title, String time, String points, bool isPositive) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
           Expanded(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(time, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
               ],
             ),
           ),
           const SizedBox(width: 8),
           Text(points, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isPositive ? AppColors.success : AppColors.error)),
         ],
      ),
    );
  }
}

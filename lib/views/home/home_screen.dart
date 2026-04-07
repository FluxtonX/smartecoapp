import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../controller/auth_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_images.dart';
import '../notifications/notifications_screen.dart';
import '../pickup_scheduling/pickup_scheduling_screen.dart';
import '../schedule_pickup/schedule_pickup_screen.dart';
import 'widgets/bin_status_dialog.dart';
import '../../controller/pickup_controller.dart';
import '../../model/pickup_model.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onViewAllBins;

  const HomeScreen({super.key, this.onViewAllBins});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PickupController>(context, listen: false).fetchActivePickup();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSchedulePickupButton(context),
                  const SizedBox(height: 24),
                  _buildQuickActions(context),
                  const SizedBox(height: 24),
                  Consumer<PickupController>(
                    builder: (context, controller, child) {
                      if (controller.activePickup == null) return const SizedBox.shrink();
                      return Column(
                        children: [
                          _buildActivePickupCard(context, controller.activePickup!),
                          const SizedBox(height: 24),
                        ],
                      );
                    },
                  ),
                  _buildSmartBinsStatus(context),
                  const SizedBox(height: 100), // Space for bottom nav
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 60, left: 16, right: 16, bottom: 20),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      AppSvgs.leafImage,
                      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      width: 28,
                      height: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.goodMorning,
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      Consumer<AuthController>(
                        builder: (context, auth, _) {
                          final name = auth.user?.displayFirstName ?? 'User';
                          return Text(
                            name,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationsScreen(),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(
                            AppSvgs.notificationImage,
                            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                            width: 24,
                            height: 24,
                          ),
                        ),
                        Positioned(
                          right: 4,
                          top: 4,
                          child: Container(
                            height: 8,
                            width: 8,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      AppSvgs.profileImage,
                      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      width: 24,
                      height: 24,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildEcoPointsCard(context),
        ],
      ),
    );
  }

  Widget _buildEcoPointsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.yourEcoPoints,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Consumer<AuthController>(
                      builder: (context, auth, _) {
                        return Text(
                          auth.user?.ecoPoints?.toString() ?? '2,450',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold),
                        );
                      }
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  AppSvgs.giftImage,
                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  width: 24,
                  height: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.ecoWarrior,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '2,450 / 5,000',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: 0.49,
              backgroundColor: Colors.white30,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.pointsToTier('550'),
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildSchedulePickupButton(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: TextButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PickupSchedulingScreen()),
          );
        },
        icon: SvgPicture.asset(
          AppSvgs.calenderImage,
          colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
          width: 20,
          height: 20,
        ),
        label: Text(
          AppLocalizations.of(context)!.schedulePickup,
          style: const TextStyle(
              color: AppColors.primary,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {'svg': AppSvgs.calenderImage, 'label': (context) => AppLocalizations.of(context)!.schedule, 'color': Colors.green},
      {'svg': AppSvgs.mapImage, 'label': (context) => AppLocalizations.of(context)!.track, 'color': Colors.blue},
      {'svg': AppSvgs.binImage, 'label': (context) => AppLocalizations.of(context)!.smartBins, 'color': Colors.grey},
      {'svg': AppSvgs.giftImage, 'label': (context) => AppLocalizations.of(context)!.rewards, 'color': Colors.orange},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: actions.map((action) {
        return Expanded(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (action['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SvgPicture.asset(
                  action['svg'] as String,
                  colorFilter: ColorFilter.mode(
                    action['color'] as Color,
                    BlendMode.srcIn,
                  ),
                  width: 24,
                  height: 24,
                ),
              ),
              const SizedBox(height: 8),
              Builder(
                builder: (context) => Text(
                  (action['label'] as String Function(BuildContext))(context),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActivePickupCard(BuildContext context, PickupModel pickup) {
    String statusLabel = AppLocalizations.of(context)!.pendingStatus;
    Color statusColor = AppColors.primary;
    
    switch (pickup.status) {
      case PickupStatus.COLLECTOR_ASSIGNED:
        statusLabel = AppLocalizations.of(context)!.collectorAssignedStatus;
        statusColor = Colors.orange;
        break;
      case PickupStatus.EN_ROUTE:
        statusLabel = AppLocalizations.of(context)!.enRoute;
        statusColor = Colors.blue;
        break;
      case PickupStatus.ARRIVED:
        statusLabel = 'Arrived'; // or localized
        statusColor = Colors.green;
        break;
      default:
        // statusLabel already initialized to pendingStatus
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                AppSvgs.mapImage,
                colorFilter: ColorFilter.mode(statusColor, BlendMode.srcIn),
                width: 20,
                height: 20,
              ),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.activePickup,
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${pickup.wasteType} Waste Collection',
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 8,
                    width: 8,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    statusLabel,
                    style: TextStyle(
                        color: statusColor, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                width: 120,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SchedulePickupScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: statusColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.trackNow, 
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmartBinsStatus(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.smartBinsStatus,
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: widget.onViewAllBins ?? () {},
              child: Text(
                AppLocalizations.of(context)!.viewAll,
                style: const TextStyle(color: AppColors.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              _buildBinStatusItem(context, AppLocalizations.of(context)!.compost, AppLocalizations.of(context)!.organicWaste, 0.45, AppColors.compost, AppSvgs.leafImage, '50L', AppLocalizations.of(context)!.daysAgo('3'), '15% per day'),
              const SizedBox(width: 16),
              _buildBinStatusItem(context, AppLocalizations.of(context)!.recyclable, AppLocalizations.of(context)!.recyclableMaterials, 0.78, AppColors.recyclable, AppSvgs.recyclableImage, '75L', AppLocalizations.of(context)!.daysAgo('5'), '16% per day'),
              const SizedBox(width: 16),
              _buildBinStatusItem(context, AppLocalizations.of(context)!.eWaste, AppLocalizations.of(context)!.electronicsBatteries, 0.20, AppColors.eWaste, AppSvgs.eWasteImage, '30L', AppLocalizations.of(context)!.daysAgo('10'), '2% per day'),
              const SizedBox(width: 16),
              _buildBinStatusItem(context, AppLocalizations.of(context)!.landfill, AppLocalizations.of(context)!.generalWasteCollection, 0.98, AppColors.landfill, AppSvgs.landfillImage, '100L', AppLocalizations.of(context)!.daysAgo('6'), '15% per day', isAlert: true),
              const SizedBox(width: 16),
              _buildBinStatusItem(context, AppLocalizations.of(context)!.hazardous, AppLocalizations.of(context)!.hazardousMaterials, 0.15, AppColors.hazardous, AppSvgs.hazardousImage, '20L', AppLocalizations.of(context)!.daysAgo('15'), '1% per day'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBinStatusItem(BuildContext context, String label, String subtitle, double percentage, Color color, String svgPath, String capacity, String lastEmptied, String avgFillRate, {bool isAlert = false}) {
    return GestureDetector(
      onTap: () {
        showBinStatusDialog(
          context,
          title: '$label Bin',
          subtitle: subtitle,
          percentage: percentage,
          color: color,
          capacity: capacity,
          lastEmptied: lastEmptied,
          avgFillRate: avgFillRate,
          appSvg: svgPath,
        );
      },
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 60,
                width: 60,
                child: CircularProgressIndicator(
                  value: percentage,
                  backgroundColor: AppColors.border.withOpacity(0.5),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  strokeWidth: 6,
                ),
              ),
              Text(
                '${(percentage * 100).toInt()}%',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              if (isAlert)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.error, color: Colors.red, size: 16),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

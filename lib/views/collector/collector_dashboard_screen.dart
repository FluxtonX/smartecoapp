import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controller/collector_controller.dart';
import '../../controller/auth_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../model/collector_profile_model.dart';
import 'pickup_detail_screen.dart';

class CollectorDashboardScreen extends StatefulWidget {
  const CollectorDashboardScreen({super.key});

  @override
  State<CollectorDashboardScreen> createState() =>
      _CollectorDashboardScreenState();
}

class _CollectorDashboardScreenState extends State<CollectorDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CollectorController>(context, listen: false).loadDashboard();
    });
  }

  Future<void> _onRefresh() async {
    await Provider.of<CollectorController>(context, listen: false)
        .loadDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<CollectorController>(
        builder: (context, controller, _) {
          return RefreshIndicator(
            onRefresh: _onRefresh,
            color: AppColors.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, controller),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildKPICards(controller),
                        const SizedBox(height: 24),
                        _buildTodayScheduleSection(controller),
                        const SizedBox(height: 24),
                        if (controller.stats != null)
                          _buildPerformanceSummary(controller),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, CollectorController controller) {
    final authController = Provider.of<AuthController>(context, listen: false);
    final profile = controller.profile;
    final name = profile?.name ?? authController.user?.displayFirstName ?? '';

    return Container(
      padding: const EdgeInsets.only(top: 60, left: 16, right: 16, bottom: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, Color(0xFF1B5E20)],
        ),
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
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: const Icon(Icons.local_shipping_rounded,
                        color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome back,',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              _buildAvailabilityToggle(controller),
            ],
          ),
          if (profile != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.directions_car, color: Colors.white70, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    profile.vehiclePlate,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.location_on, color: Colors.white70, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    profile.zone,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const Spacer(),
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    profile.rating.toStringAsFixed(1),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAvailabilityToggle(CollectorController controller) {
    final isAvailable = controller.profile?.isAvailable ?? false;
    return GestureDetector(
      onTap: () => controller.toggleAvailability(!isAvailable),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isAvailable
              ? Colors.green.withOpacity(0.3)
              : Colors.red.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isAvailable ? Colors.greenAccent : Colors.redAccent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isAvailable ? Colors.greenAccent : Colors.redAccent,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              isAvailable ? 'Online' : 'Offline',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKPICards(CollectorController controller) {
    final profile = controller.profile;
    return Row(
      children: [
        _buildKPICard(
          icon: Icons.assignment,
          label: "Today's\nPickups",
          value: '${profile?.todayPickups ?? 0}',
          color: Colors.blue,
        ),
        const SizedBox(width: 12),
        _buildKPICard(
          icon: Icons.check_circle,
          label: 'Completed\nToday',
          value: '${profile?.todayCompleted ?? 0}',
          color: Colors.green,
        ),
        const SizedBox(width: 12),
        _buildKPICard(
          icon: Icons.star,
          label: 'Rating\n',
          value: (profile?.rating ?? 5.0).toStringAsFixed(1),
          color: Colors.amber,
        ),
      ],
    );
  }

  Widget _buildKPICard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayScheduleSection(CollectorController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "📋 Today's Schedule",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${controller.todayPickups.length} remaining',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (controller.isLoading && controller.todayPickups.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          )
        else if (controller.todayPickups.isEmpty)
          _buildEmptySchedule()
        else
          ...controller.todayPickups
              .map((pickup) => _buildPickupCard(pickup)),
      ],
    );
  }

  Widget _buildEmptySchedule() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Icon(Icons.check_circle_outline,
              size: 48, color: Colors.green.withOpacity(0.5)),
          const SizedBox(height: 12),
          const Text(
            'All caught up! 🎉',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'No more pickups scheduled for today.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildPickupCard(CollectorPickupModel pickup) {
    final statusColor = _getStatusColor(pickup.status);
    final statusLabel = _getStatusLabel(pickup.status);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PickupDetailScreen(pickupId: pickup.id),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: statusColor.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      _getWasteIcon(pickup.wasteType),
                      color: _getWasteColor(pickup.wasteType),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      pickup.wasteTypeLabel,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.schedule, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text(
                  pickup.timeSlotLabel,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    pickup.address,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.person_outline,
                    size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text(
                  pickup.user.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceSummary(CollectorController controller) {
    final stats = controller.stats!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '📊 Performance',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildStatRow('This Week',
                  '${stats.thisWeek.completed} pickups', '${stats.thisWeek.weightKg.toStringAsFixed(1)} kg'),
              const Divider(height: 20),
              _buildStatRow('This Month',
                  '${stats.thisMonth.completed} pickups', '${stats.thisMonth.weightKg.toStringAsFixed(1)} kg'),
              const Divider(height: 20),
              _buildStatRow('All Time',
                  '${stats.allTime.completed} pickups', '${stats.allTime.weightKg.toStringAsFixed(1)} kg'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatRow(String label, String pickups, String weight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        Row(
          children: [
            Text(
              pickups,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              weight,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'COLLECTOR_ASSIGNED':
        return Colors.orange;
      case 'EN_ROUTE':
        return Colors.blue;
      case 'ARRIVED':
        return Colors.teal;
      case 'IN_PROGRESS':
        return Colors.purple;
      default:
        return AppColors.primary;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'COLLECTOR_ASSIGNED':
        return 'Assigned';
      case 'EN_ROUTE':
        return 'En Route';
      case 'ARRIVED':
        return 'Arrived';
      case 'IN_PROGRESS':
        return 'Collecting';
      default:
        return status;
    }
  }

  IconData _getWasteIcon(String type) {
    switch (type) {
      case 'ORGANIC':
        return Icons.eco;
      case 'RECYCLABLE':
        return Icons.recycling;
      case 'EWASTE':
        return Icons.devices;
      case 'HAZARDOUS':
        return Icons.warning_amber;
      case 'GLASS':
        return Icons.local_drink;
      default:
        return Icons.delete_outline;
    }
  }

  Color _getWasteColor(String type) {
    switch (type) {
      case 'ORGANIC':
        return Colors.green;
      case 'RECYCLABLE':
        return Colors.blue;
      case 'EWASTE':
        return Colors.orange;
      case 'HAZARDOUS':
        return Colors.red;
      case 'GLASS':
        return Colors.cyan;
      default:
        return Colors.grey;
    }
  }
}

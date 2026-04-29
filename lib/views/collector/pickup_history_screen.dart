import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controller/collector_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../model/collector_profile_model.dart';

class PickupHistoryScreen extends StatefulWidget {
  const PickupHistoryScreen({super.key});

  @override
  State<PickupHistoryScreen> createState() => _PickupHistoryScreenState();
}

class _PickupHistoryScreenState extends State<PickupHistoryScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CollectorController>(context, listen: false)
          .fetchPickupHistory(refresh: true);
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      Provider.of<CollectorController>(context, listen: false)
          .fetchPickupHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Pickup History',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Consumer<CollectorController>(
        builder: (context, controller, _) {
          if (controller.isLoading && controller.pickupHistory.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (controller.pickupHistory.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () => controller.fetchPickupHistory(refresh: true),
            color: AppColors.primary,
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: controller.pickupHistory.length +
                  (controller.hasMoreHistory ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= controller.pickupHistory.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(
                          color: AppColors.primary, strokeWidth: 2),
                    ),
                  );
                }
                return _buildHistoryCard(controller.pickupHistory[index]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            'No pickup history yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your completed pickups will appear here.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(CollectorPickupModel pickup) {
    final isCompleted = pickup.status == 'COMPLETED';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                pickup.reference,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isCompleted ? 'Completed' : 'Cancelled',
                  style: TextStyle(
                    color: isCompleted ? Colors.green : Colors.red,
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
              Icon(
                _getWasteIcon(pickup.wasteType),
                size: 16,
                color: _getWasteColor(pickup.wasteType),
              ),
              const SizedBox(width: 6),
              Text(pickup.wasteTypeLabel,
                  style: const TextStyle(fontSize: 13)),
              const SizedBox(width: 16),
              const Icon(Icons.person_outline,
                  size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  pickup.user.name,
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textSecondary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  pickup.address,
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (isCompleted && pickup.weightKg != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.scale, size: 16, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(
                  '${pickup.weightKg!.toStringAsFixed(1)} kg collected',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
          if (pickup.completedAt != null) ...[
            const SizedBox(height: 8),
            Text(
              _formatDateTime(pickup.completedAt!),
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
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

  String _formatDateTime(DateTime dt) {
    final months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final hour = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} ${months[dt.month]} ${dt.year} at $hour:$min';
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controller/collector_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../model/collector_profile_model.dart';

class PickupDetailScreen extends StatefulWidget {
  final String pickupId;

  const PickupDetailScreen({super.key, required this.pickupId});

  @override
  State<PickupDetailScreen> createState() => _PickupDetailScreenState();
}

class _PickupDetailScreenState extends State<PickupDetailScreen> {
  CollectorPickupModel? _pickup;
  bool _isLoading = true;
  bool _isUpdating = false;
  final TextEditingController _weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPickup();
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _loadPickup() async {
    setState(() => _isLoading = true);
    try {
      final controller =
          Provider.of<CollectorController>(context, listen: false);
      // Find from today pickups first
      final found = controller.todayPickups
          .where((p) => p.id == widget.pickupId)
          .toList();
      if (found.isNotEmpty) {
        setState(() {
          _pickup = found.first;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateStatus(String newStatus) async {
    if (_isUpdating) return;

    if (newStatus == 'COMPLETED') {
      _showWeightDialog();
      return;
    }

    setState(() => _isUpdating = true);
    final controller =
        Provider.of<CollectorController>(context, listen: false);
    final success = await controller.updatePickupStatus(
      widget.pickupId,
      newStatus,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Status updated to ${_getStatusLabel(newStatus)}'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      await _loadPickup();
    }
    if (mounted) setState(() => _isUpdating = false);
  }

  void _showWeightDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Complete Pickup'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter the weight of waste collected (in kg):'),
            const SizedBox(height: 16),
            TextField(
              controller: _weightController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: 'e.g. 2.5',
                suffixText: 'kg',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child:
                const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              final weight = double.tryParse(_weightController.text.trim());
              if (weight == null || weight <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a valid weight'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              Navigator.pop(ctx);
              setState(() => _isUpdating = true);
              final controller = Provider.of<CollectorController>(context,
                  listen: false);
              final success = await controller.updatePickupStatus(
                widget.pickupId,
                'COMPLETED',
                weightKg: weight,
              );
              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pickup completed! 🎉'),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                Navigator.pop(context);
              }
              if (mounted) setState(() => _isUpdating = false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Complete',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _callCustomer() async {
    if (_pickup?.user.phone != null) {
      final uri = Uri(scheme: 'tel', path: _pickup!.user.phone);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    }
  }

  Future<void> _navigateToPickup() async {
    if (_pickup == null) return;
    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${_pickup!.latitude},${_pickup!.longitude}&travelmode=driving',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColors.textPrimary),
        ),
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (_pickup == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColors.textPrimary),
        ),
        body: const Center(child: Text('Pickup not found')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopBar(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: _buildStatusBar(key: ValueKey('status_${_pickup!.status}')),
                  ),
                  const SizedBox(height: 20),
                  _buildCustomerCard(),
                  const SizedBox(height: 16),
                  _buildLocationCard(),
                  const SizedBox(height: 16),
                  _buildPickupInfoCard(),
                  if (_pickup!.notes != null && _pickup!.notes!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _buildNotesCard(),
                  ],
                  const SizedBox(height: 24),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _buildActionButton(key: ValueKey('action_${_pickup!.status}')),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.only(top: 56, left: 16, right: 16, bottom: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getStatusColor(_pickup!.status),
            _getStatusColor(_pickup!.status).withOpacity(0.8),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          const Spacer(),
          Text(
            _pickup!.reference,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildStatusBar({Key? key}) {
    final steps = ['ASSIGNED', 'EN_ROUTE', 'ARRIVED', 'IN_PROGRESS', 'COMPLETED'];
    final statusMap = {
      'COLLECTOR_ASSIGNED': 0,
      'EN_ROUTE': 1,
      'ARRIVED': 2,
      'IN_PROGRESS': 3,
      'COMPLETED': 4,
    };
    final currentIndex = statusMap[_pickup!.status] ?? 0;

    return Container(
      key: key,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pickup Progress',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: List.generate(steps.length, (i) {
              final isActive = i <= currentIndex;
              final isLast = i == steps.length - 1;
              return Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive
                            ? _getStatusColor(_pickup!.status)
                            : Colors.grey.shade200,
                      ),
                      child: Icon(
                        i <= currentIndex ? Icons.check : Icons.circle,
                        size: 14,
                        color: isActive ? Colors.white : Colors.grey.shade400,
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: i < currentIndex
                              ? _getStatusColor(_pickup!.status)
                              : Colors.grey.shade200,
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: steps.map((s) {
              return SizedBox(
                width: 54,
                child: Text(
                  s.replaceAll('_', '\n'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 8, color: AppColors.textSecondary),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Customer',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: const Icon(Icons.person, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _pickup!.user.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      _pickup!.user.phone,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: _callCustomer,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.green.withOpacity(0.1),
                ),
                icon: const Icon(Icons.phone, color: Colors.green),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Location',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton.icon(
                onPressed: _navigateToPickup,
                icon: const Icon(Icons.navigation, size: 18),
                label: const Text('Navigate'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _pickup!.address,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPickupInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pickup Details',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            Icons.delete_outline,
            'Waste Type',
            _pickup!.wasteTypeLabel,
            _getWasteColor(_pickup!.wasteType),
          ),
          const SizedBox(height: 10),
          _buildInfoRow(
            Icons.schedule,
            'Time Slot',
            _pickup!.timeSlotLabel,
            Colors.blue,
          ),
          if (_pickup!.scheduledDate != null) ...[
            const SizedBox(height: 10),
            _buildInfoRow(
              Icons.calendar_today,
              'Date',
              _formatDate(_pickup!.scheduledDate!),
              Colors.purple,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNotesCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.note_alt, color: Colors.amber, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Customer Note',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _pickup!.notes!,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
      IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({Key? key}) {
    final status = _pickup!.status;
    String? nextStatus;
    String label;
    IconData icon;
    Color color;

    switch (status) {
      case 'COLLECTOR_ASSIGNED':
        nextStatus = 'EN_ROUTE';
        label = 'Start Route';
        icon = Icons.directions;
        color = Colors.blue;
        break;
      case 'EN_ROUTE':
        nextStatus = 'ARRIVED';
        label = "I've Arrived";
        icon = Icons.location_on;
        color = Colors.teal;
        break;
      case 'ARRIVED':
        nextStatus = 'IN_PROGRESS';
        label = 'Start Collection';
        icon = Icons.play_arrow;
        color = Colors.purple;
        break;
      case 'IN_PROGRESS':
        nextStatus = 'COMPLETED';
        label = 'Complete Pickup';
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      default:
        return const SizedBox.shrink();
    }

    return SizedBox(
      key: key,
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: _isUpdating ? null : () => _updateStatus(nextStatus!),
        icon: _isUpdating
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2),
              )
            : Icon(icon, color: Colors.white),
        label: Text(
          _isUpdating ? 'Updating...' : label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
        ),
      ),
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
      case 'COMPLETED':
        return Colors.green;
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
      case 'COMPLETED':
        return 'Completed';
      default:
        return status;
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

  String _formatDate(DateTime date) {
    final months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month]} ${date.year}';
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controller/collector_controller.dart';
import '../../core/theme/app_colors.dart';
import 'collector_dashboard_screen.dart';
import 'pickup_history_screen.dart';
import 'collector_profile_screen.dart';
import 'pending_approval_screen.dart';

class CollectorLayout extends StatefulWidget {
  const CollectorLayout({super.key});

  @override
  State<CollectorLayout> createState() => _CollectorLayoutState();
}

class _CollectorLayoutState extends State<CollectorLayout> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const CollectorDashboardScreen(),
    const PickupHistoryScreen(),
    const CollectorProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Load profile to check approval status
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CollectorController>(context, listen: false).fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CollectorController>(
      builder: (context, controller, _) {
        // Show pending approval screen if not approved
        if (controller.profile != null && !controller.profile!.isApproved) {
          return const PendingApprovalScreen();
        }

        return Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(Icons.dashboard_rounded, 'Dashboard', 0),
                    _buildNavItem(Icons.history_rounded, 'History', 1),
                    _buildNavItem(Icons.person_rounded, 'Profile', 2),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color:
                    isSelected ? AppColors.primary : AppColors.textSecondary,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_images.dart';
import '../../l10n/app_localizations.dart';
import 'home/home_screen.dart';
import 'profile/profile_screen.dart';
import 'bins/bins_screen.dart';
import 'rewards/rewards_screen.dart';
import 'bins/scan_tab_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  void _navigateTo(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  late final List<Widget> _screens = [
    HomeScreen(
      onViewAllBins: () => _navigateTo(1),
      onNavigateTo: _navigateTo,
    ),
    const BinsScreen(),
    const ScanTabScreen(),
    const RewardsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        padding: EdgeInsets.zero,
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, AppSvgs.leafImage, AppLocalizations.of(context)!.navHome),
            _buildNavItem(1, AppSvgs.binImage, AppLocalizations.of(context)!.navBins),
            _buildScannerItem(),
            _buildNavItem(3, AppSvgs.giftImage, AppLocalizations.of(context)!.rewards),
            _buildNavItem(4, AppSvgs.profileImage, AppLocalizations.of(context)!.profile),
          ],
        ),
      ),
    );
  }

  Widget _buildScannerItem() {
    final isSelected = _currentIndex == 2;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = 2;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.grey.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SvgPicture.asset(
              AppSvgs.qrCodeImage,
              colorFilter: ColorFilter.mode(
                isSelected ? Colors.white : AppColors.textSecondary,
                BlendMode.srcIn,
              ),
              width: 20,
              height: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            AppLocalizations.of(context)!.navScan,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String svgPath, String label) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.grey.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SvgPicture.asset(
              svgPath,
              colorFilter: ColorFilter.mode(
                isSelected ? Colors.white : AppColors.textSecondary,
                BlendMode.srcIn,
              ),
              width: 20,
              height: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

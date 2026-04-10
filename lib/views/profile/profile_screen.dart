import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../controller/auth_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_images.dart';
import '../../l10n/app_localizations.dart';
import '../../core/providers/locale_provider.dart';
import '../auth/login_screen.dart';

import 'security_settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthController>(context);
    final user = auth.user;
    final name = user?.displayFirstName ?? 'User';
    final phone = user?.phone ?? '+250 000 000 000';
    final points = user?.ecoPoints?.toString() ?? '0';
    final tier = user?.ecoTier ?? 'Eco Warrior';
    final initials = name.isNotEmpty ? name[0].toUpperCase() : 'U';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context, initials, name, phone, tier, points),
            const SizedBox(height: 56), 
            const SizedBox(height: 16),
            _buildSection(
              title: AppLocalizations.of(context)!.account,
              items: [
                _buildListItem(Icons.person_outline, AppLocalizations.of(context)!.personalInformation),
                _buildListItem(Icons.location_on_outlined, AppLocalizations.of(context)!.addresses),
                _buildListItem(Icons.phone_outlined, AppLocalizations.of(context)!.phoneNumber),
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: AppLocalizations.of(context)!.preferences,
              items: [
                _buildListItem(Icons.notifications_none, AppLocalizations.of(context)!.notifications),
                _buildListItem(
                  Icons.security_outlined, 
                  AppLocalizations.of(context)!.privacySecurity,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SecuritySettingsScreen()),
                    );
                  },
                ),
                _buildListItem(
                  Icons.language, 
                  AppLocalizations.of(context)!.language,
                  onTap: () => _showLanguageDialog(context),
                  trailing: Text(
                    _getLanguageName(Provider.of<LocaleProvider>(context, listen: false).locale?.languageCode ?? 'en', context),
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: AppLocalizations.of(context)!.support,
              items: [
                _buildListItem(Icons.help_outline, AppLocalizations.of(context)!.helpSupport),
                _buildListItem(Icons.info_outline, AppLocalizations.of(context)!.aboutSmartEco),
              ],
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: _buildListItem(
                  Icons.logout, 
                  AppLocalizations.of(context)!.logOut, 
                  isLogout: true,
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Center(
              child: Column(
                children: [
                  Text(
                    'SmartEco v1.0.0',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Made with 💚 for a cleaner Rwanda',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String initials, String name, String phone, String tier, String points) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 60, bottom: 60),
          decoration: const BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    AppLocalizations.of(context)!.profile,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 48), // Match width of IconButton for centering
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                phone,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.yellow, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      AppSvgs.badgeImage,
                      colorFilter: const ColorFilter.mode(Colors.yellow, BlendMode.srcIn),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      tier,
                      style: const TextStyle(color: Colors.yellow, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
        Positioned(
          bottom: -40,
          left: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(child: _buildStatItem('24', AppLocalizations.of(context)!.pickups)),
                Container(width: 1, height: 40, color: AppColors.border),
                Expanded(child: _buildStatItem(points, AppLocalizations.of(context)!.ecoPoints)),
                Container(width: 1, height: 40, color: AppColors.border),
                Expanded(child: _buildStatItem('156kg', AppLocalizations.of(context)!.recycled)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildSection({required String title, required List<Widget> items}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: items.asMap().entries.map((entry) {
                int index = entry.key;
                Widget item = entry.value;
                return Column(
                  children: [
                    item,
                    if (index < items.length - 1)
                      Divider(height: 1, indent: 56, color: Colors.grey.shade200),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(IconData icon, String title, {bool isLogout = false, VoidCallback? onTap, Widget? trailing}) {
    final bgColor = isLogout ? Colors.red.withOpacity(0.1) : Colors.grey.withOpacity(0.1);
    final iconColor = isLogout ? Colors.red : AppColors.textSecondary;
    final textColor = isLogout ? Colors.red : AppColors.textPrimary;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontSize: 16,
          fontWeight: isLogout ? FontWeight.bold : FontWeight.w500,
        ),
      ),
      trailing: trailing ?? Icon(Icons.chevron_right, color: iconColor),
      onTap: onTap ?? () {},
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.only(top: 12, bottom: 32, left: 24, right: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.selectLanguage,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _languageOption(context, 'en', AppLocalizations.of(context)!.english, '🇬🇧'),
            const SizedBox(height: 12),
            _languageOption(context, 'rw', AppLocalizations.of(context)!.kinyarwanda, '🇷🇼'),
            const SizedBox(height: 12),
            _languageOption(context, 'fr', AppLocalizations.of(context)!.french, '🇫🇷'),
          ],
        ),
      ),
    );
  }

  Widget _languageOption(BuildContext context, String code, String name, String emojiFlag) {
    final provider = Provider.of<LocaleProvider>(context, listen: false);
    final isSelected = provider.locale?.languageCode == code;

    return InkWell(
      onTap: () {
        provider.setLocale(Locale(code));
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.08) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              emojiFlag,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 16),
              ),
          ],
        ),
      ),
    );
  }

  String _getLanguageName(String code, BuildContext context) {
    switch (code) {
      case 'en':
        return AppLocalizations.of(context)!.english;
      case 'rw':
        return AppLocalizations.of(context)!.kinyarwanda;
      case 'fr':
        return AppLocalizations.of(context)!.french;
      default:
        return AppLocalizations.of(context)!.english;
    }
  }
}

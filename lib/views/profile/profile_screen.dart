import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_images.dart';
import '../../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../core/providers/locale_provider.dart';
import '../auth/login_screen.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 56), // Add space to prevent overlap from positioned card in header
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
                _buildListItem(Icons.security_outlined, AppLocalizations.of(context)!.privacySecurity),
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

  Widget _buildHeader(BuildContext context) {
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
                child: const Center(
                  child: Text(
                    'R',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Rahmat',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '+250 788 XXX XXX',
                style: TextStyle(color: Colors.white70, fontSize: 14),
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
                    const Text(
                      'Eco Warrior',
                      style: TextStyle(color: Colors.yellow, fontSize: 12),
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
                Expanded(child: _buildStatItem('2,450', AppLocalizations.of(context)!.ecoPoints)),
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.selectLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _languageOption(context, 'en', AppLocalizations.of(context)!.english),
            _languageOption(context, 'rw', AppLocalizations.of(context)!.kinyarwanda),
            _languageOption(context, 'fr', AppLocalizations.of(context)!.french),
          ],
        ),
      ),
    );
  }

  Widget _languageOption(BuildContext context, String code, String name) {
    final provider = Provider.of<LocaleProvider>(context, listen: false);
    final isSelected = provider.locale?.languageCode == code;

    return ListTile(
      title: Text(name),
      trailing: isSelected ? const Icon(Icons.check, color: AppColors.primary) : null,
      onTap: () {
        provider.setLocale(Locale(code));
        Navigator.pop(context);
      },
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

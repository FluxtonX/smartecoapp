import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import 'biometrics_screen.dart';
import '../../l10n/app_localizations.dart';

class AccountTypeScreen extends StatefulWidget {
  const AccountTypeScreen({super.key});

  @override
  State<AccountTypeScreen> createState() => _AccountTypeScreenState();
}

class _AccountTypeScreenState extends State<AccountTypeScreen> {
  String _selectedType = 'residential'; // 'residential' or 'business'

  void _onContinue() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const BiometricsScreen()),
    );
  }

  Widget _buildTypeCard({
    required String type,
    required String title,
    required String subtitle,
    required IconData icon,
    required List<String> benefits,
  }) {
    final isSelected = _selectedType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? Colors.white : AppColors.primary,
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check_circle, color: AppColors.primary),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            ...benefits.map((benefit) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check, color: AppColors.success, size: 12),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        benefit,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight - 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.accountType,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.chooseTypeNeeds,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 32),
                    _buildTypeCard(
                      type: 'residential',
                      title: AppLocalizations.of(context)!.residential,
                      subtitle: AppLocalizations.of(context)!.residentialDesc,
                      icon: Icons.home_outlined,
                      benefits: [
                        AppLocalizations.of(context)!.weeklyPickups,
                        AppLocalizations.of(context)!.upTo3Bins,
                        AppLocalizations.of(context)!.basicEcoPoints,
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTypeCard(
                      type: 'business',
                      title: AppLocalizations.of(context)!.businessAccount,
                      subtitle: AppLocalizations.of(context)!.businessDesc,
                      icon: Icons.domain,
                      benefits: [
                        AppLocalizations.of(context)!.dailyPickups,
                        AppLocalizations.of(context)!.unlimitedBins,
                        AppLocalizations.of(context)!.twoXEcoPoints,
                      ],
                    ),
                    const SizedBox(height: 32),
                    const SizedBox(height: 16), // Extra space for scrolling
                    CustomButton(
                      onPressed: _onContinue,
                      text: AppLocalizations.of(context)!.continueText,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import 'welcome_screen.dart';
import '../../l10n/app_localizations.dart';
import '../../core/services/biometric_service.dart';
import '../../controller/auth_controller.dart';

class BiometricsScreen extends StatefulWidget {
  final bool fromSettings;
  const BiometricsScreen({super.key, this.fromSettings = false});

  @override
  State<BiometricsScreen> createState() => _BiometricsScreenState();
}

class _BiometricsScreenState extends State<BiometricsScreen> {
  final BiometricService _biometricService = BiometricService();

  Future<void> _onEnableBiometrics() async {
    final isAvailable = await _biometricService.isBiometricAvailable();
    
    if (!isAvailable) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fingerprint hardware not found on this device.')),
        );
      }
      return;
    }

    final authenticated = await _biometricService.authenticate(
      reason: 'Please authenticate to enable fingerprint login',
    );

    if (authenticated) {
      final authController = Provider.of<AuthController>(context, listen: false);
      final token = authController.accessToken;
      
      if (token != null) {
        await _biometricService.storeToken(token);
        await _biometricService.setBiometricsEnabled(true);
      }

      if (mounted) {
        if (widget.fromSettings) {
          Navigator.pop(context, true);
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const WelcomeScreen()),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Authentication failed. Please try again or skip.')),
        );
      }
    }
  }

  void _onSkip() {
    if (widget.fromSettings) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight - 48),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 48),
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Icon(
                        Icons.fingerprint,
                        size: 80,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 48),
                    Text(
                      AppLocalizations.of(context)!.enableBiometrics,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.biometricsDesc,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 64),
                    CustomButton(
                      onPressed: _onEnableBiometrics,
                      text: AppLocalizations.of(context)!.enableBiometrics,
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      onPressed: _onSkip,
                      text: AppLocalizations.of(context)!.skipForNow,
                      isOutlined: true,
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

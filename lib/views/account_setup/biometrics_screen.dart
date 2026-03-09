import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import 'welcome_screen.dart';

class BiometricsScreen extends StatefulWidget {
  const BiometricsScreen({super.key});

  @override
  State<BiometricsScreen> createState() => _BiometricsScreenState();
}

class _BiometricsScreenState extends State<BiometricsScreen> {
  void _onEnableBiometrics() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ScanningBiometricsScreen()),
    );
  }

  void _onSkip() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
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
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
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
                'Enable Biometrics',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              Text(
                'Use your fingerprint or face ID for quick\nand secure access',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              CustomButton(
                onPressed: _onEnableBiometrics,
                text: 'Enable Biometrics',
              ),
              const SizedBox(height: 16),
              CustomButton(
                onPressed: _onSkip,
                text: 'Skip for Now',
                isOutlined: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ScanningBiometricsScreen extends StatefulWidget {
  const ScanningBiometricsScreen({super.key});

  @override
  State<ScanningBiometricsScreen> createState() => _ScanningBiometricsScreenState();
}

class _ScanningBiometricsScreenState extends State<ScanningBiometricsScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.fingerprint,
                  size: 80,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 48),
              Text(
                'Scanning...',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              Text(
                'Setting up your biometric authentication',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: 8,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(150),
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

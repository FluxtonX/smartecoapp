import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../controller/auth_controller.dart';
import 'login_screen.dart';

class CollectorPendingScreen extends StatelessWidget {
  const CollectorPendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.pending_actions_rounded,
                size: 80,
                color: Colors.orange,
              ),
              const SizedBox(height: 32),
              Text(
                'Registration Pending',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Your collector registration has been submitted and is currently awaiting admin approval. You will be notified once your account is active.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),
              CustomButton(
                onPressed: () async {
                  final authController = Provider.of<AuthController>(context, listen: false);
                  await authController.refreshProfile();
                  // The navigation will handle itself if the profile updates
                },
                text: 'Check Status',
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () async {
                  final authController = Provider.of<AuthController>(context, listen: false);
                  await authController.logout();
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  }
                },
                child: const Text(
                  'Log Out',
                  style: TextStyle(color: AppColors.error),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import 'create_account_screen.dart';
import 'verify_phone_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();

  void _onLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const VerifyPhoneScreen(isLogin: true,)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.eco, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'SmartEco',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 64),
              Center(
                child: Text(
                  'Welcome Back',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Log in to continue your smart waste journey',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),

              const SizedBox(height: 48),
              CustomTextField(
                controller: _phoneController,
                labelText: 'Phone Number',
                hintText: '+250 7XX XXX XXX',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 32),
              CustomButton(
                onPressed: _onLogin,
                text: 'Log In',
              ),
              const SizedBox(height: 24),
              Center(
                child: InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const CreateAccountScreen()),
                    );
                  },
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                      children: [
                        const TextSpan(text: 'Don\'t have an account? '),
                        TextSpan(
                          text: 'Sign Up',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

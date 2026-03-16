import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import 'login_screen.dart';
import 'verify_phone_screen.dart';
import '../../l10n/app_localizations.dart';
class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _phoneController = TextEditingController();
  final _referralController = TextEditingController();

  void _onContinue() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const VerifyPhoneScreen()),
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
              const SizedBox(height: 48),
              Center(
                child: Text(
                  AppLocalizations.of(context)!.createAccount,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  AppLocalizations.of(context)!.joinRwandaSmartWaste,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),

              const SizedBox(height: 32),
              CustomTextField(
                controller: _phoneController,
                labelText: AppLocalizations.of(context)!.phoneNumber,
                hintText: '+250 7XX XXX XXX',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _referralController,
                labelText: AppLocalizations.of(context)!.referralCode,
                hintText: '# ENTER CODE',
                prefixIcon: Icons.local_offer_outlined,
              ),
              const SizedBox(height: 32),
              CustomButton(
                onPressed: _onContinue,
                text: AppLocalizations.of(context)!.continueText,
              ),
              const SizedBox(height: 16),
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodySmall,
                    children: [
                      TextSpan(text: AppLocalizations.of(context)!.byContinuingAgree),
                      TextSpan(
                        text: AppLocalizations.of(context)!.termsOfService,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(text: AppLocalizations.of(context)!.and),
                      TextSpan(
                        text: AppLocalizations.of(context)!.privacyPolicy,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                      children: [
                        TextSpan(text: AppLocalizations.of(context)!.alreadyHaveAccount),
                        TextSpan(
                          text: AppLocalizations.of(context)!.logIn,
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
              const SizedBox(height: 48),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.verified, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.governmentCertified,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                          ),
                          Text(
                            AppLocalizations.of(context)!.authorizedByREMA,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.primary,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

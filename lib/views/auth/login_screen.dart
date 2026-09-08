import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import '../account_setup/account_type_screen.dart';
import '../../controller/auth_controller.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/social_auth_button.dart';
import 'create_account_screen.dart';
import 'select_role_screen.dart';
import 'verify_phone_screen.dart';
import '../../l10n/app_localizations.dart';
import '../../core/services/biometric_service.dart';
import '../main_layout.dart';
import '../../core/utils/navigation_utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  String _lastValidCountryCode = 'RW';
  Key _phoneFieldKey = UniqueKey();
  final BiometricService _biometricService = BiometricService();
  bool _isBiometricsEnabled = false;

  late final List<Country> _customCountries = countries.map((country) {
    if (['PK', 'RW', 'FR', 'US'].contains(country.code)) {
      return country;
    }
    return Country(
      name: '🔒 ${country.name} (Unavailable)',
      nameTranslations: const {},
      flag: country.flag,
      code: country.code,
      dialCode: country.dialCode,
      minLength: country.minLength,
      maxLength: country.maxLength,
    );
  }).toList();

  String _fullPhoneNumber = '';

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    final authController = Provider.of<AuthController>(context, listen: false);
    final enabled = await _biometricService.isBiometricsEnabled();
    final hasStoredSession = await authController.hasStoredSession;
    if (!mounted) return;
    setState(() {
      _isBiometricsEnabled = enabled && hasStoredSession;
    });
    
    // Auto-prompt if enabled
    if (_isBiometricsEnabled) {
      // Small delay to let screen settle
      Future.delayed(const Duration(milliseconds: 500), _onBiometricLogin);
    }
  }

  Future<void> _onBiometricLogin() async {
    final authenticated = await _biometricService.authenticate(
      reason: 'Use your fingerprint to login to SmartEco AI',
    );

    if (authenticated && mounted) {
      final authController = Provider.of<AuthController>(context, listen: false);
      final success = await authController.tryAutoLogin();

      if (success && mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => getLayoutForUser(authController.user)),
          (route) => false,
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authController.error ?? 'Biometric login failed'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _onLogin() async {
    if (_fullPhoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid phone number')),
      );
      return;
    }
    
    final authController = Provider.of<AuthController>(context, listen: false);
    final fullPhone = _fullPhoneNumber;
    
    final success = await authController.sendOtp(fullPhone, isLogin: true);
    
    if (success && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => VerifyPhoneScreen(isLogin: true, phoneNumber: fullPhone)),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authController.error ?? 'Failed to send OTP'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);

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
                    'SmartEco AI',
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
                  AppLocalizations.of(context)!.welcomeBack,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  AppLocalizations.of(context)!.loginToContinue,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),

              const SizedBox(height: 48),
              IntlPhoneField(
                key: _phoneFieldKey,
                controller: _phoneController,
                countries: _customCountries,
                dropdownTextStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                dropdownIconPosition: IconPosition.trailing,
                dropdownIcon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.primary,
                ),
                flagsButtonMargin: const EdgeInsets.only(left: 8),
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.phoneNumber,
                  labelStyle: const TextStyle(color: AppColors.textSecondary),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: AppColors.textSecondary.withOpacity(0.2)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.primary, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.05),
                ),
                initialCountryCode: _lastValidCountryCode,
                onChanged: (phone) {
                  _fullPhoneNumber = phone.completeNumber;
                },
                onCountryChanged: (country) {
                  if (!['PK', 'RW', 'FR', 'US'].contains(country.code)) {
                    // Revert selection
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Service is currently unavailable in ${country.name}.'),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                    setState(() {
                      _phoneFieldKey = UniqueKey();
                    });
                    return;
                  }

                  setState(() {
                    _lastValidCountryCode = country.code;
                  });

                  final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
                  if (country.code == 'FR') {
                    localeProvider.setLocale(const Locale('fr'));
                  } else if (country.code == 'RW') {
                    localeProvider.setLocale(const Locale('rw'));
                  } else {
                    localeProvider.setLocale(const Locale('en'));
                  }
                },
              ),
              const SizedBox(height: 32),
              CustomButton(
                onPressed: _onLogin,
                text: AppLocalizations.of(context)!.logIn,
                isLoading: authController.isLoading,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: Divider(color: AppColors.textSecondary.withOpacity(0.2))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      AppLocalizations.of(context)!.orContinueWith,
                      style: TextStyle(color: AppColors.textSecondary.withOpacity(0.5), fontSize: 13),
                    ),
                  ),
                  Expanded(child: Divider(color: AppColors.textSecondary.withOpacity(0.2))),
                ],
              ),
              const SizedBox(height: 24),
              SocialAuthButton(
                onPressed: () async {
                  final success = await authController.signInWithGoogle();
                  if (success && mounted) {
                    if (authController.user?.userType == null) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const AccountTypeScreen()),
                        (route) => false,
                      );
                    } else {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => getLayoutForUser(authController.user)),
                        (route) => false,
                      );
                    }
                  } else if (mounted && authController.error != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(authController.error!), backgroundColor: AppColors.error),
                    );
                  }
                },
                icon: 'assets/google.svg',
                label: 'Google',
              ),
              const SizedBox(height: 24),
              Center(
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const SelectRoleScreen()),
                        );
                      },
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                          children: [
                            TextSpan(text: AppLocalizations.of(context)!.dontHaveAccount),
                            TextSpan(
                              text: AppLocalizations.of(context)!.signUp,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_isBiometricsEnabled) ...[
                      const SizedBox(height: 32),
                      InkWell(
                        onTap: _onBiometricLogin,
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.08),
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.primary.withOpacity(0.15)),
                          ),
                          child: const Icon(
                            Icons.fingerprint,
                            size: 40,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                    ],
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

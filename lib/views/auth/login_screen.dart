import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import 'create_account_screen.dart';
import 'verify_phone_screen.dart';
import '../../l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  String _lastValidCountryCode = 'RW';
  Key _phoneFieldKey = UniqueKey();

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
                  // You can handle phone number changes here
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
                        TextSpan(text: AppLocalizations.of(context)!.dontHaveAccount),
                        TextSpan(
                          text: AppLocalizations.of(context)!.signUp,
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

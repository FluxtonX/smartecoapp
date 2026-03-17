import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import '../../core/providers/locale_provider.dart';
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

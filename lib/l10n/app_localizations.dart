import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_rw.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
    Locale('rw'),
  ];

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get goodMorning;

  /// No description provided for @yourEcoPoints.
  ///
  /// In en, this message translates to:
  /// **'Your EcoPoints'**
  String get yourEcoPoints;

  /// No description provided for @ecoWarrior.
  ///
  /// In en, this message translates to:
  /// **'Eco Warrior'**
  String get ecoWarrior;

  /// No description provided for @pointsToTier.
  ///
  /// In en, this message translates to:
  /// **'{points} points to Eco Champion tier'**
  String pointsToTier(String points);

  /// No description provided for @schedulePickup.
  ///
  /// In en, this message translates to:
  /// **'Schedule Pickup'**
  String get schedulePickup;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @track.
  ///
  /// In en, this message translates to:
  /// **'Track'**
  String get track;

  /// No description provided for @smartBins.
  ///
  /// In en, this message translates to:
  /// **'Smart Bins'**
  String get smartBins;

  /// No description provided for @rewards.
  ///
  /// In en, this message translates to:
  /// **'Rewards'**
  String get rewards;

  /// No description provided for @activePickup.
  ///
  /// In en, this message translates to:
  /// **'Active Pickup'**
  String get activePickup;

  /// No description provided for @generalWasteCollection.
  ///
  /// In en, this message translates to:
  /// **'General waste collection'**
  String get generalWasteCollection;

  /// No description provided for @enRoute.
  ///
  /// In en, this message translates to:
  /// **'En route'**
  String get enRoute;

  /// No description provided for @trackNow.
  ///
  /// In en, this message translates to:
  /// **'Track Now'**
  String get trackNow;

  /// No description provided for @smartBinsStatus.
  ///
  /// In en, this message translates to:
  /// **'Smart Bins Status'**
  String get smartBinsStatus;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @addresses.
  ///
  /// In en, this message translates to:
  /// **'Addresses'**
  String get addresses;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @privacySecurity.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security'**
  String get privacySecurity;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @aboutSmartEco.
  ///
  /// In en, this message translates to:
  /// **'About SmartEco'**
  String get aboutSmartEco;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @pickups.
  ///
  /// In en, this message translates to:
  /// **'Pickups'**
  String get pickups;

  /// No description provided for @ecoPoints.
  ///
  /// In en, this message translates to:
  /// **'EcoPoints'**
  String get ecoPoints;

  /// No description provided for @recycled.
  ///
  /// In en, this message translates to:
  /// **'Recycled'**
  String get recycled;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @kinyarwanda.
  ///
  /// In en, this message translates to:
  /// **'Kinyarwanda'**
  String get kinyarwanda;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @loginToContinue.
  ///
  /// In en, this message translates to:
  /// **'Log in to continue your smart waste journey'**
  String get loginToContinue;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logIn;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get orContinueWith;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @joinRwandaSmartWaste.
  ///
  /// In en, this message translates to:
  /// **'Join Rwanda\'s smart waste management platform'**
  String get joinRwandaSmartWaste;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get email;

  /// No description provided for @referralCode.
  ///
  /// In en, this message translates to:
  /// **'Referral Code (Optional)'**
  String get referralCode;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @userSignupText.
  ///
  /// In en, this message translates to:
  /// **'Register as a User'**
  String get userSignupText;

  /// No description provided for @collectorSignupText.
  ///
  /// In en, this message translates to:
  /// **'Register as a Collector'**
  String get collectorSignupText;

  /// No description provided for @byContinuingAgree.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our '**
  String get byContinuingAgree;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **' and\n'**
  String get and;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @governmentCertified.
  ///
  /// In en, this message translates to:
  /// **'Government Certified'**
  String get governmentCertified;

  /// No description provided for @authorizedByREMA.
  ///
  /// In en, this message translates to:
  /// **'Authorized by Rwanda Environment Management Authority'**
  String get authorizedByREMA;

  /// No description provided for @onboarding1Title.
  ///
  /// In en, this message translates to:
  /// **'Smart Waste Management'**
  String get onboarding1Title;

  /// No description provided for @onboarding1Desc.
  ///
  /// In en, this message translates to:
  /// **'Schedule pickups, track collectors, and manage waste efficiently with our innovative platform.'**
  String get onboarding1Desc;

  /// No description provided for @onboarding2Title.
  ///
  /// In en, this message translates to:
  /// **'Real-Time Tracking'**
  String get onboarding2Title;

  /// No description provided for @onboarding2Desc.
  ///
  /// In en, this message translates to:
  /// **'Monitor your waste collector in real-time with live GPS tracking and accurate ETAs.'**
  String get onboarding2Desc;

  /// No description provided for @onboarding3Title.
  ///
  /// In en, this message translates to:
  /// **'Earn EcoPoints'**
  String get onboarding3Title;

  /// No description provided for @onboarding3Desc.
  ///
  /// In en, this message translates to:
  /// **'Get rewarded for proper waste management. Redeem points for exciting rewards and benefits.'**
  String get onboarding3Desc;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next >'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @totalFillRate.
  ///
  /// In en, this message translates to:
  /// **'Total Fill Rate'**
  String get totalFillRate;

  /// No description provided for @scanBin.
  ///
  /// In en, this message translates to:
  /// **'Scan Bin'**
  String get scanBin;

  /// No description provided for @compostBin.
  ///
  /// In en, this message translates to:
  /// **'Compost Bin'**
  String get compostBin;

  /// No description provided for @compost.
  ///
  /// In en, this message translates to:
  /// **'Compost'**
  String get compost;

  /// No description provided for @organicWaste.
  ///
  /// In en, this message translates to:
  /// **'Organic Waste'**
  String get organicWaste;

  /// No description provided for @recyclingBin.
  ///
  /// In en, this message translates to:
  /// **'Recycling Bin'**
  String get recyclingBin;

  /// No description provided for @recyclable.
  ///
  /// In en, this message translates to:
  /// **'Recyclable'**
  String get recyclable;

  /// No description provided for @recyclableMaterials.
  ///
  /// In en, this message translates to:
  /// **'Recyclable Materials'**
  String get recyclableMaterials;

  /// No description provided for @eWasteBin.
  ///
  /// In en, this message translates to:
  /// **'E-Waste Bin'**
  String get eWasteBin;

  /// No description provided for @eWaste.
  ///
  /// In en, this message translates to:
  /// **'E-Waste'**
  String get eWaste;

  /// No description provided for @electronicsBatteries.
  ///
  /// In en, this message translates to:
  /// **'Electronics & Batteries'**
  String get electronicsBatteries;

  /// No description provided for @landfillBin.
  ///
  /// In en, this message translates to:
  /// **'Landfill Bin'**
  String get landfillBin;

  /// No description provided for @landfill.
  ///
  /// In en, this message translates to:
  /// **'Landfill'**
  String get landfill;

  /// No description provided for @hazardousBin.
  ///
  /// In en, this message translates to:
  /// **'Hazardous Bin'**
  String get hazardousBin;

  /// No description provided for @hazardous.
  ///
  /// In en, this message translates to:
  /// **'Hazardous'**
  String get hazardous;

  /// No description provided for @hazardousMaterials.
  ///
  /// In en, this message translates to:
  /// **'Hazardous Materials'**
  String get hazardousMaterials;

  /// No description provided for @statusOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get statusOk;

  /// No description provided for @statusNearlyFull.
  ///
  /// In en, this message translates to:
  /// **'Nearly Full'**
  String get statusNearlyFull;

  /// No description provided for @statusFull.
  ///
  /// In en, this message translates to:
  /// **'Full'**
  String get statusFull;

  /// No description provided for @fillLevel.
  ///
  /// In en, this message translates to:
  /// **'Fill Level'**
  String get fillLevel;

  /// No description provided for @lastEmptied.
  ///
  /// In en, this message translates to:
  /// **'Last: {time}'**
  String lastEmptied(Object time);

  /// No description provided for @smartTip.
  ///
  /// In en, this message translates to:
  /// **'Smart Tip'**
  String get smartTip;

  /// No description provided for @landfillFullTip.
  ///
  /// In en, this message translates to:
  /// **'Your Landfill Bin is full. Schedule a pickup to earn EcoPoints and keep your bins clean!'**
  String get landfillFullTip;

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String daysAgo(Object count);

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @verifyPhone.
  ///
  /// In en, this message translates to:
  /// **'Verify Phone'**
  String get verifyPhone;

  /// No description provided for @enterCodeSent.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code sent to\n{phone}'**
  String enterCodeSent(Object phone);

  /// No description provided for @resendCodeIn.
  ///
  /// In en, this message translates to:
  /// **'Resend code in {seconds}s'**
  String resendCodeIn(Object seconds);

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCode;

  /// No description provided for @maxAttemptsReached.
  ///
  /// In en, this message translates to:
  /// **'Maximum resend attempts reached'**
  String get maxAttemptsReached;

  /// No description provided for @verifyTip.
  ///
  /// In en, this message translates to:
  /// **'Tip: Check your messages for a code from '**
  String get verifyTip;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @accountType.
  ///
  /// In en, this message translates to:
  /// **'Account Type'**
  String get accountType;

  /// No description provided for @chooseTypeNeeds.
  ///
  /// In en, this message translates to:
  /// **'Choose the type that best fits your needs'**
  String get chooseTypeNeeds;

  /// No description provided for @residential.
  ///
  /// In en, this message translates to:
  /// **'Residential'**
  String get residential;

  /// No description provided for @residentialDesc.
  ///
  /// In en, this message translates to:
  /// **'For individual households and families'**
  String get residentialDesc;

  /// No description provided for @weeklyPickups.
  ///
  /// In en, this message translates to:
  /// **'Weekly pickups'**
  String get weeklyPickups;

  /// No description provided for @upTo3Bins.
  ///
  /// In en, this message translates to:
  /// **'Up to 3 bins'**
  String get upTo3Bins;

  /// No description provided for @basicEcoPoints.
  ///
  /// In en, this message translates to:
  /// **'Basic EcoPoints'**
  String get basicEcoPoints;

  /// No description provided for @businessAccount.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get businessAccount;

  /// No description provided for @businessDesc.
  ///
  /// In en, this message translates to:
  /// **'For businesses and commercial properties'**
  String get businessDesc;

  /// No description provided for @dailyPickups.
  ///
  /// In en, this message translates to:
  /// **'Daily pickups'**
  String get dailyPickups;

  /// No description provided for @unlimitedBins.
  ///
  /// In en, this message translates to:
  /// **'Unlimited bins'**
  String get unlimitedBins;

  /// No description provided for @twoXEcoPoints.
  ///
  /// In en, this message translates to:
  /// **'2x EcoPoints'**
  String get twoXEcoPoints;

  /// No description provided for @enableBiometrics.
  ///
  /// In en, this message translates to:
  /// **'Enable Biometrics'**
  String get enableBiometrics;

  /// No description provided for @biometricsDesc.
  ///
  /// In en, this message translates to:
  /// **'Use your fingerprint or face ID for quick\nand secure access'**
  String get biometricsDesc;

  /// No description provided for @skipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for Now'**
  String get skipForNow;

  /// No description provided for @scanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning...'**
  String get scanning;

  /// No description provided for @biometricsSetupDesc.
  ///
  /// In en, this message translates to:
  /// **'Setting up your biometric authentication'**
  String get biometricsSetupDesc;

  /// No description provided for @welcomeBonus.
  ///
  /// In en, this message translates to:
  /// **'Welcome Bonus!'**
  String get welcomeBonus;

  /// No description provided for @earnedFirstEcoPoints.
  ///
  /// In en, this message translates to:
  /// **'You\'ve earned your first EcoPoints'**
  String get earnedFirstEcoPoints;

  /// No description provided for @startUsingSmartEco.
  ///
  /// In en, this message translates to:
  /// **'Start Using SmartEco'**
  String get startUsingSmartEco;

  /// No description provided for @rewardsTitle.
  ///
  /// In en, this message translates to:
  /// **'EcoPoints Rewards'**
  String get rewardsTitle;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @redeem.
  ///
  /// In en, this message translates to:
  /// **'Redeem'**
  String get redeem;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @yourBalance.
  ///
  /// In en, this message translates to:
  /// **'Your Balance'**
  String get yourBalance;

  /// No description provided for @pointsToTierDetailed.
  ///
  /// In en, this message translates to:
  /// **'{points} points to {tier}'**
  String pointsToTierDetailed(Object points, Object tier);

  /// No description provided for @membershipTiers.
  ///
  /// In en, this message translates to:
  /// **'Membership Tiers'**
  String get membershipTiers;

  /// No description provided for @ecoStarter.
  ///
  /// In en, this message translates to:
  /// **'Eco Starter'**
  String get ecoStarter;

  /// No description provided for @ecoStarterPoints.
  ///
  /// In en, this message translates to:
  /// **'0 - 999 points'**
  String get ecoStarterPoints;

  /// No description provided for @ecoWarriorPoints.
  ///
  /// In en, this message translates to:
  /// **'1000 - 4999 points'**
  String get ecoWarriorPoints;

  /// No description provided for @ecoChampion.
  ///
  /// In en, this message translates to:
  /// **'Eco Champion'**
  String get ecoChampion;

  /// No description provided for @ecoChampionPoints.
  ///
  /// In en, this message translates to:
  /// **'5000+ points'**
  String get ecoChampionPoints;

  /// No description provided for @current.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get current;

  /// No description provided for @waysToEarn.
  ///
  /// In en, this message translates to:
  /// **'Ways to Earn'**
  String get waysToEarn;

  /// No description provided for @earnPerBooking.
  ///
  /// In en, this message translates to:
  /// **'Earn per booking'**
  String get earnPerBooking;

  /// No description provided for @earnPerCompletion.
  ///
  /// In en, this message translates to:
  /// **'Earn per completion'**
  String get earnPerCompletion;

  /// No description provided for @bothGetPoints.
  ///
  /// In en, this message translates to:
  /// **'Both get points'**
  String get bothGetPoints;

  /// No description provided for @completePickup.
  ///
  /// In en, this message translates to:
  /// **'Complete Pickup'**
  String get completePickup;

  /// No description provided for @referFriend.
  ///
  /// In en, this message translates to:
  /// **'Refer a Friend'**
  String get referFriend;

  /// No description provided for @inviteFriends.
  ///
  /// In en, this message translates to:
  /// **'Invite Friends'**
  String get inviteFriends;

  /// No description provided for @shareYourCode.
  ///
  /// In en, this message translates to:
  /// **'Share your code: '**
  String get shareYourCode;

  /// No description provided for @shareCode.
  ///
  /// In en, this message translates to:
  /// **'Share Code'**
  String get shareCode;

  /// No description provided for @pointsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} points'**
  String pointsCount(Object count);

  /// No description provided for @locked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get locked;

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} hours ago'**
  String hoursAgo(Object count);

  /// No description provided for @airtimeVoucher.
  ///
  /// In en, this message translates to:
  /// **'Airtime voucher'**
  String get airtimeVoucher;

  /// No description provided for @weeklyStreak.
  ///
  /// In en, this message translates to:
  /// **'Weekly streak'**
  String get weeklyStreak;

  /// No description provided for @referralBonus.
  ///
  /// In en, this message translates to:
  /// **'Referral bonus'**
  String get referralBonus;

  /// No description provided for @unreadNotifications.
  ///
  /// In en, this message translates to:
  /// **'{count} unread notifications'**
  String unreadNotifications(Object count);

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get markAllRead;

  /// No description provided for @collectorArriving.
  ///
  /// In en, this message translates to:
  /// **'Collector Arriving'**
  String get collectorArriving;

  /// No description provided for @minAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} min ago'**
  String minAgo(Object count);

  /// No description provided for @collectorArrivingDesc.
  ///
  /// In en, this message translates to:
  /// **'Your waste collector is 5 minutes away'**
  String get collectorArrivingDesc;

  /// No description provided for @ecoPointsEarned.
  ///
  /// In en, this message translates to:
  /// **'EcoPoints Earned!'**
  String get ecoPointsEarned;

  /// No description provided for @hrAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} hr ago'**
  String hrAgo(Object count);

  /// No description provided for @ecoPointsEarnedDesc.
  ///
  /// In en, this message translates to:
  /// **'You earned 100 points for completing a pickup 2 hours ago'**
  String get ecoPointsEarnedDesc;

  /// No description provided for @binNearlyFull.
  ///
  /// In en, this message translates to:
  /// **'Bin Nearly Full'**
  String get binNearlyFull;

  /// No description provided for @binNearlyFullDesc.
  ///
  /// In en, this message translates to:
  /// **'Your Landfill Bin is 92% full. Schedule a pickup soon.'**
  String get binNearlyFullDesc;

  /// No description provided for @pickupCompleted.
  ///
  /// In en, this message translates to:
  /// **'Pickup Completed'**
  String get pickupCompleted;

  /// No description provided for @pickupCompletedDesc.
  ///
  /// In en, this message translates to:
  /// **'Your general waste has been successfully collected'**
  String get pickupCompletedDesc;

  /// No description provided for @weeklyReminder.
  ///
  /// In en, this message translates to:
  /// **'Weekly Reminder'**
  String get weeklyReminder;

  /// No description provided for @weeklyReminderDesc.
  ///
  /// In en, this message translates to:
  /// **'Don\'t forget to schedule your weekly waste pickup'**
  String get weeklyReminderDesc;

  /// No description provided for @allCaughtUp.
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up!'**
  String get allCaughtUp;

  /// No description provided for @mapPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Map Placeholder'**
  String get mapPlaceholder;

  /// No description provided for @minTime.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String minTime(Object count);

  /// No description provided for @collectorEnRoute.
  ///
  /// In en, this message translates to:
  /// **'Collector En Route'**
  String get collectorEnRoute;

  /// No description provided for @wasteCollectedShortly.
  ///
  /// In en, this message translates to:
  /// **'Your waste will be collected shortly'**
  String get wasteCollectedShortly;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutes;

  /// No description provided for @kmAway.
  ///
  /// In en, this message translates to:
  /// **'km away'**
  String get kmAway;

  /// No description provided for @stops.
  ///
  /// In en, this message translates to:
  /// **'Stops'**
  String get stops;

  /// No description provided for @pickupsCount.
  ///
  /// In en, this message translates to:
  /// **'({count} pickups)'**
  String pickupsCount(Object count);

  /// No description provided for @callCollector.
  ///
  /// In en, this message translates to:
  /// **'Call Collector'**
  String get callCollector;

  /// No description provided for @statusUpdates.
  ///
  /// In en, this message translates to:
  /// **'Status Updates'**
  String get statusUpdates;

  /// No description provided for @enRouteLocation.
  ///
  /// In en, this message translates to:
  /// **'En Route to Your Location'**
  String get enRouteLocation;

  /// No description provided for @minutesAway.
  ///
  /// In en, this message translates to:
  /// **'12 minutes away'**
  String get minutesAway;

  /// No description provided for @pickupStarted.
  ///
  /// In en, this message translates to:
  /// **'Pickup Started'**
  String get pickupStarted;

  /// No description provided for @collectionInitiated.
  ///
  /// In en, this message translates to:
  /// **'Collection route initiated'**
  String get collectionInitiated;

  /// No description provided for @pickupScheduled.
  ///
  /// In en, this message translates to:
  /// **'Pickup Scheduled'**
  String get pickupScheduled;

  /// No description provided for @waitingCollector.
  ///
  /// In en, this message translates to:
  /// **'Waiting for collector'**
  String get waitingCollector;

  /// No description provided for @selectWasteType.
  ///
  /// In en, this message translates to:
  /// **'Select Waste Type'**
  String get selectWasteType;

  /// No description provided for @chooseWasteCategories.
  ///
  /// In en, this message translates to:
  /// **'Choose one or more waste categories'**
  String get chooseWasteCategories;

  /// No description provided for @organicWasteTitle.
  ///
  /// In en, this message translates to:
  /// **'Organic'**
  String get organicWasteTitle;

  /// No description provided for @organicWasteDesc.
  ///
  /// In en, this message translates to:
  /// **'Food waste, garden waste'**
  String get organicWasteDesc;

  /// No description provided for @recyclableWasteTitle.
  ///
  /// In en, this message translates to:
  /// **'Recyclable'**
  String get recyclableWasteTitle;

  /// No description provided for @recyclableWasteDesc.
  ///
  /// In en, this message translates to:
  /// **'Paper, plastic, metal'**
  String get recyclableWasteDesc;

  /// No description provided for @generalWasteTitle.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get generalWasteTitle;

  /// No description provided for @generalWasteDesc.
  ///
  /// In en, this message translates to:
  /// **'Non-recyclable waste'**
  String get generalWasteDesc;

  /// No description provided for @eWasteTitle.
  ///
  /// In en, this message translates to:
  /// **'E-Waste'**
  String get eWasteTitle;

  /// No description provided for @eWasteDesc.
  ///
  /// In en, this message translates to:
  /// **'Electronics, batteries'**
  String get eWasteDesc;

  /// No description provided for @glassWasteTitle.
  ///
  /// In en, this message translates to:
  /// **'Glass'**
  String get glassWasteTitle;

  /// No description provided for @glassWasteDesc.
  ///
  /// In en, this message translates to:
  /// **'Bottles, glassware'**
  String get glassWasteDesc;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @advanceNotice.
  ///
  /// In en, this message translates to:
  /// **'Pickups must be scheduled 24 hours in advance'**
  String get advanceNotice;

  /// No description provided for @selectTime.
  ///
  /// In en, this message translates to:
  /// **'Select Time'**
  String get selectTime;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @confirmAddress.
  ///
  /// In en, this message translates to:
  /// **'Confirm Address'**
  String get confirmAddress;

  /// No description provided for @verifyLocation.
  ///
  /// In en, this message translates to:
  /// **'Verify your pickup location'**
  String get verifyLocation;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @homeLocation.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeLocation;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @choosePayment.
  ///
  /// In en, this message translates to:
  /// **'Choose how you want to pay'**
  String get choosePayment;

  /// No description provided for @serviceFee.
  ///
  /// In en, this message translates to:
  /// **'Service Fee'**
  String get serviceFee;

  /// No description provided for @ecoPointsDiscount.
  ///
  /// In en, this message translates to:
  /// **'EcoPoints Discount'**
  String get ecoPointsDiscount;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @continueBtn.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueBtn;

  /// No description provided for @pickupScheduledSuccess.
  ///
  /// In en, this message translates to:
  /// **'Pickup scheduled successfully!'**
  String get pickupScheduledSuccess;

  /// No description provided for @errSelectWaste.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one waste type'**
  String get errSelectWaste;

  /// No description provided for @errSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Please select a date'**
  String get errSelectDate;

  /// No description provided for @errSelectTime.
  ///
  /// In en, this message translates to:
  /// **'Please select a time slot'**
  String get errSelectTime;

  /// No description provided for @errSelectPayment.
  ///
  /// In en, this message translates to:
  /// **'Please select a payment method'**
  String get errSelectPayment;

  /// No description provided for @pickupScheduledSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Pickup Scheduled!'**
  String get pickupScheduledSuccessTitle;

  /// No description provided for @wastePickupConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Your waste pickup has been confirmed'**
  String get wastePickupConfirmed;

  /// No description provided for @referenceNumber.
  ///
  /// In en, this message translates to:
  /// **'Reference Number'**
  String get referenceNumber;

  /// No description provided for @earnedPointsText1.
  ///
  /// In en, this message translates to:
  /// **'You earned '**
  String get earnedPointsText1;

  /// No description provided for @earnedPointsText2.
  ///
  /// In en, this message translates to:
  /// **'50 EcoPoints'**
  String get earnedPointsText2;

  /// No description provided for @earnedPointsText3.
  ///
  /// In en, this message translates to:
  /// **' for scheduling this pickup!'**
  String get earnedPointsText3;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navBins.
  ///
  /// In en, this message translates to:
  /// **'Bins'**
  String get navBins;

  /// No description provided for @navScan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get navScan;

  /// No description provided for @noSlotsAvailableTomorrow.
  ///
  /// In en, this message translates to:
  /// **'No slots available for tomorrow. Please choose another date.'**
  String get noSlotsAvailableTomorrow;

  /// No description provided for @confirmPayment.
  ///
  /// In en, this message translates to:
  /// **'Confirm Payment'**
  String get confirmPayment;

  /// No description provided for @scanningQRCode.
  ///
  /// In en, this message translates to:
  /// **'Scanning QR Code...'**
  String get scanningQRCode;

  /// No description provided for @capacity.
  ///
  /// In en, this message translates to:
  /// **'Capacity'**
  String get capacity;

  /// No description provided for @lastEmptiedTitle.
  ///
  /// In en, this message translates to:
  /// **'Last Emptied'**
  String get lastEmptiedTitle;

  /// No description provided for @avgFillRate.
  ///
  /// In en, this message translates to:
  /// **'Avg Fill Rate'**
  String get avgFillRate;

  /// No description provided for @fifteenPercentPerDay.
  ///
  /// In en, this message translates to:
  /// **'15% per day'**
  String get fifteenPercentPerDay;

  /// No description provided for @sixteenPercentPerDay.
  ///
  /// In en, this message translates to:
  /// **'16% per day'**
  String get sixteenPercentPerDay;

  /// No description provided for @fiftyL.
  ///
  /// In en, this message translates to:
  /// **'50L'**
  String get fiftyL;

  /// No description provided for @seventyFiveL.
  ///
  /// In en, this message translates to:
  /// **'75L'**
  String get seventyFiveL;

  /// No description provided for @pendingStatus.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pendingStatus;

  /// No description provided for @confirmedStatus.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get confirmedStatus;

  /// No description provided for @collectorAssignedStatus.
  ///
  /// In en, this message translates to:
  /// **'Collector Assigned'**
  String get collectorAssignedStatus;

  /// No description provided for @completedStatus.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedStatus;

  /// No description provided for @cancelledStatus.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelledStatus;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr', 'rw'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'rw':
      return AppLocalizationsRw();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

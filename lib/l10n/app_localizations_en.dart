// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get goodMorning => 'Good Morning';

  @override
  String get yourEcoPoints => 'Your EcoPoints';

  @override
  String get ecoWarrior => 'Eco Warrior';

  @override
  String pointsToTier(String points) {
    return '$points points to Eco Champion tier';
  }

  @override
  String get schedulePickup => 'Schedule Pickup';

  @override
  String get schedule => 'Schedule';

  @override
  String get track => 'Track';

  @override
  String get smartBins => 'Smart Bins';

  @override
  String get rewards => 'Rewards';

  @override
  String get activePickup => 'Active Pickup';

  @override
  String get generalWasteCollection => 'General waste collection';

  @override
  String get enRoute => 'En route';

  @override
  String get trackNow => 'Track Now';

  @override
  String get smartBinsStatus => 'Smart Bins Status';

  @override
  String get viewAll => 'View All';

  @override
  String get personalInformation => 'Personal Information';

  @override
  String get addresses => 'Addresses';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get notifications => 'Notifications';

  @override
  String get privacySecurity => 'Privacy & Security';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get aboutSmartEco => 'About SmartEco';

  @override
  String get logOut => 'Log Out';

  @override
  String get profile => 'Profile';

  @override
  String get pickups => 'Pickups';

  @override
  String get ecoPoints => 'EcoPoints';

  @override
  String get recycled => 'Recycled';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get english => 'English';

  @override
  String get kinyarwanda => 'Kinyarwanda';

  @override
  String get french => 'French';

  @override
  String get account => 'Account';

  @override
  String get preferences => 'Preferences';

  @override
  String get support => 'Support';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get loginToContinue => 'Log in to continue your smart waste journey';

  @override
  String get logIn => 'Log In';

  @override
  String get orContinueWith => 'Or continue with';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get signUp => 'Sign Up';

  @override
  String get createAccount => 'Create Account';

  @override
  String get joinRwandaSmartWaste =>
      'Join Rwanda\'s smart waste management platform';

  @override
  String get fullName => 'Full Name';

  @override
  String get email => 'Email Address';

  @override
  String get referralCode => 'Referral Code (Optional)';

  @override
  String get continueText => 'Continue';

  @override
  String get byContinuingAgree => 'By continuing, you agree to our ';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get and => ' and\n';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get governmentCertified => 'Government Certified';

  @override
  String get authorizedByREMA =>
      'Authorized by Rwanda Environment Management Authority';

  @override
  String get onboarding1Title => 'Smart Waste Management';

  @override
  String get onboarding1Desc =>
      'Schedule pickups, track collectors, and manage waste efficiently with our innovative platform.';

  @override
  String get onboarding2Title => 'Real-Time Tracking';

  @override
  String get onboarding2Desc =>
      'Monitor your waste collector in real-time with live GPS tracking and accurate ETAs.';

  @override
  String get onboarding3Title => 'Earn EcoPoints';

  @override
  String get onboarding3Desc =>
      'Get rewarded for proper waste management. Redeem points for exciting rewards and benefits.';

  @override
  String get getStarted => 'Get Started';

  @override
  String get next => 'Next >';

  @override
  String get skip => 'Skip';

  @override
  String get totalFillRate => 'Total Fill Rate';

  @override
  String get scanBin => 'Scan Bin';

  @override
  String get compostBin => 'Compost Bin';

  @override
  String get compost => 'Compost';

  @override
  String get organicWaste => 'Organic Waste';

  @override
  String get recyclingBin => 'Recycling Bin';

  @override
  String get recyclable => 'Recyclable';

  @override
  String get recyclableMaterials => 'Recyclable Materials';

  @override
  String get eWasteBin => 'E-Waste Bin';

  @override
  String get eWaste => 'E-Waste';

  @override
  String get electronicsBatteries => 'Electronics & Batteries';

  @override
  String get landfillBin => 'Landfill Bin';

  @override
  String get landfill => 'Landfill';

  @override
  String get hazardousBin => 'Hazardous Bin';

  @override
  String get hazardous => 'Hazardous';

  @override
  String get hazardousMaterials => 'Hazardous Materials';

  @override
  String get statusOk => 'OK';

  @override
  String get statusNearlyFull => 'Nearly Full';

  @override
  String get statusFull => 'Full';

  @override
  String get fillLevel => 'Fill Level';

  @override
  String lastEmptied(Object time) {
    return 'Last: $time';
  }

  @override
  String get smartTip => 'Smart Tip';

  @override
  String get landfillFullTip =>
      'Your Landfill Bin is full. Schedule a pickup to earn EcoPoints and keep your bins clean!';

  @override
  String daysAgo(Object count) {
    return '$count days ago';
  }

  @override
  String get back => 'Back';

  @override
  String get verifyPhone => 'Verify Phone';

  @override
  String enterCodeSent(Object phone) {
    return 'Enter the 6-digit code sent to\n$phone';
  }

  @override
  String resendCodeIn(Object seconds) {
    return 'Resend code in ${seconds}s';
  }

  @override
  String get resendCode => 'Resend Code';

  @override
  String get maxAttemptsReached => 'Maximum resend attempts reached';

  @override
  String get verifyTip => 'Tip: Check your messages for a code from ';

  @override
  String get verify => 'Verify';

  @override
  String get accountType => 'Account Type';

  @override
  String get chooseTypeNeeds => 'Choose the type that best fits your needs';

  @override
  String get residential => 'Residential';

  @override
  String get residentialDesc => 'For individual households and families';

  @override
  String get weeklyPickups => 'Weekly pickups';

  @override
  String get upTo3Bins => 'Up to 3 bins';

  @override
  String get basicEcoPoints => 'Basic EcoPoints';

  @override
  String get businessAccount => 'Business';

  @override
  String get businessDesc => 'For businesses and commercial properties';

  @override
  String get dailyPickups => 'Daily pickups';

  @override
  String get unlimitedBins => 'Unlimited bins';

  @override
  String get twoXEcoPoints => '2x EcoPoints';

  @override
  String get enableBiometrics => 'Enable Biometrics';

  @override
  String get biometricsDesc =>
      'Use your fingerprint or face ID for quick\nand secure access';

  @override
  String get skipForNow => 'Skip for Now';

  @override
  String get scanning => 'Scanning...';

  @override
  String get biometricsSetupDesc => 'Setting up your biometric authentication';

  @override
  String get welcomeBonus => 'Welcome Bonus!';

  @override
  String get earnedFirstEcoPoints => 'You\'ve earned your first EcoPoints';

  @override
  String get startUsingSmartEco => 'Start Using SmartEco';

  @override
  String get rewardsTitle => 'EcoPoints Rewards';

  @override
  String get overview => 'Overview';

  @override
  String get redeem => 'Redeem';

  @override
  String get history => 'History';

  @override
  String get yourBalance => 'Your Balance';

  @override
  String pointsToTierDetailed(Object points, Object tier) {
    return '$points points to $tier';
  }

  @override
  String get membershipTiers => 'Membership Tiers';

  @override
  String get ecoStarter => 'Eco Starter';

  @override
  String get ecoStarterPoints => '0 - 999 points';

  @override
  String get ecoWarriorPoints => '1000 - 4999 points';

  @override
  String get ecoChampion => 'Eco Champion';

  @override
  String get ecoChampionPoints => '5000+ points';

  @override
  String get current => 'Current';

  @override
  String get waysToEarn => 'Ways to Earn';

  @override
  String get earnPerBooking => 'Earn per booking';

  @override
  String get earnPerCompletion => 'Earn per completion';

  @override
  String get bothGetPoints => 'Both get points';

  @override
  String get completePickup => 'Complete Pickup';

  @override
  String get referFriend => 'Refer a Friend';

  @override
  String get inviteFriends => 'Invite Friends';

  @override
  String get shareYourCode => 'Share your code: ';

  @override
  String get shareCode => 'Share Code';

  @override
  String pointsCount(Object count) {
    return '$count points';
  }

  @override
  String get locked => 'Locked';

  @override
  String hoursAgo(Object count) {
    return '$count hours ago';
  }

  @override
  String get airtimeVoucher => 'Airtime voucher';

  @override
  String get weeklyStreak => 'Weekly streak';

  @override
  String get referralBonus => 'Referral bonus';

  @override
  String unreadNotifications(Object count) {
    return '$count unread notifications';
  }

  @override
  String get markAllRead => 'Mark all read';

  @override
  String get collectorArriving => 'Collector Arriving';

  @override
  String minAgo(Object count) {
    return '$count min ago';
  }

  @override
  String get collectorArrivingDesc => 'Your waste collector is 5 minutes away';

  @override
  String get ecoPointsEarned => 'EcoPoints Earned!';

  @override
  String hrAgo(Object count) {
    return '$count hr ago';
  }

  @override
  String get ecoPointsEarnedDesc =>
      'You earned 100 points for completing a pickup 2 hours ago';

  @override
  String get binNearlyFull => 'Bin Nearly Full';

  @override
  String get binNearlyFullDesc =>
      'Your Landfill Bin is 92% full. Schedule a pickup soon.';

  @override
  String get pickupCompleted => 'Pickup Completed';

  @override
  String get pickupCompletedDesc =>
      'Your general waste has been successfully collected';

  @override
  String get weeklyReminder => 'Weekly Reminder';

  @override
  String get weeklyReminderDesc =>
      'Don\'t forget to schedule your weekly waste pickup';

  @override
  String get allCaughtUp => 'You\'re all caught up!';

  @override
  String get mapPlaceholder => 'Map Placeholder';

  @override
  String minTime(Object count) {
    return '$count min';
  }

  @override
  String get collectorEnRoute => 'Collector En Route';

  @override
  String get wasteCollectedShortly => 'Your waste will be collected shortly';

  @override
  String get minutes => 'Minutes';

  @override
  String get kmAway => 'km away';

  @override
  String get stops => 'Stops';

  @override
  String pickupsCount(Object count) {
    return '($count pickups)';
  }

  @override
  String get callCollector => 'Call Collector';

  @override
  String get statusUpdates => 'Status Updates';

  @override
  String get enRouteLocation => 'En Route to Your Location';

  @override
  String get minutesAway => '12 minutes away';

  @override
  String get pickupStarted => 'Pickup Started';

  @override
  String get collectionInitiated => 'Collection route initiated';

  @override
  String get pickupScheduled => 'Pickup Scheduled';

  @override
  String get waitingCollector => 'Waiting for collector';

  @override
  String get selectWasteType => 'Select Waste Type';

  @override
  String get chooseWasteCategories => 'Choose one or more waste categories';

  @override
  String get organicWasteTitle => 'Organic';

  @override
  String get organicWasteDesc => 'Food waste, garden waste';

  @override
  String get recyclableWasteTitle => 'Recyclable';

  @override
  String get recyclableWasteDesc => 'Paper, plastic, metal';

  @override
  String get generalWasteTitle => 'General';

  @override
  String get generalWasteDesc => 'Non-recyclable waste';

  @override
  String get eWasteTitle => 'E-Waste';

  @override
  String get eWasteDesc => 'Electronics, batteries';

  @override
  String get glassWasteTitle => 'Glass';

  @override
  String get glassWasteDesc => 'Bottles, glassware';

  @override
  String get selectDate => 'Select Date';

  @override
  String get advanceNotice => 'Pickups must be scheduled 24 hours in advance';

  @override
  String get selectTime => 'Select Time';

  @override
  String get available => 'Available';

  @override
  String get confirmAddress => 'Confirm Address';

  @override
  String get verifyLocation => 'Verify your pickup location';

  @override
  String get edit => 'Edit';

  @override
  String get homeLocation => 'Home';

  @override
  String get paymentMethod => 'Payment Method';

  @override
  String get choosePayment => 'Choose how you want to pay';

  @override
  String get serviceFee => 'Service Fee';

  @override
  String get ecoPointsDiscount => 'EcoPoints Discount';

  @override
  String get total => 'Total';

  @override
  String get continueBtn => 'Continue';

  @override
  String get pickupScheduledSuccess => 'Pickup scheduled successfully!';

  @override
  String get errSelectWaste => 'Please select at least one waste type';

  @override
  String get errSelectDate => 'Please select a date';

  @override
  String get errSelectTime => 'Please select a time slot';

  @override
  String get errSelectPayment => 'Please select a payment method';

  @override
  String get pickupScheduledSuccessTitle => 'Pickup Scheduled!';

  @override
  String get wastePickupConfirmed => 'Your waste pickup has been confirmed';

  @override
  String get referenceNumber => 'Reference Number';

  @override
  String get earnedPointsText1 => 'You earned ';

  @override
  String get earnedPointsText2 => '50 EcoPoints';

  @override
  String get earnedPointsText3 => ' for scheduling this pickup!';

  @override
  String get navHome => 'Home';

  @override
  String get navBins => 'Bins';

  @override
  String get navScan => 'Scan';

  @override
  String get noSlotsAvailableTomorrow =>
      'No slots available for tomorrow. Please choose another date.';

  @override
  String get confirmPayment => 'Confirm Payment';

  @override
  String get scanningQRCode => 'Scanning QR Code...';

  @override
  String get capacity => 'Capacity';

  @override
  String get lastEmptiedTitle => 'Last Emptied';

  @override
  String get avgFillRate => 'Avg Fill Rate';

  @override
  String get fifteenPercentPerDay => '15% per day';

  @override
  String get sixteenPercentPerDay => '16% per day';

  @override
  String get fiftyL => '50L';

  @override
  String get seventyFiveL => '75L';

  @override
  String get pendingStatus => 'Pending';

  @override
  String get confirmedStatus => 'Confirmed';

  @override
  String get collectorAssignedStatus => 'Collector Assigned';

  @override
  String get completedStatus => 'Completed';

  @override
  String get cancelledStatus => 'Cancelled';

  @override
  String get cancel => 'Cancel';
}

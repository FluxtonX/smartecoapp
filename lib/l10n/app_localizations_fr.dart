// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get goodMorning => 'Bonjour';

  @override
  String get yourEcoPoints => 'Vos EcoPoints';

  @override
  String get ecoWarrior => 'Guerrier Éco';

  @override
  String pointsToTier(String points) {
    return '$points points pour le niveau Champion Éco';
  }

  @override
  String get schedulePickup => 'Planifier le ramassage';

  @override
  String get schedule => 'Planifier';

  @override
  String get track => 'Suivre';

  @override
  String get smartBins => 'Bacs intelligents';

  @override
  String get rewards => 'Récompenses';

  @override
  String get activePickup => 'Ramassage actif';

  @override
  String get generalWasteCollection => 'Collecte des déchets généraux';

  @override
  String get enRoute => 'En route';

  @override
  String get trackNow => 'Suivre maintenant';

  @override
  String get smartBinsStatus => 'Statut des bacs intelligents';

  @override
  String get viewAll => 'Voir tout';

  @override
  String get personalInformation => 'Informations personnelles';

  @override
  String get addresses => 'Adresses';

  @override
  String get phoneNumber => 'Numéro de téléphone';

  @override
  String get notifications => 'Notifications';

  @override
  String get privacySecurity => 'Confidentialité et sécurité';

  @override
  String get helpSupport => 'Aide et support';

  @override
  String get aboutSmartEco => 'À propos de SmartEco';

  @override
  String get logOut => 'Se déconnecter';

  @override
  String get profile => 'Profil';

  @override
  String get pickups => 'Ramassages';

  @override
  String get ecoPoints => 'EcoPoints';

  @override
  String get recycled => 'Recyclé';

  @override
  String get language => 'Langue';

  @override
  String get selectLanguage => 'Choisir la langue';

  @override
  String get english => 'Anglais';

  @override
  String get kinyarwanda => 'Kinyarwanda';

  @override
  String get french => 'Français';

  @override
  String get account => 'Compte';

  @override
  String get preferences => 'Préférences';

  @override
  String get support => 'Assistance';

  @override
  String get welcomeBack => 'Bon retour';

  @override
  String get loginToContinue =>
      'Connectez-vous pour continuer votre parcours de gestion intelligente des déchets';

  @override
  String get logIn => 'Se connecter';

  @override
  String get orContinueWith => 'Ou continuer avec';

  @override
  String get dontHaveAccount => 'Vous n\'avez pas de compte ? ';

  @override
  String get signUp => 'S\'inscrire';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get joinRwandaSmartWaste =>
      'Rejoignez la plateforme rwandaise de gestion intelligente des déchets';

  @override
  String get fullName => 'Nom complet';

  @override
  String get email => 'Adresse e-mail';

  @override
  String get referralCode => 'Code de parrainage (facultatif)';

  @override
  String get continueText => 'Continuer';

  @override
  String get byContinuingAgree => 'En continuant, vous acceptez nos ';

  @override
  String get termsOfService => 'Conditions d\'utilisation';

  @override
  String get and => ' et\n';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get alreadyHaveAccount => 'Vous avez déjà un compte ? ';

  @override
  String get governmentCertified => 'Certifié par le gouvernement';

  @override
  String get authorizedByREMA =>
      'Autorisé par l\'Autorité rwandaise de gestion de l\'environnement';

  @override
  String get onboarding1Title => 'Gestion intelligente des déchets';

  @override
  String get onboarding1Desc =>
      'Planifiez les ramassages, suivez les collecteurs et gérez les déchets efficacement avec notre plateforme innovante.';

  @override
  String get onboarding2Title => 'Suivi en temps réel';

  @override
  String get onboarding2Desc =>
      'Surveillez votre collecteur de déchets en temps réel avec un suivi GPS en direct et des heures d\'arrivée précises.';

  @override
  String get onboarding3Title => 'Gagnez des EcoPoints';

  @override
  String get onboarding3Desc =>
      'Soyez récompensé pour une bonne gestion des déchets. Échangez vos points contre des récompenses et des avantages passionnants.';

  @override
  String get getStarted => 'Commencer';

  @override
  String get next => 'Suivant >';

  @override
  String get skip => 'Passer';

  @override
  String get totalFillRate => 'Taux de remplissage total';

  @override
  String get scanBin => 'Scanner le bac';

  @override
  String get compostBin => 'Bac à compost';

  @override
  String get compost => 'Compost';

  @override
  String get organicWaste => 'Déchets organiques';

  @override
  String get recyclingBin => 'Bac de recyclage';

  @override
  String get recyclable => 'Recyclable';

  @override
  String get recyclableMaterials => 'Matières recyclables';

  @override
  String get eWasteBin => 'Bac à déchets électroniques';

  @override
  String get eWaste => 'Électronique';

  @override
  String get electronicsBatteries => 'Électronique et piles';

  @override
  String get landfillBin => 'Bac à ordures ménagères';

  @override
  String get landfill => 'Ordures';

  @override
  String get hazardousBin => 'Bac pour produits dangereux';

  @override
  String get hazardous => 'Dangereux';

  @override
  String get hazardousMaterials => 'Matières dangereuses';

  @override
  String get statusOk => 'OK';

  @override
  String get statusNearlyFull => 'Presque plein';

  @override
  String get statusFull => 'Plein';

  @override
  String get fillLevel => 'Niveau de remplissage';

  @override
  String lastEmptied(Object time) {
    return 'Dernière fois : $time';
  }

  @override
  String get smartTip => 'Conseil intelligent';

  @override
  String get landfillFullTip =>
      'Votre bac à ordures ménagères est plein. Planifiez un ramassage pour gagner des EcoPoints et garder vos bacs propres !';

  @override
  String daysAgo(Object count) {
    return 'il y a $count jours';
  }

  @override
  String get back => 'Retour';

  @override
  String get verifyPhone => 'Vérifier le téléphone';

  @override
  String enterCodeSent(Object phone) {
    return 'Entrez le code à 6 chiffres envoyé au\n$phone';
  }

  @override
  String resendCodeIn(Object seconds) {
    return 'Renvoyer le code dans ${seconds}s';
  }

  @override
  String get verifyTip => 'Conseil : Vérifiez vos messages pour un code de ';

  @override
  String get verify => 'Vérifier';

  @override
  String get accountType => 'Type de compte';

  @override
  String get chooseTypeNeeds =>
      'Choisissez le type qui correspond le mieux à vos besoins';

  @override
  String get residential => 'Résidentiel';

  @override
  String get residentialDesc => 'Pour les ménages individuels et les familles';

  @override
  String get weeklyPickups => 'Ramassages hebdomadaires';

  @override
  String get upTo3Bins => 'Jusqu\'à 3 bacs';

  @override
  String get basicEcoPoints => 'EcoPoints de base';

  @override
  String get businessAccount => 'Entreprise';

  @override
  String get businessDesc =>
      'Pour les entreprises et les propriétés commerciales';

  @override
  String get dailyPickups => 'Ramassages quotidiens';

  @override
  String get unlimitedBins => 'Bacs illimités';

  @override
  String get twoXEcoPoints => '2x EcoPoints';

  @override
  String get enableBiometrics => 'Activer la biométrie';

  @override
  String get biometricsDesc =>
      'Utilisez votre empreinte digitale ou l\'identification faciale pour un accès rapide\net sécurisé';

  @override
  String get skipForNow => 'Passer pour l\'instant';

  @override
  String get scanning => 'Numérisation...';

  @override
  String get biometricsSetupDesc =>
      'Configuration de votre authentification biométrique';

  @override
  String get welcomeBonus => 'Bonus de bienvenue !';

  @override
  String get earnedFirstEcoPoints => 'Vous avez gagné vos premiers EcoPoints';

  @override
  String get startUsingSmartEco => 'Commencer à utiliser SmartEco';

  @override
  String get rewardsTitle => 'Récompenses EcoPoints';

  @override
  String get overview => 'Aperçu';

  @override
  String get redeem => 'Échanger';

  @override
  String get history => 'Historique';

  @override
  String get yourBalance => 'Votre solde';

  @override
  String pointsToTierDetailed(Object points, Object tier) {
    return '$points points jusqu\'à $tier';
  }

  @override
  String get membershipTiers => 'Niveaux d\'adhésion';

  @override
  String get ecoStarter => 'Eco Débutant';

  @override
  String get ecoStarterPoints => '0 - 999 points';

  @override
  String get ecoWarriorPoints => '1000 - 4999 points';

  @override
  String get ecoChampion => 'Champion Éco';

  @override
  String get ecoChampionPoints => '5000+ points';

  @override
  String get current => 'Actuel';

  @override
  String get waysToEarn => 'Façons de gagner';

  @override
  String get earnPerBooking => 'Gagnez par réservation';

  @override
  String get earnPerCompletion => 'Gagnez par ramassage terminé';

  @override
  String get bothGetPoints => 'Les deux reçoivent des points';

  @override
  String get completePickup => 'Ramassage terminé';

  @override
  String get referFriend => 'Parrainer un ami';

  @override
  String get inviteFriends => 'Inviter des amis';

  @override
  String get shareYourCode => 'Partagez votre code : ';

  @override
  String get shareCode => 'Partager le code';

  @override
  String pointsCount(Object count) {
    return '$count points';
  }

  @override
  String get locked => 'Verrouillé';

  @override
  String hoursAgo(Object count) {
    return 'il y a $count heures';
  }

  @override
  String get airtimeVoucher => 'Bon de recharge';

  @override
  String get weeklyStreak => 'Série hebdomadaire';

  @override
  String get referralBonus => 'Bonus de parrainage';

  @override
  String unreadNotifications(Object count) {
    return '$count notifications non lues';
  }

  @override
  String get markAllRead => 'Tout marquer comme lu';

  @override
  String get collectorArriving => 'Collecteur en route';

  @override
  String minAgo(Object count) {
    return 'il y a $count min';
  }

  @override
  String get collectorArrivingDesc =>
      'Votre collecteur de déchets est à 5 minutes';

  @override
  String get ecoPointsEarned => 'EcoPoints gagnés !';

  @override
  String hrAgo(Object count) {
    return 'il y a $count h';
  }

  @override
  String get ecoPointsEarnedDesc =>
      'Vous avez gagné 100 points pour un ramassage il y a 2 heures';

  @override
  String get binNearlyFull => 'Bac presque plein';

  @override
  String get binNearlyFullDesc =>
      'Votre bac à ordures est plein à 92 %. Planifiez un ramassage bientôt.';

  @override
  String get pickupCompleted => 'Ramassage terminé';

  @override
  String get pickupCompletedDesc =>
      'Vos déchets généraux ont été collectés avec succès';

  @override
  String get weeklyReminder => 'Rappel hebdomadaire';

  @override
  String get weeklyReminderDesc =>
      'N\'oubliez pas de planifier votre collecte de déchets hebdomadaire';

  @override
  String get allCaughtUp => 'Vous êtes à jour !';

  @override
  String get mapPlaceholder => 'Espace réservé à la carte';

  @override
  String minTime(Object count) {
    return '$count min';
  }

  @override
  String get collectorEnRoute => 'Collecteur en route';

  @override
  String get wasteCollectedShortly =>
      'Vos déchets seront collectés prochainement';

  @override
  String get minutes => 'Minutes';

  @override
  String get kmAway => 'km de distance';

  @override
  String get stops => 'Arrêts';

  @override
  String pickupsCount(Object count) {
    return '($count ramassages)';
  }

  @override
  String get callCollector => 'Appeler le collecteur';

  @override
  String get statusUpdates => 'Mises à jour du statut';

  @override
  String get enRouteLocation => 'En route vers votre position';

  @override
  String get minutesAway => 'à 12 minutes';

  @override
  String get pickupStarted => 'Ramassage commencé';

  @override
  String get collectionInitiated => 'Itinéraire de collecte initié';

  @override
  String get pickupScheduled => 'Ramassage prévu';

  @override
  String get waitingCollector => 'En attente du collecteur';

  @override
  String get selectWasteType => 'Sélectionner le type de déchets';

  @override
  String get chooseWasteCategories =>
      'Choisissez une ou plusieurs catégories de déchets';

  @override
  String get organicWasteTitle => 'Organique';

  @override
  String get organicWasteDesc => 'Restes de nourriture, déchets de jardin';

  @override
  String get recyclableWasteTitle => 'Recyclable';

  @override
  String get recyclableWasteDesc => 'Papier, plastique, métal';

  @override
  String get generalWasteTitle => 'Général';

  @override
  String get generalWasteDesc => 'Déchets non recyclables';

  @override
  String get eWasteTitle => 'Déchets électroniques';

  @override
  String get eWasteDesc => 'Électronique, batteries';

  @override
  String get glassWasteTitle => 'Verre';

  @override
  String get glassWasteDesc => 'Bouteilles, objets en verre';

  @override
  String get selectDate => 'Sélectionner une date';

  @override
  String get advanceNotice =>
      'Les ramassages doivent être planifiés 24 heures à l\'avance';

  @override
  String get selectTime => 'Sélectionner l\'heure';

  @override
  String get available => 'Disponible';

  @override
  String get confirmAddress => 'Confirmer l\'adresse';

  @override
  String get verifyLocation => 'Vérifiez votre lieu de ramassage';

  @override
  String get edit => 'Modifier';

  @override
  String get homeLocation => 'Domicile';

  @override
  String get paymentMethod => 'Mode de paiement';

  @override
  String get choosePayment => 'Choisissez comment vous souhaitez payer';

  @override
  String get serviceFee => 'Frais de service';

  @override
  String get ecoPointsDiscount => 'Remise EcoPoints';

  @override
  String get total => 'Total';

  @override
  String get continueBtn => 'Continuer';

  @override
  String get pickupScheduledSuccess => 'Ramassage planifié avec succès !';

  @override
  String get errSelectWaste =>
      'Veuillez sélectionner au moins un type de déchets';

  @override
  String get errSelectDate => 'Veuillez sélectionner une date';

  @override
  String get errSelectTime => 'Veuillez sélectionner un créneau horaire';

  @override
  String get errSelectPayment => 'Veuillez sélectionner un mode de paiement';

  @override
  String get pickupScheduledSuccessTitle => 'Ramassage planifié !';

  @override
  String get wastePickupConfirmed =>
      'Votre ramassage de déchets a été confirmé';

  @override
  String get referenceNumber => 'Numéro de référence';

  @override
  String get earnedPointsText1 => 'Vous avez gagné ';

  @override
  String get earnedPointsText2 => '50 EcoPoints';

  @override
  String get earnedPointsText3 => ' pour la planification de ce ramassage !';

  @override
  String get navHome => 'Accueil';

  @override
  String get navBins => 'Poubelles';

  @override
  String get navScan => 'Scanner';

  @override
  String get noSlotsAvailableTomorrow =>
      'No slots available for tomorrow. Please choose another date.';

  @override
  String get confirmPayment => 'Confirm Payment';

  @override
  String get scanningQRCode => 'Numérisation du code QR...';

  @override
  String get capacity => 'Capacité';

  @override
  String get lastEmptiedTitle => 'Dernier vidage';

  @override
  String get avgFillRate => 'Taux de remplissage m...';

  @override
  String get fifteenPercentPerDay => '15% par jour';

  @override
  String get sixteenPercentPerDay => '16% par jour';

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

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get onboardingSkip => 'Passer';

  @override
  String get onboardingTitle1 => 'Bienvenue dans Inner Wisdom Astro';

  @override
  String get onboardingDesc1 =>
      'Innerwisdom Astro réunit plus de 30 ans d\'expertise astrologique de Madi G. avec la puissance de l\'IA avancée, créant l\'une des applications d\'astrologie les plus raffinées et performantes disponibles aujourd\'hui.\n\nEn mêlant une profonde compréhension humaine à une technologie intelligente, Innerwisdom Astro offre des interprétations précises, personnalisées et significatives, soutenant les utilisateurs dans leur parcours de découverte de soi, de clarté et de croissance consciente.';

  @override
  String get onboardingTitle2 => 'Votre Voyage Astrologique Complet';

  @override
  String get onboardingDesc2 =>
      'Des conseils quotidiens personnalisés à votre Carte du Ciel, l\'Astrologie Karmique, des rapports de personnalité approfondis, la Compatibilité Amoureuse et Amicale, les Prévisions Romantiques pour les Couples, et bien plus encore — tout est désormais à portée de main.\n\nConçu pour soutenir la clarté, la connexion et la compréhension de soi, Innerwisdom Astro offre une expérience astrologique complète, adaptée à vous.';

  @override
  String get onboardingNext => 'Suivant';

  @override
  String get onboardingGetStarted => 'Commencer';

  @override
  String get onboardingAlreadyHaveAccount =>
      'Vous avez déjà un compte ? Connexion';

  @override
  String get birthDataTitle => 'Votre Carte du Ciel';

  @override
  String get birthDataSubtitle =>
      'Nous avons besoin de vos détails de naissance pour créer\nvotre profil astrologique personnalisé';

  @override
  String get birthDateLabel => 'Date de Naissance';

  @override
  String get birthDateSelectHint => 'Sélectionnez votre date de naissance';

  @override
  String get birthTimeLabel => 'Heure de Naissance';

  @override
  String get birthTimeUnknown => 'Inconnu';

  @override
  String get birthTimeSelectHint => 'Sélectionnez votre heure de naissance';

  @override
  String get birthTimeUnknownCheckbox =>
      'Je ne connais pas mon heure de naissance exacte';

  @override
  String get birthPlaceLabel => 'Lieu de Naissance';

  @override
  String get birthPlaceHint => 'Commencez à taper le nom d\'une ville...';

  @override
  String get birthPlaceValidation =>
      'Veuillez sélectionner un emplacement parmi les suggestions';

  @override
  String birthPlaceSelected(Object location) {
    return 'Sélectionné : $location';
  }

  @override
  String get genderLabel => 'Genre';

  @override
  String get genderMale => 'Homme';

  @override
  String get genderFemale => 'Femme';

  @override
  String get genderPreferNotToSay => 'Préfère ne pas dire';

  @override
  String get birthDataSubmit => 'Générer Ma Carte du Ciel';

  @override
  String get birthDataPrivacyNote =>
      'Vos données de naissance ne sont utilisées que pour calculer votre\ncarte astrologique et sont stockées en toute sécurité.';

  @override
  String get birthDateMissing =>
      'Veuillez sélectionner votre date de naissance';

  @override
  String get birthPlaceMissing =>
      'Veuillez sélectionner un lieu de naissance parmi les suggestions';

  @override
  String get birthDataSaveError =>
      'Impossible d\'enregistrer les données de naissance. Veuillez réessayer.';

  @override
  String get appearanceTitle => 'Apparence';

  @override
  String get appearanceTheme => 'Thème';

  @override
  String get appearanceDarkTitle => 'Sombre';

  @override
  String get appearanceDarkSubtitle =>
      'Doux pour les yeux dans des conditions de faible luminosité';

  @override
  String get appearanceLightTitle => 'Clair';

  @override
  String get appearanceLightSubtitle => 'Apparence classique et lumineuse';

  @override
  String get appearanceSystemTitle => 'Système';

  @override
  String get appearanceSystemSubtitle =>
      'Correspondre aux paramètres de votre appareil';

  @override
  String get appearancePreviewTitle => 'Aperçu';

  @override
  String get appearancePreviewBody =>
      'Le thème cosmique est conçu pour créer une expérience astrologique immersive. Le thème sombre est recommandé pour la meilleure expérience visuelle.';

  @override
  String appearanceThemeChanged(Object theme) {
    return 'Thème changé en $theme';
  }

  @override
  String get profileUserFallback => 'Utilisateur';

  @override
  String get profilePersonalContext => 'Contexte Personnel';

  @override
  String get profileSettings => 'Paramètres';

  @override
  String get profileAppLanguage => 'Langue de l\'Application';

  @override
  String get profileContentLanguage => 'Langue du Contenu';

  @override
  String get profileContentLanguageHint =>
      'Le contenu de l\'IA utilise la langue sélectionnée.';

  @override
  String get profileNotifications => 'Notifications';

  @override
  String get profileNotificationsEnabled => 'Activé';

  @override
  String get profileNotificationsDisabled => 'Désactivé';

  @override
  String get profileAppearance => 'Apparence';

  @override
  String get profileHelpSupport => 'Aide & Support';

  @override
  String get profilePrivacyPolicy => 'Politique de Confidentialité';

  @override
  String get profileTermsOfService => 'Conditions d\'Utilisation';

  @override
  String get profileLogout => 'Déconnexion';

  @override
  String get profileLogoutConfirm =>
      'Êtes-vous sûr de vouloir vous déconnecter ?';

  @override
  String get profileDeleteAccount => 'Supprimer le Compte';

  @override
  String get commonCancel => 'Annuler';

  @override
  String get profileSelectLanguageTitle => 'Sélectionner la Langue';

  @override
  String get profileSelectLanguageSubtitle =>
      'Tout le contenu généré par l\'IA sera dans votre langue sélectionnée.';

  @override
  String profileLanguageUpdated(Object language) {
    return 'Langue mise à jour en $language';
  }

  @override
  String profileLanguageUpdateFailed(Object error) {
    return 'Échec de la mise à jour de la langue : $error';
  }

  @override
  String profileVersion(Object version) {
    return 'Inner Wisdom v$version';
  }

  @override
  String get profileCosmicBlueprint => 'Votre Plan Cosmique';

  @override
  String get profileSunLabel => '☀️ Soleil';

  @override
  String get profileMoonLabel => '🌙 Lune';

  @override
  String get profileRisingLabel => '⬆️ Ascendant';

  @override
  String get profileUnknown => 'Inconnu';

  @override
  String get forgotPasswordTitle => 'Mot de Passe Oublié ?';

  @override
  String get forgotPasswordSubtitle =>
      'Entrez votre email et nous vous enverrons un code pour réinitialiser votre mot de passe';

  @override
  String get forgotPasswordSent =>
      'Si un compte existe, un code de réinitialisation a été envoyé à votre email.';

  @override
  String get forgotPasswordFailed =>
      'Échec de l\'envoi du code de réinitialisation. Veuillez réessayer.';

  @override
  String get forgotPasswordSendCode => 'Envoyer le Code de Réinitialisation';

  @override
  String get forgotPasswordHaveCode => 'Vous avez déjà un code ?';

  @override
  String get forgotPasswordRemember =>
      'Vous vous souvenez de votre mot de passe ? ';

  @override
  String get loginWelcomeBack => 'Bienvenue de Nouveau';

  @override
  String get loginSubtitle =>
      'Connectez-vous pour continuer votre voyage cosmique';

  @override
  String get loginInvalidCredentials => 'Email ou mot de passe invalide';

  @override
  String get loginGoogleFailed =>
      'Échec de la connexion Google. Veuillez réessayer.';

  @override
  String get loginAppleFailed =>
      'Échec de la connexion Apple. Veuillez réessayer.';

  @override
  String get loginNetworkError =>
      'Erreur réseau. Veuillez vérifier votre connexion.';

  @override
  String get loginSignInCancelled => 'La connexion a été annulée.';

  @override
  String get loginPasswordHint => 'Entrez votre mot de passe';

  @override
  String get loginForgotPassword => 'Mot de Passe Oublié ?';

  @override
  String get loginSignIn => 'Se Connecter';

  @override
  String get loginNoAccount => 'Vous n\'avez pas de compte ? ';

  @override
  String get loginSignUp => 'S\'inscrire';

  @override
  String get commonEmailLabel => 'Email';

  @override
  String get commonEmailHint => 'Entrez votre email';

  @override
  String get commonEmailRequired => 'Veuillez entrer votre email';

  @override
  String get commonEmailInvalid => 'Veuillez entrer un email valide';

  @override
  String get commonPasswordLabel => 'Mot de Passe';

  @override
  String get commonPasswordRequired => 'Veuillez entrer votre mot de passe';

  @override
  String get commonOrContinueWith => 'ou continuer avec';

  @override
  String get commonGoogle => 'Google';

  @override
  String get commonApple => 'Apple';

  @override
  String get commonNameLabel => 'Nom';

  @override
  String get commonNameHint => 'Entrez votre nom';

  @override
  String get commonNameRequired => 'Veuillez entrer votre nom';

  @override
  String get signupTitle => 'Créer un Compte';

  @override
  String get signupSubtitle =>
      'Commencez votre voyage cosmique avec Inner Wisdom';

  @override
  String get signupEmailExists =>
      'L\'email existe déjà ou les données sont invalides';

  @override
  String get signupGoogleFailed =>
      'Échec de la connexion Google. Veuillez réessayer.';

  @override
  String get signupAppleFailed =>
      'Échec de la connexion Apple. Veuillez réessayer.';

  @override
  String get signupPasswordHint => 'Créez un mot de passe (min. 8 caractères)';

  @override
  String get signupPasswordMin =>
      'Le mot de passe doit comporter au moins 8 caractères';

  @override
  String get signupConfirmPasswordLabel => 'Confirmer le mot de passe';

  @override
  String get signupConfirmPasswordHint => 'Confirmez votre mot de passe';

  @override
  String get signupConfirmPasswordRequired =>
      'Veuillez confirmer votre mot de passe';

  @override
  String get signupPasswordMismatch => 'Les mots de passe ne correspondent pas';

  @override
  String get signupPreferredLanguage => 'Langue préférée';

  @override
  String get signupCreateAccount => 'Créer un compte';

  @override
  String get signupHaveAccount => 'Vous avez déjà un compte ? ';

  @override
  String get resetPasswordTitle => 'Réinitialiser le mot de passe';

  @override
  String get resetPasswordSubtitle =>
      'Entrez le code envoyé à votre email et définissez un nouveau mot de passe';

  @override
  String get resetPasswordSuccess =>
      'Réinitialisation du mot de passe réussie ! Redirection vers la connexion...';

  @override
  String get resetPasswordFailed =>
      'Échec de la réinitialisation du mot de passe. Veuillez réessayer.';

  @override
  String get resetPasswordInvalidCode =>
      'Code de réinitialisation invalide ou expiré. Veuillez en demander un nouveau.';

  @override
  String get resetPasswordMaxAttempts =>
      'Nombre maximum de tentatives dépassé. Veuillez demander un nouveau code.';

  @override
  String get resetCodeLabel => 'Code de réinitialisation';

  @override
  String get resetCodeHint => 'Entrez le code à 6 chiffres';

  @override
  String get resetCodeRequired => 'Veuillez entrer le code de réinitialisation';

  @override
  String get resetCodeLength => 'Le code doit comporter 6 chiffres';

  @override
  String get resetNewPasswordLabel => 'Nouveau mot de passe';

  @override
  String get resetNewPasswordHint =>
      'Créez un nouveau mot de passe (min. 8 caractères)';

  @override
  String get resetNewPasswordRequired =>
      'Veuillez entrer un nouveau mot de passe';

  @override
  String get resetConfirmPasswordHint => 'Confirmez votre nouveau mot de passe';

  @override
  String get resetPasswordButton => 'Réinitialiser le mot de passe';

  @override
  String get resetRequestNewCode => 'Demander un nouveau code';

  @override
  String get serviceResultGenerated => 'Rapport généré';

  @override
  String serviceResultReady(Object title) {
    return 'Votre $title personnalisé est prêt';
  }

  @override
  String get serviceResultBackToForYou => 'Retour à Pour Vous';

  @override
  String get serviceResultNotSavedNotice =>
      'Ce rapport ne sera pas enregistré. Si vous le souhaitez, vous pouvez le copier et l\'enregistrer ailleurs en utilisant la fonction Copier.';

  @override
  String get commonCopy => 'Copier';

  @override
  String get commonCopied => 'Copié dans le presse-papiers';

  @override
  String get commonContinue => 'Continuer';

  @override
  String get partnerDetailsTitle => 'Détails du partenaire';

  @override
  String get partnerBirthDataTitle =>
      'Entrez les données de naissance du partenaire';

  @override
  String partnerBirthDataFor(Object title) {
    return 'Pour \"$title\"';
  }

  @override
  String get partnerNameOptionalLabel => 'Nom (facultatif)';

  @override
  String get partnerNameHint => 'Nom du partenaire';

  @override
  String get partnerGenderOptionalLabel => 'Genre (facultatif)';

  @override
  String get partnerBirthDateLabel => 'Date de naissance *';

  @override
  String get partnerBirthDateSelect => 'Sélectionnez la date de naissance';

  @override
  String get partnerBirthDateMissing =>
      'Veuillez sélectionner la date de naissance';

  @override
  String get partnerBirthTimeOptionalLabel => 'Heure de naissance (facultatif)';

  @override
  String get partnerBirthTimeSelect => 'Sélectionnez l\'heure de naissance';

  @override
  String get partnerBirthPlaceLabel => 'Lieu de naissance *';

  @override
  String get serviceOfferRequiresPartner =>
      'Nécessite les données de naissance du partenaire';

  @override
  String get serviceOfferBetaFree =>
      'Les testeurs bêta bénéficient d\'un accès gratuit !';

  @override
  String get serviceOfferUnlocked => 'Déverrouillé';

  @override
  String get serviceOfferGenerate => 'Générer le rapport';

  @override
  String serviceOfferUnlockFor(Object price) {
    return 'Déverrouiller pour $price';
  }

  @override
  String get serviceOfferPreparing =>
      'Préparation de votre rapport personnalisé…';

  @override
  String get serviceOfferTimeout =>
      'Prend plus de temps que prévu. Veuillez réessayer.';

  @override
  String get serviceOfferNotReady =>
      'Le rapport n\'est pas encore prêt. Veuillez réessayer.';

  @override
  String serviceOfferFetchFailed(Object error) {
    return 'Échec de la récupération du rapport : $error';
  }

  @override
  String get commonFree => 'GRATUIT';

  @override
  String get commonLater => 'Plus tard';

  @override
  String get commonRetry => 'Réessayer';

  @override
  String get commonYes => 'Oui';

  @override
  String get commonNo => 'Non';

  @override
  String get commonBack => 'Retour';

  @override
  String get commonOptional => 'Facultatif';

  @override
  String get commonNotSpecified => 'Non spécifié';

  @override
  String get commonJustNow => 'À l\'instant';

  @override
  String get commonViewMore => 'Voir plus';

  @override
  String get commonViewLess => 'Voir moins';

  @override
  String commonMinutesAgo(Object count) {
    return 'Il y a $count min';
  }

  @override
  String commonHoursAgo(Object count) {
    return 'Il y a ${count}h';
  }

  @override
  String commonDaysAgo(Object count) {
    return 'Il y a ${count}j';
  }

  @override
  String commonDateShort(Object day, Object month, Object year) {
    return '$day/$month/$year';
  }

  @override
  String get askGuideTitle => 'Demandez à votre guide';

  @override
  String get askGuideSubtitle => 'Guidance cosmique personnelle';

  @override
  String askGuideRemaining(Object count) {
    return '$count restant';
  }

  @override
  String get askGuideQuestionHint =>
      'Posez n\'importe quelle question - amour, carrière, décisions, émotions...';

  @override
  String get askGuideBasedOnChart =>
      'Basé sur votre carte de naissance et les énergies cosmiques d\'aujourd\'hui';

  @override
  String get askGuideThinking => 'Votre guide réfléchit...';

  @override
  String get askGuideYourGuide => 'Votre guide';

  @override
  String get askGuideEmptyTitle => 'Posez votre première question';

  @override
  String get askGuideEmptyBody =>
      'Obtenez une guidance instantanée et profondément personnelle basée sur votre carte de naissance et les énergies cosmiques d\'aujourd\'hui.';

  @override
  String get askGuideEmptyHint =>
      'Posez n\'importe quelle question — amour, carrière, décisions, émotions.';

  @override
  String get askGuideLoadFailed => 'Échec du chargement des données';

  @override
  String askGuideSendFailed(Object error) {
    return 'Échec de l\'envoi de la question : $error';
  }

  @override
  String get askGuideLimitTitle => 'Limite mensuelle atteinte';

  @override
  String get askGuideLimitBody =>
      'Vous avez atteint votre limite mensuelle de demandes.';

  @override
  String get askGuideLimitAddon =>
      'Vous pouvez acheter un add-on à 1,99 \$ pour continuer à utiliser ce service pour le reste du mois de facturation actuel.';

  @override
  String askGuideLimitBillingEnd(Object date) {
    return 'Votre mois de facturation se termine le : $date';
  }

  @override
  String get askGuideLimitGetAddon => 'Obtenir l\'Add-On';

  @override
  String get contextTitle => 'Contexte personnel';

  @override
  String contextStepOf(Object current, Object total) {
    return 'Étape $current sur $total';
  }

  @override
  String get contextStep1Title => 'Personnes autour de vous';

  @override
  String get contextStep1Subtitle =>
      'Votre contexte relationnel et familial nous aide à comprendre votre paysage émotionnel.';

  @override
  String get contextStep2Title => 'Vie professionnelle';

  @override
  String get contextStep2Subtitle =>
      'Votre travail et votre rythme quotidien façonnent votre expérience de la pression, de la croissance et du but.';

  @override
  String get contextStep3Title => 'Comment la vie se sent en ce moment';

  @override
  String get contextStep3Subtitle =>
      'Il n\'y a pas de bonnes ou de mauvaises réponses, juste votre réalité actuelle';

  @override
  String get contextStep4Title => 'Ce qui compte le plus pour vous';

  @override
  String get contextStep4Subtitle =>
      'Ainsi, votre guidance s\'aligne avec ce qui vous tient vraiment à cœur';

  @override
  String get contextPriorityRequired =>
      'Veuillez sélectionner au moins un domaine de priorité.';

  @override
  String contextSaveFailed(Object error) {
    return 'Échec de l\'enregistrement du profil : $error';
  }

  @override
  String get contextSaveContinue => 'Enregistrer & Continuer';

  @override
  String get contextRelationshipStatusTitle => 'Statut relationnel actuel';

  @override
  String get contextSeekingRelationshipTitle => 'Cherchez-vous une relation ?';

  @override
  String get contextHasChildrenTitle => 'Avez-vous des enfants ?';

  @override
  String get contextChildrenDetailsOptional =>
      'Détails sur les enfants (optionnel)';

  @override
  String get contextAddChild => 'Ajouter un enfant';

  @override
  String get contextChildAgeLabel => 'Âge';

  @override
  String contextChildAgeYears(num age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other: 'ans',
      one: 'an',
    );
    return '$age $_temp0';
  }

  @override
  String get contextChildGenderLabel => 'Genre';

  @override
  String get contextRelationshipSingle => 'Célibataire';

  @override
  String get contextRelationshipInRelationship => 'En couple';

  @override
  String get contextRelationshipMarried => 'Marié / Partenariat civil';

  @override
  String get contextRelationshipSeparated => 'Séparé / Divorcé';

  @override
  String get contextRelationshipWidowed => 'Veuf / Veuve';

  @override
  String get contextRelationshipPreferNotToSay => 'Préfère ne pas dire';

  @override
  String get contextProfessionalStatusTitle => 'Statut professionnel actuel';

  @override
  String get contextProfessionalStatusOtherHint =>
      'Veuillez préciser votre statut professionnel';

  @override
  String get contextIndustryTitle => 'Secteur principal';

  @override
  String get contextWorkStatusStudent => 'Étudiant';

  @override
  String get contextWorkStatusUnemployed =>
      'Sans emploi / En recherche d\'emploi';

  @override
  String get contextWorkStatusEmployedIc => 'Employé (Contributeur individuel)';

  @override
  String get contextWorkStatusEmployedManagement => 'Employé (Gestion)';

  @override
  String get contextWorkStatusExecutive => 'Cadre / Direction (niveau C)';

  @override
  String get contextWorkStatusSelfEmployed =>
      'Travailleur indépendant / Freelance';

  @override
  String get contextWorkStatusEntrepreneur =>
      'Entrepreneur / Propriétaire d\'entreprise';

  @override
  String get contextWorkStatusInvestor => 'Investisseur';

  @override
  String get contextWorkStatusRetired => 'Retraité';

  @override
  String get contextWorkStatusHomemaker => 'Ménagère / Parent au foyer';

  @override
  String get contextWorkStatusCareerBreak => 'Congé carrière / Sabbatique';

  @override
  String get contextWorkStatusOther => 'Autre';

  @override
  String get contextIndustryTech => 'Technologie / IT';

  @override
  String get contextIndustryFinance => 'Finance / Investissements';

  @override
  String get contextIndustryHealthcare => 'Santé';

  @override
  String get contextIndustryEducation => 'Éducation';

  @override
  String get contextIndustrySalesMarketing => 'Ventes / Marketing';

  @override
  String get contextIndustryRealEstate => 'Immobilier';

  @override
  String get contextIndustryHospitality => 'Hôtellerie';

  @override
  String get contextIndustryGovernment => 'Gouvernement / Secteur public';

  @override
  String get contextIndustryCreative => 'Industries créatives';

  @override
  String get contextIndustryOther => 'Autre';

  @override
  String get contextSelfAssessmentIntro =>
      'Évaluez votre situation actuelle dans chaque domaine (1 = en difficulté, 5 = épanoui)';

  @override
  String get contextSelfHealthTitle => 'Santé & Énergie';

  @override
  String get contextSelfHealthSubtitle =>
      '1 = problèmes graves/faible énergie, 5 = excellente vitalité';

  @override
  String get contextSelfSocialTitle => 'Vie sociale';

  @override
  String get contextSelfSocialSubtitle =>
      '1 = isolé, 5 = connexions sociales épanouies';

  @override
  String get contextSelfRomanceTitle => 'Vie romantique';

  @override
  String get contextSelfRomanceSubtitle =>
      '1 = absente/difficile, 5 = épanouie';

  @override
  String get contextSelfFinanceTitle => 'Stabilité financière';

  @override
  String get contextSelfFinanceSubtitle =>
      '1 = grande difficulté, 5 = excellente';

  @override
  String get contextSelfCareerTitle => 'Satisfaction professionnelle';

  @override
  String get contextSelfCareerSubtitle =>
      '1 = bloqué/stressé, 5 = progrès/clarté';

  @override
  String get contextSelfGrowthTitle => 'Intérêt pour la croissance personnelle';

  @override
  String get contextSelfGrowthSubtitle => '1 = faible intérêt, 5 = très élevé';

  @override
  String get contextSelfStruggling => 'En difficulté';

  @override
  String get contextSelfThriving => 'Épanoui';

  @override
  String get contextPrioritiesTitle =>
      'Quelles sont vos principales priorités en ce moment ?';

  @override
  String get contextPrioritiesSubtitle =>
      'Sélectionnez jusqu\'à 2 domaines sur lesquels vous souhaitez vous concentrer';

  @override
  String get contextGuidanceStyleTitle => 'Style de guidance préféré';

  @override
  String get contextSensitivityTitle => 'Mode de sensibilité';

  @override
  String get contextSensitivitySubtitle =>
      'Évitez les formulations anxiogènes ou déterministes dans la guidance';

  @override
  String get contextPriorityHealth => 'Santé & habitudes';

  @override
  String get contextPriorityCareer => 'Croissance professionnelle';

  @override
  String get contextPriorityBusiness => 'Décisions d\'affaires';

  @override
  String get contextPriorityMoney => 'Argent & stabilité';

  @override
  String get contextPriorityLove => 'Amour & relations';

  @override
  String get contextPriorityFamily => 'Famille & parentalité';

  @override
  String get contextPrioritySocial => 'Vie sociale';

  @override
  String get contextPriorityGrowth => 'Croissance personnelle / état d\'esprit';

  @override
  String get contextGuidanceStyleDirect => 'Direct & pratique';

  @override
  String get contextGuidanceStyleDirectDesc =>
      'Allez droit au but avec des conseils pratiques';

  @override
  String get contextGuidanceStyleEmpathetic => 'Empathique & réfléchi';

  @override
  String get contextGuidanceStyleEmpatheticDesc =>
      'Guidance chaleureuse et soutenante';

  @override
  String get contextGuidanceStyleBalanced => 'Équilibré';

  @override
  String get contextGuidanceStyleBalancedDesc =>
      'Mélange de soutien pratique et émotionnel';

  @override
  String get homeGuidancePreparing =>
      'Lire les étoiles et demander à l\'Univers à votre sujet…';

  @override
  String get homeGuidanceFailed =>
      'Échec de la génération de la guidance. Veuillez réessayer.';

  @override
  String get homeGuidanceTimeout =>
      'Prend plus de temps que prévu. Appuyez sur Réessayer ou revenez dans un instant.';

  @override
  String get homeGuidanceLoadFailed => 'Échec du chargement de la guidance';

  @override
  String get homeTodaysGuidance => 'La guidance d\'aujourd\'hui';

  @override
  String get homeSeeAll => 'Voir tout';

  @override
  String get homeHealth => 'Santé';

  @override
  String get homeCareer => 'Carrière';

  @override
  String get homeMoney => 'Argent';

  @override
  String get homeLove => 'Amour';

  @override
  String get homePartners => 'Partenaires';

  @override
  String get homeGrowth => 'Croissance';

  @override
  String get homeTraveler => 'Voyageur';

  @override
  String homeGreeting(Object name) {
    return 'Bonjour, $name';
  }

  @override
  String get homeFocusFallback => 'Croissance personnelle';

  @override
  String get homeDailyMessage => 'Votre message quotidien';

  @override
  String get homeNatalChartTitle => 'Mon thème natal';

  @override
  String get homeNatalChartSubtitle =>
      'Explorez votre carte de naissance & interprétations';

  @override
  String get navHome => 'Accueil';

  @override
  String get navHistory => 'Historique';

  @override
  String get navGuide => 'Guide';

  @override
  String get navProfile => 'Profil';

  @override
  String get navForYou => 'Pour Vous';

  @override
  String get commonToday => 'Aujourd\'hui';

  @override
  String get commonTryAgain => 'Réessayer';

  @override
  String get natalChartTitle => 'Mon thème natal';

  @override
  String get natalChartTabTable => 'Table';

  @override
  String get natalChartTabChart => 'Graphique';

  @override
  String get natalChartEmptyTitle => 'Aucune donnée de carte natale';

  @override
  String get natalChartEmptySubtitle =>
      'Veuillez compléter vos données de naissance pour voir votre carte natale.';

  @override
  String get natalChartAddBirthData => 'Ajouter des données de naissance';

  @override
  String get natalChartErrorTitle => 'Impossible de charger le graphique';

  @override
  String get guidanceTitle => 'Guidance Quotidienne';

  @override
  String get guidanceLoadFailed => 'Échec du chargement de la guidance';

  @override
  String get guidanceNoneAvailable => 'Aucune guidance disponible';

  @override
  String get guidanceCosmicEnergyTitle => 'Énergie Cosmique d\'Aujourd\'hui';

  @override
  String get guidanceMoodLabel => 'Humeur';

  @override
  String get guidanceFocusLabel => 'Concentration';

  @override
  String get guidanceYourGuidance => 'Votre Guidance';

  @override
  String get guidanceTapToCollapse => 'Appuyez pour réduire';

  @override
  String get historyTitle => 'Historique de Guidance';

  @override
  String get historySubtitle => 'Votre voyage cosmique à travers le temps';

  @override
  String get historyLoadFailed => 'Échec du chargement de l\'historique';

  @override
  String get historyEmptyTitle => 'Pas encore d\'historique';

  @override
  String get historyEmptySubtitle =>
      'Vos guidances quotidiennes apparaîtront ici';

  @override
  String get historyNewBadge => 'NOUVEAU';

  @override
  String get commonUnlocked => 'Débloqué';

  @override
  String get commonComingSoon => 'Bientôt disponible';

  @override
  String get commonSomethingWentWrong => 'Quelque chose a mal tourné';

  @override
  String get commonNoContent => 'Aucun contenu disponible.';

  @override
  String get commonUnknownError => 'Erreur inconnue';

  @override
  String get commonTakingLonger =>
      'Prend plus de temps que prévu. Veuillez réessayer.';

  @override
  String commonErrorWithMessage(Object error) {
    return 'Erreur : $error';
  }

  @override
  String get forYouTitle => 'Pour Vous';

  @override
  String get forYouSubtitle => 'Aperçus cosmiques personnalisés';

  @override
  String get forYouNatalChartTitle => 'Ma Carte Natale';

  @override
  String get forYouNatalChartSubtitle => 'Analyse de votre carte de naissance';

  @override
  String get forYouCompatibilitiesTitle => 'Compatibilités';

  @override
  String get forYouCompatibilitiesSubtitle =>
      'Rapports sur l\'amour, l\'amitié et le partenariat';

  @override
  String get forYouKarmicTitle => 'Astrologie Karmique';

  @override
  String get forYouKarmicSubtitle =>
      'Leçons de l\'âme et schémas de vies passées';

  @override
  String get forYouLearnTitle => 'Apprendre l\'Astrologie';

  @override
  String get forYouLearnSubtitle => 'Contenu éducatif gratuit';

  @override
  String get compatibilitiesTitle => 'Compatibilités';

  @override
  String get compatibilitiesLoadFailed => 'Échec du chargement des services';

  @override
  String get compatibilitiesBetaFree =>
      'Bêta : Tous les rapports sont GRATUITS !';

  @override
  String get compatibilitiesChooseReport => 'Choisissez un Rapport';

  @override
  String get compatibilitiesSubtitle =>
      'Découvrez des aperçus sur vous-même et vos relations';

  @override
  String get compatibilitiesPartnerBadge => '+Partenaire';

  @override
  String get compatibilitiesPersonalityTitle => 'Rapport de Personnalité';

  @override
  String get compatibilitiesPersonalitySubtitle =>
      'Analyse complète de votre personnalité basée sur votre carte natale';

  @override
  String get compatibilitiesRomanticPersonalityTitle =>
      'Rapport de Personnalité Romantique';

  @override
  String get compatibilitiesRomanticPersonalitySubtitle =>
      'Comprenez comment vous abordez l\'amour et la romance';

  @override
  String get compatibilitiesLoveCompatibilityTitle => 'Compatibilité Amoureuse';

  @override
  String get compatibilitiesLoveCompatibilitySubtitle =>
      'Analyse détaillée de la compatibilité romantique avec votre partenaire';

  @override
  String get compatibilitiesRomanticForecastTitle =>
      'Prévisions pour Couples Romantiques';

  @override
  String get compatibilitiesRomanticForecastSubtitle =>
      'Aperçus sur l\'avenir de votre relation';

  @override
  String get compatibilitiesFriendshipTitle => 'Rapport d\'Amitié';

  @override
  String get compatibilitiesFriendshipSubtitle =>
      'Analyse des dynamiques d\'amitié et de compatibilité';

  @override
  String get moonPhaseTitle => 'Rapport de Phase Lunaire';

  @override
  String get moonPhaseSubtitle =>
      'Comprenez l\'énergie lunaire actuelle et comment elle vous affecte. Obtenez des conseils alignés avec la phase de la lune.';

  @override
  String get moonPhaseSelectDate => 'Sélectionner la Date';

  @override
  String get moonPhaseOriginalPrice => '\$2.99';

  @override
  String get moonPhaseGenerate => 'Générer le Rapport';

  @override
  String get moonPhaseGenerateDifferentDate =>
      'Générer pour une Date Différente';

  @override
  String get moonPhaseGenerationFailed => 'Échec de la génération';

  @override
  String get moonPhaseGenerating =>
      'Le rapport est en cours de génération. Veuillez réessayer.';

  @override
  String get moonPhaseUnknownError =>
      'Quelque chose a mal tourné. Veuillez réessayer.';

  @override
  String get requiredFieldsNote =>
      'Les champs marqués d\'un * sont obligatoires.';

  @override
  String get karmicTitle => 'Astrologie Karmique';

  @override
  String karmicLoadFailed(Object error) {
    return 'Échec du chargement : $error';
  }

  @override
  String get karmicOfferTitle => '🔮 Astrologie Karmique – Messages de l\'Âme';

  @override
  String get karmicOfferBody =>
      'L\'astrologie karmique révèle les schémas profonds qui façonnent votre vie, au-delà des événements quotidiens.\n\nElle offre une interprétation qui parle des leçons non résolues, des connexions karmiques et du chemin de croissance de l\'âme.\n\nCe n\'est pas une question de ce qui vient ensuite,\nmais de pourquoi vous vivez ce que vous vivez.\n\n✨ Activez l\'Astrologie Karmique et découvrez la signification plus profonde de votre parcours.';

  @override
  String get karmicBetaFreeBadge => 'Testeurs Bêta – Accès GRATUIT !';

  @override
  String karmicPriceBeta(Object price) {
    return '\$$price – Testeurs Bêta Gratuit';
  }

  @override
  String karmicPriceUnlock(Object price) {
    return 'Débloquer pour \$$price';
  }

  @override
  String get karmicHintInstant => 'Votre lecture sera générée instantanément';

  @override
  String get karmicHintOneTime => 'Achat unique, pas d\'abonnement';

  @override
  String get karmicProgressHint => 'Connexion à votre chemin karmique…';

  @override
  String karmicGenerateFailed(Object error) {
    return 'Échec de la génération : $error';
  }

  @override
  String get karmicCheckoutTitle => 'Paiement de l\'Astrologie Karmique';

  @override
  String get karmicCheckoutSubtitle => 'Flux d\'achat à venir';

  @override
  String karmicGenerationFailed(Object error) {
    return 'Échec de la génération : $error';
  }

  @override
  String get karmicLoading => 'Chargement de votre lecture karmique...';

  @override
  String get karmicGenerationFailedShort => 'Échec de la génération';

  @override
  String get karmicGeneratingTitle => 'Génération de Votre Lecture Karmique...';

  @override
  String get karmicGeneratingSubtitle =>
      'Analyse de votre carte natale pour des schémas karmiques et des leçons de l\'âme.';

  @override
  String get karmicReadingTitle => '🔮 Votre Lecture Karmique';

  @override
  String get karmicReadingSubtitle => 'Messages de l\'Âme';

  @override
  String get karmicDisclaimer =>
      'Cette lecture est destinée à l\'auto-réflexion et au divertissement. Elle ne constitue pas un conseil professionnel.';

  @override
  String get commonActive => 'Actif';

  @override
  String get commonBackToHome => 'Retour à l\'Accueil';

  @override
  String get commonYesterday => 'hier';

  @override
  String commonWeeksAgo(Object count) {
    return 'il y a $count semaines';
  }

  @override
  String commonMonthsAgo(Object count) {
    return 'il y a $count mois';
  }

  @override
  String get commonEdit => 'Modifier';

  @override
  String get commonDelete => 'Supprimer';

  @override
  String get natalChartProGenerated =>
      'Interprétations Pro générées ! Faites défiler vers le haut pour les voir.';

  @override
  String get natalChartHouse1 => 'Soi & Identité';

  @override
  String get natalChartHouse2 => 'Argent & Valeurs';

  @override
  String get natalChartHouse3 => 'Communication';

  @override
  String get natalChartHouse4 => 'Maison & Famille';

  @override
  String get natalChartHouse5 => 'Créativité & Romance';

  @override
  String get natalChartHouse6 => 'Santé & Routine';

  @override
  String get natalChartHouse7 => 'Relations';

  @override
  String get natalChartHouse8 => 'Transformation';

  @override
  String get natalChartHouse9 => 'Philosophie & Voyage';

  @override
  String get natalChartHouse10 => 'Carrière & Statut';

  @override
  String get natalChartHouse11 => 'Amis & Objectifs';

  @override
  String get natalChartHouse12 => 'Spiritualité';

  @override
  String get helpSupportTitle => 'Aide & Support';

  @override
  String get helpSupportContactTitle => 'Contacter le Support';

  @override
  String get helpSupportContactSubtitle =>
      'Nous répondons généralement dans les 24 heures';

  @override
  String get helpSupportFaqTitle => 'Questions Fréquemment Posées';

  @override
  String get helpSupportEmailSubject => 'Demande de Support Inner Wisdom';

  @override
  String get helpSupportEmailAppFailed =>
      'Impossible d\'ouvrir l\'application de messagerie. Veuillez envoyer un email à support@innerwisdomapp.com';

  @override
  String get helpSupportEmailFallback =>
      'Veuillez nous envoyer un email à support@innerwisdomapp.com';

  @override
  String get helpSupportFaq1Q =>
      'Quelle est la précision des conseils quotidiens ?';

  @override
  String get helpSupportFaq1A =>
      'Nos conseils quotidiens combinent des principes astrologiques traditionnels avec votre thème natal. Bien que l\'astrologie soit interprétative, notre IA fournit des insights personnalisés basés sur les positions et aspects planétaires réels.';

  @override
  String get helpSupportFaq2Q =>
      'Pourquoi ai-je besoin de mon heure de naissance ?';

  @override
  String get helpSupportFaq2A =>
      'Votre heure de naissance détermine votre Ascendant (signe ascendant) et les positions des maisons dans votre thème. Sans cela, nous utilisons midi par défaut, ce qui peut affecter la précision des interprétations liées aux maisons.';

  @override
  String get helpSupportFaq3Q =>
      'Comment puis-je changer mes données de naissance ?';

  @override
  String get helpSupportFaq3A =>
      'Actuellement, les données de naissance ne peuvent pas être modifiées après la configuration initiale pour garantir la cohérence de vos lectures. Contactez le support si vous devez apporter des corrections.';

  @override
  String get helpSupportFaq4Q => 'Qu\'est-ce qu\'un sujet de Focus ?';

  @override
  String get helpSupportFaq4A =>
      'Un sujet de Focus est une préoccupation actuelle ou un domaine de vie que vous souhaitez mettre en avant. Une fois défini, votre guidance quotidienne prêtera une attention particulière à ce domaine, fournissant des insights plus pertinents.';

  @override
  String get helpSupportFaq5Q => 'Comment fonctionne l\'abonnement ?';

  @override
  String get helpSupportFaq5A =>
      'Le niveau gratuit inclut des conseils quotidiens de base. Les abonnés premium bénéficient d\'une personnalisation améliorée, de lectures audio et d\'un accès à des fonctionnalités spéciales comme les lectures d\'astrologie karmique.';

  @override
  String get helpSupportFaq6Q => 'Mes données sont-elles privées ?';

  @override
  String get helpSupportFaq6A =>
      'Oui ! Nous prenons la vie privée au sérieux. Vos données de naissance et vos informations personnelles sont cryptées et jamais partagées avec des tiers. Vous pouvez supprimer votre compte à tout moment.';

  @override
  String get helpSupportFaq7Q =>
      'Que faire si je ne suis pas d\'accord avec une lecture ?';

  @override
  String get helpSupportFaq7A =>
      'L\'astrologie est interprétative, et toutes les lectures ne résonneront pas. Utilisez la fonction de retour d\'information pour nous aider à nous améliorer. Notre IA apprend de vos préférences au fil du temps.';

  @override
  String get notificationsSaved => 'Paramètres de notification enregistrés';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsSectionTitle => 'Notifications Push';

  @override
  String get notificationsDailyTitle => 'Conseils Quotidiens';

  @override
  String get notificationsDailySubtitle =>
      'Recevez une notification lorsque vos conseils quotidiens sont prêts';

  @override
  String get notificationsWeeklyTitle => 'Points Forts Hebdomadaires';

  @override
  String get notificationsWeeklySubtitle =>
      'Aperçu cosmique hebdomadaire et transits clés';

  @override
  String get notificationsSpecialTitle => 'Événements Spéciaux';

  @override
  String get notificationsSpecialSubtitle =>
      'Plein lunes, éclipses et rétrogrades';

  @override
  String get notificationsDeviceHint =>
      'Vous pouvez également contrôler les notifications dans les paramètres de votre appareil.';

  @override
  String get concernsTitle => 'Votre Focus';

  @override
  String get concernsSubtitle => 'Sujets façonnant votre guidance';

  @override
  String concernsTabActive(Object count) {
    return 'Actif ($count)';
  }

  @override
  String concernsTabResolved(Object count) {
    return 'Résolu ($count)';
  }

  @override
  String concernsTabArchived(Object count) {
    return 'Archivé ($count)';
  }

  @override
  String get concernsEmptyTitle => 'Aucune préoccupation ici';

  @override
  String get concernsEmptySubtitle =>
      'Ajoutez un sujet de focus pour obtenir des conseils personnalisés';

  @override
  String get concernsCategoryCareer => 'Carrière & Emploi';

  @override
  String get concernsCategoryHealth => 'Santé';

  @override
  String get concernsCategoryRelationship => 'Relation';

  @override
  String get concernsCategoryFamily => 'Famille';

  @override
  String get concernsCategoryMoney => 'Argent';

  @override
  String get concernsCategoryBusiness => 'Affaires';

  @override
  String get concernsCategoryPartnership => 'Partenariat';

  @override
  String get concernsCategoryGrowth => 'Croissance Personnelle';

  @override
  String get concernsMinLength =>
      'Veuillez décrire votre préoccupation plus en détail (au moins 10 caractères)';

  @override
  String get concernsSubmitFailed =>
      'Échec de l\'envoi de la préoccupation. Veuillez réessayer.';

  @override
  String get concernsAddTitle => 'Qu\'est-ce qui vous préoccupe ?';

  @override
  String get concernsAddDescription =>
      'Partagez votre préoccupation actuelle, question ou situation de vie. Notre IA l\'analysera et fournira des conseils ciblés à partir de demain.';

  @override
  String get concernsExamplesTitle => 'Exemples de préoccupations :';

  @override
  String get concernsExampleCareer => 'Décision de changement de carrière';

  @override
  String get concernsExampleRelationship => 'Défis relationnels';

  @override
  String get concernsExampleFinance => 'Timing d\'investissement financier';

  @override
  String get concernsExampleHealth =>
      'Concentration sur la santé et le bien-être';

  @override
  String get concernsExampleGrowth => 'Direction de la croissance personnelle';

  @override
  String get concernsSubmitButton => 'Soumettre la Préoccupation';

  @override
  String get concernsSuccessTitle => 'Préoccupation Enregistrée !';

  @override
  String get concernsCategoryLabel => 'Catégorie : ';

  @override
  String get concernsSuccessMessage =>
      'À partir de demain, votre guidance quotidienne se concentrera davantage sur ce sujet.';

  @override
  String get concernsViewFocusTopics => 'Voir Mes Sujets de Focus';

  @override
  String get deleteAccountTitle => 'Supprimer le Compte';

  @override
  String get deleteAccountHeading => 'Supprimer Votre Compte ?';

  @override
  String get deleteAccountConfirmError =>
      'Veuillez taper SUPPRIMER pour confirmer';

  @override
  String get deleteAccountFinalWarningTitle => 'Avertissement Final';

  @override
  String get deleteAccountFinalWarningBody =>
      'Cette action ne peut pas être annulée. Toutes vos données, y compris :\n\n• Votre profil et vos données de naissance\n• Thème natal et interprétations\n• Historique des conseils quotidiens\n• Contexte personnel et préférences\n• Tout contenu acheté\n\nSera définitivement supprimé.';

  @override
  String get deleteAccountConfirmButton => 'Supprimer Pour Toujours';

  @override
  String get deleteAccountSuccess => 'Votre compte a été supprimé';

  @override
  String get deleteAccountFailed =>
      'Échec de la suppression du compte. Veuillez réessayer.';

  @override
  String get deleteAccountPermanentWarning =>
      'Cette action est permanente et ne peut pas être annulée';

  @override
  String get deleteAccountWarningDetail =>
      'Toutes vos données personnelles, y compris votre thème natal, l\'historique des conseils et tout achat seront définitivement supprimés.';

  @override
  String get deleteAccountWhatTitle => 'Ce qui sera supprimé :';

  @override
  String get deleteAccountItemProfile => 'Votre profil et compte';

  @override
  String get deleteAccountItemBirthData =>
      'Données de naissance et thème natal';

  @override
  String get deleteAccountItemGuidance =>
      'Tout l\'historique des conseils quotidiens';

  @override
  String get deleteAccountItemContext => 'Contexte personnel & préférences';

  @override
  String get deleteAccountItemKarmic => 'Lectures d\'astrologie karmique';

  @override
  String get deleteAccountItemPurchases => 'Tout le contenu acheté';

  @override
  String get deleteAccountTypeDelete => 'Tapez SUPPRIMER pour confirmer';

  @override
  String get deleteAccountDeleteHint => 'SUPPRIMER';

  @override
  String get deleteAccountButton => 'Supprimer Mon Compte';

  @override
  String get deleteAccountCancel => 'Annuler, garder mon compte';

  @override
  String get learnArticleLoadFailed => 'Échec du chargement de l\'article';

  @override
  String get learnContentInEnglish => 'Contenu en anglais';

  @override
  String get learnArticlesLoadFailed => 'Échec du chargement des articles';

  @override
  String get learnArticlesEmpty => 'Aucun article disponible pour le moment';

  @override
  String get learnContentFallback =>
      'Affichage du contenu en anglais (non disponible dans votre langue)';

  @override
  String get checkoutTitle => 'Paiement';

  @override
  String get checkoutOrderSummary => 'Résumé de la Commande';

  @override
  String get checkoutProTitle => 'Thème Natal Pro';

  @override
  String get checkoutProSubtitle => 'Interprétations planétaires complètes';

  @override
  String get checkoutTotalLabel => 'Total';

  @override
  String get checkoutTotalAmount => '9,99 \$ USD';

  @override
  String get checkoutPaymentTitle => 'Intégration de Paiement';

  @override
  String get checkoutPaymentSubtitle =>
      'L\'intégration d\'achat dans l\'application est en cours de finalisation. Veuillez revenir bientôt !';

  @override
  String get checkoutProcessing => 'Traitement...';

  @override
  String get checkoutDemoPurchase => 'Achat Démo (Test)';

  @override
  String get checkoutSecurityNote =>
      'Le paiement est traité de manière sécurisée via Apple/Google. Vos informations de carte ne sont jamais stockées.';

  @override
  String get checkoutSuccess => '🎉 Carte Natal Pro débloquée avec succès !';

  @override
  String get checkoutGenerateFailed =>
      'Échec de la génération des interprétations. Veuillez réessayer.';

  @override
  String checkoutErrorWithMessage(Object error) {
    return 'Une erreur est survenue : $error';
  }

  @override
  String get billingUpgrade => 'Passer à Premium';

  @override
  String billingFeatureLocked(Object feature) {
    return '$feature est une fonctionnalité Premium';
  }

  @override
  String get billingUpgradeBody =>
      'Passez à Premium pour débloquer cette fonctionnalité et obtenir des conseils plus personnalisés.';

  @override
  String get contextReviewFailed =>
      'Échec de la mise à jour. Veuillez réessayer.';

  @override
  String get contextReviewTitle => 'Temps pour un rapide point';

  @override
  String get contextReviewBody =>
      'Cela fait 3 mois depuis notre dernière mise à jour de votre contexte personnel. Y a-t-il eu des changements importants dans votre vie dont nous devrions être informés ?';

  @override
  String get contextReviewHint =>
      'Cela nous aide à vous donner des conseils plus personnalisés.';

  @override
  String get contextReviewNoChanges => 'Aucun changement';

  @override
  String get contextReviewYesUpdate => 'Oui, mettre à jour';

  @override
  String get contextProfileLoadFailed => 'Échec du chargement du profil';

  @override
  String get contextCardTitle => 'Contexte Personnel';

  @override
  String get contextCardSubtitle =>
      'Configurez votre contexte personnel pour recevoir des conseils plus adaptés.';

  @override
  String get contextCardSetupNow => 'Configurer Maintenant';

  @override
  String contextCardVersionUpdated(Object version, Object date) {
    return 'Version $version • Dernière mise à jour $date';
  }

  @override
  String get contextCardAiSummary => 'Résumé IA';

  @override
  String contextCardToneTag(Object tone) {
    return 'ton $tone';
  }

  @override
  String get contextCardSensitivityTag => 'sensibilité activée';

  @override
  String get contextCardReviewDue =>
      'Révision due - mettez à jour votre contexte';

  @override
  String contextCardNextReview(Object days) {
    return 'Prochaine révision dans $days jours';
  }

  @override
  String get contextDeleteTitle => 'Supprimer le Contexte Personnel ?';

  @override
  String get contextDeleteBody =>
      'Cela supprimera votre profil de contexte personnel. Vos conseils deviendront moins personnalisés.';

  @override
  String get contextDeleteFailed => 'Échec de la suppression du profil';

  @override
  String get appTitle => 'Sagesse Intérieure';

  @override
  String get concernsHintExample =>
      'Exemple : J\'ai une offre d\'emploi dans une autre ville et je ne suis pas sûr de l\'accepter...';

  @override
  String get learnTitle => 'Apprendre l\'Astrologie';

  @override
  String get learnFreeTitle => 'Ressources d\'Apprentissage Gratuites';

  @override
  String get learnFreeSubtitle => 'Explorez les fondamentaux de l\'astrologie';

  @override
  String get learnSignsTitle => 'Signes';

  @override
  String get learnSignsSubtitle =>
      '12 signes du zodiaque et leurs significations';

  @override
  String get learnPlanetsTitle => 'Planètes';

  @override
  String get learnPlanetsSubtitle => 'Corps célestes en astrologie';

  @override
  String get learnHousesTitle => 'Maisons';

  @override
  String get learnHousesSubtitle => '12 domaines de vie dans votre carte';

  @override
  String get learnTransitsTitle => 'Transits';

  @override
  String get learnTransitsSubtitle => 'Mouvements planétaires & effets';

  @override
  String get learnPaceTitle => 'Apprenez à Votre Rythme';

  @override
  String get learnPaceSubtitle =>
      'Leçons complètes pour approfondir vos connaissances astrologiques';

  @override
  String get proNatalTitle => 'Carte Natal Pro';

  @override
  String get proNatalHeroTitle => 'Débloquez des Insights Profonds';

  @override
  String get proNatalHeroSubtitle =>
      'Obtenez des interprétations complètes de 150 à 200 mots pour chaque placement planétaire dans votre carte de naissance.';

  @override
  String get proNatalFeature1Title => 'Insights Profonds sur la Personnalité';

  @override
  String get proNatalFeature1Body =>
      'Comprenez comment chaque planète façonne votre personnalité unique et votre chemin de vie.';

  @override
  String get proNatalFeature2Title => 'Analyse Alimentée par IA';

  @override
  String get proNatalFeature2Body =>
      'Interprétations avancées adaptées à vos positions planétaires exactes.';

  @override
  String get proNatalFeature3Title => 'Conseils Actionnables';

  @override
  String get proNatalFeature3Body =>
      'Conseils pratiques pour la carrière, les relations et la croissance personnelle.';

  @override
  String get proNatalFeature4Title => 'Accès à Vie';

  @override
  String get proNatalFeature4Body =>
      'Vos interprétations sont sauvegardées pour toujours. Accédez-y à tout moment.';

  @override
  String get proNatalOneTime => 'Achat unique';

  @override
  String get proNatalNoSubscription => 'Aucun abonnement requis';
}

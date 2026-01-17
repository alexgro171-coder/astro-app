// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get onboardingSkip => 'Überspringen';

  @override
  String get onboardingTitle1 => 'Willkommen bei Inner Wisdom Astro';

  @override
  String get onboardingDesc1 =>
      'Innerwisdom Astro vereint über 30 Jahre astrologische Expertise von Madi G. mit der Kraft fortschrittlicher KI und schafft eine der raffiniertesten und leistungsstärksten Astrologie-Anwendungen, die heute verfügbar ist.\n\nDurch die Kombination von tiefem menschlichen Verständnis mit intelligenter Technologie bietet Innerwisdom Astro präzise, personalisierte und bedeutungsvolle Interpretationen, die die Benutzer auf ihrer Reise der Selbstentdeckung, Klarheit und bewussten Entwicklung unterstützen.';

  @override
  String get onboardingTitle2 => 'Ihre vollständige astrologische Reise';

  @override
  String get onboardingDesc2 =>
      'Von personalisierten täglichen Anleitungen bis zu Ihrem Natal Birth Chart, karmischer Astrologie, tiefgehenden Persönlichkeitsberichten, Liebes- und Freundschaftskompatibilität, romantischen Vorhersagen für Paare und vielem mehr – alles ist jetzt in Ihren Händen.\n\nEntwickelt, um Klarheit, Verbindung und Selbstverständnis zu unterstützen, bietet Innerwisdom Astro ein vollständiges astrologisches Erlebnis, das auf Sie zugeschnitten ist.';

  @override
  String get onboardingNext => 'Weiter';

  @override
  String get onboardingGetStarted => 'Loslegen';

  @override
  String get onboardingAlreadyHaveAccount =>
      'Haben Sie bereits ein Konto? Anmelden';

  @override
  String get birthDataTitle => 'Ihr Geburtshoroskop';

  @override
  String get birthDataSubtitle =>
      'Wir benötigen Ihre Geburtsdaten, um\nIhr personalisiertes astrologisches Profil zu erstellen';

  @override
  String get birthDateLabel => 'Geburtsdatum';

  @override
  String get birthDateSelectHint => 'Wählen Sie Ihr Geburtsdatum';

  @override
  String get birthTimeLabel => 'Geburtszeit';

  @override
  String get birthTimeUnknown => 'Unbekannt';

  @override
  String get birthTimeSelectHint => 'Wählen Sie Ihre Geburtszeit';

  @override
  String get birthTimeUnknownCheckbox =>
      'Ich kenne meine genaue Geburtszeit nicht';

  @override
  String get birthPlaceLabel => 'Geburtsort';

  @override
  String get birthPlaceHint => 'Beginnen Sie, einen Städtenamen einzugeben...';

  @override
  String get birthPlaceValidation =>
      'Bitte wählen Sie einen Standort aus den Vorschlägen';

  @override
  String birthPlaceSelected(Object location) {
    return 'Ausgewählt: $location';
  }

  @override
  String get genderLabel => 'Geschlecht';

  @override
  String get genderMale => 'Männlich';

  @override
  String get genderFemale => 'Weiblich';

  @override
  String get genderPreferNotToSay => 'Bevorzuge es, nichts zu sagen';

  @override
  String get birthDataSubmit => 'Mein Geburtshoroskop erstellen';

  @override
  String get birthDataPrivacyNote =>
      'Ihre Geburtsdaten werden nur zur Berechnung Ihres\nastrologischen Horoskops verwendet und sicher gespeichert.';

  @override
  String get birthDateMissing => 'Bitte wählen Sie Ihr Geburtsdatum';

  @override
  String get birthPlaceMissing =>
      'Bitte wählen Sie einen Geburtsort aus den Vorschlägen';

  @override
  String get birthDataSaveError =>
      'Geburtsdaten konnten nicht gespeichert werden. Bitte versuchen Sie es erneut.';

  @override
  String get appearanceTitle => 'Erscheinungsbild';

  @override
  String get appearanceTheme => 'Thema';

  @override
  String get appearanceDarkTitle => 'Dunkel';

  @override
  String get appearanceDarkSubtitle => 'Augenfreundlich bei schwachem Licht';

  @override
  String get appearanceLightTitle => 'Hell';

  @override
  String get appearanceLightSubtitle => 'Klassisches helles Erscheinungsbild';

  @override
  String get appearanceSystemTitle => 'System';

  @override
  String get appearanceSystemSubtitle => 'Entspricht Ihren Geräteeinstellungen';

  @override
  String get appearancePreviewTitle => 'Vorschau';

  @override
  String get appearancePreviewBody =>
      'Das kosmische Thema ist darauf ausgelegt, ein immersives Astrologie-Erlebnis zu schaffen. Das dunkle Thema wird für das beste visuelle Erlebnis empfohlen.';

  @override
  String appearanceThemeChanged(Object theme) {
    return 'Thema geändert zu $theme';
  }

  @override
  String get profileUserFallback => 'Benutzer';

  @override
  String get profilePersonalContext => 'Persönlicher Kontext';

  @override
  String get profileSettings => 'Einstellungen';

  @override
  String get profileAppLanguage => 'App-Sprache';

  @override
  String get profileContentLanguage => 'Inhaltssprache';

  @override
  String get profileContentLanguageHint =>
      'KI-Inhalte verwenden die ausgewählte Sprache.';

  @override
  String get profileNotifications => 'Benachrichtigungen';

  @override
  String get profileNotificationsEnabled => 'Aktiviert';

  @override
  String get profileNotificationsDisabled => 'Deaktiviert';

  @override
  String get profileAppearance => 'Erscheinungsbild';

  @override
  String get profileHelpSupport => 'Hilfe & Unterstützung';

  @override
  String get profilePrivacyPolicy => 'Datenschutzrichtlinie';

  @override
  String get profileTermsOfService => 'Nutzungsbedingungen';

  @override
  String get profileLogout => 'Abmelden';

  @override
  String get profileLogoutConfirm =>
      'Sind Sie sicher, dass Sie sich abmelden möchten?';

  @override
  String get profileDeleteAccount => 'Konto löschen';

  @override
  String get commonCancel => 'Abbrechen';

  @override
  String get profileSelectLanguageTitle => 'Sprache auswählen';

  @override
  String get profileSelectLanguageSubtitle =>
      'Alle KI-generierten Inhalte werden in Ihrer ausgewählten Sprache angezeigt.';

  @override
  String profileLanguageUpdated(Object language) {
    return 'Sprache auf $language aktualisiert';
  }

  @override
  String profileLanguageUpdateFailed(Object error) {
    return 'Fehler beim Aktualisieren der Sprache: $error';
  }

  @override
  String profileVersion(Object version) {
    return 'Inner Wisdom v$version';
  }

  @override
  String get profileCosmicBlueprint => 'Ihr kosmischer Plan';

  @override
  String get profileSunLabel => '☀️ Sonne';

  @override
  String get profileMoonLabel => '🌙 Mond';

  @override
  String get profileRisingLabel => '⬆️ Aszendent';

  @override
  String get profileUnknown => 'Unbekannt';

  @override
  String get forgotPasswordTitle => 'Passwort vergessen?';

  @override
  String get forgotPasswordSubtitle =>
      'Geben Sie Ihre E-Mail-Adresse ein, und wir senden Ihnen einen Code, um Ihr Passwort zurückzusetzen';

  @override
  String get forgotPasswordSent =>
      'Wenn ein Konto existiert, wurde ein Rücksetzcode an Ihre E-Mail-Adresse gesendet.';

  @override
  String get forgotPasswordFailed =>
      'Fehler beim Senden des Rücksetzcodes. Bitte versuchen Sie es erneut.';

  @override
  String get forgotPasswordSendCode => 'Rücksetzcode senden';

  @override
  String get forgotPasswordHaveCode => 'Haben Sie bereits einen Code?';

  @override
  String get forgotPasswordRemember => 'Erinnern Sie sich an Ihr Passwort? ';

  @override
  String get loginWelcomeBack => 'Willkommen zurück';

  @override
  String get loginSubtitle =>
      'Melden Sie sich an, um Ihre kosmische Reise fortzusetzen';

  @override
  String get loginInvalidCredentials => 'Ungültige E-Mail oder Passwort';

  @override
  String get loginGoogleFailed =>
      'Google-Anmeldung fehlgeschlagen. Bitte versuchen Sie es erneut.';

  @override
  String get loginAppleFailed =>
      'Apple-Anmeldung fehlgeschlagen. Bitte versuchen Sie es erneut.';

  @override
  String get loginNetworkError =>
      'Netzwerkfehler. Bitte überprüfen Sie Ihre Verbindung.';

  @override
  String get loginSignInCancelled => 'Anmeldung wurde abgebrochen.';

  @override
  String get loginPasswordHint => 'Geben Sie Ihr Passwort ein';

  @override
  String get loginForgotPassword => 'Passwort vergessen?';

  @override
  String get loginSignIn => 'Anmelden';

  @override
  String get loginNoAccount => 'Haben Sie kein Konto? ';

  @override
  String get loginSignUp => 'Registrieren';

  @override
  String get commonEmailLabel => 'E-Mail';

  @override
  String get commonEmailHint => 'Geben Sie Ihre E-Mail-Adresse ein';

  @override
  String get commonEmailRequired => 'Bitte geben Sie Ihre E-Mail-Adresse ein';

  @override
  String get commonEmailInvalid =>
      'Bitte geben Sie eine gültige E-Mail-Adresse ein';

  @override
  String get commonPasswordLabel => 'Passwort';

  @override
  String get commonPasswordRequired => 'Bitte geben Sie Ihr Passwort ein';

  @override
  String get commonOrContinueWith => 'oder fortfahren mit';

  @override
  String get commonGoogle => 'Google';

  @override
  String get commonApple => 'Apple';

  @override
  String get commonNameLabel => 'Name';

  @override
  String get commonNameHint => 'Geben Sie Ihren Namen ein';

  @override
  String get commonNameRequired => 'Bitte geben Sie Ihren Namen ein';

  @override
  String get signupTitle => 'Konto erstellen';

  @override
  String get signupSubtitle =>
      'Beginnen Sie Ihre kosmische Reise mit Inner Wisdom';

  @override
  String get signupEmailExists =>
      'E-Mail existiert bereits oder ungültige Daten';

  @override
  String get signupGoogleFailed =>
      'Google-Anmeldung fehlgeschlagen. Bitte versuchen Sie es erneut.';

  @override
  String get signupAppleFailed =>
      'Apple-Anmeldung fehlgeschlagen. Bitte versuchen Sie es erneut.';

  @override
  String get signupPasswordHint =>
      'Erstellen Sie ein Passwort (mind. 8 Zeichen)';

  @override
  String get signupPasswordMin =>
      'Das Passwort muss mindestens 8 Zeichen lang sein';

  @override
  String get signupConfirmPasswordLabel => 'Passwort bestätigen';

  @override
  String get signupConfirmPasswordHint => 'Bestätigen Sie Ihr Passwort';

  @override
  String get signupConfirmPasswordRequired =>
      'Bitte bestätigen Sie Ihr Passwort';

  @override
  String get signupPasswordMismatch => 'Passwörter stimmen nicht überein';

  @override
  String get signupPreferredLanguage => 'Bevorzugte Sprache';

  @override
  String get signupCreateAccount => 'Konto erstellen';

  @override
  String get signupHaveAccount => 'Haben Sie bereits ein Konto? ';

  @override
  String get resetPasswordTitle => 'Passwort zurücksetzen';

  @override
  String get resetPasswordSubtitle =>
      'Geben Sie den an Ihre E-Mail gesendeten Code ein und setzen Sie ein neues Passwort';

  @override
  String get resetPasswordSuccess =>
      'Passwort erfolgreich zurückgesetzt! Weiterleitung zur Anmeldung...';

  @override
  String get resetPasswordFailed =>
      'Zurücksetzen des Passworts fehlgeschlagen. Bitte versuchen Sie es erneut.';

  @override
  String get resetPasswordInvalidCode =>
      'Ungültiger oder abgelaufener Rücksetzungscode. Bitte fordern Sie einen neuen an.';

  @override
  String get resetPasswordMaxAttempts =>
      'Maximale Versuche überschritten. Bitte fordern Sie einen neuen Code an.';

  @override
  String get resetCodeLabel => 'Rücksetzungscode';

  @override
  String get resetCodeHint => 'Geben Sie den 6-stelligen Code ein';

  @override
  String get resetCodeRequired => 'Bitte geben Sie den Rücksetzungscode ein';

  @override
  String get resetCodeLength => 'Der Code muss 6 Ziffern haben';

  @override
  String get resetNewPasswordLabel => 'Neues Passwort';

  @override
  String get resetNewPasswordHint =>
      'Erstellen Sie ein neues Passwort (mind. 8 Zeichen)';

  @override
  String get resetNewPasswordRequired =>
      'Bitte geben Sie ein neues Passwort ein';

  @override
  String get resetConfirmPasswordHint => 'Bestätigen Sie Ihr neues Passwort';

  @override
  String get resetPasswordButton => 'Passwort zurücksetzen';

  @override
  String get resetRequestNewCode => 'Neuen Code anfordern';

  @override
  String get serviceResultGenerated => 'Bericht erstellt';

  @override
  String serviceResultReady(Object title) {
    return 'Ihr personalisierter $title ist bereit';
  }

  @override
  String get serviceResultBackToForYou => 'Zurück zu Für Sie';

  @override
  String get serviceResultNotSavedNotice =>
      'Dieser Bericht wird nicht gespeichert. Wenn Sie möchten, können Sie ihn kopieren und an anderer Stelle mit der Kopierfunktion speichern.';

  @override
  String get commonCopy => 'Kopieren';

  @override
  String get commonCopied => 'In die Zwischenablage kopiert';

  @override
  String get commonContinue => 'Fortfahren';

  @override
  String get partnerDetailsTitle => 'Partnerdetails';

  @override
  String get partnerBirthDataTitle =>
      'Geben Sie die Geburtsdaten des Partners ein';

  @override
  String partnerBirthDataFor(Object title) {
    return 'Für \"$title\"';
  }

  @override
  String get partnerNameOptionalLabel => 'Name (optional)';

  @override
  String get partnerNameHint => 'Name des Partners';

  @override
  String get partnerGenderOptionalLabel => 'Geschlecht (optional)';

  @override
  String get partnerBirthDateLabel => 'Geburtsdatum *';

  @override
  String get partnerBirthDateSelect => 'Geburtsdatum auswählen';

  @override
  String get partnerBirthDateMissing => 'Bitte wählen Sie das Geburtsdatum aus';

  @override
  String get partnerBirthTimeOptionalLabel => 'Geburtszeit (optional)';

  @override
  String get partnerBirthTimeSelect => 'Geburtszeit auswählen';

  @override
  String get partnerBirthPlaceLabel => 'Geburtsort *';

  @override
  String get serviceOfferRequiresPartner =>
      'Benötigt Geburtsdaten des Partners';

  @override
  String get serviceOfferBetaFree => 'Beta-Tester erhalten kostenlosen Zugang!';

  @override
  String get serviceOfferUnlocked => 'Freigeschaltet';

  @override
  String get serviceOfferGenerate => 'Bericht erstellen';

  @override
  String serviceOfferUnlockFor(Object price) {
    return 'Freischalten für $price';
  }

  @override
  String get serviceOfferPreparing =>
      'Bereite Ihren personalisierten Bericht vor…';

  @override
  String get serviceOfferTimeout =>
      'Dauert länger als erwartet. Bitte versuchen Sie es erneut.';

  @override
  String get serviceOfferNotReady =>
      'Bericht noch nicht bereit. Bitte versuchen Sie es erneut.';

  @override
  String serviceOfferFetchFailed(Object error) {
    return 'Bericht konnte nicht abgerufen werden: $error';
  }

  @override
  String get commonFree => 'KOSTENLOS';

  @override
  String get commonLater => 'Später';

  @override
  String get commonRetry => 'Erneut versuchen';

  @override
  String get commonYes => 'Ja';

  @override
  String get commonNo => 'Nein';

  @override
  String get commonBack => 'Zurück';

  @override
  String get commonOptional => 'Optional';

  @override
  String get commonNotSpecified => 'Nicht angegeben';

  @override
  String get commonJustNow => 'Gerade eben';

  @override
  String get commonViewMore => 'Mehr anzeigen';

  @override
  String get commonViewLess => 'Weniger anzeigen';

  @override
  String commonMinutesAgo(Object count) {
    return 'Vor $count Min.';
  }

  @override
  String commonHoursAgo(Object count) {
    return 'Vor ${count}h';
  }

  @override
  String commonDaysAgo(Object count) {
    return 'Vor ${count}d';
  }

  @override
  String commonDateShort(Object day, Object month, Object year) {
    return '$day/$month/$year';
  }

  @override
  String get askGuideTitle => 'Fragen Sie Ihren Guide';

  @override
  String get askGuideSubtitle => 'Persönliche kosmische Anleitung';

  @override
  String askGuideRemaining(Object count) {
    return '$count übrig';
  }

  @override
  String get askGuideQuestionHint =>
      'Fragen Sie alles - Liebe, Karriere, Entscheidungen, Emotionen...';

  @override
  String get askGuideBasedOnChart =>
      'Basierend auf Ihrem Geburtshoroskop & den kosmischen Energien von heute';

  @override
  String get askGuideThinking => 'Ihr Guide denkt nach...';

  @override
  String get askGuideYourGuide => 'Ihr Guide';

  @override
  String get askGuideEmptyTitle => 'Stellen Sie Ihre erste Frage';

  @override
  String get askGuideEmptyBody =>
      'Erhalten Sie sofortige, tief persönliche Anleitung basierend auf Ihrem Geburtshoroskop und den kosmischen Energien von heute.';

  @override
  String get askGuideEmptyHint =>
      'Fragen Sie alles — Liebe, Karriere, Entscheidungen, Emotionen.';

  @override
  String get askGuideLoadFailed => 'Daten konnten nicht geladen werden';

  @override
  String askGuideSendFailed(Object error) {
    return 'Frage konnte nicht gesendet werden: $error';
  }

  @override
  String get askGuideLimitTitle => 'Monatliches Limit erreicht';

  @override
  String get askGuideLimitBody =>
      'Sie haben Ihr monatliches Anfrage-Limit erreicht.';

  @override
  String get askGuideLimitAddon =>
      'Sie können ein Add-On für 1,99 \$ erwerben, um diesen Dienst für den Rest des aktuellen Abrechnungsmonats weiter zu nutzen.';

  @override
  String askGuideLimitBillingEnd(Object date) {
    return 'Ihr Abrechnungsmonat endet am: $date';
  }

  @override
  String get askGuideLimitGetAddon => 'Add-On holen';

  @override
  String get contextTitle => 'Persönlicher Kontext';

  @override
  String contextStepOf(Object current, Object total) {
    return 'Schritt $current von $total';
  }

  @override
  String get contextStep1Title => 'Menschen um Sie herum';

  @override
  String get contextStep1Subtitle =>
      'Ihr Beziehungs- und Familienkontext hilft uns, Ihre emotionale Landschaft zu verstehen.';

  @override
  String get contextStep2Title => 'Berufliches Leben';

  @override
  String get contextStep2Subtitle =>
      'Ihre Arbeit und Ihr täglicher Rhythmus prägen, wie Sie Druck, Wachstum und Sinn erleben.';

  @override
  String get contextStep3Title => 'Wie sich das Leben gerade anfühlt';

  @override
  String get contextStep3Subtitle =>
      'Es gibt keine richtigen oder falschen Antworten, nur Ihre aktuelle Realität';

  @override
  String get contextStep4Title => 'Was Ihnen am wichtigsten ist';

  @override
  String get contextStep4Subtitle =>
      'Damit Ihre Anleitung mit dem übereinstimmt, was Ihnen wirklich wichtig ist';

  @override
  String get contextPriorityRequired =>
      'Bitte wählen Sie mindestens einen Prioritätsbereich aus.';

  @override
  String contextSaveFailed(Object error) {
    return 'Profil konnte nicht gespeichert werden: $error';
  }

  @override
  String get contextSaveContinue => 'Speichern & Fortfahren';

  @override
  String get contextRelationshipStatusTitle => 'Aktueller Beziehungsstatus';

  @override
  String get contextSeekingRelationshipTitle => 'Suchen Sie eine Beziehung?';

  @override
  String get contextHasChildrenTitle => 'Haben Sie Kinder?';

  @override
  String get contextChildrenDetailsOptional => 'Details zu Kindern (optional)';

  @override
  String get contextAddChild => 'Kind hinzufügen';

  @override
  String get contextChildAgeLabel => 'Alter';

  @override
  String contextChildAgeYears(num age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other: 'Jahre',
      one: 'Jahr',
    );
    return '$age $_temp0';
  }

  @override
  String get contextChildGenderLabel => 'Geschlecht';

  @override
  String get contextRelationshipSingle => 'Ledig';

  @override
  String get contextRelationshipInRelationship => 'In einer Beziehung';

  @override
  String get contextRelationshipMarried =>
      'Verheiratet / Eingetragene Partnerschaft';

  @override
  String get contextRelationshipSeparated => 'Getrennt / Geschieden';

  @override
  String get contextRelationshipWidowed => 'Witwe/Witwer';

  @override
  String get contextRelationshipPreferNotToSay => 'Möchte ich nicht sagen';

  @override
  String get contextProfessionalStatusTitle => 'Aktueller beruflicher Status';

  @override
  String get contextProfessionalStatusOtherHint =>
      'Bitte geben Sie Ihren Arbeitsstatus an';

  @override
  String get contextIndustryTitle => 'Hauptbranche/Bereich';

  @override
  String get contextWorkStatusStudent => 'Student';

  @override
  String get contextWorkStatusUnemployed => 'Arbeitslos / Zwischenjobs';

  @override
  String get contextWorkStatusEmployedIc => 'Angestellt (Einzelbeitragender)';

  @override
  String get contextWorkStatusEmployedManagement => 'Angestellt (Management)';

  @override
  String get contextWorkStatusExecutive => 'Führungskraft / Leitung (C-Level)';

  @override
  String get contextWorkStatusSelfEmployed => 'Selbstständig / Freiberufler';

  @override
  String get contextWorkStatusEntrepreneur => 'Unternehmer / Geschäftsinhaber';

  @override
  String get contextWorkStatusInvestor => 'Investor';

  @override
  String get contextWorkStatusRetired => 'In Rente';

  @override
  String get contextWorkStatusHomemaker =>
      'Hausfrau/Hausmann / Elternteil, der zu Hause bleibt';

  @override
  String get contextWorkStatusCareerBreak => 'Berufliche Auszeit / Sabbatical';

  @override
  String get contextWorkStatusOther => 'Sonstiges';

  @override
  String get contextIndustryTech => 'Technologie / IT';

  @override
  String get contextIndustryFinance => 'Finanzen / Investitionen';

  @override
  String get contextIndustryHealthcare => 'Gesundheitswesen';

  @override
  String get contextIndustryEducation => 'Bildung';

  @override
  String get contextIndustrySalesMarketing => 'Vertrieb / Marketing';

  @override
  String get contextIndustryRealEstate => 'Immobilien';

  @override
  String get contextIndustryHospitality => 'Gastgewerbe';

  @override
  String get contextIndustryGovernment => 'Regierung / Öffentlicher Sektor';

  @override
  String get contextIndustryCreative => 'Kreativwirtschaft';

  @override
  String get contextIndustryOther => 'Sonstiges';

  @override
  String get contextSelfAssessmentIntro =>
      'Bewerten Sie Ihre aktuelle Situation in jedem Bereich (1 = Schwierigkeiten, 5 = blühend)';

  @override
  String get contextSelfHealthTitle => 'Gesundheit & Energie';

  @override
  String get contextSelfHealthSubtitle =>
      '1 = ernsthafte Probleme/niedrige Energie, 5 = ausgezeichnete Vitalität';

  @override
  String get contextSelfSocialTitle => 'Soziales Leben';

  @override
  String get contextSelfSocialSubtitle =>
      '1 = isoliert, 5 = blühende soziale Kontakte';

  @override
  String get contextSelfRomanceTitle => 'Romantisches Leben';

  @override
  String get contextSelfRomanceSubtitle =>
      '1 = abwesend/herausfordernd, 5 = erfüllt';

  @override
  String get contextSelfFinanceTitle => 'Finanzielle Stabilität';

  @override
  String get contextSelfFinanceSubtitle =>
      '1 = große Schwierigkeiten, 5 = ausgezeichnet';

  @override
  String get contextSelfCareerTitle => 'Karrierezufriedenheit';

  @override
  String get contextSelfCareerSubtitle =>
      '1 = festgefahren/stressig, 5 = Fortschritt/Klarheit';

  @override
  String get contextSelfGrowthTitle => 'Interesse an persönlichem Wachstum';

  @override
  String get contextSelfGrowthSubtitle =>
      '1 = geringes Interesse, 5 = sehr hoch';

  @override
  String get contextSelfStruggling => 'Kämpfen';

  @override
  String get contextSelfThriving => 'Gedeihen';

  @override
  String get contextPrioritiesTitle =>
      'Was sind Ihre wichtigsten Prioritäten gerade?';

  @override
  String get contextPrioritiesSubtitle =>
      'Wählen Sie bis zu 2 Bereiche, auf die Sie sich konzentrieren möchten';

  @override
  String get contextGuidanceStyleTitle => 'Bevorzugter Beratungsstil';

  @override
  String get contextSensitivityTitle => 'Sensitivitätsmodus';

  @override
  String get contextSensitivitySubtitle =>
      'Vermeiden Sie angstinduzierende oder deterministische Formulierungen in der Beratung';

  @override
  String get contextPriorityHealth => 'Gesundheit & Gewohnheiten';

  @override
  String get contextPriorityCareer => 'Karrierewachstum';

  @override
  String get contextPriorityBusiness => 'Geschäftsentscheidungen';

  @override
  String get contextPriorityMoney => 'Geld & Stabilität';

  @override
  String get contextPriorityLove => 'Liebe & Beziehung';

  @override
  String get contextPriorityFamily => 'Familie & Elternschaft';

  @override
  String get contextPrioritySocial => 'Soziales Leben';

  @override
  String get contextPriorityGrowth => 'Persönliches Wachstum / Denkweise';

  @override
  String get contextGuidanceStyleDirect => 'Direkt & praktisch';

  @override
  String get contextGuidanceStyleDirectDesc =>
      'Direkt zu umsetzbaren Ratschlägen';

  @override
  String get contextGuidanceStyleEmpathetic => 'Empathisch & reflektierend';

  @override
  String get contextGuidanceStyleEmpatheticDesc =>
      'Warmes, unterstützendes Coaching';

  @override
  String get contextGuidanceStyleBalanced => 'Ausgewogen';

  @override
  String get contextGuidanceStyleBalancedDesc =>
      'Mischung aus praktischer und emotionaler Unterstützung';

  @override
  String get homeGuidancePreparing =>
      'Die Sterne lesen und das Universum nach Ihnen fragen…';

  @override
  String get homeGuidanceFailed =>
      'Fehler beim Generieren der Beratung. Bitte versuchen Sie es erneut.';

  @override
  String get homeGuidanceTimeout =>
      'Dauert länger als erwartet. Tippen Sie auf Wiederholen oder schauen Sie in einem Moment wieder vorbei.';

  @override
  String get homeGuidanceLoadFailed => 'Fehler beim Laden der Beratung';

  @override
  String get homeTodaysGuidance => 'Heutige Beratung';

  @override
  String get homeSeeAll => 'Alle ansehen';

  @override
  String get homeHealth => 'Gesundheit';

  @override
  String get homeCareer => 'Karriere';

  @override
  String get homeMoney => 'Geld';

  @override
  String get homeLove => 'Liebe';

  @override
  String get homePartners => 'Partner';

  @override
  String get homeGrowth => 'Wachstum';

  @override
  String get homeTraveler => 'Reisender';

  @override
  String homeGreeting(Object name) {
    return 'Hallo, $name';
  }

  @override
  String get homeFocusFallback => 'Persönliches Wachstum';

  @override
  String get homeDailyMessage => 'Ihre tägliche Nachricht';

  @override
  String get homeNatalChartTitle => 'Mein Geburtshoroskop';

  @override
  String get homeNatalChartSubtitle =>
      'Erforschen Sie Ihr Geburtshoroskop & Interpretationen';

  @override
  String get navHome => 'Startseite';

  @override
  String get navHistory => 'Verlauf';

  @override
  String get navGuide => 'Leitfaden';

  @override
  String get navProfile => 'Profil';

  @override
  String get navForYou => 'Für Sie';

  @override
  String get commonToday => 'Heute';

  @override
  String get commonTryAgain => 'Erneut versuchen';

  @override
  String get natalChartTitle => 'Mein Geburtshoroskop';

  @override
  String get natalChartTabTable => 'Tabelle';

  @override
  String get natalChartTabChart => 'Diagramm';

  @override
  String get natalChartEmptyTitle => 'Keine Natal Chart-Daten';

  @override
  String get natalChartEmptySubtitle =>
      'Bitte vervollständigen Sie Ihre Geburtsdaten, um Ihr Natal Chart zu sehen.';

  @override
  String get natalChartAddBirthData => 'Geburtsdaten hinzufügen';

  @override
  String get natalChartErrorTitle => 'Diagramm konnte nicht geladen werden';

  @override
  String get guidanceTitle => 'Tägliche Anleitung';

  @override
  String get guidanceLoadFailed => 'Anleitung konnte nicht geladen werden';

  @override
  String get guidanceNoneAvailable => 'Keine Anleitung verfügbar';

  @override
  String get guidanceCosmicEnergyTitle => 'Kosmische Energie von heute';

  @override
  String get guidanceMoodLabel => 'Stimmung';

  @override
  String get guidanceFocusLabel => 'Fokus';

  @override
  String get guidanceYourGuidance => 'Ihre Anleitung';

  @override
  String get guidanceTapToCollapse => 'Tippen, um zu minimieren';

  @override
  String get historyTitle => 'Anleitungshistorie';

  @override
  String get historySubtitle => 'Ihre kosmische Reise durch die Zeit';

  @override
  String get historyLoadFailed => 'Historie konnte nicht geladen werden';

  @override
  String get historyEmptyTitle => 'Noch keine Historie';

  @override
  String get historyEmptySubtitle =>
      'Ihre täglichen Anleitungen erscheinen hier';

  @override
  String get historyNewBadge => 'NEU';

  @override
  String get commonUnlocked => 'Freigeschaltet';

  @override
  String get commonComingSoon => 'Demnächst';

  @override
  String get commonSomethingWentWrong => 'Etwas ist schiefgelaufen';

  @override
  String get commonNoContent => 'Keine Inhalte verfügbar.';

  @override
  String get commonUnknownError => 'Unbekannter Fehler';

  @override
  String get commonTakingLonger =>
      'Dauert länger als erwartet. Bitte versuchen Sie es erneut.';

  @override
  String commonErrorWithMessage(Object error) {
    return 'Fehler: $error';
  }

  @override
  String get forYouTitle => 'Für Sie';

  @override
  String get forYouSubtitle => 'Personalisierte kosmische Einblicke';

  @override
  String get forYouNatalChartTitle => 'Mein Natal Chart';

  @override
  String get forYouNatalChartSubtitle => 'Ihre Geburtschart-Analyse';

  @override
  String get forYouCompatibilitiesTitle => 'Kompatibilitäten';

  @override
  String get forYouCompatibilitiesSubtitle =>
      'Berichte über Liebe, Freundschaft & Partnerschaft';

  @override
  String get forYouKarmicTitle => 'Karmische Astrologie';

  @override
  String get forYouKarmicSubtitle =>
      'Seelenlektionen & Muster aus vergangenen Leben';

  @override
  String get forYouLearnTitle => 'Astrologie lernen';

  @override
  String get forYouLearnSubtitle => 'Kostenlose Bildungsinhalte';

  @override
  String get compatibilitiesTitle => 'Kompatibilitäten';

  @override
  String get compatibilitiesLoadFailed => 'Laden der Dienste fehlgeschlagen';

  @override
  String get compatibilitiesBetaFree => 'Beta: Alle Berichte sind KOSTENLOS!';

  @override
  String get compatibilitiesChooseReport => 'Wählen Sie einen Bericht';

  @override
  String get compatibilitiesSubtitle =>
      'Entdecken Sie Einblicke über sich selbst und Ihre Beziehungen';

  @override
  String get compatibilitiesPartnerBadge => '+Partner';

  @override
  String get compatibilitiesPersonalityTitle => 'Persönlichkeitsbericht';

  @override
  String get compatibilitiesPersonalitySubtitle =>
      'Umfassende Analyse Ihrer Persönlichkeit basierend auf Ihrem Natal Chart';

  @override
  String get compatibilitiesRomanticPersonalityTitle =>
      'Romantischer Persönlichkeitsbericht';

  @override
  String get compatibilitiesRomanticPersonalitySubtitle =>
      'Verstehen, wie Sie Liebe und Romantik angehen';

  @override
  String get compatibilitiesLoveCompatibilityTitle => 'Liebeskompatibilität';

  @override
  String get compatibilitiesLoveCompatibilitySubtitle =>
      'Detaillierte romantische Kompatibilitätsanalyse mit Ihrem Partner';

  @override
  String get compatibilitiesRomanticForecastTitle => 'Romantische Paarprognose';

  @override
  String get compatibilitiesRomanticForecastSubtitle =>
      'Einblicke in die Zukunft Ihrer Beziehung';

  @override
  String get compatibilitiesFriendshipTitle => 'Freundschaftsbericht';

  @override
  String get compatibilitiesFriendshipSubtitle =>
      'Analysieren Sie die Dynamik und Kompatibilität von Freundschaften';

  @override
  String get moonPhaseTitle => 'Mondphasenbericht';

  @override
  String get moonPhaseSubtitle =>
      'Verstehen Sie die aktuelle Mondenergie und wie sie Sie beeinflusst. Erhalten Sie Anleitung, die mit der Mondphase übereinstimmt.';

  @override
  String get moonPhaseSelectDate => 'Datum auswählen';

  @override
  String get moonPhaseOriginalPrice => '\$2.99';

  @override
  String get moonPhaseGenerate => 'Bericht generieren';

  @override
  String get moonPhaseGenerateDifferentDate =>
      'Für ein anderes Datum generieren';

  @override
  String get moonPhaseGenerationFailed => 'Generierung fehlgeschlagen';

  @override
  String get moonPhaseGenerating =>
      'Bericht wird generiert. Bitte versuchen Sie es erneut.';

  @override
  String get moonPhaseUnknownError =>
      'Etwas ist schiefgelaufen. Bitte versuchen Sie es erneut.';

  @override
  String get requiredFieldsNote =>
      'Mit * gekennzeichnete Felder sind erforderlich.';

  @override
  String get karmicTitle => 'Karmische Astrologie';

  @override
  String karmicLoadFailed(Object error) {
    return 'Laden fehlgeschlagen: $error';
  }

  @override
  String get karmicOfferTitle =>
      '🔮 Karmische Astrologie – Botschaften der Seele';

  @override
  String get karmicOfferBody =>
      'Karmische Astrologie offenbart die tiefen Muster, die Ihr Leben prägen, jenseits alltäglicher Ereignisse.\n\nSie bietet eine Interpretation, die über ungelöste Lektionen, karmische Verbindungen und den Seelenweg des Wachstums spricht.\n\nEs geht nicht darum, was als nächstes kommt,\nsondern darum, warum Sie erleben, was Sie erleben.\n\n✨ Aktivieren Sie die karmische Astrologie und entdecken Sie die tiefere Bedeutung Ihrer Reise.';

  @override
  String get karmicBetaFreeBadge => 'Beta-Tester – KOSTENLOSER Zugang!';

  @override
  String karmicPriceBeta(Object price) {
    return '\$$price – Beta-Tester kostenlos';
  }

  @override
  String karmicPriceUnlock(Object price) {
    return 'Freischalten für \$$price';
  }

  @override
  String get karmicHintInstant => 'Ihre Lesung wird sofort generiert';

  @override
  String get karmicHintOneTime => 'Einmaliger Kauf, kein Abonnement';

  @override
  String get karmicProgressHint =>
      'Verbindung zu Ihrem karmischen Weg wird hergestellt…';

  @override
  String karmicGenerateFailed(Object error) {
    return 'Generierung fehlgeschlagen: $error';
  }

  @override
  String get karmicCheckoutTitle => 'Karmische Astrologie Checkout';

  @override
  String get karmicCheckoutSubtitle => 'Kaufprozess demnächst verfügbar';

  @override
  String karmicGenerationFailed(Object error) {
    return 'Generierung fehlgeschlagen: $error';
  }

  @override
  String get karmicLoading => 'Lade Ihre karmische Lesung...';

  @override
  String get karmicGenerationFailedShort => 'Generierung fehlgeschlagen';

  @override
  String get karmicGeneratingTitle => 'Generiere Ihre karmische Lesung...';

  @override
  String get karmicGeneratingSubtitle =>
      'Analysiere Ihr Natal Chart nach karmischen Mustern und Seelenlektionen.';

  @override
  String get karmicReadingTitle => '🔮 Ihre karmische Lesung';

  @override
  String get karmicReadingSubtitle => 'Botschaften der Seele';

  @override
  String get karmicDisclaimer =>
      'Diese Lesung dient der Selbstreflexion und Unterhaltung. Sie stellt keinen professionellen Rat dar.';

  @override
  String get commonActive => 'Aktiv';

  @override
  String get commonBackToHome => 'Zurück zur Startseite';

  @override
  String get commonYesterday => 'gestern';

  @override
  String commonWeeksAgo(Object count) {
    return '$count Wochen her';
  }

  @override
  String commonMonthsAgo(Object count) {
    return '$count Monate her';
  }

  @override
  String get commonEdit => 'Bearbeiten';

  @override
  String get commonDelete => 'Löschen';

  @override
  String get natalChartProGenerated =>
      'Pro-Interpretationen generiert! Nach oben scrollen, um sie zu sehen.';

  @override
  String get natalChartHouse1 => 'Selbst & Identität';

  @override
  String get natalChartHouse2 => 'Geld & Werte';

  @override
  String get natalChartHouse3 => 'Kommunikation';

  @override
  String get natalChartHouse4 => 'Zuhause & Familie';

  @override
  String get natalChartHouse5 => 'Kreativität & Romantik';

  @override
  String get natalChartHouse6 => 'Gesundheit & Routine';

  @override
  String get natalChartHouse7 => 'Beziehungen';

  @override
  String get natalChartHouse8 => 'Transformation';

  @override
  String get natalChartHouse9 => 'Philosophie & Reisen';

  @override
  String get natalChartHouse10 => 'Karriere & Status';

  @override
  String get natalChartHouse11 => 'Freunde & Ziele';

  @override
  String get natalChartHouse12 => 'Spiritualität';

  @override
  String get helpSupportTitle => 'Hilfe & Unterstützung';

  @override
  String get helpSupportContactTitle => 'Support kontaktieren';

  @override
  String get helpSupportContactSubtitle =>
      'Wir antworten normalerweise innerhalb von 24 Stunden';

  @override
  String get helpSupportFaqTitle => 'Häufig gestellte Fragen';

  @override
  String get helpSupportEmailSubject =>
      'Anfrage zur Unterstützung von Inner Wisdom';

  @override
  String get helpSupportEmailAppFailed =>
      'E-Mail-App konnte nicht geöffnet werden. Bitte senden Sie eine E-Mail an support@innerwisdomapp.com';

  @override
  String get helpSupportEmailFallback =>
      'Bitte senden Sie uns eine E-Mail an support@innerwisdomapp.com';

  @override
  String get helpSupportFaq1Q => 'Wie genau ist die tägliche Anleitung?';

  @override
  String get helpSupportFaq1A =>
      'Unsere tägliche Anleitung kombiniert traditionelle astrologische Prinzipien mit Ihrem persönlichen Geburtshoroskop. Während Astrologie interpretativ ist, bietet unsere KI personalisierte Einblicke basierend auf realen planetarischen Positionen und Aspekten.';

  @override
  String get helpSupportFaq2Q => 'Warum benötige ich meine Geburtszeit?';

  @override
  String get helpSupportFaq2A =>
      'Ihre Geburtszeit bestimmt Ihren Aszendenten (Rising Sign) und die Positionen der Häuser in Ihrem Horoskop. Ohne sie verwenden wir Mittag als Standard, was die Genauigkeit der hausbezogenen Interpretationen beeinträchtigen kann.';

  @override
  String get helpSupportFaq3Q => 'Wie ändere ich meine Geburtsdaten?';

  @override
  String get helpSupportFaq3A =>
      'Derzeit können Geburtsdaten nach der ersten Einrichtung nicht mehr geändert werden, um die Konsistenz Ihrer Lesungen zu gewährleisten. Kontaktieren Sie den Support, wenn Sie Korrekturen vornehmen müssen.';

  @override
  String get helpSupportFaq4Q => 'Was ist ein Fokus-Thema?';

  @override
  String get helpSupportFaq4A =>
      'Ein Fokus-Thema ist ein aktuelles Anliegen oder Lebensbereich, den Sie betonen möchten. Wenn festgelegt, wird Ihre tägliche Anleitung diesem Bereich besondere Aufmerksamkeit schenken und relevantere Einblicke bieten.';

  @override
  String get helpSupportFaq5Q => 'Wie funktioniert das Abonnement?';

  @override
  String get helpSupportFaq5A =>
      'Die kostenlose Stufe umfasst grundlegende tägliche Anleitungen. Premium-Abonnenten erhalten verbesserte Personalisierung, Audio-Lesungen und Zugang zu speziellen Funktionen wie karmischen Astrologie-Lesungen.';

  @override
  String get helpSupportFaq6Q => 'Sind meine Daten privat?';

  @override
  String get helpSupportFaq6A =>
      'Ja! Wir nehmen Datenschutz ernst. Ihre Geburtsdaten und persönlichen Informationen sind verschlüsselt und werden niemals an Dritte weitergegeben. Sie können Ihr Konto jederzeit löschen.';

  @override
  String get helpSupportFaq7Q =>
      'Was ist, wenn ich mit einer Lesung nicht einverstanden bin?';

  @override
  String get helpSupportFaq7A =>
      'Astrologie ist interpretativ, und nicht jede Lesung wird resonieren. Nutzen Sie die Feedback-Funktion, um uns zu helfen, uns zu verbessern. Unsere KI lernt im Laufe der Zeit aus Ihren Vorlieben.';

  @override
  String get notificationsSaved => 'Benachrichtigungseinstellungen gespeichert';

  @override
  String get notificationsTitle => 'Benachrichtigungen';

  @override
  String get notificationsSectionTitle => 'Push-Benachrichtigungen';

  @override
  String get notificationsDailyTitle => 'Tägliche Anleitung';

  @override
  String get notificationsDailySubtitle =>
      'Erhalten Sie eine Benachrichtigung, wenn Ihre tägliche Anleitung bereit ist';

  @override
  String get notificationsWeeklyTitle => 'Wöchentliche Highlights';

  @override
  String get notificationsWeeklySubtitle =>
      'Wöchentlicher kosmischer Überblick und wichtige Transite';

  @override
  String get notificationsSpecialTitle => 'Besondere Ereignisse';

  @override
  String get notificationsSpecialSubtitle =>
      'Vollmonde, Finsternisse und Rückläufigkeiten';

  @override
  String get notificationsDeviceHint =>
      'Sie können Benachrichtigungen auch in den Einstellungen Ihres Geräts steuern.';

  @override
  String get concernsTitle => 'Ihr Fokus';

  @override
  String get concernsSubtitle => 'Themen, die Ihre Anleitung prägen';

  @override
  String concernsTabActive(Object count) {
    return 'Aktiv ($count)';
  }

  @override
  String concernsTabResolved(Object count) {
    return 'Gelöst ($count)';
  }

  @override
  String concernsTabArchived(Object count) {
    return 'Archiviert ($count)';
  }

  @override
  String get concernsEmptyTitle => 'Keine Anliegen hier';

  @override
  String get concernsEmptySubtitle =>
      'Fügen Sie ein Fokus-Thema hinzu, um personalisierte Anleitung zu erhalten';

  @override
  String get concernsCategoryCareer => 'Karriere & Job';

  @override
  String get concernsCategoryHealth => 'Gesundheit';

  @override
  String get concernsCategoryRelationship => 'Beziehung';

  @override
  String get concernsCategoryFamily => 'Familie';

  @override
  String get concernsCategoryMoney => 'Geld';

  @override
  String get concernsCategoryBusiness => 'Geschäft';

  @override
  String get concernsCategoryPartnership => 'Partnerschaft';

  @override
  String get concernsCategoryGrowth => 'Persönliches Wachstum';

  @override
  String get concernsMinLength =>
      'Bitte beschreiben Sie Ihr Anliegen ausführlicher (mindestens 10 Zeichen)';

  @override
  String get concernsSubmitFailed =>
      'Einreichung des Anliegens fehlgeschlagen. Bitte versuchen Sie es erneut.';

  @override
  String get concernsAddTitle => 'Was beschäftigt Sie?';

  @override
  String get concernsAddDescription =>
      'Teilen Sie Ihr aktuelles Anliegen, Ihre Frage oder Ihre Lebenssituation. Unsere KI wird es analysieren und ab morgen fokussierte Anleitung bieten.';

  @override
  String get concernsExamplesTitle => 'Beispiele für Anliegen:';

  @override
  String get concernsExampleCareer => 'Entscheidung über Berufswechsel';

  @override
  String get concernsExampleRelationship => 'Herausforderungen in Beziehungen';

  @override
  String get concernsExampleFinance => 'Zeitpunkt finanzieller Investitionen';

  @override
  String get concernsExampleHealth => 'Fokus auf Gesundheit und Wellness';

  @override
  String get concernsExampleGrowth => 'Richtung persönliches Wachstum';

  @override
  String get concernsSubmitButton => 'Anliegen einreichen';

  @override
  String get concernsSuccessTitle => 'Anliegen aufgezeichnet!';

  @override
  String get concernsCategoryLabel => 'Kategorie: ';

  @override
  String get concernsSuccessMessage =>
      'Ab morgen wird Ihre tägliche Anleitung mehr auf dieses Thema fokussiert sein.';

  @override
  String get concernsViewFocusTopics => 'Meine Fokus-Themen anzeigen';

  @override
  String get deleteAccountTitle => 'Konto löschen';

  @override
  String get deleteAccountHeading => 'Ihr Konto löschen?';

  @override
  String get deleteAccountConfirmError =>
      'Bitte geben Sie DELETE zur Bestätigung ein';

  @override
  String get deleteAccountFinalWarningTitle => 'Letzte Warnung';

  @override
  String get deleteAccountFinalWarningBody =>
      'Diese Aktion kann nicht rückgängig gemacht werden. Alle Ihre Daten, einschließlich:\n\n• Ihr Profil und Geburtsdaten\n• Geburtshoroskop und Interpretationen\n• Verlauf der täglichen Anleitung\n• Persönlicher Kontext und Vorlieben\n• Alle gekauften Inhalte\n\nwerden dauerhaft gelöscht.';

  @override
  String get deleteAccountConfirmButton => 'Für immer löschen';

  @override
  String get deleteAccountSuccess => 'Ihr Konto wurde gelöscht';

  @override
  String get deleteAccountFailed =>
      'Löschen des Kontos fehlgeschlagen. Bitte versuchen Sie es erneut.';

  @override
  String get deleteAccountPermanentWarning =>
      'Diese Aktion ist dauerhaft und kann nicht rückgängig gemacht werden';

  @override
  String get deleteAccountWarningDetail =>
      'Alle Ihre persönlichen Daten, einschließlich Ihres Geburtshoroskops, des Verlaufs der Anleitung und aller Käufe, werden dauerhaft gelöscht.';

  @override
  String get deleteAccountWhatTitle => 'Was wird gelöscht:';

  @override
  String get deleteAccountItemProfile => 'Ihr Profil und Konto';

  @override
  String get deleteAccountItemBirthData => 'Geburtsdaten und Geburtshoroskop';

  @override
  String get deleteAccountItemGuidance =>
      'Alle Verlauf der täglichen Anleitung';

  @override
  String get deleteAccountItemContext => 'Persönlicher Kontext & Vorlieben';

  @override
  String get deleteAccountItemKarmic => 'Karmische Astrologie-Lesungen';

  @override
  String get deleteAccountItemPurchases => 'Alle gekauften Inhalte';

  @override
  String get deleteAccountTypeDelete => 'Geben Sie DELETE zur Bestätigung ein';

  @override
  String get deleteAccountDeleteHint => 'DELETE';

  @override
  String get deleteAccountButton => 'Mein Konto löschen';

  @override
  String get deleteAccountCancel => 'Abbrechen, Konto behalten';

  @override
  String get learnArticleLoadFailed => 'Artikel konnte nicht geladen werden';

  @override
  String get learnContentInEnglish => 'Inhalt auf Englisch';

  @override
  String get learnArticlesLoadFailed => 'Artikel konnten nicht geladen werden';

  @override
  String get learnArticlesEmpty => 'Noch keine Artikel verfügbar';

  @override
  String get learnContentFallback =>
      'Inhalt auf Englisch anzeigen (nicht in Ihrer Sprache verfügbar)';

  @override
  String get checkoutTitle => 'Kasse';

  @override
  String get checkoutOrderSummary => 'Bestellübersicht';

  @override
  String get checkoutProTitle => 'Pro Geburtshoroskop';

  @override
  String get checkoutProSubtitle =>
      'Vollständige planetarische Interpretationen';

  @override
  String get checkoutTotalLabel => 'Gesamt';

  @override
  String get checkoutTotalAmount => '\$9.99 USD';

  @override
  String get checkoutPaymentTitle => 'Zahlungsintegration';

  @override
  String get checkoutPaymentSubtitle =>
      'Integration von In-App-Käufen wird finalisiert. Bitte bald wieder vorbeischauen!';

  @override
  String get checkoutProcessing => 'Wird verarbeitet...';

  @override
  String get checkoutDemoPurchase => 'Demo-Kauf (Test)';

  @override
  String get checkoutSecurityNote =>
      'Die Zahlung wird sicher über Apple/Google verarbeitet. Ihre Kartendaten werden niemals gespeichert.';

  @override
  String get checkoutSuccess =>
      '🎉 Pro Natal Chart erfolgreich freigeschaltet!';

  @override
  String get checkoutGenerateFailed =>
      'Interpretationen konnten nicht generiert werden. Bitte versuchen Sie es erneut.';

  @override
  String checkoutErrorWithMessage(Object error) {
    return 'Ein Fehler ist aufgetreten: $error';
  }

  @override
  String get billingUpgrade => 'Upgrade auf Premium';

  @override
  String billingFeatureLocked(Object feature) {
    return '$feature ist eine Premium-Funktion';
  }

  @override
  String get billingUpgradeBody =>
      'Upgrade auf Premium, um diese Funktion freizuschalten und die persönlichste Anleitung zu erhalten.';

  @override
  String get contextReviewFailed =>
      'Aktualisierung fehlgeschlagen. Bitte versuchen Sie es erneut.';

  @override
  String get contextReviewTitle => 'Zeit für ein kurzes Check-in';

  @override
  String get contextReviewBody =>
      'Es sind 3 Monate vergangen, seit wir Ihren persönlichen Kontext zuletzt aktualisiert haben. Hat sich etwas Wichtiges in Ihrem Leben geändert, das wir wissen sollten?';

  @override
  String get contextReviewHint =>
      'Das hilft uns, Ihnen persönlichere Anleitungen zu geben.';

  @override
  String get contextReviewNoChanges => 'Keine Änderungen';

  @override
  String get contextReviewYesUpdate => 'Ja, aktualisieren';

  @override
  String get contextProfileLoadFailed => 'Profil konnte nicht geladen werden';

  @override
  String get contextCardTitle => 'Persönlicher Kontext';

  @override
  String get contextCardSubtitle =>
      'Richten Sie Ihren persönlichen Kontext ein, um maßgeschneiderte Anleitungen zu erhalten.';

  @override
  String get contextCardSetupNow => 'Jetzt einrichten';

  @override
  String contextCardVersionUpdated(Object version, Object date) {
    return 'Version $version • Zuletzt aktualisiert am $date';
  }

  @override
  String get contextCardAiSummary => 'KI-Zusammenfassung';

  @override
  String contextCardToneTag(Object tone) {
    return '$tone Ton';
  }

  @override
  String get contextCardSensitivityTag => 'Sensibilität aktiviert';

  @override
  String get contextCardReviewDue =>
      'Überprüfung fällig - aktualisieren Sie Ihren Kontext';

  @override
  String contextCardNextReview(Object days) {
    return 'Nächste Überprüfung in $days Tagen';
  }

  @override
  String get contextDeleteTitle => 'Persönlichen Kontext löschen?';

  @override
  String get contextDeleteBody =>
      'Dies wird Ihr persönliches Kontextprofil löschen. Ihre Anleitung wird weniger personalisiert.';

  @override
  String get contextDeleteFailed => 'Profil konnte nicht gelöscht werden';

  @override
  String get appTitle => 'Innere Weisheit';

  @override
  String get concernsHintExample =>
      'Beispiel: Ich habe ein Jobangebot in einer anderen Stadt und bin mir nicht sicher, ob ich es annehmen soll...';

  @override
  String get learnTitle => 'Astrologie lernen';

  @override
  String get learnFreeTitle => 'Kostenlose Lernressourcen';

  @override
  String get learnFreeSubtitle =>
      'Erforschen Sie die Grundlagen der Astrologie';

  @override
  String get learnSignsTitle => 'Zeichen';

  @override
  String get learnSignsSubtitle => '12 Tierkreiszeichen und ihre Bedeutungen';

  @override
  String get learnPlanetsTitle => 'Planeten';

  @override
  String get learnPlanetsSubtitle => 'Himmelskörper in der Astrologie';

  @override
  String get learnHousesTitle => 'Häuser';

  @override
  String get learnHousesSubtitle => '12 Lebensbereiche in Ihrem Chart';

  @override
  String get learnTransitsTitle => 'Transite';

  @override
  String get learnTransitsSubtitle => 'Planetarische Bewegungen & Auswirkungen';

  @override
  String get learnPaceTitle => 'Lernen in Ihrem Tempo';

  @override
  String get learnPaceSubtitle =>
      'Umfassende Lektionen zur Vertiefung Ihres astrologischen Wissens';

  @override
  String get proNatalTitle => 'Pro Natal Chart';

  @override
  String get proNatalHeroTitle => 'Tiefere Einblicke freischalten';

  @override
  String get proNatalHeroSubtitle =>
      'Erhalten Sie umfassende 150-200 Wörter lange Interpretationen für jede planetarische Platzierung in Ihrem Geburtshoroskop.';

  @override
  String get proNatalFeature1Title => 'Tiefgehende Persönlichkeitsanalysen';

  @override
  String get proNatalFeature1Body =>
      'Verstehen Sie, wie jeder Planet Ihre einzigartige Persönlichkeit und Lebensweg prägt.';

  @override
  String get proNatalFeature2Title => 'KI-gestützte Analyse';

  @override
  String get proNatalFeature2Body =>
      'Fortgeschrittene Interpretationen, die auf Ihren genauen planetarischen Positionen basieren.';

  @override
  String get proNatalFeature3Title => 'Umsetzbare Anleitungen';

  @override
  String get proNatalFeature3Body =>
      'Praktische Ratschläge für Karriere, Beziehungen und persönliches Wachstum.';

  @override
  String get proNatalFeature4Title => 'Lebenslanger Zugang';

  @override
  String get proNatalFeature4Body =>
      'Ihre Interpretationen werden für immer gespeichert. Jederzeit zugänglich.';

  @override
  String get proNatalOneTime => 'Einmaliger Kauf';

  @override
  String get proNatalNoSubscription => 'Kein Abonnement erforderlich';
}

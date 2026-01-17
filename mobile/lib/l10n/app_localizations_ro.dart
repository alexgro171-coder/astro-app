// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get onboardingSkip => 'Sari';

  @override
  String get onboardingTitle1 => 'Bun venit la Inner Wisdom Astro';

  @override
  String get onboardingDesc1 =>
      'Innerwisdom Astro reunește peste 30 de ani de expertiză astrologică de la Madi G. cu puterea AI avansat, creând una dintre cele mai rafinate și performante aplicații de astrologie disponibile astăzi.\n\nPrin combinarea unei perspective umane profunde cu tehnologia inteligentă, Innerwisdom Astro oferă interpretări precise, personalizate și semnificative, sprijinind utilizatorii în călătoria lor de auto-descoperire, claritate și creștere conștientă.';

  @override
  String get onboardingTitle2 => 'Călătoria ta astrologică completă';

  @override
  String get onboardingDesc2 =>
      'De la ghidare zilnică personalizată la Harta Ta Natală, Astrologie Karmică, rapoarte de personalitate detaliate, Compatibilitate în Dragoste și Prietenie, Previziuni Romantice pentru Cupluri și multe altele — toate sunt acum la îndemâna ta.\n\nProiectată pentru a sprijini claritatea, conexiunea și înțelegerea de sine, Innerwisdom Astro oferă o experiență astrologică completă, adaptată ție.';

  @override
  String get onboardingNext => 'Următorul';

  @override
  String get onboardingGetStarted => 'Începe';

  @override
  String get onboardingAlreadyHaveAccount => 'Ai deja un cont? Conectează-te';

  @override
  String get birthDataTitle => 'Harta Ta Natală';

  @override
  String get birthDataSubtitle =>
      'Avem nevoie de detaliile tale de naștere pentru a crea\nprofilul tău astrologic personalizat';

  @override
  String get birthDateLabel => 'Data Nașterii';

  @override
  String get birthDateSelectHint => 'Selectează data nașterii';

  @override
  String get birthTimeLabel => 'Ora Nașterii';

  @override
  String get birthTimeUnknown => 'Necunoscut';

  @override
  String get birthTimeSelectHint => 'Selectează ora nașterii';

  @override
  String get birthTimeUnknownCheckbox => 'Nu știu ora exactă a nașterii';

  @override
  String get birthPlaceLabel => 'Locul Nașterii';

  @override
  String get birthPlaceHint => 'Începe să scrii numele unui oraș...';

  @override
  String get birthPlaceValidation =>
      'Te rugăm să selectezi o locație din sugestii';

  @override
  String birthPlaceSelected(Object location) {
    return 'Selectat: $location';
  }

  @override
  String get genderLabel => 'Gen';

  @override
  String get genderMale => 'Masculin';

  @override
  String get genderFemale => 'Feminin';

  @override
  String get genderPreferNotToSay => 'Prefer să nu spun';

  @override
  String get birthDataSubmit => 'Generează Harta Mea Natală';

  @override
  String get birthDataPrivacyNote =>
      'Datele tale de naștere sunt folosite doar pentru a calcula\nharta ta astrologică și sunt stocate în siguranță.';

  @override
  String get birthDateMissing => 'Te rugăm să selectezi data nașterii';

  @override
  String get birthPlaceMissing =>
      'Te rugăm să selectezi un loc de naștere din sugestii';

  @override
  String get birthDataSaveError =>
      'Nu s-au putut salva datele de naștere. Te rugăm să încerci din nou.';

  @override
  String get appearanceTitle => 'Aspect';

  @override
  String get appearanceTheme => 'Temă';

  @override
  String get appearanceDarkTitle => 'Întunecat';

  @override
  String get appearanceDarkSubtitle => 'Ușor pentru ochi în lumină slabă';

  @override
  String get appearanceLightTitle => 'Lumină';

  @override
  String get appearanceLightSubtitle => 'Aspect clasic luminos';

  @override
  String get appearanceSystemTitle => 'Sistem';

  @override
  String get appearanceSystemSubtitle =>
      'Se potrivește cu setările dispozitivului tău';

  @override
  String get appearancePreviewTitle => 'Previzualizare';

  @override
  String get appearancePreviewBody =>
      'Tema cosmică este concepută pentru a crea o experiență imersivă de astrologie. Tema întunecată este recomandată pentru cea mai bună experiență vizuală.';

  @override
  String appearanceThemeChanged(Object theme) {
    return 'Tema a fost schimbată în $theme';
  }

  @override
  String get profileUserFallback => 'Utilizator';

  @override
  String get profilePersonalContext => 'Context Personal';

  @override
  String get profileSettings => 'Setări';

  @override
  String get profileAppLanguage => 'Limba Aplicației';

  @override
  String get profileContentLanguage => 'Limba Conținutului';

  @override
  String get profileContentLanguageHint =>
      'Conținutul AI folosește limba selectată.';

  @override
  String get profileNotifications => 'Notificări';

  @override
  String get profileNotificationsEnabled => 'Activat';

  @override
  String get profileNotificationsDisabled => 'Dezactivat';

  @override
  String get profileAppearance => 'Aspect';

  @override
  String get profileHelpSupport => 'Ajutor & Suport';

  @override
  String get profilePrivacyPolicy => 'Politica de Confidențialitate';

  @override
  String get profileTermsOfService => 'Termeni și Condiții';

  @override
  String get profileLogout => 'Deconectare';

  @override
  String get profileLogoutConfirm => 'Ești sigur că vrei să te deconectezi?';

  @override
  String get profileDeleteAccount => 'Șterge Contul';

  @override
  String get commonCancel => 'Anulează';

  @override
  String get profileSelectLanguageTitle => 'Selectează Limba';

  @override
  String get profileSelectLanguageSubtitle =>
      'Tot conținutul generat de AI va fi în limba ta selectată.';

  @override
  String profileLanguageUpdated(Object language) {
    return 'Limba a fost actualizată în $language';
  }

  @override
  String profileLanguageUpdateFailed(Object error) {
    return 'Nu s-a reușit actualizarea limbii: $error';
  }

  @override
  String profileVersion(Object version) {
    return 'Inner Wisdom v$version';
  }

  @override
  String get profileCosmicBlueprint => 'Planul Tău Cosmic';

  @override
  String get profileSunLabel => '☀️ Soare';

  @override
  String get profileMoonLabel => '🌙 Lună';

  @override
  String get profileRisingLabel => '⬆️ Ascendent';

  @override
  String get profileUnknown => 'Necunoscut';

  @override
  String get forgotPasswordTitle => 'Ai uitat parola?';

  @override
  String get forgotPasswordSubtitle =>
      'Introdu adresa ta de email și îți vom trimite un cod pentru a-ți reseta parola';

  @override
  String get forgotPasswordSent =>
      'Dacă există un cont, un cod de resetare a fost trimis pe emailul tău.';

  @override
  String get forgotPasswordFailed =>
      'Nu s-a reușit trimiterea codului de resetare. Te rugăm să încerci din nou.';

  @override
  String get forgotPasswordSendCode => 'Trimite Codul de Resetare';

  @override
  String get forgotPasswordHaveCode => 'Ai deja un cod?';

  @override
  String get forgotPasswordRemember => 'Îți amintești parola? ';

  @override
  String get loginWelcomeBack => 'Bun venit înapoi';

  @override
  String get loginSubtitle =>
      'Conectează-te pentru a continua călătoria ta cosmică';

  @override
  String get loginInvalidCredentials => 'Email sau parolă invalide';

  @override
  String get loginGoogleFailed =>
      'Conectarea cu Google a eșuat. Te rugăm să încerci din nou.';

  @override
  String get loginAppleFailed =>
      'Conectarea cu Apple a eșuat. Te rugăm să încerci din nou.';

  @override
  String get loginNetworkError =>
      'Eroare de rețea. Te rugăm să verifici conexiunea ta.';

  @override
  String get loginSignInCancelled => 'Conectarea a fost anulată.';

  @override
  String get loginPasswordHint => 'Introdu parola ta';

  @override
  String get loginForgotPassword => 'Ai uitat parola?';

  @override
  String get loginSignIn => 'Conectează-te';

  @override
  String get loginNoAccount => 'Nu ai un cont? ';

  @override
  String get loginSignUp => 'Înscrie-te';

  @override
  String get commonEmailLabel => 'Email';

  @override
  String get commonEmailHint => 'Introdu adresa ta de email';

  @override
  String get commonEmailRequired => 'Te rugăm să introduci adresa ta de email';

  @override
  String get commonEmailInvalid =>
      'Te rugăm să introduci o adresă de email validă';

  @override
  String get commonPasswordLabel => 'Parolă';

  @override
  String get commonPasswordRequired => 'Te rugăm să introduci parola ta';

  @override
  String get commonOrContinueWith => 'sau continuă cu';

  @override
  String get commonGoogle => 'Google';

  @override
  String get commonApple => 'Apple';

  @override
  String get commonNameLabel => 'Nume';

  @override
  String get commonNameHint => 'Introdu numele tău';

  @override
  String get commonNameRequired => 'Te rugăm să introduci numele tău';

  @override
  String get signupTitle => 'Creează Cont';

  @override
  String get signupSubtitle => 'Începe-ți călătoria cosmică cu Inner Wisdom';

  @override
  String get signupEmailExists =>
      'Emailul există deja sau datele sunt invalide';

  @override
  String get signupGoogleFailed =>
      'Autentificarea Google a eșuat. Te rugăm să încerci din nou.';

  @override
  String get signupAppleFailed =>
      'Autentificarea Apple a eșuat. Te rugăm să încerci din nou.';

  @override
  String get signupPasswordHint => 'Creează o parolă (min. 8 caractere)';

  @override
  String get signupPasswordMin =>
      'Parola trebuie să aibă cel puțin 8 caractere';

  @override
  String get signupConfirmPasswordLabel => 'Confirmă Parola';

  @override
  String get signupConfirmPasswordHint => 'Confirmă-ți parola';

  @override
  String get signupConfirmPasswordRequired => 'Te rugăm să confirmi parola';

  @override
  String get signupPasswordMismatch => 'Parolele nu se potrivesc';

  @override
  String get signupPreferredLanguage => 'Limba Preferată';

  @override
  String get signupCreateAccount => 'Creează Cont';

  @override
  String get signupHaveAccount => 'Ai deja un cont? ';

  @override
  String get resetPasswordTitle => 'Resetează Parola';

  @override
  String get resetPasswordSubtitle =>
      'Introdu codul trimis pe email și setează o nouă parolă';

  @override
  String get resetPasswordSuccess =>
      'Resetarea parolei a fost reușită! Redirecționare către autentificare...';

  @override
  String get resetPasswordFailed =>
      'Eșec la resetarea parolei. Te rugăm să încerci din nou.';

  @override
  String get resetPasswordInvalidCode =>
      'Cod de resetare invalid sau expirat. Te rugăm să soliciți unul nou.';

  @override
  String get resetPasswordMaxAttempts =>
      'Numărul maxim de încercări a fost depășit. Te rugăm să soliciți un cod nou.';

  @override
  String get resetCodeLabel => 'Cod de Resetare';

  @override
  String get resetCodeHint => 'Introdu codul de 6 cifre';

  @override
  String get resetCodeRequired => 'Te rugăm să introduci codul de resetare';

  @override
  String get resetCodeLength => 'Codul trebuie să fie de 6 cifre';

  @override
  String get resetNewPasswordLabel => 'Noua Parolă';

  @override
  String get resetNewPasswordHint => 'Creează o nouă parolă (min. 8 caractere)';

  @override
  String get resetNewPasswordRequired => 'Te rugăm să introduci o nouă parolă';

  @override
  String get resetConfirmPasswordHint => 'Confirmă-ți noua parolă';

  @override
  String get resetPasswordButton => 'Resetează Parola';

  @override
  String get resetRequestNewCode => 'Solicită un cod nou';

  @override
  String get serviceResultGenerated => 'Raport Generat';

  @override
  String serviceResultReady(Object title) {
    return 'Raportul tău personalizat $title este gata';
  }

  @override
  String get serviceResultBackToForYou => 'Înapoi la Pentru Tine';

  @override
  String get serviceResultNotSavedNotice =>
      'Acest raport nu va fi salvat. Dacă dorești, poți să-l copiezi și să-l salvezi în altă parte folosind funcția Copiere.';

  @override
  String get commonCopy => 'Copiază';

  @override
  String get commonCopied => 'Copiat în clipboard';

  @override
  String get commonContinue => 'Continuă';

  @override
  String get partnerDetailsTitle => 'Detalii Partener';

  @override
  String get partnerBirthDataTitle =>
      'Introdu datele de naștere ale partenerului';

  @override
  String partnerBirthDataFor(Object title) {
    return 'Pentru \"$title\"';
  }

  @override
  String get partnerNameOptionalLabel => 'Nume (opțional)';

  @override
  String get partnerNameHint => 'Numele partenerului';

  @override
  String get partnerGenderOptionalLabel => 'Gen (opțional)';

  @override
  String get partnerBirthDateLabel => 'Data Nașterii *';

  @override
  String get partnerBirthDateSelect => 'Selectează data nașterii';

  @override
  String get partnerBirthDateMissing => 'Te rugăm să selectezi data nașterii';

  @override
  String get partnerBirthTimeOptionalLabel => 'Ora Nașterii (opțional)';

  @override
  String get partnerBirthTimeSelect => 'Selectează ora nașterii';

  @override
  String get partnerBirthPlaceLabel => 'Locul Nașterii *';

  @override
  String get serviceOfferRequiresPartner =>
      'Necesită datele de naștere ale partenerului';

  @override
  String get serviceOfferBetaFree => 'Testeri beta primesc acces gratuit!';

  @override
  String get serviceOfferUnlocked => 'Deblocat';

  @override
  String get serviceOfferGenerate => 'Generează Raport';

  @override
  String serviceOfferUnlockFor(Object price) {
    return 'Deblochează pentru $price';
  }

  @override
  String get serviceOfferPreparing =>
      'Se pregătește raportul tău personalizat…';

  @override
  String get serviceOfferTimeout =>
      'Durata a fost mai lungă decât era de așteptat. Te rugăm să încerci din nou.';

  @override
  String get serviceOfferNotReady =>
      'Raportul nu este încă gata. Te rugăm să încerci din nou.';

  @override
  String serviceOfferFetchFailed(Object error) {
    return 'Eșec la obținerea raportului: $error';
  }

  @override
  String get commonFree => 'GRATUIT';

  @override
  String get commonLater => 'Mai târziu';

  @override
  String get commonRetry => 'Reîncearcă';

  @override
  String get commonYes => 'Da';

  @override
  String get commonNo => 'Nu';

  @override
  String get commonBack => 'Înapoi';

  @override
  String get commonOptional => 'Opțional';

  @override
  String get commonNotSpecified => 'Nespecificat';

  @override
  String get commonJustNow => 'Chiar acum';

  @override
  String get commonViewMore => 'Vezi mai mult';

  @override
  String get commonViewLess => 'Vezi mai puțin';

  @override
  String commonMinutesAgo(Object count) {
    return '$count min în urmă';
  }

  @override
  String commonHoursAgo(Object count) {
    return '${count}h în urmă';
  }

  @override
  String commonDaysAgo(Object count) {
    return '${count}d în urmă';
  }

  @override
  String commonDateShort(Object day, Object month, Object year) {
    return '$day/$month/$year';
  }

  @override
  String get askGuideTitle => 'Întreabă-ți Ghidul';

  @override
  String get askGuideSubtitle => 'Ghidare cosmică personală';

  @override
  String askGuideRemaining(Object count) {
    return '$count rămase';
  }

  @override
  String get askGuideQuestionHint =>
      'Întreabă orice - dragoste, carieră, decizii, emoții...';

  @override
  String get askGuideBasedOnChart =>
      'Pe baza hărții tale natale și energiilor cosmice de astăzi';

  @override
  String get askGuideThinking => 'Ghidul tău se gândește...';

  @override
  String get askGuideYourGuide => 'Ghidul tău';

  @override
  String get askGuideEmptyTitle => 'Întreabă-ți Prima Întrebare';

  @override
  String get askGuideEmptyBody =>
      'Obține ghidare instantanee, profund personală, bazată pe harta ta natală și energiile cosmice de astăzi.';

  @override
  String get askGuideEmptyHint =>
      'Întreabă orice — dragoste, carieră, decizii, emoții.';

  @override
  String get askGuideLoadFailed => 'Eșec la încărcarea datelor';

  @override
  String askGuideSendFailed(Object error) {
    return 'Eșec la trimiterea întrebării: $error';
  }

  @override
  String get askGuideLimitTitle => 'Limita Lunii A fost Atinge';

  @override
  String get askGuideLimitBody => 'Ai atins limita lunară de cereri.';

  @override
  String get askGuideLimitAddon =>
      'Poți achiziționa un addon de \$1.99 pentru a continua să folosești acest serviciu pentru restul lunii de facturare curente.';

  @override
  String askGuideLimitBillingEnd(Object date) {
    return 'Luna ta de facturare se încheie pe: $date';
  }

  @override
  String get askGuideLimitGetAddon => 'Obține Add-On';

  @override
  String get contextTitle => 'Context Personal';

  @override
  String contextStepOf(Object current, Object total) {
    return 'Pasul $current din $total';
  }

  @override
  String get contextStep1Title => 'Oamenii din jurul tău';

  @override
  String get contextStep1Subtitle =>
      'Relația și contextul tău familial ne ajută să înțelegem peisajul tău emoțional.';

  @override
  String get contextStep2Title => 'Viața Profesională';

  @override
  String get contextStep2Subtitle =>
      'Munca și ritmul tău zilnic modelează modul în care experimentezi presiunea, creșterea și scopul.';

  @override
  String get contextStep3Title => 'Cum se simte viața acum';

  @override
  String get contextStep3Subtitle =>
      'Nu există răspunsuri corecte sau greșite, doar realitatea ta actuală';

  @override
  String get contextStep4Title => 'Ce contează cel mai mult pentru tine';

  @override
  String get contextStep4Subtitle =>
      'Astfel încât ghidarea ta să se alinieze cu ceea ce îți pasă cu adevărat';

  @override
  String get contextPriorityRequired =>
      'Te rugăm să selectezi cel puțin o zonă de prioritate.';

  @override
  String contextSaveFailed(Object error) {
    return 'Eșec la salvarea profilului: $error';
  }

  @override
  String get contextSaveContinue => 'Salvează și Continuă';

  @override
  String get contextRelationshipStatusTitle => 'Starea actuală a relației';

  @override
  String get contextSeekingRelationshipTitle => 'Cauți o relație?';

  @override
  String get contextHasChildrenTitle => 'Ai copii?';

  @override
  String get contextChildrenDetailsOptional =>
      'Detalii despre copii (opțional)';

  @override
  String get contextAddChild => 'Adaugă copil';

  @override
  String get contextChildAgeLabel => 'Vârstă';

  @override
  String contextChildAgeYears(num age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other: 'ani',
      one: 'an',
    );
    return '$age $_temp0';
  }

  @override
  String get contextChildGenderLabel => 'Gen';

  @override
  String get contextRelationshipSingle => 'Singur';

  @override
  String get contextRelationshipInRelationship => 'Într-o relație';

  @override
  String get contextRelationshipMarried => 'Căsătorit / Parteneriat civil';

  @override
  String get contextRelationshipSeparated => 'Separat / Divorțat';

  @override
  String get contextRelationshipWidowed => 'Văduv';

  @override
  String get contextRelationshipPreferNotToSay => 'Prefer să nu spun';

  @override
  String get contextProfessionalStatusTitle => 'Starea profesională actuală';

  @override
  String get contextProfessionalStatusOtherHint =>
      'Te rugăm să specifici statutul tău profesional';

  @override
  String get contextIndustryTitle => 'Industria/domeniul principal';

  @override
  String get contextWorkStatusStudent => 'Student';

  @override
  String get contextWorkStatusUnemployed => 'Șomer / Între locuri de muncă';

  @override
  String get contextWorkStatusEmployedIc => 'Angajat (Contribuitor individual)';

  @override
  String get contextWorkStatusEmployedManagement => 'Angajat (Management)';

  @override
  String get contextWorkStatusExecutive => 'Executiv / Leadership (nivel C)';

  @override
  String get contextWorkStatusSelfEmployed => 'Întreprinzător / Freelancer';

  @override
  String get contextWorkStatusEntrepreneur =>
      'Antreprenor / Proprietar de afacere';

  @override
  String get contextWorkStatusInvestor => 'Investitor';

  @override
  String get contextWorkStatusRetired => 'Pensionat';

  @override
  String get contextWorkStatusHomemaker =>
      'Îngrijitor de casă / Părinte care stă acasă';

  @override
  String get contextWorkStatusCareerBreak => 'Pauză în carieră / Sabbatic';

  @override
  String get contextWorkStatusOther => 'Altceva';

  @override
  String get contextIndustryTech => 'Tehnologie / IT';

  @override
  String get contextIndustryFinance => 'Finanțe / Investiții';

  @override
  String get contextIndustryHealthcare => 'Sănătate';

  @override
  String get contextIndustryEducation => 'Educație';

  @override
  String get contextIndustrySalesMarketing => 'Vânzări / Marketing';

  @override
  String get contextIndustryRealEstate => 'Imobiliare';

  @override
  String get contextIndustryHospitality => 'Ospitalitate';

  @override
  String get contextIndustryGovernment => 'Guvern / Sector public';

  @override
  String get contextIndustryCreative => 'Industria creativă';

  @override
  String get contextIndustryOther => 'Altceva';

  @override
  String get contextSelfAssessmentIntro =>
      'Evaluează-ți situația actuală în fiecare domeniu (1 = dificultăți, 5 = prosperitate)';

  @override
  String get contextSelfHealthTitle => 'Sănătate & Energie';

  @override
  String get contextSelfHealthSubtitle =>
      '1 = probleme serioase/energie scăzută, 5 = vitalitate excelentă';

  @override
  String get contextSelfSocialTitle => 'Viața socială';

  @override
  String get contextSelfSocialSubtitle =>
      '1 = izolat, 5 = conexiuni sociale prospere';

  @override
  String get contextSelfRomanceTitle => 'Viața romantică';

  @override
  String get contextSelfRomanceSubtitle =>
      '1 = absentă/provocatoare, 5 = împlinită';

  @override
  String get contextSelfFinanceTitle => 'Stabilitate financiară';

  @override
  String get contextSelfFinanceSubtitle =>
      '1 = dificultăți majore, 5 = excelent';

  @override
  String get contextSelfCareerTitle => 'Satisfacția în carieră';

  @override
  String get contextSelfCareerSubtitle =>
      '1 = blocat/stresat, 5 = progres/claritate';

  @override
  String get contextSelfGrowthTitle => 'Interes pentru dezvoltare personală';

  @override
  String get contextSelfGrowthSubtitle =>
      '1 = interes scăzut, 5 = foarte ridicat';

  @override
  String get contextSelfStruggling => 'În dificultate';

  @override
  String get contextSelfThriving => 'Prosper';

  @override
  String get contextPrioritiesTitle =>
      'Care sunt prioritățile tale principale în acest moment?';

  @override
  String get contextPrioritiesSubtitle =>
      'Selectează până la 2 domenii pe care vrei să te concentrezi';

  @override
  String get contextGuidanceStyleTitle => 'Stilul de ghidare preferat';

  @override
  String get contextSensitivityTitle => 'Mod de sensibilitate';

  @override
  String get contextSensitivitySubtitle =>
      'Evită formulările care induc anxietate sau sunt deterministe în ghidare';

  @override
  String get contextPriorityHealth => 'Sănătate & obiceiuri';

  @override
  String get contextPriorityCareer => 'Dezvoltare profesională';

  @override
  String get contextPriorityBusiness => 'Decizii de afaceri';

  @override
  String get contextPriorityMoney => 'Bani & stabilitate';

  @override
  String get contextPriorityLove => 'Dragoste & relație';

  @override
  String get contextPriorityFamily => 'Familie & parenting';

  @override
  String get contextPrioritySocial => 'Viața socială';

  @override
  String get contextPriorityGrowth => 'Dezvoltare personală / mentalitate';

  @override
  String get contextGuidanceStyleDirect => 'Direct & practic';

  @override
  String get contextGuidanceStyleDirectDesc =>
      'Obține sfaturi directe și acționabile';

  @override
  String get contextGuidanceStyleEmpathetic => 'Empatic & reflexiv';

  @override
  String get contextGuidanceStyleEmpatheticDesc =>
      'Ghidare caldă și de susținere';

  @override
  String get contextGuidanceStyleBalanced => 'Echilibrat';

  @override
  String get contextGuidanceStyleBalancedDesc =>
      'Amestec de suport practic și emoțional';

  @override
  String get homeGuidancePreparing =>
      'Citind stelele și întrebând Universul despre tine…';

  @override
  String get homeGuidanceFailed =>
      'Generarea ghidării a eșuat. Te rugăm să încerci din nou.';

  @override
  String get homeGuidanceTimeout =>
      'Durată mai lungă decât era de așteptat. Apasă Retry sau verifică din nou în câteva momente.';

  @override
  String get homeGuidanceLoadFailed => 'Încărcarea ghidării a eșuat';

  @override
  String get homeTodaysGuidance => 'Ghidarea de astăzi';

  @override
  String get homeSeeAll => 'Vezi tot';

  @override
  String get homeHealth => 'Sănătate';

  @override
  String get homeCareer => 'Carieră';

  @override
  String get homeMoney => 'Bani';

  @override
  String get homeLove => 'Dragoste';

  @override
  String get homePartners => 'Parteneri';

  @override
  String get homeGrowth => 'Dezvoltare';

  @override
  String get homeTraveler => 'Călător';

  @override
  String homeGreeting(Object name) {
    return 'Bună, $name';
  }

  @override
  String get homeFocusFallback => 'Dezvoltare personală';

  @override
  String get homeDailyMessage => 'Mesajul tău zilnic';

  @override
  String get homeNatalChartTitle => 'Harta mea natală';

  @override
  String get homeNatalChartSubtitle =>
      'Explorează-ți harta natală și interpretările';

  @override
  String get navHome => 'Acasă';

  @override
  String get navHistory => 'Istoric';

  @override
  String get navGuide => 'Ghid';

  @override
  String get navProfile => 'Profil';

  @override
  String get navForYou => 'Pentru tine';

  @override
  String get commonToday => 'Astăzi';

  @override
  String get commonTryAgain => 'Încearcă din nou';

  @override
  String get natalChartTitle => 'Harta mea natală';

  @override
  String get natalChartTabTable => 'Tabel';

  @override
  String get natalChartTabChart => 'Grafica';

  @override
  String get natalChartEmptyTitle => 'Nu există date pentru harta natală';

  @override
  String get natalChartEmptySubtitle =>
      'Te rugăm să completezi datele nașterii pentru a vedea harta ta natală.';

  @override
  String get natalChartAddBirthData => 'Adaugă date de naștere';

  @override
  String get natalChartErrorTitle => 'Imposibil de încărcat harta';

  @override
  String get guidanceTitle => 'Îndrumare zilnică';

  @override
  String get guidanceLoadFailed => 'Încărcarea îndrumării a eșuat';

  @override
  String get guidanceNoneAvailable => 'Nu există îndrumări disponibile';

  @override
  String get guidanceCosmicEnergyTitle => 'Energia cosmică de astăzi';

  @override
  String get guidanceMoodLabel => 'Stare';

  @override
  String get guidanceFocusLabel => 'Concentrare';

  @override
  String get guidanceYourGuidance => 'Îndrumarea ta';

  @override
  String get guidanceTapToCollapse => 'Apasă pentru a restrânge';

  @override
  String get historyTitle => 'Istoricul îndrumărilor';

  @override
  String get historySubtitle => 'Călătoria ta cosmică în timp';

  @override
  String get historyLoadFailed => 'Încărcarea istoricului a eșuat';

  @override
  String get historyEmptyTitle => 'Nu există istoric încă';

  @override
  String get historyEmptySubtitle => 'Îndrumările tale zilnice vor apărea aici';

  @override
  String get historyNewBadge => 'NOU';

  @override
  String get commonUnlocked => 'Dezblocat';

  @override
  String get commonComingSoon => 'În curând';

  @override
  String get commonSomethingWentWrong => 'Ceva a mers prost';

  @override
  String get commonNoContent => 'Nu există conținut disponibil.';

  @override
  String get commonUnknownError => 'Eroare necunoscută';

  @override
  String get commonTakingLonger =>
      'Durata este mai lungă decât era de așteptat. Te rugăm să încerci din nou.';

  @override
  String commonErrorWithMessage(Object error) {
    return 'Eroare: $error';
  }

  @override
  String get forYouTitle => 'Pentru tine';

  @override
  String get forYouSubtitle => 'Perspectivă cosmică personalizată';

  @override
  String get forYouNatalChartTitle => 'Harta mea natală';

  @override
  String get forYouNatalChartSubtitle => 'Analiza hărții tale natale';

  @override
  String get forYouCompatibilitiesTitle => 'Compatibilități';

  @override
  String get forYouCompatibilitiesSubtitle =>
      'Rapoarte despre dragoste, prietenie și parteneriate';

  @override
  String get forYouKarmicTitle => 'Astrologie Karmică';

  @override
  String get forYouKarmicSubtitle =>
      'Lecții ale sufletului și tipare din viețile anterioare';

  @override
  String get forYouLearnTitle => 'Învață astrologie';

  @override
  String get forYouLearnSubtitle => 'Conținut educațional gratuit';

  @override
  String get compatibilitiesTitle => 'Compatibilități';

  @override
  String get compatibilitiesLoadFailed => 'Încărcarea serviciilor a eșuat';

  @override
  String get compatibilitiesBetaFree => 'Beta: Toate rapoartele sunt GRATUITE!';

  @override
  String get compatibilitiesChooseReport => 'Alege un raport';

  @override
  String get compatibilitiesSubtitle =>
      'Descoperă perspective despre tine și relațiile tale';

  @override
  String get compatibilitiesPartnerBadge => '+Partener';

  @override
  String get compatibilitiesPersonalityTitle => 'Raport de personalitate';

  @override
  String get compatibilitiesPersonalitySubtitle =>
      'Analiză cuprinzătoare a personalității tale bazată pe harta natală';

  @override
  String get compatibilitiesRomanticPersonalityTitle =>
      'Raport de personalitate romantică';

  @override
  String get compatibilitiesRomanticPersonalitySubtitle =>
      'Înțelege cum abordezi dragostea și romantismul';

  @override
  String get compatibilitiesLoveCompatibilityTitle =>
      'Compatibilitate în dragoste';

  @override
  String get compatibilitiesLoveCompatibilitySubtitle =>
      'Analiză detaliată a compatibilității romantice cu partenerul tău';

  @override
  String get compatibilitiesRomanticForecastTitle =>
      'Previziune pentru cupluri romantice';

  @override
  String get compatibilitiesRomanticForecastSubtitle =>
      'Perspective asupra viitorului relației tale';

  @override
  String get compatibilitiesFriendshipTitle => 'Raport de prietenie';

  @override
  String get compatibilitiesFriendshipSubtitle =>
      'Analizează dinamica prieteniei și compatibilitatea';

  @override
  String get moonPhaseTitle => 'Raport despre faza lunii';

  @override
  String get moonPhaseSubtitle =>
      'Înțelege energia lunară actuală și cum te afectează. Obține îndrumări aliniate cu faza lunii.';

  @override
  String get moonPhaseSelectDate => 'Selectează data';

  @override
  String get moonPhaseOriginalPrice => '\$2.99';

  @override
  String get moonPhaseGenerate => 'Generează raport';

  @override
  String get moonPhaseGenerateDifferentDate =>
      'Generează pentru o dată diferită';

  @override
  String get moonPhaseGenerationFailed => 'Generarea a eșuat';

  @override
  String get moonPhaseGenerating =>
      'Raportul este în curs de generare. Te rugăm să încerci din nou.';

  @override
  String get moonPhaseUnknownError =>
      'Ceva a mers prost. Te rugăm să încerci din nou.';

  @override
  String get requiredFieldsNote => 'Câmpurile marcate cu * sunt obligatorii.';

  @override
  String get karmicTitle => 'Astrologie Karmică';

  @override
  String karmicLoadFailed(Object error) {
    return 'Încărcarea a eșuat: $error';
  }

  @override
  String get karmicOfferTitle =>
      '🔮 Astrologie Karmică – Mesaje ale Sufletului';

  @override
  String get karmicOfferBody =>
      'Astrologia Karmică dezvăluie tiparele profunde care îți modelează viața, dincolo de evenimentele cotidiene.\n\nOferă o interpretare care vorbește despre lecții nerezolvate, conexiuni karmice și calea de creștere a sufletului.\n\nAceasta nu este despre ce urmează,\nci despre de ce experimentezi ceea ce experimentezi.\n\n✨ Activează Astrologia Karmică și descoperă semnificația mai profundă a călătoriei tale.';

  @override
  String get karmicBetaFreeBadge => 'Testeri Beta – Acces GRATUIT!';

  @override
  String karmicPriceBeta(Object price) {
    return '\$$price – Testeri Beta Gratuit';
  }

  @override
  String karmicPriceUnlock(Object price) {
    return 'Dezblochează pentru \$$price';
  }

  @override
  String get karmicHintInstant => 'Citirea ta va fi generată instantaneu';

  @override
  String get karmicHintOneTime => 'Achiziție unică, fără abonament';

  @override
  String get karmicProgressHint => 'Conectare la calea ta karmică…';

  @override
  String karmicGenerateFailed(Object error) {
    return 'Generarea a eșuat: $error';
  }

  @override
  String get karmicCheckoutTitle => 'Plata pentru Astrologie Karmică';

  @override
  String get karmicCheckoutSubtitle => 'Fluxul de achiziție va veni în curând';

  @override
  String karmicGenerationFailed(Object error) {
    return 'Generarea a eșuat: $error';
  }

  @override
  String get karmicLoading => 'Se încarcă citirea ta karmică...';

  @override
  String get karmicGenerationFailedShort => 'Generarea a eșuat';

  @override
  String get karmicGeneratingTitle => 'Se generează citirea ta karmică...';

  @override
  String get karmicGeneratingSubtitle =>
      'Se analizează harta ta natală pentru tipare karmice și lecții ale sufletului.';

  @override
  String get karmicReadingTitle => '🔮 Citirea ta Karmică';

  @override
  String get karmicReadingSubtitle => 'Mesaje ale Sufletului';

  @override
  String get karmicDisclaimer =>
      'Această citire este pentru auto-reflecție și scopuri de divertisment. Nu constituie sfaturi profesionale.';

  @override
  String get commonActive => 'Activ';

  @override
  String get commonBackToHome => 'Înapoi la Acasă';

  @override
  String get commonYesterday => 'ieri';

  @override
  String commonWeeksAgo(Object count) {
    return '$count săptămâni în urmă';
  }

  @override
  String commonMonthsAgo(Object count) {
    return '$count luni în urmă';
  }

  @override
  String get commonEdit => 'Editează';

  @override
  String get commonDelete => 'Șterge';

  @override
  String get natalChartProGenerated =>
      'Interpretări Pro generate! Derulează în sus pentru a le vedea.';

  @override
  String get natalChartHouse1 => 'Sine & Identitate';

  @override
  String get natalChartHouse2 => 'Bani & Valori';

  @override
  String get natalChartHouse3 => 'Comunicare';

  @override
  String get natalChartHouse4 => 'Acasă & Familie';

  @override
  String get natalChartHouse5 => 'Creativitate & Romantism';

  @override
  String get natalChartHouse6 => 'Sănătate & Rutine';

  @override
  String get natalChartHouse7 => 'Relații';

  @override
  String get natalChartHouse8 => 'Transformare';

  @override
  String get natalChartHouse9 => 'Filozofie și Călătorii';

  @override
  String get natalChartHouse10 => 'Carieră și Statut';

  @override
  String get natalChartHouse11 => 'Prietenii și Obiectivele';

  @override
  String get natalChartHouse12 => 'Spiritualitate';

  @override
  String get helpSupportTitle => 'Ajutor și Suport';

  @override
  String get helpSupportContactTitle => 'Contactați Suportul';

  @override
  String get helpSupportContactSubtitle =>
      'De obicei, răspundem în termen de 24 de ore';

  @override
  String get helpSupportFaqTitle => 'Întrebări Frecvente';

  @override
  String get helpSupportEmailSubject => 'Cerere de Suport Inner Wisdom';

  @override
  String get helpSupportEmailAppFailed =>
      'Nu s-a putut deschide aplicația de email. Vă rugăm să trimiteți un email la support@innerwisdomapp.com';

  @override
  String get helpSupportEmailFallback =>
      'Vă rugăm să ne trimiteți un email la support@innerwisdomapp.com';

  @override
  String get helpSupportFaq1Q => 'Cât de precisă este ghidarea zilnică?';

  @override
  String get helpSupportFaq1A =>
      'Ghidarea noastră zilnică combină principii astrologice tradiționale cu harta dumneavoastră natală. Deși astrologia este interpretativă, AI-ul nostru oferă perspective personalizate bazate pe pozițiile planetare reale și aspectele acestora.';

  @override
  String get helpSupportFaq2Q => 'De ce am nevoie de ora nașterii mele?';

  @override
  String get helpSupportFaq2A =>
      'Ora nașterii dumneavoastră determină Ascendentul (Semnul Ascendent) și pozițiile caselor din harta dumneavoastră. Fără aceasta, folosim prânzul ca valoare implicită, ceea ce poate afecta precizia interpretărilor legate de case.';

  @override
  String get helpSupportFaq3Q => 'Cum îmi schimb datele de naștere?';

  @override
  String get helpSupportFaq3A =>
      'În prezent, datele de naștere nu pot fi schimbate după configurarea inițială pentru a asigura consistența citirilor dumneavoastră. Contactați suportul dacă trebuie să faceți corecții.';

  @override
  String get helpSupportFaq4Q => 'Ce este un subiect de Focus?';

  @override
  String get helpSupportFaq4A =>
      'Un subiect de Focus este o preocupare actuală sau o zonă de viață pe care doriți să o accentuați. Când este setat, ghidarea dumneavoastră zilnică va acorda o atenție specială acestei zone, oferind perspective mai relevante.';

  @override
  String get helpSupportFaq5Q => 'Cum funcționează abonamentul?';

  @override
  String get helpSupportFaq5A =>
      'Nivelul gratuit include ghidare zilnică de bază. Abonații premium beneficiază de personalizare îmbunătățită, citiri audio și acces la funcții speciale, cum ar fi citirile de Astrologie Karmică.';

  @override
  String get helpSupportFaq6Q => 'Datele mele sunt private?';

  @override
  String get helpSupportFaq6A =>
      'Da! Luăm în serios confidențialitatea. Datele dumneavoastră de naștere și informațiile personale sunt criptate și nu sunt niciodată partajate cu terțe părți. Puteți șterge contul dumneavoastră în orice moment.';

  @override
  String get helpSupportFaq7Q =>
      'Ce se întâmplă dacă nu sunt de acord cu o citire?';

  @override
  String get helpSupportFaq7A =>
      'Astrologia este interpretativă și nu fiecare citire va rezonează. Folosiți funcția de feedback pentru a ne ajuta să ne îmbunătățim. AI-ul nostru învață din preferințele dumneavoastră în timp.';

  @override
  String get notificationsSaved => 'Setările de notificare au fost salvate';

  @override
  String get notificationsTitle => 'Notificări';

  @override
  String get notificationsSectionTitle => 'Notificări Push';

  @override
  String get notificationsDailyTitle => 'Ghidare Zilnică';

  @override
  String get notificationsDailySubtitle =>
      'Fiți notificat când ghidarea dumneavoastră zilnică este gata';

  @override
  String get notificationsWeeklyTitle => 'Puncte Săptămânale';

  @override
  String get notificationsWeeklySubtitle =>
      'Prezentare cosmică săptămânală și tranzite cheie';

  @override
  String get notificationsSpecialTitle => 'Evenimente Speciale';

  @override
  String get notificationsSpecialSubtitle =>
      'Luni pline, eclipse și retrograde';

  @override
  String get notificationsDeviceHint =>
      'De asemenea, puteți controla notificările în setările dispozitivului dumneavoastră.';

  @override
  String get concernsTitle => 'Focusul Tău';

  @override
  String get concernsSubtitle => 'Subiecte care modelează ghidarea ta';

  @override
  String concernsTabActive(Object count) {
    return 'Activ ($count)';
  }

  @override
  String concernsTabResolved(Object count) {
    return 'Rezolvat ($count)';
  }

  @override
  String concernsTabArchived(Object count) {
    return 'Arhivat ($count)';
  }

  @override
  String get concernsEmptyTitle => 'Nici o preocupare aici';

  @override
  String get concernsEmptySubtitle =>
      'Adăugați un subiect de focus pentru a obține ghidare personalizată';

  @override
  String get concernsCategoryCareer => 'Carieră și Loc de Muncă';

  @override
  String get concernsCategoryHealth => 'Sănătate';

  @override
  String get concernsCategoryRelationship => 'Relație';

  @override
  String get concernsCategoryFamily => 'Familie';

  @override
  String get concernsCategoryMoney => 'Bani';

  @override
  String get concernsCategoryBusiness => 'Afaceri';

  @override
  String get concernsCategoryPartnership => 'Parteneriat';

  @override
  String get concernsCategoryGrowth => 'Dezvoltare Personală';

  @override
  String get concernsMinLength =>
      'Vă rugăm să descrieți preocuparea dumneavoastră în mai multe detalii (cel puțin 10 caractere)';

  @override
  String get concernsSubmitFailed =>
      'Nu s-a putut trimite preocuparea. Vă rugăm să încercați din nou.';

  @override
  String get concernsAddTitle => 'Ce ai pe minte?';

  @override
  String get concernsAddDescription =>
      'Împărtășiți-vă preocuparea, întrebarea sau situația de viață actuală. AI-ul nostru o va analiza și va oferi ghidare concentrată începând de mâine.';

  @override
  String get concernsExamplesTitle => 'Exemple de preocupări:';

  @override
  String get concernsExampleCareer => 'Decizia de schimbare a carierei';

  @override
  String get concernsExampleRelationship => 'Provocări în relație';

  @override
  String get concernsExampleFinance => 'Timpul de investiție financiară';

  @override
  String get concernsExampleHealth => 'Focus pe sănătate și bunăstare';

  @override
  String get concernsExampleGrowth => 'Direcția de dezvoltare personală';

  @override
  String get concernsSubmitButton => 'Trimite Preocuparea';

  @override
  String get concernsSuccessTitle => 'Preocupare Înregistrată!';

  @override
  String get concernsCategoryLabel => 'Categorie: ';

  @override
  String get concernsSuccessMessage =>
      'Începând de mâine, ghidarea dumneavoastră zilnică se va concentra mai mult pe acest subiect.';

  @override
  String get concernsViewFocusTopics => 'Vizualizați Subiectele Mele de Focus';

  @override
  String get deleteAccountTitle => 'Șterge Contul';

  @override
  String get deleteAccountHeading => 'Ștergeți Contul Dumneavoastră?';

  @override
  String get deleteAccountConfirmError =>
      'Vă rugăm să tastați DELETE pentru a confirma';

  @override
  String get deleteAccountFinalWarningTitle => 'Avertizare Finală';

  @override
  String get deleteAccountFinalWarningBody =>
      'Această acțiune nu poate fi anulată. Toate datele dumneavoastră, inclusiv:\n\n• Profilul și datele de naștere\n• Harta natală și interpretările\n• Istoricul ghidării zilnice\n• Contextul personal și preferințele\n• Toate conținuturile achiziționate\n\nVor fi șterse permanent.';

  @override
  String get deleteAccountConfirmButton => 'Șterge pentru Totdeauna';

  @override
  String get deleteAccountSuccess => 'Contul dumneavoastră a fost șters';

  @override
  String get deleteAccountFailed =>
      'Nu s-a putut șterge contul. Vă rugăm să încercați din nou.';

  @override
  String get deleteAccountPermanentWarning =>
      'Această acțiune este permanentă și nu poate fi anulată';

  @override
  String get deleteAccountWarningDetail =>
      'Toate datele dumneavoastră personale, inclusiv harta natală, istoricul ghidării și orice achiziții vor fi șterse permanent.';

  @override
  String get deleteAccountWhatTitle => 'Ce va fi șters:';

  @override
  String get deleteAccountItemProfile => 'Profilul și contul dumneavoastră';

  @override
  String get deleteAccountItemBirthData => 'Datele de naștere și harta natală';

  @override
  String get deleteAccountItemGuidance => 'Întreg istoricul ghidării zilnice';

  @override
  String get deleteAccountItemContext => 'Context personal și preferințe';

  @override
  String get deleteAccountItemKarmic => 'Citiri de astrologie karmică';

  @override
  String get deleteAccountItemPurchases => 'Toate conținuturile achiziționate';

  @override
  String get deleteAccountTypeDelete => 'Tastați DELETE pentru a confirma';

  @override
  String get deleteAccountDeleteHint => 'DELETE';

  @override
  String get deleteAccountButton => 'Șterge Contul Meu';

  @override
  String get deleteAccountCancel => 'Anulează, păstrează-mi contul';

  @override
  String get learnArticleLoadFailed => 'Nu s-a putut încărca articolul';

  @override
  String get learnContentInEnglish => 'Conținut în engleză';

  @override
  String get learnArticlesLoadFailed => 'Nu s-au putut încărca articolele';

  @override
  String get learnArticlesEmpty => 'Nu sunt articole disponibile încă';

  @override
  String get learnContentFallback =>
      'Se afișează conținut în engleză (nu este disponibil în limba dumneavoastră)';

  @override
  String get checkoutTitle => 'Finalizare Comandă';

  @override
  String get checkoutOrderSummary => 'Sumar Comandă';

  @override
  String get checkoutProTitle => 'Harta Natală Pro';

  @override
  String get checkoutProSubtitle => 'Interpretări planetare complete';

  @override
  String get checkoutTotalLabel => 'Total';

  @override
  String get checkoutTotalAmount => '\$9.99 USD';

  @override
  String get checkoutPaymentTitle => 'Integrarea Plății';

  @override
  String get checkoutPaymentSubtitle =>
      'Integrarea achizițiilor în aplicație este în curs de finalizare. Vă rugăm să verificați din nou în curând!';

  @override
  String get checkoutProcessing => 'Se procesează...';

  @override
  String get checkoutDemoPurchase => 'Achiziție Demo (Testare)';

  @override
  String get checkoutSecurityNote =>
      'Plata este procesată în siguranță prin Apple/Google. Detaliile cardului tău nu sunt niciodată stocate.';

  @override
  String get checkoutSuccess => '🎉 Graficul Natal Pro deblocat cu succes!';

  @override
  String get checkoutGenerateFailed =>
      'Generarea interpretărilor a eșuat. Te rugăm să încerci din nou.';

  @override
  String checkoutErrorWithMessage(Object error) {
    return 'A apărut o eroare: $error';
  }

  @override
  String get billingUpgrade => 'Upgrade la Premium';

  @override
  String billingFeatureLocked(Object feature) {
    return '$feature este o caracteristică Premium';
  }

  @override
  String get billingUpgradeBody =>
      'Upgrade la Premium pentru a debloca această caracteristică și a obține cele mai personalizate îndrumări.';

  @override
  String get contextReviewFailed =>
      'Actualizarea a eșuat. Te rugăm să încerci din nou.';

  @override
  String get contextReviewTitle => 'Timp pentru o Verificare Rapidă';

  @override
  String get contextReviewBody =>
      'Au trecut 3 luni de când am actualizat ultima dată contextul tău personal. A schimbat ceva important în viața ta de care ar trebui să știm?';

  @override
  String get contextReviewHint =>
      'Acest lucru ne ajută să îți oferim îndrumări mai personalizate.';

  @override
  String get contextReviewNoChanges => 'Nicio schimbare';

  @override
  String get contextReviewYesUpdate => 'Da, actualizează';

  @override
  String get contextProfileLoadFailed => 'Încărcarea profilului a eșuat';

  @override
  String get contextCardTitle => 'Context Personal';

  @override
  String get contextCardSubtitle =>
      'Configurează-ți contextul personal pentru a primi îndrumări mai adaptate.';

  @override
  String get contextCardSetupNow => 'Configurează Acum';

  @override
  String contextCardVersionUpdated(Object version, Object date) {
    return 'Versiunea $version • Ultima actualizare $date';
  }

  @override
  String get contextCardAiSummary => 'Rezumat AI';

  @override
  String contextCardToneTag(Object tone) {
    return 'ton $tone';
  }

  @override
  String get contextCardSensitivityTag => 'sensibilitate activată';

  @override
  String get contextCardReviewDue =>
      'Revizuire necesară - actualizează-ți contextul';

  @override
  String contextCardNextReview(Object days) {
    return 'Următoarea revizuire în $days zile';
  }

  @override
  String get contextDeleteTitle => 'Ștergi Contextul Personal?';

  @override
  String get contextDeleteBody =>
      'Aceasta va șterge profilul tău de context personal. Îndrumările tale vor deveni mai puțin personalizate.';

  @override
  String get contextDeleteFailed => 'Ștergerea profilului a eșuat';

  @override
  String get appTitle => 'Înțelepciune Interioară';

  @override
  String get concernsHintExample =>
      'Exemplu: Am o ofertă de muncă într-un alt oraș și nu sunt sigur dacă ar trebui să o accept...';

  @override
  String get learnTitle => 'Învață Astrologie';

  @override
  String get learnFreeTitle => 'Resurse de Învățare Gratuite';

  @override
  String get learnFreeSubtitle => 'Explorează fundamentele astrologiei';

  @override
  String get learnSignsTitle => 'Semne';

  @override
  String get learnSignsSubtitle => '12 semne zodiacale și semnificațiile lor';

  @override
  String get learnPlanetsTitle => 'Planete';

  @override
  String get learnPlanetsSubtitle => 'Corpi cerești în astrologie';

  @override
  String get learnHousesTitle => 'Case';

  @override
  String get learnHousesSubtitle => '12 domenii de viață în graficul tău';

  @override
  String get learnTransitsTitle => 'Tranzite';

  @override
  String get learnTransitsSubtitle => 'Mișcările planetare și efectele lor';

  @override
  String get learnPaceTitle => 'Învață în Ritmul Tău';

  @override
  String get learnPaceSubtitle =>
      'Lecții cuprinzătoare pentru a-ți aprofunda cunoștințele astrologice';

  @override
  String get proNatalTitle => 'Graficul Natal Pro';

  @override
  String get proNatalHeroTitle => 'Deblochează Perspective Profunde';

  @override
  String get proNatalHeroSubtitle =>
      'Obține interpretări cuprinzătoare de 150-200 de cuvinte pentru fiecare plasare planetară din graficul tău natal.';

  @override
  String get proNatalFeature1Title =>
      'Perspective Profunde asupra Personalității';

  @override
  String get proNatalFeature1Body =>
      'Înțelege cum fiecare planetă îți modelează personalitatea unică și calea în viață.';

  @override
  String get proNatalFeature2Title => 'Analiză Alimentată de AI';

  @override
  String get proNatalFeature2Body =>
      'Interpretări avansate adaptate pozițiilor tale planetare exacte.';

  @override
  String get proNatalFeature3Title => 'Îndrumări Acționabile';

  @override
  String get proNatalFeature3Body =>
      'Sfaturi practice pentru carieră, relații și dezvoltare personală.';

  @override
  String get proNatalFeature4Title => 'Acces pe Viață';

  @override
  String get proNatalFeature4Body =>
      'Interpretările tale sunt salvate pentru totdeauna. Accesează oricând.';

  @override
  String get proNatalOneTime => 'Achiziție unică';

  @override
  String get proNatalNoSubscription => 'Nu este necesar un abonament';
}

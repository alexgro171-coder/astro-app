// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get onboardingSkip => 'Kihagyás';

  @override
  String get onboardingTitle1 => 'Üdvözöljük az Inner Wisdom Astro-nál';

  @override
  String get onboardingDesc1 =>
      'Az Innerwisdom Astro több mint 30 éves asztrológiai szakértelmet hoz össze Madi G. vezetésével és a fejlett mesterséges intelligencia erejével, létrehozva a legfinomabb és legmagasabb teljesítményű asztrológiai alkalmazások egyikét, amely ma elérhető.\n\nA mély emberi megértés és az intelligens technológia ötvözésével az Innerwisdom Astro pontos, személyre szabott és jelentős értelmezéseket nyújt, támogatva a felhasználókat önfelfedezésük, tisztánlátásuk és tudatos növekedésük útján.';

  @override
  String get onboardingTitle2 => 'Teljes Asztrológiai Utazásod';

  @override
  String get onboardingDesc2 =>
      'A személyre szabott napi útmutatásoktól kezdve a Natal Születési Térképedig, Karmikus Asztrológia, részletes személyiségi jelentések, Szerelmi és Barátsági Kompatibilitás, Romantikus Előrejelzések Párnak és még sok más — mindez most a kezed ügyében van.\n\nAz Innerwisdom Astro a tisztánlátás, a kapcsolat és az önmegértés támogatására lett tervezve, teljes asztrológiai élményt kínálva, amely a te igényeidhez van szabva.';

  @override
  String get onboardingNext => 'Következő';

  @override
  String get onboardingGetStarted => 'Kezdjük';

  @override
  String get onboardingAlreadyHaveAccount => 'Már van fiókod? Bejelentkezés';

  @override
  String get birthDataTitle => 'Születési Térképed';

  @override
  String get birthDataSubtitle =>
      'Szükségünk van a születési adataidra, hogy létrehozzuk\na személyre szabott asztrológiai profilodat';

  @override
  String get birthDateLabel => 'Születési Dátum';

  @override
  String get birthDateSelectHint => 'Válaszd ki a születési dátumodat';

  @override
  String get birthTimeLabel => 'Születési Idő';

  @override
  String get birthTimeUnknown => 'Ismeretlen';

  @override
  String get birthTimeSelectHint => 'Válaszd ki a születési idődet';

  @override
  String get birthTimeUnknownCheckbox => 'Nem tudom a pontos születési időmet';

  @override
  String get birthPlaceLabel => 'Születési Hely';

  @override
  String get birthPlaceHint => 'Kezdj el gépelni egy városnevet...';

  @override
  String get birthPlaceValidation =>
      'Kérlek, válassz egy helyet a javaslatok közül';

  @override
  String birthPlaceSelected(Object location) {
    return 'Kiválasztva: $location';
  }

  @override
  String get genderLabel => 'Nem';

  @override
  String get genderMale => 'Férfi';

  @override
  String get genderFemale => 'Nő';

  @override
  String get genderPreferNotToSay => 'Nem szeretném megmondani';

  @override
  String get birthDataSubmit => 'Generálj Születési Térképet';

  @override
  String get birthDataPrivacyNote =>
      'A születési adataidat csak a\nasztrológiai térkép kiszámításához használjuk, és biztonságosan tároljuk.';

  @override
  String get birthDateMissing => 'Kérlek, válaszd ki a születési dátumodat';

  @override
  String get birthPlaceMissing =>
      'Kérlek, válassz egy születési helyet a javaslatok közül';

  @override
  String get birthDataSaveError =>
      'Nem sikerült menteni a születési adatokat. Kérlek, próbáld újra.';

  @override
  String get appearanceTitle => 'Megjelenés';

  @override
  String get appearanceTheme => 'Téma';

  @override
  String get appearanceDarkTitle => 'Sötét';

  @override
  String get appearanceDarkSubtitle => 'Könnyen olvasható gyenge fényben';

  @override
  String get appearanceLightTitle => 'Világos';

  @override
  String get appearanceLightSubtitle => 'Hagyományos világos megjelenés';

  @override
  String get appearanceSystemTitle => 'Rendszer';

  @override
  String get appearanceSystemSubtitle => 'Illeszkedj a készülék beállításaihoz';

  @override
  String get appearancePreviewTitle => 'Előnézet';

  @override
  String get appearancePreviewBody =>
      'A kozmikus téma célja, hogy magával ragadó asztrológiai élményt nyújtson. A sötét téma ajánlott a legjobb vizuális élmény érdekében.';

  @override
  String appearanceThemeChanged(Object theme) {
    return 'A téma megváltozott: $theme';
  }

  @override
  String get profileUserFallback => 'Felhasználó';

  @override
  String get profilePersonalContext => 'Személyes Kontextus';

  @override
  String get profileSettings => 'Beállítások';

  @override
  String get profileAppLanguage => 'Alkalmazás Nyelve';

  @override
  String get profileContentLanguage => 'Tartalom Nyelve';

  @override
  String get profileContentLanguageHint =>
      'A mesterséges intelligencia tartalom a kiválasztott nyelvet használja.';

  @override
  String get profileNotifications => 'Értesítések';

  @override
  String get profileNotificationsEnabled => 'Engedélyezve';

  @override
  String get profileNotificationsDisabled => 'Letiltva';

  @override
  String get profileAppearance => 'Megjelenés';

  @override
  String get profileHelpSupport => 'Segítség & Támogatás';

  @override
  String get profilePrivacyPolicy => 'Adatvédelmi Irányelvek';

  @override
  String get profileTermsOfService => 'Szolgáltatási Feltételek';

  @override
  String get profileLogout => 'Kijelentkezés';

  @override
  String get profileLogoutConfirm => 'Biztosan ki akarsz jelentkezni?';

  @override
  String get profileDeleteAccount => 'Fiók Törlése';

  @override
  String get commonCancel => 'Mégse';

  @override
  String get profileSelectLanguageTitle => 'Nyelv Kiválasztása';

  @override
  String get profileSelectLanguageSubtitle =>
      'Minden mesterséges intelligenciával generált tartalom a kiválasztott nyelven lesz.';

  @override
  String profileLanguageUpdated(Object language) {
    return 'Nyelv frissítve: $language';
  }

  @override
  String profileLanguageUpdateFailed(Object error) {
    return 'A nyelv frissítése nem sikerült: $error';
  }

  @override
  String profileVersion(Object version) {
    return 'Inner Wisdom v$version';
  }

  @override
  String get profileCosmicBlueprint => 'A Te Kozmikus Terved';

  @override
  String get profileSunLabel => '☀️ Nap';

  @override
  String get profileMoonLabel => '🌙 Hold';

  @override
  String get profileRisingLabel => '⬆️ Felkelő';

  @override
  String get profileUnknown => 'Ismeretlen';

  @override
  String get forgotPasswordTitle => 'Elfelejtetted a Jelszavad?';

  @override
  String get forgotPasswordSubtitle =>
      'Add meg az email címed, és küldünk egy kódot a jelszavad visszaállításához';

  @override
  String get forgotPasswordSent =>
      'Ha létezik fiók, egy visszaállító kódot küldtünk az email címedre.';

  @override
  String get forgotPasswordFailed =>
      'A visszaállító kód küldése nem sikerült. Kérlek, próbáld újra.';

  @override
  String get forgotPasswordSendCode => 'Visszaállító Kód Küldése';

  @override
  String get forgotPasswordHaveCode => 'Már van kódod?';

  @override
  String get forgotPasswordRemember => 'Emlékszel a jelszavadra? ';

  @override
  String get loginWelcomeBack => 'Üdvözlünk Vissza';

  @override
  String get loginSubtitle =>
      'Jelentkezz be, hogy folytathasd kozmikus utazásodat';

  @override
  String get loginInvalidCredentials => 'Érvénytelen email vagy jelszó';

  @override
  String get loginGoogleFailed =>
      'A Google bejelentkezés nem sikerült. Kérlek, próbáld újra.';

  @override
  String get loginAppleFailed =>
      'Az Apple bejelentkezés nem sikerült. Kérlek, próbáld újra.';

  @override
  String get loginNetworkError =>
      'Hálózati hiba. Kérlek, ellenőrizd a kapcsolatodat.';

  @override
  String get loginSignInCancelled => 'A bejelentkezés megszakítva.';

  @override
  String get loginPasswordHint => 'Add meg a jelszavad';

  @override
  String get loginForgotPassword => 'Elfelejtetted a Jelszavad?';

  @override
  String get loginSignIn => 'Bejelentkezés';

  @override
  String get loginNoAccount => 'Nincs fiókod? ';

  @override
  String get loginSignUp => 'Regisztráció';

  @override
  String get commonEmailLabel => 'Email';

  @override
  String get commonEmailHint => 'Add meg az email címed';

  @override
  String get commonEmailRequired => 'Kérlek, add meg az email címed';

  @override
  String get commonEmailInvalid => 'Kérlek, adj meg egy érvényes email címet';

  @override
  String get commonPasswordLabel => 'Jelszó';

  @override
  String get commonPasswordRequired => 'Kérlek, add meg a jelszavad';

  @override
  String get commonOrContinueWith => 'vagy folytasd a';

  @override
  String get commonGoogle => 'Google';

  @override
  String get commonApple => 'Apple';

  @override
  String get commonNameLabel => 'Név';

  @override
  String get commonNameHint => 'Add meg a neved';

  @override
  String get commonNameRequired => 'Kérlek, add meg a neved';

  @override
  String get signupTitle => 'Fiók Létrehozása';

  @override
  String get signupSubtitle =>
      'Kezdd el kozmikus utazásodat az Inner Wisdom-mal';

  @override
  String get signupEmailExists => 'Az email már létezik vagy érvénytelen adat';

  @override
  String get signupGoogleFailed =>
      'A Google bejelentkezés nem sikerült. Kérjük, próbálja újra.';

  @override
  String get signupAppleFailed =>
      'Az Apple bejelentkezés nem sikerült. Kérjük, próbálja újra.';

  @override
  String get signupPasswordHint => 'Hozzon létre egy jelszót (min. 8 karakter)';

  @override
  String get signupPasswordMin =>
      'A jelszónak legalább 8 karakterből kell állnia';

  @override
  String get signupConfirmPasswordLabel => 'Jelszó megerősítése';

  @override
  String get signupConfirmPasswordHint => 'Erősítse meg a jelszavát';

  @override
  String get signupConfirmPasswordRequired =>
      'Kérjük, erősítse meg a jelszavát';

  @override
  String get signupPasswordMismatch => 'A jelszavak nem egyeznek';

  @override
  String get signupPreferredLanguage => 'Preferált nyelv';

  @override
  String get signupCreateAccount => 'Fiók létrehozása';

  @override
  String get signupHaveAccount => 'Már van fiókja? ';

  @override
  String get resetPasswordTitle => 'Jelszó visszaállítása';

  @override
  String get resetPasswordSubtitle =>
      'Adja meg az email címére küldött kódot, és állítson be egy új jelszót';

  @override
  String get resetPasswordSuccess =>
      'A jelszó visszaállítása sikeres! Átirányítás a bejelentkezéshez...';

  @override
  String get resetPasswordFailed =>
      'A jelszó visszaállítása nem sikerült. Kérjük, próbálja újra.';

  @override
  String get resetPasswordInvalidCode =>
      'Érvénytelen vagy lejárt visszaállító kód. Kérjük, kérjen egy újat.';

  @override
  String get resetPasswordMaxAttempts =>
      'A maximális próbálkozások száma túllépve. Kérjük, kérjen egy új kódot.';

  @override
  String get resetCodeLabel => 'Visszaállító kód';

  @override
  String get resetCodeHint => 'Adja meg a 6 számjegyű kódot';

  @override
  String get resetCodeRequired => 'Kérjük, adja meg a visszaállító kódot';

  @override
  String get resetCodeLength => 'A kódnak 6 számjegyűnek kell lennie';

  @override
  String get resetNewPasswordLabel => 'Új jelszó';

  @override
  String get resetNewPasswordHint =>
      'Hozzon létre egy új jelszót (min. 8 karakter)';

  @override
  String get resetNewPasswordRequired => 'Kérjük, adjon meg egy új jelszót';

  @override
  String get resetConfirmPasswordHint => 'Erősítse meg az új jelszavát';

  @override
  String get resetPasswordButton => 'Jelszó visszaállítása';

  @override
  String get resetRequestNewCode => 'Kérjen egy új kódot';

  @override
  String get serviceResultGenerated => 'Jelentés generálva';

  @override
  String serviceResultReady(Object title) {
    return 'A személyre szabott $title készen áll';
  }

  @override
  String get serviceResultBackToForYou => 'Vissza a Számodra';

  @override
  String get serviceResultNotSavedNotice =>
      'Ez a Jelentés nem lesz mentve. Ha szeretné, másolja ki, és mentse el máshol a Másolás funkcióval.';

  @override
  String get commonCopy => 'Másolás';

  @override
  String get commonCopied => 'Másolva a vágólapra';

  @override
  String get commonContinue => 'Folytatás';

  @override
  String get partnerDetailsTitle => 'Partner részletei';

  @override
  String get partnerBirthDataTitle => 'Adja meg a partner születési adatait';

  @override
  String partnerBirthDataFor(Object title) {
    return '\"$title\" számára';
  }

  @override
  String get partnerNameOptionalLabel => 'Név (opcionális)';

  @override
  String get partnerNameHint => 'Partner neve';

  @override
  String get partnerGenderOptionalLabel => 'Nem (opcionális)';

  @override
  String get partnerBirthDateLabel => 'Születési dátum *';

  @override
  String get partnerBirthDateSelect => 'Válassza ki a születési dátumot';

  @override
  String get partnerBirthDateMissing =>
      'Kérjük, válassza ki a születési dátumot';

  @override
  String get partnerBirthTimeOptionalLabel => 'Születési idő (opcionális)';

  @override
  String get partnerBirthTimeSelect => 'Válassza ki a születési időt';

  @override
  String get partnerBirthPlaceLabel => 'Születési hely *';

  @override
  String get serviceOfferRequiresPartner =>
      'Szükséges a partner születési adatai';

  @override
  String get serviceOfferBetaFree =>
      'A béta tesztelők ingyenes hozzáférést kapnak!';

  @override
  String get serviceOfferUnlocked => 'Feloldva';

  @override
  String get serviceOfferGenerate => 'Jelentés generálása';

  @override
  String serviceOfferUnlockFor(Object price) {
    return 'Feloldás $price-ért';
  }

  @override
  String get serviceOfferPreparing =>
      'A személyre szabott jelentésed előkészítése…';

  @override
  String get serviceOfferTimeout => 'Túl sokáig tart. Kérjük, próbálja újra.';

  @override
  String get serviceOfferNotReady =>
      'A jelentés még nem készült el. Kérjük, próbálja újra.';

  @override
  String serviceOfferFetchFailed(Object error) {
    return 'A jelentés lekérése nem sikerült: $error';
  }

  @override
  String get commonFree => 'INGYENES';

  @override
  String get commonLater => 'Később';

  @override
  String get commonRetry => 'Újrapróbálkozás';

  @override
  String get commonYes => 'Igen';

  @override
  String get commonNo => 'Nem';

  @override
  String get commonBack => 'Vissza';

  @override
  String get commonOptional => 'Opcionális';

  @override
  String get commonNotSpecified => 'Nincs megadva';

  @override
  String get commonJustNow => 'Éppen most';

  @override
  String get commonViewMore => 'Továbbiak megtekintése';

  @override
  String get commonViewLess => 'Kevesebb megtekintése';

  @override
  String commonMinutesAgo(Object count) {
    return '$count perce';
  }

  @override
  String commonHoursAgo(Object count) {
    return '$count órája';
  }

  @override
  String commonDaysAgo(Object count) {
    return '$count napja';
  }

  @override
  String commonDateShort(Object day, Object month, Object year) {
    return '$day/$month/$year';
  }

  @override
  String get askGuideTitle => 'Kérdezze meg az Útmutatóját';

  @override
  String get askGuideSubtitle => 'Személyes kozmikus útmutatás';

  @override
  String askGuideRemaining(Object count) {
    return '$count maradt';
  }

  @override
  String get askGuideQuestionHint =>
      'Kérdezzen bármit - szerelem, karrier, döntések, érzelmek...';

  @override
  String get askGuideBasedOnChart =>
      'A születési diagramja és a mai kozmikus energiák alapján';

  @override
  String get askGuideThinking => 'Az Ön Útmutatója gondolkodik...';

  @override
  String get askGuideYourGuide => 'Az Ön Útmutatója';

  @override
  String get askGuideEmptyTitle => 'Kérdezze meg az Első Kérdését';

  @override
  String get askGuideEmptyBody =>
      'Azonnali, mélyen személyes útmutatást kap a születési diagramja és a mai kozmikus energiák alapján.';

  @override
  String get askGuideEmptyHint =>
      'Kérdezzen bármit — szerelem, karrier, döntések, érzelmek.';

  @override
  String get askGuideLoadFailed => 'Az adatok betöltése nem sikerült';

  @override
  String askGuideSendFailed(Object error) {
    return 'A kérdés elküldése nem sikerült: $error';
  }

  @override
  String get askGuideLimitTitle => 'Havi Korlát Elérve';

  @override
  String get askGuideLimitBody => 'Elérte a havi kérésének korlátját.';

  @override
  String get askGuideLimitAddon =>
      'Vásárolhat egy \$1.99 kiegészítőt, hogy továbbra is használhassa ezt a szolgáltatást a jelenlegi számlázási hónap hátralévő részében.';

  @override
  String askGuideLimitBillingEnd(Object date) {
    return 'A számlázási hónapja vége: $date';
  }

  @override
  String get askGuideLimitGetAddon => 'Kiegészítő beszerzése';

  @override
  String get contextTitle => 'Személyes Kontextus';

  @override
  String contextStepOf(Object current, Object total) {
    return '$current lépés a $total-ból';
  }

  @override
  String get contextStep1Title => 'Az Önt körülvevő emberek';

  @override
  String get contextStep1Subtitle =>
      'A kapcsolati és családi kontextus segít megérteni érzelmi táját.';

  @override
  String get contextStep2Title => 'Szakmai élet';

  @override
  String get contextStep2Subtitle =>
      'A munkája és napi ritmusa alakítja, hogyan tapasztalja meg a nyomást, a növekedést és a célt.';

  @override
  String get contextStep3Title => 'Hogyan érzi most az életet';

  @override
  String get contextStep3Subtitle =>
      'Nincsenek helyes vagy helytelen válaszok, csak a jelenlegi valósága';

  @override
  String get contextStep4Title => 'Mi számít Önnek a legjobban';

  @override
  String get contextStep4Subtitle =>
      'Így az útmutatása összhangban van azzal, ami igazán fontos Önnek';

  @override
  String get contextPriorityRequired =>
      'Kérjük, válasszon ki legalább egy prioritási területet.';

  @override
  String contextSaveFailed(Object error) {
    return 'A profil mentése nem sikerült: $error';
  }

  @override
  String get contextSaveContinue => 'Mentés és folytatás';

  @override
  String get contextRelationshipStatusTitle =>
      'Jelenlegi párkapcsolati státusz';

  @override
  String get contextSeekingRelationshipTitle => 'Keresel párkapcsolatot?';

  @override
  String get contextHasChildrenTitle => 'Vannak gyermekeid?';

  @override
  String get contextChildrenDetailsOptional =>
      'Gyermekek részletei (opcionális)';

  @override
  String get contextAddChild => 'Gyermek hozzáadása';

  @override
  String get contextChildAgeLabel => 'Kor';

  @override
  String contextChildAgeYears(num age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other: 'év',
      one: 'év',
    );
    return '$age $_temp0';
  }

  @override
  String get contextChildGenderLabel => 'Nem';

  @override
  String get contextRelationshipSingle => 'Egyedülálló';

  @override
  String get contextRelationshipInRelationship => 'Kapcsolatban';

  @override
  String get contextRelationshipMarried => 'Házas / Élettársi kapcsolat';

  @override
  String get contextRelationshipSeparated => 'Elvált / Különélő';

  @override
  String get contextRelationshipWidowed => 'Özvegy';

  @override
  String get contextRelationshipPreferNotToSay => 'Nem szeretném megmondani';

  @override
  String get contextProfessionalStatusTitle => 'Jelenlegi szakmai státusz';

  @override
  String get contextProfessionalStatusOtherHint =>
      'Kérlek, add meg a munkavállalói státuszodat';

  @override
  String get contextIndustryTitle => 'Fő iparág/terület';

  @override
  String get contextWorkStatusStudent => 'Diák';

  @override
  String get contextWorkStatusUnemployed => 'Munkanélküli / Két munka között';

  @override
  String get contextWorkStatusEmployedIc =>
      'Foglalkoztatott (Egyéni hozzájáruló)';

  @override
  String get contextWorkStatusEmployedManagement => 'Foglalkoztatott (Vezetői)';

  @override
  String get contextWorkStatusExecutive => 'Vezető / Vezetőség (C-szint)';

  @override
  String get contextWorkStatusSelfEmployed => 'Önálló vállalkozó / Szabadúszó';

  @override
  String get contextWorkStatusEntrepreneur => 'Vállalkozó / Cégvezető';

  @override
  String get contextWorkStatusInvestor => 'Befektető';

  @override
  String get contextWorkStatusRetired => 'Nyugdíjas';

  @override
  String get contextWorkStatusHomemaker =>
      'Háztartásbeli / Otthon maradó szülő';

  @override
  String get contextWorkStatusCareerBreak => 'Karrier szünet / Szabadság';

  @override
  String get contextWorkStatusOther => 'Egyéb';

  @override
  String get contextIndustryTech => 'Technológia / IT';

  @override
  String get contextIndustryFinance => 'Pénzügy / Befektetések';

  @override
  String get contextIndustryHealthcare => 'Egészségügy';

  @override
  String get contextIndustryEducation => 'Oktatás';

  @override
  String get contextIndustrySalesMarketing => 'Értékesítés / Marketing';

  @override
  String get contextIndustryRealEstate => 'Ingatlan';

  @override
  String get contextIndustryHospitality => 'Vendéglátás';

  @override
  String get contextIndustryGovernment => 'Kormány / Közszolgáltatás';

  @override
  String get contextIndustryCreative => 'Kreatív iparágak';

  @override
  String get contextIndustryOther => 'Egyéb';

  @override
  String get contextSelfAssessmentIntro =>
      'Értékeld a jelenlegi helyzetedet minden területen (1 = küzdő, 5 = virágzó)';

  @override
  String get contextSelfHealthTitle => 'Egészség és energia';

  @override
  String get contextSelfHealthSubtitle =>
      '1 = súlyos problémák/alacsony energia, 5 = kiváló vitalitás';

  @override
  String get contextSelfSocialTitle => 'Társadalmi élet';

  @override
  String get contextSelfSocialSubtitle =>
      '1 = elszigetelt, 5 = virágzó társadalmi kapcsolatok';

  @override
  String get contextSelfRomanceTitle => 'Romantikus élet';

  @override
  String get contextSelfRomanceSubtitle =>
      '1 = hiányzó/kihívásokkal teli, 5 = beteljesült';

  @override
  String get contextSelfFinanceTitle => 'Pénzügyi stabilitás';

  @override
  String get contextSelfFinanceSubtitle =>
      '1 = jelentős nehézségek, 5 = kiváló';

  @override
  String get contextSelfCareerTitle => 'Karrier elégedettség';

  @override
  String get contextSelfCareerSubtitle =>
      '1 = megrekedt/stresszes, 5 = előrehaladás/tisztánlátás';

  @override
  String get contextSelfGrowthTitle => 'Személyes fejlődés érdeklődés';

  @override
  String get contextSelfGrowthSubtitle =>
      '1 = alacsony érdeklődés, 5 = nagyon magas';

  @override
  String get contextSelfStruggling => 'Küzdő';

  @override
  String get contextSelfThriving => 'Virágzó';

  @override
  String get contextPrioritiesTitle => 'Mik a legfontosabb prioritásaid most?';

  @override
  String get contextPrioritiesSubtitle =>
      'Válassz ki legfeljebb 2 területet, amire fókuszálni szeretnél';

  @override
  String get contextGuidanceStyleTitle => 'Preferált útmutatási stílus';

  @override
  String get contextSensitivityTitle => 'Érzékenységi mód';

  @override
  String get contextSensitivitySubtitle =>
      'Kerüld az szorongást keltő vagy determinisztikus megfogalmazásokat az útmutatásban';

  @override
  String get contextPriorityHealth => 'Egészség és szokások';

  @override
  String get contextPriorityCareer => 'Karrier fejlődés';

  @override
  String get contextPriorityBusiness => 'Üzleti döntések';

  @override
  String get contextPriorityMoney => 'Pénz és stabilitás';

  @override
  String get contextPriorityLove => 'Szerelem és párkapcsolat';

  @override
  String get contextPriorityFamily => 'Család és szülőség';

  @override
  String get contextPrioritySocial => 'Társadalmi élet';

  @override
  String get contextPriorityGrowth => 'Személyes fejlődés / gondolkodásmód';

  @override
  String get contextGuidanceStyleDirect => 'Közvetlen és praktikus';

  @override
  String get contextGuidanceStyleDirectDesc =>
      'Közvetlenül a cselekvőképes tanácsra';

  @override
  String get contextGuidanceStyleEmpathetic => 'Empatikus és reflektív';

  @override
  String get contextGuidanceStyleEmpatheticDesc => 'Meleg, támogató útmutatás';

  @override
  String get contextGuidanceStyleBalanced => 'Kiegyensúlyozott';

  @override
  String get contextGuidanceStyleBalancedDesc =>
      'Praktikus és érzelmi támogatás keveréke';

  @override
  String get homeGuidancePreparing =>
      'Olvasom a csillagokat és kérdezem az Univerzumban rólad…';

  @override
  String get homeGuidanceFailed =>
      'Nem sikerült útmutatást generálni. Kérlek, próbáld újra.';

  @override
  String get homeGuidanceTimeout =>
      'Több időt vesz igénybe, mint vártuk. Koppints a Próbáld újra gombra, vagy nézz vissza egy pillanat múlva.';

  @override
  String get homeGuidanceLoadFailed => 'Nem sikerült betölteni az útmutatást';

  @override
  String get homeTodaysGuidance => 'Mai útmutatás';

  @override
  String get homeSeeAll => 'Összes megtekintése';

  @override
  String get homeHealth => 'Egészség';

  @override
  String get homeCareer => 'Karrier';

  @override
  String get homeMoney => 'Pénz';

  @override
  String get homeLove => 'Szerelem';

  @override
  String get homePartners => 'Partnerek';

  @override
  String get homeGrowth => 'Fejlődés';

  @override
  String get homeTraveler => 'Utazó';

  @override
  String homeGreeting(Object name) {
    return 'Helló, $name';
  }

  @override
  String get homeFocusFallback => 'Személyes fejlődés';

  @override
  String get homeDailyMessage => 'A napi üzeneted';

  @override
  String get homeNatalChartTitle => 'Születési térképem';

  @override
  String get homeNatalChartSubtitle =>
      'Fedezd fel a születési térképedet és értelmezéseit';

  @override
  String get navHome => 'Kezdőlap';

  @override
  String get navHistory => 'Történelem';

  @override
  String get navGuide => 'Útmutató';

  @override
  String get navProfile => 'Profil';

  @override
  String get navForYou => 'Számodra';

  @override
  String get commonToday => 'Ma';

  @override
  String get commonTryAgain => 'Próbáld újra';

  @override
  String get natalChartTitle => 'Születési térképem';

  @override
  String get natalChartTabTable => 'Táblázat';

  @override
  String get natalChartTabChart => 'Diagram';

  @override
  String get natalChartEmptyTitle => 'Nincs születési diagram adat';

  @override
  String get natalChartEmptySubtitle =>
      'Kérjük, töltsd ki a születési adataidat a születési diagram megtekintéséhez.';

  @override
  String get natalChartAddBirthData => 'Születési adatok hozzáadása';

  @override
  String get natalChartErrorTitle => 'A diagram betöltése nem sikerült';

  @override
  String get guidanceTitle => 'Napi Útmutatás';

  @override
  String get guidanceLoadFailed => 'Az útmutatás betöltése nem sikerült';

  @override
  String get guidanceNoneAvailable => 'Nincs elérhető útmutatás';

  @override
  String get guidanceCosmicEnergyTitle => 'A mai Kozmikus Energia';

  @override
  String get guidanceMoodLabel => 'Hangulat';

  @override
  String get guidanceFocusLabel => 'Fókusz';

  @override
  String get guidanceYourGuidance => 'A te útmutatásod';

  @override
  String get guidanceTapToCollapse => 'Koppints a bezáráshoz';

  @override
  String get historyTitle => 'Útmutatás Történet';

  @override
  String get historySubtitle => 'Kozmikus utazásod az időben';

  @override
  String get historyLoadFailed => 'A történet betöltése nem sikerült';

  @override
  String get historyEmptyTitle => 'Még nincs történet';

  @override
  String get historyEmptySubtitle =>
      'A napi útmutatásaid itt fognak megjelenni';

  @override
  String get historyNewBadge => 'ÚJ';

  @override
  String get commonUnlocked => 'Feloldva';

  @override
  String get commonComingSoon => 'Hamarosan';

  @override
  String get commonSomethingWentWrong => 'Valami hiba történt';

  @override
  String get commonNoContent => 'Nincs elérhető tartalom.';

  @override
  String get commonUnknownError => 'Ismeretlen hiba';

  @override
  String get commonTakingLonger =>
      'Hosszabb ideig tart, mint vártuk. Kérjük, próbáld újra.';

  @override
  String commonErrorWithMessage(Object error) {
    return 'Hiba: $error';
  }

  @override
  String get forYouTitle => 'Számodra';

  @override
  String get forYouSubtitle => 'Személyre szabott kozmikus betekintések';

  @override
  String get forYouNatalChartTitle => 'Születési Diagramom';

  @override
  String get forYouNatalChartSubtitle => 'A születési diagramod elemzése';

  @override
  String get forYouCompatibilitiesTitle => 'Kompatibilitások';

  @override
  String get forYouCompatibilitiesSubtitle =>
      'Szerelem, barátság és partnerségi jelentések';

  @override
  String get forYouKarmicTitle => 'Karmikus Asztrológia';

  @override
  String get forYouKarmicSubtitle => 'Lélekleckék és múltbeli életminták';

  @override
  String get forYouLearnTitle => 'Tanulj Asztrológiát';

  @override
  String get forYouLearnSubtitle => 'Ingyenes oktatási tartalom';

  @override
  String get compatibilitiesTitle => 'Kompatibilitások';

  @override
  String get compatibilitiesLoadFailed =>
      'A szolgáltatások betöltése nem sikerült';

  @override
  String get compatibilitiesBetaFree => 'Béta: Minden jelentés INGYENES!';

  @override
  String get compatibilitiesChooseReport => 'Jelentés választása';

  @override
  String get compatibilitiesSubtitle =>
      'Fedezd fel önmagadra és kapcsolataidra vonatkozó betekintéseket';

  @override
  String get compatibilitiesPartnerBadge => '+Partner';

  @override
  String get compatibilitiesPersonalityTitle => 'Személyiség Jelentés';

  @override
  String get compatibilitiesPersonalitySubtitle =>
      'Átfogó elemzés a személyiségedről a születési diagramod alapján';

  @override
  String get compatibilitiesRomanticPersonalityTitle =>
      'Romantikus Személyiség Jelentés';

  @override
  String get compatibilitiesRomanticPersonalitySubtitle =>
      'Értsd meg, hogyan közelítesz a szerelemhez és a romantikához';

  @override
  String get compatibilitiesLoveCompatibilityTitle => 'Szerelem Kompatibilitás';

  @override
  String get compatibilitiesLoveCompatibilitySubtitle =>
      'Részletes romantikus kompatibilitási elemzés a partnereddel';

  @override
  String get compatibilitiesRomanticForecastTitle =>
      'Romantikus Pár Előrejelzés';

  @override
  String get compatibilitiesRomanticForecastSubtitle =>
      'Betekintés a kapcsolatod jövőjébe';

  @override
  String get compatibilitiesFriendshipTitle => 'Barátság Jelentés';

  @override
  String get compatibilitiesFriendshipSubtitle =>
      'Barátsági dinamikák és kompatibilitás elemzése';

  @override
  String get moonPhaseTitle => 'Holdfázis Jelentés';

  @override
  String get moonPhaseSubtitle =>
      'Értsd meg a jelenlegi holdenergiát és hogy ez hogyan hat rád. Kapj útmutatást a holdfázisnak megfelelően.';

  @override
  String get moonPhaseSelectDate => 'Dátum kiválasztása';

  @override
  String get moonPhaseOriginalPrice => '\$2.99';

  @override
  String get moonPhaseGenerate => 'Jelentés generálása';

  @override
  String get moonPhaseGenerateDifferentDate => 'Generálás másik dátumra';

  @override
  String get moonPhaseGenerationFailed => 'Generálás nem sikerült';

  @override
  String get moonPhaseGenerating =>
      'A jelentés generálása folyamatban. Kérjük, próbáld újra.';

  @override
  String get moonPhaseUnknownError =>
      'Valami hiba történt. Kérjük, próbáld újra.';

  @override
  String get requiredFieldsNote => 'A *-gal jelölt mezők kötelezőek.';

  @override
  String get karmicTitle => 'Karmikus Asztrológia';

  @override
  String karmicLoadFailed(Object error) {
    return 'Betöltés nem sikerült: $error';
  }

  @override
  String get karmicOfferTitle => '🔮 Karmikus Asztrológia – A Lélek Üzenetei';

  @override
  String get karmicOfferBody =>
      'A Karmikus Asztrológia felfedi az életet formáló mély mintákat, a mindennapi eseményeken túl.\n\nOlyan értelmezést kínál, amely a megoldatlan leckékről, karmikus kapcsolódásokról és a lélek növekedési útjáról szól.\n\nEz nem arról szól, hogy mi következik,\nhanem arról, hogy miért tapasztalod meg azt, amit megélsz.\n\n✨ Aktiváld a Karmikus Asztrológiát, és fedezd fel utazásod mélyebb jelentését.';

  @override
  String get karmicBetaFreeBadge => 'Béta Tesztelők – INGYENES Hozzáférés!';

  @override
  String karmicPriceBeta(Object price) {
    return '\$$price – Béta Tesztelők Ingyenes';
  }

  @override
  String karmicPriceUnlock(Object price) {
    return 'Feloldás: \$$price';
  }

  @override
  String get karmicHintInstant => 'A felolvasás azonnal generálódik';

  @override
  String get karmicHintOneTime => 'Egyszeri vásárlás, nincs előfizetés';

  @override
  String get karmicProgressHint => 'Kapcsolódás a karmikus utadhoz...';

  @override
  String karmicGenerateFailed(Object error) {
    return 'Generálás nem sikerült: $error';
  }

  @override
  String get karmicCheckoutTitle => 'Karmikus Asztrológia Pénztár';

  @override
  String get karmicCheckoutSubtitle => 'Vásárlási folyamat hamarosan';

  @override
  String karmicGenerationFailed(Object error) {
    return 'Generálás nem sikerült: $error';
  }

  @override
  String get karmicLoading => 'A karmikus felolvasásod betöltése...';

  @override
  String get karmicGenerationFailedShort => 'Generálás nem sikerült';

  @override
  String get karmicGeneratingTitle => 'A Karmikus Felolvasásod Generálása...';

  @override
  String get karmicGeneratingSubtitle =>
      'A születési diagramod elemzése karmikus minták és lélekleckék szempontjából.';

  @override
  String get karmicReadingTitle => '🔮 A Te Karmikus Felolvasásod';

  @override
  String get karmicReadingSubtitle => 'A Lélek Üzenetei';

  @override
  String get karmicDisclaimer =>
      'Ez a felolvasás önreflexióra és szórakozásra szolgál. Nem helyettesít szakmai tanácsadást.';

  @override
  String get commonActive => 'Aktív';

  @override
  String get commonBackToHome => 'Vissza a Főoldalra';

  @override
  String get commonYesterday => 'tegnap';

  @override
  String commonWeeksAgo(Object count) {
    return '$count héttel ezelőtt';
  }

  @override
  String commonMonthsAgo(Object count) {
    return '$count hónappal ezelőtt';
  }

  @override
  String get commonEdit => 'Szerkesztés';

  @override
  String get commonDelete => 'Törlés';

  @override
  String get natalChartProGenerated =>
      'Pro értelmezések generálva! Görgess fel, hogy lásd őket.';

  @override
  String get natalChartHouse1 => 'Önmagad és Identitás';

  @override
  String get natalChartHouse2 => 'Pénz és Értékek';

  @override
  String get natalChartHouse3 => 'Kommunikáció';

  @override
  String get natalChartHouse4 => 'Otthon és Család';

  @override
  String get natalChartHouse5 => 'Kreativitás és Romantika';

  @override
  String get natalChartHouse6 => 'Egészség és Rutin';

  @override
  String get natalChartHouse7 => 'Kapcsolatok';

  @override
  String get natalChartHouse8 => 'Átalakulás';

  @override
  String get natalChartHouse9 => 'Filozófia és Utazás';

  @override
  String get natalChartHouse10 => 'Karrier és Státusz';

  @override
  String get natalChartHouse11 => 'Barátok és Célok';

  @override
  String get natalChartHouse12 => 'Spiritualitás';

  @override
  String get helpSupportTitle => 'Segítség és Támogatás';

  @override
  String get helpSupportContactTitle => 'Támogatás Kapcsolat';

  @override
  String get helpSupportContactSubtitle =>
      'Általában 24 órán belül válaszolunk';

  @override
  String get helpSupportFaqTitle => 'Gyakran Ismételt Kérdések';

  @override
  String get helpSupportEmailSubject => 'Belső Bölcsesség Támogatási Kérelem';

  @override
  String get helpSupportEmailAppFailed =>
      'Nem sikerült megnyitni az e-mail alkalmazást. Kérjük, írjon a support@innerwisdomapp.com címre';

  @override
  String get helpSupportEmailFallback =>
      'Kérjük, írjon nekünk a support@innerwisdomapp.com címre';

  @override
  String get helpSupportFaq1Q => 'Mennyire pontos a napi útmutatás?';

  @override
  String get helpSupportFaq1A =>
      'A napi útmutatásunk a hagyományos asztrológiai elveket ötvözi a személyes születési térképeddel. Míg az asztrológia értelmező, az AI-nk valós bolygóhelyzetek és aspektusok alapján nyújt személyre szabott betekintést.';

  @override
  String get helpSupportFaq2Q => 'Miért van szükségem a születési időmre?';

  @override
  String get helpSupportFaq2A =>
      'A születési időd határozza meg az Aszcendensedet (Fellépő jel) és a házak pozícióit a térképedben. Enélkül délben használjuk alapértelmezettként, ami befolyásolhatja a házakkal kapcsolatos értelmezések pontosságát.';

  @override
  String get helpSupportFaq3Q =>
      'Hogyan tudom megváltoztatni a születési adataimat?';

  @override
  String get helpSupportFaq3A =>
      'Jelenleg a születési adatokat nem lehet megváltoztatni az első beállítás után, hogy biztosítsuk az olvasások következetességét. Lépj kapcsolatba a támogatással, ha javításokra van szükséged.';

  @override
  String get helpSupportFaq4Q => 'Mi az a Fókusz téma?';

  @override
  String get helpSupportFaq4A =>
      'A Fókusz téma egy aktuális aggodalom vagy élet terület, amelyet hangsúlyozni szeretnél. Ha be van állítva, a napi útmutatásod külön figyelmet fordít erre a területre, relevánsabb betekintést nyújtva.';

  @override
  String get helpSupportFaq5Q => 'Hogyan működik a előfizetés?';

  @override
  String get helpSupportFaq5A =>
      'A ingyenes szint alapvető napi útmutatást tartalmaz. A prémium előfizetők fokozott személyre szabást, audio olvasásokat és hozzáférést kapnak különleges funkciókhoz, mint például a Karmikus Asztrológiai olvasások.';

  @override
  String get helpSupportFaq6Q => 'Privát az adatom?';

  @override
  String get helpSupportFaq6A =>
      'Igen! Komolyan vesszük a magánéletet. A születési adataid és személyes információid titkosítva vannak, és soha nem osztjuk meg harmadik felekkel. Bármikor törölheted a fiókodat.';

  @override
  String get helpSupportFaq7Q => 'Mi van, ha nem értek egyet egy olvasással?';

  @override
  String get helpSupportFaq7A =>
      'Az asztrológia értelmező, és nem minden olvasás fog rezonálni. Használj visszajelzési funkciót, hogy segíts nekünk fejlődni. Az AI-nk az idő múlásával tanul a preferenciáidból.';

  @override
  String get notificationsSaved => 'Értesítési beállítások mentve';

  @override
  String get notificationsTitle => 'Értesítések';

  @override
  String get notificationsSectionTitle => 'Push Értesítések';

  @override
  String get notificationsDailyTitle => 'Napi Útmutatás';

  @override
  String get notificationsDailySubtitle =>
      'Értesítést kapsz, amikor a napi útmutatásod készen áll';

  @override
  String get notificationsWeeklyTitle => 'Heti Főbb Események';

  @override
  String get notificationsWeeklySubtitle =>
      'Heti kozmikus áttekintés és kulcsfontosságú tranzitok';

  @override
  String get notificationsSpecialTitle => 'Különleges Események';

  @override
  String get notificationsSpecialSubtitle =>
      'Teliholdak, napfogyatkozások és retrográdok';

  @override
  String get notificationsDeviceHint =>
      'Az értesítéseket a készülék beállításaiban is vezérelheted.';

  @override
  String get concernsTitle => 'A Te Fókuszod';

  @override
  String get concernsSubtitle => 'Témák, amelyek formálják az útmutatásodat';

  @override
  String concernsTabActive(Object count) {
    return 'Aktív ($count)';
  }

  @override
  String concernsTabResolved(Object count) {
    return 'Megoldott ($count)';
  }

  @override
  String concernsTabArchived(Object count) {
    return 'Archív ($count)';
  }

  @override
  String get concernsEmptyTitle => 'Nincsenek aggodalmak itt';

  @override
  String get concernsEmptySubtitle =>
      'Adj hozzá egy fókusz témát, hogy személyre szabott útmutatást kapj';

  @override
  String get concernsCategoryCareer => 'Karrier és Munka';

  @override
  String get concernsCategoryHealth => 'Egészség';

  @override
  String get concernsCategoryRelationship => 'Kapcsolat';

  @override
  String get concernsCategoryFamily => 'Család';

  @override
  String get concernsCategoryMoney => 'Pénz';

  @override
  String get concernsCategoryBusiness => 'Üzlet';

  @override
  String get concernsCategoryPartnership => 'Partnerség';

  @override
  String get concernsCategoryGrowth => 'Személyes Fejlődés';

  @override
  String get concernsMinLength =>
      'Kérjük, írd le az aggodalmadat részletesebben (legalább 10 karakter)';

  @override
  String get concernsSubmitFailed =>
      'Nem sikerült benyújtani az aggodalmat. Kérjük, próbáld újra.';

  @override
  String get concernsAddTitle => 'Mi jár a fejedben?';

  @override
  String get concernsAddDescription =>
      'Oszd meg a jelenlegi aggodalmadat, kérdésedet vagy élethelyzetedet. Az AI-nk elemezni fogja, és fókuszált útmutatást ad holnaptól.';

  @override
  String get concernsExamplesTitle => 'A gondok példái:';

  @override
  String get concernsExampleCareer => 'Karrierváltás döntés';

  @override
  String get concernsExampleRelationship => 'Kapcsolati kihívások';

  @override
  String get concernsExampleFinance => 'Pénzügyi befektetés időzítése';

  @override
  String get concernsExampleHealth => 'Egészség és wellness fókusz';

  @override
  String get concernsExampleGrowth => 'Személyes fejlődés iránya';

  @override
  String get concernsSubmitButton => 'Agyalás Benyújtása';

  @override
  String get concernsSuccessTitle => 'Agyalás Rögzítve!';

  @override
  String get concernsCategoryLabel => 'Kategória: ';

  @override
  String get concernsSuccessMessage =>
      'Holnaptól a napi útmutatásod jobban fog fókuszálni erre a témára.';

  @override
  String get concernsViewFocusTopics => 'Nézd meg a Fókusz Témáimat';

  @override
  String get deleteAccountTitle => 'Fiók Törlése';

  @override
  String get deleteAccountHeading => 'Törölni szeretnéd a fiókodat?';

  @override
  String get deleteAccountConfirmError =>
      'Kérjük, írd be a DELETE-et a megerősítéshez';

  @override
  String get deleteAccountFinalWarningTitle => 'Végső Figyelmeztetés';

  @override
  String get deleteAccountFinalWarningBody =>
      'Ez a művelet nem vonható vissza. Minden adatod, beleértve:\n\n• A profilodat és születési adataidat\n• A születési térképedet és értelmezéseket\n• A napi útmutatás történetét\n• Személyes kontextust és preferenciákat\n• Minden megvásárolt tartalmat\n\nÖrökre törlésre kerül.';

  @override
  String get deleteAccountConfirmButton => 'Törlés Örökre';

  @override
  String get deleteAccountSuccess => 'A fiókod törölve lett';

  @override
  String get deleteAccountFailed =>
      'Nem sikerült törölni a fiókot. Kérjük, próbáld újra.';

  @override
  String get deleteAccountPermanentWarning =>
      'Ez a művelet végleges, és nem vonható vissza';

  @override
  String get deleteAccountWarningDetail =>
      'Minden személyes adatod, beleértve a születési térképedet, az útmutatás történetét és bármilyen vásárlást, véglegesen törlésre kerül.';

  @override
  String get deleteAccountWhatTitle => 'Mi fog törlődni:';

  @override
  String get deleteAccountItemProfile => 'A profilod és fiókod';

  @override
  String get deleteAccountItemBirthData =>
      'Születési adatok és születési térkép';

  @override
  String get deleteAccountItemGuidance => 'Minden napi útmutatás története';

  @override
  String get deleteAccountItemContext => 'Személyes kontextus és preferenciák';

  @override
  String get deleteAccountItemKarmic => 'Karmikus asztrológiai olvasások';

  @override
  String get deleteAccountItemPurchases => 'Minden megvásárolt tartalom';

  @override
  String get deleteAccountTypeDelete => 'Írd be a DELETE-et a megerősítéshez';

  @override
  String get deleteAccountDeleteHint => 'DELETE';

  @override
  String get deleteAccountButton => 'Fiókom Törlése';

  @override
  String get deleteAccountCancel => 'Mégse, tartsd meg a fiókomat';

  @override
  String get learnArticleLoadFailed => 'Nem sikerült betölteni a cikket';

  @override
  String get learnContentInEnglish => 'Tartalom angolul';

  @override
  String get learnArticlesLoadFailed => 'Nem sikerült betölteni a cikkeket';

  @override
  String get learnArticlesEmpty => 'Még nincsenek elérhető cikkek';

  @override
  String get learnContentFallback =>
      'Tartalom angolul (nem elérhető a nyelveden)';

  @override
  String get checkoutTitle => 'Pénztár';

  @override
  String get checkoutOrderSummary => 'Rendelés Összegzés';

  @override
  String get checkoutProTitle => 'Pro Születési Térkép';

  @override
  String get checkoutProSubtitle => 'Teljes bolygóértelmezések';

  @override
  String get checkoutTotalLabel => 'Összesen';

  @override
  String get checkoutTotalAmount => '\$9.99 USD';

  @override
  String get checkoutPaymentTitle => 'Fizetési Integráció';

  @override
  String get checkoutPaymentSubtitle =>
      'Az alkalmazáson belüli vásárlás integrációja folyamatban van. Kérjük, nézd meg később!';

  @override
  String get checkoutProcessing => 'Feldolgozás...';

  @override
  String get checkoutDemoPurchase => 'Demó vásárlás (Tesztelés)';

  @override
  String get checkoutSecurityNote =>
      'A fizetés biztonságosan történik az Apple/Google által. A kártyaadatok soha nem kerülnek tárolásra.';

  @override
  String get checkoutSuccess => '🎉 Pro Natal Chart sikeresen feloldva!';

  @override
  String get checkoutGenerateFailed =>
      'A magyarázatok generálása sikertelen. Kérjük, próbálja újra.';

  @override
  String checkoutErrorWithMessage(Object error) {
    return 'Hiba történt: $error';
  }

  @override
  String get billingUpgrade => 'Frissítés Prémiumra';

  @override
  String billingFeatureLocked(Object feature) {
    return '$feature egy Prémium funkció';
  }

  @override
  String get billingUpgradeBody =>
      'Frissítsen Prémiumra, hogy feloldja ezt a funkciót és a legszemélyre szabottabb útmutatást kapja.';

  @override
  String get contextReviewFailed =>
      'Frissítés sikertelen. Kérjük, próbálja újra.';

  @override
  String get contextReviewTitle => 'Ideje egy Gyors Ellenőrzésre';

  @override
  String get contextReviewBody =>
      '3 hónap telt el azóta, hogy utoljára frissítettük a személyes kontextusát. Változott valami fontos az életében, amit tudnunk kellene?';

  @override
  String get contextReviewHint =>
      'Ez segít nekünk abban, hogy személyre szabottabb útmutatást nyújtsunk.';

  @override
  String get contextReviewNoChanges => 'Nincs változás';

  @override
  String get contextReviewYesUpdate => 'Igen, frissítés';

  @override
  String get contextProfileLoadFailed => 'Profil betöltése sikertelen';

  @override
  String get contextCardTitle => 'Személyes Kontextus';

  @override
  String get contextCardSubtitle =>
      'Állítsa be a személyes kontextusát, hogy személyre szabottabb útmutatást kapjon.';

  @override
  String get contextCardSetupNow => 'Állítsa be most';

  @override
  String contextCardVersionUpdated(Object version, Object date) {
    return 'Verzió $version • Utoljára frissítve: $date';
  }

  @override
  String get contextCardAiSummary => 'AI Összefoglaló';

  @override
  String contextCardToneTag(Object tone) {
    return '$tone hangvétel';
  }

  @override
  String get contextCardSensitivityTag => 'érzékenység be';

  @override
  String get contextCardReviewDue =>
      'Felülvizsgálat esedékes - frissítse a kontextusát';

  @override
  String contextCardNextReview(Object days) {
    return 'Következő felülvizsgálat $days napon belül';
  }

  @override
  String get contextDeleteTitle => 'Személyes Kontextus törlése?';

  @override
  String get contextDeleteBody =>
      'Ez törli a személyes kontextus profilját. Az útmutatása kevésbé lesz személyre szabott.';

  @override
  String get contextDeleteFailed => 'Profil törlése sikertelen';

  @override
  String get appTitle => 'Belső Bölcsesség';

  @override
  String get concernsHintExample =>
      'Példa: Van egy állásajánlatom egy másik városban, és nem vagyok biztos benne, hogy el kellene-e fogadnom...';

  @override
  String get learnTitle => 'Tanulj Asztrológiát';

  @override
  String get learnFreeTitle => 'Ingyenes Tanulási Források';

  @override
  String get learnFreeSubtitle => 'Fedezze fel az asztrológia alapjait';

  @override
  String get learnSignsTitle => 'Jelek';

  @override
  String get learnSignsSubtitle => '12 Zodiákus jel és jelentésük';

  @override
  String get learnPlanetsTitle => 'Bolygók';

  @override
  String get learnPlanetsSubtitle => 'Égi testek az asztrológiában';

  @override
  String get learnHousesTitle => 'Házak';

  @override
  String get learnHousesSubtitle => '12 életterület a horoszkópjában';

  @override
  String get learnTransitsTitle => 'Átmenetek';

  @override
  String get learnTransitsSubtitle => 'Bolygómozgások és hatások';

  @override
  String get learnPaceTitle => 'Tanulj a Saját Tempódban';

  @override
  String get learnPaceSubtitle =>
      'Átfogó leckék az asztrológiai tudás elmélyítéséhez';

  @override
  String get proNatalTitle => 'Pro Natal Chart';

  @override
  String get proNatalHeroTitle => 'Mélységi Megértések Feloldása';

  @override
  String get proNatalHeroSubtitle =>
      'Kapjon átfogó, 150-200 szavas magyarázatokat minden bolygóhelyzetre a születési horoszkópjában.';

  @override
  String get proNatalFeature1Title => 'Mély Személyiség Megértések';

  @override
  String get proNatalFeature1Body =>
      'Értsd meg, hogyan formálja minden bolygó az egyedi személyiségedet és életutad.';

  @override
  String get proNatalFeature2Title => 'AI-vezérelt Elemzés';

  @override
  String get proNatalFeature2Body =>
      'Fejlett magyarázatok, amelyek a pontos bolygóhelyzeteidhez vannak igazítva.';

  @override
  String get proNatalFeature3Title => 'Használható Útmutatás';

  @override
  String get proNatalFeature3Body =>
      'Gyakorlati tanácsok karrierhez, kapcsolatokhoz és személyes fejlődéshez.';

  @override
  String get proNatalFeature4Title => 'Élethosszig Tartó Hozzáférés';

  @override
  String get proNatalFeature4Body =>
      'A magyarázataid örökre elmentésre kerülnek. Bármikor hozzáférhetsz.';

  @override
  String get proNatalOneTime => 'Egyszeri vásárlás';

  @override
  String get proNatalNoSubscription => 'Előfizetés nem szükséges';
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get onboardingSkip => 'Pomiń';

  @override
  String get onboardingTitle1 => 'Witamy w Inner Wisdom Astro';

  @override
  String get onboardingDesc1 =>
      'Innerwisdom Astro łączy ponad 30-letnie doświadczenie astrologiczne Madi G. z mocą zaawansowanej sztucznej inteligencji, tworząc jedną z najbardziej dopracowanych i wydajnych aplikacji astrologicznych dostępnych dzisiaj.\n\nŁącząc głęboką ludzką intuicję z inteligentną technologią, Innerwisdom Astro dostarcza interpretacje, które są precyzyjne, spersonalizowane i znaczące, wspierając użytkowników w ich drodze do samopoznania, jasności i świadomego rozwoju.';

  @override
  String get onboardingTitle2 => 'Twoja Pełna Astrologiczna Podróż';

  @override
  String get onboardingDesc2 =>
      'Od spersonalizowanych codziennych wskazówek po Twój Natalny Horoskop, Astrologię Karmiczną, szczegółowe raporty osobowości, Kompatybilność w Miłości i Przyjaźni, Romantyczne Prognozy dla Par i wiele więcej — wszystko jest teraz na wyciągnięcie ręki.\n\nZaprojektowane, aby wspierać jasność, połączenie i zrozumienie siebie, Innerwisdom Astro oferuje kompletną astrologiczną doświadczenie, dostosowane do Ciebie.';

  @override
  String get onboardingNext => 'Dalej';

  @override
  String get onboardingGetStarted => 'Rozpocznij';

  @override
  String get onboardingAlreadyHaveAccount => 'Masz już konto? Zaloguj się';

  @override
  String get birthDataTitle => 'Twój Horoskop';

  @override
  String get birthDataSubtitle =>
      'Potrzebujemy Twoich danych urodzeniowych, aby stworzyć\nTwój spersonalizowany profil astrologiczny';

  @override
  String get birthDateLabel => 'Data Urodzenia';

  @override
  String get birthDateSelectHint => 'Wybierz swoją datę urodzenia';

  @override
  String get birthTimeLabel => 'Godzina Urodzenia';

  @override
  String get birthTimeUnknown => 'Nieznana';

  @override
  String get birthTimeSelectHint => 'Wybierz swoją godzinę urodzenia';

  @override
  String get birthTimeUnknownCheckbox => 'Nie znam dokładnej godziny urodzenia';

  @override
  String get birthPlaceLabel => 'Miejsce Urodzenia';

  @override
  String get birthPlaceHint => 'Zacznij wpisywać nazwę miasta...';

  @override
  String get birthPlaceValidation => 'Proszę wybrać lokalizację z sugestii';

  @override
  String birthPlaceSelected(Object location) {
    return 'Wybrane: $location';
  }

  @override
  String get genderLabel => 'Płeć';

  @override
  String get genderMale => 'Mężczyzna';

  @override
  String get genderFemale => 'Kobieta';

  @override
  String get genderPreferNotToSay => 'Wolę nie mówić';

  @override
  String get birthDataSubmit => 'Generuj Mój Horoskop';

  @override
  String get birthDataPrivacyNote =>
      'Twoje dane urodzeniowe są używane tylko do obliczenia Twojego\nhoroskopu i są przechowywane w bezpieczny sposób.';

  @override
  String get birthDateMissing => 'Proszę wybrać datę urodzenia';

  @override
  String get birthPlaceMissing => 'Proszę wybrać miejsce urodzenia z sugestii';

  @override
  String get birthDataSaveError =>
      'Nie można zapisać danych urodzeniowych. Proszę spróbować ponownie.';

  @override
  String get appearanceTitle => 'Wygląd';

  @override
  String get appearanceTheme => 'Motyw';

  @override
  String get appearanceDarkTitle => 'Ciemny';

  @override
  String get appearanceDarkSubtitle => 'Łatwy dla oczu w słabym świetle';

  @override
  String get appearanceLightTitle => 'Jasny';

  @override
  String get appearanceLightSubtitle => 'Klasyczny jasny wygląd';

  @override
  String get appearanceSystemTitle => 'System';

  @override
  String get appearanceSystemSubtitle => 'Dopasuj do ustawień urządzenia';

  @override
  String get appearancePreviewTitle => 'Podgląd';

  @override
  String get appearancePreviewBody =>
      'Kosmiczny motyw jest zaprojektowany, aby stworzyć immersyjne doświadczenie astrologiczne. Ciemny motyw jest zalecany dla najlepszego doświadczenia wizualnego.';

  @override
  String appearanceThemeChanged(Object theme) {
    return 'Motyw zmieniony na $theme';
  }

  @override
  String get profileUserFallback => 'Użytkownik';

  @override
  String get profilePersonalContext => 'Osobisty Kontekst';

  @override
  String get profileSettings => 'Ustawienia';

  @override
  String get profileAppLanguage => 'Język Aplikacji';

  @override
  String get profileContentLanguage => 'Język Treści';

  @override
  String get profileContentLanguageHint =>
      'Treści AI używają wybranego języka.';

  @override
  String get profileNotifications => 'Powiadomienia';

  @override
  String get profileNotificationsEnabled => 'Włączone';

  @override
  String get profileNotificationsDisabled => 'Wyłączone';

  @override
  String get profileAppearance => 'Wygląd';

  @override
  String get profileHelpSupport => 'Pomoc i Wsparcie';

  @override
  String get profilePrivacyPolicy => 'Polityka Prywatności';

  @override
  String get profileTermsOfService => 'Warunki Usługi';

  @override
  String get profileLogout => 'Wyloguj się';

  @override
  String get profileLogoutConfirm => 'Czy na pewno chcesz się wylogować?';

  @override
  String get profileDeleteAccount => 'Usuń Konto';

  @override
  String get commonCancel => 'Anuluj';

  @override
  String get profileSelectLanguageTitle => 'Wybierz Język';

  @override
  String get profileSelectLanguageSubtitle =>
      'Wszystkie treści generowane przez AI będą w wybranym języku.';

  @override
  String profileLanguageUpdated(Object language) {
    return 'Język zaktualizowany na $language';
  }

  @override
  String profileLanguageUpdateFailed(Object error) {
    return 'Nie udało się zaktualizować języka: $error';
  }

  @override
  String profileVersion(Object version) {
    return 'Inner Wisdom v$version';
  }

  @override
  String get profileCosmicBlueprint => 'Twój Kosmiczny Plan';

  @override
  String get profileSunLabel => '☀️ Słońce';

  @override
  String get profileMoonLabel => '🌙 Księżyc';

  @override
  String get profileRisingLabel => '⬆️ Wschodzący';

  @override
  String get profileUnknown => 'Nieznane';

  @override
  String get forgotPasswordTitle => 'Zapomniałeś Hasła?';

  @override
  String get forgotPasswordSubtitle =>
      'Wprowadź swój e-mail, a wyślemy Ci kod do zresetowania hasła';

  @override
  String get forgotPasswordSent =>
      'Jeśli konto istnieje, kod resetujący został wysłany na Twój e-mail.';

  @override
  String get forgotPasswordFailed =>
      'Nie udało się wysłać kodu resetującego. Proszę spróbować ponownie.';

  @override
  String get forgotPasswordSendCode => 'Wyślij Kod Resetujący';

  @override
  String get forgotPasswordHaveCode => 'Masz już kod?';

  @override
  String get forgotPasswordRemember => 'Pamiętasz swoje hasło? ';

  @override
  String get loginWelcomeBack => 'Witamy z powrotem';

  @override
  String get loginSubtitle =>
      'Zaloguj się, aby kontynuować swoją kosmiczną podróż';

  @override
  String get loginInvalidCredentials => 'Nieprawidłowy e-mail lub hasło';

  @override
  String get loginGoogleFailed =>
      'Logowanie przez Google nie powiodło się. Proszę spróbować ponownie.';

  @override
  String get loginAppleFailed =>
      'Logowanie przez Apple nie powiodło się. Proszę spróbować ponownie.';

  @override
  String get loginNetworkError => 'Błąd sieci. Proszę sprawdzić połączenie.';

  @override
  String get loginSignInCancelled => 'Logowanie zostało anulowane.';

  @override
  String get loginPasswordHint => 'Wprowadź swoje hasło';

  @override
  String get loginForgotPassword => 'Zapomniałeś Hasła?';

  @override
  String get loginSignIn => 'Zaloguj się';

  @override
  String get loginNoAccount => 'Nie masz konta? ';

  @override
  String get loginSignUp => 'Zarejestruj się';

  @override
  String get commonEmailLabel => 'E-mail';

  @override
  String get commonEmailHint => 'Wprowadź swój e-mail';

  @override
  String get commonEmailRequired => 'Proszę wprowadzić swój e-mail';

  @override
  String get commonEmailInvalid => 'Proszę wprowadzić prawidłowy e-mail';

  @override
  String get commonPasswordLabel => 'Hasło';

  @override
  String get commonPasswordRequired => 'Proszę wprowadzić swoje hasło';

  @override
  String get commonOrContinueWith => 'lub kontynuuj z';

  @override
  String get commonGoogle => 'Google';

  @override
  String get commonApple => 'Apple';

  @override
  String get commonNameLabel => 'Imię';

  @override
  String get commonNameHint => 'Wprowadź swoje imię';

  @override
  String get commonNameRequired => 'Proszę wprowadzić swoje imię';

  @override
  String get signupTitle => 'Utwórz Konto';

  @override
  String get signupSubtitle =>
      'Rozpocznij swoją kosmiczną podróż z Inner Wisdom';

  @override
  String get signupEmailExists => 'Email już istnieje lub nieprawidłowe dane';

  @override
  String get signupGoogleFailed =>
      'Logowanie przez Google nie powiodło się. Proszę spróbować ponownie.';

  @override
  String get signupAppleFailed =>
      'Logowanie przez Apple nie powiodło się. Proszę spróbować ponownie.';

  @override
  String get signupPasswordHint => 'Utwórz hasło (min. 8 znaków)';

  @override
  String get signupPasswordMin => 'Hasło musi mieć co najmniej 8 znaków';

  @override
  String get signupConfirmPasswordLabel => 'Potwierdź hasło';

  @override
  String get signupConfirmPasswordHint => 'Potwierdź swoje hasło';

  @override
  String get signupConfirmPasswordRequired => 'Proszę potwierdzić swoje hasło';

  @override
  String get signupPasswordMismatch => 'Hasła nie pasują do siebie';

  @override
  String get signupPreferredLanguage => 'Preferowany język';

  @override
  String get signupCreateAccount => 'Utwórz konto';

  @override
  String get signupHaveAccount => 'Masz już konto? ';

  @override
  String get resetPasswordTitle => 'Zresetuj hasło';

  @override
  String get resetPasswordSubtitle =>
      'Wprowadź kod wysłany na Twój email i ustaw nowe hasło';

  @override
  String get resetPasswordSuccess =>
      'Resetowanie hasła zakończone sukcesem! Przekierowywanie do logowania...';

  @override
  String get resetPasswordFailed =>
      'Nie udało się zresetować hasła. Proszę spróbować ponownie.';

  @override
  String get resetPasswordInvalidCode =>
      'Nieprawidłowy lub wygasły kod resetowania. Proszę poprosić o nowy.';

  @override
  String get resetPasswordMaxAttempts =>
      'Przekroczono maksymalną liczbę prób. Proszę poprosić o nowy kod.';

  @override
  String get resetCodeLabel => 'Kod resetowania';

  @override
  String get resetCodeHint => 'Wprowadź 6-cyfrowy kod';

  @override
  String get resetCodeRequired => 'Proszę wprowadzić kod resetowania';

  @override
  String get resetCodeLength => 'Kod musi mieć 6 cyfr';

  @override
  String get resetNewPasswordLabel => 'Nowe hasło';

  @override
  String get resetNewPasswordHint => 'Utwórz nowe hasło (min. 8 znaków)';

  @override
  String get resetNewPasswordRequired => 'Proszę wprowadzić nowe hasło';

  @override
  String get resetConfirmPasswordHint => 'Potwierdź swoje nowe hasło';

  @override
  String get resetPasswordButton => 'Zresetuj hasło';

  @override
  String get resetRequestNewCode => 'Poproś o nowy kod';

  @override
  String get serviceResultGenerated => 'Raport wygenerowany';

  @override
  String serviceResultReady(Object title) {
    return 'Twój spersonalizowany $title jest gotowy';
  }

  @override
  String get serviceResultBackToForYou => 'Powrót do Dla Ciebie';

  @override
  String get serviceResultNotSavedNotice =>
      'Ten raport nie zostanie zapisany. Jeśli chcesz, możesz go skopiować i zapisać gdzie indziej, korzystając z funkcji Kopiuj.';

  @override
  String get commonCopy => 'Kopiuj';

  @override
  String get commonCopied => 'Skopiowano do schowka';

  @override
  String get commonContinue => 'Kontynuuj';

  @override
  String get partnerDetailsTitle => 'Szczegóły partnera';

  @override
  String get partnerBirthDataTitle => 'Wprowadź dane urodzenia partnera';

  @override
  String partnerBirthDataFor(Object title) {
    return 'Dla \"$title\"';
  }

  @override
  String get partnerNameOptionalLabel => 'Imię (opcjonalnie)';

  @override
  String get partnerNameHint => 'Imię partnera';

  @override
  String get partnerGenderOptionalLabel => 'Płeć (opcjonalnie)';

  @override
  String get partnerBirthDateLabel => 'Data urodzenia *';

  @override
  String get partnerBirthDateSelect => 'Wybierz datę urodzenia';

  @override
  String get partnerBirthDateMissing => 'Proszę wybrać datę urodzenia';

  @override
  String get partnerBirthTimeOptionalLabel => 'Czas urodzenia (opcjonalnie)';

  @override
  String get partnerBirthTimeSelect => 'Wybierz czas urodzenia';

  @override
  String get partnerBirthPlaceLabel => 'Miejsce urodzenia *';

  @override
  String get serviceOfferRequiresPartner => 'Wymaga danych urodzenia partnera';

  @override
  String get serviceOfferBetaFree => 'Testerzy beta otrzymują darmowy dostęp!';

  @override
  String get serviceOfferUnlocked => 'Odblokowane';

  @override
  String get serviceOfferGenerate => 'Generuj raport';

  @override
  String serviceOfferUnlockFor(Object price) {
    return 'Odblokuj za $price';
  }

  @override
  String get serviceOfferPreparing =>
      'Przygotowujemy Twój spersonalizowany raport…';

  @override
  String get serviceOfferTimeout =>
      'Zajmuje więcej czasu niż oczekiwano. Proszę spróbować ponownie.';

  @override
  String get serviceOfferNotReady =>
      'Raport jeszcze nie gotowy. Proszę spróbować ponownie.';

  @override
  String serviceOfferFetchFailed(Object error) {
    return 'Nie udało się pobrać raportu: $error';
  }

  @override
  String get commonFree => 'DARMOWE';

  @override
  String get commonLater => 'Później';

  @override
  String get commonRetry => 'Spróbuj ponownie';

  @override
  String get commonYes => 'Tak';

  @override
  String get commonNo => 'Nie';

  @override
  String get commonBack => 'Wstecz';

  @override
  String get commonOptional => 'Opcjonalnie';

  @override
  String get commonNotSpecified => 'Nie określono';

  @override
  String get commonJustNow => 'Przed chwilą';

  @override
  String get commonViewMore => 'Zobacz więcej';

  @override
  String get commonViewLess => 'Zobacz mniej';

  @override
  String commonMinutesAgo(Object count) {
    return '$count min temu';
  }

  @override
  String commonHoursAgo(Object count) {
    return '${count}h temu';
  }

  @override
  String commonDaysAgo(Object count) {
    return '${count}d temu';
  }

  @override
  String commonDateShort(Object day, Object month, Object year) {
    return '$day/$month/$year';
  }

  @override
  String get askGuideTitle => 'Zapytaj swojego przewodnika';

  @override
  String get askGuideSubtitle => 'Osobiste kosmiczne wskazówki';

  @override
  String askGuideRemaining(Object count) {
    return '$count pozostało';
  }

  @override
  String get askGuideQuestionHint =>
      'Zapytaj o cokolwiek - miłość, kariera, decyzje, emocje...';

  @override
  String get askGuideBasedOnChart =>
      'Na podstawie Twojego wykresu urodzeniowego i dzisiejszych kosmicznych energii';

  @override
  String get askGuideThinking => 'Twój przewodnik myśli...';

  @override
  String get askGuideYourGuide => 'Twój przewodnik';

  @override
  String get askGuideEmptyTitle => 'Zadaj swoje pierwsze pytanie';

  @override
  String get askGuideEmptyBody =>
      'Uzyskaj natychmiastowe, głęboko osobiste wskazówki na podstawie swojego wykresu urodzeniowego i dzisiejszych kosmicznych energii.';

  @override
  String get askGuideEmptyHint =>
      'Zapytaj o cokolwiek — miłość, kariera, decyzje, emocje.';

  @override
  String get askGuideLoadFailed => 'Nie udało się załadować danych';

  @override
  String askGuideSendFailed(Object error) {
    return 'Nie udało się wysłać pytania: $error';
  }

  @override
  String get askGuideLimitTitle => 'Osiągnięto miesięczny limit';

  @override
  String get askGuideLimitBody => 'Osiągnąłeś swój miesięczny limit zapytań.';

  @override
  String get askGuideLimitAddon =>
      'Możesz zakupić dodatek za 1,99 USD, aby kontynuować korzystanie z tej usługi przez resztę bieżącego miesiąca rozliczeniowego.';

  @override
  String askGuideLimitBillingEnd(Object date) {
    return 'Twój miesiąc rozliczeniowy kończy się: $date';
  }

  @override
  String get askGuideLimitGetAddon => 'Pobierz dodatek';

  @override
  String get contextTitle => 'Osobisty kontekst';

  @override
  String contextStepOf(Object current, Object total) {
    return 'Krok $current z $total';
  }

  @override
  String get contextStep1Title => 'Ludzie wokół Ciebie';

  @override
  String get contextStep1Subtitle =>
      'Twój kontekst relacji i rodziny pomaga nam zrozumieć Twoje emocjonalne otoczenie.';

  @override
  String get contextStep2Title => 'Życie zawodowe';

  @override
  String get contextStep2Subtitle =>
      'Twoja praca i codzienny rytm kształtują to, jak doświadczasz presji, wzrostu i celu.';

  @override
  String get contextStep3Title => 'Jak życie wygląda teraz';

  @override
  String get contextStep3Subtitle =>
      'Nie ma dobrych ani złych odpowiedzi, tylko Twoja obecna rzeczywistość';

  @override
  String get contextStep4Title => 'Co jest dla Ciebie najważniejsze';

  @override
  String get contextStep4Subtitle =>
      'Aby Twoje wskazówki były zgodne z tym, co naprawdę Cię interesuje';

  @override
  String get contextPriorityRequired =>
      'Proszę wybrać przynajmniej jeden obszar priorytetowy.';

  @override
  String contextSaveFailed(Object error) {
    return 'Nie udało się zapisać profilu: $error';
  }

  @override
  String get contextSaveContinue => 'Zapisz i kontynuuj';

  @override
  String get contextRelationshipStatusTitle => 'Aktualny status związku';

  @override
  String get contextSeekingRelationshipTitle => 'Czy szukasz związku?';

  @override
  String get contextHasChildrenTitle => 'Czy masz dzieci?';

  @override
  String get contextChildrenDetailsOptional =>
      'Szczegóły dotyczące dzieci (opcjonalnie)';

  @override
  String get contextAddChild => 'Dodaj dziecko';

  @override
  String get contextChildAgeLabel => 'Wiek';

  @override
  String contextChildAgeYears(num age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other: 'lata',
      one: 'rok',
    );
    return '$age $_temp0';
  }

  @override
  String get contextChildGenderLabel => 'Płeć';

  @override
  String get contextRelationshipSingle => 'Singiel';

  @override
  String get contextRelationshipInRelationship => 'W związku';

  @override
  String get contextRelationshipMarried => 'Żonaty / Związek cywilny';

  @override
  String get contextRelationshipSeparated => 'Rozwiedziony / Separacja';

  @override
  String get contextRelationshipWidowed => 'Wdowiec/Wdowa';

  @override
  String get contextRelationshipPreferNotToSay => 'Wolę nie mówić';

  @override
  String get contextProfessionalStatusTitle => 'Aktualny status zawodowy';

  @override
  String get contextProfessionalStatusOtherHint =>
      'Proszę określić swój status pracy';

  @override
  String get contextIndustryTitle => 'Główna branża/dziedzina';

  @override
  String get contextWorkStatusStudent => 'Student';

  @override
  String get contextWorkStatusUnemployed => 'Bezrobotny / Między pracami';

  @override
  String get contextWorkStatusEmployedIc => 'Zatrudniony (wkład indywidualny)';

  @override
  String get contextWorkStatusEmployedManagement => 'Zatrudniony (zarząd)';

  @override
  String get contextWorkStatusExecutive =>
      'Wykonawczy / Kierowniczy (poziom C)';

  @override
  String get contextWorkStatusSelfEmployed => 'Własna działalność / Freelancer';

  @override
  String get contextWorkStatusEntrepreneur =>
      'Przedsiębiorca / Właściciel firmy';

  @override
  String get contextWorkStatusInvestor => 'Inwestor';

  @override
  String get contextWorkStatusRetired => 'Na emeryturze';

  @override
  String get contextWorkStatusHomemaker =>
      'Gospodyni domowa / Rodzic pozostający w domu';

  @override
  String get contextWorkStatusCareerBreak =>
      'Przerwa w karierze / Urlop naukowy';

  @override
  String get contextWorkStatusOther => 'Inne';

  @override
  String get contextIndustryTech => 'Technologia / IT';

  @override
  String get contextIndustryFinance => 'Finanse / Inwestycje';

  @override
  String get contextIndustryHealthcare => 'Opieka zdrowotna';

  @override
  String get contextIndustryEducation => 'Edukacja';

  @override
  String get contextIndustrySalesMarketing => 'Sprzedaż / Marketing';

  @override
  String get contextIndustryRealEstate => 'Nieruchomości';

  @override
  String get contextIndustryHospitality => 'Gościnność';

  @override
  String get contextIndustryGovernment => 'Rząd / Sektor publiczny';

  @override
  String get contextIndustryCreative => 'Branże kreatywne';

  @override
  String get contextIndustryOther => 'Inne';

  @override
  String get contextSelfAssessmentIntro =>
      'Oceń swoją obecną sytuację w każdej dziedzinie (1 = trudności, 5 = doskonałość)';

  @override
  String get contextSelfHealthTitle => 'Zdrowie i energia';

  @override
  String get contextSelfHealthSubtitle =>
      '1 = poważne problemy/niska energia, 5 = doskonała witalność';

  @override
  String get contextSelfSocialTitle => 'Życie towarzyskie';

  @override
  String get contextSelfSocialSubtitle =>
      '1 = izolacja, 5 = rozwinięte połączenia społeczne';

  @override
  String get contextSelfRomanceTitle => 'Życie romantyczne';

  @override
  String get contextSelfRomanceSubtitle => '1 = brak/trudności, 5 = spełnienie';

  @override
  String get contextSelfFinanceTitle => 'Stabilność finansowa';

  @override
  String get contextSelfFinanceSubtitle =>
      '1 = poważne trudności, 5 = doskonałe';

  @override
  String get contextSelfCareerTitle => 'Satysfakcja z kariery';

  @override
  String get contextSelfCareerSubtitle =>
      '1 = utknąłem/zestresowany, 5 = postęp/jasność';

  @override
  String get contextSelfGrowthTitle => 'Zainteresowanie osobistym rozwojem';

  @override
  String get contextSelfGrowthSubtitle =>
      '1 = niskie zainteresowanie, 5 = bardzo wysokie';

  @override
  String get contextSelfStruggling => 'Zmagający się';

  @override
  String get contextSelfThriving => 'Rozkwitający';

  @override
  String get contextPrioritiesTitle =>
      'Jakie są twoje najważniejsze priorytety w tej chwili?';

  @override
  String get contextPrioritiesSubtitle =>
      'Wybierz do 2 obszarów, na których chcesz się skupić';

  @override
  String get contextGuidanceStyleTitle => 'Preferowany styl prowadzenia';

  @override
  String get contextSensitivityTitle => 'Tryb wrażliwości';

  @override
  String get contextSensitivitySubtitle =>
      'Unikaj sformułowań wywołujących lęk lub deterministycznych w prowadzeniu';

  @override
  String get contextPriorityHealth => 'Zdrowie i nawyki';

  @override
  String get contextPriorityCareer => 'Rozwój kariery';

  @override
  String get contextPriorityBusiness => 'Decyzje biznesowe';

  @override
  String get contextPriorityMoney => 'Pieniądze i stabilność';

  @override
  String get contextPriorityLove => 'Miłość i związek';

  @override
  String get contextPriorityFamily => 'Rodzina i rodzicielstwo';

  @override
  String get contextPrioritySocial => 'Życie towarzyskie';

  @override
  String get contextPriorityGrowth => 'Osobisty rozwój / nastawienie';

  @override
  String get contextGuidanceStyleDirect => 'Bezpośredni i praktyczny';

  @override
  String get contextGuidanceStyleDirectDesc =>
      'Przejdź od razu do praktycznych porad';

  @override
  String get contextGuidanceStyleEmpathetic => 'Empatyczny i refleksyjny';

  @override
  String get contextGuidanceStyleEmpatheticDesc =>
      'Ciepłe, wspierające prowadzenie';

  @override
  String get contextGuidanceStyleBalanced => 'Zrównoważony';

  @override
  String get contextGuidanceStyleBalancedDesc =>
      'Mieszanka wsparcia praktycznego i emocjonalnego';

  @override
  String get homeGuidancePreparing =>
      'Czytanie gwiazd i pytanie Wszechświata o ciebie…';

  @override
  String get homeGuidanceFailed =>
      'Nie udało się wygenerować prowadzenia. Proszę spróbować ponownie.';

  @override
  String get homeGuidanceTimeout =>
      'Zajmuje więcej czasu niż oczekiwano. Naciśnij Ponów lub sprawdź za chwilę.';

  @override
  String get homeGuidanceLoadFailed => 'Nie udało się załadować prowadzenia';

  @override
  String get homeTodaysGuidance => 'Dzisiejsze prowadzenie';

  @override
  String get homeSeeAll => 'Zobacz wszystko';

  @override
  String get homeHealth => 'Zdrowie';

  @override
  String get homeCareer => 'Kariera';

  @override
  String get homeMoney => 'Pieniądze';

  @override
  String get homeLove => 'Miłość';

  @override
  String get homePartners => 'Partnerzy';

  @override
  String get homeGrowth => 'Rozwój';

  @override
  String get homeTraveler => 'Podróżnik';

  @override
  String homeGreeting(Object name) {
    return 'Cześć, $name';
  }

  @override
  String get homeFocusFallback => 'Osobisty rozwój';

  @override
  String get homeDailyMessage => 'Twoja codzienna wiadomość';

  @override
  String get homeNatalChartTitle => 'Moja mapa urodzeniowa';

  @override
  String get homeNatalChartSubtitle =>
      'Zbadaj swoją mapę urodzeniową i interpretacje';

  @override
  String get navHome => 'Strona główna';

  @override
  String get navHistory => 'Historia';

  @override
  String get navGuide => 'Przewodnik';

  @override
  String get navProfile => 'Profil';

  @override
  String get navForYou => 'Dla Ciebie';

  @override
  String get commonToday => 'Dziś';

  @override
  String get commonTryAgain => 'Spróbuj ponownie';

  @override
  String get natalChartTitle => 'Moja mapa urodzeniowa';

  @override
  String get natalChartTabTable => 'Tabela';

  @override
  String get natalChartTabChart => 'Wykres';

  @override
  String get natalChartEmptyTitle => 'Brak danych wykresu natalnego';

  @override
  String get natalChartEmptySubtitle =>
      'Proszę uzupełnić dane urodzenia, aby zobaczyć swój wykres natalny.';

  @override
  String get natalChartAddBirthData => 'Dodaj dane urodzenia';

  @override
  String get natalChartErrorTitle => 'Nie można załadować wykresu';

  @override
  String get guidanceTitle => 'Codzienne Wskazówki';

  @override
  String get guidanceLoadFailed => 'Nie udało się załadować wskazówek';

  @override
  String get guidanceNoneAvailable => 'Brak dostępnych wskazówek';

  @override
  String get guidanceCosmicEnergyTitle => 'Dzisiejsza Energia Kosmiczna';

  @override
  String get guidanceMoodLabel => 'Nastrój';

  @override
  String get guidanceFocusLabel => 'Skupienie';

  @override
  String get guidanceYourGuidance => 'Twoje Wskazówki';

  @override
  String get guidanceTapToCollapse => 'Stuknij, aby zwinąć';

  @override
  String get historyTitle => 'Historia Wskazówek';

  @override
  String get historySubtitle => 'Twoja kosmiczna podróż przez czas';

  @override
  String get historyLoadFailed => 'Nie udało się załadować historii';

  @override
  String get historyEmptyTitle => 'Brak historii';

  @override
  String get historyEmptySubtitle =>
      'Twoje codzienne wskazówki pojawią się tutaj';

  @override
  String get historyNewBadge => 'NOWE';

  @override
  String get commonUnlocked => 'Odblokowane';

  @override
  String get commonComingSoon => 'Wkrótce';

  @override
  String get commonSomethingWentWrong => 'Coś poszło nie tak';

  @override
  String get commonNoContent => 'Brak dostępnych treści.';

  @override
  String get commonUnknownError => 'Nieznany błąd';

  @override
  String get commonTakingLonger =>
      'Zajmuje więcej czasu niż oczekiwano. Proszę spróbować ponownie.';

  @override
  String commonErrorWithMessage(Object error) {
    return 'Błąd: $error';
  }

  @override
  String get forYouTitle => 'Dla Ciebie';

  @override
  String get forYouSubtitle => 'Spersonalizowane kosmiczne wglądy';

  @override
  String get forYouNatalChartTitle => 'Mój Wykres Natalny';

  @override
  String get forYouNatalChartSubtitle =>
      'Analiza twojego wykresu urodzeniowego';

  @override
  String get forYouCompatibilitiesTitle => 'Kompatybilności';

  @override
  String get forYouCompatibilitiesSubtitle =>
      'Raporty o miłości, przyjaźni i partnerstwie';

  @override
  String get forYouKarmicTitle => 'Astrologia Karmiczna';

  @override
  String get forYouKarmicSubtitle => 'Lekcje duszy i wzorce z poprzednich żyć';

  @override
  String get forYouLearnTitle => 'Ucz się Astrologii';

  @override
  String get forYouLearnSubtitle => 'Darmowe materiały edukacyjne';

  @override
  String get compatibilitiesTitle => 'Kompatybilności';

  @override
  String get compatibilitiesLoadFailed => 'Nie udało się załadować usług';

  @override
  String get compatibilitiesBetaFree => 'Beta: Wszystkie raporty są DARMOWE!';

  @override
  String get compatibilitiesChooseReport => 'Wybierz Raport';

  @override
  String get compatibilitiesSubtitle =>
      'Odkryj wglądy o sobie i swoich relacjach';

  @override
  String get compatibilitiesPartnerBadge => '+Partner';

  @override
  String get compatibilitiesPersonalityTitle => 'Raport Osobowości';

  @override
  String get compatibilitiesPersonalitySubtitle =>
      'Kompleksowa analiza twojej osobowości na podstawie twojego wykresu natalnego';

  @override
  String get compatibilitiesRomanticPersonalityTitle =>
      'Raport Osobowości Romantycznej';

  @override
  String get compatibilitiesRomanticPersonalitySubtitle =>
      'Zrozum, jak podchodzisz do miłości i romansu';

  @override
  String get compatibilitiesLoveCompatibilityTitle => 'Kompatybilność Miłosna';

  @override
  String get compatibilitiesLoveCompatibilitySubtitle =>
      'Szczegółowa analiza romantycznej kompatybilności z twoim partnerem';

  @override
  String get compatibilitiesRomanticForecastTitle =>
      'Prognoza Romantyczna dla Par';

  @override
  String get compatibilitiesRomanticForecastSubtitle =>
      'Wglądy w przyszłość twojego związku';

  @override
  String get compatibilitiesFriendshipTitle => 'Raport Przyjaźni';

  @override
  String get compatibilitiesFriendshipSubtitle =>
      'Analiza dynamiki przyjaźni i kompatybilności';

  @override
  String get moonPhaseTitle => 'Raport Fazy Księżyca';

  @override
  String get moonPhaseSubtitle =>
      'Zrozum aktualną energię księżycową i jak na ciebie wpływa. Uzyskaj wskazówki zgodne z fazą księżyca.';

  @override
  String get moonPhaseSelectDate => 'Wybierz Datę';

  @override
  String get moonPhaseOriginalPrice => '\$2.99';

  @override
  String get moonPhaseGenerate => 'Generuj Raport';

  @override
  String get moonPhaseGenerateDifferentDate => 'Generuj dla Innej Daty';

  @override
  String get moonPhaseGenerationFailed => 'Generowanie nie powiodło się';

  @override
  String get moonPhaseGenerating =>
      'Raport jest generowany. Proszę spróbować ponownie.';

  @override
  String get moonPhaseUnknownError =>
      'Coś poszło nie tak. Proszę spróbować ponownie.';

  @override
  String get requiredFieldsNote => 'Pola oznaczone * są wymagane.';

  @override
  String get karmicTitle => 'Astrologia Karmiczna';

  @override
  String karmicLoadFailed(Object error) {
    return 'Nie udało się załadować: $error';
  }

  @override
  String get karmicOfferTitle => '🔮 Astrologia Karmiczna – Wiadomości Duszy';

  @override
  String get karmicOfferBody =>
      'Astrologia Karmiczna ujawnia głębokie wzorce kształtujące twoje życie, wykraczające poza codzienne wydarzenia.\n\nOferuje interpretację, która mówi o nierozwiązanych lekcjach, karmicznych połączeniach i ścieżce wzrostu duszy.\n\nTo nie chodzi o to, co będzie dalej,\nale o to, dlaczego doświadczasz tego, co przeżywasz.\n\n✨ Aktywuj Astrologię Karmiczną i odkryj głębsze znaczenie swojej podróży.';

  @override
  String get karmicBetaFreeBadge => 'Beta Testerzy – DARMOWY Dostęp!';

  @override
  String karmicPriceBeta(Object price) {
    return '\$$price – DARMOWE dla Beta Testerów';
  }

  @override
  String karmicPriceUnlock(Object price) {
    return 'Odblokuj za \$$price';
  }

  @override
  String get karmicHintInstant =>
      'Twoje odczytanie zostanie wygenerowane natychmiast';

  @override
  String get karmicHintOneTime => 'Jednorazowy zakup, bez subskrypcji';

  @override
  String get karmicProgressHint => 'Łączenie z twoją karmiczną ścieżką…';

  @override
  String karmicGenerateFailed(Object error) {
    return 'Nie udało się wygenerować: $error';
  }

  @override
  String get karmicCheckoutTitle => 'Zakupy Astrologii Karmicznej';

  @override
  String get karmicCheckoutSubtitle => 'Proces zakupu wkrótce';

  @override
  String karmicGenerationFailed(Object error) {
    return 'Generowanie nie powiodło się: $error';
  }

  @override
  String get karmicLoading => 'Ładowanie twojego odczytania karmicznego...';

  @override
  String get karmicGenerationFailedShort => 'Generowanie nie powiodło się';

  @override
  String get karmicGeneratingTitle =>
      'Generowanie Twojego Odczytania Karmicznego...';

  @override
  String get karmicGeneratingSubtitle =>
      'Analizowanie twojego wykresu natalnego w poszukiwaniu wzorców karmicznych i lekcji duszy.';

  @override
  String get karmicReadingTitle => '🔮 Twoje Odczytanie Karmiczne';

  @override
  String get karmicReadingSubtitle => 'Wiadomości Duszy';

  @override
  String get karmicDisclaimer =>
      'To odczytanie jest przeznaczone do refleksji i celów rozrywkowych. Nie stanowi profesjonalnej porady.';

  @override
  String get commonActive => 'Aktywny';

  @override
  String get commonBackToHome => 'Powrót do Strony Głównej';

  @override
  String get commonYesterday => 'wczoraj';

  @override
  String commonWeeksAgo(Object count) {
    return '$count tygodnie temu';
  }

  @override
  String commonMonthsAgo(Object count) {
    return '$count miesiące temu';
  }

  @override
  String get commonEdit => 'Edytuj';

  @override
  String get commonDelete => 'Usuń';

  @override
  String get natalChartProGenerated =>
      'Pro interpretacje wygenerowane! Przewiń w górę, aby je zobaczyć.';

  @override
  String get natalChartHouse1 => 'Ja i Tożsamość';

  @override
  String get natalChartHouse2 => 'Pieniądze i Wartości';

  @override
  String get natalChartHouse3 => 'Komunikacja';

  @override
  String get natalChartHouse4 => 'Dom i Rodzina';

  @override
  String get natalChartHouse5 => 'Kreatywność i Romans';

  @override
  String get natalChartHouse6 => 'Zdrowie i Rutyna';

  @override
  String get natalChartHouse7 => 'Relacje';

  @override
  String get natalChartHouse8 => 'Transformacja';

  @override
  String get natalChartHouse9 => 'Filozofia i Podróże';

  @override
  String get natalChartHouse10 => 'Kariera i Status';

  @override
  String get natalChartHouse11 => 'Przyjaciele i Cele';

  @override
  String get natalChartHouse12 => 'Duchowość';

  @override
  String get helpSupportTitle => 'Pomoc i Wsparcie';

  @override
  String get helpSupportContactTitle => 'Kontakt z Wsparciem';

  @override
  String get helpSupportContactSubtitle =>
      'Zazwyczaj odpowiadamy w ciągu 24 godzin';

  @override
  String get helpSupportFaqTitle => 'Najczęściej Zadawane Pytania';

  @override
  String get helpSupportEmailSubject => 'Prośba o Wsparcie z Inner Wisdom';

  @override
  String get helpSupportEmailAppFailed =>
      'Nie można otworzyć aplikacji e-mail. Proszę wysłać e-mail na support@innerwisdomapp.com';

  @override
  String get helpSupportEmailFallback =>
      'Proszę wysłać do nas e-mail na support@innerwisdomapp.com';

  @override
  String get helpSupportFaq1Q => 'Jak dokładne są codzienne wskazówki?';

  @override
  String get helpSupportFaq1A =>
      'Nasze codzienne wskazówki łączą tradycyjne zasady astrologiczne z Twoim osobistym horoskopem. Chociaż astrologia jest interpretacyjna, nasza AI dostarcza spersonalizowane wglądy na podstawie rzeczywistych pozycji planet i aspektów.';

  @override
  String get helpSupportFaq2Q => 'Dlaczego potrzebuję godziny urodzenia?';

  @override
  String get helpSupportFaq2A =>
      'Twoja godzina urodzenia określa Twój Ascendent (znak wschodzący) oraz pozycje domów w Twoim horoskopie. Bez niej używamy południa jako domyślnej, co może wpłynąć na dokładność interpretacji związanych z domami.';

  @override
  String get helpSupportFaq3Q => 'Jak mogę zmienić swoje dane urodzenia?';

  @override
  String get helpSupportFaq3A =>
      'Obecnie dane urodzenia nie mogą być zmieniane po początkowej konfiguracji, aby zapewnić spójność w Twoich odczytach. Skontaktuj się z wsparciem, jeśli musisz wprowadzić poprawki.';

  @override
  String get helpSupportFaq4Q => 'Czym jest temat Fokusu?';

  @override
  String get helpSupportFaq4A =>
      'Temat Fokusu to aktualna kwestia lub obszar życia, który chcesz podkreślić. Po ustawieniu, Twoje codzienne wskazówki będą szczególnie zwracać uwagę na ten obszar, dostarczając bardziej odpowiednich wglądów.';

  @override
  String get helpSupportFaq5Q => 'Jak działa subskrypcja?';

  @override
  String get helpSupportFaq5A =>
      'Darmowy poziom obejmuje podstawowe codzienne wskazówki. Subskrybenci premium otrzymują ulepszoną personalizację, odczyty audio i dostęp do specjalnych funkcji, takich jak odczyty astrologii karmicznej.';

  @override
  String get helpSupportFaq6Q => 'Czy moje dane są prywatne?';

  @override
  String get helpSupportFaq6A =>
      'Tak! Traktujemy prywatność poważnie. Twoje dane urodzenia i informacje osobiste są szyfrowane i nigdy nie są udostępniane osobom trzecim. Możesz usunąć swoje konto w dowolnym momencie.';

  @override
  String get helpSupportFaq7Q => 'Co jeśli nie zgadzam się z odczytem?';

  @override
  String get helpSupportFaq7A =>
      'Astrologia jest interpretacyjna i nie każdy odczyt będzie rezonować. Użyj funkcji feedbacku, aby pomóc nam się poprawić. Nasza AI uczy się z Twoich preferencji w czasie.';

  @override
  String get notificationsSaved => 'Ustawienia powiadomień zapisane';

  @override
  String get notificationsTitle => 'Powiadomienia';

  @override
  String get notificationsSectionTitle => 'Powiadomienia Push';

  @override
  String get notificationsDailyTitle => 'Codzienne Wskazówki';

  @override
  String get notificationsDailySubtitle =>
      'Otrzymuj powiadomienia, gdy Twoje codzienne wskazówki są gotowe';

  @override
  String get notificationsWeeklyTitle => 'Cotygodniowe Podsumowanie';

  @override
  String get notificationsWeeklySubtitle =>
      'Cotygodniowy przegląd kosmiczny i kluczowe tranzyty';

  @override
  String get notificationsSpecialTitle => 'Wydarzenia Specjalne';

  @override
  String get notificationsSpecialSubtitle =>
      'Pełnie księżyca, zaćmienia i retrogradacje';

  @override
  String get notificationsDeviceHint =>
      'Możesz także kontrolować powiadomienia w ustawieniach swojego urządzenia.';

  @override
  String get concernsTitle => 'Twój Fokus';

  @override
  String get concernsSubtitle => 'Tematy kształtujące Twoje wskazówki';

  @override
  String concernsTabActive(Object count) {
    return 'Aktywne ($count)';
  }

  @override
  String concernsTabResolved(Object count) {
    return 'Rozwiązane ($count)';
  }

  @override
  String concernsTabArchived(Object count) {
    return 'Zarchiwizowane ($count)';
  }

  @override
  String get concernsEmptyTitle => 'Brak tutaj zmartwień';

  @override
  String get concernsEmptySubtitle =>
      'Dodaj temat fokusu, aby uzyskać spersonalizowane wskazówki';

  @override
  String get concernsCategoryCareer => 'Kariera i Praca';

  @override
  String get concernsCategoryHealth => 'Zdrowie';

  @override
  String get concernsCategoryRelationship => 'Związek';

  @override
  String get concernsCategoryFamily => 'Rodzina';

  @override
  String get concernsCategoryMoney => 'Pieniądze';

  @override
  String get concernsCategoryBusiness => 'Biznes';

  @override
  String get concernsCategoryPartnership => 'Partnerstwo';

  @override
  String get concernsCategoryGrowth => 'Osobisty Rozwój';

  @override
  String get concernsMinLength =>
      'Proszę opisać swoje zmartwienie bardziej szczegółowo (przynajmniej 10 znaków)';

  @override
  String get concernsSubmitFailed =>
      'Nie udało się przesłać zmartwienia. Proszę spróbować ponownie.';

  @override
  String get concernsAddTitle => 'Co masz na myśli?';

  @override
  String get concernsAddDescription =>
      'Podziel się swoim aktualnym zmartwieniem, pytaniem lub sytuacją życiową. Nasza AI przeanalizuje to i dostarczy skoncentrowane wskazówki od jutra.';

  @override
  String get concernsExamplesTitle => 'Przykłady zmartwień:';

  @override
  String get concernsExampleCareer => 'Decyzja o zmianie kariery';

  @override
  String get concernsExampleRelationship => 'Wyzwania w związku';

  @override
  String get concernsExampleFinance => 'Czas inwestycji finansowej';

  @override
  String get concernsExampleHealth => 'Skupienie na zdrowiu i wellness';

  @override
  String get concernsExampleGrowth => 'Kierunek osobistego rozwoju';

  @override
  String get concernsSubmitButton => 'Prześlij Zmartwienie';

  @override
  String get concernsSuccessTitle => 'Zmartwienie Zarejestrowane!';

  @override
  String get concernsCategoryLabel => 'Kategoria: ';

  @override
  String get concernsSuccessMessage =>
      'Od jutra Twoje codzienne wskazówki będą bardziej koncentrować się na tym temacie.';

  @override
  String get concernsViewFocusTopics => 'Zobacz Moje Tematy Fokusu';

  @override
  String get deleteAccountTitle => 'Usuń Konto';

  @override
  String get deleteAccountHeading => 'Usunąć swoje konto?';

  @override
  String get deleteAccountConfirmError =>
      'Proszę wpisać DELETE, aby potwierdzić';

  @override
  String get deleteAccountFinalWarningTitle => 'Ostateczne Ostrzeżenie';

  @override
  String get deleteAccountFinalWarningBody =>
      'Ta akcja nie może być cofnięta. Wszystkie Twoje dane, w tym:\n\n• Twój profil i dane urodzenia\n• Horoskop i interpretacje\n• Historia codziennych wskazówek\n• Osobisty kontekst i preferencje\n• Cała zakupiona zawartość\n\nZostaną trwale usunięte.';

  @override
  String get deleteAccountConfirmButton => 'Usuń Na Zawsze';

  @override
  String get deleteAccountSuccess => 'Twoje konto zostało usunięte';

  @override
  String get deleteAccountFailed =>
      'Nie udało się usunąć konta. Proszę spróbować ponownie.';

  @override
  String get deleteAccountPermanentWarning =>
      'Ta akcja jest trwała i nie może być cofnięta';

  @override
  String get deleteAccountWarningDetail =>
      'Wszystkie Twoje dane osobowe, w tym Twój horoskop, historia wskazówek i wszelkie zakupy, zostaną trwale usunięte.';

  @override
  String get deleteAccountWhatTitle => 'Co zostanie usunięte:';

  @override
  String get deleteAccountItemProfile => 'Twój profil i konto';

  @override
  String get deleteAccountItemBirthData => 'Dane urodzenia i horoskop';

  @override
  String get deleteAccountItemGuidance => 'Cała historia codziennych wskazówek';

  @override
  String get deleteAccountItemContext => 'Osobisty kontekst i preferencje';

  @override
  String get deleteAccountItemKarmic => 'Odczyty astrologii karmicznej';

  @override
  String get deleteAccountItemPurchases => 'Cała zakupiona zawartość';

  @override
  String get deleteAccountTypeDelete => 'Wpisz DELETE, aby potwierdzić';

  @override
  String get deleteAccountDeleteHint => 'DELETE';

  @override
  String get deleteAccountButton => 'Usuń Moje Konto';

  @override
  String get deleteAccountCancel => 'Anuluj, zachowaj moje konto';

  @override
  String get learnArticleLoadFailed => 'Nie udało się załadować artykułu';

  @override
  String get learnContentInEnglish => 'Treść w języku angielskim';

  @override
  String get learnArticlesLoadFailed => 'Nie udało się załadować artykułów';

  @override
  String get learnArticlesEmpty => 'Brak dostępnych artykułów';

  @override
  String get learnContentFallback =>
      'Wyświetlanie treści w języku angielskim (niedostępne w Twoim języku)';

  @override
  String get checkoutTitle => 'Zakupy';

  @override
  String get checkoutOrderSummary => 'Podsumowanie Zamówienia';

  @override
  String get checkoutProTitle => 'Pro Horoskop';

  @override
  String get checkoutProSubtitle => 'Pełne interpretacje planetarne';

  @override
  String get checkoutTotalLabel => 'Całkowita kwota';

  @override
  String get checkoutTotalAmount => '\$9.99 USD';

  @override
  String get checkoutPaymentTitle => 'Integracja Płatności';

  @override
  String get checkoutPaymentSubtitle =>
      'Integracja zakupu w aplikacji jest w finalizacji. Proszę sprawdzić wkrótce!';

  @override
  String get checkoutProcessing => 'Przetwarzanie...';

  @override
  String get checkoutDemoPurchase => 'Zakup demo (testowy)';

  @override
  String get checkoutSecurityNote =>
      'Płatność jest przetwarzana bezpiecznie przez Apple/Google. Twoje dane karty nigdy nie są przechowywane.';

  @override
  String get checkoutSuccess => '🎉 Pro Natal Chart odblokowany pomyślnie!';

  @override
  String get checkoutGenerateFailed =>
      'Nie udało się wygenerować interpretacji. Proszę spróbować ponownie.';

  @override
  String checkoutErrorWithMessage(Object error) {
    return 'Wystąpił błąd: $error';
  }

  @override
  String get billingUpgrade => 'Ulepsz do Premium';

  @override
  String billingFeatureLocked(Object feature) {
    return '$feature jest funkcją Premium';
  }

  @override
  String get billingUpgradeBody =>
      'Ulepsz do Premium, aby odblokować tę funkcję i uzyskać najbardziej spersonalizowane wskazówki.';

  @override
  String get contextReviewFailed =>
      'Nie udało się zaktualizować. Proszę spróbować ponownie.';

  @override
  String get contextReviewTitle => 'Czas na szybkie sprawdzenie';

  @override
  String get contextReviewBody =>
      'Minęły 3 miesiące od ostatniej aktualizacji twojego osobistego kontekstu. Czy coś ważnego zmieniło się w twoim życiu, o czym powinniśmy wiedzieć?';

  @override
  String get contextReviewHint =>
      'To pomoże nam dać ci bardziej spersonalizowane wskazówki.';

  @override
  String get contextReviewNoChanges => 'Brak zmian';

  @override
  String get contextReviewYesUpdate => 'Tak, zaktualizuj';

  @override
  String get contextProfileLoadFailed => 'Nie udało się załadować profilu';

  @override
  String get contextCardTitle => 'Osobisty kontekst';

  @override
  String get contextCardSubtitle =>
      'Skonfiguruj swój osobisty kontekst, aby otrzymać bardziej dostosowane wskazówki.';

  @override
  String get contextCardSetupNow => 'Skonfiguruj teraz';

  @override
  String contextCardVersionUpdated(Object version, Object date) {
    return 'Wersja $version • Ostatnia aktualizacja $date';
  }

  @override
  String get contextCardAiSummary => 'Podsumowanie AI';

  @override
  String contextCardToneTag(Object tone) {
    return 'ton $tone';
  }

  @override
  String get contextCardSensitivityTag => 'wrażliwość włączona';

  @override
  String get contextCardReviewDue =>
      'Przegląd do zrobienia - zaktualizuj swój kontekst';

  @override
  String contextCardNextReview(Object days) {
    return 'Następny przegląd za $days dni';
  }

  @override
  String get contextDeleteTitle => 'Usunąć osobisty kontekst?';

  @override
  String get contextDeleteBody =>
      'To usunie twój profil osobistego kontekstu. Twoje wskazówki staną się mniej spersonalizowane.';

  @override
  String get contextDeleteFailed => 'Nie udało się usunąć profilu';

  @override
  String get appTitle => 'Wewnętrzna Mądrość';

  @override
  String get concernsHintExample =>
      'Przykład: Mam ofertę pracy w innym mieście i nie jestem pewien, czy powinienem ją przyjąć...';

  @override
  String get learnTitle => 'Ucz się astrologii';

  @override
  String get learnFreeTitle => 'Darmowe zasoby edukacyjne';

  @override
  String get learnFreeSubtitle => 'Poznaj podstawy astrologii';

  @override
  String get learnSignsTitle => 'Znaki';

  @override
  String get learnSignsSubtitle => '12 znaków zodiaku i ich znaczenia';

  @override
  String get learnPlanetsTitle => 'Planety';

  @override
  String get learnPlanetsSubtitle => 'Ciała niebieskie w astrologii';

  @override
  String get learnHousesTitle => 'Domy';

  @override
  String get learnHousesSubtitle => '12 obszarów życia w twoim wykresie';

  @override
  String get learnTransitsTitle => 'Tranzyty';

  @override
  String get learnTransitsSubtitle => 'Ruchy planetarne i ich efekty';

  @override
  String get learnPaceTitle => 'Ucz się w swoim tempie';

  @override
  String get learnPaceSubtitle =>
      'Kompleksowe lekcje, aby pogłębić swoją wiedzę astrologiczną';

  @override
  String get proNatalTitle => 'Pro Natal Chart';

  @override
  String get proNatalHeroTitle => 'Odblokuj głębokie wglądy';

  @override
  String get proNatalHeroSubtitle =>
      'Uzyskaj kompleksowe interpretacje o długości 150-200 słów dla każdego położenia planetarnego w swoim wykresie urodzeniowym.';

  @override
  String get proNatalFeature1Title => 'Głębokie wglądy w osobowość';

  @override
  String get proNatalFeature1Body =>
      'Zrozum, jak każda planeta kształtuje twoją unikalną osobowość i ścieżkę życiową.';

  @override
  String get proNatalFeature2Title => 'Analiza zasilana AI';

  @override
  String get proNatalFeature2Body =>
      'Zaawansowane interpretacje dostosowane do twoich dokładnych pozycji planetarnych.';

  @override
  String get proNatalFeature3Title => 'Praktyczne wskazówki';

  @override
  String get proNatalFeature3Body =>
      'Praktyczne porady dotyczące kariery, relacji i osobistego rozwoju.';

  @override
  String get proNatalFeature4Title => 'Dostęp na całe życie';

  @override
  String get proNatalFeature4Body =>
      'Twoje interpretacje są zapisywane na zawsze. Uzyskaj dostęp w dowolnym momencie.';

  @override
  String get proNatalOneTime => 'Jednorazowy zakup';

  @override
  String get proNatalNoSubscription => 'Brak wymaganej subskrypcji';
}

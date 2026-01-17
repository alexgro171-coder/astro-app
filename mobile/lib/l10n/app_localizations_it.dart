// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get onboardingSkip => 'Pule';

  @override
  String get onboardingTitle1 => 'Welkom bij Inner Wisdom Astro';

  @override
  String get onboardingDesc1 =>
      'Innerwisdom Astro brengt meer dan 30 jaar astrologische expertise van Madi G. samen met de kracht van geavanceerde AI, waardoor een van de meest verfijnde en hoogpresterende astrologie-applicaties van vandaag ontstaat.\n\nDoor diepe menselijke inzichten te combineren met intelligente technologie, levert Innerwisdom Astro interpretaties die nauwkeurig, gepersonaliseerd en betekenisvol zijn, en ondersteunt het gebruikers op hun reis van zelfontdekking, helderheid en bewuste groei.';

  @override
  String get onboardingTitle2 => 'Jouw Complete Astrologische Reis';

  @override
  String get onboardingDesc2 =>
      'Van gepersonaliseerde dagelijkse begeleiding tot jouw Natal Birth Chart, Karmische Astrologie, diepgaande persoonlijkheidsrapporten, Liefde- en Vriendschapscompatibiliteit, Romantische Voorspellingen voor Stellen, en nog veel meer — alles is nu binnen handbereik.\n\nOntworpen om helderheid, verbinding en zelfbegrip te ondersteunen, biedt Innerwisdom Astro een complete astrologische ervaring, op maat gemaakt voor jou.';

  @override
  String get onboardingNext => 'Volgende';

  @override
  String get onboardingGetStarted => 'Aan de Slag';

  @override
  String get onboardingAlreadyHaveAccount => 'Heb je al een account? Inloggen';

  @override
  String get birthDataTitle => 'Jouw Geboortehoroscoop';

  @override
  String get birthDataSubtitle =>
      'We hebben jouw geboortedetails nodig om\neen gepersonaliseerd astrologisch profiel te maken';

  @override
  String get birthDateLabel => 'Geboortedatum';

  @override
  String get birthDateSelectHint => 'Selecteer je geboortedatum';

  @override
  String get birthTimeLabel => 'Geboortetijd';

  @override
  String get birthTimeUnknown => 'Onbekend';

  @override
  String get birthTimeSelectHint => 'Selecteer je geboortetijd';

  @override
  String get birthTimeUnknownCheckbox =>
      'Ik weet mijn exacte geboortetijd niet';

  @override
  String get birthPlaceLabel => 'Geboorteplaats';

  @override
  String get birthPlaceHint => 'Begin met het typen van een stadsnaam...';

  @override
  String get birthPlaceValidation => 'Selecteer een locatie uit de suggesties';

  @override
  String birthPlaceSelected(Object location) {
    return 'Geselecteerd: $location';
  }

  @override
  String get genderLabel => 'Geslacht';

  @override
  String get genderMale => 'Man';

  @override
  String get genderFemale => 'Vrouw';

  @override
  String get genderPreferNotToSay => 'Lieber niet zeggen';

  @override
  String get birthDataSubmit => 'Genereer Mijn Geboortehoroscoop';

  @override
  String get birthDataPrivacyNote =>
      'Jouw geboortedata wordt alleen gebruikt om jouw\nastrologische horoscoop te berekenen en wordt veilig opgeslagen.';

  @override
  String get birthDateMissing => 'Selecteer je geboortedatum';

  @override
  String get birthPlaceMissing =>
      'Selecteer een geboorteplaats uit de suggesties';

  @override
  String get birthDataSaveError =>
      'Kon geboortedata niet opslaan. Probeer het opnieuw.';

  @override
  String get appearanceTitle => 'Uiterlijk';

  @override
  String get appearanceTheme => 'Thema';

  @override
  String get appearanceDarkTitle => 'Donker';

  @override
  String get appearanceDarkSubtitle =>
      'Vriendelijk voor de ogen bij weinig licht';

  @override
  String get appearanceLightTitle => 'Licht';

  @override
  String get appearanceLightSubtitle => 'Klassiek helder uiterlijk';

  @override
  String get appearanceSystemTitle => 'Systeem';

  @override
  String get appearanceSystemSubtitle => 'Stem af op je apparaatsinstellingen';

  @override
  String get appearancePreviewTitle => 'Voorbeeld';

  @override
  String get appearancePreviewBody =>
      'Het kosmische thema is ontworpen om een meeslepende astrologie-ervaring te creëren. Het donkere thema wordt aanbevolen voor de beste visuele ervaring.';

  @override
  String appearanceThemeChanged(Object theme) {
    return 'Thema gewijzigd naar $theme';
  }

  @override
  String get profileUserFallback => 'Gebruiker';

  @override
  String get profilePersonalContext => 'Persoonlijke Context';

  @override
  String get profileSettings => 'Instellingen';

  @override
  String get profileAppLanguage => 'App Taal';

  @override
  String get profileContentLanguage => 'Inhoud Taal';

  @override
  String get profileContentLanguageHint =>
      'AI-inhoud gebruikt de geselecteerde taal.';

  @override
  String get profileNotifications => 'Meldingen';

  @override
  String get profileNotificationsEnabled => 'Ingeschakeld';

  @override
  String get profileNotificationsDisabled => 'Uitgeschakeld';

  @override
  String get profileAppearance => 'Uiterlijk';

  @override
  String get profileHelpSupport => 'Hulp & Ondersteuning';

  @override
  String get profilePrivacyPolicy => 'Privacybeleid';

  @override
  String get profileTermsOfService => 'Servicevoorwaarden';

  @override
  String get profileLogout => 'Uitloggen';

  @override
  String get profileLogoutConfirm => 'Weet je zeker dat je wilt uitloggen?';

  @override
  String get profileDeleteAccount => 'Account Verwijderen';

  @override
  String get commonCancel => 'Annuleren';

  @override
  String get profileSelectLanguageTitle => 'Selecteer Taal';

  @override
  String get profileSelectLanguageSubtitle =>
      'Alle AI-gegenereerde inhoud zal in jouw geselecteerde taal zijn.';

  @override
  String profileLanguageUpdated(Object language) {
    return 'Taal bijgewerkt naar $language';
  }

  @override
  String profileLanguageUpdateFailed(Object error) {
    return 'Kon taal niet bijwerken: $error';
  }

  @override
  String profileVersion(Object version) {
    return 'Inner Wisdom v$version';
  }

  @override
  String get profileCosmicBlueprint => 'Jouw Kosmische Blauwdruk';

  @override
  String get profileSunLabel => '☀️ Zon';

  @override
  String get profileMoonLabel => '🌙 Maan';

  @override
  String get profileRisingLabel => '⬆️ Stijgend';

  @override
  String get profileUnknown => 'Onbekend';

  @override
  String get forgotPasswordTitle => 'Wachtwoord Vergeten?';

  @override
  String get forgotPasswordSubtitle =>
      'Voer je e-mail in en we sturen je een code om je wachtwoord opnieuw in te stellen';

  @override
  String get forgotPasswordSent =>
      'Als er een account bestaat, is er een resetcode naar je e-mail gestuurd.';

  @override
  String get forgotPasswordFailed =>
      'Kon resetcode niet verzenden. Probeer het opnieuw.';

  @override
  String get forgotPasswordSendCode => 'Stuur Resetcode';

  @override
  String get forgotPasswordHaveCode => 'Heb je al een code?';

  @override
  String get forgotPasswordRemember => 'Vergeet je wachtwoord? ';

  @override
  String get loginWelcomeBack => 'Welkom Terug';

  @override
  String get loginSubtitle => 'Log in om je kosmische reis voort te zetten';

  @override
  String get loginInvalidCredentials => 'Ongeldige e-mail of wachtwoord';

  @override
  String get loginGoogleFailed =>
      'Google-inloggen mislukt. Probeer het opnieuw.';

  @override
  String get loginAppleFailed => 'Apple-inloggen mislukt. Probeer het opnieuw.';

  @override
  String get loginNetworkError => 'Netwerkfout. Controleer je verbinding.';

  @override
  String get loginSignInCancelled => 'Inloggen is geannuleerd.';

  @override
  String get loginPasswordHint => 'Voer je wachtwoord in';

  @override
  String get loginForgotPassword => 'Wachtwoord Vergeten?';

  @override
  String get loginSignIn => 'Inloggen';

  @override
  String get loginNoAccount => 'Heb je geen account? ';

  @override
  String get loginSignUp => 'Aanmelden';

  @override
  String get commonEmailLabel => 'E-mail';

  @override
  String get commonEmailHint => 'Voer je e-mail in';

  @override
  String get commonEmailRequired => 'Voer je e-mail in';

  @override
  String get commonEmailInvalid => 'Voer een geldige e-mail in';

  @override
  String get commonPasswordLabel => 'Wachtwoord';

  @override
  String get commonPasswordRequired => 'Voer je wachtwoord in';

  @override
  String get commonOrContinueWith => 'of ga verder met';

  @override
  String get commonGoogle => 'Google';

  @override
  String get commonApple => 'Apple';

  @override
  String get commonNameLabel => 'Naam';

  @override
  String get commonNameHint => 'Voer je naam in';

  @override
  String get commonNameRequired => 'Voer je naam in';

  @override
  String get signupTitle => 'Account Aanmaken';

  @override
  String get signupSubtitle => 'Begin je kosmische reis met Inner Wisdom';

  @override
  String get signupEmailExists => 'E-mail já existe ou dados inválidos';

  @override
  String get signupGoogleFailed =>
      'Falha ao fazer login com o Google. Por favor, tente novamente.';

  @override
  String get signupAppleFailed =>
      'Falha ao fazer login com a Apple. Por favor, tente novamente.';

  @override
  String get signupPasswordHint => 'Crie uma senha (mín. 8 caracteres)';

  @override
  String get signupPasswordMin => 'A senha deve ter pelo menos 8 caracteres';

  @override
  String get signupConfirmPasswordLabel => 'Confirmar Senha';

  @override
  String get signupConfirmPasswordHint => 'Confirme sua senha';

  @override
  String get signupConfirmPasswordRequired => 'Por favor, confirme sua senha';

  @override
  String get signupPasswordMismatch => 'As senhas não coincidem';

  @override
  String get signupPreferredLanguage => 'Idioma Preferido';

  @override
  String get signupCreateAccount => 'Criar Conta';

  @override
  String get signupHaveAccount => 'Já tem uma conta? ';

  @override
  String get resetPasswordTitle => 'Redefinir Senha';

  @override
  String get resetPasswordSubtitle =>
      'Digite o código enviado para seu e-mail e defina uma nova senha';

  @override
  String get resetPasswordSuccess =>
      'Redefinição de senha bem-sucedida! Redirecionando para o login...';

  @override
  String get resetPasswordFailed =>
      'Falha ao redefinir a senha. Por favor, tente novamente.';

  @override
  String get resetPasswordInvalidCode =>
      'Código de redefinição inválido ou expirado. Por favor, solicite um novo.';

  @override
  String get resetPasswordMaxAttempts =>
      'Número máximo de tentativas excedido. Por favor, solicite um novo código.';

  @override
  String get resetCodeLabel => 'Código de Redefinição';

  @override
  String get resetCodeHint => 'Digite o código de 6 dígitos';

  @override
  String get resetCodeRequired => 'Por favor, insira o código de redefinição';

  @override
  String get resetCodeLength => 'O código deve ter 6 dígitos';

  @override
  String get resetNewPasswordLabel => 'Nova Senha';

  @override
  String get resetNewPasswordHint => 'Crie uma nova senha (mín. 8 caracteres)';

  @override
  String get resetNewPasswordRequired => 'Por favor, insira uma nova senha';

  @override
  String get resetConfirmPasswordHint => 'Confirme sua nova senha';

  @override
  String get resetPasswordButton => 'Redefinir Senha';

  @override
  String get resetRequestNewCode => 'Solicitar um novo código';

  @override
  String get serviceResultGenerated => 'Relatório Gerado';

  @override
  String serviceResultReady(Object title) {
    return 'Seu $title personalizado está pronto';
  }

  @override
  String get serviceResultBackToForYou => 'Voltar para Você';

  @override
  String get serviceResultNotSavedNotice =>
      'Este Relatório não será salvo. Se desejar, você pode copiá-lo e salvá-lo em outro lugar usando a função Copiar.';

  @override
  String get commonCopy => 'Copiar';

  @override
  String get commonCopied => 'Copiado para a área de transferência';

  @override
  String get commonContinue => 'Continuar';

  @override
  String get partnerDetailsTitle => 'Detalhes do Parceiro';

  @override
  String get partnerBirthDataTitle =>
      'Insira os dados de nascimento do parceiro';

  @override
  String partnerBirthDataFor(Object title) {
    return 'Para \"$title\"';
  }

  @override
  String get partnerNameOptionalLabel => 'Nome (opcional)';

  @override
  String get partnerNameHint => 'Nome do parceiro';

  @override
  String get partnerGenderOptionalLabel => 'Gênero (opcional)';

  @override
  String get partnerBirthDateLabel => 'Data de Nascimento *';

  @override
  String get partnerBirthDateSelect => 'Selecionar data de nascimento';

  @override
  String get partnerBirthDateMissing =>
      'Por favor, selecione a data de nascimento';

  @override
  String get partnerBirthTimeOptionalLabel => 'Hora de Nascimento (opcional)';

  @override
  String get partnerBirthTimeSelect => 'Selecionar hora de nascimento';

  @override
  String get partnerBirthPlaceLabel => 'Local de Nascimento *';

  @override
  String get serviceOfferRequiresPartner =>
      'Requer dados de nascimento do parceiro';

  @override
  String get serviceOfferBetaFree => 'Testadores beta têm acesso gratuito!';

  @override
  String get serviceOfferUnlocked => 'Desbloqueado';

  @override
  String get serviceOfferGenerate => 'Gerar Relatório';

  @override
  String serviceOfferUnlockFor(Object price) {
    return 'Desbloquear por $price';
  }

  @override
  String get serviceOfferPreparing => 'Preparando seu relatório personalizado…';

  @override
  String get serviceOfferTimeout =>
      'Demorando mais do que o esperado. Por favor, tente novamente.';

  @override
  String get serviceOfferNotReady =>
      'Relatório ainda não está pronto. Por favor, tente novamente.';

  @override
  String serviceOfferFetchFailed(Object error) {
    return 'Falha ao buscar relatório: $error';
  }

  @override
  String get commonFree => 'GRATIS';

  @override
  String get commonLater => 'Depois';

  @override
  String get commonRetry => 'Tentar Novamente';

  @override
  String get commonYes => 'Sim';

  @override
  String get commonNo => 'Não';

  @override
  String get commonBack => 'Voltar';

  @override
  String get commonOptional => 'Opcional';

  @override
  String get commonNotSpecified => 'Não especificado';

  @override
  String get commonJustNow => 'Agora mesmo';

  @override
  String get commonViewMore => 'Ver mais';

  @override
  String get commonViewLess => 'Ver menos';

  @override
  String commonMinutesAgo(Object count) {
    return 'Há $count min';
  }

  @override
  String commonHoursAgo(Object count) {
    return 'Há ${count}h';
  }

  @override
  String commonDaysAgo(Object count) {
    return 'Há ${count}d';
  }

  @override
  String commonDateShort(Object day, Object month, Object year) {
    return '$day/$month/$year';
  }

  @override
  String get askGuideTitle => 'Pergunte ao Seu Guia';

  @override
  String get askGuideSubtitle => 'Orientação cósmica pessoal';

  @override
  String askGuideRemaining(Object count) {
    return '$count restantes';
  }

  @override
  String get askGuideQuestionHint =>
      'Pergunte qualquer coisa - amor, carreira, decisões, emoções...';

  @override
  String get askGuideBasedOnChart =>
      'Baseado no seu mapa natal e nas energias cósmicas de hoje';

  @override
  String get askGuideThinking => 'Seu Guia está pensando...';

  @override
  String get askGuideYourGuide => 'Seu Guia';

  @override
  String get askGuideEmptyTitle => 'Faça Sua Primeira Pergunta';

  @override
  String get askGuideEmptyBody =>
      'Obtenha orientação instantânea e profundamente pessoal com base no seu mapa natal e nas energias cósmicas de hoje.';

  @override
  String get askGuideEmptyHint =>
      'Pergunte qualquer coisa — amor, carreira, decisões, emoções.';

  @override
  String get askGuideLoadFailed => 'Falha ao carregar dados';

  @override
  String askGuideSendFailed(Object error) {
    return 'Falha ao enviar pergunta: $error';
  }

  @override
  String get askGuideLimitTitle => 'Limite Mensal Atingido';

  @override
  String get askGuideLimitBody =>
      'Você atingiu seu limite mensal de solicitações.';

  @override
  String get askGuideLimitAddon =>
      'Você pode comprar um complemento de \$1,99 para continuar usando este serviço pelo resto do mês de faturamento atual.';

  @override
  String askGuideLimitBillingEnd(Object date) {
    return 'Seu mês de faturamento termina em: $date';
  }

  @override
  String get askGuideLimitGetAddon => 'Obtener complemento';

  @override
  String get contextTitle => 'Contexto Pessoal';

  @override
  String contextStepOf(Object current, Object total) {
    return 'Passo $current de $total';
  }

  @override
  String get contextStep1Title => 'Pessoas ao seu redor';

  @override
  String get contextStep1Subtitle =>
      'Seu contexto de relacionamento e familiar nos ajuda a entender sua paisagem emocional.';

  @override
  String get contextStep2Title => 'Vida Profissional';

  @override
  String get contextStep2Subtitle =>
      'Seu trabalho e ritmo diário moldam como você experimenta pressão, crescimento e propósito.';

  @override
  String get contextStep3Title => 'Como a vida se sente agora';

  @override
  String get contextStep3Subtitle =>
      'Não há respostas certas ou erradas, apenas sua realidade atual';

  @override
  String get contextStep4Title => 'O que mais importa para você';

  @override
  String get contextStep4Subtitle =>
      'Para que sua orientação esteja alinhada com o que você realmente se importa';

  @override
  String get contextPriorityRequired =>
      'Por favor, selecione pelo menos uma área de prioridade.';

  @override
  String contextSaveFailed(Object error) {
    return 'Falha ao salvar perfil: $error';
  }

  @override
  String get contextSaveContinue => 'Opslaan & Doorgaan';

  @override
  String get contextRelationshipStatusTitle => 'Huidige relatie status';

  @override
  String get contextSeekingRelationshipTitle => 'Zoek je een relatie?';

  @override
  String get contextHasChildrenTitle => 'Heb je kinderen?';

  @override
  String get contextChildrenDetailsOptional => 'Kinderen details (optioneel)';

  @override
  String get contextAddChild => 'Voeg kind toe';

  @override
  String get contextChildAgeLabel => 'Leeftijd';

  @override
  String contextChildAgeYears(num age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other: 'jaren',
      one: 'jaar',
    );
    return '$age $_temp0';
  }

  @override
  String get contextChildGenderLabel => 'Geslacht';

  @override
  String get contextRelationshipSingle => 'Single';

  @override
  String get contextRelationshipInRelationship => 'In een relatie';

  @override
  String get contextRelationshipMarried =>
      'Getrouwd / Geregistreerd partnerschap';

  @override
  String get contextRelationshipSeparated => 'Gescheiden / Divorced';

  @override
  String get contextRelationshipWidowed => 'Weduwe / Weduwnaar';

  @override
  String get contextRelationshipPreferNotToSay => 'Liever niet zeggen';

  @override
  String get contextProfessionalStatusTitle => 'Huidige professionele status';

  @override
  String get contextProfessionalStatusOtherHint =>
      'Geef alstublieft je werkstatus op';

  @override
  String get contextIndustryTitle => 'Hoofd industrie/domein';

  @override
  String get contextWorkStatusStudent => 'Student';

  @override
  String get contextWorkStatusUnemployed => 'Werkloos / Tussen banen';

  @override
  String get contextWorkStatusEmployedIc => 'In dienst (Individuele bijdrager)';

  @override
  String get contextWorkStatusEmployedManagement => 'In dienst (Management)';

  @override
  String get contextWorkStatusExecutive => 'Executive / Leiderschap (C-niveau)';

  @override
  String get contextWorkStatusSelfEmployed => 'Zelfstandig / Freelancer';

  @override
  String get contextWorkStatusEntrepreneur => 'Ondernemer / Bedrijfseigenaar';

  @override
  String get contextWorkStatusInvestor => 'Investeerder';

  @override
  String get contextWorkStatusRetired => 'Met pensioen';

  @override
  String get contextWorkStatusHomemaker => 'Huisvrouw / Thuisblijvende ouder';

  @override
  String get contextWorkStatusCareerBreak => 'Carrièrepauze / Sabbatical';

  @override
  String get contextWorkStatusOther => 'Anders';

  @override
  String get contextIndustryTech => 'Technologie / IT';

  @override
  String get contextIndustryFinance => 'Financiën / Investeringen';

  @override
  String get contextIndustryHealthcare => 'Gezondheidszorg';

  @override
  String get contextIndustryEducation => 'Onderwijs';

  @override
  String get contextIndustrySalesMarketing => 'Verkoop / Marketing';

  @override
  String get contextIndustryRealEstate => 'Vastgoed';

  @override
  String get contextIndustryHospitality => 'Gastvrijheid';

  @override
  String get contextIndustryGovernment => 'Overheid / Publieke sector';

  @override
  String get contextIndustryCreative => 'Creatieve industrieën';

  @override
  String get contextIndustryOther => 'Anders';

  @override
  String get contextSelfAssessmentIntro =>
      'Beoordeel je huidige situatie in elk gebied (1 = worstelen, 5 = bloeien)';

  @override
  String get contextSelfHealthTitle => 'Gezondheid & Energie';

  @override
  String get contextSelfHealthSubtitle =>
      '1 = ernstige problemen/lage energie, 5 = uitstekende vitaliteit';

  @override
  String get contextSelfSocialTitle => 'Sociaal Leven';

  @override
  String get contextSelfSocialSubtitle =>
      '1 = geïsoleerd, 5 = bloeiende sociale connecties';

  @override
  String get contextSelfRomanceTitle => 'Romantisch Leven';

  @override
  String get contextSelfRomanceSubtitle => '1 = afwezig/uitdagend, 5 = vervuld';

  @override
  String get contextSelfFinanceTitle => 'Financiële Stabiliteit';

  @override
  String get contextSelfFinanceSubtitle =>
      '1 = grote moeilijkheden, 5 = uitstekend';

  @override
  String get contextSelfCareerTitle => 'Carrière Tevredenheid';

  @override
  String get contextSelfCareerSubtitle =>
      '1 = vast/gestrest, 5 = vooruitgang/helderheid';

  @override
  String get contextSelfGrowthTitle => 'Persoonlijke Groei Interesse';

  @override
  String get contextSelfGrowthSubtitle => '1 = lage interesse, 5 = zeer hoog';

  @override
  String get contextSelfStruggling => 'Worstelen';

  @override
  String get contextSelfThriving => 'Bloeien';

  @override
  String get contextPrioritiesTitle =>
      'Wat zijn je belangrijkste prioriteiten op dit moment?';

  @override
  String get contextPrioritiesSubtitle =>
      'Selecteer tot 2 gebieden waarop je je wilt concentreren';

  @override
  String get contextGuidanceStyleTitle => 'Voorkeurs begeleidingsstijl';

  @override
  String get contextSensitivityTitle => 'Gevoeligheidsmodus';

  @override
  String get contextSensitivitySubtitle =>
      'Vermijd angstaanjagende of deterministische formuleringen in begeleiding';

  @override
  String get contextPriorityHealth => 'Gezondheid & gewoonten';

  @override
  String get contextPriorityCareer => 'Carrièregroei';

  @override
  String get contextPriorityBusiness => 'Zakelijke beslissingen';

  @override
  String get contextPriorityMoney => 'Geld & stabiliteit';

  @override
  String get contextPriorityLove => 'Liefde & relatie';

  @override
  String get contextPriorityFamily => 'Familie & ouderschap';

  @override
  String get contextPrioritySocial => 'Sociaal leven';

  @override
  String get contextPriorityGrowth => 'Persoonlijke groei / mindset';

  @override
  String get contextGuidanceStyleDirect => 'Direct & praktisch';

  @override
  String get contextGuidanceStyleDirectDesc =>
      'Ga recht naar uitvoerbare adviezen';

  @override
  String get contextGuidanceStyleEmpathetic => 'Empathisch & reflectief';

  @override
  String get contextGuidanceStyleEmpatheticDesc =>
      'Warme, ondersteunende begeleiding';

  @override
  String get contextGuidanceStyleBalanced => 'Gebalanceerd';

  @override
  String get contextGuidanceStyleBalancedDesc =>
      'Mix van praktische en emotionele ondersteuning';

  @override
  String get homeGuidancePreparing =>
      'De sterren lezen en het Universum over jou vragen…';

  @override
  String get homeGuidanceFailed =>
      'Het is niet gelukt om begeleiding te genereren. Probeer het opnieuw.';

  @override
  String get homeGuidanceTimeout =>
      'Het duurt langer dan verwacht. Tik op Opnieuw of kijk over een moment terug.';

  @override
  String get homeGuidanceLoadFailed =>
      'Het is niet gelukt om begeleiding te laden';

  @override
  String get homeTodaysGuidance => 'Vandaag\'s Begeleiding';

  @override
  String get homeSeeAll => 'Bekijk alles';

  @override
  String get homeHealth => 'Gezondheid';

  @override
  String get homeCareer => 'Carrière';

  @override
  String get homeMoney => 'Geld';

  @override
  String get homeLove => 'Liefde';

  @override
  String get homePartners => 'Partners';

  @override
  String get homeGrowth => 'Groei';

  @override
  String get homeTraveler => 'Reiziger';

  @override
  String homeGreeting(Object name) {
    return 'Hallo, $name';
  }

  @override
  String get homeFocusFallback => 'Persoonlijke Groei';

  @override
  String get homeDailyMessage => 'Je Dagelijkse Bericht';

  @override
  String get homeNatalChartTitle => 'Mijn Geboortehoroscoop';

  @override
  String get homeNatalChartSubtitle =>
      'Verken je geboortehoroscoop & interpretaties';

  @override
  String get navHome => 'Home';

  @override
  String get navHistory => 'Geschiedenis';

  @override
  String get navGuide => 'Gids';

  @override
  String get navProfile => 'Profiel';

  @override
  String get navForYou => 'Voor Jou';

  @override
  String get commonToday => 'Vandaag';

  @override
  String get commonTryAgain => 'Probeer Opnieuw';

  @override
  String get natalChartTitle => 'Mijn Geboortehoroscoop';

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
  String get guidanceCosmicEnergyTitle => 'Heutige kosmische Energie';

  @override
  String get guidanceMoodLabel => 'Stimmung';

  @override
  String get guidanceFocusLabel => 'Fokus';

  @override
  String get guidanceYourGuidance => 'Ihre Anleitung';

  @override
  String get guidanceTapToCollapse => 'Tippen, um zu minimieren';

  @override
  String get historyTitle => 'Anleitungsverlauf';

  @override
  String get historySubtitle => 'Ihre kosmische Reise durch die Zeit';

  @override
  String get historyLoadFailed => 'Verlauf konnte nicht geladen werden';

  @override
  String get historyEmptyTitle => 'Noch keine Historie';

  @override
  String get historyEmptySubtitle =>
      'Ihre täglichen Anleitungen werden hier angezeigt';

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
      'Berichte über Liebe, Freundschaft und Partnerschaft';

  @override
  String get forYouKarmicTitle => 'Karmische Astrologie';

  @override
  String get forYouKarmicSubtitle =>
      'Seelenlektionen und Muster aus vergangenen Leben';

  @override
  String get forYouLearnTitle => 'Astrologie lernen';

  @override
  String get forYouLearnSubtitle => 'Kostenlose Bildungsinhalte';

  @override
  String get compatibilitiesTitle => 'Kompatibilitäten';

  @override
  String get compatibilitiesLoadFailed => 'Konnte Dienste nicht laden';

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
      'Analysieren Sie Freundschaftsdynamiken und Kompatibilität';

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
  String get moonPhaseGenerateDifferentDate => 'Für anderes Datum generieren';

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
      'Karmische Astrologie offenbart die tiefen Muster, die Ihr Leben prägen, über alltägliche Ereignisse hinaus.\n\nSie bietet eine Interpretation, die von ungelösten Lektionen, karmischen Verbindungen und dem Wachstumsweg der Seele spricht.\n\nEs geht nicht darum, was als Nächstes kommt,\nsondern darum, warum Sie erleben, was Sie erleben.\n\n✨ Aktivieren Sie die karmische Astrologie und entdecken Sie die tiefere Bedeutung Ihrer Reise.';

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
  String get karmicProgressHint => 'Verbinden mit Ihrem karmischen Weg…';

  @override
  String karmicGenerateFailed(Object error) {
    return 'Generierung fehlgeschlagen: $error';
  }

  @override
  String get karmicCheckoutTitle => 'Karmische Astrologie Checkout';

  @override
  String get karmicCheckoutSubtitle => 'Kaufprozess kommt bald';

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
  String get natalChartHouse9 => 'Filosofia e Viagem';

  @override
  String get natalChartHouse10 => 'Carreira e Status';

  @override
  String get natalChartHouse11 => 'Amigos e Objetivos';

  @override
  String get natalChartHouse12 => 'Espiritualidade';

  @override
  String get helpSupportTitle => 'Ajuda e Suporte';

  @override
  String get helpSupportContactTitle => 'Contato com o Suporte';

  @override
  String get helpSupportContactSubtitle =>
      'Normalmente respondemos em até 24 horas';

  @override
  String get helpSupportFaqTitle => 'Perguntas Frequentes';

  @override
  String get helpSupportEmailSubject => 'Solicitação de Suporte Inner Wisdom';

  @override
  String get helpSupportEmailAppFailed =>
      'Não foi possível abrir o aplicativo de e-mail. Por favor, envie um e-mail para support@innerwisdomapp.com';

  @override
  String get helpSupportEmailFallback =>
      'Por favor, envie-nos um e-mail para support@innerwisdomapp.com';

  @override
  String get helpSupportFaq1Q => 'Quão precisa é a orientação diária?';

  @override
  String get helpSupportFaq1A =>
      'Nossa orientação diária combina princípios astrológicos tradicionais com seu mapa natal. Embora a astrologia seja interpretativa, nossa IA fornece insights personalizados com base nas posições e aspectos planetários reais.';

  @override
  String get helpSupportFaq2Q =>
      'Por que preciso do meu horário de nascimento?';

  @override
  String get helpSupportFaq2A =>
      'Seu horário de nascimento determina seu Ascendente (signo ascendente) e as posições das casas em seu mapa. Sem ele, usamos o meio-dia como padrão, o que pode afetar a precisão das interpretações relacionadas às casas.';

  @override
  String get helpSupportFaq3Q =>
      'Como faço para alterar meus dados de nascimento?';

  @override
  String get helpSupportFaq3A =>
      'Atualmente, os dados de nascimento não podem ser alterados após a configuração inicial para garantir consistência em suas leituras. Entre em contato com o suporte se precisar fazer correções.';

  @override
  String get helpSupportFaq4Q => 'O que é um tópico de Foco?';

  @override
  String get helpSupportFaq4A =>
      'Um tópico de Foco é uma preocupação atual ou área da vida que você deseja enfatizar. Quando definido, sua orientação diária prestará atenção especial a essa área, fornecendo insights mais relevantes.';

  @override
  String get helpSupportFaq5Q => 'Como funciona a assinatura?';

  @override
  String get helpSupportFaq5A =>
      'O nível gratuito inclui orientação diária básica. Assinantes premium recebem personalização aprimorada, leituras em áudio e acesso a recursos especiais, como leituras de Astrologia Kármica.';

  @override
  String get helpSupportFaq6Q => 'Meus dados são privados?';

  @override
  String get helpSupportFaq6A =>
      'Sim! Levamos a privacidade a sério. Seus dados de nascimento e informações pessoais são criptografados e nunca compartilhados com terceiros. Você pode excluir sua conta a qualquer momento.';

  @override
  String get helpSupportFaq7Q => 'E se eu discordar de uma leitura?';

  @override
  String get helpSupportFaq7A =>
      'A astrologia é interpretativa, e nem toda leitura ressoará. Use o recurso de feedback para nos ajudar a melhorar. Nossa IA aprende com suas preferências ao longo do tempo.';

  @override
  String get notificationsSaved => 'Configurações de notificação salvas';

  @override
  String get notificationsTitle => 'Notificações';

  @override
  String get notificationsSectionTitle => 'Notificações Push';

  @override
  String get notificationsDailyTitle => 'Orientação Diária';

  @override
  String get notificationsDailySubtitle =>
      'Receba notificações quando sua orientação diária estiver pronta';

  @override
  String get notificationsWeeklyTitle => 'Destaques Semanais';

  @override
  String get notificationsWeeklySubtitle =>
      'Visão cósmica semanal e principais trânsitos';

  @override
  String get notificationsSpecialTitle => 'Eventos Especiais';

  @override
  String get notificationsSpecialSubtitle =>
      'Luas cheias, eclipses e retrógrados';

  @override
  String get notificationsDeviceHint =>
      'Você também pode controlar as notificações nas configurações do seu dispositivo.';

  @override
  String get concernsTitle => 'Seu Foco';

  @override
  String get concernsSubtitle => 'Tópicos que moldam sua orientação';

  @override
  String concernsTabActive(Object count) {
    return 'Ativo ($count)';
  }

  @override
  String concernsTabResolved(Object count) {
    return 'Resolvido ($count)';
  }

  @override
  String concernsTabArchived(Object count) {
    return 'Arquivado ($count)';
  }

  @override
  String get concernsEmptyTitle => 'Nenhuma preocupação aqui';

  @override
  String get concernsEmptySubtitle =>
      'Adicione um tópico de foco para obter orientação personalizada';

  @override
  String get concernsCategoryCareer => 'Carreira e Trabalho';

  @override
  String get concernsCategoryHealth => 'Saúde';

  @override
  String get concernsCategoryRelationship => 'Relacionamento';

  @override
  String get concernsCategoryFamily => 'Família';

  @override
  String get concernsCategoryMoney => 'Dinheiro';

  @override
  String get concernsCategoryBusiness => 'Negócios';

  @override
  String get concernsCategoryPartnership => 'Parceria';

  @override
  String get concernsCategoryGrowth => 'Crescimento Pessoal';

  @override
  String get concernsMinLength =>
      'Por favor, descreva sua preocupação com mais detalhes (pelo menos 10 caracteres)';

  @override
  String get concernsSubmitFailed =>
      'Falha ao enviar a preocupação. Por favor, tente novamente.';

  @override
  String get concernsAddTitle => 'O que está na sua mente?';

  @override
  String get concernsAddDescription =>
      'Compartilhe sua preocupação atual, pergunta ou situação de vida. Nossa IA irá analisá-la e fornecer orientação focada a partir de amanhã.';

  @override
  String get concernsExamplesTitle => 'Exemplos de preocupações:';

  @override
  String get concernsExampleCareer => 'Decisão de mudança de carreira';

  @override
  String get concernsExampleRelationship => 'Desafios de relacionamento';

  @override
  String get concernsExampleFinance => 'Momento de investimento financeiro';

  @override
  String get concernsExampleHealth => 'Foco em saúde e bem-estar';

  @override
  String get concernsExampleGrowth => 'Direção de crescimento pessoal';

  @override
  String get concernsSubmitButton => 'Enviar Preocupação';

  @override
  String get concernsSuccessTitle => 'Preocupação Registrada!';

  @override
  String get concernsCategoryLabel => 'Categoria: ';

  @override
  String get concernsSuccessMessage =>
      'A partir de amanhã, sua orientação diária se concentrará mais neste tópico.';

  @override
  String get concernsViewFocusTopics => 'Ver Meus Tópicos de Foco';

  @override
  String get deleteAccountTitle => 'Excluir Conta';

  @override
  String get deleteAccountHeading => 'Excluir Sua Conta?';

  @override
  String get deleteAccountConfirmError =>
      'Por favor, digite DELETE para confirmar';

  @override
  String get deleteAccountFinalWarningTitle => 'Aviso Final';

  @override
  String get deleteAccountFinalWarningBody =>
      'Esta ação não pode ser desfeita. Todos os seus dados, incluindo:\n\n• Seu perfil e dados de nascimento\n• Mapa natal e interpretações\n• Histórico de orientação diária\n• Contexto pessoal e preferências\n• Todo o conteúdo adquirido\n\nSerão permanentemente excluídos.';

  @override
  String get deleteAccountConfirmButton => 'Excluir Para Sempre';

  @override
  String get deleteAccountSuccess => 'Sua conta foi excluída';

  @override
  String get deleteAccountFailed =>
      'Falha ao excluir a conta. Por favor, tente novamente.';

  @override
  String get deleteAccountPermanentWarning =>
      'Esta ação é permanente e não pode ser desfeita';

  @override
  String get deleteAccountWarningDetail =>
      'Todos os seus dados pessoais, incluindo seu mapa natal, histórico de orientação e quaisquer compras serão permanentemente excluídos.';

  @override
  String get deleteAccountWhatTitle => 'O que será excluído:';

  @override
  String get deleteAccountItemProfile => 'Seu perfil e conta';

  @override
  String get deleteAccountItemBirthData => 'Dados de nascimento e mapa natal';

  @override
  String get deleteAccountItemGuidance =>
      'Todo o histórico de orientação diária';

  @override
  String get deleteAccountItemContext => 'Contexto pessoal e preferências';

  @override
  String get deleteAccountItemKarmic => 'Leituras de astrologia kármica';

  @override
  String get deleteAccountItemPurchases => 'Todo o conteúdo adquirido';

  @override
  String get deleteAccountTypeDelete => 'Digite DELETE para confirmar';

  @override
  String get deleteAccountDeleteHint => 'DELETE';

  @override
  String get deleteAccountButton => 'Excluir Minha Conta';

  @override
  String get deleteAccountCancel => 'Cancelar, manter minha conta';

  @override
  String get learnArticleLoadFailed => 'Falha ao carregar artigo';

  @override
  String get learnContentInEnglish => 'Conteúdo em inglês';

  @override
  String get learnArticlesLoadFailed => 'Falha ao carregar artigos';

  @override
  String get learnArticlesEmpty => 'Nenhum artigo disponível ainda';

  @override
  String get learnContentFallback =>
      'Mostrando conteúdo em inglês (não disponível em seu idioma)';

  @override
  String get checkoutTitle => 'Finalizar Compra';

  @override
  String get checkoutOrderSummary => 'Resumo do Pedido';

  @override
  String get checkoutProTitle => 'Mapa Natal Pro';

  @override
  String get checkoutProSubtitle => 'Interpretações planetárias completas';

  @override
  String get checkoutTotalLabel => 'Total';

  @override
  String get checkoutTotalAmount => '\$9.99 USD';

  @override
  String get checkoutPaymentTitle => 'Integração de Pagamento';

  @override
  String get checkoutPaymentSubtitle =>
      'A integração de Compra Dentro do Aplicativo está sendo finalizada. Por favor, volte em breve!';

  @override
  String get checkoutProcessing => 'Processando...';

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
      'Upgrade auf Premium, um diese Funktion freizuschalten und die personalisierteste Anleitung zu erhalten.';

  @override
  String get contextReviewFailed =>
      'Aktualisierung fehlgeschlagen. Bitte versuchen Sie es erneut.';

  @override
  String get contextReviewTitle => 'Zeit für eine schnelle Überprüfung';

  @override
  String get contextReviewBody =>
      'Es sind 3 Monate vergangen, seit wir Ihren persönlichen Kontext zuletzt aktualisiert haben. Hat sich etwas Wichtiges in Ihrem Leben geändert, das wir wissen sollten?';

  @override
  String get contextReviewHint =>
      'Das hilft uns, Ihnen personalisierte Anleitungen zu geben.';

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
      'Dies löscht Ihr persönliches Kontextprofil. Ihre Anleitung wird weniger personalisiert.';

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
  String get learnPaceTitle => 'In Ihrem Tempo lernen';

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
  String get proNatalFeature1Title => 'Tiefe Persönlichkeits-Einblicke';

  @override
  String get proNatalFeature1Body =>
      'Verstehen Sie, wie jeder Planet Ihre einzigartige Persönlichkeit und Lebensweg prägt.';

  @override
  String get proNatalFeature2Title => 'KI-gestützte Analyse';

  @override
  String get proNatalFeature2Body =>
      'Fortgeschrittene Interpretationen, die auf Ihre genauen planetarischen Positionen zugeschnitten sind.';

  @override
  String get proNatalFeature3Title => 'Umsetzbare Anleitung';

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
  String get proNatalNoSubscription => 'Keine Abonnement erforderlich';
}

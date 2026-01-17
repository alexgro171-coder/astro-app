// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get onboardingSkip => 'Saltar';

  @override
  String get onboardingTitle1 => 'Bienvenido a Inner Wisdom Astro';

  @override
  String get onboardingDesc1 =>
      'Innerwisdom Astro reúne más de 30 años de experiencia astrológica de Madi G. con el poder de la IA avanzada, creando una de las aplicaciones de astrología más refinadas y de alto rendimiento disponibles hoy en día.\n\nAl combinar una profunda comprensión humana con tecnología inteligente, Innerwisdom Astro ofrece interpretaciones que son precisas, personalizadas y significativas, apoyando a los usuarios en su viaje de autodescubrimiento, claridad y crecimiento consciente.';

  @override
  String get onboardingTitle2 => 'Tu Viaje Astrológico Completo';

  @override
  String get onboardingDesc2 =>
      'Desde orientación diaria personalizada hasta tu Carta Natal, Astrología Kármica, informes de personalidad en profundidad, Compatibilidad en Amor y Amistad, Pronósticos Románticos para Parejas, y mucho más: todo está ahora al alcance de tu mano.\n\nDiseñado para apoyar la claridad, la conexión y la autocomprensión, Innerwisdom Astro ofrece una experiencia astrológica completa, adaptada a ti.';

  @override
  String get onboardingNext => 'Siguiente';

  @override
  String get onboardingGetStarted => 'Comenzar';

  @override
  String get onboardingAlreadyHaveAccount =>
      '¿Ya tienes una cuenta? Iniciar sesión';

  @override
  String get birthDataTitle => 'Tu Carta Natal';

  @override
  String get birthDataSubtitle =>
      'Necesitamos tus datos de nacimiento para crear\ntu perfil astrológico personalizado';

  @override
  String get birthDateLabel => 'Fecha de Nacimiento';

  @override
  String get birthDateSelectHint => 'Selecciona tu fecha de nacimiento';

  @override
  String get birthTimeLabel => 'Hora de Nacimiento';

  @override
  String get birthTimeUnknown => 'Desconocido';

  @override
  String get birthTimeSelectHint => 'Selecciona tu hora de nacimiento';

  @override
  String get birthTimeUnknownCheckbox => 'No sé mi hora exacta de nacimiento';

  @override
  String get birthPlaceLabel => 'Lugar de Nacimiento';

  @override
  String get birthPlaceHint => 'Comienza a escribir el nombre de una ciudad...';

  @override
  String get birthPlaceValidation =>
      'Por favor selecciona una ubicación de las sugerencias';

  @override
  String birthPlaceSelected(Object location) {
    return 'Seleccionado: $location';
  }

  @override
  String get genderLabel => 'Género';

  @override
  String get genderMale => 'Masculino';

  @override
  String get genderFemale => 'Femenino';

  @override
  String get genderPreferNotToSay => 'Prefiero no decir';

  @override
  String get birthDataSubmit => 'Generar Mi Carta Natal';

  @override
  String get birthDataPrivacyNote =>
      'Tus datos de nacimiento se utilizan solo para calcular tu\ncarta astrológica y se almacenan de forma segura.';

  @override
  String get birthDateMissing => 'Por favor selecciona tu fecha de nacimiento';

  @override
  String get birthPlaceMissing =>
      'Por favor selecciona un lugar de nacimiento de las sugerencias';

  @override
  String get birthDataSaveError =>
      'No se pudo guardar los datos de nacimiento. Por favor intenta de nuevo.';

  @override
  String get appearanceTitle => 'Apariencia';

  @override
  String get appearanceTheme => 'Tema';

  @override
  String get appearanceDarkTitle => 'Oscuro';

  @override
  String get appearanceDarkSubtitle => 'Fácil para los ojos en poca luz';

  @override
  String get appearanceLightTitle => 'Claro';

  @override
  String get appearanceLightSubtitle => 'Apariencia clásica brillante';

  @override
  String get appearanceSystemTitle => 'Sistema';

  @override
  String get appearanceSystemSubtitle =>
      'Coincide con la configuración de tu dispositivo';

  @override
  String get appearancePreviewTitle => 'Vista Previa';

  @override
  String get appearancePreviewBody =>
      'El tema cósmico está diseñado para crear una experiencia astrológica inmersiva. Se recomienda el tema oscuro para la mejor experiencia visual.';

  @override
  String appearanceThemeChanged(Object theme) {
    return 'Tema cambiado a $theme';
  }

  @override
  String get profileUserFallback => 'Usuario';

  @override
  String get profilePersonalContext => 'Contexto Personal';

  @override
  String get profileSettings => 'Configuraciones';

  @override
  String get profileAppLanguage => 'Idioma de la App';

  @override
  String get profileContentLanguage => 'Idioma del Contenido';

  @override
  String get profileContentLanguageHint =>
      'El contenido de IA utiliza el idioma seleccionado.';

  @override
  String get profileNotifications => 'Notificaciones';

  @override
  String get profileNotificationsEnabled => 'Habilitado';

  @override
  String get profileNotificationsDisabled => 'Deshabilitado';

  @override
  String get profileAppearance => 'Apariencia';

  @override
  String get profileHelpSupport => 'Ayuda y Soporte';

  @override
  String get profilePrivacyPolicy => 'Política de Privacidad';

  @override
  String get profileTermsOfService => 'Términos de Servicio';

  @override
  String get profileLogout => 'Cerrar sesión';

  @override
  String get profileLogoutConfirm =>
      '¿Estás seguro de que quieres cerrar sesión?';

  @override
  String get profileDeleteAccount => 'Eliminar Cuenta';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get profileSelectLanguageTitle => 'Seleccionar Idioma';

  @override
  String get profileSelectLanguageSubtitle =>
      'Todo el contenido generado por IA estará en tu idioma seleccionado.';

  @override
  String profileLanguageUpdated(Object language) {
    return 'Idioma actualizado a $language';
  }

  @override
  String profileLanguageUpdateFailed(Object error) {
    return 'Error al actualizar el idioma: $error';
  }

  @override
  String profileVersion(Object version) {
    return 'Inner Wisdom v$version';
  }

  @override
  String get profileCosmicBlueprint => 'Tu Plano Cósmico';

  @override
  String get profileSunLabel => '☀️ Sol';

  @override
  String get profileMoonLabel => '🌙 Luna';

  @override
  String get profileRisingLabel => '⬆️ Ascendente';

  @override
  String get profileUnknown => 'Desconocido';

  @override
  String get forgotPasswordTitle => '¿Olvidaste tu Contraseña?';

  @override
  String get forgotPasswordSubtitle =>
      'Ingresa tu correo electrónico y te enviaremos un código para restablecer tu contraseña';

  @override
  String get forgotPasswordSent =>
      'Si existe una cuenta, se ha enviado un código de restablecimiento a tu correo electrónico.';

  @override
  String get forgotPasswordFailed =>
      'Error al enviar el código de restablecimiento. Por favor intenta de nuevo.';

  @override
  String get forgotPasswordSendCode => 'Enviar Código de Restablecimiento';

  @override
  String get forgotPasswordHaveCode => '¿Ya tienes un código?';

  @override
  String get forgotPasswordRemember => '¿Recuerdas tu contraseña? ';

  @override
  String get loginWelcomeBack => 'Bienvenido de nuevo';

  @override
  String get loginSubtitle => 'Inicia sesión para continuar tu viaje cósmico';

  @override
  String get loginInvalidCredentials =>
      'Correo electrónico o contraseña inválidos';

  @override
  String get loginGoogleFailed =>
      'Error al iniciar sesión con Google. Por favor intenta de nuevo.';

  @override
  String get loginAppleFailed =>
      'Error al iniciar sesión con Apple. Por favor intenta de nuevo.';

  @override
  String get loginNetworkError =>
      'Error de red. Por favor verifica tu conexión.';

  @override
  String get loginSignInCancelled => 'La sesión fue cancelada.';

  @override
  String get loginPasswordHint => 'Ingresa tu contraseña';

  @override
  String get loginForgotPassword => '¿Olvidaste tu Contraseña?';

  @override
  String get loginSignIn => 'Iniciar Sesión';

  @override
  String get loginNoAccount => '¿No tienes una cuenta? ';

  @override
  String get loginSignUp => 'Registrarse';

  @override
  String get commonEmailLabel => 'Correo Electrónico';

  @override
  String get commonEmailHint => 'Ingresa tu correo electrónico';

  @override
  String get commonEmailRequired => 'Por favor ingresa tu correo electrónico';

  @override
  String get commonEmailInvalid =>
      'Por favor ingresa un correo electrónico válido';

  @override
  String get commonPasswordLabel => 'Contraseña';

  @override
  String get commonPasswordRequired => 'Por favor ingresa tu contraseña';

  @override
  String get commonOrContinueWith => 'o continuar con';

  @override
  String get commonGoogle => 'Google';

  @override
  String get commonApple => 'Apple';

  @override
  String get commonNameLabel => 'Nombre';

  @override
  String get commonNameHint => 'Ingresa tu nombre';

  @override
  String get commonNameRequired => 'Por favor ingresa tu nombre';

  @override
  String get signupTitle => 'Crear Cuenta';

  @override
  String get signupSubtitle => 'Comienza tu viaje cósmico con Inner Wisdom';

  @override
  String get signupEmailExists =>
      'El correo electrónico ya existe o los datos son inválidos';

  @override
  String get signupGoogleFailed =>
      'Error al iniciar sesión con Google. Por favor, inténtalo de nuevo.';

  @override
  String get signupAppleFailed =>
      'Error al iniciar sesión con Apple. Por favor, inténtalo de nuevo.';

  @override
  String get signupPasswordHint => 'Crea una contraseña (mín. 8 caracteres)';

  @override
  String get signupPasswordMin =>
      'La contraseña debe tener al menos 8 caracteres';

  @override
  String get signupConfirmPasswordLabel => 'Confirmar Contraseña';

  @override
  String get signupConfirmPasswordHint => 'Confirma tu contraseña';

  @override
  String get signupConfirmPasswordRequired =>
      'Por favor, confirma tu contraseña';

  @override
  String get signupPasswordMismatch => 'Las contraseñas no coinciden';

  @override
  String get signupPreferredLanguage => 'Idioma Preferido';

  @override
  String get signupCreateAccount => 'Crear Cuenta';

  @override
  String get signupHaveAccount => '¿Ya tienes una cuenta? ';

  @override
  String get resetPasswordTitle => 'Restablecer Contraseña';

  @override
  String get resetPasswordSubtitle =>
      'Ingresa el código enviado a tu correo electrónico y establece una nueva contraseña';

  @override
  String get resetPasswordSuccess =>
      '¡Restablecimiento de contraseña exitoso! Redirigiendo a inicio de sesión...';

  @override
  String get resetPasswordFailed =>
      'Error al restablecer la contraseña. Por favor, inténtalo de nuevo.';

  @override
  String get resetPasswordInvalidCode =>
      'Código de restablecimiento inválido o expirado. Por favor, solicita uno nuevo.';

  @override
  String get resetPasswordMaxAttempts =>
      'Se ha superado el número máximo de intentos. Por favor, solicita un nuevo código.';

  @override
  String get resetCodeLabel => 'Código de Restablecimiento';

  @override
  String get resetCodeHint => 'Ingresa el código de 6 dígitos';

  @override
  String get resetCodeRequired =>
      'Por favor, ingresa el código de restablecimiento';

  @override
  String get resetCodeLength => 'El código debe tener 6 dígitos';

  @override
  String get resetNewPasswordLabel => 'Nueva Contraseña';

  @override
  String get resetNewPasswordHint =>
      'Crea una nueva contraseña (mín. 8 caracteres)';

  @override
  String get resetNewPasswordRequired =>
      'Por favor, ingresa una nueva contraseña';

  @override
  String get resetConfirmPasswordHint => 'Confirma tu nueva contraseña';

  @override
  String get resetPasswordButton => 'Restablecer Contraseña';

  @override
  String get resetRequestNewCode => 'Solicitar un nuevo código';

  @override
  String get serviceResultGenerated => 'Informe Generado';

  @override
  String serviceResultReady(Object title) {
    return 'Tu $title personalizado está listo';
  }

  @override
  String get serviceResultBackToForYou => 'Volver a Para Ti';

  @override
  String get serviceResultNotSavedNotice =>
      'Este Informe no se guardará. Si lo deseas, puedes copiarlo y guardarlo en otro lugar utilizando la función Copiar.';

  @override
  String get commonCopy => 'Copiar';

  @override
  String get commonCopied => 'Copiado al portapapeles';

  @override
  String get commonContinue => 'Continuar';

  @override
  String get partnerDetailsTitle => 'Detalles del Pareja';

  @override
  String get partnerBirthDataTitle =>
      'Ingresa los datos de nacimiento del pareja';

  @override
  String partnerBirthDataFor(Object title) {
    return 'Para \"$title\"';
  }

  @override
  String get partnerNameOptionalLabel => 'Nombre (opcional)';

  @override
  String get partnerNameHint => 'Nombre del pareja';

  @override
  String get partnerGenderOptionalLabel => 'Género (opcional)';

  @override
  String get partnerBirthDateLabel => 'Fecha de Nacimiento *';

  @override
  String get partnerBirthDateSelect => 'Seleccionar fecha de nacimiento';

  @override
  String get partnerBirthDateMissing =>
      'Por favor, selecciona la fecha de nacimiento';

  @override
  String get partnerBirthTimeOptionalLabel => 'Hora de Nacimiento (opcional)';

  @override
  String get partnerBirthTimeSelect => 'Seleccionar hora de nacimiento';

  @override
  String get partnerBirthPlaceLabel => 'Lugar de Nacimiento *';

  @override
  String get serviceOfferRequiresPartner =>
      'Requiere datos de nacimiento del pareja';

  @override
  String get serviceOfferBetaFree =>
      '¡Los beta testers obtienen acceso gratuito!';

  @override
  String get serviceOfferUnlocked => 'Desbloqueado';

  @override
  String get serviceOfferGenerate => 'Generar Informe';

  @override
  String serviceOfferUnlockFor(Object price) {
    return 'Desbloquear por $price';
  }

  @override
  String get serviceOfferPreparing => 'Preparando tu informe personalizado…';

  @override
  String get serviceOfferTimeout =>
      'Tardando más de lo esperado. Por favor, inténtalo de nuevo.';

  @override
  String get serviceOfferNotReady =>
      'Informe aún no listo. Por favor, inténtalo de nuevo.';

  @override
  String serviceOfferFetchFailed(Object error) {
    return 'Error al obtener el informe: $error';
  }

  @override
  String get commonFree => 'GRATIS';

  @override
  String get commonLater => 'Más tarde';

  @override
  String get commonRetry => 'Reintentar';

  @override
  String get commonYes => 'Sí';

  @override
  String get commonNo => 'No';

  @override
  String get commonBack => 'Atrás';

  @override
  String get commonOptional => 'Opcional';

  @override
  String get commonNotSpecified => 'No especificado';

  @override
  String get commonJustNow => 'Justo ahora';

  @override
  String get commonViewMore => 'Ver más';

  @override
  String get commonViewLess => 'Ver menos';

  @override
  String commonMinutesAgo(Object count) {
    return 'hace $count min';
  }

  @override
  String commonHoursAgo(Object count) {
    return 'hace ${count}h';
  }

  @override
  String commonDaysAgo(Object count) {
    return 'hace ${count}d';
  }

  @override
  String commonDateShort(Object day, Object month, Object year) {
    return '$day/$month/$year';
  }

  @override
  String get askGuideTitle => 'Pregunta a Tu Guía';

  @override
  String get askGuideSubtitle => 'Guía cósmica personal';

  @override
  String askGuideRemaining(Object count) {
    return '$count restantes';
  }

  @override
  String get askGuideQuestionHint =>
      'Pregunta cualquier cosa - amor, carrera, decisiones, emociones...';

  @override
  String get askGuideBasedOnChart =>
      'Basado en tu carta natal y las energías cósmicas de hoy';

  @override
  String get askGuideThinking => 'Tu Guía está pensando...';

  @override
  String get askGuideYourGuide => 'Tu Guía';

  @override
  String get askGuideEmptyTitle => 'Haz Tu Primera Pregunta';

  @override
  String get askGuideEmptyBody =>
      'Obtén orientación instantánea y profundamente personal basada en tu carta natal y las energías cósmicas de hoy.';

  @override
  String get askGuideEmptyHint =>
      'Pregunta cualquier cosa — amor, carrera, decisiones, emociones.';

  @override
  String get askGuideLoadFailed => 'Error al cargar datos';

  @override
  String askGuideSendFailed(Object error) {
    return 'Error al enviar la pregunta: $error';
  }

  @override
  String get askGuideLimitTitle => 'Límite Mensual Alcanzado';

  @override
  String get askGuideLimitBody =>
      'Has alcanzado tu límite mensual de solicitudes.';

  @override
  String get askGuideLimitAddon =>
      'Puedes comprar un complemento de \$1.99 para seguir utilizando este servicio durante el resto del mes de facturación actual.';

  @override
  String askGuideLimitBillingEnd(Object date) {
    return 'Tu mes de facturación termina el: $date';
  }

  @override
  String get askGuideLimitGetAddon => 'Obtener complemento';

  @override
  String get contextTitle => 'Contexto Personal';

  @override
  String contextStepOf(Object current, Object total) {
    return 'Paso $current de $total';
  }

  @override
  String get contextStep1Title => 'Personas a tu alrededor';

  @override
  String get contextStep1Subtitle =>
      'Tu contexto de relaciones y familia nos ayuda a entender tu paisaje emocional.';

  @override
  String get contextStep2Title => 'Vida Profesional';

  @override
  String get contextStep2Subtitle =>
      'Tu trabajo y ritmo diario moldean cómo experimentas la presión, el crecimiento y el propósito.';

  @override
  String get contextStep3Title => 'Cómo se siente la vida ahora mismo';

  @override
  String get contextStep3Subtitle =>
      'No hay respuestas correctas o incorrectas, solo tu realidad actual';

  @override
  String get contextStep4Title => 'Lo que más te importa';

  @override
  String get contextStep4Subtitle =>
      'Para que tu orientación se alinee con lo que realmente te importa';

  @override
  String get contextPriorityRequired =>
      'Por favor, selecciona al menos un área de prioridad.';

  @override
  String contextSaveFailed(Object error) {
    return 'Error al guardar el perfil: $error';
  }

  @override
  String get contextSaveContinue => 'Guardar y continuar';

  @override
  String get contextRelationshipStatusTitle => 'Estado actual de la relación';

  @override
  String get contextSeekingRelationshipTitle => '¿Estás buscando una relación?';

  @override
  String get contextHasChildrenTitle => '¿Tienes hijos?';

  @override
  String get contextChildrenDetailsOptional =>
      'Detalles de los hijos (opcional)';

  @override
  String get contextAddChild => 'Agregar hijo';

  @override
  String get contextChildAgeLabel => 'Edad';

  @override
  String contextChildAgeYears(num age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other: 'años',
      one: 'año',
    );
    return '$age $_temp0';
  }

  @override
  String get contextChildGenderLabel => 'Género';

  @override
  String get contextRelationshipSingle => 'Soltero';

  @override
  String get contextRelationshipInRelationship => 'En una relación';

  @override
  String get contextRelationshipMarried => 'Casado / Pareja de hecho';

  @override
  String get contextRelationshipSeparated => 'Separado / Divorciado';

  @override
  String get contextRelationshipWidowed => 'Viudo';

  @override
  String get contextRelationshipPreferNotToSay => 'Prefiero no decirlo';

  @override
  String get contextProfessionalStatusTitle => 'Estado profesional actual';

  @override
  String get contextProfessionalStatusOtherHint =>
      'Por favor especifica tu estado laboral';

  @override
  String get contextIndustryTitle => 'Industria/dominio principal';

  @override
  String get contextWorkStatusStudent => 'Estudiante';

  @override
  String get contextWorkStatusUnemployed => 'Desempleado / Entre trabajos';

  @override
  String get contextWorkStatusEmployedIc =>
      'Empleado (Contribuyente individual)';

  @override
  String get contextWorkStatusEmployedManagement => 'Empleado (Gestión)';

  @override
  String get contextWorkStatusExecutive => 'Ejecutivo / Liderazgo (nivel C)';

  @override
  String get contextWorkStatusSelfEmployed => 'Autónomo / Freelance';

  @override
  String get contextWorkStatusEntrepreneur =>
      'Emprendedor / Propietario de negocio';

  @override
  String get contextWorkStatusInvestor => 'Inversor';

  @override
  String get contextWorkStatusRetired => 'Jubilado';

  @override
  String get contextWorkStatusHomemaker =>
      'Ama de casa / Padre que se queda en casa';

  @override
  String get contextWorkStatusCareerBreak => 'Descanso profesional / Sabático';

  @override
  String get contextWorkStatusOther => 'Otro';

  @override
  String get contextIndustryTech => 'Tecnología / TI';

  @override
  String get contextIndustryFinance => 'Finanzas / Inversiones';

  @override
  String get contextIndustryHealthcare => 'Salud';

  @override
  String get contextIndustryEducation => 'Educación';

  @override
  String get contextIndustrySalesMarketing => 'Ventas / Marketing';

  @override
  String get contextIndustryRealEstate => 'Bienes raíces';

  @override
  String get contextIndustryHospitality => 'Hospitalidad';

  @override
  String get contextIndustryGovernment => 'Gobierno / Sector público';

  @override
  String get contextIndustryCreative => 'Industrias creativas';

  @override
  String get contextIndustryOther => 'Otro';

  @override
  String get contextSelfAssessmentIntro =>
      'Evalúa tu situación actual en cada área (1 = luchando, 5 = prosperando)';

  @override
  String get contextSelfHealthTitle => 'Salud y energía';

  @override
  String get contextSelfHealthSubtitle =>
      '1 = problemas graves/baja energía, 5 = excelente vitalidad';

  @override
  String get contextSelfSocialTitle => 'Vida social';

  @override
  String get contextSelfSocialSubtitle =>
      '1 = aislado, 5 = conexiones sociales prósperas';

  @override
  String get contextSelfRomanceTitle => 'Vida romántica';

  @override
  String get contextSelfRomanceSubtitle =>
      '1 = ausente/desafiante, 5 = realizado';

  @override
  String get contextSelfFinanceTitle => 'Estabilidad financiera';

  @override
  String get contextSelfFinanceSubtitle =>
      '1 = dificultades importantes, 5 = excelente';

  @override
  String get contextSelfCareerTitle => 'Satisfacción profesional';

  @override
  String get contextSelfCareerSubtitle =>
      '1 = estancado/estresado, 5 = progreso/claridad';

  @override
  String get contextSelfGrowthTitle => 'Interés en el crecimiento personal';

  @override
  String get contextSelfGrowthSubtitle => '1 = bajo interés, 5 = muy alto';

  @override
  String get contextSelfStruggling => 'Luchando';

  @override
  String get contextSelfThriving => 'Prosperando';

  @override
  String get contextPrioritiesTitle =>
      '¿Cuáles son tus principales prioridades en este momento?';

  @override
  String get contextPrioritiesSubtitle =>
      'Selecciona hasta 2 áreas en las que deseas enfocarte';

  @override
  String get contextGuidanceStyleTitle => 'Estilo de orientación preferido';

  @override
  String get contextSensitivityTitle => 'Modo de sensibilidad';

  @override
  String get contextSensitivitySubtitle =>
      'Evitar frases que induzcan ansiedad o deterministas en la orientación';

  @override
  String get contextPriorityHealth => 'Salud y hábitos';

  @override
  String get contextPriorityCareer => 'Crecimiento profesional';

  @override
  String get contextPriorityBusiness => 'Decisiones empresariales';

  @override
  String get contextPriorityMoney => 'Dinero y estabilidad';

  @override
  String get contextPriorityLove => 'Amor y relación';

  @override
  String get contextPriorityFamily => 'Familia y crianza';

  @override
  String get contextPrioritySocial => 'Vida social';

  @override
  String get contextPriorityGrowth => 'Crecimiento personal / mentalidad';

  @override
  String get contextGuidanceStyleDirect => 'Directo y práctico';

  @override
  String get contextGuidanceStyleDirectDesc =>
      'Ve directo a consejos prácticos';

  @override
  String get contextGuidanceStyleEmpathetic => 'Empático y reflexivo';

  @override
  String get contextGuidanceStyleEmpatheticDesc =>
      'Orientación cálida y de apoyo';

  @override
  String get contextGuidanceStyleBalanced => 'Equilibrado';

  @override
  String get contextGuidanceStyleBalancedDesc =>
      'Mezcla de apoyo práctico y emocional';

  @override
  String get homeGuidancePreparing =>
      'Leyendo las estrellas y preguntando al Universo sobre ti...';

  @override
  String get homeGuidanceFailed =>
      'No se pudo generar la orientación. Por favor, inténtalo de nuevo.';

  @override
  String get homeGuidanceTimeout =>
      'Tomando más tiempo del esperado. Toca Reintentar o vuelve en un momento.';

  @override
  String get homeGuidanceLoadFailed => 'No se pudo cargar la orientación';

  @override
  String get homeTodaysGuidance => 'Orientación de hoy';

  @override
  String get homeSeeAll => 'Ver todo';

  @override
  String get homeHealth => 'Salud';

  @override
  String get homeCareer => 'Carrera';

  @override
  String get homeMoney => 'Dinero';

  @override
  String get homeLove => 'Amor';

  @override
  String get homePartners => 'Parejas';

  @override
  String get homeGrowth => 'Crecimiento';

  @override
  String get homeTraveler => 'Viajero';

  @override
  String homeGreeting(Object name) {
    return 'Hola, $name';
  }

  @override
  String get homeFocusFallback => 'Crecimiento personal';

  @override
  String get homeDailyMessage => 'Tu mensaje diario';

  @override
  String get homeNatalChartTitle => 'Mi carta natal';

  @override
  String get homeNatalChartSubtitle =>
      'Explora tu carta natal e interpretaciones';

  @override
  String get navHome => 'Inicio';

  @override
  String get navHistory => 'Historial';

  @override
  String get navGuide => 'Guía';

  @override
  String get navProfile => 'Perfil';

  @override
  String get navForYou => 'Para ti';

  @override
  String get commonToday => 'Hoy';

  @override
  String get commonTryAgain => 'Inténtalo de nuevo';

  @override
  String get natalChartTitle => 'Mi carta natal';

  @override
  String get natalChartTabTable => 'Tabla';

  @override
  String get natalChartTabChart => 'Gráfico';

  @override
  String get natalChartEmptyTitle => 'No hay datos de la carta natal';

  @override
  String get natalChartEmptySubtitle =>
      'Por favor completa tus datos de nacimiento para ver tu carta natal.';

  @override
  String get natalChartAddBirthData => 'Agregar datos de nacimiento';

  @override
  String get natalChartErrorTitle => 'No se pudo cargar el gráfico';

  @override
  String get guidanceTitle => 'Orientación Diaria';

  @override
  String get guidanceLoadFailed => 'Error al cargar la orientación';

  @override
  String get guidanceNoneAvailable => 'No hay orientación disponible';

  @override
  String get guidanceCosmicEnergyTitle => 'La Energía Cósmica de Hoy';

  @override
  String get guidanceMoodLabel => 'Estado de Ánimo';

  @override
  String get guidanceFocusLabel => 'Enfoque';

  @override
  String get guidanceYourGuidance => 'Tu Orientación';

  @override
  String get guidanceTapToCollapse => 'Toca para colapsar';

  @override
  String get historyTitle => 'Historial de Orientación';

  @override
  String get historySubtitle => 'Tu viaje cósmico a través del tiempo';

  @override
  String get historyLoadFailed => 'Error al cargar el historial';

  @override
  String get historyEmptyTitle => 'Aún no hay historial';

  @override
  String get historyEmptySubtitle =>
      'Tus orientaciones diarias aparecerán aquí';

  @override
  String get historyNewBadge => 'NUEVO';

  @override
  String get commonUnlocked => 'Desbloqueado';

  @override
  String get commonComingSoon => 'Próximamente';

  @override
  String get commonSomethingWentWrong => 'Algo salió mal';

  @override
  String get commonNoContent => 'No hay contenido disponible.';

  @override
  String get commonUnknownError => 'Error desconocido';

  @override
  String get commonTakingLonger =>
      'Tomando más tiempo de lo esperado. Por favor, intenta de nuevo.';

  @override
  String commonErrorWithMessage(Object error) {
    return 'Error: $error';
  }

  @override
  String get forYouTitle => 'Para Ti';

  @override
  String get forYouSubtitle => 'Perspectivas cósmicas personalizadas';

  @override
  String get forYouNatalChartTitle => 'Mi Carta Natal';

  @override
  String get forYouNatalChartSubtitle => 'Análisis de tu carta natal';

  @override
  String get forYouCompatibilitiesTitle => 'Compatibilidades';

  @override
  String get forYouCompatibilitiesSubtitle =>
      'Informes de amor, amistad y asociación';

  @override
  String get forYouKarmicTitle => 'Astrología Kármica';

  @override
  String get forYouKarmicSubtitle =>
      'Lecciones del alma y patrones de vidas pasadas';

  @override
  String get forYouLearnTitle => 'Aprender Astrología';

  @override
  String get forYouLearnSubtitle => 'Contenido educativo gratuito';

  @override
  String get compatibilitiesTitle => 'Compatibilidades';

  @override
  String get compatibilitiesLoadFailed => 'Error al cargar los servicios';

  @override
  String get compatibilitiesBetaFree => 'Beta: ¡Todos los informes son GRATIS!';

  @override
  String get compatibilitiesChooseReport => 'Elige un Informe';

  @override
  String get compatibilitiesSubtitle =>
      'Descubre perspectivas sobre ti mismo y tus relaciones';

  @override
  String get compatibilitiesPartnerBadge => '+Pareja';

  @override
  String get compatibilitiesPersonalityTitle => 'Informe de Personalidad';

  @override
  String get compatibilitiesPersonalitySubtitle =>
      'Análisis completo de tu personalidad basado en tu carta natal';

  @override
  String get compatibilitiesRomanticPersonalityTitle =>
      'Informe de Personalidad Romántica';

  @override
  String get compatibilitiesRomanticPersonalitySubtitle =>
      'Entiende cómo te acercas al amor y al romance';

  @override
  String get compatibilitiesLoveCompatibilityTitle => 'Compatibilidad Amorosa';

  @override
  String get compatibilitiesLoveCompatibilitySubtitle =>
      'Análisis detallado de la compatibilidad romántica con tu pareja';

  @override
  String get compatibilitiesRomanticForecastTitle =>
      'Pronóstico de Pareja Romántica';

  @override
  String get compatibilitiesRomanticForecastSubtitle =>
      'Perspectivas sobre el futuro de tu relación';

  @override
  String get compatibilitiesFriendshipTitle => 'Informe de Amistad';

  @override
  String get compatibilitiesFriendshipSubtitle =>
      'Analiza la dinámica y compatibilidad de la amistad';

  @override
  String get moonPhaseTitle => 'Informe de Fase Lunar';

  @override
  String get moonPhaseSubtitle =>
      'Entiende la energía lunar actual y cómo te afecta. Obtén orientación alineada con la fase de la luna.';

  @override
  String get moonPhaseSelectDate => 'Seleccionar Fecha';

  @override
  String get moonPhaseOriginalPrice => '\$2.99';

  @override
  String get moonPhaseGenerate => 'Generar Informe';

  @override
  String get moonPhaseGenerateDifferentDate => 'Generar para Fecha Diferente';

  @override
  String get moonPhaseGenerationFailed => 'Generación fallida';

  @override
  String get moonPhaseGenerating =>
      'El informe se está generando. Por favor, intenta de nuevo.';

  @override
  String get moonPhaseUnknownError =>
      'Algo salió mal. Por favor, intenta de nuevo.';

  @override
  String get requiredFieldsNote =>
      'Los campos marcados con * son obligatorios.';

  @override
  String get karmicTitle => 'Astrología Kármica';

  @override
  String karmicLoadFailed(Object error) {
    return 'Error al cargar: $error';
  }

  @override
  String get karmicOfferTitle => '🔮 Astrología Kármica – Mensajes del Alma';

  @override
  String get karmicOfferBody =>
      'La Astrología Kármica revela los patrones profundos que dan forma a tu vida, más allá de los eventos cotidianos.\n\nOfrece una interpretación que habla sobre lecciones no resueltas, conexiones kármicas y el camino de crecimiento del alma.\n\nEsto no se trata de lo que viene después,\nsino de por qué estás experimentando lo que experimentas.\n\n✨ Activa la Astrología Kármica y descubre el significado más profundo de tu viaje.';

  @override
  String get karmicBetaFreeBadge => 'Beta Testers – ¡Acceso GRATIS!';

  @override
  String karmicPriceBeta(Object price) {
    return '\$$price – Beta Testers Gratis';
  }

  @override
  String karmicPriceUnlock(Object price) {
    return 'Desbloquear por \$$price';
  }

  @override
  String get karmicHintInstant => 'Tu lectura se generará instantáneamente';

  @override
  String get karmicHintOneTime => 'Compra única, sin suscripción';

  @override
  String get karmicProgressHint => 'Conectando con tu camino kármico…';

  @override
  String karmicGenerateFailed(Object error) {
    return 'Error al generar: $error';
  }

  @override
  String get karmicCheckoutTitle => 'Pago de Astrología Kármica';

  @override
  String get karmicCheckoutSubtitle => 'Flujo de compra próximamente';

  @override
  String karmicGenerationFailed(Object error) {
    return 'Generación fallida: $error';
  }

  @override
  String get karmicLoading => 'Cargando tu lectura kármica...';

  @override
  String get karmicGenerationFailedShort => 'Generación fallida';

  @override
  String get karmicGeneratingTitle => 'Generando Tu Lectura Kármica...';

  @override
  String get karmicGeneratingSubtitle =>
      'Analizando tu carta natal para patrones kármicos y lecciones del alma.';

  @override
  String get karmicReadingTitle => '🔮 Tu Lectura Kármica';

  @override
  String get karmicReadingSubtitle => 'Mensajes del Alma';

  @override
  String get karmicDisclaimer =>
      'Esta lectura es para auto-reflexión y entretenimiento. No constituye asesoramiento profesional.';

  @override
  String get commonActive => 'Activo';

  @override
  String get commonBackToHome => 'Volver a Inicio';

  @override
  String get commonYesterday => 'ayer';

  @override
  String commonWeeksAgo(Object count) {
    return '$count semanas atrás';
  }

  @override
  String commonMonthsAgo(Object count) {
    return '$count meses atrás';
  }

  @override
  String get commonEdit => 'Editar';

  @override
  String get commonDelete => 'Eliminar';

  @override
  String get natalChartProGenerated =>
      '¡Interpretaciones Pro generadas! Desplázate hacia arriba para verlas.';

  @override
  String get natalChartHouse1 => 'Yo e Identidad';

  @override
  String get natalChartHouse2 => 'Dinero y Valores';

  @override
  String get natalChartHouse3 => 'Comunicación';

  @override
  String get natalChartHouse4 => 'Hogar y Familia';

  @override
  String get natalChartHouse5 => 'Creatividad y Romance';

  @override
  String get natalChartHouse6 => 'Salud y Rutina';

  @override
  String get natalChartHouse7 => 'Relaciones';

  @override
  String get natalChartHouse8 => 'Transformación';

  @override
  String get natalChartHouse9 => 'Filosofía y Viajes';

  @override
  String get natalChartHouse10 => 'Carrera y Estado';

  @override
  String get natalChartHouse11 => 'Amigos y Metas';

  @override
  String get natalChartHouse12 => 'Espiritualidad';

  @override
  String get helpSupportTitle => 'Ayuda y Soporte';

  @override
  String get helpSupportContactTitle => 'Contactar Soporte';

  @override
  String get helpSupportContactSubtitle =>
      'Normalmente respondemos en 24 horas';

  @override
  String get helpSupportFaqTitle => 'Preguntas Frecuentes';

  @override
  String get helpSupportEmailSubject => 'Solicitud de Soporte de Inner Wisdom';

  @override
  String get helpSupportEmailAppFailed =>
      'No se pudo abrir la aplicación de correo. Por favor, envía un correo a support@innerwisdomapp.com';

  @override
  String get helpSupportEmailFallback =>
      'Por favor, envíanos un correo a support@innerwisdomapp.com';

  @override
  String get helpSupportFaq1Q => '¿Qué tan precisa es la guía diaria?';

  @override
  String get helpSupportFaq1A =>
      'Nuestra guía diaria combina principios astrológicos tradicionales con tu carta natal personal. Si bien la astrología es interpretativa, nuestra IA proporciona información personalizada basada en posiciones y aspectos planetarios reales.';

  @override
  String get helpSupportFaq2Q => '¿Por qué necesito mi hora de nacimiento?';

  @override
  String get helpSupportFaq2A =>
      'Tu hora de nacimiento determina tu Ascendente (signo ascendente) y las posiciones de las casas en tu carta. Sin ella, usamos el mediodía como predeterminado, lo que puede afectar la precisión de las interpretaciones relacionadas con las casas.';

  @override
  String get helpSupportFaq3Q => '¿Cómo cambio mis datos de nacimiento?';

  @override
  String get helpSupportFaq3A =>
      'Actualmente, los datos de nacimiento no se pueden cambiar después de la configuración inicial para garantizar la consistencia en tus lecturas. Contacta al soporte si necesitas hacer correcciones.';

  @override
  String get helpSupportFaq4Q => '¿Qué es un tema de Enfoque?';

  @override
  String get helpSupportFaq4A =>
      'Un tema de Enfoque es una preocupación actual o área de vida que deseas enfatizar. Cuando se establece, tu guía diaria prestará especial atención a esta área, proporcionando información más relevante.';

  @override
  String get helpSupportFaq5Q => '¿Cómo funciona la suscripción?';

  @override
  String get helpSupportFaq5A =>
      'El nivel gratuito incluye guía diaria básica. Los suscriptores premium obtienen personalización mejorada, lecturas de audio y acceso a funciones especiales como lecturas de Astrología Kármica.';

  @override
  String get helpSupportFaq6Q => '¿Mis datos son privados?';

  @override
  String get helpSupportFaq6A =>
      '¡Sí! Tomamos la privacidad en serio. Tus datos de nacimiento e información personal están encriptados y nunca se comparten con terceros. Puedes eliminar tu cuenta en cualquier momento.';

  @override
  String get helpSupportFaq7Q =>
      '¿Qué pasa si no estoy de acuerdo con una lectura?';

  @override
  String get helpSupportFaq7A =>
      'La astrología es interpretativa, y no todas las lecturas resonarán. Usa la función de retroalimentación para ayudarnos a mejorar. Nuestra IA aprende de tus preferencias con el tiempo.';

  @override
  String get notificationsSaved => 'Configuraciones de notificación guardadas';

  @override
  String get notificationsTitle => 'Notificaciones';

  @override
  String get notificationsSectionTitle => 'Notificaciones Push';

  @override
  String get notificationsDailyTitle => 'Guía Diaria';

  @override
  String get notificationsDailySubtitle =>
      'Recibe notificaciones cuando tu guía diaria esté lista';

  @override
  String get notificationsWeeklyTitle => 'Destacados Semanales';

  @override
  String get notificationsWeeklySubtitle =>
      'Resumen cósmico semanal y tránsitos clave';

  @override
  String get notificationsSpecialTitle => 'Eventos Especiales';

  @override
  String get notificationsSpecialSubtitle =>
      'Lunas llenas, eclipses y retrógrados';

  @override
  String get notificationsDeviceHint =>
      'También puedes controlar las notificaciones en la configuración de tu dispositivo.';

  @override
  String get concernsTitle => 'Tu Enfoque';

  @override
  String get concernsSubtitle => 'Temas que dan forma a tu guía';

  @override
  String concernsTabActive(Object count) {
    return 'Activo ($count)';
  }

  @override
  String concernsTabResolved(Object count) {
    return 'Resuelto ($count)';
  }

  @override
  String concernsTabArchived(Object count) {
    return 'Archivado ($count)';
  }

  @override
  String get concernsEmptyTitle => 'No hay preocupaciones aquí';

  @override
  String get concernsEmptySubtitle =>
      'Agrega un tema de enfoque para obtener guía personalizada';

  @override
  String get concernsCategoryCareer => 'Carrera y Trabajo';

  @override
  String get concernsCategoryHealth => 'Salud';

  @override
  String get concernsCategoryRelationship => 'Relación';

  @override
  String get concernsCategoryFamily => 'Familia';

  @override
  String get concernsCategoryMoney => 'Dinero';

  @override
  String get concernsCategoryBusiness => 'Negocios';

  @override
  String get concernsCategoryPartnership => 'Asociación';

  @override
  String get concernsCategoryGrowth => 'Crecimiento Personal';

  @override
  String get concernsMinLength =>
      'Por favor describe tu preocupación con más detalle (al menos 10 caracteres)';

  @override
  String get concernsSubmitFailed =>
      'Error al enviar la preocupación. Por favor, intenta de nuevo.';

  @override
  String get concernsAddTitle => '¿Qué tienes en mente?';

  @override
  String get concernsAddDescription =>
      'Comparte tu preocupación actual, pregunta o situación de vida. Nuestra IA la analizará y proporcionará guía enfocada a partir de mañana.';

  @override
  String get concernsExamplesTitle => 'Ejemplos de preocupaciones:';

  @override
  String get concernsExampleCareer => 'Decisión de cambio de carrera';

  @override
  String get concernsExampleRelationship => 'Desafíos en la relación';

  @override
  String get concernsExampleFinance => 'Momento de inversión financiera';

  @override
  String get concernsExampleHealth => 'Enfoque en salud y bienestar';

  @override
  String get concernsExampleGrowth => 'Dirección de crecimiento personal';

  @override
  String get concernsSubmitButton => 'Enviar Preocupación';

  @override
  String get concernsSuccessTitle => '¡Preocupación Registrada!';

  @override
  String get concernsCategoryLabel => 'Categoría: ';

  @override
  String get concernsSuccessMessage =>
      'A partir de mañana, tu guía diaria se centrará más en este tema.';

  @override
  String get concernsViewFocusTopics => 'Ver Mis Temas de Enfoque';

  @override
  String get deleteAccountTitle => 'Eliminar Cuenta';

  @override
  String get deleteAccountHeading => '¿Eliminar Tu Cuenta?';

  @override
  String get deleteAccountConfirmError =>
      'Por favor escribe DELETE para confirmar';

  @override
  String get deleteAccountFinalWarningTitle => 'Advertencia Final';

  @override
  String get deleteAccountFinalWarningBody =>
      'Esta acción no se puede deshacer. Todos tus datos, incluyendo:\n\n• Tu perfil y datos de nacimiento\n• Carta natal e interpretaciones\n• Historial de guía diaria\n• Contexto personal y preferencias\n• Todo el contenido comprado\n\nSe eliminarán permanentemente.';

  @override
  String get deleteAccountConfirmButton => 'Eliminar Para Siempre';

  @override
  String get deleteAccountSuccess => 'Tu cuenta ha sido eliminada';

  @override
  String get deleteAccountFailed =>
      'Error al eliminar la cuenta. Por favor, intenta de nuevo.';

  @override
  String get deleteAccountPermanentWarning =>
      'Esta acción es permanente y no se puede deshacer';

  @override
  String get deleteAccountWarningDetail =>
      'Todos tus datos personales, incluyendo tu carta natal, historial de guía y cualquier compra serán eliminados permanentemente.';

  @override
  String get deleteAccountWhatTitle => '¿Qué se eliminará:';

  @override
  String get deleteAccountItemProfile => 'Tu perfil y cuenta';

  @override
  String get deleteAccountItemBirthData => 'Datos de nacimiento y carta natal';

  @override
  String get deleteAccountItemGuidance => 'Todo el historial de guía diaria';

  @override
  String get deleteAccountItemContext => 'Contexto personal y preferencias';

  @override
  String get deleteAccountItemKarmic => 'Lecturas de astrología kármica';

  @override
  String get deleteAccountItemPurchases => 'Todo el contenido comprado';

  @override
  String get deleteAccountTypeDelete => 'Escribe DELETE para confirmar';

  @override
  String get deleteAccountDeleteHint => 'DELETE';

  @override
  String get deleteAccountButton => 'Eliminar Mi Cuenta';

  @override
  String get deleteAccountCancel => 'Cancelar, mantener mi cuenta';

  @override
  String get learnArticleLoadFailed => 'Error al cargar el artículo';

  @override
  String get learnContentInEnglish => 'Contenido en inglés';

  @override
  String get learnArticlesLoadFailed => 'Error al cargar los artículos';

  @override
  String get learnArticlesEmpty => 'No hay artículos disponibles aún';

  @override
  String get learnContentFallback =>
      'Mostrando contenido en inglés (no disponible en tu idioma)';

  @override
  String get checkoutTitle => 'Finalizar Compra';

  @override
  String get checkoutOrderSummary => 'Resumen del Pedido';

  @override
  String get checkoutProTitle => 'Carta Natal Pro';

  @override
  String get checkoutProSubtitle => 'Interpretaciones planetarias completas';

  @override
  String get checkoutTotalLabel => 'Total';

  @override
  String get checkoutTotalAmount => '\$9.99 USD';

  @override
  String get checkoutPaymentTitle => 'Integración de Pago';

  @override
  String get checkoutPaymentSubtitle =>
      'La integración de compra dentro de la aplicación se está finalizando. ¡Por favor, vuelve pronto!';

  @override
  String get checkoutProcessing => 'Procesando...';

  @override
  String get checkoutDemoPurchase => 'Compra de demostración (pruebas)';

  @override
  String get checkoutSecurityNote =>
      'El pago se procesa de forma segura a través de Apple/Google. Los detalles de tu tarjeta nunca se almacenan.';

  @override
  String get checkoutSuccess => '🎉 ¡Carta Natal Pro desbloqueada con éxito!';

  @override
  String get checkoutGenerateFailed =>
      'Error al generar interpretaciones. Por favor, inténtalo de nuevo.';

  @override
  String checkoutErrorWithMessage(Object error) {
    return 'Ocurrió un error: $error';
  }

  @override
  String get billingUpgrade => 'Actualizar a Premium';

  @override
  String billingFeatureLocked(Object feature) {
    return '$feature es una función Premium';
  }

  @override
  String get billingUpgradeBody =>
      'Actualiza a Premium para desbloquear esta función y obtener la orientación más personalizada.';

  @override
  String get contextReviewFailed =>
      'Error al actualizar. Por favor, inténtalo de nuevo.';

  @override
  String get contextReviewTitle => 'Es hora de una rápida revisión';

  @override
  String get contextReviewBody =>
      'Han pasado 3 meses desde la última vez que actualizamos tu contexto personal. ¿Ha cambiado algo importante en tu vida que debamos saber?';

  @override
  String get contextReviewHint =>
      'Esto nos ayuda a darte una orientación más personalizada.';

  @override
  String get contextReviewNoChanges => 'Sin cambios';

  @override
  String get contextReviewYesUpdate => 'Sí, actualizar';

  @override
  String get contextProfileLoadFailed => 'Error al cargar el perfil';

  @override
  String get contextCardTitle => 'Contexto Personal';

  @override
  String get contextCardSubtitle =>
      'Configura tu contexto personal para recibir una orientación más adaptada.';

  @override
  String get contextCardSetupNow => 'Configurar ahora';

  @override
  String contextCardVersionUpdated(Object version, Object date) {
    return 'Versión $version • Última actualización $date';
  }

  @override
  String get contextCardAiSummary => 'Resumen de IA';

  @override
  String contextCardToneTag(Object tone) {
    return 'tono $tone';
  }

  @override
  String get contextCardSensitivityTag => 'sensibilidad activada';

  @override
  String get contextCardReviewDue =>
      'Revisión pendiente - actualiza tu contexto';

  @override
  String contextCardNextReview(Object days) {
    return 'Próxima revisión en $days días';
  }

  @override
  String get contextDeleteTitle => '¿Eliminar el Contexto Personal?';

  @override
  String get contextDeleteBody =>
      'Esto eliminará tu perfil de contexto personal. Tu orientación se volverá menos personalizada.';

  @override
  String get contextDeleteFailed => 'Error al eliminar el perfil';

  @override
  String get appTitle => 'Sabiduría Interior';

  @override
  String get concernsHintExample =>
      'Ejemplo: Tengo una oferta de trabajo en otra ciudad y no estoy seguro de si debo aceptarla...';

  @override
  String get learnTitle => 'Aprender Astrología';

  @override
  String get learnFreeTitle => 'Recursos de Aprendizaje Gratuitos';

  @override
  String get learnFreeSubtitle => 'Explora los fundamentos de la astrología';

  @override
  String get learnSignsTitle => 'Signos';

  @override
  String get learnSignsSubtitle => '12 signos del zodiaco y sus significados';

  @override
  String get learnPlanetsTitle => 'Planetas';

  @override
  String get learnPlanetsSubtitle => 'Cuerpos celestes en astrología';

  @override
  String get learnHousesTitle => 'Casas';

  @override
  String get learnHousesSubtitle => '12 áreas de vida en tu carta';

  @override
  String get learnTransitsTitle => 'Tránsitos';

  @override
  String get learnTransitsSubtitle => 'Movimientos planetarios y efectos';

  @override
  String get learnPaceTitle => 'Aprende a tu Ritmo';

  @override
  String get learnPaceSubtitle =>
      'Lecciones completas para profundizar tu conocimiento astrológico';

  @override
  String get proNatalTitle => 'Carta Natal Pro';

  @override
  String get proNatalHeroTitle => 'Desbloquea Perspectivas Profundas';

  @override
  String get proNatalHeroSubtitle =>
      'Obtén interpretaciones completas de 150-200 palabras para cada colocación planetaria en tu carta natal.';

  @override
  String get proNatalFeature1Title => 'Perspectivas Profundas de Personalidad';

  @override
  String get proNatalFeature1Body =>
      'Entiende cómo cada planeta moldea tu personalidad única y tu camino de vida.';

  @override
  String get proNatalFeature2Title => 'Análisis Potenciado por IA';

  @override
  String get proNatalFeature2Body =>
      'Interpretaciones avanzadas adaptadas a tus posiciones planetarias exactas.';

  @override
  String get proNatalFeature3Title => 'Orientación Accionable';

  @override
  String get proNatalFeature3Body =>
      'Consejos prácticos para carrera, relaciones y crecimiento personal.';

  @override
  String get proNatalFeature4Title => 'Acceso de por Vida';

  @override
  String get proNatalFeature4Body =>
      'Tus interpretaciones se guardan para siempre. Accede en cualquier momento.';

  @override
  String get proNatalOneTime => 'Compra única';

  @override
  String get proNatalNoSubscription => 'No se requiere suscripción';
}

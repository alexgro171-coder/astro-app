import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hu.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_ro.dart';

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
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hu'),
    Locale('it'),
    Locale('pl'),
    Locale('ro')
  ];

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Inner Wisdom Astro'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In en, this message translates to:
  /// **'Innerwisdom Astro brings together over 30 years of astrological expertise from Madi G. with the power of advanced AI, creating one of the most refined and high-performance astrology applications available today.\n\nBy blending deep human insight with intelligent technology, Innerwisdom Astro delivers interpretations that are precise, personalized, and meaningful, supporting users on their journey of self-discovery, clarity, and conscious growth.'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Your Complete Astrological Journey'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In en, this message translates to:
  /// **'From personalized daily guidance to your Natal Birth Chart, Karmic Astrology, in-depth personality reports, Love and Friendship Compatibility, Romantic Forecasts for Couples, and much more — all are now at your fingertips.\n\nDesigned to support clarity, connection, and self-understanding, Innerwisdom Astro offers a complete astrological experience, tailored to you.'**
  String get onboardingDesc2;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingGetStarted;

  /// No description provided for @onboardingAlreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Login'**
  String get onboardingAlreadyHaveAccount;

  /// No description provided for @birthDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Birth Chart'**
  String get birthDataTitle;

  /// No description provided for @birthDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We need your birth details to create\nyour personalized astrological profile'**
  String get birthDataSubtitle;

  /// No description provided for @birthDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Birth Date'**
  String get birthDateLabel;

  /// No description provided for @birthDateSelectHint.
  ///
  /// In en, this message translates to:
  /// **'Select your birth date'**
  String get birthDateSelectHint;

  /// No description provided for @birthTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Birth Time'**
  String get birthTimeLabel;

  /// No description provided for @birthTimeUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get birthTimeUnknown;

  /// No description provided for @birthTimeSelectHint.
  ///
  /// In en, this message translates to:
  /// **'Select your birth time'**
  String get birthTimeSelectHint;

  /// No description provided for @birthTimeUnknownCheckbox.
  ///
  /// In en, this message translates to:
  /// **'I don\'t know my exact birth time'**
  String get birthTimeUnknownCheckbox;

  /// No description provided for @birthPlaceLabel.
  ///
  /// In en, this message translates to:
  /// **'Birth Place'**
  String get birthPlaceLabel;

  /// No description provided for @birthPlaceHint.
  ///
  /// In en, this message translates to:
  /// **'Start typing a city name...'**
  String get birthPlaceHint;

  /// No description provided for @birthPlaceValidation.
  ///
  /// In en, this message translates to:
  /// **'Please select a location from the suggestions'**
  String get birthPlaceValidation;

  /// No description provided for @birthPlaceSelected.
  ///
  /// In en, this message translates to:
  /// **'Selected: {location}'**
  String birthPlaceSelected(Object location);

  /// No description provided for @genderLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get genderLabel;

  /// No description provided for @genderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// No description provided for @genderPreferNotToSay.
  ///
  /// In en, this message translates to:
  /// **'Prefer not to say'**
  String get genderPreferNotToSay;

  /// No description provided for @birthDataSubmit.
  ///
  /// In en, this message translates to:
  /// **'Generate My Birth Chart'**
  String get birthDataSubmit;

  /// No description provided for @birthDataPrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'Your birth data is used only to calculate your\nastrological chart and is stored securely.'**
  String get birthDataPrivacyNote;

  /// No description provided for @birthDateMissing.
  ///
  /// In en, this message translates to:
  /// **'Please select your birth date'**
  String get birthDateMissing;

  /// No description provided for @birthPlaceMissing.
  ///
  /// In en, this message translates to:
  /// **'Please select a birth place from the suggestions'**
  String get birthPlaceMissing;

  /// No description provided for @birthDataSaveError.
  ///
  /// In en, this message translates to:
  /// **'Could not save birth data. Please try again.'**
  String get birthDataSaveError;

  /// No description provided for @appearanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceTitle;

  /// No description provided for @appearanceTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get appearanceTheme;

  /// No description provided for @appearanceDarkTitle.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get appearanceDarkTitle;

  /// No description provided for @appearanceDarkSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Easy on the eyes in low light'**
  String get appearanceDarkSubtitle;

  /// No description provided for @appearanceLightTitle.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get appearanceLightTitle;

  /// No description provided for @appearanceLightSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Classic bright appearance'**
  String get appearanceLightSubtitle;

  /// No description provided for @appearanceSystemTitle.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get appearanceSystemTitle;

  /// No description provided for @appearanceSystemSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Match your device settings'**
  String get appearanceSystemSubtitle;

  /// No description provided for @appearancePreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get appearancePreviewTitle;

  /// No description provided for @appearancePreviewBody.
  ///
  /// In en, this message translates to:
  /// **'The cosmic theme is designed to create an immersive astrology experience. The dark theme is recommended for the best visual experience.'**
  String get appearancePreviewBody;

  /// No description provided for @appearanceThemeChanged.
  ///
  /// In en, this message translates to:
  /// **'Theme changed to {theme}'**
  String appearanceThemeChanged(Object theme);

  /// No description provided for @profileUserFallback.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get profileUserFallback;

  /// No description provided for @profilePersonalContext.
  ///
  /// In en, this message translates to:
  /// **'Personal Context'**
  String get profilePersonalContext;

  /// No description provided for @profileSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get profileSettings;

  /// No description provided for @profileAppLanguage.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get profileAppLanguage;

  /// No description provided for @profileContentLanguage.
  ///
  /// In en, this message translates to:
  /// **'Content Language'**
  String get profileContentLanguage;

  /// No description provided for @profileContentLanguageHint.
  ///
  /// In en, this message translates to:
  /// **'AI content uses the selected language.'**
  String get profileContentLanguageHint;

  /// No description provided for @profileNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get profileNotifications;

  /// No description provided for @profileNotificationsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get profileNotificationsEnabled;

  /// No description provided for @profileNotificationsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get profileNotificationsDisabled;

  /// No description provided for @profileAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get profileAppearance;

  /// No description provided for @profileHelpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get profileHelpSupport;

  /// No description provided for @profilePrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get profilePrivacyPolicy;

  /// No description provided for @profileTermsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get profileTermsOfService;

  /// No description provided for @profileLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get profileLogout;

  /// No description provided for @profileLogoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get profileLogoutConfirm;

  /// No description provided for @profileDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get profileDeleteAccount;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @profileSelectLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get profileSelectLanguageTitle;

  /// No description provided for @profileSelectLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'All AI-generated content will be in your selected language.'**
  String get profileSelectLanguageSubtitle;

  /// No description provided for @profileLanguageUpdated.
  ///
  /// In en, this message translates to:
  /// **'Language updated to {language}'**
  String profileLanguageUpdated(Object language);

  /// No description provided for @profileLanguageUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update language: {error}'**
  String profileLanguageUpdateFailed(Object error);

  /// No description provided for @profileVersion.
  ///
  /// In en, this message translates to:
  /// **'Inner Wisdom v{version}'**
  String profileVersion(Object version);

  /// No description provided for @profileCosmicBlueprint.
  ///
  /// In en, this message translates to:
  /// **'Your Cosmic Blueprint'**
  String get profileCosmicBlueprint;

  /// No description provided for @profileSunLabel.
  ///
  /// In en, this message translates to:
  /// **'☀️ Sun'**
  String get profileSunLabel;

  /// No description provided for @profileMoonLabel.
  ///
  /// In en, this message translates to:
  /// **'🌙 Moon'**
  String get profileMoonLabel;

  /// No description provided for @profileRisingLabel.
  ///
  /// In en, this message translates to:
  /// **'⬆️ Rising'**
  String get profileRisingLabel;

  /// No description provided for @profileUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get profileUnknown;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we\'ll send you a code to reset your password'**
  String get forgotPasswordSubtitle;

  /// No description provided for @forgotPasswordSent.
  ///
  /// In en, this message translates to:
  /// **'If an account exists, a reset code has been sent to your email.'**
  String get forgotPasswordSent;

  /// No description provided for @forgotPasswordFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to send reset code. Please try again.'**
  String get forgotPasswordFailed;

  /// No description provided for @forgotPasswordSendCode.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Code'**
  String get forgotPasswordSendCode;

  /// No description provided for @forgotPasswordHaveCode.
  ///
  /// In en, this message translates to:
  /// **'Already have a code?'**
  String get forgotPasswordHaveCode;

  /// No description provided for @forgotPasswordRemember.
  ///
  /// In en, this message translates to:
  /// **'Remember your password? '**
  String get forgotPasswordRemember;

  /// No description provided for @loginWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get loginWelcomeBack;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue your cosmic journey'**
  String get loginSubtitle;

  /// No description provided for @loginInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get loginInvalidCredentials;

  /// No description provided for @loginGoogleFailed.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in failed. Please try again.'**
  String get loginGoogleFailed;

  /// No description provided for @loginAppleFailed.
  ///
  /// In en, this message translates to:
  /// **'Apple sign-in failed. Please try again.'**
  String get loginAppleFailed;

  /// No description provided for @loginNetworkError.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection.'**
  String get loginNetworkError;

  /// No description provided for @loginSignInCancelled.
  ///
  /// In en, this message translates to:
  /// **'Sign-in was cancelled.'**
  String get loginSignInCancelled;

  /// No description provided for @loginPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get loginPasswordHint;

  /// No description provided for @loginForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get loginForgotPassword;

  /// No description provided for @loginSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginSignIn;

  /// No description provided for @loginNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get loginNoAccount;

  /// No description provided for @loginSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get loginSignUp;

  /// No description provided for @commonEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get commonEmailLabel;

  /// No description provided for @commonEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get commonEmailHint;

  /// No description provided for @commonEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get commonEmailRequired;

  /// No description provided for @commonEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get commonEmailInvalid;

  /// No description provided for @commonPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get commonPasswordLabel;

  /// No description provided for @commonPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get commonPasswordRequired;

  /// No description provided for @commonOrContinueWith.
  ///
  /// In en, this message translates to:
  /// **'or continue with'**
  String get commonOrContinueWith;

  /// No description provided for @commonGoogle.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get commonGoogle;

  /// No description provided for @commonApple.
  ///
  /// In en, this message translates to:
  /// **'Apple'**
  String get commonApple;

  /// No description provided for @commonNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get commonNameLabel;

  /// No description provided for @commonNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get commonNameHint;

  /// No description provided for @commonNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get commonNameRequired;

  /// No description provided for @signupTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get signupTitle;

  /// No description provided for @signupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start your cosmic journey with Inner Wisdom'**
  String get signupSubtitle;

  /// No description provided for @signupEmailExists.
  ///
  /// In en, this message translates to:
  /// **'Email already exists or invalid data'**
  String get signupEmailExists;

  /// No description provided for @signupGoogleFailed.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in failed. Please try again.'**
  String get signupGoogleFailed;

  /// No description provided for @signupAppleFailed.
  ///
  /// In en, this message translates to:
  /// **'Apple sign-in failed. Please try again.'**
  String get signupAppleFailed;

  /// No description provided for @signupPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Create a password (min. 8 characters)'**
  String get signupPasswordHint;

  /// No description provided for @signupPasswordMin.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get signupPasswordMin;

  /// No description provided for @signupConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get signupConfirmPasswordLabel;

  /// No description provided for @signupConfirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get signupConfirmPasswordHint;

  /// No description provided for @signupConfirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get signupConfirmPasswordRequired;

  /// No description provided for @signupPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get signupPasswordMismatch;

  /// No description provided for @signupPreferredLanguage.
  ///
  /// In en, this message translates to:
  /// **'Preferred Language'**
  String get signupPreferredLanguage;

  /// No description provided for @signupCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get signupCreateAccount;

  /// No description provided for @signupHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get signupHaveAccount;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the code sent to your email and set a new password'**
  String get resetPasswordSubtitle;

  /// No description provided for @resetPasswordSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset successful! Redirecting to login...'**
  String get resetPasswordSuccess;

  /// No description provided for @resetPasswordFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to reset password. Please try again.'**
  String get resetPasswordFailed;

  /// No description provided for @resetPasswordInvalidCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid or expired reset code. Please request a new one.'**
  String get resetPasswordInvalidCode;

  /// No description provided for @resetPasswordMaxAttempts.
  ///
  /// In en, this message translates to:
  /// **'Maximum attempts exceeded. Please request a new code.'**
  String get resetPasswordMaxAttempts;

  /// No description provided for @resetCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Reset Code'**
  String get resetCodeLabel;

  /// No description provided for @resetCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Enter 6-digit code'**
  String get resetCodeHint;

  /// No description provided for @resetCodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the reset code'**
  String get resetCodeRequired;

  /// No description provided for @resetCodeLength.
  ///
  /// In en, this message translates to:
  /// **'Code must be 6 digits'**
  String get resetCodeLength;

  /// No description provided for @resetNewPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get resetNewPasswordLabel;

  /// No description provided for @resetNewPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Create a new password (min. 8 characters)'**
  String get resetNewPasswordHint;

  /// No description provided for @resetNewPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a new password'**
  String get resetNewPasswordRequired;

  /// No description provided for @resetConfirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm your new password'**
  String get resetConfirmPasswordHint;

  /// No description provided for @resetPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordButton;

  /// No description provided for @resetRequestNewCode.
  ///
  /// In en, this message translates to:
  /// **'Request a new code'**
  String get resetRequestNewCode;

  /// No description provided for @serviceResultGenerated.
  ///
  /// In en, this message translates to:
  /// **'Report Generated'**
  String get serviceResultGenerated;

  /// No description provided for @serviceResultReady.
  ///
  /// In en, this message translates to:
  /// **'Your personalized {title} is ready'**
  String serviceResultReady(Object title);

  /// No description provided for @serviceResultBackToForYou.
  ///
  /// In en, this message translates to:
  /// **'Back to For You'**
  String get serviceResultBackToForYou;

  /// No description provided for @serviceResultNotSavedNotice.
  ///
  /// In en, this message translates to:
  /// **'This Report will not be saved. If you wish, you can copy it and save it elsewhere using the Copy function.'**
  String get serviceResultNotSavedNotice;

  /// No description provided for @commonCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get commonCopy;

  /// No description provided for @commonCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get commonCopied;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @partnerDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Partner Details'**
  String get partnerDetailsTitle;

  /// No description provided for @partnerBirthDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter partner\'s birth data'**
  String get partnerBirthDataTitle;

  /// No description provided for @partnerBirthDataFor.
  ///
  /// In en, this message translates to:
  /// **'For \"{title}\"'**
  String partnerBirthDataFor(Object title);

  /// No description provided for @partnerNameOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Name (optional)'**
  String get partnerNameOptionalLabel;

  /// No description provided for @partnerNameHint.
  ///
  /// In en, this message translates to:
  /// **'Partner\'s name'**
  String get partnerNameHint;

  /// No description provided for @partnerGenderOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender (optional)'**
  String get partnerGenderOptionalLabel;

  /// No description provided for @partnerBirthDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Birth Date *'**
  String get partnerBirthDateLabel;

  /// No description provided for @partnerBirthDateSelect.
  ///
  /// In en, this message translates to:
  /// **'Select birth date'**
  String get partnerBirthDateSelect;

  /// No description provided for @partnerBirthDateMissing.
  ///
  /// In en, this message translates to:
  /// **'Please select the birth date'**
  String get partnerBirthDateMissing;

  /// No description provided for @partnerBirthTimeOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Birth Time (optional)'**
  String get partnerBirthTimeOptionalLabel;

  /// No description provided for @partnerBirthTimeSelect.
  ///
  /// In en, this message translates to:
  /// **'Select birth time'**
  String get partnerBirthTimeSelect;

  /// No description provided for @partnerBirthPlaceLabel.
  ///
  /// In en, this message translates to:
  /// **'Birth Place *'**
  String get partnerBirthPlaceLabel;

  /// No description provided for @serviceOfferRequiresPartner.
  ///
  /// In en, this message translates to:
  /// **'Requires partner birth data'**
  String get serviceOfferRequiresPartner;

  /// No description provided for @serviceOfferBetaFree.
  ///
  /// In en, this message translates to:
  /// **'Beta testers get free access!'**
  String get serviceOfferBetaFree;

  /// No description provided for @serviceOfferUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Unlocked'**
  String get serviceOfferUnlocked;

  /// No description provided for @serviceOfferGenerate.
  ///
  /// In en, this message translates to:
  /// **'Generate Report'**
  String get serviceOfferGenerate;

  /// No description provided for @serviceOfferUnlockFor.
  ///
  /// In en, this message translates to:
  /// **'Unlock for {price}'**
  String serviceOfferUnlockFor(Object price);

  /// No description provided for @serviceOfferPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing your personalized report…'**
  String get serviceOfferPreparing;

  /// No description provided for @serviceOfferTimeout.
  ///
  /// In en, this message translates to:
  /// **'Taking longer than expected. Please try again.'**
  String get serviceOfferTimeout;

  /// No description provided for @serviceOfferNotReady.
  ///
  /// In en, this message translates to:
  /// **'Report not ready yet. Please try again.'**
  String get serviceOfferNotReady;

  /// No description provided for @serviceOfferFetchFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch report: {error}'**
  String serviceOfferFetchFailed(Object error);

  /// No description provided for @commonFree.
  ///
  /// In en, this message translates to:
  /// **'FREE'**
  String get commonFree;

  /// No description provided for @commonLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get commonLater;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get commonYes;

  /// No description provided for @commonNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get commonNo;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonOptional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get commonOptional;

  /// No description provided for @commonNotSpecified.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get commonNotSpecified;

  /// No description provided for @commonJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get commonJustNow;

  /// No description provided for @commonViewMore.
  ///
  /// In en, this message translates to:
  /// **'View more'**
  String get commonViewMore;

  /// No description provided for @commonViewLess.
  ///
  /// In en, this message translates to:
  /// **'View less'**
  String get commonViewLess;

  /// No description provided for @commonMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} min ago'**
  String commonMinutesAgo(Object count);

  /// No description provided for @commonHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String commonHoursAgo(Object count);

  /// No description provided for @commonDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String commonDaysAgo(Object count);

  /// No description provided for @commonDateShort.
  ///
  /// In en, this message translates to:
  /// **'{day}/{month}/{year}'**
  String commonDateShort(Object day, Object month, Object year);

  /// No description provided for @askGuideTitle.
  ///
  /// In en, this message translates to:
  /// **'Ask Your Guide'**
  String get askGuideTitle;

  /// No description provided for @askGuideSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Personal cosmic guidance'**
  String get askGuideSubtitle;

  /// No description provided for @askGuideRemaining.
  ///
  /// In en, this message translates to:
  /// **'{count} left'**
  String askGuideRemaining(Object count);

  /// No description provided for @askGuideQuestionHint.
  ///
  /// In en, this message translates to:
  /// **'Ask anything - love, career, decisions, emotions...'**
  String get askGuideQuestionHint;

  /// No description provided for @askGuideBasedOnChart.
  ///
  /// In en, this message translates to:
  /// **'Based on your birth chart & today\'s cosmic energies'**
  String get askGuideBasedOnChart;

  /// No description provided for @askGuideThinking.
  ///
  /// In en, this message translates to:
  /// **'Your Guide is thinking...'**
  String get askGuideThinking;

  /// No description provided for @askGuideYourGuide.
  ///
  /// In en, this message translates to:
  /// **'Your Guide'**
  String get askGuideYourGuide;

  /// No description provided for @askGuideEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Ask Your First Question'**
  String get askGuideEmptyTitle;

  /// No description provided for @askGuideEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Get instant, deeply personal guidance based on your birth chart and today\'s cosmic energies.'**
  String get askGuideEmptyBody;

  /// No description provided for @askGuideEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Ask anything — love, career, decisions, emotions.'**
  String get askGuideEmptyHint;

  /// No description provided for @askGuideLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load data'**
  String get askGuideLoadFailed;

  /// No description provided for @askGuideSendFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to send question: {error}'**
  String askGuideSendFailed(Object error);

  /// No description provided for @askGuideLimitTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly Limit Reached'**
  String get askGuideLimitTitle;

  /// No description provided for @askGuideLimitBody.
  ///
  /// In en, this message translates to:
  /// **'You\'ve reached your monthly limit of requests.'**
  String get askGuideLimitBody;

  /// No description provided for @askGuideLimitAddon.
  ///
  /// In en, this message translates to:
  /// **'You can purchase a \$1.99 add-on to continue using this service for the rest of the current billing month.'**
  String get askGuideLimitAddon;

  /// No description provided for @askGuideLimitBillingEnd.
  ///
  /// In en, this message translates to:
  /// **'Your billing month ends on: {date}'**
  String askGuideLimitBillingEnd(Object date);

  /// No description provided for @askGuideLimitGetAddon.
  ///
  /// In en, this message translates to:
  /// **'Get Add-On'**
  String get askGuideLimitGetAddon;

  /// No description provided for @contextTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal Context'**
  String get contextTitle;

  /// No description provided for @contextStepOf.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String contextStepOf(Object current, Object total);

  /// No description provided for @contextStep1Title.
  ///
  /// In en, this message translates to:
  /// **'People around you'**
  String get contextStep1Title;

  /// No description provided for @contextStep1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Your relationship and family context helps us understand your emotional landscape.'**
  String get contextStep1Subtitle;

  /// No description provided for @contextStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Professional Life'**
  String get contextStep2Title;

  /// No description provided for @contextStep2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Your work and daily rhythm shape how you experience pressure, growth, and purpose.'**
  String get contextStep2Subtitle;

  /// No description provided for @contextStep3Title.
  ///
  /// In en, this message translates to:
  /// **'How life feels right now'**
  String get contextStep3Title;

  /// No description provided for @contextStep3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'There are no right or wrong answers, just your current reality'**
  String get contextStep3Subtitle;

  /// No description provided for @contextStep4Title.
  ///
  /// In en, this message translates to:
  /// **'What matters most to you'**
  String get contextStep4Title;

  /// No description provided for @contextStep4Subtitle.
  ///
  /// In en, this message translates to:
  /// **'So your guidance aligns with what you truly care about'**
  String get contextStep4Subtitle;

  /// No description provided for @contextPriorityRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one priority area.'**
  String get contextPriorityRequired;

  /// No description provided for @contextSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save profile: {error}'**
  String contextSaveFailed(Object error);

  /// No description provided for @contextSaveContinue.
  ///
  /// In en, this message translates to:
  /// **'Save & Continue'**
  String get contextSaveContinue;

  /// No description provided for @contextRelationshipStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Current relationship status'**
  String get contextRelationshipStatusTitle;

  /// No description provided for @contextSeekingRelationshipTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you looking for a relationship?'**
  String get contextSeekingRelationshipTitle;

  /// No description provided for @contextHasChildrenTitle.
  ///
  /// In en, this message translates to:
  /// **'Do you have children?'**
  String get contextHasChildrenTitle;

  /// No description provided for @contextChildrenDetailsOptional.
  ///
  /// In en, this message translates to:
  /// **'Children details (optional)'**
  String get contextChildrenDetailsOptional;

  /// No description provided for @contextAddChild.
  ///
  /// In en, this message translates to:
  /// **'Add child'**
  String get contextAddChild;

  /// No description provided for @contextChildAgeLabel.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get contextChildAgeLabel;

  /// No description provided for @contextChildAgeYears.
  ///
  /// In en, this message translates to:
  /// **'{age} {age, plural, =1{year} other{years}}'**
  String contextChildAgeYears(num age);

  /// No description provided for @contextChildGenderLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get contextChildGenderLabel;

  /// No description provided for @contextRelationshipSingle.
  ///
  /// In en, this message translates to:
  /// **'Single'**
  String get contextRelationshipSingle;

  /// No description provided for @contextRelationshipInRelationship.
  ///
  /// In en, this message translates to:
  /// **'In a relationship'**
  String get contextRelationshipInRelationship;

  /// No description provided for @contextRelationshipMarried.
  ///
  /// In en, this message translates to:
  /// **'Married / Civil partnership'**
  String get contextRelationshipMarried;

  /// No description provided for @contextRelationshipSeparated.
  ///
  /// In en, this message translates to:
  /// **'Separated / Divorced'**
  String get contextRelationshipSeparated;

  /// No description provided for @contextRelationshipWidowed.
  ///
  /// In en, this message translates to:
  /// **'Widowed'**
  String get contextRelationshipWidowed;

  /// No description provided for @contextRelationshipPreferNotToSay.
  ///
  /// In en, this message translates to:
  /// **'Prefer not to say'**
  String get contextRelationshipPreferNotToSay;

  /// No description provided for @contextProfessionalStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Current professional status'**
  String get contextProfessionalStatusTitle;

  /// No description provided for @contextProfessionalStatusOtherHint.
  ///
  /// In en, this message translates to:
  /// **'Please specify your work status'**
  String get contextProfessionalStatusOtherHint;

  /// No description provided for @contextIndustryTitle.
  ///
  /// In en, this message translates to:
  /// **'Main industry/domain'**
  String get contextIndustryTitle;

  /// No description provided for @contextWorkStatusStudent.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get contextWorkStatusStudent;

  /// No description provided for @contextWorkStatusUnemployed.
  ///
  /// In en, this message translates to:
  /// **'Unemployed / Between jobs'**
  String get contextWorkStatusUnemployed;

  /// No description provided for @contextWorkStatusEmployedIc.
  ///
  /// In en, this message translates to:
  /// **'Employed (Individual contributor)'**
  String get contextWorkStatusEmployedIc;

  /// No description provided for @contextWorkStatusEmployedManagement.
  ///
  /// In en, this message translates to:
  /// **'Employed (Management)'**
  String get contextWorkStatusEmployedManagement;

  /// No description provided for @contextWorkStatusExecutive.
  ///
  /// In en, this message translates to:
  /// **'Executive / Leadership (C-level)'**
  String get contextWorkStatusExecutive;

  /// No description provided for @contextWorkStatusSelfEmployed.
  ///
  /// In en, this message translates to:
  /// **'Self-employed / Freelancer'**
  String get contextWorkStatusSelfEmployed;

  /// No description provided for @contextWorkStatusEntrepreneur.
  ///
  /// In en, this message translates to:
  /// **'Entrepreneur / Business owner'**
  String get contextWorkStatusEntrepreneur;

  /// No description provided for @contextWorkStatusInvestor.
  ///
  /// In en, this message translates to:
  /// **'Investor'**
  String get contextWorkStatusInvestor;

  /// No description provided for @contextWorkStatusRetired.
  ///
  /// In en, this message translates to:
  /// **'Retired'**
  String get contextWorkStatusRetired;

  /// No description provided for @contextWorkStatusHomemaker.
  ///
  /// In en, this message translates to:
  /// **'Homemaker / Stay-at-home parent'**
  String get contextWorkStatusHomemaker;

  /// No description provided for @contextWorkStatusCareerBreak.
  ///
  /// In en, this message translates to:
  /// **'Career break / Sabbatical'**
  String get contextWorkStatusCareerBreak;

  /// No description provided for @contextWorkStatusOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get contextWorkStatusOther;

  /// No description provided for @contextIndustryTech.
  ///
  /// In en, this message translates to:
  /// **'Tech / IT'**
  String get contextIndustryTech;

  /// No description provided for @contextIndustryFinance.
  ///
  /// In en, this message translates to:
  /// **'Finance / Investments'**
  String get contextIndustryFinance;

  /// No description provided for @contextIndustryHealthcare.
  ///
  /// In en, this message translates to:
  /// **'Healthcare'**
  String get contextIndustryHealthcare;

  /// No description provided for @contextIndustryEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get contextIndustryEducation;

  /// No description provided for @contextIndustrySalesMarketing.
  ///
  /// In en, this message translates to:
  /// **'Sales / Marketing'**
  String get contextIndustrySalesMarketing;

  /// No description provided for @contextIndustryRealEstate.
  ///
  /// In en, this message translates to:
  /// **'Real Estate'**
  String get contextIndustryRealEstate;

  /// No description provided for @contextIndustryHospitality.
  ///
  /// In en, this message translates to:
  /// **'Hospitality'**
  String get contextIndustryHospitality;

  /// No description provided for @contextIndustryGovernment.
  ///
  /// In en, this message translates to:
  /// **'Government / Public sector'**
  String get contextIndustryGovernment;

  /// No description provided for @contextIndustryCreative.
  ///
  /// In en, this message translates to:
  /// **'Creative industries'**
  String get contextIndustryCreative;

  /// No description provided for @contextIndustryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get contextIndustryOther;

  /// No description provided for @contextSelfAssessmentIntro.
  ///
  /// In en, this message translates to:
  /// **'Rate your current situation in each area (1 = struggling, 5 = thriving)'**
  String get contextSelfAssessmentIntro;

  /// No description provided for @contextSelfHealthTitle.
  ///
  /// In en, this message translates to:
  /// **'Health & Energy'**
  String get contextSelfHealthTitle;

  /// No description provided for @contextSelfHealthSubtitle.
  ///
  /// In en, this message translates to:
  /// **'1 = serious issues/low energy, 5 = excellent vitality'**
  String get contextSelfHealthSubtitle;

  /// No description provided for @contextSelfSocialTitle.
  ///
  /// In en, this message translates to:
  /// **'Social Life'**
  String get contextSelfSocialTitle;

  /// No description provided for @contextSelfSocialSubtitle.
  ///
  /// In en, this message translates to:
  /// **'1 = isolated, 5 = thriving social connections'**
  String get contextSelfSocialSubtitle;

  /// No description provided for @contextSelfRomanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Romantic Life'**
  String get contextSelfRomanceTitle;

  /// No description provided for @contextSelfRomanceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'1 = absent/challenging, 5 = fulfilled'**
  String get contextSelfRomanceSubtitle;

  /// No description provided for @contextSelfFinanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Financial Stability'**
  String get contextSelfFinanceTitle;

  /// No description provided for @contextSelfFinanceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'1 = major hardship, 5 = excellent'**
  String get contextSelfFinanceSubtitle;

  /// No description provided for @contextSelfCareerTitle.
  ///
  /// In en, this message translates to:
  /// **'Career Satisfaction'**
  String get contextSelfCareerTitle;

  /// No description provided for @contextSelfCareerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'1 = stuck/stressed, 5 = progress/clarity'**
  String get contextSelfCareerSubtitle;

  /// No description provided for @contextSelfGrowthTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal Growth Interest'**
  String get contextSelfGrowthTitle;

  /// No description provided for @contextSelfGrowthSubtitle.
  ///
  /// In en, this message translates to:
  /// **'1 = low interest, 5 = very high'**
  String get contextSelfGrowthSubtitle;

  /// No description provided for @contextSelfStruggling.
  ///
  /// In en, this message translates to:
  /// **'Struggling'**
  String get contextSelfStruggling;

  /// No description provided for @contextSelfThriving.
  ///
  /// In en, this message translates to:
  /// **'Thriving'**
  String get contextSelfThriving;

  /// No description provided for @contextPrioritiesTitle.
  ///
  /// In en, this message translates to:
  /// **'What are your top priorities right now?'**
  String get contextPrioritiesTitle;

  /// No description provided for @contextPrioritiesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select up to 2 areas you want to focus on'**
  String get contextPrioritiesSubtitle;

  /// No description provided for @contextGuidanceStyleTitle.
  ///
  /// In en, this message translates to:
  /// **'Preferred guidance style'**
  String get contextGuidanceStyleTitle;

  /// No description provided for @contextSensitivityTitle.
  ///
  /// In en, this message translates to:
  /// **'Sensitivity Mode'**
  String get contextSensitivityTitle;

  /// No description provided for @contextSensitivitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Avoid anxiety-inducing or deterministic phrasing in guidance'**
  String get contextSensitivitySubtitle;

  /// No description provided for @contextPriorityHealth.
  ///
  /// In en, this message translates to:
  /// **'Health & habits'**
  String get contextPriorityHealth;

  /// No description provided for @contextPriorityCareer.
  ///
  /// In en, this message translates to:
  /// **'Career growth'**
  String get contextPriorityCareer;

  /// No description provided for @contextPriorityBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business decisions'**
  String get contextPriorityBusiness;

  /// No description provided for @contextPriorityMoney.
  ///
  /// In en, this message translates to:
  /// **'Money & stability'**
  String get contextPriorityMoney;

  /// No description provided for @contextPriorityLove.
  ///
  /// In en, this message translates to:
  /// **'Love & relationship'**
  String get contextPriorityLove;

  /// No description provided for @contextPriorityFamily.
  ///
  /// In en, this message translates to:
  /// **'Family & parenting'**
  String get contextPriorityFamily;

  /// No description provided for @contextPrioritySocial.
  ///
  /// In en, this message translates to:
  /// **'Social life'**
  String get contextPrioritySocial;

  /// No description provided for @contextPriorityGrowth.
  ///
  /// In en, this message translates to:
  /// **'Personal growth / mindset'**
  String get contextPriorityGrowth;

  /// No description provided for @contextGuidanceStyleDirect.
  ///
  /// In en, this message translates to:
  /// **'Direct & practical'**
  String get contextGuidanceStyleDirect;

  /// No description provided for @contextGuidanceStyleDirectDesc.
  ///
  /// In en, this message translates to:
  /// **'Get straight to actionable advice'**
  String get contextGuidanceStyleDirectDesc;

  /// No description provided for @contextGuidanceStyleEmpathetic.
  ///
  /// In en, this message translates to:
  /// **'Empathetic & reflective'**
  String get contextGuidanceStyleEmpathetic;

  /// No description provided for @contextGuidanceStyleEmpatheticDesc.
  ///
  /// In en, this message translates to:
  /// **'Warm, supportive guidance'**
  String get contextGuidanceStyleEmpatheticDesc;

  /// No description provided for @contextGuidanceStyleBalanced.
  ///
  /// In en, this message translates to:
  /// **'Balanced'**
  String get contextGuidanceStyleBalanced;

  /// No description provided for @contextGuidanceStyleBalancedDesc.
  ///
  /// In en, this message translates to:
  /// **'Mix of practical and emotional support'**
  String get contextGuidanceStyleBalancedDesc;

  /// No description provided for @homeGuidancePreparing.
  ///
  /// In en, this message translates to:
  /// **'Reading the stars and asking the Universe about you…'**
  String get homeGuidancePreparing;

  /// No description provided for @homeGuidanceFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to generate guidance. Please try again.'**
  String get homeGuidanceFailed;

  /// No description provided for @homeGuidanceTimeout.
  ///
  /// In en, this message translates to:
  /// **'Taking longer than expected. Tap Retry or check back in a moment.'**
  String get homeGuidanceTimeout;

  /// No description provided for @homeGuidanceLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load guidance'**
  String get homeGuidanceLoadFailed;

  /// No description provided for @homeTodaysGuidance.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Guidance'**
  String get homeTodaysGuidance;

  /// No description provided for @homeSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get homeSeeAll;

  /// No description provided for @homeHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get homeHealth;

  /// No description provided for @homeCareer.
  ///
  /// In en, this message translates to:
  /// **'Career'**
  String get homeCareer;

  /// No description provided for @homeMoney.
  ///
  /// In en, this message translates to:
  /// **'Money'**
  String get homeMoney;

  /// No description provided for @homeLove.
  ///
  /// In en, this message translates to:
  /// **'Love'**
  String get homeLove;

  /// No description provided for @homePartners.
  ///
  /// In en, this message translates to:
  /// **'Partners'**
  String get homePartners;

  /// No description provided for @homeGrowth.
  ///
  /// In en, this message translates to:
  /// **'Growth'**
  String get homeGrowth;

  /// No description provided for @homeTraveler.
  ///
  /// In en, this message translates to:
  /// **'Traveler'**
  String get homeTraveler;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String homeGreeting(Object name);

  /// No description provided for @homeFocusFallback.
  ///
  /// In en, this message translates to:
  /// **'Personal Growth'**
  String get homeFocusFallback;

  /// No description provided for @homeDailyMessage.
  ///
  /// In en, this message translates to:
  /// **'Your Daily Message'**
  String get homeDailyMessage;

  /// No description provided for @homeNatalChartTitle.
  ///
  /// In en, this message translates to:
  /// **'My Natal Chart'**
  String get homeNatalChartTitle;

  /// No description provided for @homeNatalChartSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Explore your birth chart & interpretations'**
  String get homeNatalChartSubtitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// No description provided for @navGuide.
  ///
  /// In en, this message translates to:
  /// **'Guide'**
  String get navGuide;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @navForYou.
  ///
  /// In en, this message translates to:
  /// **'For You'**
  String get navForYou;

  /// No description provided for @commonToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get commonToday;

  /// No description provided for @commonTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get commonTryAgain;

  /// No description provided for @natalChartTitle.
  ///
  /// In en, this message translates to:
  /// **'My Natal Chart'**
  String get natalChartTitle;

  /// No description provided for @natalChartTabTable.
  ///
  /// In en, this message translates to:
  /// **'Table'**
  String get natalChartTabTable;

  /// No description provided for @natalChartTabChart.
  ///
  /// In en, this message translates to:
  /// **'Chart'**
  String get natalChartTabChart;

  /// No description provided for @natalChartEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No Natal Chart Data'**
  String get natalChartEmptyTitle;

  /// No description provided for @natalChartEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please complete your birth data to see your natal chart.'**
  String get natalChartEmptySubtitle;

  /// No description provided for @natalChartAddBirthData.
  ///
  /// In en, this message translates to:
  /// **'Add Birth Data'**
  String get natalChartAddBirthData;

  /// No description provided for @natalChartErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Unable to load chart'**
  String get natalChartErrorTitle;

  /// No description provided for @guidanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Guidance'**
  String get guidanceTitle;

  /// No description provided for @guidanceLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load guidance'**
  String get guidanceLoadFailed;

  /// No description provided for @guidanceNoneAvailable.
  ///
  /// In en, this message translates to:
  /// **'No guidance available'**
  String get guidanceNoneAvailable;

  /// No description provided for @guidanceCosmicEnergyTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Cosmic Energy'**
  String get guidanceCosmicEnergyTitle;

  /// No description provided for @guidanceMoodLabel.
  ///
  /// In en, this message translates to:
  /// **'Mood'**
  String get guidanceMoodLabel;

  /// No description provided for @guidanceFocusLabel.
  ///
  /// In en, this message translates to:
  /// **'Focus'**
  String get guidanceFocusLabel;

  /// No description provided for @guidanceYourGuidance.
  ///
  /// In en, this message translates to:
  /// **'Your Guidance'**
  String get guidanceYourGuidance;

  /// No description provided for @guidanceTapToCollapse.
  ///
  /// In en, this message translates to:
  /// **'Tap to collapse'**
  String get guidanceTapToCollapse;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'Guidance History'**
  String get historyTitle;

  /// No description provided for @historySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your cosmic journey through time'**
  String get historySubtitle;

  /// No description provided for @historyLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load history'**
  String get historyLoadFailed;

  /// No description provided for @historyEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No history yet'**
  String get historyEmptyTitle;

  /// No description provided for @historyEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your daily guidances will appear here'**
  String get historyEmptySubtitle;

  /// No description provided for @historyNewBadge.
  ///
  /// In en, this message translates to:
  /// **'NEW'**
  String get historyNewBadge;

  /// No description provided for @commonUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Unlocked'**
  String get commonUnlocked;

  /// No description provided for @commonComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get commonComingSoon;

  /// No description provided for @commonSomethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get commonSomethingWentWrong;

  /// No description provided for @commonNoContent.
  ///
  /// In en, this message translates to:
  /// **'No content available.'**
  String get commonNoContent;

  /// No description provided for @commonUnknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get commonUnknownError;

  /// No description provided for @commonTakingLonger.
  ///
  /// In en, this message translates to:
  /// **'Taking longer than expected. Please try again.'**
  String get commonTakingLonger;

  /// No description provided for @commonErrorWithMessage.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String commonErrorWithMessage(Object error);

  /// No description provided for @forYouTitle.
  ///
  /// In en, this message translates to:
  /// **'For You'**
  String get forYouTitle;

  /// No description provided for @forYouSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Personalized cosmic insights'**
  String get forYouSubtitle;

  /// No description provided for @forYouNatalChartTitle.
  ///
  /// In en, this message translates to:
  /// **'My Natal Chart'**
  String get forYouNatalChartTitle;

  /// No description provided for @forYouNatalChartSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your birth chart analysis'**
  String get forYouNatalChartSubtitle;

  /// No description provided for @forYouCompatibilitiesTitle.
  ///
  /// In en, this message translates to:
  /// **'Compatibilities'**
  String get forYouCompatibilitiesTitle;

  /// No description provided for @forYouCompatibilitiesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Love, friendship & partnership reports'**
  String get forYouCompatibilitiesSubtitle;

  /// No description provided for @forYouKarmicTitle.
  ///
  /// In en, this message translates to:
  /// **'Karmic Astrology'**
  String get forYouKarmicTitle;

  /// No description provided for @forYouKarmicSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Soul lessons & past life patterns'**
  String get forYouKarmicSubtitle;

  /// No description provided for @forYouLearnTitle.
  ///
  /// In en, this message translates to:
  /// **'Learn Astrology'**
  String get forYouLearnTitle;

  /// No description provided for @forYouLearnSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Free educational content'**
  String get forYouLearnSubtitle;

  /// No description provided for @compatibilitiesTitle.
  ///
  /// In en, this message translates to:
  /// **'Compatibilities'**
  String get compatibilitiesTitle;

  /// No description provided for @compatibilitiesLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load services'**
  String get compatibilitiesLoadFailed;

  /// No description provided for @compatibilitiesBetaFree.
  ///
  /// In en, this message translates to:
  /// **'Beta: All reports are FREE!'**
  String get compatibilitiesBetaFree;

  /// No description provided for @compatibilitiesChooseReport.
  ///
  /// In en, this message translates to:
  /// **'Choose a Report'**
  String get compatibilitiesChooseReport;

  /// No description provided for @compatibilitiesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Discover insights about yourself and your relationships'**
  String get compatibilitiesSubtitle;

  /// No description provided for @compatibilitiesPartnerBadge.
  ///
  /// In en, this message translates to:
  /// **'+Partner'**
  String get compatibilitiesPartnerBadge;

  /// No description provided for @compatibilitiesPersonalityTitle.
  ///
  /// In en, this message translates to:
  /// **'Personality Report'**
  String get compatibilitiesPersonalityTitle;

  /// No description provided for @compatibilitiesPersonalitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive analysis of your personality based on your natal chart'**
  String get compatibilitiesPersonalitySubtitle;

  /// No description provided for @compatibilitiesRomanticPersonalityTitle.
  ///
  /// In en, this message translates to:
  /// **'Romantic Personality Report'**
  String get compatibilitiesRomanticPersonalityTitle;

  /// No description provided for @compatibilitiesRomanticPersonalitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Understand how you approach love and romance'**
  String get compatibilitiesRomanticPersonalitySubtitle;

  /// No description provided for @compatibilitiesLoveCompatibilityTitle.
  ///
  /// In en, this message translates to:
  /// **'Love Compatibility'**
  String get compatibilitiesLoveCompatibilityTitle;

  /// No description provided for @compatibilitiesLoveCompatibilitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Detailed romantic compatibility analysis with your partner'**
  String get compatibilitiesLoveCompatibilitySubtitle;

  /// No description provided for @compatibilitiesRomanticForecastTitle.
  ///
  /// In en, this message translates to:
  /// **'Romantic Couple Forecast'**
  String get compatibilitiesRomanticForecastTitle;

  /// No description provided for @compatibilitiesRomanticForecastSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Insights into the future of your relationship'**
  String get compatibilitiesRomanticForecastSubtitle;

  /// No description provided for @compatibilitiesFriendshipTitle.
  ///
  /// In en, this message translates to:
  /// **'Friendship Report'**
  String get compatibilitiesFriendshipTitle;

  /// No description provided for @compatibilitiesFriendshipSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Analyze friendship dynamics and compatibility'**
  String get compatibilitiesFriendshipSubtitle;

  /// No description provided for @moonPhaseTitle.
  ///
  /// In en, this message translates to:
  /// **'Moon Phase Report'**
  String get moonPhaseTitle;

  /// No description provided for @moonPhaseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Understand the current lunar energy and how it affects you. Get guidance aligned with the moon\'s phase.'**
  String get moonPhaseSubtitle;

  /// No description provided for @moonPhaseSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get moonPhaseSelectDate;

  /// No description provided for @moonPhaseOriginalPrice.
  ///
  /// In en, this message translates to:
  /// **'\$2.99'**
  String get moonPhaseOriginalPrice;

  /// No description provided for @moonPhaseGenerate.
  ///
  /// In en, this message translates to:
  /// **'Generate Report'**
  String get moonPhaseGenerate;

  /// No description provided for @moonPhaseGenerateDifferentDate.
  ///
  /// In en, this message translates to:
  /// **'Generate for Different Date'**
  String get moonPhaseGenerateDifferentDate;

  /// No description provided for @moonPhaseGenerationFailed.
  ///
  /// In en, this message translates to:
  /// **'Generation failed'**
  String get moonPhaseGenerationFailed;

  /// No description provided for @moonPhaseGenerating.
  ///
  /// In en, this message translates to:
  /// **'Report is being generated. Please try again.'**
  String get moonPhaseGenerating;

  /// No description provided for @moonPhaseUnknownError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get moonPhaseUnknownError;

  /// No description provided for @requiredFieldsNote.
  ///
  /// In en, this message translates to:
  /// **'Fields marked with * are required.'**
  String get requiredFieldsNote;

  /// No description provided for @karmicTitle.
  ///
  /// In en, this message translates to:
  /// **'Karmic Astrology'**
  String get karmicTitle;

  /// No description provided for @karmicLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load: {error}'**
  String karmicLoadFailed(Object error);

  /// No description provided for @karmicOfferTitle.
  ///
  /// In en, this message translates to:
  /// **'🔮 Karmic Astrology – Messages of the Soul'**
  String get karmicOfferTitle;

  /// No description provided for @karmicOfferBody.
  ///
  /// In en, this message translates to:
  /// **'Karmic Astrology reveals the deep patterns shaping your life, beyond everyday events.\n\nIt offers an interpretation that speaks about unresolved lessons, karmic connections, and the soul\'s path of growth.\n\nThis is not about what comes next,\nbut about why you are experiencing what you experience.\n\n✨ Activate Karmic Astrology and discover the deeper meaning of your journey.'**
  String get karmicOfferBody;

  /// No description provided for @karmicBetaFreeBadge.
  ///
  /// In en, this message translates to:
  /// **'Beta Testers – FREE Access!'**
  String get karmicBetaFreeBadge;

  /// No description provided for @karmicPriceBeta.
  ///
  /// In en, this message translates to:
  /// **'\${price} – Beta Testers Free'**
  String karmicPriceBeta(Object price);

  /// No description provided for @karmicPriceUnlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock for \${price}'**
  String karmicPriceUnlock(Object price);

  /// No description provided for @karmicHintInstant.
  ///
  /// In en, this message translates to:
  /// **'Your reading will be generated instantly'**
  String get karmicHintInstant;

  /// No description provided for @karmicHintOneTime.
  ///
  /// In en, this message translates to:
  /// **'One-time purchase, no subscription'**
  String get karmicHintOneTime;

  /// No description provided for @karmicProgressHint.
  ///
  /// In en, this message translates to:
  /// **'Connecting to your karmic path…'**
  String get karmicProgressHint;

  /// No description provided for @karmicGenerateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to generate: {error}'**
  String karmicGenerateFailed(Object error);

  /// No description provided for @karmicCheckoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Karmic Astrology Checkout'**
  String get karmicCheckoutTitle;

  /// No description provided for @karmicCheckoutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Purchase flow coming soon'**
  String get karmicCheckoutSubtitle;

  /// No description provided for @karmicGenerationFailed.
  ///
  /// In en, this message translates to:
  /// **'Generation failed: {error}'**
  String karmicGenerationFailed(Object error);

  /// No description provided for @karmicLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading your karmic reading...'**
  String get karmicLoading;

  /// No description provided for @karmicGenerationFailedShort.
  ///
  /// In en, this message translates to:
  /// **'Generation failed'**
  String get karmicGenerationFailedShort;

  /// No description provided for @karmicGeneratingTitle.
  ///
  /// In en, this message translates to:
  /// **'Generating Your Karmic Reading...'**
  String get karmicGeneratingTitle;

  /// No description provided for @karmicGeneratingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Analyzing your natal chart for karmic patterns and soul lessons.'**
  String get karmicGeneratingSubtitle;

  /// No description provided for @karmicReadingTitle.
  ///
  /// In en, this message translates to:
  /// **'🔮 Your Karmic Reading'**
  String get karmicReadingTitle;

  /// No description provided for @karmicReadingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Messages of the Soul'**
  String get karmicReadingSubtitle;

  /// No description provided for @karmicDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'This reading is for self-reflection and entertainment purposes. It does not constitute professional advice.'**
  String get karmicDisclaimer;

  /// No description provided for @commonActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get commonActive;

  /// No description provided for @commonBackToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get commonBackToHome;

  /// No description provided for @commonYesterday.
  ///
  /// In en, this message translates to:
  /// **'yesterday'**
  String get commonYesterday;

  /// No description provided for @commonWeeksAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} weeks ago'**
  String commonWeeksAgo(Object count);

  /// No description provided for @commonMonthsAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} months ago'**
  String commonMonthsAgo(Object count);

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @natalChartProGenerated.
  ///
  /// In en, this message translates to:
  /// **'Pro interpretations generated! Scroll up to see them.'**
  String get natalChartProGenerated;

  /// No description provided for @natalChartHouse1.
  ///
  /// In en, this message translates to:
  /// **'Self & Identity'**
  String get natalChartHouse1;

  /// No description provided for @natalChartHouse2.
  ///
  /// In en, this message translates to:
  /// **'Money & Values'**
  String get natalChartHouse2;

  /// No description provided for @natalChartHouse3.
  ///
  /// In en, this message translates to:
  /// **'Communication'**
  String get natalChartHouse3;

  /// No description provided for @natalChartHouse4.
  ///
  /// In en, this message translates to:
  /// **'Home & Family'**
  String get natalChartHouse4;

  /// No description provided for @natalChartHouse5.
  ///
  /// In en, this message translates to:
  /// **'Creativity & Romance'**
  String get natalChartHouse5;

  /// No description provided for @natalChartHouse6.
  ///
  /// In en, this message translates to:
  /// **'Health & Routine'**
  String get natalChartHouse6;

  /// No description provided for @natalChartHouse7.
  ///
  /// In en, this message translates to:
  /// **'Relationships'**
  String get natalChartHouse7;

  /// No description provided for @natalChartHouse8.
  ///
  /// In en, this message translates to:
  /// **'Transformation'**
  String get natalChartHouse8;

  /// No description provided for @natalChartHouse9.
  ///
  /// In en, this message translates to:
  /// **'Philosophy & Travel'**
  String get natalChartHouse9;

  /// No description provided for @natalChartHouse10.
  ///
  /// In en, this message translates to:
  /// **'Career & Status'**
  String get natalChartHouse10;

  /// No description provided for @natalChartHouse11.
  ///
  /// In en, this message translates to:
  /// **'Friends & Goals'**
  String get natalChartHouse11;

  /// No description provided for @natalChartHouse12.
  ///
  /// In en, this message translates to:
  /// **'Spirituality'**
  String get natalChartHouse12;

  /// No description provided for @helpSupportTitle.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupportTitle;

  /// No description provided for @helpSupportContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get helpSupportContactTitle;

  /// No description provided for @helpSupportContactSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We typically respond within 24 hours'**
  String get helpSupportContactSubtitle;

  /// No description provided for @helpSupportFaqTitle.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get helpSupportFaqTitle;

  /// No description provided for @helpSupportEmailSubject.
  ///
  /// In en, this message translates to:
  /// **'Inner Wisdom Support Request'**
  String get helpSupportEmailSubject;

  /// No description provided for @helpSupportEmailAppFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open email app. Please email support@innerwisdomapp.com'**
  String get helpSupportEmailAppFailed;

  /// No description provided for @helpSupportEmailFallback.
  ///
  /// In en, this message translates to:
  /// **'Please email us at support@innerwisdomapp.com'**
  String get helpSupportEmailFallback;

  /// No description provided for @helpSupportFaq1Q.
  ///
  /// In en, this message translates to:
  /// **'How accurate is the daily guidance?'**
  String get helpSupportFaq1Q;

  /// No description provided for @helpSupportFaq1A.
  ///
  /// In en, this message translates to:
  /// **'Our daily guidance combines traditional astrological principles with your personal birth chart. While astrology is interpretive, our AI provides personalized insights based on real planetary positions and aspects.'**
  String get helpSupportFaq1A;

  /// No description provided for @helpSupportFaq2Q.
  ///
  /// In en, this message translates to:
  /// **'Why do I need my birth time?'**
  String get helpSupportFaq2Q;

  /// No description provided for @helpSupportFaq2A.
  ///
  /// In en, this message translates to:
  /// **'Your birth time determines your Ascendant (Rising sign) and the positions of houses in your chart. Without it, we use noon as a default, which may affect the accuracy of house-related interpretations.'**
  String get helpSupportFaq2A;

  /// No description provided for @helpSupportFaq3Q.
  ///
  /// In en, this message translates to:
  /// **'How do I change my birth data?'**
  String get helpSupportFaq3Q;

  /// No description provided for @helpSupportFaq3A.
  ///
  /// In en, this message translates to:
  /// **'Currently, birth data cannot be changed after initial setup to ensure consistency in your readings. Contact support if you need to make corrections.'**
  String get helpSupportFaq3A;

  /// No description provided for @helpSupportFaq4Q.
  ///
  /// In en, this message translates to:
  /// **'What is a Focus topic?'**
  String get helpSupportFaq4Q;

  /// No description provided for @helpSupportFaq4A.
  ///
  /// In en, this message translates to:
  /// **'A Focus topic is a current concern or life area you want to emphasize. When set, your daily guidance will pay special attention to this area, providing more relevant insights.'**
  String get helpSupportFaq4A;

  /// No description provided for @helpSupportFaq5Q.
  ///
  /// In en, this message translates to:
  /// **'How does the subscription work?'**
  String get helpSupportFaq5Q;

  /// No description provided for @helpSupportFaq5A.
  ///
  /// In en, this message translates to:
  /// **'The free tier includes basic daily guidance. Premium subscribers get enhanced personalization, audio readings, and access to special features like Karmic Astrology readings.'**
  String get helpSupportFaq5A;

  /// No description provided for @helpSupportFaq6Q.
  ///
  /// In en, this message translates to:
  /// **'Is my data private?'**
  String get helpSupportFaq6Q;

  /// No description provided for @helpSupportFaq6A.
  ///
  /// In en, this message translates to:
  /// **'Yes! We take privacy seriously. Your birth data and personal information are encrypted and never shared with third parties. You can delete your account at any time.'**
  String get helpSupportFaq6A;

  /// No description provided for @helpSupportFaq7Q.
  ///
  /// In en, this message translates to:
  /// **'What if I disagree with a reading?'**
  String get helpSupportFaq7Q;

  /// No description provided for @helpSupportFaq7A.
  ///
  /// In en, this message translates to:
  /// **'Astrology is interpretive, and not every reading will resonate. Use the feedback feature to help us improve. Our AI learns from your preferences over time.'**
  String get helpSupportFaq7A;

  /// No description provided for @notificationsSaved.
  ///
  /// In en, this message translates to:
  /// **'Notification settings saved'**
  String get notificationsSaved;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get notificationsSectionTitle;

  /// No description provided for @notificationsDailyTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Guidance'**
  String get notificationsDailyTitle;

  /// No description provided for @notificationsDailySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get notified when your daily guidance is ready'**
  String get notificationsDailySubtitle;

  /// No description provided for @notificationsWeeklyTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly Highlights'**
  String get notificationsWeeklyTitle;

  /// No description provided for @notificationsWeeklySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly cosmic overview and key transits'**
  String get notificationsWeeklySubtitle;

  /// No description provided for @notificationsSpecialTitle.
  ///
  /// In en, this message translates to:
  /// **'Special Events'**
  String get notificationsSpecialTitle;

  /// No description provided for @notificationsSpecialSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Full moons, eclipses, and retrogrades'**
  String get notificationsSpecialSubtitle;

  /// No description provided for @notificationsDeviceHint.
  ///
  /// In en, this message translates to:
  /// **'You can also control notifications in your device settings.'**
  String get notificationsDeviceHint;

  /// No description provided for @concernsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Focus'**
  String get concernsTitle;

  /// No description provided for @concernsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Topics shaping your guidance'**
  String get concernsSubtitle;

  /// No description provided for @concernsTabActive.
  ///
  /// In en, this message translates to:
  /// **'Active ({count})'**
  String concernsTabActive(Object count);

  /// No description provided for @concernsTabResolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved ({count})'**
  String concernsTabResolved(Object count);

  /// No description provided for @concernsTabArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived ({count})'**
  String concernsTabArchived(Object count);

  /// No description provided for @concernsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No concerns here'**
  String get concernsEmptyTitle;

  /// No description provided for @concernsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add a focus topic to get personalized guidance'**
  String get concernsEmptySubtitle;

  /// No description provided for @concernsCategoryCareer.
  ///
  /// In en, this message translates to:
  /// **'Career & Job'**
  String get concernsCategoryCareer;

  /// No description provided for @concernsCategoryHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get concernsCategoryHealth;

  /// No description provided for @concernsCategoryRelationship.
  ///
  /// In en, this message translates to:
  /// **'Relationship'**
  String get concernsCategoryRelationship;

  /// No description provided for @concernsCategoryFamily.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get concernsCategoryFamily;

  /// No description provided for @concernsCategoryMoney.
  ///
  /// In en, this message translates to:
  /// **'Money'**
  String get concernsCategoryMoney;

  /// No description provided for @concernsCategoryBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get concernsCategoryBusiness;

  /// No description provided for @concernsCategoryPartnership.
  ///
  /// In en, this message translates to:
  /// **'Partnership'**
  String get concernsCategoryPartnership;

  /// No description provided for @concernsCategoryGrowth.
  ///
  /// In en, this message translates to:
  /// **'Personal Growth'**
  String get concernsCategoryGrowth;

  /// No description provided for @concernsMinLength.
  ///
  /// In en, this message translates to:
  /// **'Please describe your concern in more detail (at least 10 characters)'**
  String get concernsMinLength;

  /// No description provided for @concernsSubmitFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit concern. Please try again.'**
  String get concernsSubmitFailed;

  /// No description provided for @concernsAddTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s on your mind?'**
  String get concernsAddTitle;

  /// No description provided for @concernsAddDescription.
  ///
  /// In en, this message translates to:
  /// **'Share your current concern, question, or life situation. Our AI will analyze it and provide focused guidance starting tomorrow.'**
  String get concernsAddDescription;

  /// No description provided for @concernsExamplesTitle.
  ///
  /// In en, this message translates to:
  /// **'Examples of concerns:'**
  String get concernsExamplesTitle;

  /// No description provided for @concernsExampleCareer.
  ///
  /// In en, this message translates to:
  /// **'Career change decision'**
  String get concernsExampleCareer;

  /// No description provided for @concernsExampleRelationship.
  ///
  /// In en, this message translates to:
  /// **'Relationship challenges'**
  String get concernsExampleRelationship;

  /// No description provided for @concernsExampleFinance.
  ///
  /// In en, this message translates to:
  /// **'Financial investment timing'**
  String get concernsExampleFinance;

  /// No description provided for @concernsExampleHealth.
  ///
  /// In en, this message translates to:
  /// **'Health and wellness focus'**
  String get concernsExampleHealth;

  /// No description provided for @concernsExampleGrowth.
  ///
  /// In en, this message translates to:
  /// **'Personal growth direction'**
  String get concernsExampleGrowth;

  /// No description provided for @concernsSubmitButton.
  ///
  /// In en, this message translates to:
  /// **'Submit Concern'**
  String get concernsSubmitButton;

  /// No description provided for @concernsSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Concern Recorded!'**
  String get concernsSuccessTitle;

  /// No description provided for @concernsCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category: '**
  String get concernsCategoryLabel;

  /// No description provided for @concernsSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Starting tomorrow, your daily guidance will focus more on this topic.'**
  String get concernsSuccessMessage;

  /// No description provided for @concernsViewFocusTopics.
  ///
  /// In en, this message translates to:
  /// **'View My Focus Topics'**
  String get concernsViewFocusTopics;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountHeading.
  ///
  /// In en, this message translates to:
  /// **'Delete Your Account?'**
  String get deleteAccountHeading;

  /// No description provided for @deleteAccountConfirmError.
  ///
  /// In en, this message translates to:
  /// **'Please type DELETE to confirm'**
  String get deleteAccountConfirmError;

  /// No description provided for @deleteAccountFinalWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'Final Warning'**
  String get deleteAccountFinalWarningTitle;

  /// No description provided for @deleteAccountFinalWarningBody.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. All your data, including:\n\n• Your profile and birth data\n• Natal chart and interpretations\n• Daily guidance history\n• Personal context and preferences\n• All purchased content\n\nWill be permanently deleted.'**
  String get deleteAccountFinalWarningBody;

  /// No description provided for @deleteAccountConfirmButton.
  ///
  /// In en, this message translates to:
  /// **'Delete Forever'**
  String get deleteAccountConfirmButton;

  /// No description provided for @deleteAccountSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your account has been deleted'**
  String get deleteAccountSuccess;

  /// No description provided for @deleteAccountFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete account. Please try again.'**
  String get deleteAccountFailed;

  /// No description provided for @deleteAccountPermanentWarning.
  ///
  /// In en, this message translates to:
  /// **'This action is permanent and cannot be undone'**
  String get deleteAccountPermanentWarning;

  /// No description provided for @deleteAccountWarningDetail.
  ///
  /// In en, this message translates to:
  /// **'All your personal data, including your natal chart, guidance history, and any purchases will be permanently deleted.'**
  String get deleteAccountWarningDetail;

  /// No description provided for @deleteAccountWhatTitle.
  ///
  /// In en, this message translates to:
  /// **'What will be deleted:'**
  String get deleteAccountWhatTitle;

  /// No description provided for @deleteAccountItemProfile.
  ///
  /// In en, this message translates to:
  /// **'Your profile and account'**
  String get deleteAccountItemProfile;

  /// No description provided for @deleteAccountItemBirthData.
  ///
  /// In en, this message translates to:
  /// **'Birth data and natal chart'**
  String get deleteAccountItemBirthData;

  /// No description provided for @deleteAccountItemGuidance.
  ///
  /// In en, this message translates to:
  /// **'All daily guidance history'**
  String get deleteAccountItemGuidance;

  /// No description provided for @deleteAccountItemContext.
  ///
  /// In en, this message translates to:
  /// **'Personal context & preferences'**
  String get deleteAccountItemContext;

  /// No description provided for @deleteAccountItemKarmic.
  ///
  /// In en, this message translates to:
  /// **'Karmic astrology readings'**
  String get deleteAccountItemKarmic;

  /// No description provided for @deleteAccountItemPurchases.
  ///
  /// In en, this message translates to:
  /// **'All purchased content'**
  String get deleteAccountItemPurchases;

  /// No description provided for @deleteAccountTypeDelete.
  ///
  /// In en, this message translates to:
  /// **'Type DELETE to confirm'**
  String get deleteAccountTypeDelete;

  /// No description provided for @deleteAccountDeleteHint.
  ///
  /// In en, this message translates to:
  /// **'DELETE'**
  String get deleteAccountDeleteHint;

  /// No description provided for @deleteAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Delete My Account'**
  String get deleteAccountButton;

  /// No description provided for @deleteAccountCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel, keep my account'**
  String get deleteAccountCancel;

  /// No description provided for @learnArticleLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load article'**
  String get learnArticleLoadFailed;

  /// No description provided for @learnContentInEnglish.
  ///
  /// In en, this message translates to:
  /// **'Content in English'**
  String get learnContentInEnglish;

  /// No description provided for @learnArticlesLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load articles'**
  String get learnArticlesLoadFailed;

  /// No description provided for @learnArticlesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No articles available yet'**
  String get learnArticlesEmpty;

  /// No description provided for @learnContentFallback.
  ///
  /// In en, this message translates to:
  /// **'Showing content in English (not available in your language)'**
  String get learnContentFallback;

  /// No description provided for @checkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkoutTitle;

  /// No description provided for @checkoutOrderSummary.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get checkoutOrderSummary;

  /// No description provided for @checkoutProTitle.
  ///
  /// In en, this message translates to:
  /// **'Pro Natal Chart'**
  String get checkoutProTitle;

  /// No description provided for @checkoutProSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Full planetary interpretations'**
  String get checkoutProSubtitle;

  /// No description provided for @checkoutTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get checkoutTotalLabel;

  /// No description provided for @checkoutTotalAmount.
  ///
  /// In en, this message translates to:
  /// **'\$9.99 USD'**
  String get checkoutTotalAmount;

  /// No description provided for @checkoutPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment Integration'**
  String get checkoutPaymentTitle;

  /// No description provided for @checkoutPaymentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'In-App Purchase integration is being finalized. Please check back soon!'**
  String get checkoutPaymentSubtitle;

  /// No description provided for @checkoutProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get checkoutProcessing;

  /// No description provided for @checkoutDemoPurchase.
  ///
  /// In en, this message translates to:
  /// **'Demo Purchase (Testing)'**
  String get checkoutDemoPurchase;

  /// No description provided for @checkoutSecurityNote.
  ///
  /// In en, this message translates to:
  /// **'Payment is processed securely through Apple/Google. Your card details are never stored.'**
  String get checkoutSecurityNote;

  /// No description provided for @checkoutSuccess.
  ///
  /// In en, this message translates to:
  /// **'🎉 Pro Natal Chart unlocked successfully!'**
  String get checkoutSuccess;

  /// No description provided for @checkoutGenerateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to generate interpretations. Please try again.'**
  String get checkoutGenerateFailed;

  /// No description provided for @checkoutErrorWithMessage.
  ///
  /// In en, this message translates to:
  /// **'An error occurred: {error}'**
  String checkoutErrorWithMessage(Object error);

  /// No description provided for @billingUpgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium'**
  String get billingUpgrade;

  /// No description provided for @billingFeatureLocked.
  ///
  /// In en, this message translates to:
  /// **'{feature} is a Premium feature'**
  String billingFeatureLocked(Object feature);

  /// No description provided for @billingUpgradeBody.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium to unlock this feature and get the most personalized guidance.'**
  String get billingUpgradeBody;

  /// No description provided for @contextReviewFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update. Please try again.'**
  String get contextReviewFailed;

  /// No description provided for @contextReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Time for a Quick Check-in'**
  String get contextReviewTitle;

  /// No description provided for @contextReviewBody.
  ///
  /// In en, this message translates to:
  /// **'It\'s been 3 months since we last updated your personal context. Has anything important changed in your life that we should know about?'**
  String get contextReviewBody;

  /// No description provided for @contextReviewHint.
  ///
  /// In en, this message translates to:
  /// **'This helps us give you more personalized guidance.'**
  String get contextReviewHint;

  /// No description provided for @contextReviewNoChanges.
  ///
  /// In en, this message translates to:
  /// **'No changes'**
  String get contextReviewNoChanges;

  /// No description provided for @contextReviewYesUpdate.
  ///
  /// In en, this message translates to:
  /// **'Yes, update'**
  String get contextReviewYesUpdate;

  /// No description provided for @contextProfileLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load profile'**
  String get contextProfileLoadFailed;

  /// No description provided for @contextCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal Context'**
  String get contextCardTitle;

  /// No description provided for @contextCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set up your personal context to receive more tailored guidance.'**
  String get contextCardSubtitle;

  /// No description provided for @contextCardSetupNow.
  ///
  /// In en, this message translates to:
  /// **'Set Up Now'**
  String get contextCardSetupNow;

  /// No description provided for @contextCardVersionUpdated.
  ///
  /// In en, this message translates to:
  /// **'Version {version} • Last updated {date}'**
  String contextCardVersionUpdated(Object version, Object date);

  /// No description provided for @contextCardAiSummary.
  ///
  /// In en, this message translates to:
  /// **'AI Summary'**
  String get contextCardAiSummary;

  /// No description provided for @contextCardToneTag.
  ///
  /// In en, this message translates to:
  /// **'{tone} tone'**
  String contextCardToneTag(Object tone);

  /// No description provided for @contextCardSensitivityTag.
  ///
  /// In en, this message translates to:
  /// **'sensitivity on'**
  String get contextCardSensitivityTag;

  /// No description provided for @contextCardReviewDue.
  ///
  /// In en, this message translates to:
  /// **'Review due - update your context'**
  String get contextCardReviewDue;

  /// No description provided for @contextCardNextReview.
  ///
  /// In en, this message translates to:
  /// **'Next review in {days} days'**
  String contextCardNextReview(Object days);

  /// No description provided for @contextDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Personal Context?'**
  String get contextDeleteTitle;

  /// No description provided for @contextDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'This will delete your personal context profile. Your guidance will become less personalized.'**
  String get contextDeleteBody;

  /// No description provided for @contextDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete profile'**
  String get contextDeleteFailed;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Inner Wisdom'**
  String get appTitle;

  /// No description provided for @concernsHintExample.
  ///
  /// In en, this message translates to:
  /// **'Example: I have a job offer in another city and I\'m not sure if I should accept it...'**
  String get concernsHintExample;

  /// No description provided for @learnTitle.
  ///
  /// In en, this message translates to:
  /// **'Learn Astrology'**
  String get learnTitle;

  /// No description provided for @learnFreeTitle.
  ///
  /// In en, this message translates to:
  /// **'Free Learning Resources'**
  String get learnFreeTitle;

  /// No description provided for @learnFreeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Explore the fundamentals of astrology'**
  String get learnFreeSubtitle;

  /// No description provided for @learnSignsTitle.
  ///
  /// In en, this message translates to:
  /// **'Signs'**
  String get learnSignsTitle;

  /// No description provided for @learnSignsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'12 Zodiac signs and their meanings'**
  String get learnSignsSubtitle;

  /// No description provided for @learnPlanetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Planets'**
  String get learnPlanetsTitle;

  /// No description provided for @learnPlanetsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Celestial bodies in astrology'**
  String get learnPlanetsSubtitle;

  /// No description provided for @learnHousesTitle.
  ///
  /// In en, this message translates to:
  /// **'Houses'**
  String get learnHousesTitle;

  /// No description provided for @learnHousesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'12 life areas in your chart'**
  String get learnHousesSubtitle;

  /// No description provided for @learnTransitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Transits'**
  String get learnTransitsTitle;

  /// No description provided for @learnTransitsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Planetary movements & effects'**
  String get learnTransitsSubtitle;

  /// No description provided for @learnPaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Learn at Your Pace'**
  String get learnPaceTitle;

  /// No description provided for @learnPaceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive lessons to deepen your astrological knowledge'**
  String get learnPaceSubtitle;

  /// No description provided for @proNatalTitle.
  ///
  /// In en, this message translates to:
  /// **'Pro Natal Chart'**
  String get proNatalTitle;

  /// No description provided for @proNatalHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock Deep Insights'**
  String get proNatalHeroTitle;

  /// No description provided for @proNatalHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get comprehensive 150-200 word interpretations for each planetary placement in your birth chart.'**
  String get proNatalHeroSubtitle;

  /// No description provided for @proNatalFeature1Title.
  ///
  /// In en, this message translates to:
  /// **'Deep Personality Insights'**
  String get proNatalFeature1Title;

  /// No description provided for @proNatalFeature1Body.
  ///
  /// In en, this message translates to:
  /// **'Understand how each planet shapes your unique personality and life path.'**
  String get proNatalFeature1Body;

  /// No description provided for @proNatalFeature2Title.
  ///
  /// In en, this message translates to:
  /// **'AI-Powered Analysis'**
  String get proNatalFeature2Title;

  /// No description provided for @proNatalFeature2Body.
  ///
  /// In en, this message translates to:
  /// **'Advanced interpretations tailored to your exact planetary positions.'**
  String get proNatalFeature2Body;

  /// No description provided for @proNatalFeature3Title.
  ///
  /// In en, this message translates to:
  /// **'Actionable Guidance'**
  String get proNatalFeature3Title;

  /// No description provided for @proNatalFeature3Body.
  ///
  /// In en, this message translates to:
  /// **'Practical advice for career, relationships, and personal growth.'**
  String get proNatalFeature3Body;

  /// No description provided for @proNatalFeature4Title.
  ///
  /// In en, this message translates to:
  /// **'Lifetime Access'**
  String get proNatalFeature4Title;

  /// No description provided for @proNatalFeature4Body.
  ///
  /// In en, this message translates to:
  /// **'Your interpretations are saved forever. Access anytime.'**
  String get proNatalFeature4Body;

  /// No description provided for @proNatalOneTime.
  ///
  /// In en, this message translates to:
  /// **'One-time purchase'**
  String get proNatalOneTime;

  /// No description provided for @proNatalNoSubscription.
  ///
  /// In en, this message translates to:
  /// **'No subscription required'**
  String get proNatalNoSubscription;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'de',
        'en',
        'es',
        'fr',
        'hu',
        'it',
        'pl',
        'ro'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hu':
      return AppLocalizationsHu();
    case 'it':
      return AppLocalizationsIt();
    case 'pl':
      return AppLocalizationsPl();
    case 'ro':
      return AppLocalizationsRo();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

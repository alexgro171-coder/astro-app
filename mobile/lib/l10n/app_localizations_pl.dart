// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingTitle1 => 'Welcome to Inner Wisdom Astro';

  @override
  String get onboardingDesc1 =>
      'Innerwisdom Astro brings together over 30 years of astrological expertise from Madi G. with the power of advanced AI, creating one of the most refined and high-performance astrology applications available today.\n\nBy blending deep human insight with intelligent technology, Innerwisdom Astro delivers interpretations that are precise, personalized, and meaningful, supporting users on their journey of self-discovery, clarity, and conscious growth.';

  @override
  String get onboardingTitle2 => 'Your Complete Astrological Journey';

  @override
  String get onboardingDesc2 =>
      'From personalized daily guidance to your Natal Birth Chart, Karmic Astrology, in-depth personality reports, Love and Friendship Compatibility, Romantic Forecasts for Couples, and much more — all are now at your fingertips.\n\nDesigned to support clarity, connection, and self-understanding, Innerwisdom Astro offers a complete astrological experience, tailored to you.';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingGetStarted => 'Get Started';

  @override
  String get onboardingAlreadyHaveAccount => 'Already have an account? Login';

  @override
  String get birthDataTitle => 'Your Birth Chart';

  @override
  String get birthDataSubtitle =>
      'We need your birth details to create\nyour personalized astrological profile';

  @override
  String get birthDateLabel => 'Birth Date';

  @override
  String get birthDateSelectHint => 'Select your birth date';

  @override
  String get birthTimeLabel => 'Birth Time';

  @override
  String get birthTimeUnknown => 'Unknown';

  @override
  String get birthTimeSelectHint => 'Select your birth time';

  @override
  String get birthTimeUnknownCheckbox => 'I don\'t know my exact birth time';

  @override
  String get birthPlaceLabel => 'Birth Place';

  @override
  String get birthPlaceHint => 'Start typing a city name...';

  @override
  String get birthPlaceValidation =>
      'Please select a location from the suggestions';

  @override
  String birthPlaceSelected(Object location) {
    return 'Selected: $location';
  }

  @override
  String get genderLabel => 'Gender';

  @override
  String get genderMale => 'Male';

  @override
  String get genderFemale => 'Female';

  @override
  String get genderPreferNotToSay => 'Prefer not to say';

  @override
  String get birthDataSubmit => 'Generate My Birth Chart';

  @override
  String get birthDataPrivacyNote =>
      'Your birth data is used only to calculate your\nastrological chart and is stored securely.';

  @override
  String get birthDateMissing => 'Please select your birth date';

  @override
  String get birthPlaceMissing =>
      'Please select a birth place from the suggestions';

  @override
  String get birthDataSaveError =>
      'Could not save birth data. Please try again.';

  @override
  String get appearanceTitle => 'Appearance';

  @override
  String get appearanceTheme => 'Theme';

  @override
  String get appearanceDarkTitle => 'Dark';

  @override
  String get appearanceDarkSubtitle => 'Easy on the eyes in low light';

  @override
  String get appearanceLightTitle => 'Light';

  @override
  String get appearanceLightSubtitle => 'Classic bright appearance';

  @override
  String get appearanceSystemTitle => 'System';

  @override
  String get appearanceSystemSubtitle => 'Match your device settings';

  @override
  String get appearancePreviewTitle => 'Preview';

  @override
  String get appearancePreviewBody =>
      'The cosmic theme is designed to create an immersive astrology experience. The dark theme is recommended for the best visual experience.';

  @override
  String appearanceThemeChanged(Object theme) {
    return 'Theme changed to $theme';
  }

  @override
  String get profileUserFallback => 'User';

  @override
  String get profilePersonalContext => 'Personal Context';

  @override
  String get profileSettings => 'Settings';

  @override
  String get profileAppLanguage => 'App Language';

  @override
  String get profileContentLanguage => 'Content Language';

  @override
  String get profileContentLanguageHint =>
      'AI content uses the selected language.';

  @override
  String get profileNotifications => 'Notifications';

  @override
  String get profileNotificationsEnabled => 'Enabled';

  @override
  String get profileNotificationsDisabled => 'Disabled';

  @override
  String get profileAppearance => 'Appearance';

  @override
  String get profileHelpSupport => 'Help & Support';

  @override
  String get profilePrivacyPolicy => 'Privacy Policy';

  @override
  String get profileTermsOfService => 'Terms of Service';

  @override
  String get profileLogout => 'Logout';

  @override
  String get profileLogoutConfirm => 'Are you sure you want to logout?';

  @override
  String get profileDeleteAccount => 'Delete Account';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get profileSelectLanguageTitle => 'Select Language';

  @override
  String get profileSelectLanguageSubtitle =>
      'All AI-generated content will be in your selected language.';

  @override
  String profileLanguageUpdated(Object language) {
    return 'Language updated to $language';
  }

  @override
  String profileLanguageUpdateFailed(Object error) {
    return 'Failed to update language: $error';
  }

  @override
  String profileVersion(Object version) {
    return 'Inner Wisdom v$version';
  }

  @override
  String get profileCosmicBlueprint => 'Your Cosmic Blueprint';

  @override
  String get profileSunLabel => '☀️ Sun';

  @override
  String get profileMoonLabel => '🌙 Moon';

  @override
  String get profileRisingLabel => '⬆️ Rising';

  @override
  String get profileUnknown => 'Unknown';

  @override
  String get forgotPasswordTitle => 'Forgot Password?';

  @override
  String get forgotPasswordSubtitle =>
      'Enter your email and we\'ll send you a code to reset your password';

  @override
  String get forgotPasswordSent =>
      'If an account exists, a reset code has been sent to your email.';

  @override
  String get forgotPasswordFailed =>
      'Failed to send reset code. Please try again.';

  @override
  String get forgotPasswordSendCode => 'Send Reset Code';

  @override
  String get forgotPasswordHaveCode => 'Already have a code?';

  @override
  String get forgotPasswordRemember => 'Remember your password? ';

  @override
  String get loginWelcomeBack => 'Welcome Back';

  @override
  String get loginSubtitle => 'Sign in to continue your cosmic journey';

  @override
  String get loginInvalidCredentials => 'Invalid email or password';

  @override
  String get loginGoogleFailed => 'Google sign-in failed. Please try again.';

  @override
  String get loginAppleFailed => 'Apple sign-in failed. Please try again.';

  @override
  String get loginNetworkError =>
      'Network error. Please check your connection.';

  @override
  String get loginSignInCancelled => 'Sign-in was cancelled.';

  @override
  String get loginPasswordHint => 'Enter your password';

  @override
  String get loginForgotPassword => 'Forgot Password?';

  @override
  String get loginSignIn => 'Sign In';

  @override
  String get loginNoAccount => 'Don\'t have an account? ';

  @override
  String get loginSignUp => 'Sign Up';

  @override
  String get commonEmailLabel => 'Email';

  @override
  String get commonEmailHint => 'Enter your email';

  @override
  String get commonEmailRequired => 'Please enter your email';

  @override
  String get commonEmailInvalid => 'Please enter a valid email';

  @override
  String get commonPasswordLabel => 'Password';

  @override
  String get commonPasswordRequired => 'Please enter your password';

  @override
  String get commonOrContinueWith => 'or continue with';

  @override
  String get commonGoogle => 'Google';

  @override
  String get commonApple => 'Apple';

  @override
  String get commonNameLabel => 'Name';

  @override
  String get commonNameHint => 'Enter your name';

  @override
  String get commonNameRequired => 'Please enter your name';

  @override
  String get signupTitle => 'Create Account';

  @override
  String get signupSubtitle => 'Start your cosmic journey with Inner Wisdom';

  @override
  String get signupEmailExists => 'Email already exists or invalid data';

  @override
  String get signupGoogleFailed => 'Google sign-in failed. Please try again.';

  @override
  String get signupAppleFailed => 'Apple sign-in failed. Please try again.';

  @override
  String get signupPasswordHint => 'Create a password (min. 8 characters)';

  @override
  String get signupPasswordMin => 'Password must be at least 8 characters';

  @override
  String get signupConfirmPasswordLabel => 'Confirm Password';

  @override
  String get signupConfirmPasswordHint => 'Confirm your password';

  @override
  String get signupConfirmPasswordRequired => 'Please confirm your password';

  @override
  String get signupPasswordMismatch => 'Passwords do not match';

  @override
  String get signupPreferredLanguage => 'Preferred Language';

  @override
  String get signupCreateAccount => 'Create Account';

  @override
  String get signupHaveAccount => 'Already have an account? ';

  @override
  String get resetPasswordTitle => 'Reset Password';

  @override
  String get resetPasswordSubtitle =>
      'Enter the code sent to your email and set a new password';

  @override
  String get resetPasswordSuccess =>
      'Password reset successful! Redirecting to login...';

  @override
  String get resetPasswordFailed =>
      'Failed to reset password. Please try again.';

  @override
  String get resetPasswordInvalidCode =>
      'Invalid or expired reset code. Please request a new one.';

  @override
  String get resetPasswordMaxAttempts =>
      'Maximum attempts exceeded. Please request a new code.';

  @override
  String get resetCodeLabel => 'Reset Code';

  @override
  String get resetCodeHint => 'Enter 6-digit code';

  @override
  String get resetCodeRequired => 'Please enter the reset code';

  @override
  String get resetCodeLength => 'Code must be 6 digits';

  @override
  String get resetNewPasswordLabel => 'New Password';

  @override
  String get resetNewPasswordHint =>
      'Create a new password (min. 8 characters)';

  @override
  String get resetNewPasswordRequired => 'Please enter a new password';

  @override
  String get resetConfirmPasswordHint => 'Confirm your new password';

  @override
  String get resetPasswordButton => 'Reset Password';

  @override
  String get resetRequestNewCode => 'Request a new code';

  @override
  String get serviceResultGenerated => 'Report Generated';

  @override
  String serviceResultReady(Object title) {
    return 'Your personalized $title is ready';
  }

  @override
  String get serviceResultBackToForYou => 'Back to For You';

  @override
  String get serviceResultNotSavedNotice =>
      'This Report will not be saved. If you wish, you can copy it and save it elsewhere using the Copy function.';

  @override
  String get commonCopy => 'Copy';

  @override
  String get commonCopied => 'Copied to clipboard';

  @override
  String get commonContinue => 'Continue';

  @override
  String get partnerDetailsTitle => 'Partner Details';

  @override
  String get partnerBirthDataTitle => 'Enter partner\'s birth data';

  @override
  String partnerBirthDataFor(Object title) {
    return 'For \"$title\"';
  }

  @override
  String get partnerNameOptionalLabel => 'Name (optional)';

  @override
  String get partnerNameHint => 'Partner\'s name';

  @override
  String get partnerGenderOptionalLabel => 'Gender (optional)';

  @override
  String get partnerBirthDateLabel => 'Birth Date *';

  @override
  String get partnerBirthDateSelect => 'Select birth date';

  @override
  String get partnerBirthDateMissing => 'Please select the birth date';

  @override
  String get partnerBirthTimeOptionalLabel => 'Birth Time (optional)';

  @override
  String get partnerBirthTimeSelect => 'Select birth time';

  @override
  String get partnerBirthPlaceLabel => 'Birth Place *';

  @override
  String get serviceOfferRequiresPartner => 'Requires partner birth data';

  @override
  String get serviceOfferBetaFree => 'Beta testers get free access!';

  @override
  String get serviceOfferUnlocked => 'Unlocked';

  @override
  String get serviceOfferGenerate => 'Generate Report';

  @override
  String serviceOfferUnlockFor(Object price) {
    return 'Unlock for $price';
  }

  @override
  String get serviceOfferPreparing => 'Preparing your personalized report…';

  @override
  String get serviceOfferTimeout =>
      'Taking longer than expected. Please try again.';

  @override
  String get serviceOfferNotReady => 'Report not ready yet. Please try again.';

  @override
  String serviceOfferFetchFailed(Object error) {
    return 'Failed to fetch report: $error';
  }

  @override
  String get commonFree => 'FREE';

  @override
  String get commonLater => 'Later';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonYes => 'Yes';

  @override
  String get commonNo => 'No';

  @override
  String get commonBack => 'Back';

  @override
  String get commonOptional => 'Optional';

  @override
  String get commonNotSpecified => 'Not specified';

  @override
  String get commonJustNow => 'Just now';

  @override
  String get commonViewMore => 'View more';

  @override
  String get commonViewLess => 'View less';

  @override
  String commonMinutesAgo(Object count) {
    return '$count min ago';
  }

  @override
  String commonHoursAgo(Object count) {
    return '${count}h ago';
  }

  @override
  String commonDaysAgo(Object count) {
    return '${count}d ago';
  }

  @override
  String commonDateShort(Object day, Object month, Object year) {
    return '$day/$month/$year';
  }

  @override
  String get askGuideTitle => 'Ask Your Guide';

  @override
  String get askGuideSubtitle => 'Personal cosmic guidance';

  @override
  String askGuideRemaining(Object count) {
    return '$count left';
  }

  @override
  String get askGuideQuestionHint =>
      'Ask anything - love, career, decisions, emotions...';

  @override
  String get askGuideBasedOnChart =>
      'Based on your birth chart & today\'s cosmic energies';

  @override
  String get askGuideThinking => 'Your Guide is thinking...';

  @override
  String get askGuideYourGuide => 'Your Guide';

  @override
  String get askGuideEmptyTitle => 'Ask Your First Question';

  @override
  String get askGuideEmptyBody =>
      'Get instant, deeply personal guidance based on your birth chart and today\'s cosmic energies.';

  @override
  String get askGuideEmptyHint =>
      'Ask anything — love, career, decisions, emotions.';

  @override
  String get askGuideLoadFailed => 'Failed to load data';

  @override
  String askGuideSendFailed(Object error) {
    return 'Failed to send question: $error';
  }

  @override
  String get askGuideLimitTitle => 'Monthly Limit Reached';

  @override
  String get askGuideLimitBody =>
      'You\'ve reached your monthly limit of requests.';

  @override
  String get askGuideLimitAddon =>
      'You can purchase a \$1.99 add-on to continue using this service for the rest of the current billing month.';

  @override
  String askGuideLimitBillingEnd(Object date) {
    return 'Your billing month ends on: $date';
  }

  @override
  String get askGuideLimitGetAddon => 'Get Add-On';

  @override
  String get contextTitle => 'Personal Context';

  @override
  String contextStepOf(Object current, Object total) {
    return 'Step $current of $total';
  }

  @override
  String get contextStep1Title => 'People around you';

  @override
  String get contextStep1Subtitle =>
      'Your relationship and family context helps us understand your emotional landscape.';

  @override
  String get contextStep2Title => 'Professional Life';

  @override
  String get contextStep2Subtitle =>
      'Your work and daily rhythm shape how you experience pressure, growth, and purpose.';

  @override
  String get contextStep3Title => 'How life feels right now';

  @override
  String get contextStep3Subtitle =>
      'There are no right or wrong answers, just your current reality';

  @override
  String get contextStep4Title => 'What matters most to you';

  @override
  String get contextStep4Subtitle =>
      'So your guidance aligns with what you truly care about';

  @override
  String get contextPriorityRequired =>
      'Please select at least one priority area.';

  @override
  String contextSaveFailed(Object error) {
    return 'Failed to save profile: $error';
  }

  @override
  String get contextSaveContinue => 'Save & Continue';

  @override
  String get contextRelationshipStatusTitle => 'Current relationship status';

  @override
  String get contextSeekingRelationshipTitle =>
      'Are you looking for a relationship?';

  @override
  String get contextHasChildrenTitle => 'Do you have children?';

  @override
  String get contextChildrenDetailsOptional => 'Children details (optional)';

  @override
  String get contextAddChild => 'Add child';

  @override
  String get contextChildAgeLabel => 'Age';

  @override
  String contextChildAgeYears(num age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other: 'years',
      one: 'year',
    );
    return '$age $_temp0';
  }

  @override
  String get contextChildGenderLabel => 'Gender';

  @override
  String get contextRelationshipSingle => 'Single';

  @override
  String get contextRelationshipInRelationship => 'In a relationship';

  @override
  String get contextRelationshipMarried => 'Married / Civil partnership';

  @override
  String get contextRelationshipSeparated => 'Separated / Divorced';

  @override
  String get contextRelationshipWidowed => 'Widowed';

  @override
  String get contextRelationshipPreferNotToSay => 'Prefer not to say';

  @override
  String get contextProfessionalStatusTitle => 'Current professional status';

  @override
  String get contextProfessionalStatusOtherHint =>
      'Please specify your work status';

  @override
  String get contextIndustryTitle => 'Main industry/domain';

  @override
  String get contextWorkStatusStudent => 'Student';

  @override
  String get contextWorkStatusUnemployed => 'Unemployed / Between jobs';

  @override
  String get contextWorkStatusEmployedIc => 'Employed (Individual contributor)';

  @override
  String get contextWorkStatusEmployedManagement => 'Employed (Management)';

  @override
  String get contextWorkStatusExecutive => 'Executive / Leadership (C-level)';

  @override
  String get contextWorkStatusSelfEmployed => 'Self-employed / Freelancer';

  @override
  String get contextWorkStatusEntrepreneur => 'Entrepreneur / Business owner';

  @override
  String get contextWorkStatusInvestor => 'Investor';

  @override
  String get contextWorkStatusRetired => 'Retired';

  @override
  String get contextWorkStatusHomemaker => 'Homemaker / Stay-at-home parent';

  @override
  String get contextWorkStatusCareerBreak => 'Career break / Sabbatical';

  @override
  String get contextWorkStatusOther => 'Other';

  @override
  String get contextIndustryTech => 'Tech / IT';

  @override
  String get contextIndustryFinance => 'Finance / Investments';

  @override
  String get contextIndustryHealthcare => 'Healthcare';

  @override
  String get contextIndustryEducation => 'Education';

  @override
  String get contextIndustrySalesMarketing => 'Sales / Marketing';

  @override
  String get contextIndustryRealEstate => 'Real Estate';

  @override
  String get contextIndustryHospitality => 'Hospitality';

  @override
  String get contextIndustryGovernment => 'Government / Public sector';

  @override
  String get contextIndustryCreative => 'Creative industries';

  @override
  String get contextIndustryOther => 'Other';

  @override
  String get contextSelfAssessmentIntro =>
      'Rate your current situation in each area (1 = struggling, 5 = thriving)';

  @override
  String get contextSelfHealthTitle => 'Health & Energy';

  @override
  String get contextSelfHealthSubtitle =>
      '1 = serious issues/low energy, 5 = excellent vitality';

  @override
  String get contextSelfSocialTitle => 'Social Life';

  @override
  String get contextSelfSocialSubtitle =>
      '1 = isolated, 5 = thriving social connections';

  @override
  String get contextSelfRomanceTitle => 'Romantic Life';

  @override
  String get contextSelfRomanceSubtitle =>
      '1 = absent/challenging, 5 = fulfilled';

  @override
  String get contextSelfFinanceTitle => 'Financial Stability';

  @override
  String get contextSelfFinanceSubtitle => '1 = major hardship, 5 = excellent';

  @override
  String get contextSelfCareerTitle => 'Career Satisfaction';

  @override
  String get contextSelfCareerSubtitle =>
      '1 = stuck/stressed, 5 = progress/clarity';

  @override
  String get contextSelfGrowthTitle => 'Personal Growth Interest';

  @override
  String get contextSelfGrowthSubtitle => '1 = low interest, 5 = very high';

  @override
  String get contextSelfStruggling => 'Struggling';

  @override
  String get contextSelfThriving => 'Thriving';

  @override
  String get contextPrioritiesTitle =>
      'What are your top priorities right now?';

  @override
  String get contextPrioritiesSubtitle =>
      'Select up to 2 areas you want to focus on';

  @override
  String get contextGuidanceStyleTitle => 'Preferred guidance style';

  @override
  String get contextSensitivityTitle => 'Sensitivity Mode';

  @override
  String get contextSensitivitySubtitle =>
      'Avoid anxiety-inducing or deterministic phrasing in guidance';

  @override
  String get contextPriorityHealth => 'Health & habits';

  @override
  String get contextPriorityCareer => 'Career growth';

  @override
  String get contextPriorityBusiness => 'Business decisions';

  @override
  String get contextPriorityMoney => 'Money & stability';

  @override
  String get contextPriorityLove => 'Love & relationship';

  @override
  String get contextPriorityFamily => 'Family & parenting';

  @override
  String get contextPrioritySocial => 'Social life';

  @override
  String get contextPriorityGrowth => 'Personal growth / mindset';

  @override
  String get contextGuidanceStyleDirect => 'Direct & practical';

  @override
  String get contextGuidanceStyleDirectDesc =>
      'Get straight to actionable advice';

  @override
  String get contextGuidanceStyleEmpathetic => 'Empathetic & reflective';

  @override
  String get contextGuidanceStyleEmpatheticDesc => 'Warm, supportive guidance';

  @override
  String get contextGuidanceStyleBalanced => 'Balanced';

  @override
  String get contextGuidanceStyleBalancedDesc =>
      'Mix of practical and emotional support';

  @override
  String get homeGuidancePreparing =>
      'Reading the stars and asking the Universe about you…';

  @override
  String get homeGuidanceFailed =>
      'Failed to generate guidance. Please try again.';

  @override
  String get homeGuidanceTimeout =>
      'Taking longer than expected. Tap Retry or check back in a moment.';

  @override
  String get homeGuidanceLoadFailed => 'Failed to load guidance';

  @override
  String get homeTodaysGuidance => 'Today\'s Guidance';

  @override
  String get homeSeeAll => 'See all';

  @override
  String get homeHealth => 'Health';

  @override
  String get homeCareer => 'Career';

  @override
  String get homeMoney => 'Money';

  @override
  String get homeLove => 'Love';

  @override
  String get homePartners => 'Partners';

  @override
  String get homeGrowth => 'Growth';

  @override
  String get homeTraveler => 'Traveler';

  @override
  String homeGreeting(Object name) {
    return 'Hello, $name';
  }

  @override
  String get homeFocusFallback => 'Personal Growth';

  @override
  String get homeDailyMessage => 'Your Daily Message';

  @override
  String get homeNatalChartTitle => 'My Natal Chart';

  @override
  String get homeNatalChartSubtitle =>
      'Explore your birth chart & interpretations';

  @override
  String get navHome => 'Home';

  @override
  String get navHistory => 'History';

  @override
  String get navGuide => 'Guide';

  @override
  String get navProfile => 'Profile';

  @override
  String get navForYou => 'For You';

  @override
  String get commonToday => 'Today';

  @override
  String get commonTryAgain => 'Try Again';

  @override
  String get natalChartTitle => 'My Natal Chart';

  @override
  String get natalChartTabTable => 'Table';

  @override
  String get natalChartTabChart => 'Chart';

  @override
  String get natalChartEmptyTitle => 'No Natal Chart Data';

  @override
  String get natalChartEmptySubtitle =>
      'Please complete your birth data to see your natal chart.';

  @override
  String get natalChartAddBirthData => 'Add Birth Data';

  @override
  String get natalChartErrorTitle => 'Unable to load chart';

  @override
  String get guidanceTitle => 'Daily Guidance';

  @override
  String get guidanceLoadFailed => 'Failed to load guidance';

  @override
  String get guidanceNoneAvailable => 'No guidance available';

  @override
  String get guidanceCosmicEnergyTitle => 'Today\'s Cosmic Energy';

  @override
  String get guidanceMoodLabel => 'Mood';

  @override
  String get guidanceFocusLabel => 'Focus';

  @override
  String get guidanceYourGuidance => 'Your Guidance';

  @override
  String get guidanceTapToCollapse => 'Tap to collapse';

  @override
  String get historyTitle => 'Guidance History';

  @override
  String get historySubtitle => 'Your cosmic journey through time';

  @override
  String get historyLoadFailed => 'Failed to load history';

  @override
  String get historyEmptyTitle => 'No history yet';

  @override
  String get historyEmptySubtitle => 'Your daily guidances will appear here';

  @override
  String get historyNewBadge => 'NEW';

  @override
  String get commonUnlocked => 'Unlocked';

  @override
  String get commonComingSoon => 'Coming Soon';

  @override
  String get commonSomethingWentWrong => 'Something went wrong';

  @override
  String get commonNoContent => 'No content available.';

  @override
  String get commonUnknownError => 'Unknown error';

  @override
  String get commonTakingLonger =>
      'Taking longer than expected. Please try again.';

  @override
  String commonErrorWithMessage(Object error) {
    return 'Error: $error';
  }

  @override
  String get forYouTitle => 'For You';

  @override
  String get forYouSubtitle => 'Personalized cosmic insights';

  @override
  String get forYouNatalChartTitle => 'My Natal Chart';

  @override
  String get forYouNatalChartSubtitle => 'Your birth chart analysis';

  @override
  String get forYouCompatibilitiesTitle => 'Compatibilities';

  @override
  String get forYouCompatibilitiesSubtitle =>
      'Love, friendship & partnership reports';

  @override
  String get forYouKarmicTitle => 'Karmic Astrology';

  @override
  String get forYouKarmicSubtitle => 'Soul lessons & past life patterns';

  @override
  String get forYouLearnTitle => 'Learn Astrology';

  @override
  String get forYouLearnSubtitle => 'Free educational content';

  @override
  String get compatibilitiesTitle => 'Compatibilities';

  @override
  String get compatibilitiesLoadFailed => 'Failed to load services';

  @override
  String get compatibilitiesBetaFree => 'Beta: All reports are FREE!';

  @override
  String get compatibilitiesChooseReport => 'Choose a Report';

  @override
  String get compatibilitiesSubtitle =>
      'Discover insights about yourself and your relationships';

  @override
  String get compatibilitiesPartnerBadge => '+Partner';

  @override
  String get compatibilitiesPersonalityTitle => 'Personality Report';

  @override
  String get compatibilitiesPersonalitySubtitle =>
      'Comprehensive analysis of your personality based on your natal chart';

  @override
  String get compatibilitiesRomanticPersonalityTitle =>
      'Romantic Personality Report';

  @override
  String get compatibilitiesRomanticPersonalitySubtitle =>
      'Understand how you approach love and romance';

  @override
  String get compatibilitiesLoveCompatibilityTitle => 'Love Compatibility';

  @override
  String get compatibilitiesLoveCompatibilitySubtitle =>
      'Detailed romantic compatibility analysis with your partner';

  @override
  String get compatibilitiesRomanticForecastTitle => 'Romantic Couple Forecast';

  @override
  String get compatibilitiesRomanticForecastSubtitle =>
      'Insights into the future of your relationship';

  @override
  String get compatibilitiesFriendshipTitle => 'Friendship Report';

  @override
  String get compatibilitiesFriendshipSubtitle =>
      'Analyze friendship dynamics and compatibility';

  @override
  String get moonPhaseTitle => 'Moon Phase Report';

  @override
  String get moonPhaseSubtitle =>
      'Understand the current lunar energy and how it affects you. Get guidance aligned with the moon\'s phase.';

  @override
  String get moonPhaseSelectDate => 'Select Date';

  @override
  String get moonPhaseOriginalPrice => '\$2.99';

  @override
  String get moonPhaseGenerate => 'Generate Report';

  @override
  String get moonPhaseGenerateDifferentDate => 'Generate for Different Date';

  @override
  String get moonPhaseGenerationFailed => 'Generation failed';

  @override
  String get moonPhaseGenerating =>
      'Report is being generated. Please try again.';

  @override
  String get moonPhaseUnknownError => 'Something went wrong. Please try again.';

  @override
  String get requiredFieldsNote => 'Fields marked with * are required.';

  @override
  String get karmicTitle => 'Karmic Astrology';

  @override
  String karmicLoadFailed(Object error) {
    return 'Failed to load: $error';
  }

  @override
  String get karmicOfferTitle => '🔮 Karmic Astrology – Messages of the Soul';

  @override
  String get karmicOfferBody =>
      'Karmic Astrology reveals the deep patterns shaping your life, beyond everyday events.\n\nIt offers an interpretation that speaks about unresolved lessons, karmic connections, and the soul\'s path of growth.\n\nThis is not about what comes next,\nbut about why you are experiencing what you experience.\n\n✨ Activate Karmic Astrology and discover the deeper meaning of your journey.';

  @override
  String get karmicBetaFreeBadge => 'Beta Testers – FREE Access!';

  @override
  String karmicPriceBeta(Object price) {
    return '\$$price – Beta Testers Free';
  }

  @override
  String karmicPriceUnlock(Object price) {
    return 'Unlock for \$$price';
  }

  @override
  String get karmicHintInstant => 'Your reading will be generated instantly';

  @override
  String get karmicHintOneTime => 'One-time purchase, no subscription';

  @override
  String get karmicProgressHint => 'Connecting to your karmic path…';

  @override
  String karmicGenerateFailed(Object error) {
    return 'Failed to generate: $error';
  }

  @override
  String get karmicCheckoutTitle => 'Karmic Astrology Checkout';

  @override
  String get karmicCheckoutSubtitle => 'Purchase flow coming soon';

  @override
  String karmicGenerationFailed(Object error) {
    return 'Generation failed: $error';
  }

  @override
  String get karmicLoading => 'Loading your karmic reading...';

  @override
  String get karmicGenerationFailedShort => 'Generation failed';

  @override
  String get karmicGeneratingTitle => 'Generating Your Karmic Reading...';

  @override
  String get karmicGeneratingSubtitle =>
      'Analyzing your natal chart for karmic patterns and soul lessons.';

  @override
  String get karmicReadingTitle => '🔮 Your Karmic Reading';

  @override
  String get karmicReadingSubtitle => 'Messages of the Soul';

  @override
  String get karmicDisclaimer =>
      'This reading is for self-reflection and entertainment purposes. It does not constitute professional advice.';

  @override
  String get commonActive => 'Active';

  @override
  String get commonBackToHome => 'Back to Home';

  @override
  String get commonYesterday => 'yesterday';

  @override
  String commonWeeksAgo(Object count) {
    return '$count weeks ago';
  }

  @override
  String commonMonthsAgo(Object count) {
    return '$count months ago';
  }

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonDelete => 'Delete';

  @override
  String get natalChartProGenerated =>
      'Pro interpretations generated! Scroll up to see them.';

  @override
  String get natalChartHouse1 => 'Self & Identity';

  @override
  String get natalChartHouse2 => 'Money & Values';

  @override
  String get natalChartHouse3 => 'Communication';

  @override
  String get natalChartHouse4 => 'Home & Family';

  @override
  String get natalChartHouse5 => 'Creativity & Romance';

  @override
  String get natalChartHouse6 => 'Health & Routine';

  @override
  String get natalChartHouse7 => 'Relationships';

  @override
  String get natalChartHouse8 => 'Transformation';

  @override
  String get natalChartHouse9 => 'Philosophy & Travel';

  @override
  String get natalChartHouse10 => 'Career & Status';

  @override
  String get natalChartHouse11 => 'Friends & Goals';

  @override
  String get natalChartHouse12 => 'Spirituality';

  @override
  String get helpSupportTitle => 'Help & Support';

  @override
  String get helpSupportContactTitle => 'Contact Support';

  @override
  String get helpSupportContactSubtitle =>
      'We typically respond within 24 hours';

  @override
  String get helpSupportFaqTitle => 'Frequently Asked Questions';

  @override
  String get helpSupportEmailSubject => 'Inner Wisdom Support Request';

  @override
  String get helpSupportEmailAppFailed =>
      'Could not open email app. Please email support@innerwisdomapp.com';

  @override
  String get helpSupportEmailFallback =>
      'Please email us at support@innerwisdomapp.com';

  @override
  String get helpSupportFaq1Q => 'How accurate is the daily guidance?';

  @override
  String get helpSupportFaq1A =>
      'Our daily guidance combines traditional astrological principles with your personal birth chart. While astrology is interpretive, our AI provides personalized insights based on real planetary positions and aspects.';

  @override
  String get helpSupportFaq2Q => 'Why do I need my birth time?';

  @override
  String get helpSupportFaq2A =>
      'Your birth time determines your Ascendant (Rising sign) and the positions of houses in your chart. Without it, we use noon as a default, which may affect the accuracy of house-related interpretations.';

  @override
  String get helpSupportFaq3Q => 'How do I change my birth data?';

  @override
  String get helpSupportFaq3A =>
      'Currently, birth data cannot be changed after initial setup to ensure consistency in your readings. Contact support if you need to make corrections.';

  @override
  String get helpSupportFaq4Q => 'What is a Focus topic?';

  @override
  String get helpSupportFaq4A =>
      'A Focus topic is a current concern or life area you want to emphasize. When set, your daily guidance will pay special attention to this area, providing more relevant insights.';

  @override
  String get helpSupportFaq5Q => 'How does the subscription work?';

  @override
  String get helpSupportFaq5A =>
      'The free tier includes basic daily guidance. Premium subscribers get enhanced personalization, audio readings, and access to special features like Karmic Astrology readings.';

  @override
  String get helpSupportFaq6Q => 'Is my data private?';

  @override
  String get helpSupportFaq6A =>
      'Yes! We take privacy seriously. Your birth data and personal information are encrypted and never shared with third parties. You can delete your account at any time.';

  @override
  String get helpSupportFaq7Q => 'What if I disagree with a reading?';

  @override
  String get helpSupportFaq7A =>
      'Astrology is interpretive, and not every reading will resonate. Use the feedback feature to help us improve. Our AI learns from your preferences over time.';

  @override
  String get notificationsSaved => 'Notification settings saved';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsSectionTitle => 'Push Notifications';

  @override
  String get notificationsDailyTitle => 'Daily Guidance';

  @override
  String get notificationsDailySubtitle =>
      'Get notified when your daily guidance is ready';

  @override
  String get notificationsWeeklyTitle => 'Weekly Highlights';

  @override
  String get notificationsWeeklySubtitle =>
      'Weekly cosmic overview and key transits';

  @override
  String get notificationsSpecialTitle => 'Special Events';

  @override
  String get notificationsSpecialSubtitle =>
      'Full moons, eclipses, and retrogrades';

  @override
  String get notificationsDeviceHint =>
      'You can also control notifications in your device settings.';

  @override
  String get concernsTitle => 'Your Focus';

  @override
  String get concernsSubtitle => 'Topics shaping your guidance';

  @override
  String concernsTabActive(Object count) {
    return 'Active ($count)';
  }

  @override
  String concernsTabResolved(Object count) {
    return 'Resolved ($count)';
  }

  @override
  String concernsTabArchived(Object count) {
    return 'Archived ($count)';
  }

  @override
  String get concernsEmptyTitle => 'No concerns here';

  @override
  String get concernsEmptySubtitle =>
      'Add a focus topic to get personalized guidance';

  @override
  String get concernsCategoryCareer => 'Career & Job';

  @override
  String get concernsCategoryHealth => 'Health';

  @override
  String get concernsCategoryRelationship => 'Relationship';

  @override
  String get concernsCategoryFamily => 'Family';

  @override
  String get concernsCategoryMoney => 'Money';

  @override
  String get concernsCategoryBusiness => 'Business';

  @override
  String get concernsCategoryPartnership => 'Partnership';

  @override
  String get concernsCategoryGrowth => 'Personal Growth';

  @override
  String get concernsMinLength =>
      'Please describe your concern in more detail (at least 10 characters)';

  @override
  String get concernsSubmitFailed =>
      'Failed to submit concern. Please try again.';

  @override
  String get concernsAddTitle => 'What\'s on your mind?';

  @override
  String get concernsAddDescription =>
      'Share your current concern, question, or life situation. Our AI will analyze it and provide focused guidance starting tomorrow.';

  @override
  String get concernsExamplesTitle => 'Examples of concerns:';

  @override
  String get concernsExampleCareer => 'Career change decision';

  @override
  String get concernsExampleRelationship => 'Relationship challenges';

  @override
  String get concernsExampleFinance => 'Financial investment timing';

  @override
  String get concernsExampleHealth => 'Health and wellness focus';

  @override
  String get concernsExampleGrowth => 'Personal growth direction';

  @override
  String get concernsSubmitButton => 'Submit Concern';

  @override
  String get concernsSuccessTitle => 'Concern Recorded!';

  @override
  String get concernsCategoryLabel => 'Category: ';

  @override
  String get concernsSuccessMessage =>
      'Starting tomorrow, your daily guidance will focus more on this topic.';

  @override
  String get concernsViewFocusTopics => 'View My Focus Topics';

  @override
  String get deleteAccountTitle => 'Delete Account';

  @override
  String get deleteAccountHeading => 'Delete Your Account?';

  @override
  String get deleteAccountConfirmError => 'Please type DELETE to confirm';

  @override
  String get deleteAccountFinalWarningTitle => 'Final Warning';

  @override
  String get deleteAccountFinalWarningBody =>
      'This action cannot be undone. All your data, including:\n\n• Your profile and birth data\n• Natal chart and interpretations\n• Daily guidance history\n• Personal context and preferences\n• All purchased content\n\nWill be permanently deleted.';

  @override
  String get deleteAccountConfirmButton => 'Delete Forever';

  @override
  String get deleteAccountSuccess => 'Your account has been deleted';

  @override
  String get deleteAccountFailed =>
      'Failed to delete account. Please try again.';

  @override
  String get deleteAccountPermanentWarning =>
      'This action is permanent and cannot be undone';

  @override
  String get deleteAccountWarningDetail =>
      'All your personal data, including your natal chart, guidance history, and any purchases will be permanently deleted.';

  @override
  String get deleteAccountWhatTitle => 'What will be deleted:';

  @override
  String get deleteAccountItemProfile => 'Your profile and account';

  @override
  String get deleteAccountItemBirthData => 'Birth data and natal chart';

  @override
  String get deleteAccountItemGuidance => 'All daily guidance history';

  @override
  String get deleteAccountItemContext => 'Personal context & preferences';

  @override
  String get deleteAccountItemKarmic => 'Karmic astrology readings';

  @override
  String get deleteAccountItemPurchases => 'All purchased content';

  @override
  String get deleteAccountTypeDelete => 'Type DELETE to confirm';

  @override
  String get deleteAccountDeleteHint => 'DELETE';

  @override
  String get deleteAccountButton => 'Delete My Account';

  @override
  String get deleteAccountCancel => 'Cancel, keep my account';

  @override
  String get learnArticleLoadFailed => 'Failed to load article';

  @override
  String get learnContentInEnglish => 'Content in English';

  @override
  String get learnArticlesLoadFailed => 'Failed to load articles';

  @override
  String get learnArticlesEmpty => 'No articles available yet';

  @override
  String get learnContentFallback =>
      'Showing content in English (not available in your language)';

  @override
  String get checkoutTitle => 'Checkout';

  @override
  String get checkoutOrderSummary => 'Order Summary';

  @override
  String get checkoutProTitle => 'Pro Natal Chart';

  @override
  String get checkoutProSubtitle => 'Full planetary interpretations';

  @override
  String get checkoutTotalLabel => 'Total';

  @override
  String get checkoutTotalAmount => '\$9.99 USD';

  @override
  String get checkoutPaymentTitle => 'Payment Integration';

  @override
  String get checkoutPaymentSubtitle =>
      'In-App Purchase integration is being finalized. Please check back soon!';

  @override
  String get checkoutProcessing => 'Processing...';

  @override
  String get checkoutDemoPurchase => 'Demo Purchase (Testing)';

  @override
  String get checkoutSecurityNote =>
      'Payment is processed securely through Apple/Google. Your card details are never stored.';

  @override
  String get checkoutSuccess => '🎉 Pro Natal Chart unlocked successfully!';

  @override
  String get checkoutGenerateFailed =>
      'Failed to generate interpretations. Please try again.';

  @override
  String checkoutErrorWithMessage(Object error) {
    return 'An error occurred: $error';
  }

  @override
  String get billingUpgrade => 'Upgrade to Premium';

  @override
  String billingFeatureLocked(Object feature) {
    return '$feature is a Premium feature';
  }

  @override
  String get billingUpgradeBody =>
      'Upgrade to Premium to unlock this feature and get the most personalized guidance.';

  @override
  String get contextReviewFailed => 'Failed to update. Please try again.';

  @override
  String get contextReviewTitle => 'Time for a Quick Check-in';

  @override
  String get contextReviewBody =>
      'It\'s been 3 months since we last updated your personal context. Has anything important changed in your life that we should know about?';

  @override
  String get contextReviewHint =>
      'This helps us give you more personalized guidance.';

  @override
  String get contextReviewNoChanges => 'No changes';

  @override
  String get contextReviewYesUpdate => 'Yes, update';

  @override
  String get contextProfileLoadFailed => 'Failed to load profile';

  @override
  String get contextCardTitle => 'Personal Context';

  @override
  String get contextCardSubtitle =>
      'Set up your personal context to receive more tailored guidance.';

  @override
  String get contextCardSetupNow => 'Set Up Now';

  @override
  String contextCardVersionUpdated(Object version, Object date) {
    return 'Version $version • Last updated $date';
  }

  @override
  String get contextCardAiSummary => 'AI Summary';

  @override
  String contextCardToneTag(Object tone) {
    return '$tone tone';
  }

  @override
  String get contextCardSensitivityTag => 'sensitivity on';

  @override
  String get contextCardReviewDue => 'Review due - update your context';

  @override
  String contextCardNextReview(Object days) {
    return 'Next review in $days days';
  }

  @override
  String get contextDeleteTitle => 'Delete Personal Context?';

  @override
  String get contextDeleteBody =>
      'This will delete your personal context profile. Your guidance will become less personalized.';

  @override
  String get contextDeleteFailed => 'Failed to delete profile';

  @override
  String get appTitle => 'Inner Wisdom';

  @override
  String get concernsHintExample =>
      'Example: I have a job offer in another city and I\'m not sure if I should accept it...';

  @override
  String get learnTitle => 'Learn Astrology';

  @override
  String get learnFreeTitle => 'Free Learning Resources';

  @override
  String get learnFreeSubtitle => 'Explore the fundamentals of astrology';

  @override
  String get learnSignsTitle => 'Signs';

  @override
  String get learnSignsSubtitle => '12 Zodiac signs and their meanings';

  @override
  String get learnPlanetsTitle => 'Planets';

  @override
  String get learnPlanetsSubtitle => 'Celestial bodies in astrology';

  @override
  String get learnHousesTitle => 'Houses';

  @override
  String get learnHousesSubtitle => '12 life areas in your chart';

  @override
  String get learnTransitsTitle => 'Transits';

  @override
  String get learnTransitsSubtitle => 'Planetary movements & effects';

  @override
  String get learnPaceTitle => 'Learn at Your Pace';

  @override
  String get learnPaceSubtitle =>
      'Comprehensive lessons to deepen your astrological knowledge';

  @override
  String get proNatalTitle => 'Pro Natal Chart';

  @override
  String get proNatalHeroTitle => 'Unlock Deep Insights';

  @override
  String get proNatalHeroSubtitle =>
      'Get comprehensive 150-200 word interpretations for each planetary placement in your birth chart.';

  @override
  String get proNatalFeature1Title => 'Deep Personality Insights';

  @override
  String get proNatalFeature1Body =>
      'Understand how each planet shapes your unique personality and life path.';

  @override
  String get proNatalFeature2Title => 'AI-Powered Analysis';

  @override
  String get proNatalFeature2Body =>
      'Advanced interpretations tailored to your exact planetary positions.';

  @override
  String get proNatalFeature3Title => 'Actionable Guidance';

  @override
  String get proNatalFeature3Body =>
      'Practical advice for career, relationships, and personal growth.';

  @override
  String get proNatalFeature4Title => 'Lifetime Access';

  @override
  String get proNatalFeature4Body =>
      'Your interpretations are saved forever. Access anytime.';

  @override
  String get proNatalOneTime => 'One-time purchase';

  @override
  String get proNatalNoSubscription => 'No subscription required';
}

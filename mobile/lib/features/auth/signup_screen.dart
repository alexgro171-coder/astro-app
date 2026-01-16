import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/theme/app_theme.dart';
import '../../core/network/api_client.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/services/fcm_service.dart' show fcmServiceProvider;
import '../../core/services/social_auth_service.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _socialAuthService = SocialAuthService();
  bool _isLoading = false;
  bool _isSocialLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;
  String _selectedLanguage = 'EN';

  // Supported languages with their display names and flags
  static const Map<String, Map<String, String>> _languages = {
    'EN': {'name': 'English', 'flag': '🇬🇧'},
    'RO': {'name': 'Română', 'flag': '🇷🇴'},
    'FR': {'name': 'Français', 'flag': '🇫🇷'},
    'DE': {'name': 'Deutsch', 'flag': '🇩🇪'},
    'ES': {'name': 'Español', 'flag': '🇪🇸'},
    'IT': {'name': 'Italiano', 'flag': '🇮🇹'},
    'HU': {'name': 'Magyar', 'flag': '🇭🇺'},
    'PL': {'name': 'Polski', 'flag': '🇵🇱'},
  };

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Register FCM token after successful signup
  Future<void> _registerFcmToken() async {
    if (kIsWeb) return;
    
    try {
      final fcmService = ref.read(fcmServiceProvider);
      // Request permissions and get token
      await fcmService.requestPermissionsAndGetToken();
      // Register with backend
      await fcmService.registerTokenWithBackend();
    } catch (e) {
      debugPrint('SignupScreen: Error registering FCM token: $e');
      // Don't block signup flow if FCM registration fails
    }
  }

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.signup({
        'email': _emailController.text.trim(),
        'password': _passwordController.text,
        'name': _nameController.text.trim(),
        'language': _selectedLanguage,
      });

      final data = response.data;
      await apiClient.saveTokens(data['accessToken'], data['refreshToken']);
      await ref
          .read(appLocaleProvider.notifier)
          .setLocaleCode(_selectedLanguage.toLowerCase());

      // Register FCM token for push notifications
      await _registerFcmToken();

      if (!mounted) return;
      context.go('/birth-data');
    } catch (e) {
      setState(() {
        _errorMessage = l10n.signupEmailExists;
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _isSocialLoading = true;
      _errorMessage = null;
    });

    try {
      debugPrint('SignupScreen: Starting Google sign-in...');
      final result = await _socialAuthService.signInWithGoogle();
      if (result == null) {
        debugPrint('SignupScreen: Google sign-in cancelled by user');
        return;
      }

      debugPrint('SignupScreen: Google sign-in successful, authenticating with backend...');
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.firebaseAuth(
        idToken: result.idToken,
        provider: result.provider,
        name: result.name,
        language: _selectedLanguage,
      );

      final data = response.data;
      await apiClient.saveTokens(data['accessToken'], data['refreshToken']);
      await ref
          .read(appLocaleProvider.notifier)
          .setLocaleCode(_selectedLanguage.toLowerCase());
      debugPrint('SignupScreen: Backend authentication successful');

      // Register FCM token for push notifications
      await _registerFcmToken();

      if (!mounted) return;

      final user = data['user'];
      if (user['onboardingComplete'] == true) {
        context.go('/home');
      } else {
        context.go('/birth-data');
      }
    } catch (e) {
      debugPrint('SignupScreen: Google sign-in error: $e');
      String errorMsg = l10n.signupGoogleFailed;
      if (e.toString().contains('network')) {
        errorMsg = l10n.loginNetworkError;
      } else if (e.toString().contains('cancel')) {
        errorMsg = l10n.loginSignInCancelled;
      }
      setState(() {
        _errorMessage = errorMsg;
      });
    } finally {
      if (mounted) {
        setState(() => _isSocialLoading = false);
      }
    }
  }

  Future<void> _signInWithApple() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _isSocialLoading = true;
      _errorMessage = null;
    });

    try {
      debugPrint('SignupScreen: Starting Apple sign-in...');
      final result = await _socialAuthService.signInWithApple();
      if (result == null) {
        debugPrint('SignupScreen: Apple sign-in cancelled by user');
        return;
      }

      debugPrint('SignupScreen: Apple sign-in successful, authenticating with backend...');
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.firebaseAuth(
        idToken: result.idToken,
        provider: result.provider,
        name: result.name,
        language: _selectedLanguage,
      );

      final data = response.data;
      await apiClient.saveTokens(data['accessToken'], data['refreshToken']);
      await ref
          .read(appLocaleProvider.notifier)
          .setLocaleCode(_selectedLanguage.toLowerCase());
      debugPrint('SignupScreen: Backend authentication successful');

      // Register FCM token for push notifications
      await _registerFcmToken();

      if (!mounted) return;

      final user = data['user'];
      if (user['onboardingComplete'] == true) {
        context.go('/home');
      } else {
        context.go('/birth-data');
      }
    } catch (e) {
      debugPrint('SignupScreen: Apple sign-in error: $e');
      String errorMsg = l10n.signupAppleFailed;
      if (e.toString().contains('AuthorizationErrorCode.canceled')) {
        errorMsg = l10n.loginSignInCancelled;
      } else if (e.toString().contains('network')) {
        errorMsg = l10n.loginNetworkError;
      }
      setState(() {
        _errorMessage = errorMsg;
      });
    } finally {
      if (mounted) {
        setState(() => _isSocialLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.cosmicGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  IconButton(
                    onPressed: () => context.go('/onboarding'),
                    icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                  ),

                  const SizedBox(height: 20),

                  // Header
                  Text(
                    l10n.signupTitle,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.signupSubtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Error message
                  if (_errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.error.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: AppColors.error, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(color: AppColors.error),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Name field
                  Text(
                    l10n.commonNameLabel,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      hintText: l10n.commonNameHint,
                      prefixIcon: const Icon(Icons.person_outline, color: AppColors.textMuted),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.commonNameRequired;
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Email field
                  Text(
                    l10n.commonEmailLabel,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: l10n.commonEmailHint,
                      prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textMuted),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.commonEmailRequired;
                      }
                      if (!value.contains('@')) {
                        return l10n.commonEmailInvalid;
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Password field
                  Text(
                    l10n.commonPasswordLabel,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: l10n.signupPasswordHint,
                      prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textMuted),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: AppColors.textMuted,
                        ),
                        onPressed: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.commonPasswordRequired;
                      }
                      if (value.length < 8) {
                        return l10n.signupPasswordMin;
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Confirm Password field
                  Text(
                    l10n.signupConfirmPasswordLabel,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: l10n.signupConfirmPasswordHint,
                      prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textMuted),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                          color: AppColors.textMuted,
                        ),
                        onPressed: () {
                          setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.signupConfirmPasswordRequired;
                      }
                      if (value != _passwordController.text) {
                        return l10n.signupPasswordMismatch;
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Language selection
                  Text(
                    l10n.signupPreferredLanguage,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.profileSelectLanguageSubtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildLanguageDropdown(),

                  const SizedBox(height: 32),

                  // Signup button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading || _isSocialLoading ? null : _signup,
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primary,
                              ),
                            )
                          : Text(l10n.signupCreateAccount),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Divider with "or"
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: AppColors.textMuted.withOpacity(0.3),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          l10n.commonOrContinueWith,
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: AppColors.textMuted.withOpacity(0.3),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Social sign-up buttons
                  Row(
                    children: [
                      // Google Sign-In
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _isLoading || _isSocialLoading ? null : _signInWithGoogle,
                          icon: _isSocialLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Image.network(
                                  'https://www.google.com/favicon.ico',
                                  width: 20,
                                  height: 20,
                                  errorBuilder: (_, __, ___) => const Icon(Icons.g_mobiledata, size: 24),
                                ),
                          label: Text(l10n.commonGoogle),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textPrimary,
                            side: BorderSide(color: AppColors.textMuted.withOpacity(0.3)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Apple Sign-In (iOS only)
                      if (!kIsWeb && Platform.isIOS)
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _isLoading || _isSocialLoading ? null : _signInWithApple,
                            icon: _isSocialLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.apple, size: 24),
                            label: Text(l10n.commonApple),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.textPrimary,
                              side: BorderSide(color: AppColors.textMuted.withOpacity(0.3)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Login link
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          l10n.signupHaveAccount,
                          style: const TextStyle(color: AppColors.textSecondary),
                        ),
                        TextButton(
                          onPressed: () => context.go('/login'),
                          child: Text(l10n.loginSignIn),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageDropdown() {
    final lang = _languages[_selectedLanguage]!;
    
    return InkWell(
      onTap: _showLanguagePicker,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.accent.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              lang['flag']!,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                lang['name']!,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguagePicker() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.profileSelectLanguageTitle,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textMuted),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l10n.profileSelectLanguageSubtitle,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _languages.length,
                itemBuilder: (context, index) {
                  final code = _languages.keys.elementAt(index);
                  final lang = _languages[code]!;
                  final isSelected = code == _selectedLanguage;
                  
                  return ListTile(
                    leading: Text(
                      lang['flag']!,
                      style: const TextStyle(fontSize: 28),
                    ),
                    title: Text(
                      lang['name']!,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: AppColors.accent)
                        : null,
                    onTap: () {
                      setState(() => _selectedLanguage = code);
                      Navigator.pop(context);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    tileColor: isSelected
                        ? AppColors.accent.withOpacity(0.1)
                        : null,
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}


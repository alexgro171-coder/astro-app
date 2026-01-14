import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/network/api_client.dart';
import '../../core/services/social_auth_service.dart';
import '../../core/services/fcm_service.dart' show fcmServiceProvider;

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _socialAuthService = SocialAuthService();
  bool _isLoading = false;
  bool _isSocialLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Register FCM token after successful login
  Future<void> _registerFcmToken() async {
    if (kIsWeb) return;
    
    try {
      final fcmService = ref.read(fcmServiceProvider);
      // Request permissions and get token
      await fcmService.requestPermissionsAndGetToken();
      // Register with backend
      await fcmService.registerTokenWithBackend();
    } catch (e) {
      debugPrint('LoginScreen: Error registering FCM token: $e');
      // Don't block login flow if FCM registration fails
    }
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.login({
        'email': _emailController.text.trim(),
        'password': _passwordController.text,
      });

      final data = response.data;
      await apiClient.saveTokens(data['accessToken'], data['refreshToken']);

      // Register FCM token for push notifications
      await _registerFcmToken();

      if (!mounted) return;

      // Check if onboarding is complete
      final user = data['user'];
      if (user['onboardingComplete'] == true) {
        context.go('/home');
      } else {
        context.go('/birth-data');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Invalid email or password';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isSocialLoading = true;
      _errorMessage = null;
    });

    try {
      debugPrint('LoginScreen: Starting Google sign-in...');
      final result = await _socialAuthService.signInWithGoogle();
      if (result == null) {
        debugPrint('LoginScreen: Google sign-in cancelled by user');
        return;
      }

      debugPrint('LoginScreen: Google sign-in successful, authenticating with backend...');
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.firebaseAuth(
        idToken: result.idToken,
        provider: result.provider,
        name: result.name,
      );

      final data = response.data;
      await apiClient.saveTokens(data['accessToken'], data['refreshToken']);
      debugPrint('LoginScreen: Backend authentication successful');

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
      debugPrint('LoginScreen: Google sign-in error: $e');
      String errorMsg = 'Google sign-in failed. Please try again.';
      if (e.toString().contains('network')) {
        errorMsg = 'Network error. Please check your connection.';
      } else if (e.toString().contains('cancel')) {
        errorMsg = 'Sign-in was cancelled.';
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
    setState(() {
      _isSocialLoading = true;
      _errorMessage = null;
    });

    try {
      debugPrint('LoginScreen: Starting Apple sign-in...');
      final result = await _socialAuthService.signInWithApple();
      if (result == null) {
        debugPrint('LoginScreen: Apple sign-in cancelled by user');
        return;
      }

      debugPrint('LoginScreen: Apple sign-in successful, authenticating with backend...');
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.firebaseAuth(
        idToken: result.idToken,
        provider: result.provider,
        name: result.name,
      );

      final data = response.data;
      await apiClient.saveTokens(data['accessToken'], data['refreshToken']);
      debugPrint('LoginScreen: Backend authentication successful');

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
      debugPrint('LoginScreen: Apple sign-in error: $e');
      String errorMsg = 'Apple sign-in failed. Please try again.';
      if (e.toString().contains('AuthorizationErrorCode.canceled')) {
        errorMsg = 'Sign-in was cancelled.';
      } else if (e.toString().contains('network')) {
        errorMsg = 'Network error. Please check your connection.';
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
                  const SizedBox(height: 40),

                  // Header
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppColors.accentGradient,
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/InnerLogo_transp.png',
                              width: 60,
                              height: 60,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Welcome Back',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Sign in to continue your cosmic journey',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 48),

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

                  // Email field
                  const Text(
                    'Email',
                    style: TextStyle(
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
                    decoration: const InputDecoration(
                      hintText: 'Enter your email',
                      prefixIcon: Icon(Icons.email_outlined, color: AppColors.textMuted),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Password field
                  const Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _login(),
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
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
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 12),

                  // Forgot password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => context.push('/forgot-password'),
                      child: const Text('Forgot Password?'),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Login button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading || _isSocialLoading ? null : _login,
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primary,
                              ),
                            )
                          : const Text('Sign In'),
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
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'or continue with',
                          style: TextStyle(
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

                  // Social login buttons
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
                          label: const Text('Google'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textPrimary,
                            side: BorderSide(color: AppColors.textMuted.withOpacity(0.3)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Apple Sign-In (iOS only)
                      if (Platform.isIOS)
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
                            label: const Text('Apple'),
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

                  // Sign up link
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                        TextButton(
                          onPressed: () => context.go('/signup'),
                          child: const Text('Sign Up'),
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
}


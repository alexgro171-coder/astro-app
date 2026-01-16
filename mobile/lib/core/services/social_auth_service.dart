import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Service for handling social authentication (Google & Apple Sign-In)
class SocialAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  /// Sign in with Google
  /// Returns Firebase ID token if successful, null otherwise
  Future<SocialAuthResult?> signInWithGoogle() async {
    try {
      // Ensure account picker is shown by clearing any previous session
      try {
        await _googleSignIn.disconnect();
      } catch (_) {
        // Ignore if not signed in or disconnect not supported
      }

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      // Get the Firebase ID token
      final idToken = await userCredential.user?.getIdToken();

      if (idToken == null) {
        throw Exception('Failed to get Firebase ID token');
      }

      return SocialAuthResult(
        idToken: idToken,
        provider: 'google',
        email: userCredential.user?.email,
        name: userCredential.user?.displayName,
      );
    } catch (e) {
      debugPrint('Google Sign-In error: $e');
      rethrow;
    }
  }

  /// Sign in with Apple
  /// Returns Firebase ID token if successful, null otherwise
  Future<SocialAuthResult?> signInWithApple() async {
    try {
      // Generate nonce for security
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      // Request Apple Sign-In
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      // Create OAuth credential
      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in to Firebase
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(oauthCredential);

      // Get the Firebase ID token
      final idToken = await userCredential.user?.getIdToken();

      if (idToken == null) {
        throw Exception('Failed to get Firebase ID token');
      }

      // Apple only provides name on first sign-in
      String? displayName;
      if (appleCredential.givenName != null) {
        displayName = '${appleCredential.givenName} ${appleCredential.familyName ?? ''}'.trim();
      }

      return SocialAuthResult(
        idToken: idToken,
        provider: 'apple',
        email: userCredential.user?.email ?? appleCredential.email,
        name: displayName ?? userCredential.user?.displayName,
      );
    } catch (e) {
      debugPrint('Apple Sign-In error: $e');
      rethrow;
    }
  }

  /// Sign out from all providers
  Future<void> signOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.disconnect().catchError((_) {}),
      _googleSignIn.signOut().catchError((_) {}),
    ]);
  }

  /// Generate a random nonce for Apple Sign-In
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// SHA256 hash of string
  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Check if Apple Sign-In is available on this device
  Future<bool> isAppleSignInAvailable() async {
    return await SignInWithApple.isAvailable();
  }
}

/// Result from social authentication
class SocialAuthResult {
  final String idToken;
  final String provider;
  final String? email;
  final String? name;

  SocialAuthResult({
    required this.idToken,
    required this.provider,
    this.email,
    this.name,
  });
}


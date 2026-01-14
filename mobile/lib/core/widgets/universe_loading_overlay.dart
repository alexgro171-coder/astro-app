import 'package:flutter/material.dart';
import 'dart:async';

import '../theme/app_theme.dart';

/// Loading messages for sequential display (not rotating loop).
/// Message 1: 0-10 seconds
/// Message 2: 10-20 seconds
/// Message 3: 20+ seconds (stays until complete)
const List<String> _loadingMessages = [
  "We're reading the stars and asking the Universe about you…\nPlease hold on a moment while we receive the answer.",
  "The cosmos is aligning your insights…\nJust a moment while we interpret the celestial patterns.",
  "Connecting with universal wisdom…\nYour personalized guidance is being prepared.",
];

/// Universe Loading Overlay Widget.
/// Displays a full-screen loading overlay with animated stars and sequential messages.
/// Messages change every 10 seconds, stopping at the final message.
class UniverseLoadingOverlay extends StatefulWidget {
  final VoidCallback? onCancel;
  final bool showCancelAfter; // Show cancel button after timeout
  final Duration cancelAfterDuration;

  const UniverseLoadingOverlay({
    super.key,
    this.onCancel,
    this.showCancelAfter = true,
    this.cancelAfterDuration = const Duration(seconds: 90),
  });

  @override
  State<UniverseLoadingOverlay> createState() => _UniverseLoadingOverlayState();
}

class _UniverseLoadingOverlayState extends State<UniverseLoadingOverlay>
    with SingleTickerProviderStateMixin {
  int _currentMessageIndex = 0;
  Timer? _messageTimer;
  Timer? _cancelTimer;
  bool _showCancelButton = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Animation for message fade
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Schedule message transitions - 10 seconds each, stop at last message
    _scheduleNextMessage();

    // Show cancel button after timeout
    if (widget.showCancelAfter) {
      _cancelTimer = Timer(widget.cancelAfterDuration, () {
        if (mounted) {
          setState(() {
            _showCancelButton = true;
          });
        }
      });
    }
  }

  void _scheduleNextMessage() {
    // Only schedule if not at the last message
    if (_currentMessageIndex < _loadingMessages.length - 1) {
      _messageTimer = Timer(const Duration(seconds: 10), () {
        if (mounted) {
          _animationController.forward().then((_) {
            setState(() {
              _currentMessageIndex++;
            });
            _animationController.reverse();
            // Schedule next transition if not at last message
            _scheduleNextMessage();
          });
        }
      });
    }
    // If at last message, don't schedule - it stays indefinitely
  }

  @override
  void dispose() {
    _messageTimer?.cancel();
    _cancelTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final message = _loadingMessages[_currentMessageIndex];

    return Container(
      color: AppColors.background.withOpacity(0.95),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated stars/cosmic icon
                _buildCosmicAnimation(),
                
                const SizedBox(height: 48),

                // Loading message with fade animation
                FadeTransition(
                  opacity: ReverseAnimation(_fadeAnimation),
                  child: Text(
                    message,
                    style: const TextStyle(
                      fontSize: 18,
                      color: AppColors.textPrimary,
                      height: 1.6,
                      letterSpacing: 0.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 48),

                // Progress indicator
                const SizedBox(
                  width: 48,
                  height: 48,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
                  ),
                ),

                // Cancel/retry section
                if (_showCancelButton && widget.onCancel != null) ...[
                  const SizedBox(height: 48),
                  Text(
                    "Still working… You can leave and come back later.",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: widget.onCancel,
                    child: const Text(
                      "Check again later",
                      style: TextStyle(
                        color: AppColors.accent,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCosmicAnimation() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(seconds: 2),
      builder: (context, value, child) {
        return Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppColors.accent.withOpacity(0.3 * value),
                AppColors.accent.withOpacity(0.1 * value),
                Colors.transparent,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: Center(
            child: Icon(
              Icons.auto_awesome,
              size: 64,
              color: AppColors.accent.withOpacity(0.5 + (0.5 * value)),
            ),
          ),
        );
      },
    );
  }
}

/// Wrapper widget for showing overlay on top of content.
class UniverseLoadingStack extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final VoidCallback? onCancel;

  const UniverseLoadingStack({
    super.key,
    required this.child,
    required this.isLoading,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: UniverseLoadingOverlay(
              onCancel: onCancel,
            ),
          ),
      ],
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:astro_app/l10n/app_localizations.dart';

import '../../core/theme/app_theme.dart';
import '../../core/network/api_client.dart';
import '../../core/utils/zodiac_utils.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/services/social_auth_service.dart';
import '../shell/main_shell.dart';
import '../context/widgets/context_settings_card.dart';
import '../natal_chart/services/natal_chart_service.dart';
import '../karmic/services/karmic_service.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  Map<String, dynamic>? _user;
  bool _isLoading = true;

  // UI languages (lowercase codes)
  static const Map<String, Map<String, String>> _uiLanguages = {
    'en': {'name': 'English', 'flag': '🇬🇧'},
    'ro': {'name': 'Română', 'flag': '🇷🇴'},
    'fr': {'name': 'Français', 'flag': '🇫🇷'},
    'de': {'name': 'Deutsch', 'flag': '🇩🇪'},
    'es': {'name': 'Español', 'flag': '🇪🇸'},
    'it': {'name': 'Italiano', 'flag': '🇮🇹'},
    'hu': {'name': 'Magyar', 'flag': '🇭🇺'},
    'pl': {'name': 'Polski', 'flag': '🇵🇱'},
  };

  @override
  void initState() {
    super.initState();
    // Set navigation index
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(currentNavIndexProvider.notifier).state = 3;
    });
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.getProfile();
      setState(() {
        _user = response.data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _logout() async {
    final l10n = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(l10n.profileLogout, style: const TextStyle(color: AppColors.textPrimary)),
        content: Text(
          l10n.profileLogoutConfirm,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.profileLogout, style: const TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await SocialAuthService().signOut();
      final apiClient = ref.read(apiClientProvider);
      await apiClient.clearTokens();
      
      // Clear all user-specific cached data
      ref.invalidate(natalChartDataProvider);
      ref.invalidate(natalChartWheelProvider);
      ref.invalidate(karmicStatusProvider);
      
      if (mounted) {
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  
                  // Avatar with zodiac
                  _buildProfileHeader(),
                  
                  const SizedBox(height: 32),

                  // Natal Chart Info
                  if (_user?['natalChart'] != null)
                    _buildNatalChartCard(),

                  const SizedBox(height: 24),

                  // Personal Context Card
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 12),
                    child: Text(
                      l10n.profilePersonalContext,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const ContextSettingsCard(),

                  const SizedBox(height: 24),

                  // Settings
                  _buildSettingsSection(),

                  const SizedBox(height: 32),

                  // Version
                  Text(
                    l10n.profileVersion('1.0.0'),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                  
                  const SizedBox(height: 100),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileHeader() {
    final l10n = AppLocalizations.of(context)!;
    final sunSign = _user?['natalChart']?['sunSign'] as String?;
    final zodiac = ZodiacUtils.getZodiacData(sunSign);
    
    return Column(
      children: [
        // Avatar with zodiac glow
        Stack(
          alignment: Alignment.center,
          children: [
            // Glow effect
            if (zodiac != null)
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: zodiac.color.withOpacity(0.3),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
              ),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: zodiac != null
                      ? [zodiac.gradient[0].withOpacity(0.3), zodiac.gradient[1].withOpacity(0.1)]
                      : [AppColors.surfaceLight, AppColors.surface],
                ),
                border: Border.all(
                  color: zodiac?.color ?? AppColors.accent,
                  width: 3,
                ),
              ),
              child: Center(
                child: zodiac != null
                    ? Text(
                        zodiac.symbol,
                        style: TextStyle(
                          fontSize: 40,
                          color: zodiac.color,
                        ),
                      )
                    : const Icon(
                        Icons.person,
                        size: 50,
                        color: AppColors.accent,
                      ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          _user?['name'] ?? l10n.profileUserFallback,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _user?['email'] ?? '',
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        if (zodiac != null) ...[
          const SizedBox(height: 8),
          ZodiacBadge(signName: sunSign, showName: true),
        ],
      ],
    );
  }

  Widget _buildNatalChartCard() {
    final sunSign = _user!['natalChart']['sunSign'] as String?;
    final moonSign = _user!['natalChart']['moonSign'] as String?;
    final ascendant = _user!['natalChart']['ascendant'] as String?;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.auto_awesome, size: 18, color: AppColors.accent),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.profileCosmicBlueprint,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildZodiacInfo(
                AppLocalizations.of(context)!.profileSunLabel,
                sunSign,
              ),
              _buildZodiacInfo(
                AppLocalizations.of(context)!.profileMoonLabel,
                moonSign,
              ),
              _buildZodiacInfo(
                AppLocalizations.of(context)!.profileRisingLabel,
                ascendant,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildZodiacInfo(String label, String? sign) {
    final l10n = AppLocalizations.of(context)!;
    final zodiac = ZodiacUtils.getZodiacData(sign);
    
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 8),
        if (zodiac != null)
          Text(
            zodiac.symbol,
            style: TextStyle(
              fontSize: 24,
              color: zodiac.color,
            ),
          ),
        const SizedBox(height: 4),
        Text(
          sign ?? l10n.profileUnknown,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: zodiac?.color ?? AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection() {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            l10n.profileSettings,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        _buildAppLanguageDropdown(),
        _buildSettingsItem(
          icon: Icons.notifications_rounded,
          title: l10n.profileNotifications,
          subtitle: _user?['notifyEnabled'] == true
              ? l10n.profileNotificationsEnabled
              : l10n.profileNotificationsDisabled,
          onTap: () => context.push('/notifications-settings'),
        ),
        _buildSettingsItem(
          icon: Icons.color_lens_rounded,
          title: l10n.profileAppearance,
          subtitle: l10n.appearanceDarkTitle,
          onTap: () => context.push('/appearance'),
        ),
        _buildSettingsItem(
          icon: Icons.help_outline_rounded,
          title: l10n.profileHelpSupport,
          onTap: () => context.push('/help-support'),
        ),
        _buildSettingsItem(
          icon: Icons.privacy_tip_rounded,
          title: l10n.profilePrivacyPolicy,
          onTap: () => context.push('/privacy-policy'),
        ),
        _buildSettingsItem(
          icon: Icons.article_outlined,
          title: l10n.profileTermsOfService,
          onTap: () => context.push('/terms-of-service'),
        ),
        const SizedBox(height: 16),
        _buildSettingsItem(
          icon: Icons.logout_rounded,
          title: l10n.profileLogout,
          titleColor: AppColors.error,
          onTap: _logout,
        ),
        const SizedBox(height: 8),
        _buildSettingsItem(
          icon: Icons.delete_forever_rounded,
          title: l10n.profileDeleteAccount,
          titleColor: AppColors.error,
          onTap: () => context.push('/delete-account'),
        ),
      ],
    );
  }

  String _getUiLanguageDisplayName(Locale locale) {
    final lang = _uiLanguages[locale.languageCode];
    if (lang == null) {
      return _uiLanguages['en']!['name']! + ' ' + _uiLanguages['en']!['flag']!;
    }
    return '${lang['name']} ${lang['flag']}';
  }

  Widget _buildAppLanguageDropdown() {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(appLocaleProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.language_rounded,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.profileAppLanguage,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: currentLocale.languageCode,
                    isDense: true,
                    dropdownColor: AppColors.surface,
                    items: _uiLanguages.entries.map((entry) {
                      final code = entry.key;
                      final lang = entry.value;
                      return DropdownMenuItem<String>(
                        value: code,
                        child: Row(
                          children: [
                            Text(lang['flag']!, style: const TextStyle(fontSize: 18)),
                            const SizedBox(width: 8),
                            Text(lang['name']!, style: const TextStyle(color: AppColors.textPrimary)),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (code) async {
                      if (code == null) return;
                      await _updateAppLanguage(code);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateAppLanguage(String code) async {
    final l10n = AppLocalizations.of(context)!;
    final displayName = _uiLanguages[code]?['name'] ?? code;

    await ref.read(appLocaleProvider.notifier).setLocaleCode(code);
    try {
      final apiClient = ref.read(apiClientProvider);
      await apiClient.updateLanguage(code.toUpperCase());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.profileLanguageUpdated(displayName)),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.profileLanguageUpdateFailed(e.toString())),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.surface.withOpacity(0.6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (titleColor ?? AppColors.textSecondary).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: titleColor ?? AppColors.textSecondary,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: titleColor ?? AppColors.textPrimary,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}

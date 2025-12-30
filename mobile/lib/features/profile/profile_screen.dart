import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/network/api_client.dart';
import '../../core/utils/zodiac_utils.dart';
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
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Logout', style: TextStyle(color: AppColors.textPrimary)),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirm == true) {
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
                  const Padding(
                    padding: EdgeInsets.only(left: 4, bottom: 12),
                    child: Text(
                      'Personal Context',
                      style: TextStyle(
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
                  const Text(
                    'Inner Wisdom v1.0.0',
                    style: TextStyle(
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
          _user?['name'] ?? 'User',
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
              const Text(
                'Your Cosmic Blueprint',
                style: TextStyle(
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
              _buildZodiacInfo('☀️ Sun', sunSign),
              _buildZodiacInfo('🌙 Moon', moonSign),
              _buildZodiacInfo('⬆️ Rising', ascendant),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildZodiacInfo(String label, String? sign) {
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
          sign ?? 'Unknown',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'Settings',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        _buildSettingsItem(
          icon: Icons.language_rounded,
          title: 'Language',
          subtitle: _getLanguageDisplayName(_user?['language'] ?? 'EN'),
          onTap: _showLanguagePicker,
        ),
        _buildSettingsItem(
          icon: Icons.notifications_rounded,
          title: 'Notifications',
          subtitle: _user?['notifyEnabled'] == true ? 'Enabled at 08:00' : 'Disabled',
          onTap: () {},
        ),
        _buildSettingsItem(
          icon: Icons.color_lens_rounded,
          title: 'Appearance',
          subtitle: 'Dark theme',
          onTap: () {},
        ),
        _buildSettingsItem(
          icon: Icons.help_outline_rounded,
          title: 'Help & Support',
          onTap: () {},
        ),
        _buildSettingsItem(
          icon: Icons.privacy_tip_rounded,
          title: 'Privacy Policy',
          onTap: () {},
        ),
        const SizedBox(height: 16),
        _buildSettingsItem(
          icon: Icons.logout_rounded,
          title: 'Logout',
          titleColor: AppColors.error,
          onTap: _logout,
        ),
      ],
    );
  }

  String _getLanguageDisplayName(String code) {
    final lang = _languages[code];
    if (lang == null) return 'English 🇬🇧';
    return '${lang['name']} ${lang['flag']}';
  }

  Future<void> _showLanguagePicker() async {
    final currentLanguage = _user?['language'] ?? 'EN';
    
    final selected = await showModalBottomSheet<String>(
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
                const Text(
                  'Select Language',
                  style: TextStyle(
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
            const Text(
              'All AI-generated content will be in your selected language.',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _languages.length,
                itemBuilder: (context, index) {
                  final code = _languages.keys.elementAt(index);
                  final lang = _languages[code]!;
                  final isSelected = code == currentLanguage;
                  
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
                    onTap: () => Navigator.pop(context, code),
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

    if (selected != null && selected != currentLanguage) {
      await _updateLanguage(selected);
    }
  }

  Future<void> _updateLanguage(String languageCode) async {
    try {
      setState(() => _isLoading = true);
      
      final apiClient = ref.read(apiClientProvider);
      await apiClient.updateLanguage(languageCode);
      
      // Reload profile to get updated data
      await _loadProfile();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Language updated to ${_languages[languageCode]?['name'] ?? languageCode}'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update language: $e'),
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

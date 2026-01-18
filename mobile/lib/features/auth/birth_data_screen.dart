import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:astro_app/l10n/app_localizations.dart';

import '../../core/theme/app_theme.dart';
import '../../core/network/api_client.dart';
import '../../core/widgets/location_autocomplete.dart';
import '../../core/providers/locale_provider.dart';

class BirthDataScreen extends ConsumerStatefulWidget {
  const BirthDataScreen({super.key});

  @override
  ConsumerState<BirthDataScreen> createState() => _BirthDataScreenState();
}

// Gender options
enum Gender { male, female, preferNotToSay }

extension GenderExtension on Gender {
  String get apiValue {
    switch (this) {
      case Gender.male:
        return 'MALE';
      case Gender.female:
        return 'FEMALE';
      case Gender.preferNotToSay:
        return 'PREFER_NOT_TO_SAY';
    }
  }
}

class _BirthDataScreenState extends ConsumerState<BirthDataScreen> {
  final _formKey = GlobalKey<FormState>();
  
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _unknownTime = false;
  bool _isLoading = false;
  String? _errorMessage;
  LocationResult? _selectedLocation;
  Gender? _selectedGender;
  String? _selectedLanguageCode;

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
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final currentLocale = ref.read(appLocaleProvider);
    _selectedLanguageCode = currentLocale.languageCode;
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime(1990, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.accent,
              surface: AppColors.surface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.accent,
              surface: AppColors.surface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (time != null) {
      setState(() {
        _selectedTime = time;
        _unknownTime = false;
      });
    }
  }

  String _genderLabel(Gender gender, AppLocalizations l10n) {
    switch (gender) {
      case Gender.male:
        return l10n.genderMale;
      case Gender.female:
        return l10n.genderFemale;
      case Gender.preferNotToSay:
        return l10n.genderPreferNotToSay;
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context)!;
    if (_selectedLanguageCode == null || _selectedLanguageCode!.isEmpty) {
      setState(() => _errorMessage = l10n.profileSelectLanguageTitle);
      return;
    }
    if (_selectedDate == null) {
      setState(() => _errorMessage = l10n.birthDateMissing);
      return;
    }
    if (_selectedLocation == null) {
      setState(() => _errorMessage = l10n.birthPlaceMissing);
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final apiClient = ref.read(apiClientProvider);
      await apiClient.updateLanguage(_selectedLanguageCode!.toUpperCase());
      
      String? birthTime;
      if (_unknownTime) {
        birthTime = 'unknown';
      } else if (_selectedTime != null) {
        birthTime = '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}';
      }

      // Send pre-resolved location data (no ambiguity!)
      await apiClient.setBirthData({
        'birthDate': DateFormat('yyyy-MM-dd').format(_selectedDate!),
        'birthTime': birthTime,
        'location': _selectedLocation!.toJson(),
        if (_selectedGender != null) 'gender': _selectedGender!.apiValue,
      });

      if (!mounted) return;
      
      // Continue to Context Wizard (personal context questionnaire)
      context.go('/context-wizard', extra: {'isOnboarding': true});
    } catch (e) {
      setState(() {
        _errorMessage = l10n.birthDataSaveError;
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
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
                  const SizedBox(height: 20),

                  // Header
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.surfaceLight,
                          ),
                          child: const Icon(
                            Icons.stars,
                            size: 40,
                            color: AppColors.accent,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          l10n.birthDataTitle,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.birthDataSubtitle,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Language (required)
                  Text(
                    l10n.profileAppLanguage,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _showLanguagePicker,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Text(
                            _uiLanguages[_selectedLanguageCode]?['flag'] ?? '🌐',
                            style: const TextStyle(fontSize: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _getUiLanguageDisplayName(_selectedLanguageCode),
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Icon(Icons.expand_more, color: AppColors.textMuted),
                        ],
                      ),
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

                  // Birth Date
                  Text(
                    l10n.birthDateLabel,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _selectDate,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, color: AppColors.textMuted),
                          const SizedBox(width: 12),
                          Text(
                            _selectedDate != null
                                ? DateFormat('MMMM d, yyyy').format(_selectedDate!)
                                : l10n.birthDateSelectHint,
                            style: TextStyle(
                              color: _selectedDate != null
                                  ? AppColors.textPrimary
                                  : AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Birth Time
                  Text(
                    l10n.birthTimeLabel,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _unknownTime ? null : _selectTime,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _unknownTime
                            ? AppColors.surfaceLight.withOpacity(0.5)
                            : AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            color: _unknownTime ? AppColors.textMuted.withOpacity(0.5) : AppColors.textMuted,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _unknownTime
                                ? l10n.birthTimeUnknown
                                : _selectedTime != null
                                    ? _selectedTime!.format(context)
                                    : l10n.birthTimeSelectHint,
                            style: TextStyle(
                              color: _unknownTime
                                  ? AppColors.textMuted.withOpacity(0.5)
                                  : _selectedTime != null
                                      ? AppColors.textPrimary
                                      : AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Checkbox(
                        value: _unknownTime,
                        onChanged: (value) {
                          setState(() {
                            _unknownTime = value ?? false;
                            if (_unknownTime) _selectedTime = null;
                          });
                        },
                        activeColor: AppColors.accent,
                      ),
                      Text(
                        l10n.birthTimeUnknownCheckbox,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Birth Place with Autocomplete
                  Text(
                    l10n.birthPlaceLabel,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LocationAutocomplete(
                    hintText: l10n.birthPlaceHint,
                    initialValue: _selectedLocation,
                    onSelected: (location) {
                      setState(() {
                        _selectedLocation = location;
                        _errorMessage = null;
                      });
                    },
                    validator: (value) {
                      if (_selectedLocation == null) {
                        return l10n.birthPlaceValidation;
                      }
                      return null;
                    },
                  ),
                  if (_selectedLocation != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              l10n.birthPlaceSelected(_selectedLocation!.displayName),
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),

                  // Gender
                  Text(
                    l10n.genderLabel,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: Gender.values.map((gender) {
                        final isSelected = _selectedGender == gender;
                        return InkWell(
                          onTap: () => setState(() => _selectedGender = gender),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.accent.withOpacity(0.15) : null,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                                  color: isSelected ? AppColors.accent : AppColors.textMuted,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  _genderLabel(gender, l10n),
                                  style: TextStyle(
                                    color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submit,
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primary,
                              ),
                            )
                          : Text(l10n.birthDataSubmit),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Info text
                  Center(
                    child: Text(
                      l10n.birthDataPrivacyNote,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                      textAlign: TextAlign.center,
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

  String _getUiLanguageDisplayName(String? code) {
    final lang = code == null ? null : _uiLanguages[code];
    if (lang == null) return 'English 🇬🇧';
    return '${lang['name']} ${lang['flag']}';
  }

  Future<void> _showLanguagePicker() async {
    final l10n = AppLocalizations.of(context)!;
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
              l10n.profileAppLanguage,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  ..._uiLanguages.entries.map((entry) {
                    final code = entry.key;
                    final lang = entry.value;
                    final isSelected = _selectedLanguageCode == code;
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
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );

    if (!mounted) return;
    if (selected == null) return;
    await ref.read(appLocaleProvider.notifier).setLocaleCode(selected);
    if (mounted) {
      setState(() {
        _selectedLanguageCode = selected;
        _errorMessage = null;
      });
    }
  }
}


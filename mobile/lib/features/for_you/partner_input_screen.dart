import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:astro_app/l10n/app_localizations.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/location_autocomplete.dart';

class PartnerInputScreen extends ConsumerStatefulWidget {
  final String title;

  const PartnerInputScreen({super.key, required this.title});

  @override
  ConsumerState<PartnerInputScreen> createState() => _PartnerInputScreenState();
}

// Gender options (match onboarding)
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

class _PartnerInputScreenState extends ConsumerState<PartnerInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  DateTime? _birthDate;
  TimeOfDay? _birthTime;
  bool _unknownTime = false;
  LocationResult? _selectedLocation;
  Gender? _selectedGender;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.partnerDetailsTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
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
                  Text(
                    l10n.partnerBirthDataTitle,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.partnerBirthDataFor(widget.title),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Name (optional)
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: l10n.partnerNameOptionalLabel,
                      hintText: l10n.partnerNameHint,
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Gender (optional)
                  Text(
                    l10n.partnerGenderOptionalLabel,
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
                  const SizedBox(height: 20),

                  // Birth Date (required)
                  Text(
                    l10n.partnerBirthDateLabel,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _selectBirthDate,
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
                          Expanded(
                            child: Text(
                              _birthDate != null
                                  ? DateFormat('MMMM d, yyyy').format(_birthDate!)
                                  : l10n.partnerBirthDateSelect,
                              style: TextStyle(
                                color: _birthDate != null
                                    ? AppColors.textPrimary
                                    : AppColors.textMuted,
                              ),
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down, color: AppColors.textMuted),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Birth Time (optional)
                  Text(
                    l10n.partnerBirthTimeOptionalLabel,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _unknownTime ? null : _selectBirthTime,
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
                          Expanded(
                            child: Text(
                              _unknownTime
                                  ? l10n.birthTimeUnknown
                                  : _birthTime != null
                                      ? '${_birthTime!.hour.toString().padLeft(2, '0')}:${_birthTime!.minute.toString().padLeft(2, '0')}'
                                      : l10n.partnerBirthTimeSelect,
                              style: TextStyle(
                                color: _unknownTime
                                    ? AppColors.textMuted.withOpacity(0.5)
                                    : _birthTime != null
                                        ? AppColors.textPrimary
                                        : AppColors.textMuted,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: _unknownTime ? AppColors.textMuted.withOpacity(0.5) : AppColors.textMuted,
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
                            if (_unknownTime) _birthTime = null;
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
                    l10n.partnerBirthPlaceLabel,
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

                  const SizedBox(height: 16),
                  Text(
                    l10n.requiredFieldsNote,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),

                  // Error message
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
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
                              style: const TextStyle(color: AppColors.error, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 40),

                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        l10n.commonContinue,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectBirthDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(1990),
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
      setState(() {
        _birthDate = date;
        _errorMessage = null;
      });
    }
  }

  Future<void> _selectBirthTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _birthTime ?? TimeOfDay.now(),
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
        _birthTime = time;
        _unknownTime = false;
      });
    }
  }

  void _submit() {
    final l10n = AppLocalizations.of(context)!;
    // Manual validation
    if (_birthDate == null) {
      setState(() => _errorMessage = l10n.partnerBirthDateMissing);
      return;
    }
    if (_selectedLocation == null) {
      setState(() => _errorMessage = l10n.birthPlaceMissing);
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Build partner data with all location details
    final partnerData = <String, dynamic>{
      'birthDate': DateFormat('yyyy-MM-dd').format(_birthDate!),
      // Location data from autocomplete
      'birthCity': _selectedLocation!.placeName,
      'birthCountry': _selectedLocation!.countryName,
      'birthCountryCode': _selectedLocation!.countryCode,
      'birthLat': _selectedLocation!.latitude,
      'birthLon': _selectedLocation!.longitude,
      'birthTimezone': _selectedLocation!.timezoneId,
    };

    if (_nameController.text.isNotEmpty) {
      partnerData['name'] = _nameController.text;
    }

    if (_selectedGender != null) {
      partnerData['gender'] = _selectedGender!.apiValue;
    }

    if (_birthTime != null && !_unknownTime) {
      partnerData['birthTime'] = '${_birthTime!.hour.toString().padLeft(2, '0')}:${_birthTime!.minute.toString().padLeft(2, '0')}';
    }

    context.pop(partnerData);
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
}

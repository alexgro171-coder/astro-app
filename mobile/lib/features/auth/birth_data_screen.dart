import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';
import '../../core/network/api_client.dart';
import '../../core/widgets/location_autocomplete.dart';

class BirthDataScreen extends ConsumerStatefulWidget {
  const BirthDataScreen({super.key});

  @override
  ConsumerState<BirthDataScreen> createState() => _BirthDataScreenState();
}

class _BirthDataScreenState extends ConsumerState<BirthDataScreen> {
  final _formKey = GlobalKey<FormState>();
  
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _unknownTime = false;
  bool _isLoading = false;
  String? _errorMessage;
  LocationResult? _selectedLocation;

  @override
  void dispose() {
    super.dispose();
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      setState(() => _errorMessage = 'Please select your birth date');
      return;
    }
    if (_selectedLocation == null) {
      setState(() => _errorMessage = 'Please select a birth place from the suggestions');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final apiClient = ref.read(apiClientProvider);
      
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
      });

      if (!mounted) return;
      
      // Continue to Context Wizard (personal context questionnaire)
      context.go('/context-wizard', extra: {'isOnboarding': true});
    } catch (e) {
      setState(() {
        _errorMessage = 'Could not save birth data. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
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
                        const Text(
                          'Your Birth Chart',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'We need your birth details to create\nyour personalized astrological profile',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

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
                  const Text(
                    'Birth Date',
                    style: TextStyle(
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
                                : 'Select your birth date',
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
                  const Text(
                    'Birth Time',
                    style: TextStyle(
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
                                ? 'Unknown'
                                : _selectedTime != null
                                    ? _selectedTime!.format(context)
                                    : 'Select your birth time',
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
                      const Text(
                        "I don't know my exact birth time",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Birth Place with Autocomplete
                  const Text(
                    'Birth Place',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LocationAutocomplete(
                    hintText: 'Start typing a city name...',
                    initialValue: _selectedLocation,
                    onSelected: (location) {
                      setState(() {
                        _selectedLocation = location;
                        _errorMessage = null;
                      });
                    },
                    validator: (value) {
                      if (_selectedLocation == null) {
                        return 'Please select a location from the suggestions';
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
                              'Selected: ${_selectedLocation!.displayName}',
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
                          : const Text('Generate My Birth Chart'),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Info text
                  const Center(
                    child: Text(
                      'Your birth data is used only to calculate your\nastrological chart and is stored securely.',
                      style: TextStyle(
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
}


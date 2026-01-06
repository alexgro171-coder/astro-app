import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';

class PartnerInputScreen extends ConsumerStatefulWidget {
  final String title;

  const PartnerInputScreen({super.key, required this.title});

  @override
  ConsumerState<PartnerInputScreen> createState() => _PartnerInputScreenState();
}

class _PartnerInputScreenState extends ConsumerState<PartnerInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _birthTimeController = TextEditingController();

  DateTime? _birthDate;
  double _timezone = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _birthTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Partner Details'),
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
                    'Enter partner\'s birth data',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'For "${widget.title}"',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Name (optional)
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name (optional)',
                      hintText: 'Partner\'s name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Birth Date (required)
                  GestureDetector(
                    onTap: _selectBirthDate,
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Birth Date *',
                          hintText: 'Select birth date',
                          prefixIcon: const Icon(Icons.calendar_today),
                          suffixIcon: const Icon(Icons.arrow_drop_down),
                        ),
                        controller: TextEditingController(
                          text: _birthDate != null
                              ? DateFormat('MMMM d, yyyy').format(_birthDate!)
                              : '',
                        ),
                        validator: (value) {
                          if (_birthDate == null) {
                            return 'Birth date is required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Birth Time (optional)
                  GestureDetector(
                    onTap: _selectBirthTime,
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _birthTimeController,
                        decoration: const InputDecoration(
                          labelText: 'Birth Time (optional)',
                          hintText: 'Select birth time',
                          prefixIcon: Icon(Icons.access_time),
                          suffixIcon: Icon(Icons.arrow_drop_down),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Timezone
                  const Text(
                    'Timezone (UTC offset)',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.public, color: AppColors.textMuted),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<double>(
                              value: _timezone,
                              isExpanded: true,
                              dropdownColor: AppColors.surface,
                              items: _buildTimezoneItems(),
                              onChanged: (value) {
                                setState(() {
                                  _timezone = value ?? 0;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  Text(
                    '* Required field',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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

  List<DropdownMenuItem<double>> _buildTimezoneItems() {
    final timezones = <double>[];
    for (double i = -12; i <= 14; i += 0.5) {
      timezones.add(i);
    }

    return timezones.map((tz) {
      final sign = tz >= 0 ? '+' : '';
      final hours = tz.truncate();
      final minutes = ((tz - hours).abs() * 60).toInt();
      final label = minutes > 0
          ? 'UTC $sign$hours:${minutes.toString().padLeft(2, '0')}'
          : 'UTC $sign$hours';

      return DropdownMenuItem(
        value: tz,
        child: Text(label),
      );
    }).toList();
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
      });
    }
  }

  Future<void> _selectBirthTime() async {
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
      final formatted =
          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      setState(() {
        _birthTimeController.text = formatted;
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final partnerData = <String, dynamic>{
      'birthDate': DateFormat('yyyy-MM-dd').format(_birthDate!),
      'timezone': _timezone,
    };

    if (_nameController.text.isNotEmpty) {
      partnerData['name'] = _nameController.text;
    }

    if (_birthTimeController.text.isNotEmpty) {
      partnerData['birthTime'] = _birthTimeController.text;
    }

    context.pop(partnerData);
  }
}


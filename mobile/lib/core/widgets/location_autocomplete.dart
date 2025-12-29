import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/api_client.dart';
import '../theme/app_theme.dart';

/// Model for a location result from geo-search
class LocationResult {
  final String placeName;
  final String? adminName;
  final String countryName;
  final String countryCode;
  final double latitude;
  final double longitude;
  final String? timezoneId;
  final String displayName;

  LocationResult({
    required this.placeName,
    this.adminName,
    required this.countryName,
    required this.countryCode,
    required this.latitude,
    required this.longitude,
    this.timezoneId,
    required this.displayName,
  });

  factory LocationResult.fromJson(Map<String, dynamic> json) {
    // Handle latitude/longitude as either String or num
    double parseCoord(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }
    
    return LocationResult(
      placeName: json['placeName'] ?? '',
      adminName: json['adminName'],
      countryName: json['countryName'] ?? '',
      countryCode: json['countryCode'] ?? '',
      latitude: parseCoord(json['latitude']),
      longitude: parseCoord(json['longitude']),
      timezoneId: json['timezoneId'],
      displayName: json['displayName'] ?? json['placeName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'placeName': placeName,
    'adminName': adminName,
    'countryName': countryName,
    'countryCode': countryCode,
    'latitude': latitude,
    'longitude': longitude,
    'timezoneId': timezoneId,
  };
}

/// Location autocomplete widget with debouncing
class LocationAutocomplete extends ConsumerStatefulWidget {
  final LocationResult? initialValue;
  final ValueChanged<LocationResult?> onSelected;
  final String? hintText;
  final String? labelText;
  final String? Function(String?)? validator;

  const LocationAutocomplete({
    super.key,
    this.initialValue,
    required this.onSelected,
    this.hintText,
    this.labelText,
    this.validator,
  });

  @override
  ConsumerState<LocationAutocomplete> createState() => _LocationAutocompleteState();
}

class _LocationAutocompleteState extends ConsumerState<LocationAutocomplete> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  
  OverlayEntry? _overlayEntry;
  List<LocationResult> _suggestions = [];
  bool _isLoading = false;
  Timer? _debounce;
  LocationResult? _selectedLocation;
  bool _showOverlay = false;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialValue;
    if (_selectedLocation != null) {
      _controller.text = _selectedLocation!.displayName;
    }
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      if (_suggestions.isNotEmpty) {
        _showOverlay = true;
        _updateOverlay();
      }
    } else {
      // Delay hiding to allow tap on suggestions
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted && !_focusNode.hasFocus) {
          _showOverlay = false;
          _removeOverlay();
        }
      });
    }
  }

  void _onTextChanged(String value) {
    // Clear selection if text changed
    if (_selectedLocation != null && value != _selectedLocation!.displayName) {
      _selectedLocation = null;
      widget.onSelected(null);
    }

    // Debounce API calls
    _debounce?.cancel();
    
    if (value.trim().length < 2) {
      setState(() {
        _suggestions = [];
        _isLoading = false;
      });
      _removeOverlay();
      return;
    }

    setState(() => _isLoading = true);
    
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _searchLocations(value.trim());
    });
  }

  Future<void> _searchLocations(String query) async {
    try {
      debugPrint('[LocationAutocomplete] Searching for: $query');
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.searchLocation(query);
      
      debugPrint('[LocationAutocomplete] Response: ${response.data}');
      
      if (!mounted) return;
      
      final results = (response.data['results'] as List?)
          ?.map((r) => LocationResult.fromJson(r))
          .toList() ?? [];
      
      debugPrint('[LocationAutocomplete] Parsed ${results.length} results');
      
      setState(() {
        _suggestions = results;
        _isLoading = false;
      });
      
      if (results.isNotEmpty && _focusNode.hasFocus) {
        debugPrint('[LocationAutocomplete] Showing overlay with ${results.length} items');
        _showOverlay = true;
        _updateOverlay();
      } else {
        debugPrint('[LocationAutocomplete] No results or not focused, hiding overlay');
        _removeOverlay();
      }
    } catch (e, stackTrace) {
      debugPrint('[LocationAutocomplete] ERROR: $e');
      debugPrint('[LocationAutocomplete] Stack: $stackTrace');
      if (mounted) {
        setState(() {
          _suggestions = [];
          _isLoading = false;
        });
        _removeOverlay();
      }
    }
  }

  void _selectLocation(LocationResult location) {
    setState(() {
      _selectedLocation = location;
      _controller.text = location.displayName;
      _suggestions = [];
      _showOverlay = false;
    });
    _removeOverlay();
    widget.onSelected(location);
    _focusNode.unfocus();
  }

  void _updateOverlay() {
    _removeOverlay();
    if (_showOverlay && _suggestions.isNotEmpty) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 4),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(12),
            color: AppColors.surface,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 250),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.accent.withOpacity(0.3),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: _suggestions.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    color: AppColors.surfaceLight.withOpacity(0.3),
                  ),
                  itemBuilder: (context, index) {
                    final location = _suggestions[index];
                    return _buildSuggestionTile(location);
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionTile(LocationResult location) {
    // Split display name into parts for better formatting
    final parts = location.displayName.split(', ');
    final city = parts.isNotEmpty ? parts[0] : location.displayName;
    final region = parts.length > 2 ? parts.sublist(1, parts.length - 1).join(', ') : null;
    final country = parts.length > 1 ? parts.last : '';

    return InkWell(
      onTap: () => _selectLocation(location),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              color: AppColors.accent,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    city,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (region != null || country.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      region != null ? '$region, $country' : country,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Country flag emoji (optional, based on country code)
            Text(
              _getCountryFlag(location.countryCode),
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  String _getCountryFlag(String countryCode) {
    if (countryCode.length != 2) return '';
    final firstLetter = countryCode.codeUnitAt(0) - 0x41 + 0x1F1E6;
    final secondLetter = countryCode.codeUnitAt(1) - 0x41 + 0x1F1E6;
    return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        controller: _controller,
        focusNode: _focusNode,
        textCapitalization: TextCapitalization.words,
        onChanged: _onTextChanged,
        decoration: InputDecoration(
          hintText: widget.hintText ?? 'Search for a city...',
          labelText: widget.labelText,
          prefixIcon: const Icon(Icons.location_on_outlined, color: AppColors.textMuted),
          suffixIcon: _isLoading
              ? const Padding(
                  padding: EdgeInsets.all(12),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.accent,
                    ),
                  ),
                )
              : _selectedLocation != null
                  ? IconButton(
                      icon: const Icon(Icons.check_circle, color: Colors.green),
                      onPressed: null,
                    )
                  : _controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: AppColors.textMuted),
                          onPressed: () {
                            _controller.clear();
                            setState(() {
                              _selectedLocation = null;
                              _suggestions = [];
                            });
                            widget.onSelected(null);
                          },
                        )
                      : null,
        ),
        validator: widget.validator ?? (value) {
          if (_selectedLocation == null) {
            return 'Please select a location from the suggestions';
          }
          return null;
        },
      ),
    );
  }
}


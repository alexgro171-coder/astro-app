import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

import '../../../core/network/api_client.dart';
import '../../../core/services/jobs_service.dart';
import '../models/natal_placement.dart';

/// Provider for NatalChartService
final natalChartServiceProvider = Provider<NatalChartService>((ref) {
  return NatalChartService(
    ref.watch(apiClientProvider),
    ref.watch(jobsServiceProvider),
  );
});

/// Provider for natal chart data with job-based generation
final natalChartDataProvider = FutureProvider<NatalChartData?>((ref) async {
  final service = ref.watch(natalChartServiceProvider);
  return service.getNatalChartDataWithJob();
});

/// Provider for natal chart wheel SVG
/// Can be invalidated and refreshed by calling ref.refresh(natalChartWheelProvider)
final natalChartWheelProvider = FutureProvider<String?>((ref) async {
  final service = ref.watch(natalChartServiceProvider);
  return service.getWheelSvg();
});

/// Provider with force regenerate option
final natalChartWheelForceProvider = FutureProvider.family<String?, bool>(
  (ref, forceRegenerate) async {
    final service = ref.watch(natalChartServiceProvider);
    if (forceRegenerate) {
      await service.regenerateWheel();
    }
    return service.getWheelSvg(forceRegenerate: forceRegenerate);
  },
);

/// Provider for a single interpretation (with loading state)
final interpretationProvider = FutureProvider.family<NatalInterpretation?, String>(
  (ref, planetKey) async {
    final service = ref.watch(natalChartServiceProvider);
    return service.getInterpretation(planetKey);
  },
);

class NatalChartService {
  final ApiClient _apiClient;
  final JobsService _jobsService;

  NatalChartService(this._apiClient, this._jobsService);

  /// Get natal chart data with job-based generation if needed.
  Future<NatalChartData?> getNatalChartDataWithJob() async {
    // First try direct fetch - fast path
    try {
      final response = await _apiClient.get('/natal-chart');
      if (response.statusCode == 200 && response.data != null) {
        return NatalChartData.fromJson(response.data);
      }
    } catch (e) {
      debugPrint('Direct natal chart fetch failed: $e');
    }

    // If direct fetch fails, try job-based generation
    try {
      final startResponse = await _jobsService.startJob(
        jobType: JobType.natalChartShort,
      );

      // If already ready, fetch data
      if (startResponse.isSuccess) {
        return getNatalChartData();
      }

      // Poll for completion (max 60 seconds)
      const pollInterval = Duration(milliseconds: 2500);
      const maxPolls = 24;
      
      for (int i = 0; i < maxPolls; i++) {
        await Future.delayed(pollInterval);
        
        final status = await _jobsService.getJobStatus(startResponse.jobId);
        
        if (status.isSuccess) {
          return getNatalChartData();
        } else if (status.isFailed) {
          debugPrint('Natal chart job failed: ${status.errorMsg}');
          return null;
        }
      }
      
      debugPrint('Natal chart job timed out');
      return null;
    } catch (e) {
      debugPrint('Error with natal chart job: $e');
      return null;
    }
  }

  /// Get full natal chart data including placements and interpretations
  Future<NatalChartData?> getNatalChartData() async {
    try {
      final response = await _apiClient.get('/natal-chart');
      if (response.statusCode == 200 && response.data != null) {
        return NatalChartData.fromJson(response.data);
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching natal chart data: $e');
      return null;
    }
  }

  /// Get placements only
  Future<NatalPlacements?> getPlacements() async {
    try {
      final response = await _apiClient.get('/natal-chart/placements');
      if (response.statusCode == 200 && response.data != null) {
        return NatalPlacements.fromJson(response.data);
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching placements: $e');
      return null;
    }
  }

  /// Get a specific interpretation (lazy loaded)
  Future<NatalInterpretation?> getInterpretation(String planetKey) async {
    try {
      final response = await _apiClient.get('/natal-chart/interpretation/$planetKey');
      if (response.statusCode == 200 && response.data != null) {
        return NatalInterpretation.fromJson(response.data);
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching interpretation for $planetKey: $e');
      return null;
    }
  }

  /// Get all free interpretations
  Future<List<NatalInterpretation>> getFreeInterpretations() async {
    try {
      final response = await _apiClient.get('/natal-chart/interpretations/free');
      if (response.statusCode == 200 && response.data != null) {
        return (response.data as List)
            .map((i) => NatalInterpretation.fromJson(i))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching free interpretations: $e');
      return [];
    }
  }

  /// Get wheel chart SVG
  /// @param forceRegenerate - If true, forces backend to regenerate SVG
  Future<String?> getWheelSvg({bool forceRegenerate = false}) async {
    try {
      String path = '/natal-chart/wheel.svg';
      if (forceRegenerate) {
        path += '?force=true';
      }
      final response = await _apiClient.get(
        path,
        options: ApiClient.svgOptions(),
      );
      if (response.statusCode == 200) {
        return response.data as String;
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching wheel SVG: $e');
      return null;
    }
  }

  /// Force regenerate wheel chart SVG (clears cache and regenerates)
  Future<bool> regenerateWheel() async {
    try {
      final response = await _apiClient.post('/natal-chart/wheel/regenerate');
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error regenerating wheel: $e');
      return false;
    }
  }

  /// Check if user has pro natal chart access
  Future<bool> hasProAccess() async {
    try {
      final response = await _apiClient.get('/natal-chart/pro/status');
      if (response.statusCode == 200 && response.data != null) {
        return response.data['hasAccess'] as bool? ?? false;
      }
      return false;
    } catch (e) {
      debugPrint('Error checking pro access: $e');
      return false;
    }
  }

  /// Generate pro interpretations (requires purchase)
  Future<List<NatalInterpretation>?> generateProInterpretations() async {
    try {
      final response = await _apiClient.post('/natal-chart/pro/generate');
      debugPrint('Pro generate response: ${response.statusCode} - ${response.data}');
      
      // Accept both 200 and 201 status codes
      if ((response.statusCode == 200 || response.statusCode == 201) && response.data != null) {
        final interpretations = response.data['interpretations'] as List?;
        if (interpretations != null) {
          return interpretations
              .map((i) => NatalInterpretation.fromJson(i))
              .toList();
        }
      }
      debugPrint('Pro generate failed: statusCode=${response.statusCode}');
      return null;
    } catch (e, stackTrace) {
      debugPrint('Error generating pro interpretations: $e');
      debugPrint('Stack trace: $stackTrace');
      return null;
    }
  }

  /// Get pro interpretations (if purchased)
  Future<List<NatalInterpretation>?> getProInterpretations() async {
    try {
      final response = await _apiClient.get('/natal-chart/interpretations/pro');
      if (response.statusCode == 200 && response.data != null) {
        return (response.data as List)
            .map((i) => NatalInterpretation.fromJson(i))
            .toList();
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching pro interpretations: $e');
      return null;
    }
  }
}


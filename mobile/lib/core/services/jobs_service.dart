import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/api_client.dart';

/// Job status enum matching backend.
enum JobStatus {
  pending,
  running,
  ready,
  failed,
}

/// Job type enum matching backend.
enum JobType {
  dailyGuidance,
  natalChartShort,
  natalChartPro,
  karmicAstrology,
  oneTimeReport,
}

extension JobTypeExtension on JobType {
  String get apiValue {
    switch (this) {
      case JobType.dailyGuidance:
        return 'DAILY_GUIDANCE';
      case JobType.natalChartShort:
        return 'NATAL_CHART_SHORT';
      case JobType.natalChartPro:
        return 'NATAL_CHART_PRO';
      case JobType.karmicAstrology:
        return 'KARMIC_ASTROLOGY';
      case JobType.oneTimeReport:
        return 'ONE_TIME_REPORT';
    }
  }
}

/// Response from job start/status endpoints.
class JobResponse {
  final String jobId;
  final JobStatus status;
  final String? progressHint;
  final Map<String, dynamic>? resultRef;
  final String? errorMsg;

  JobResponse({
    required this.jobId,
    required this.status,
    this.progressHint,
    this.resultRef,
    this.errorMsg,
  });

  factory JobResponse.fromJson(Map<String, dynamic> json) {
    return JobResponse(
      jobId: json['jobId'] as String,
      status: _parseStatus(json['status'] as String),
      progressHint: json['progressHint'] as String?,
      resultRef: json['resultRef'] as Map<String, dynamic>?,
      errorMsg: json['errorMsg'] as String?,
    );
  }

  static JobStatus _parseStatus(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return JobStatus.pending;
      case 'RUNNING':
        return JobStatus.running;
      case 'READY':
        return JobStatus.ready;
      case 'FAILED':
        return JobStatus.failed;
      default:
        return JobStatus.pending;
    }
  }

  bool get isComplete => status == JobStatus.ready || status == JobStatus.failed;
  bool get isSuccess => status == JobStatus.ready;
  bool get isFailed => status == JobStatus.failed;
  bool get isProcessing => status == JobStatus.pending || status == JobStatus.running;
}

/// Service for interacting with the jobs API.
class JobsService {
  final ApiClient _apiClient;

  JobsService(this._apiClient);

  /// Start a new job (idempotent).
  Future<JobResponse> startJob({
    required JobType jobType,
    String? locale,
    Map<String, dynamic>? payload,
  }) async {
    final response = await _apiClient.post(
      '/jobs/start',
      data: {
        'jobType': jobType.apiValue,
        if (locale != null) 'locale': locale,
        if (payload != null) 'payload': payload,
      },
    );
    return JobResponse.fromJson(response.data);
  }

  /// Get job status.
  Future<JobResponse> getJobStatus(String jobId) async {
    final response = await _apiClient.get('/jobs/$jobId');
    return JobResponse.fromJson(response.data);
  }

  /// Retry a failed job.
  Future<JobResponse> retryJob(String jobId) async {
    final response = await _apiClient.post('/jobs/$jobId/retry');
    return JobResponse.fromJson(response.data);
  }
}

/// Provider for JobsService.
final jobsServiceProvider = Provider<JobsService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return JobsService(apiClient);
});


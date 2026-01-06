import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/jobs_service.dart';

/// State for job polling.
class JobPollingState {
  final String? jobId;
  final JobStatus status;
  final String? progressHint;
  final Map<String, dynamic>? resultRef;
  final String? errorMsg;
  final bool isTimedOut;
  final int pollCount;

  const JobPollingState({
    this.jobId,
    this.status = JobStatus.pending,
    this.progressHint,
    this.resultRef,
    this.errorMsg,
    this.isTimedOut = false,
    this.pollCount = 0,
  });

  JobPollingState copyWith({
    String? jobId,
    JobStatus? status,
    String? progressHint,
    Map<String, dynamic>? resultRef,
    String? errorMsg,
    bool? isTimedOut,
    int? pollCount,
  }) {
    return JobPollingState(
      jobId: jobId ?? this.jobId,
      status: status ?? this.status,
      progressHint: progressHint ?? this.progressHint,
      resultRef: resultRef ?? this.resultRef,
      errorMsg: errorMsg ?? this.errorMsg,
      isTimedOut: isTimedOut ?? this.isTimedOut,
      pollCount: pollCount ?? this.pollCount,
    );
  }

  bool get isLoading => !isComplete && !isTimedOut;
  bool get isComplete => status == JobStatus.ready || status == JobStatus.failed;
  bool get isSuccess => status == JobStatus.ready;
  bool get isFailed => status == JobStatus.failed;
}

/// Controller for managing job polling lifecycle.
class JobPollingController extends StateNotifier<JobPollingState> {
  final JobsService _jobsService;
  Timer? _pollTimer;
  int _retryCount = 0;
  final int _maxRetries = 3;
  final Duration _baseInterval = const Duration(milliseconds: 2500);
  final Duration _maxPollingDuration = const Duration(seconds: 90);
  DateTime? _startTime;

  JobPollingController(this._jobsService) : super(const JobPollingState());

  /// Start a job and begin polling.
  Future<void> startJob({
    required JobType jobType,
    String? locale,
    Map<String, dynamic>? payload,
  }) async {
    // Reset state
    state = const JobPollingState();
    _startTime = DateTime.now();
    _retryCount = 0;

    try {
      // Start the job
      final response = await _jobsService.startJob(
        jobType: jobType,
        locale: locale,
        payload: payload,
      );

      state = state.copyWith(
        jobId: response.jobId,
        status: response.status,
        progressHint: response.progressHint,
        resultRef: response.resultRef,
        errorMsg: response.errorMsg,
      );

      // If already complete, no need to poll
      if (response.isComplete) {
        return;
      }

      // Start polling
      _startPolling();
    } catch (e) {
      debugPrint('JobPollingController: Error starting job: $e');
      state = state.copyWith(
        status: JobStatus.failed,
        errorMsg: e.toString(),
      );
    }
  }

  /// Resume polling for an existing job (e.g., after navigation back).
  Future<void> resumePolling(String jobId) async {
    if (state.jobId == jobId && state.isComplete) {
      // Already have final result, no need to poll
      return;
    }

    state = state.copyWith(jobId: jobId);
    _startTime = DateTime.now();
    _retryCount = 0;

    await _checkStatus();

    if (!state.isComplete) {
      _startPolling();
    }
  }

  /// Manually check status (e.g., when user taps "Check again").
  Future<void> checkStatus() async {
    await _checkStatus();
  }

  void _startPolling() {
    _stopPolling();

    _pollTimer = Timer.periodic(_getPollInterval(), (_) {
      _checkStatus();
    });
  }

  void _stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  Duration _getPollInterval() {
    // Add jitter to prevent thundering herd
    final jitter = Random().nextInt(600) - 300; // -300ms to +300ms
    return _baseInterval + Duration(milliseconds: jitter);
  }

  Future<void> _checkStatus() async {
    if (state.jobId == null) return;

    // Check for timeout
    if (_startTime != null &&
        DateTime.now().difference(_startTime!) > _maxPollingDuration) {
      _stopPolling();
      state = state.copyWith(isTimedOut: true);
      return;
    }

    try {
      final response = await _jobsService.getJobStatus(state.jobId!);

      state = state.copyWith(
        status: response.status,
        progressHint: response.progressHint,
        resultRef: response.resultRef,
        errorMsg: response.errorMsg,
        pollCount: state.pollCount + 1,
      );

      // Reset retry count on success
      _retryCount = 0;

      // Stop polling if complete
      if (response.isComplete) {
        _stopPolling();
      }
    } catch (e) {
      debugPrint('JobPollingController: Error checking status: $e');
      _retryCount++;

      if (_retryCount >= _maxRetries) {
        _stopPolling();
        state = state.copyWith(
          status: JobStatus.failed,
          errorMsg: 'Network error: Unable to check job status',
        );
      }
      // Otherwise continue polling with exponential backoff
    }
  }

  /// Retry a failed job.
  Future<void> retry() async {
    if (state.jobId == null) return;

    state = state.copyWith(
      status: JobStatus.pending,
      errorMsg: null,
      isTimedOut: false,
    );
    _startTime = DateTime.now();
    _retryCount = 0;

    try {
      final response = await _jobsService.retryJob(state.jobId!);

      state = state.copyWith(
        status: response.status,
        progressHint: response.progressHint,
        resultRef: response.resultRef,
        errorMsg: response.errorMsg,
      );

      if (!response.isComplete) {
        _startPolling();
      }
    } catch (e) {
      debugPrint('JobPollingController: Error retrying job: $e');
      state = state.copyWith(
        status: JobStatus.failed,
        errorMsg: e.toString(),
      );
    }
  }

  @override
  void dispose() {
    _stopPolling();
    super.dispose();
  }
}

/// Provider family for job polling - one controller per job type.
final jobPollingProvider = StateNotifierProvider.autoDispose
    .family<JobPollingController, JobPollingState, JobType>((ref, jobType) {
  final jobsService = ref.watch(jobsServiceProvider);
  return JobPollingController(jobsService);
});

/// Provider for a specific job by ID (for resuming).
final jobStatusProvider = FutureProvider.autoDispose.family<JobResponse, String>(
  (ref, jobId) async {
    final jobsService = ref.watch(jobsServiceProvider);
    return jobsService.getJobStatus(jobId);
  },
);


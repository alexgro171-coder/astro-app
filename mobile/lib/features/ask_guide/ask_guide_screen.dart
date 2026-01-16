import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/theme/app_theme.dart';
import '../../core/network/api_client.dart';
import '../shell/main_shell.dart';

/// Ask Your Guide Screen
/// 
/// Replaces the old "Your Focus" screen.
/// Allows users to ask personal questions and get guidance
/// based on their natal chart and current transits.
class AskGuideScreen extends ConsumerStatefulWidget {
  const AskGuideScreen({super.key});

  @override
  ConsumerState<AskGuideScreen> createState() => _AskGuideScreenState();
}

class _AskGuideScreenState extends ConsumerState<AskGuideScreen> {
  final TextEditingController _questionController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  List<Map<String, dynamic>> _history = [];
  Map<String, dynamic>? _usage;
  bool _isLoading = true;
  bool _isAsking = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(currentNavIndexProvider.notifier).state = 2;
    });
    _loadData();
  }

  @override
  void dispose() {
    _questionController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.get('/ask-guide/history');
      
      setState(() {
        _history = List<Map<String, dynamic>>.from(response.data['requests'] ?? []);
        _usage = response.data['usage'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = AppLocalizations.of(context)!.askGuideLoadFailed;
        _isLoading = false;
      });
    }
  }

  Future<void> _askQuestion() async {
    final l10n = AppLocalizations.of(context)!;
    final question = _questionController.text.trim();
    if (question.isEmpty) return;

    // Check remaining requests
    if (_usage != null && (_usage!['remaining'] ?? 0) <= 0) {
      _showLimitReachedDialog();
      return;
    }

    setState(() {
      _isAsking = true;
    });

    try {
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.post('/ask-guide/ask', data: {
        'question': question,
      });
      
      // Add new request to top of history
      final newRequest = response.data;
      setState(() {
        _history.insert(0, newRequest);
        _questionController.clear();
        _isAsking = false;
        // Decrement remaining count
        if (_usage != null) {
          _usage!['remaining'] = (_usage!['remaining'] ?? 1) - 1;
          _usage!['requestCount'] = (_usage!['requestCount'] ?? 0) + 1;
        }
      });

      // Scroll to top to show new answer
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } catch (e) {
      setState(() {
        _isAsking = false;
      });
      
      if (e.toString().contains('LIMIT_REACHED')) {
        _showLimitReachedDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.askGuideSendFailed(e.toString())),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _showLimitReachedDialog() {
    final l10n = AppLocalizations.of(context)!;
    final billingEnd = _usage?['billingMonthEnd'] ?? 'your next billing date';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.info_outline, color: AppColors.accent),
            const SizedBox(width: 8),
            Text(
              l10n.askGuideLimitTitle,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 18),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.askGuideLimitBody,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.askGuideLimitAddon,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.askGuideLimitBillingEnd(billingEnd),
              style: const TextStyle(
                color: AppColors.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.commonLater),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Navigate to add-on purchase
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
            ),
            child: Text(l10n.askGuideLimitGetAddon),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          // Header
          _buildHeader(),
          
          // Content
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
                : _error != null
                    ? _buildErrorState()
                    : _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final l10n = AppLocalizations.of(context)!;
    final remaining = _usage?['remaining'] ?? 0;
    final limit = _usage?['limitCount'] ?? 40;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.askGuideTitle,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.askGuideSubtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              // Usage counter
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: remaining > 10
                      ? AppColors.success.withOpacity(0.15)
                      : remaining > 0
                          ? AppColors.warning.withOpacity(0.15)
                          : AppColors.error.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      size: 16,
                      color: remaining > 10
                          ? AppColors.success
                          : remaining > 0
                              ? AppColors.warning
                              : AppColors.error,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      l10n.askGuideRemaining(remaining),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: remaining > 10
                            ? AppColors.success
                            : remaining > 0
                                ? AppColors.warning
                                : AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        // Input area
        _buildInputArea(),
        
        const SizedBox(height: 16),
        
        // History list
        Expanded(
          child: _history.isEmpty
              ? _buildEmptyState()
              : _buildHistoryList(),
        ),
      ],
    );
  }

  Widget _buildInputArea() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _questionController,
            maxLines: 3,
            minLines: 2,
            maxLength: 500,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: l10n.askGuideQuestionHint,
              hintStyle: TextStyle(color: AppColors.textMuted),
              border: InputBorder.none,
              counterStyle: TextStyle(color: AppColors.textMuted),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.askGuideBasedOnChart,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 48,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isAsking ? null : _askQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isAsking
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.send_rounded, size: 22),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    return RefreshIndicator(
      onRefresh: _loadData,
      color: AppColors.accent,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _history.length,
        itemBuilder: (context, index) {
          final request = _history[index];
          return _buildHistoryItem(request);
        },
      ),
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> request) {
    final l10n = AppLocalizations.of(context)!;
    final question = request['question'] as String? ?? '';
    final answer = request['answer'] as String?;
    final status = request['status'] as String? ?? 'PENDING';
    final createdAt = DateTime.tryParse(request['createdAt'] ?? '') ?? DateTime.now();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.person_outline,
                    color: AppColors.accent,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(createdAt),
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Answer
          Padding(
            padding: const EdgeInsets.all(16),
            child: status == 'PENDING'
                ? Row(
                    children: [
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.accent,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        l10n.askGuideThinking,
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  )
                : status == 'FAILED'
                    ? Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: AppColors.error,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            request['errorMsg'] ?? 'Failed to get answer',
                            style: const TextStyle(color: AppColors.error),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.accent.withOpacity(0.3),
                                      Colors.purple.withOpacity(0.3),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.auto_awesome,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                l10n.askGuideYourGuide,
                                style: const TextStyle(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            answer ?? '',
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Copy button
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: answer ?? ''));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(l10n.commonCopied),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.copy, size: 16),
                              label: Text(l10n.commonCopy),
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.textMuted,
                              ),
                            ),
                          ),
                        ],
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Opacity(
            opacity: 0.7,
            child: Image.asset(
              'assets/images/InnerLogo_transp.png',
              width: 80,
              height: 80,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.askGuideEmptyTitle,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.askGuideEmptyBody,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.askGuideEmptyHint,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.error),
          const SizedBox(height: 16),
          Text(_error!, style: const TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadData,
            child: Text(l10n.commonRetry),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final diff = now.difference(date);
    
    if (diff.inMinutes < 1) {
      return l10n.commonJustNow;
    } else if (diff.inHours < 1) {
      return l10n.commonMinutesAgo(diff.inMinutes);
    } else if (diff.inDays < 1) {
      return l10n.commonHoursAgo(diff.inHours);
    } else if (diff.inDays < 7) {
      return l10n.commonDaysAgo(diff.inDays);
    } else {
      return l10n.commonDateShort(date.day, date.month, date.year);
    }
  }
}

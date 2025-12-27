import 'context_answers.dart';

/// Context Profile Model
/// 
/// Represents the user's saved context profile from the backend,
/// including the AI-generated summary and tags.

class ContextTags {
  final String relationshipStatus;
  final bool? seekingRelationship;
  final bool hasChildren;
  final int childrenCount;
  final String workStatus;
  final String? industry;
  final int healthScore;
  final int socialScore;
  final int romanceScore;
  final int financeScore;
  final int careerScore;
  final int growthScore;
  final List<String> priorities;
  final String tonePreference;
  final bool sensitivityMode;

  ContextTags({
    required this.relationshipStatus,
    this.seekingRelationship,
    required this.hasChildren,
    required this.childrenCount,
    required this.workStatus,
    this.industry,
    required this.healthScore,
    required this.socialScore,
    required this.romanceScore,
    required this.financeScore,
    required this.careerScore,
    required this.growthScore,
    required this.priorities,
    required this.tonePreference,
    required this.sensitivityMode,
  });

  factory ContextTags.fromJson(Map<String, dynamic> json) => ContextTags(
    relationshipStatus: json['relationship_status'] as String? ?? 'unknown',
    seekingRelationship: json['seeking_relationship'] as bool?,
    hasChildren: json['has_children'] as bool? ?? false,
    childrenCount: json['children_count'] as int? ?? 0,
    workStatus: json['work_status'] as String? ?? 'unknown',
    industry: json['industry'] as String?,
    healthScore: json['health_score'] as int? ?? 3,
    socialScore: json['social_score'] as int? ?? 3,
    romanceScore: json['romance_score'] as int? ?? 3,
    financeScore: json['finance_score'] as int? ?? 3,
    careerScore: json['career_score'] as int? ?? 3,
    growthScore: json['growth_score'] as int? ?? 3,
    priorities: (json['priorities'] as List<dynamic>?)
        ?.map((p) => p as String)
        .toList() ?? [],
    tonePreference: json['tone_preference'] as String? ?? 'balanced',
    sensitivityMode: json['sensitivity_mode'] as bool? ?? false,
  );

  Map<String, dynamic> toJson() => {
    'relationship_status': relationshipStatus,
    'seeking_relationship': seekingRelationship,
    'has_children': hasChildren,
    'children_count': childrenCount,
    'work_status': workStatus,
    'industry': industry,
    'health_score': healthScore,
    'social_score': socialScore,
    'romance_score': romanceScore,
    'finance_score': financeScore,
    'career_score': careerScore,
    'growth_score': growthScore,
    'priorities': priorities,
    'tone_preference': tonePreference,
    'sensitivity_mode': sensitivityMode,
  };
}

class ContextProfile {
  final String id;
  final int version;
  final ContextAnswers answers;
  final String summary60w;
  final ContextTags summaryTags;
  final DateTime nextReviewAt;
  final DateTime completedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ContextProfile({
    required this.id,
    required this.version,
    required this.answers,
    required this.summary60w,
    required this.summaryTags,
    required this.nextReviewAt,
    required this.completedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory ContextProfile.fromJson(Map<String, dynamic> json) => ContextProfile(
    id: json['id'] as String,
    version: json['version'] as int? ?? 1,
    answers: ContextAnswers.fromJson(json['answers'] as Map<String, dynamic>),
    summary60w: json['summary60w'] as String? ?? '',
    summaryTags: ContextTags.fromJson(json['summaryTags'] as Map<String, dynamic>? ?? {}),
    nextReviewAt: DateTime.parse(json['nextReviewAt'] as String),
    completedAt: DateTime.parse(json['completedAt'] as String),
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
    updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'version': version,
    'answers': answers.toJson(),
    'summary60w': summary60w,
    'summaryTags': summaryTags.toJson(),
    'nextReviewAt': nextReviewAt.toIso8601String(),
    'completedAt': completedAt.toIso8601String(),
    if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
  };

  /// Check if profile needs review (90-day check)
  bool get needsReview => DateTime.now().isAfter(nextReviewAt);

  /// Days until next review
  int get daysUntilReview {
    final now = DateTime.now();
    if (now.isAfter(nextReviewAt)) return 0;
    return nextReviewAt.difference(now).inDays;
  }
}

/// Response from GET /context/status
class ContextStatus {
  final bool hasProfile;
  final bool needsReview;
  final DateTime? nextReviewAt;
  final int? currentVersion;

  ContextStatus({
    required this.hasProfile,
    required this.needsReview,
    this.nextReviewAt,
    this.currentVersion,
  });

  factory ContextStatus.fromJson(Map<String, dynamic> json) => ContextStatus(
    hasProfile: json['hasProfile'] as bool? ?? false,
    needsReview: json['needsReview'] as bool? ?? false,
    nextReviewAt: json['nextReviewAt'] != null 
        ? DateTime.parse(json['nextReviewAt'] as String) 
        : null,
    currentVersion: json['currentVersion'] as int?,
  );
}

/// Response from GET /context/profile
class ContextProfileResponse {
  final bool hasProfile;
  final ContextProfile? profile;

  ContextProfileResponse({
    required this.hasProfile,
    this.profile,
  });

  factory ContextProfileResponse.fromJson(Map<String, dynamic> json) => ContextProfileResponse(
    hasProfile: json['hasProfile'] as bool? ?? false,
    profile: json['profile'] != null 
        ? ContextProfile.fromJson(json['profile'] as Map<String, dynamic>)
        : null,
  );
}


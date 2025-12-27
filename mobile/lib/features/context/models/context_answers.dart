/// Context Answers Model - V1 Questionnaire
/// 
/// Represents the user's personal context answers for personalized guidance.

// ============================================
// ENUMS
// ============================================

enum RelationshipStatus {
  single('single', 'Single'),
  inRelationship('in_relationship', 'In a relationship'),
  married('married', 'Married / Civil partnership'),
  separated('separated', 'Separated / Divorced'),
  widowed('widowed', 'Widowed'),
  preferNotToSay('prefer_not_to_say', 'Prefer not to say');

  final String value;
  final String label;
  const RelationshipStatus(this.value, this.label);

  static RelationshipStatus fromValue(String value) {
    return RelationshipStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => RelationshipStatus.preferNotToSay,
    );
  }
}

enum ChildGender {
  male('M', 'Male'),
  female('F', 'Female'),
  preferNotToSay('prefer_not_to_say', 'Prefer not to say');

  final String value;
  final String label;
  const ChildGender(this.value, this.label);

  static ChildGender fromValue(String value) {
    return ChildGender.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ChildGender.preferNotToSay,
    );
  }
}

enum WorkStatus {
  student('student', 'Student'),
  unemployed('unemployed', 'Unemployed / Between jobs'),
  employedIc('employed_ic', 'Employed (Individual contributor)'),
  employedManagement('employed_management', 'Employed (Management)'),
  executive('executive', 'Executive / Leadership (C-level)'),
  selfEmployed('self_employed', 'Self-employed / Freelancer'),
  entrepreneur('entrepreneur', 'Entrepreneur / Business owner'),
  investor('investor', 'Investor'),
  retired('retired', 'Retired'),
  homemaker('homemaker', 'Homemaker / Stay-at-home parent'),
  careerBreak('career_break', 'Career break / Sabbatical'),
  other('other', 'Other');

  final String value;
  final String label;
  const WorkStatus(this.value, this.label);

  static WorkStatus fromValue(String value) {
    return WorkStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => WorkStatus.other,
    );
  }
}

enum Industry {
  techIt('tech_it', 'Tech / IT'),
  finance('finance', 'Finance / Investments'),
  healthcare('healthcare', 'Healthcare'),
  education('education', 'Education'),
  salesMarketing('sales_marketing', 'Sales / Marketing'),
  realEstate('real_estate', 'Real Estate'),
  hospitality('hospitality', 'Hospitality'),
  government('government', 'Government / Public sector'),
  creative('creative', 'Creative industries'),
  other('other', 'Other');

  final String value;
  final String label;
  const Industry(this.value, this.label);

  static Industry fromValue(String value) {
    return Industry.values.firstWhere(
      (e) => e.value == value,
      orElse: () => Industry.other,
    );
  }
}

enum Priority {
  healthHabits('health_habits', 'Health & habits', '🏃'),
  careerGrowth('career_growth', 'Career growth', '📈'),
  businessDecisions('business_decisions', 'Business decisions', '💼'),
  moneyStability('money_stability', 'Money & stability', '💰'),
  loveRelationship('love_relationship', 'Love & relationship', '❤️'),
  familyParenting('family_parenting', 'Family & parenting', '👨‍👩‍👧'),
  socialLife('social_life', 'Social life', '🎉'),
  personalGrowth('personal_growth', 'Personal growth / mindset', '🧘');

  final String value;
  final String label;
  final String emoji;
  const Priority(this.value, this.label, this.emoji);

  static Priority fromValue(String value) {
    return Priority.values.firstWhere(
      (e) => e.value == value,
      orElse: () => Priority.personalGrowth,
    );
  }
}

enum GuidanceStyle {
  direct('direct', 'Direct & practical', 'Get straight to actionable advice'),
  empathetic('empathetic', 'Empathetic & reflective', 'Warm, supportive guidance'),
  balanced('balanced', 'Balanced', 'Mix of practical and emotional support');

  final String value;
  final String label;
  final String description;
  const GuidanceStyle(this.value, this.label, this.description);

  static GuidanceStyle fromValue(String value) {
    return GuidanceStyle.values.firstWhere(
      (e) => e.value == value,
      orElse: () => GuidanceStyle.balanced,
    );
  }
}

// ============================================
// DATA CLASSES
// ============================================

class ChildInfo {
  final int age;
  final ChildGender gender;

  ChildInfo({
    required this.age,
    required this.gender,
  });

  Map<String, dynamic> toJson() => {
    'age': age,
    'gender': gender.value,
  };

  factory ChildInfo.fromJson(Map<String, dynamic> json) => ChildInfo(
    age: json['age'] as int,
    gender: ChildGender.fromValue(json['gender'] as String),
  );
}

class ContextAnswers {
  // Section A: Relationships & Family
  final RelationshipStatus relationshipStatus;
  final bool? seekingRelationship;
  final bool hasChildren;
  final List<ChildInfo> children;

  // Section B: Professional Life
  final WorkStatus workStatus;
  final String? workStatusOther;
  final Industry? industry;

  // Section C: Self-Assessment (Likert 1-5)
  final int healthScore;
  final int socialScore;
  final int romanceScore;
  final int financeScore;
  final int careerScore;
  final int growthScore;

  // Section D: Priorities & Tone
  final List<Priority> priorities; // max 2
  final GuidanceStyle guidanceStyle;
  final bool sensitivityMode;

  ContextAnswers({
    required this.relationshipStatus,
    this.seekingRelationship,
    required this.hasChildren,
    this.children = const [],
    required this.workStatus,
    this.workStatusOther,
    this.industry,
    required this.healthScore,
    required this.socialScore,
    required this.romanceScore,
    required this.financeScore,
    required this.careerScore,
    required this.growthScore,
    required this.priorities,
    required this.guidanceStyle,
    this.sensitivityMode = false,
  });

  /// Create empty/default instance for wizard initialization
  factory ContextAnswers.empty() => ContextAnswers(
    relationshipStatus: RelationshipStatus.preferNotToSay,
    hasChildren: false,
    workStatus: WorkStatus.other,
    healthScore: 3,
    socialScore: 3,
    romanceScore: 3,
    financeScore: 3,
    careerScore: 3,
    growthScore: 3,
    priorities: [],
    guidanceStyle: GuidanceStyle.balanced,
  );

  Map<String, dynamic> toJson() => {
    'relationshipStatus': relationshipStatus.value,
    'seekingRelationship': seekingRelationship,
    'hasChildren': hasChildren,
    'children': children.map((c) => c.toJson()).toList(),
    'workStatus': workStatus.value,
    'workStatusOther': workStatusOther,
    'industry': industry?.value,
    'healthScore': healthScore,
    'socialScore': socialScore,
    'romanceScore': romanceScore,
    'financeScore': financeScore,
    'careerScore': careerScore,
    'growthScore': growthScore,
    'priorities': priorities.map((p) => p.value).toList(),
    'guidanceStyle': guidanceStyle.value,
    'sensitivityMode': sensitivityMode,
  };

  factory ContextAnswers.fromJson(Map<String, dynamic> json) => ContextAnswers(
    relationshipStatus: RelationshipStatus.fromValue(json['relationshipStatus'] as String? ?? 'prefer_not_to_say'),
    seekingRelationship: json['seekingRelationship'] as bool?,
    hasChildren: json['hasChildren'] as bool? ?? false,
    children: (json['children'] as List<dynamic>?)
        ?.map((c) => ChildInfo.fromJson(c as Map<String, dynamic>))
        .toList() ?? [],
    workStatus: WorkStatus.fromValue(json['workStatus'] as String? ?? 'other'),
    workStatusOther: json['workStatusOther'] as String?,
    industry: json['industry'] != null ? Industry.fromValue(json['industry'] as String) : null,
    healthScore: json['healthScore'] as int? ?? 3,
    socialScore: json['socialScore'] as int? ?? 3,
    romanceScore: json['romanceScore'] as int? ?? 3,
    financeScore: json['financeScore'] as int? ?? 3,
    careerScore: json['careerScore'] as int? ?? 3,
    growthScore: json['growthScore'] as int? ?? 3,
    priorities: (json['priorities'] as List<dynamic>?)
        ?.map((p) => Priority.fromValue(p as String))
        .toList() ?? [],
    guidanceStyle: GuidanceStyle.fromValue(json['guidanceStyle'] as String? ?? 'balanced'),
    sensitivityMode: json['sensitivityMode'] as bool? ?? false,
  );

  /// Create a copy with updated values
  ContextAnswers copyWith({
    RelationshipStatus? relationshipStatus,
    bool? seekingRelationship,
    bool? hasChildren,
    List<ChildInfo>? children,
    WorkStatus? workStatus,
    String? workStatusOther,
    Industry? industry,
    int? healthScore,
    int? socialScore,
    int? romanceScore,
    int? financeScore,
    int? careerScore,
    int? growthScore,
    List<Priority>? priorities,
    GuidanceStyle? guidanceStyle,
    bool? sensitivityMode,
  }) {
    return ContextAnswers(
      relationshipStatus: relationshipStatus ?? this.relationshipStatus,
      seekingRelationship: seekingRelationship ?? this.seekingRelationship,
      hasChildren: hasChildren ?? this.hasChildren,
      children: children ?? this.children,
      workStatus: workStatus ?? this.workStatus,
      workStatusOther: workStatusOther ?? this.workStatusOther,
      industry: industry ?? this.industry,
      healthScore: healthScore ?? this.healthScore,
      socialScore: socialScore ?? this.socialScore,
      romanceScore: romanceScore ?? this.romanceScore,
      financeScore: financeScore ?? this.financeScore,
      careerScore: careerScore ?? this.careerScore,
      growthScore: growthScore ?? this.growthScore,
      priorities: priorities ?? this.priorities,
      guidanceStyle: guidanceStyle ?? this.guidanceStyle,
      sensitivityMode: sensitivityMode ?? this.sensitivityMode,
    );
  }

  /// Check if seeking relationship question should be shown
  bool get shouldShowSeekingRelationship {
    return relationshipStatus == RelationshipStatus.single ||
           relationshipStatus == RelationshipStatus.separated ||
           relationshipStatus == RelationshipStatus.widowed;
  }
}


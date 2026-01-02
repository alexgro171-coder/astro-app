import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';

/// Learn categories
enum LearnCategory {
  signs,
  planets,
  houses,
  transits,
}

extension LearnCategoryExtension on LearnCategory {
  String get apiValue => name.toUpperCase();
  
  String get displayName {
    switch (this) {
      case LearnCategory.signs:
        return 'Zodiac Signs';
      case LearnCategory.planets:
        return 'Planets';
      case LearnCategory.houses:
        return 'Houses';
      case LearnCategory.transits:
        return 'Transits';
    }
  }
  
  String get icon {
    switch (this) {
      case LearnCategory.signs:
        return '♈';
      case LearnCategory.planets:
        return '☉';
      case LearnCategory.houses:
        return '🏠';
      case LearnCategory.transits:
        return '🔄';
    }
  }
}

/// Learn item (article preview)
class LearnItem {
  final String slug;
  final String title;
  final DateTime updatedAt;

  LearnItem({
    required this.slug,
    required this.title,
    required this.updatedAt,
  });

  factory LearnItem.fromJson(Map<String, dynamic> json) {
    return LearnItem(
      slug: json['slug'] as String,
      title: json['title'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

/// Items response with optional fallback locale
class LearnItemsResponse {
  final List<LearnItem> items;
  final String? fallbackLocale;

  LearnItemsResponse({
    required this.items,
    this.fallbackLocale,
  });

  factory LearnItemsResponse.fromJson(Map<String, dynamic> json) {
    return LearnItemsResponse(
      items: (json['items'] as List)
          .map((e) => LearnItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      fallbackLocale: json['fallbackLocale'] as String?,
    );
  }
}

/// Full article content
class LearnArticle {
  final String title;
  final String content;
  final DateTime updatedAt;
  final String localeUsed;

  LearnArticle({
    required this.title,
    required this.content,
    required this.updatedAt,
    required this.localeUsed,
  });

  factory LearnArticle.fromJson(Map<String, dynamic> json) {
    return LearnArticle(
      title: json['title'] as String,
      content: json['content'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      localeUsed: json['localeUsed'] as String,
    );
  }
}

/// Learn Service
class LearnService {
  final ApiClient _apiClient;

  LearnService(this._apiClient);

  /// Get list of items for a category
  Future<LearnItemsResponse> getItems(LearnCategory category, String locale) async {
    try {
      final response = await _apiClient.get(
        '/learn/${category.apiValue}/$locale/items',
      );
      return LearnItemsResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// Get single article content
  Future<LearnArticle> getArticle(
    LearnCategory category,
    String locale,
    String slug,
  ) async {
    try {
      final response = await _apiClient.get(
        '/learn/${category.apiValue}/$locale/$slug',
      );
      return LearnArticle.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// Log that user opened Learn section
  Future<void> logLearnOpened() async {
    try {
      await _apiClient.post('/learn/opened');
    } catch (e) {
      // Don't throw - analytics shouldn't break UX
      print('Failed to log learn opened: $e');
    }
  }
}

/// Provider for LearnService
final learnServiceProvider = Provider<LearnService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return LearnService(apiClient);
});


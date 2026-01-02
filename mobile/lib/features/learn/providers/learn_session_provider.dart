import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/learn_service.dart';

/// Cache key for items
String _itemsCacheKey(LearnCategory category, String locale) =>
    '${category.name}|$locale';

/// Cache key for articles
String _articleCacheKey(LearnCategory category, String locale, String slug) =>
    '${category.name}|$locale|$slug';

/// Learn session state
class LearnSessionState {
  final Map<String, LearnItemsResponse> itemsCache;
  final Map<String, LearnArticle> articlesCache;
  final bool hasLoggedOpened;

  LearnSessionState({
    this.itemsCache = const {},
    this.articlesCache = const {},
    this.hasLoggedOpened = false,
  });

  LearnSessionState copyWith({
    Map<String, LearnItemsResponse>? itemsCache,
    Map<String, LearnArticle>? articlesCache,
    bool? hasLoggedOpened,
  }) {
    return LearnSessionState(
      itemsCache: itemsCache ?? this.itemsCache,
      articlesCache: articlesCache ?? this.articlesCache,
      hasLoggedOpened: hasLoggedOpened ?? this.hasLoggedOpened,
    );
  }
}

/// Learn session notifier - caches data for the session duration
class LearnSessionNotifier extends StateNotifier<LearnSessionState> {
  final LearnService _learnService;

  LearnSessionNotifier(this._learnService) : super(LearnSessionState());

  /// Log learn opened (once per session)
  Future<void> logOpenedIfNeeded() async {
    if (!state.hasLoggedOpened) {
      await _learnService.logLearnOpened();
      state = state.copyWith(hasLoggedOpened: true);
    }
  }

  /// Get items for category (with caching)
  Future<LearnItemsResponse> getItems(
    LearnCategory category,
    String locale,
  ) async {
    final cacheKey = _itemsCacheKey(category, locale);

    // Check cache first
    if (state.itemsCache.containsKey(cacheKey)) {
      return state.itemsCache[cacheKey]!;
    }

    // Fetch from API
    final response = await _learnService.getItems(category, locale);

    // Update cache
    state = state.copyWith(
      itemsCache: {...state.itemsCache, cacheKey: response},
    );

    return response;
  }

  /// Get article (with caching)
  Future<LearnArticle> getArticle(
    LearnCategory category,
    String locale,
    String slug,
  ) async {
    final cacheKey = _articleCacheKey(category, locale, slug);

    // Check cache first
    if (state.articlesCache.containsKey(cacheKey)) {
      return state.articlesCache[cacheKey]!;
    }

    // Fetch from API
    final article = await _learnService.getArticle(category, locale, slug);

    // Update cache
    state = state.copyWith(
      articlesCache: {...state.articlesCache, cacheKey: article},
    );

    return article;
  }

  /// Check if items are cached
  bool hasItemsCached(LearnCategory category, String locale) {
    return state.itemsCache.containsKey(_itemsCacheKey(category, locale));
  }

  /// Check if article is cached
  bool hasArticleCached(LearnCategory category, String locale, String slug) {
    return state.articlesCache.containsKey(_articleCacheKey(category, locale, slug));
  }
}

/// Provider for learn session - autoDispose when leaving Learn module
final learnSessionProvider =
    StateNotifierProvider.autoDispose<LearnSessionNotifier, LearnSessionState>((ref) {
  final learnService = ref.watch(learnServiceProvider);
  return LearnSessionNotifier(learnService);
});

/// Provider for fetching items with loading state
final learnItemsProvider = FutureProvider.autoDispose
    .family<LearnItemsResponse, (LearnCategory, String)>((ref, params) async {
  final (category, locale) = params;
  final session = ref.watch(learnSessionProvider.notifier);
  return session.getItems(category, locale);
});

/// Provider for fetching article with loading state
final learnArticleProvider = FutureProvider.autoDispose
    .family<LearnArticle, (LearnCategory, String, String)>((ref, params) async {
  final (category, locale, slug) = params;
  final session = ref.watch(learnSessionProvider.notifier);
  return session.getArticle(category, locale, slug);
});


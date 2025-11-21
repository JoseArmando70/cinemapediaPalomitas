import 'package:cinemapedia/domain/entities/search_result.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/legacy.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = StateNotifierProvider<SearchNotifier, List<SearchResult>>((ref) {
  final searchMovies = ref.watch(moviesRepositoryProvider).searchMovies;
  return SearchNotifier(searchMovies: searchMovies);
});

typedef SearchMoviesCallback = Future<List<SearchResult>> Function(String query, {int page});

class SearchNotifier extends StateNotifier<List<SearchResult>> {
  String currentQuery = '';
  int currentPage = 1;
  bool isLoading = false;
  final SearchMoviesCallback searchMovies;

  SearchNotifier({required this.searchMovies}) : super([]);

  Future<void> searchMoviesByQuery(String query) async {
    if (query.isEmpty) {
      state = [];
      currentQuery = '';
      return;
    }

    if (isLoading) return;

    isLoading = true;
    currentQuery = query;
    currentPage = 1;

    try {
      final results = await searchMovies(query, page: currentPage);
      state = results;
    } catch (e) {
      state = [];
    } finally {
      isLoading = false;
    }
  }

  Future<void> loadNextPage() async {
    if (isLoading || currentQuery.isEmpty) return;

    isLoading = true;
    currentPage++;

    try {
      final results = await searchMovies(currentQuery, page: currentPage);
      state = [...state, ...results];
    } catch (e) {
      // Mantener los resultados existentes en caso de error
    } finally {
      isLoading = false;
    }
  }

  void clearSearch() {
    state = [];
    currentQuery = '';
    currentPage = 1;
  }
}
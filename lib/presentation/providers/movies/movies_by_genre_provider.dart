import 'package:cinemapedia/domain/entities/movies.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/legacy.dart';

final moviesByGenreProvider = StateNotifierProvider<MoviesByGenreNotifier, Map<String, List<Movie>>>((ref) {
  final getMoviesByGenre = ref.watch(moviesRepositoryProvider).getMoviesByGenre;
  return MoviesByGenreNotifier(getMoviesByGenre: getMoviesByGenre);
});

typedef GetMoviesByGenreCallback = Future<List<Movie>> Function(int genreId, {int page});

class MoviesByGenreNotifier extends StateNotifier<Map<String, List<Movie>>> {
  final GetMoviesByGenreCallback getMoviesByGenre;

  MoviesByGenreNotifier({required this.getMoviesByGenre}) : super({});

  Future<void> loadMoviesByGenre(int genreId) async {
    final key = genreId.toString();
    if (state[key] != null) return; // Ya está cargado

    try {
      final movies = await getMoviesByGenre(genreId);
      state = {...state, key: movies};
    } catch (e) {
      print('Error loading movies for genre $genreId: $e');
      state = {...state, key: []};
    }
  }

  Future<void> loadNextPage(int genreId) async {
    final key = genreId.toString();
    final currentMovies = state[key] ?? [];
    final currentPage = (currentMovies.length ~/ 20) + 1;

    try {
      final newMovies = await getMoviesByGenre(genreId, page: currentPage);
      state = {...state, key: [...currentMovies, ...newMovies]};
    } catch (e) {
      print('Error loading next page for genre $genreId: $e');
    }
  }
}
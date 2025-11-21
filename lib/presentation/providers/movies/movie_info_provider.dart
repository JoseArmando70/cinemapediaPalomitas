import 'package:cinemapedia/domain/entities/movies.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/legacy.dart';

final movieInfoProvider =
    StateNotifierProvider<MovieMapNotifier, Map<String, Movie>>((ref) {
      final movieRepository = ref.watch(moviesRepositoryProvider);
      return MovieMapNotifier(getMovie: movieRepository.getMovieById);
    });

/* 
  {
    '505670': Movie(...),
    '324567': Movie(...),
  }
*/

typedef GetMovieCallBack = Future<Movie> Function(String id);

class MovieMapNotifier extends StateNotifier<Map<String, Movie>> {
  final GetMovieCallBack getMovie;

  MovieMapNotifier({required this.getMovie}) : super({});

  Future<void> loadMovie(String movieId) async {
    if (state[movieId] != null) return;

    final movie = await getMovie(movieId);

    state = {...state, movieId: movie};
  }
}

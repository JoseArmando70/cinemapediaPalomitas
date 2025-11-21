import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/legacy.dart';

final movieCastProvider = StateNotifierProvider<MovieCastNotifier, Map<String, List<Actor>>>((ref) {
  final movieRepository = ref.watch(moviesRepositoryProvider);
  return MovieCastNotifier(getMovieCast: movieRepository.getMovieCast);
});

typedef GetMovieCastCallback = Future<List<Actor>> Function(String movieId);

class MovieCastNotifier extends StateNotifier<Map<String, List<Actor>>> {
  final GetMovieCastCallback getMovieCast;

  MovieCastNotifier({required this.getMovieCast}) : super({});

  Future<void> loadMovieCast(String movieId) async {
    if (state[movieId] != null) return;

    final cast = await getMovieCast(movieId);
    state = {...state, movieId: cast};
  }
}
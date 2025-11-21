import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/domain/entities/movie_video.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';

final movieVideosProvider = FutureProvider.family<List<MovieVideo>, String>((
  ref,
  movieId,
) {
  final repo = ref.watch(moviesRepositoryProvider);
  return repo.getMovieVideos(movieId);
});

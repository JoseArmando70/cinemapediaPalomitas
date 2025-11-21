import 'package:cinemapedia/domain/entities/movies.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final movieSlideshowProvider = Provider<List<Movie>>((ref){
  final nowPlayingMovies = ref.watch( nowPlayingMoviesProvider );

  if(nowPlayingMovies.isEmpty){
    return [];
  }

  return nowPlayingMovies.sublist(0,6);
});

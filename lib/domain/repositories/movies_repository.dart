import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/entities/movies.dart';
import 'package:cinemapedia/domain/entities/search_result.dart';

abstract class MoviesRepository {
  Future<List<Movie>> getNowPlaying({int page = 1});

  Future<List<Movie>> getPopular({int page = 1});

  Future<List<Movie>> getTopRated({int page = 1});

  Future<List<Movie>> getUpcoming({int page = 1});

  Future<Movie> getMovieById(String id);

  Future<List<Actor>> getMovieCast(String movieId);

  Future<List<SearchResult>> searchMovies(String query, {int page = 1});
}
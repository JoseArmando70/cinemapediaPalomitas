import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/entities/genre.dart';
import 'package:cinemapedia/domain/entities/movie_video.dart';
import 'package:cinemapedia/domain/entities/movies.dart';
import 'package:cinemapedia/domain/entities/search_result.dart';

abstract class MoviesDatasource {
  Future<List<Movie>> getNowPlaying({int page = 1});

  Future<List<Movie>> getPopular({int page = 1});

  Future<List<Movie>> getTopRated({int page = 1});

  Future<List<Movie>> getUpcoming({int page = 1});

  Future<Movie> getMovieById(String id);

  Future<List<Actor>> getMovieCast(String movieId);

  Future<List<SearchResult>> searchMovies(String query, {int page = 1});

  Future<List<Genre>> getMovieGenres();

  Future<List<Movie>> getMoviesByGenre(int genreId, {int page = 1});

  Future<List<MovieVideo>> getMovieVideos(String movieId);
}

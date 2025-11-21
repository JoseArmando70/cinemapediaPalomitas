import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/entities/movie_video.dart';
import 'package:cinemapedia/domain/entities/movies.dart';
import 'package:cinemapedia/domain/entities/search_result.dart';
import 'package:cinemapedia/domain/repositories/movies_repository.dart';
import '../../domain/entities/genre.dart';

class MovieRepositoryImpl extends MoviesRepository {
  final MoviesDatasource datasource;

  MovieRepositoryImpl(this.datasource);

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) {
    return datasource.getNowPlaying(page: page);
  }

  @override
  Future<List<Movie>> getPopular({int page = 1}) {
    return datasource.getPopular(page: page);
  }

  @override
  Future<List<Movie>> getTopRated({int page = 1}) {
    return datasource.getTopRated(page: page);
  }

  @override
  Future<List<Movie>> getUpcoming({int page = 1}) {
    return datasource.getUpcoming(page: page);
  }

  @override
  Future<Movie> getMovieById(String id) {
    return datasource.getMovieById(id);
  }

  @override
  Future<List<Actor>> getMovieCast(String movieId) {
    return datasource.getMovieCast(movieId);
  }

  @override
  Future<List<SearchResult>> searchMovies(String query, {int page = 1}) {
    return datasource.searchMovies(query, page: page);
  }

  // ✅ NUEVO: Obtener géneros
  @override
  Future<List<Genre>> getMovieGenres() {
    return datasource.getMovieGenres();
  }

  // ✅ NUEVO: Obtener películas por género
  @override
  Future<List<Movie>> getMoviesByGenre(int genreId, {int page = 1}) {
    return datasource.getMoviesByGenre(genreId, page: page);
  }

  @override
  Future<List<MovieVideo>> getMovieVideos(String movieId) {
    return datasource.getMovieVideos(movieId);
  }
}

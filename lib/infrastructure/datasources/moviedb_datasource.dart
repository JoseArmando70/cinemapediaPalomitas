import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/entities/movie_video.dart';
import 'package:cinemapedia/domain/entities/movies.dart';
import 'package:cinemapedia/domain/entities/search_result.dart';
import 'package:cinemapedia/domain/entities/genre.dart';
import 'package:cinemapedia/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infrastructure/mappers/movie_video_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/genres_response.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_credits.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_details.dart'
    as movie_details; // ✅ ALIAS
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_response.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_videos_response.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/search_response.dart';
import 'package:dio/dio.dart';

class MoviedbDatasource extends MoviesDatasource {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Environment.theMovieDbKey,
        'language': 'es-MX',
      },
    ),
  );

  List<Movie> _jsonToMovies(Map<String, dynamic> json) {
    final movieDBResponse = MovieDbResponse.fromJson(json);
    final List<Movie> movies = movieDBResponse.results
        .where((moviedb) => moviedb.posterPath != 'no-poster')
        .map((moviedb) => MovieMapper.movieDBToEntity(moviedb))
        .toList();

    return movies;
  }

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response = await dio.get(
      '/movie/now_playing',
      queryParameters: {'page': page},
    );

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
    final response = await dio.get(
      '/movie/popular',
      queryParameters: {'page': page},
    );

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getTopRated({int page = 1}) async {
    final response = await dio.get(
      '/movie/top_rated',
      queryParameters: {'page': page},
    );

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getUpcoming({int page = 1}) async {
    final response = await dio.get(
      '/movie/upcoming',
      queryParameters: {'page': page},
    );

    return _jsonToMovies(response.data);
  }

  @override
  Future<Movie> getMovieById(String id) async {
    final response = await dio.get('/movie/$id');
    if (response.statusCode != 200)
      throw Exception('Movie with id: $id not found');

    final movieDetails = movie_details.MovieDetails.fromJson(
      response.data,
    ); // ✅ USAR ALIAS

    final movie = MovieMapper.movieDetailsToEntity(movieDetails);

    return movie;
  }

  @override
  Future<List<Actor>> getMovieCast(String movieId) async {
    final response = await dio.get('/movie/$movieId/credits');

    if (response.statusCode != 200) {
      throw Exception('Error al obtener el reparto');
    }

    final movieCredits = MovieCredits.fromJson(response.data);

    final List<Actor> actors = movieCredits.cast
        .take(10)
        .map(
          (actor) => Actor(
            id: actor.id,
            name: actor.name,
            character: actor.character,
            profilePath: actor.profilePath,
          ),
        )
        .toList();

    return actors;
  }

  @override
  Future<List<SearchResult>> searchMovies(String query, {int page = 1}) async {
    if (query.isEmpty) return [];

    final response = await dio.get(
      '/search/multi',
      queryParameters: {'query': query, 'page': page, 'include_adult': false},
    );

    if (response.statusCode != 200) {
      throw Exception('Error en la búsqueda');
    }

    final searchResponse = SearchResponse.fromJson(response.data);

    final List<SearchResult> results = searchResponse.results
        .where((item) => item.mediaType == 'movie' || item.mediaType == 'tv')
        .map(
          (item) => SearchResult(
            id: item.id,
            title: item.title,
            posterPath: item.posterPath,
            backdropPath: item.backdropPath,
            mediaType: item.mediaType ?? 'movie',
            voteAverage: item.voteAverage,
            releaseDate: item.releaseDate,
            overview: item.overview,
          ),
        )
        .toList();

    return results;
  }

  @override
  Future<List<Genre>> getMovieGenres() async {
    final response = await dio.get('/genre/movie/list');

    if (response.statusCode != 200) {
      throw Exception('Error al obtener géneros');
    }

    final genresResponse = GenresResponse.fromJson(response.data);

    final List<Genre> genres = genresResponse.genres
        .map((genre) => Genre(id: genre.id, name: genre.name))
        .toList();

    return genres;
  }

  @override
  Future<List<Movie>> getMoviesByGenre(int genreId, {int page = 1}) async {
    final response = await dio.get(
      '/discover/movie',
      queryParameters: {
        'with_genres': genreId,
        'page': page,
        'sort_by': 'popularity.desc',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Error al obtener películas del género');
    }

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<MovieVideo>> getMovieVideos(String movieId) async {
    final response = await dio.get('/movie/$movieId/videos');

    final videosResponse = MovieDbVideosResponse.fromJson(response.data);
    final allVideos = videosResponse.results
        .map((e) => MovieVideoMapper.movieDBToEntity(e))
        .toList();

    // 1. Buscar Trailer oficial
    final primary = allVideos.where((v) => v.isPrimaryTrailer).toList();
    if (primary.isNotEmpty) return primary;

    // 2. Buscar Teaser / Clip / Featurette
    final secondary = allVideos.where((v) => v.isSecondaryTrailer).toList();
    if (secondary.isNotEmpty) return secondary;

    // 3. Cualquier video válido de YouTube
    final fallback = allVideos.where((v) => v.isAnyYoutubeVideo).toList();
    return fallback;
  }
}

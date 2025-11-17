import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/entities/movies.dart';
import 'package:cinemapedia/domain/entities/search_result.dart';
import 'package:cinemapedia/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_credits.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_details.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_response.dart';
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

    final movieDetails = MovieDetails.fromJson(response.data);

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
        .map((actor) => Actor(
              id: actor.id,
              name: actor.name,
              character: actor.character,
              profilePath: actor.profilePath,
            ))
        .toList();

    return actors;
  }
 @override
  Future<List<SearchResult>> searchMovies(String query, {int page = 1}) async {
    if (query.isEmpty) return [];

    final response = await dio.get(
      '/search/multi',
      queryParameters: {
        'query': query,
        'page': page,
        'include_adult': false,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Error en la búsqueda');
    }

    final searchResponse = SearchResponse.fromJson(response.data);
    
    // Filtrar solo películas y series (excluir personas por ahora)
    final List<SearchResult> results = searchResponse.results
        .where((item) => item.mediaType == 'movie' || item.mediaType == 'tv')
        .map((item) => SearchResult(
              id: item.id,
              title: item.title,
              posterPath: item.posterPath,
              backdropPath: item.backdropPath,
              mediaType: item.mediaType ?? 'movie',
              voteAverage: item.voteAverage,
              releaseDate: item.releaseDate,
              overview: item.overview,
            ))
        .toList();

    return results;
  }
}




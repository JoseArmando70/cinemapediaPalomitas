import 'package:cinemapedia/domain/entities/movie_video.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_videos_response.dart';

class MovieVideoMapper {
  static MovieVideo movieDBToEntity(MovieVideoDB moviedb) => MovieVideo(
    id: moviedb.id,
    name: moviedb.name,
    type: moviedb.type,
    site: moviedb.site,
    key: moviedb.key,
  );
}

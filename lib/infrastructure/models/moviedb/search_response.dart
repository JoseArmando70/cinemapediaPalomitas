class SearchResponse {
  final int page;
  final List<SearchMovieDB> results;
  final int totalPages;
  final int totalResults;

  SearchResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) => SearchResponse(
        page: json["page"],
        results: List<SearchMovieDB>.from(
            json["results"].map((x) => SearchMovieDB.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );
}

class SearchMovieDB {
  final bool? adult;
  final String? backdropPath;
  final List<int>? genreIds;
  final int id;
  final String? mediaType;
  final String? originalLanguage;
  final String? originalTitle;
  final String overview;
  final double popularity;
  final String? posterPath;
  final String? releaseDate;
  final String title;
  final bool? video;
  final double voteAverage;
  final int voteCount;

  SearchMovieDB({
    this.adult,
    this.backdropPath,
    this.genreIds,
    required this.id,
    this.mediaType,
    this.originalLanguage,
    this.originalTitle,
    required this.overview,
    required this.popularity,
    this.posterPath,
    this.releaseDate,
    required this.title,
    this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  factory SearchMovieDB.fromJson(Map<String, dynamic> json) => SearchMovieDB(
        adult: json["adult"],
        backdropPath: json["backdrop_path"],
        genreIds: json["genre_ids"] == null
            ? []
            : List<int>.from(json["genre_ids"]!.map((x) => x)),
        id: json["id"],
        mediaType: json["media_type"],
        originalLanguage: json["original_language"],
        originalTitle: json["original_title"],
        overview: json["overview"] ?? '',
        popularity: json["popularity"]?.toDouble() ?? 0.0,
        posterPath: json["poster_path"],
        releaseDate: json["release_date"],
        title: json["title"] ?? json["name"] ?? 'Sin título',
        video: json["video"],
        voteAverage: json["vote_average"]?.toDouble() ?? 0.0,
        voteCount: json["vote_count"] ?? 0,
      );
}
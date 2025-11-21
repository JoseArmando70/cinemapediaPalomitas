class SearchResult {
  final int id;
  final String title;
  final String? posterPath;
  final String? backdropPath;
  final String mediaType;
  final double? voteAverage;
  final String? releaseDate;
  final String? overview;

  SearchResult({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.backdropPath,
    required this.mediaType,
    this.voteAverage,
    this.releaseDate,
    this.overview,
  });

  String get fullPosterPath {
    if (posterPath != null) {
      return 'https://image.tmdb.org/t/p/w500$posterPath';
    }
    return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRoWcWg0E8pSjBNi0TtiZsqu8uD2PAr_K11DA&s';
  }

  String get fullBackdropPath {
    if (backdropPath != null) {
      return 'https://image.tmdb.org/t/p/w500$backdropPath';
    }
    return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRoWcWg0E8pSjBNi0TtiZsqu8uD2PAr_K11DA&s';
  }
}
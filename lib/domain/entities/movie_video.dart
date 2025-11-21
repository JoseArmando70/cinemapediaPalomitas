class MovieVideo {
  final String id;
  final String name;
  final String type;
  final String site;
  final String key; // YouTube video ID

  MovieVideo({
    required this.id,
    required this.name,
    required this.type,
    required this.site,
    required this.key,
  });

  bool get isPrimaryTrailer => type == 'Trailer' && site == 'YouTube';

  bool get isSecondaryTrailer =>
      (type == 'Teaser' || type == 'Clip' || type == 'Featurette') &&
      site == 'YouTube';

  bool get isAnyYoutubeVideo => site == 'YouTube';
}

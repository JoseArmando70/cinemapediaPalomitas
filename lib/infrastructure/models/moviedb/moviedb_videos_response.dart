class MovieDbVideosResponse {
  final List<MovieVideoDB> results;

  MovieDbVideosResponse({required this.results});

  factory MovieDbVideosResponse.fromJson(Map<String, dynamic> json) =>
      MovieDbVideosResponse(
        results: (json["results"] as List)
            .map((e) => MovieVideoDB.fromJson(e))
            .toList(),
      );
}

class MovieVideoDB {
  final String id;
  final String name;
  final String type;
  final String site;
  final String key;

  MovieVideoDB({
    required this.id,
    required this.name,
    required this.type,
    required this.site,
    required this.key,
  });

  factory MovieVideoDB.fromJson(Map<String, dynamic> json) => MovieVideoDB(
    id: json["id"],
    name: json["name"],
    type: json["type"],
    site: json["site"],
    key: json["key"],
  );
}

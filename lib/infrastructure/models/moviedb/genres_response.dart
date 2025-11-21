class GenresResponse {
  final List<GenreModel> genres;

  GenresResponse({
    required this.genres,
  });

  factory GenresResponse.fromJson(Map<String, dynamic> json) => GenresResponse(
        genres: List<GenreModel>.from(
            json["genres"].map((x) => GenreModel.fromJson(x))),
      );
}

class GenreModel {
  final int id;
  final String name;

  GenreModel({
    required this.id,
    required this.name,
  });

  factory GenreModel.fromJson(Map<String, dynamic> json) => GenreModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
              
class MovieCredits {
  final List<ActorModel> cast;
  final List<Crew> crew;

  MovieCredits({required this.cast, required this.crew});

  factory MovieCredits.fromJson(Map<String, dynamic> json) => MovieCredits(
        cast: List<ActorModel>.from(json["cast"].map((x) => ActorModel.fromJson(x))),
        crew: List<Crew>.from(json["crew"].map((x) => Crew.fromJson(x))),
      );
}

class ActorModel {
  final int id;
  final String name;
  final String? profilePath;
  final String character;

  ActorModel({
    required this.id,
    required this.name,
    required this.profilePath,
    required this.character,
  });

  factory ActorModel.fromJson(Map<String, dynamic> json) => ActorModel(
        id: json["id"],
        name: json["name"],
        profilePath: json["profile_path"],
        character: json["character"],
      );
}

class Crew {
  final String name;
  final String job;

  Crew({required this.name, required this.job});

  factory Crew.fromJson(Map<String, dynamic> json) => Crew(
        name: json["name"],
        job: json["job"],
      );
}
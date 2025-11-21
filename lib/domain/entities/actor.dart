class Actor {
  final int id;
  final String name;
  final String? profilePath;
  final String character;

  Actor({
    required this.id,
    required this.name,
    required this.profilePath,
    required this.character,
  });

  String get fullProfilePath {
    if (profilePath != null) {
      return 'https://image.tmdb.org/t/p/w500$profilePath';
    }
    return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRoWcWg0E8pSjBNi0TtiZsqu8uD2PAr_K11DA&s';
  }
}
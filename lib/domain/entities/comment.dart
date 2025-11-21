class Comment {
  final String id;
  final String movieId;
  final String userId;
  final String userName;      // Nombre para mostrar
  final String? userEmail;    //  Correo
  final String? userPhotoUrl; //  Foto de perfil
  final String text;
  final DateTime timestamp;

  Comment({
    required this.id,
    required this.movieId,
    required this.userId,
    required this.userName,
    this.userEmail,
    this.userPhotoUrl,
    required this.text,
    required this.timestamp,
  });
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cinemapedia/domain/entities/movies.dart';
import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';

class FirestoreRepositoryImpl extends LocalStorageRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get _favoritesCollection {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('Usuario no logueado');
    return _firestore.collection('users').doc(uid).collection('favorites');
  }

  @override
  Future<bool> isMovieFavorite(int movieId) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return false;
      
      final doc = await _favoritesCollection.doc(movieId.toString()).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> toggleFavorite(Movie movie) async {
    final docRef = _favoritesCollection.doc(movie.id.toString());
    final doc = await docRef.get();

    if (doc.exists) {
   
      await docRef.delete();
    } else {
      // Si no existe, lo creamos (agregar a favoritos)
      // Convertimos la entidad Movie a un Mapa simple para guardar
      await docRef.set({
        'id': movie.id,
        'title': movie.title,
        'posterPath': movie.posterPath,
        'backdropPath': movie.backdropPath,
        'overview': movie.overview,
        'voteAverage': movie.voteAverage,
        'releaseDate': movie.releaseDate.toIso8601String(),
        'popularity': movie.popularity,
        'isAdult': movie.adult,
        'originalLanguage': movie.originalLanguage,
        'originalTitle': movie.originalTitle,
        'video': movie.video,
        'voteCount': movie.voteCount,
        'genreIds': movie.genreIds,
        'timestamp': FieldValue.serverTimestamp(), // Para ordenar después
      });
    }
  }

  

 @override
  Future<List<Movie>> loadMovies({int limit = 10, offset = 0}) async {
    final snapshot = await _favoritesCollection
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .get();

    final List<Movie> movies = [];

    for (final doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;

      // Creación manual de la película con protección de tipos
      movies.add(Movie(
        adult: data['isAdult'] ?? false,
        backdropPath: data['backdropPath'] ?? '',
        // Aseguramos que genreIds sea una lista de Strings
        genreIds: List<String>.from(data['genreIds']?.map((e) => e.toString()) ?? []),
        id: data['id'] ?? 0,
        originalLanguage: data['originalLanguage'] ?? '',
        originalTitle: data['originalTitle'] ?? '',
        overview: data['overview'] ?? '',
        // 🔥 AQUÍ ESTÁ EL ARREGLO CLAVE: (as num?)?.toDouble()
        // Esto acepta tanto 7 como 7.5 y lo convierte a 7.0 o 7.5 sin error
        popularity: (data['popularity'] as num?)?.toDouble() ?? 0.0,
        posterPath: data['posterPath'] ?? '',
        releaseDate: DateTime.tryParse(data['releaseDate'] ?? '') ?? DateTime.now(),
        title: data['title'] ?? 'Sin Título',
        video: data['video'] ?? false,
        // 🔥 AQUÍ TAMBIÉN:
        voteAverage: (data['voteAverage'] as num?)?.toDouble() ?? 0.0,
        voteCount: data['voteCount'] ?? 0,
      ));
    }

    return movies;
  }
}
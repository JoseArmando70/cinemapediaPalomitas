import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cinemapedia/domain/entities/movies.dart';
import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';

class FirestoreRepositoryImpl extends LocalStorageRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Helper para obtener la colección del usuario actual
  CollectionReference get _favoritesCollection {
    final uid = _auth.currentUser?.uid;
    // Si no hay usuario, retornamos una referencia segura o lanzamos error controlado
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
      // Borrar
      await docRef.delete();
    } else {
      // Crear
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
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Future<List<Movie>> loadMovies({int limit = 10, offset = 0}) async {
    try {
      // 1. Intentamos obtener los datos
      final snapshot = await _favoritesCollection
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();

      final List<Movie> movies = [];

      for (final doc in snapshot.docs) {
        try {
          // 2. Convertimos los datos de forma SEGURA
          final data = doc.data() as Map<String, dynamic>;

          // Validación mínima: Si no tiene título o path, no sirve.
          if (data['title'] == null || data['posterPath'] == null) continue;

          movies.add(Movie(
            adult: data['isAdult'] ?? false,
            backdropPath: data['backdropPath'] ?? '',
            // Convertimos la lista de géneros a String de forma segura
            genreIds: (data['genreIds'] as List<dynamic>?)
                    ?.map((e) => e.toString())
                    .toList() ?? [],
            id: data['id'] ?? 0,
            originalLanguage: data['originalLanguage'] ?? '',
            originalTitle: data['originalTitle'] ?? '',
            overview: data['overview'] ?? '',
            // 🔥 EL ARREGLO MÁGICO: (as num?)?.toDouble()
            // Esto evita el crash por "int is not subtype of double"
            popularity: (data['popularity'] as num?)?.toDouble() ?? 0.0,
            posterPath: data['posterPath'] ?? '',
            releaseDate: DateTime.tryParse(data['releaseDate'] ?? '') ?? DateTime.now(),
            title: data['title'] ?? 'Sin Título',
            video: data['video'] ?? false,
            // 🔥 AQUÍ TAMBIÉN
            voteAverage: (data['voteAverage'] as num?)?.toDouble() ?? 0.0,
            voteCount: (data['voteCount'] as num?)?.toInt() ?? 0,
          ));
        } catch (e) {
          // Si UNA película falla, la imprimimos en consola pero NO rompemos la app
          print("⚠️ Error al leer una película: $e");
        }
      }
      return movies;

    } catch (e) {
      print("❌ Error general al cargar favoritos: $e");
      return []; // Retornamos lista vacía en vez de romper todo
    }
  }
}
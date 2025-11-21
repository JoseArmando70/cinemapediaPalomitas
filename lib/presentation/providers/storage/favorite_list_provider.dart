import 'package:cinemapedia/domain/entities/movies.dart';
import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:cinemapedia/presentation/providers/storage/favorite_movies_provider.dart'; // 👈 IMPORTANTE: Importamos el repositorio de aquí


final favoriteMoviesProvider = StateNotifierProvider<FavoriteMoviesNotifier, List<Movie>>((ref) {
  // Ahora lee el repositorio desde el otro archivo (favorite_movies_provider.dart)
  final repository = ref.watch(localStorageRepositoryProvider);
  return FavoriteMoviesNotifier(localStorageRepository: repository);
});


class FavoriteMoviesNotifier extends StateNotifier<List<Movie>> {
  int page = 0;
  final LocalStorageRepository localStorageRepository;
  
  // ✅ Usamos un Set para almacenar los IDs ya cargados y evitar duplicados
  final Set<int> loadedMovieIds = {}; 

  FavoriteMoviesNotifier({required this.localStorageRepository}) : super([]);

  Future<List<Movie>> loadNextPage() async {
    final movies = await localStorageRepository.loadMovies(limit: 20, offset: page * 20);
    
    if (movies.isEmpty) {
        return movies;
    }
    
    // Filtramos para asegurarnos de que sean únicas
    final List<Movie> newUniqueMovies = [];
    for (final movie in movies) {
        if (!loadedMovieIds.contains(movie.id)) { 
            newUniqueMovies.add(movie);
            loadedMovieIds.add(movie.id); 
        }
    }
    
    if (newUniqueMovies.isNotEmpty) {
      page++;
    }
    
    state = [...state, ...newUniqueMovies];
    return newUniqueMovies; 
  }
  
  // ✅ MÉTODO CLAVE: Para refrescar la lista después de borrar o al entrar
  Future<void> refreshFavorites() async {
    page = 0;
    state = [];
    loadedMovieIds.clear(); // Limpiamos la caché
    await loadNextPage();
  }
}
import 'package:cinemapedia/domain/entities/genre.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/legacy.dart';

final genresProvider = StateNotifierProvider<GenresNotifier, List<Genre>>((ref) {
  final getGenres = ref.watch(moviesRepositoryProvider).getMovieGenres;
  return GenresNotifier(getGenres: getGenres);
});

typedef GetGenresCallback = Future<List<Genre>> Function();

class GenresNotifier extends StateNotifier<List<Genre>> {
  final GetGenresCallback getGenres;
  bool isLoading = false;

  GenresNotifier({required this.getGenres}) : super([]);

  Future<void> loadGenres() async {
    if (isLoading || state.isNotEmpty) return;

    isLoading = true;
    
    try {
      final genres = await getGenres();
      state = genres;
    } catch (e) {
      print('Error loading genres: $e');
      // Mantener estado vacío en caso de error
    } finally {
      isLoading = false;
    }
  }
}
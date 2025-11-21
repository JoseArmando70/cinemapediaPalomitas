import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';
import 'package:cinemapedia/infrastructure/repositories/firestore_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. Instancia del repositorio
final localStorageRepositoryProvider = Provider<LocalStorageRepository>((ref) {
  return FirestoreRepositoryImpl();
});

// 2. Provider para saber si UNA película es favorita
// Usamos .family porque necesitamos pasarle el ID de la película
final isFavoriteProvider = FutureProvider.family.autoDispose<bool, int>((ref, movieId) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
  return localStorageRepository.isMovieFavorite(movieId);
});
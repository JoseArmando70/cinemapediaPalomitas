import 'package:cinemapedia/domain/entities/comment.dart';
import 'package:cinemapedia/infrastructure/repositories/comments_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Instancia del repositorio
final commentsRepositoryProvider = Provider((ref) => CommentsRepositoryImpl());

// StreamProvider para escuchar los comentarios de una película específica
final commentsByMovieProvider = StreamProvider.family<List<Comment>, String>((ref, movieId) {
  final repository = ref.watch(commentsRepositoryProvider);
  return repository.getCommentsByMovie(movieId);
});
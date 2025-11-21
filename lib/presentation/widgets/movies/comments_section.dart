import 'package:cinemapedia/presentation/providers/auth/auth_provider.dart';
import 'package:cinemapedia/presentation/providers/comments/comments_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CommentsSection extends ConsumerStatefulWidget {
  final String movieId;
  const CommentsSection({super.key, required this.movieId});

  @override
  CommentsSectionState createState() => CommentsSectionState();
}

class CommentsSectionState extends ConsumerState<CommentsSection> {
  final _commentController = TextEditingController();

  void _submitComment() {
    final user = ref.read(authStateProvider).value;
    if (user == null || _commentController.text.trim().isEmpty) return;

    // ✅ Usamos el nombre de Google si existe, o la primera parte del correo
    final nameToShow = user.displayName ?? user.email!.split('@')[0];

    ref.read(commentsRepositoryProvider).addComment(
          movieId: widget.movieId,
          userId: user.uid,
          userName: nameToShow, 
          userEmail: user.email,        
          userPhotoUrl: user.photoURL,  
          text: _commentController.text.trim(),
        );

    _commentController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final commentsAsyncValue = ref.watch(commentsByMovieProvider(widget.movieId));
    final user = ref.watch(authStateProvider).value;
    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Comentarios', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          
          if (user != null)
            Row(
              children: [
                // Tu foto actual al escribir
                CircleAvatar(
                  radius: 18,
                  backgroundImage: user.photoURL != null ? NetworkImage(user.photoURL!) : null,
                  child: user.photoURL == null ? Text(user.email![0].toUpperCase()) : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Escribe tu opinión...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _submitComment,
                  icon: const Icon(Icons.send),
                  color: Theme.of(context).primaryColor,
                )
              ],
            )
          else
            const Center(child: Text('Inicia sesión para comentar')),

          const SizedBox(height: 20),

          commentsAsyncValue.when(
            data: (comments) {
              if (comments.isEmpty) return const Center(child: Text('Sé el primero en comentar.'));
              
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  return Card(
                    elevation: 1,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //   FOTO DE PERFIL 
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: comment.userPhotoUrl != null 
                                ? NetworkImage(comment.userPhotoUrl!) 
                                : null,
                            child: comment.userPhotoUrl == null 
                                ? Text(comment.userName[0].toUpperCase()) 
                                : null,
                          ),
                          const SizedBox(width: 12),
                          
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //  NOMBRE Y FECHA
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(comment.userName, style: textStyles.titleSmall),
                                    Text(
                                      DateFormat.MMMd().format(comment.timestamp),
                                      style: textStyles.bodySmall?.copyWith(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                
                                //  CORREO 
                                if (comment.userEmail != null)
                                  Text(comment.userEmail!, style: textStyles.bodySmall?.copyWith(fontSize: 10, color: Colors.grey[600])),
                                
                                const SizedBox(height: 6),
                                
                                //   COMENTARIO
                                Text(comment.text, style: textStyles.bodyMedium),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text('Error: $e')),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
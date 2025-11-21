import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cinemapedia/domain/entities/comment.dart';

class CommentsRepositoryImpl {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Comment>> getCommentsByMovie(String movieId) {
    return _firestore
        .collection('comments')
        .where('movieId', isEqualTo: movieId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return Comment(
                id: doc.id,
                movieId: data['movieId'],
                userId: data['userId'],
                userName: data['userName'] ?? 'Usuario',
                userEmail: data['userEmail'],          
                userPhotoUrl: data['userPhotoUrl'],    
                text: data['text'],
                timestamp: (data['timestamp'] as Timestamp).toDate(),
              );
            }).toList());
  }

  Future<void> addComment({
    required String movieId,
    required String userId,
    required String userName,
    String? userEmail,       
    String? userPhotoUrl,    
    required String text,
  }) async {
    await _firestore.collection('comments').add({
      'movieId': movieId,
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,       
      'userPhotoUrl': userPhotoUrl, 
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
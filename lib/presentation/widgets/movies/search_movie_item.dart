import 'package:cinemapedia/domain/entities/search_result.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchMovieItem extends StatelessWidget {
  final SearchResult result;

  const SearchMovieItem({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          result.fullPosterPath,
          width: 50,
          height: 75,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 50,
              height: 75,
              color: Colors.grey[300],
              child: Icon(Icons.movie_outlined, color: Colors.grey[600]),
            );
          },
        ),
      ),
      title: Text(
        result.title,
        style: textStyle.bodyMedium,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (result.releaseDate != null)
            Text(
              'Estreno: ${result.releaseDate!.substring(0, 4)}',
              style: textStyle.bodySmall,
            ),
          if (result.voteAverage != null && result.voteAverage! > 0)
            Row(
              children: [
                Icon(Icons.star, size: 14, color: Colors.amber),
                SizedBox(width: 4),
                Text(
                  '${result.voteAverage!.toStringAsFixed(1)}',
                  style: textStyle.bodySmall,
                ),
              ],
            ),
        ],
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
      onTap: () {
        // Navegar a la pantalla de detalles de la película
        if (result.mediaType == 'movie') {
          context.push('/movie/${result.id}');
        }
        // Para series podrías agregar otra pantalla
      },
    );
  }
}
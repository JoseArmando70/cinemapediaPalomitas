import 'package:cinemapedia/domain/entities/genre.dart';
import 'package:flutter/material.dart';

class GenreCard extends StatelessWidget {
  final Genre genre;
  final VoidCallback onTap;

  const GenreCard({
    super.key,
    required this.genre,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 150,
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getGenreIcon(genre.name),
                size: 40,
                color: colors.primary,
              ),
              SizedBox(height: 8),
              Text(
                genre.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getGenreIcon(String genreName) {
    switch (genreName.toLowerCase()) {
      case 'acción':
        return Icons.bolt;
      case 'aventura':
        return Icons.explore;
      case 'animación':
        return Icons.animation;
      case 'comedia':
        return Icons.sentiment_very_satisfied;
      case 'crimen':
        return Icons.security;
      case 'documental':
        return Icons.movie_filter;
      case 'drama':
        return Icons.theaters;
      case 'familia':
        return Icons.family_restroom;
      case 'fantasía':
        return Icons.auto_awesome;
      case 'historia':
        return Icons.history;
      case 'terror':
        return Icons.warning;
      case 'música':
        return Icons.music_note;
      case 'misterio':
        return Icons.psychology;
      case 'romance':
        return Icons.favorite;
      case 'ciencia ficción':
        return Icons.rocket_launch;
      case 'tv movie':
        return Icons.live_tv;
      case 'suspense':
        return Icons.nightlight_round;
      case 'guerra':
        return Icons.military_tech;
      case 'western':
        return Icons.landscape;
      default:
        return Icons.movie;
    }
  }
}
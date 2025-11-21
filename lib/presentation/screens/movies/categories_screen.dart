import 'package:cinemapedia/domain/entities/genre.dart';
import 'package:cinemapedia/presentation/providers/movies/genres_provider.dart';
import 'package:cinemapedia/presentation/widgets/movies/genre_card.dart';
import 'package:cinemapedia/presentation/widgets/shared/custom_appbar.dart';
import 'package:cinemapedia/presentation/widgets/shared/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  static const name = 'categories-screen';

  const CategoriesScreen({super.key});

  @override
  CategoriesScreenState createState() => CategoriesScreenState();
}

class CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar géneros cuando se inicia la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(genresProvider.notifier).loadGenres();
    });
  }

  void _onGenreTap(Genre genre) {
    context.push('/genre/${genre.id}', extra: genre.name);
  }

  @override
  Widget build(BuildContext context) {
    final genres = ref.watch(genresProvider);

    return Scaffold(
      appBar: CustomAppbar(),
      body: genres.isEmpty
          ? FullScreenLoader()
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Categorías',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: genres.length,
                      itemBuilder: (context, index) {
                        final genre = genres[index];
                        return GenreCard(
                          genre: genre,
                          onTap: () => _onGenreTap(genre),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
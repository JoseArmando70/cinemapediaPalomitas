import 'package:cinemapedia/presentation/providers/movies/movies_by_genre_provider.dart';
import 'package:cinemapedia/presentation/widgets/movies/movie_horizontal_listview.dart';
import 'package:cinemapedia/presentation/widgets/shared/custom_appbar.dart';
import 'package:cinemapedia/presentation/widgets/shared/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MoviesByGenreScreen extends ConsumerStatefulWidget {
  static const name = 'movies-by-genre-screen';

  final int genreId;
  final String genreName;

  const MoviesByGenreScreen({
    super.key,
    required this.genreId,
    required this.genreName,
  });

  @override
  MoviesByGenreScreenState createState() => MoviesByGenreScreenState();
}

class MoviesByGenreScreenState extends ConsumerState<MoviesByGenreScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar películas del género cuando se inicia la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(moviesByGenreProvider.notifier).loadMoviesByGenre(widget.genreId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final movies = ref.watch(moviesByGenreProvider)[widget.genreId.toString()] ?? [];

    return Scaffold(
      appBar: CustomAppbar(),
      body: movies.isEmpty
          ? FullScreenLoader()
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  expandedHeight: 100,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      widget.genreName,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    centerTitle: true,
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    MovieHorizontalListview(
                      movies: movies,
                      title: 'Películas de ${widget.genreName}',
                      loadNextPage: () {
                        ref.read(moviesByGenreProvider.notifier).loadNextPage(widget.genreId);
                      },
                    ),
                  ]),
                ),
              ],
            ),
    );
  }
}
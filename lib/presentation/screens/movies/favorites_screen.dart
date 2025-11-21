import 'package:cinemapedia/presentation/providers/storage/favorite_list_provider.dart';
import 'package:cinemapedia/presentation/widgets/shared/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  static const name = 'favorites-screen';

  const FavoritesScreen({super.key});

  @override
  FavoritesScreenState createState() => FavoritesScreenState();
}

class FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  bool isLastPage = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // La carga inicial se maneja en didChangeDependencies
  }

  // ✅ Se ejecuta cuando la pantalla recibe el foco (ej: al volver de Detalles)
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refreshAndLoad();
  }

  void _refreshAndLoad() async {
    if (isLoading) return;
    
    isLoading = true;
    setState(() {}); // Muestra loading si es necesario

    // 1. Refrescamos el provider (esto es void)
    await ref.read(favoriteMoviesProvider.notifier).refreshFavorites();
    
    // 2. ✅ ARREGLO DEL ERROR VOID: Leemos el estado actualizado directamente
    final movies = ref.read(favoriteMoviesProvider);
    
    if (mounted) {
      isLoading = false;
      isLastPage = movies.isEmpty;
      setState(() {});
    }
  }

  void _loadNextPage() async {
    if (isLoading || isLastPage) return;
    
    isLoading = true;
    // loadNextPage SÍ devuelve una lista, así que esto es seguro
    final movies = await ref.read(favoriteMoviesProvider.notifier).loadNextPage();
    isLoading = false;

    if (movies.isEmpty) {
      isLastPage = true;
    }
    if (mounted) setState(() {});
  }

  Widget _buildEmptyState(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: colors.primary),
          const SizedBox(height: 20),
          Text('¡Aún no tienes favoritos!', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 10),
          Text('Dale al corazón en las películas que te gusten.', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey)),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () => context.go('/'),
            icon: const Icon(Icons.home),
            label: const Text('Ir a la Home'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favoriteMovies = ref.watch(favoriteMoviesProvider);
    
    // Mostrar loader solo si está vacío y cargando
    if (favoriteMovies.isEmpty && isLoading) {
      return const FullScreenLoader();
    }
    
    if (favoriteMovies.isEmpty && !isLoading) {
      return _buildEmptyState(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Favoritos'),
        centerTitle: true,
        // ✅ Flecha de regreso
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new), 
          onPressed: () => context.go('/'),
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          if (notification is ScrollEndNotification && notification.metrics.extentAfter == 0) {
            _loadNextPage();
          }
          return false;
        },
        child: GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2/3,
          ),
          itemCount: favoriteMovies.length,
          itemBuilder: (context, index) {
            final movie = favoriteMovies[index];
            return GestureDetector(
              onTap: () => context.push('/movie/${movie.id}'),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  movie.posterPath,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(color: Colors.grey[200]);
                  },
                  errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.error)),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
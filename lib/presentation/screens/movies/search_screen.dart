import 'package:cinemapedia/domain/entities/search_result.dart';
import 'package:cinemapedia/presentation/providers/movies/search_provider.dart';
import 'package:cinemapedia/presentation/widgets/movies/search_movie_item.dart';
import 'package:cinemapedia/presentation/widgets/shared/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchScreen extends ConsumerStatefulWidget {
  static const name = 'search-screen';

  const SearchScreen({super.key});

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isInitialLoad = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Enfocar el campo de búsqueda al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(FocusNode());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(searchResultsProvider.notifier).loadNextPage();
    }
  }

  void _onQueryChanged(String query) {
    ref.read(searchQueryProvider.notifier).state = query;
    
    if (query.length >= 3) {
      _isInitialLoad = false;
      ref.read(searchResultsProvider.notifier).searchMoviesByQuery(query);
    } else {
      ref.read(searchResultsProvider.notifier).clearSearch();
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(searchResultsProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    return Scaffold(
      appBar: CustomAppbar(),
      body: SafeArea(
        child: Column(
          children: [
            // Barra de búsqueda
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar películas...',
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _onQueryChanged('');
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceVariant,
                ),
                onChanged: _onQueryChanged,
                textInputAction: TextInputAction.search,
              ),
            ),

            // Resultados o estado vacío
            Expanded(
              child: _buildContent(searchResults, searchQuery),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(List<SearchResult> results, String query) {
    if (_isInitialLoad && query.isEmpty) {
      return _buildEmptyState('Escribe para buscar películas');
    }

    if (query.isNotEmpty && query.length < 3) {
      return _buildEmptyState('Escribe al menos 3 caracteres');
    }

    if (results.isEmpty && query.length >= 3) {
      return _buildEmptyState('No se encontraron resultados para "$query"');
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: results.length + 1, // +1 para el loading indicator
      itemBuilder: (context, index) {
        if (index < results.length) {
          return SearchMovieItem(result: results[index]);
        } else {
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 64, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
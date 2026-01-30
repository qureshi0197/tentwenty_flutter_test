import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_list/theme/app_colors.dart';
import 'package:movie_list/ui/movie_detail/movie_detail_screen.dart';
import '../../data/providers/providers.dart';
import 'movie_list_item.dart';

class MovieListScreen extends ConsumerStatefulWidget {
  const MovieListScreen({super.key, required this.onSearchTap});
  final VoidCallback onSearchTap;

  @override
  ConsumerState<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends ConsumerState<MovieListScreen> {
  int _page = 1;
  @override
  Widget build(BuildContext context) {
    final moviesAsync = ref.watch(movieListProvider);
    return Scaffold(
      backgroundColor: AppColors.divider,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Watch'),
        toolbarHeight: 80,
        backgroundColor: AppColors.background,
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: widget.onSearchTap)],
      ),
      body: moviesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) {
          return const Center(child: Text('Unable to load movies.\nShowing offline data if available.', textAlign: TextAlign.center));
        },
        data: (movies) {
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: movies.length + 1,
            itemBuilder: (context, index) {
              if (index == movies.length) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: OutlinedButton(
                      onPressed: () {
                        ref.read(movieListProvider.notifier).loadMore();
                      },
                      child: const Text('Load More'),
                    ),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: MovieListItem(
                  movie: movies[index],
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => MovieDetailScreen(movieId: movies[index].id)));
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_list/data/constants/genres_assets.dart';
import 'package:movie_list/ui/movie_detail/movie_detail_screen.dart';
import '../../data/providers/providers.dart';
import '../../data/constants/genres.dart';
import '../../theme/app_colors.dart';
import '../../data/models/movie_list_model.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key, required this.onBack, required this.onDone});
  final VoidCallback onBack;
  final Function(List<MovieListModel>) onDone;

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resultsAsync = ref.watch(movieSearchResultsProvider);
    final query = ref.watch(movieSearchQueryProvider);

    debugPrint("Query is query: $query");

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TextField(
          controller: _controller,
          onChanged: (value) {
            ref.read(movieSearchQueryProvider.notifier).state = value;
          },
          onSubmitted: (_) async {
            FocusScope.of(context).unfocus();

            if (_controller.text.trim().isEmpty) return;

            final results = await ref.read(movieSearchResultsProvider.future);
            ref.read(movieSearchQueryProvider.notifier).state = '';

            if (results.isNotEmpty) {
              widget.onDone(results);
            }
          },
          decoration: InputDecoration(
            hintText: 'TV shows, movies and more',
            border: InputBorder.none,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _controller.clear();
                        FocusScope.of(context).unfocus(); // dismiss keyboard
                        ref.read(movieSearchQueryProvider.notifier).state = '';
                      });
                      // widget.onBack();
                    },
                  )
                : null,
          ),
        ),
      ),

      body: query.trim().isEmpty
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2,
                children: genreMap.values.map((genre) {
                  final genreId = genreMap.entries.firstWhere((e) => e.value == genre).key;

                  final imagePath = genreImageMap[genreId] ?? defaultGenreImage;

                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Background image
                        Image.asset(imagePath, fit: BoxFit.cover),

                        // Gradient overlay
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black54],
                            ),
                          ),
                        ),

                        // Genre name (bottom-left)
                        Positioned(
                          left: 12,
                          bottom: 12,
                          child: Text(
                            genre,
                            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ) // ALWAYS show genres when query is empty
          : resultsAsync.when(
              data: (movies) {
                if (movies.isEmpty) {
                  return const SizedBox(); // or empty state
                }

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Top Results', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Divider(color: AppColors.divider),

                      const SizedBox(height: 8),

                      Expanded(
                        child: ListView.separated(
                          itemCount: movies.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            return _SearchMovieTile(movie: movies[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
              loading: () => const SizedBox(),
              error: (error, _) {
                return const Center(child: Text('No internet connection.\nPlease check your network.', textAlign: TextAlign.center));
              },
            ),
    );
  }
}

class _SearchMovieTile extends StatelessWidget {
  final MovieListModel movie;

  const _SearchMovieTile({required this.movie});

  @override
  Widget build(BuildContext context) {
    final imageUrl = movie.posterPath != null ? 'https://image.tmdb.org/t/p/w200${movie.posterPath}' : null;

    final firstGenre = movie.genreIds.isNotEmpty ? genreMap[movie.genreIds.first] ?? '' : '';

    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => MovieDetailScreen(movieId: movie.id)));
      },
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: imageUrl != null
                ? Image.network(imageUrl, width: 60, height: 80, fit: BoxFit.cover)
                : Container(width: 60, height: 80, color: Colors.grey.shade300),
          ),

          const SizedBox(width: 12),

          // Title + genre
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(firstGenre, style: const TextStyle(fontSize: 12, color: AppColors.secondaryText)),
              ],
            ),
          ),

          // More icon
          const Icon(Icons.more_horiz),
        ],
      ),
    );
  }
}

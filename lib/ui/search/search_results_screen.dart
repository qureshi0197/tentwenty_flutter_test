import 'package:flutter/material.dart';
import '../../data/models/movie_list_model.dart';
import '../../theme/app_colors.dart';
import '../../data/constants/genres.dart';
import '../movie_detail/movie_detail_screen.dart';

class SearchResultsScreen extends StatelessWidget {
  final List<MovieListModel> results;
  final VoidCallback onBack;

  const SearchResultsScreen({super.key, required this.results, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: onBack),
        title: Text('${results.length} Results Found', style: const TextStyle(fontSize: 16)),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: results.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final movie = results[index];
          final firstGenre = movie.genreIds.isNotEmpty ? genreMap[movie.genreIds.first] ?? '' : '';

          final imageUrl = movie.posterPath != null ? 'https://image.tmdb.org/t/p/w200${movie.posterPath}' : null;

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

                // Text
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

                const Icon(Icons.more_vert),
              ],
            ),
          );
        },
      ),
    );
  }
}

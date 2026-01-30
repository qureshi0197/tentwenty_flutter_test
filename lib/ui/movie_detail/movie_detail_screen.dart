import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:movie_list/data/models/movie_detail_model.dart';
import 'package:movie_list/data/providers/providers.dart';
import 'package:movie_list/ui/showtime/showtime_screen.dart';
import 'package:movie_list/ui/trailer/trailer_player_screen.dart';
import 'package:movie_list/theme/app_colors.dart';

class MovieDetailScreen extends ConsumerWidget {
  final int movieId;

  const MovieDetailScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.read(movieRepositoryProvider);

    return FutureBuilder<MovieDetailModel>(
      future: repository.getMovieDetail(movieId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final movie = snapshot.data!;
        final imageUrl = movie.backdropPath != null ? 'https://image.tmdb.org/t/p/w780${movie.backdropPath}' : null;

        final formattedDate = movie.releaseDate != null ? DateFormat('MMMM d, y').format(DateTime.parse(movie.releaseDate!)) : '';

        return Scaffold(
          body: Column(
            children: [
              // ================= IMAGE HALF =================
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    imageUrl != null ? Image.network(imageUrl, fit: BoxFit.cover) : Container(color: Colors.grey),

                    // Dark overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black54, Colors.transparent, Colors.black87],
                        ),
                      ),
                    ),

                    // Top-left back + text
                    Positioned(
                      top: 48,
                      left: 16,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'Watch',
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),

                    // Bottom-center content
                    Positioned(
                      bottom: 24,
                      left: 16,
                      right: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            movie.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text('In Theaters $formattedDate', style: const TextStyle(color: Colors.white70, fontSize: 14)),
                          const SizedBox(height: 16),

                          // Get Tickets button
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: 48,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ShowtimeScreen(movieTitle: movie.title, releaseDate: movie.releaseDate ?? ''),
                                  ),
                                );
                              },
                              child: const Text('Get Tickets'),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Watch Trailer button
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: 48,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.white),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () async {
                                final videos = await repository.getMovieTrailers(movieId);
                                if (videos.isNotEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => TrailerPlayerScreen(youtubeKey: videos.first.key)),
                                  );
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [Icon(Icons.play_arrow), SizedBox(width: 5), const Text('Watch Trailer')],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ================= DETAILS HALF =================
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Genres
                      if (movie.genres.isNotEmpty) ...[
                        const Text('Genres', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: movie.genres.asMap().entries.map((entry) {
                            final index = entry.key;
                            final genreName = entry.value.name;
                            final color = AppColors.genreColors[index % AppColors.genreColors.length];

                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
                              child: Text(genreName, style: const TextStyle(color: Colors.white, fontSize: 13)),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                        // Divider
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Divider(color: AppColors.divider, thickness: 1),
                        ),

                        const SizedBox(height: 24),
                      ],

                      // Overview
                      const Text('Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(movie.overview ?? 'No overview available.', style: const TextStyle(fontSize: 14, height: 1.4)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

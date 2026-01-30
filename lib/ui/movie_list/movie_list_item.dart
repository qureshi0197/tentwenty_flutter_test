import 'package:flutter/material.dart';
import 'package:movie_list/data/models/movie_list_model.dart';

class MovieListItem extends StatelessWidget {
  final MovieListModel movie;
  final VoidCallback onTap;

  const MovieListItem({super.key, required this.movie, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final imageUrl = movie.backdropPath != null
        ? 'https://image.tmdb.org/t/p/w780${movie.backdropPath}'
        : movie.posterPath != null
        ? 'https://image.tmdb.org/t/p/w500${movie.posterPath}'
        : null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 180,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              if (imageUrl != null) Image.network(imageUrl, fit: BoxFit.cover) else Container(color: Colors.grey.shade300),

              // Dark gradient for readability
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black54],
                  ),
                ),
              ),

              // Movie title (bottom-left)
              Positioned(
                left: 12,
                bottom: 12,
                right: 12,
                child: Text(
                  movie.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:movie_list/data/models/genre_model.dart';
import 'package:movie_list/data/models/movie_base.dart';

class MovieDetailModel extends MovieBase {
  final List<Genre> genres;
  final int? runtime;
  final String? tagline;
  final int? budget;
  final int? revenue;
  final String? homepage;

  MovieDetailModel({
    required super.id,
    required super.title,
    required super.originalTitle,
    required super.originalLanguage,
    required super.overview,
    required super.posterPath,
    required super.backdropPath,
    required super.releaseDate,
    required super.adult,
    required super.video,
    required super.popularity,
    required super.voteAverage,
    required super.voteCount,
    required this.genres,
    this.runtime,
    this.tagline,
    this.budget,
    this.revenue,
    this.homepage,
  });

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) {
    return MovieDetailModel(
      id: json['id'],
      title: json['title'] ?? '',
      originalTitle: json['original_title'] ?? '',
      originalLanguage: json['original_language'] ?? '',
      overview: json['overview'],
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      releaseDate: json['release_date'],
      adult: json['adult'] ?? false,
      video: json['video'] ?? false,
      popularity: (json['popularity'] ?? 0).toDouble(),
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      runtime: json['runtime'],
      tagline: json['tagline'],
      budget: json['budget'],
      revenue: json['revenue'],
      homepage: json['homepage'],
      genres: (json['genres'] as List<dynamic>? ?? []).map((e) => Genre.fromJson(e)).toList(),
    );
  }
}

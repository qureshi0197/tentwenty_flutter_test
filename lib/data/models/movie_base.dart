abstract class MovieBase {
  final int id;
  final String title;
  final String originalTitle;
  final String originalLanguage;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final String? releaseDate;
  final bool adult;
  final bool video;
  final double popularity;
  final double voteAverage;
  final int voteCount;

  MovieBase({
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.originalLanguage,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.releaseDate,
    required this.adult,
    required this.video,
    required this.popularity,
    required this.voteAverage,
    required this.voteCount,
  });
}

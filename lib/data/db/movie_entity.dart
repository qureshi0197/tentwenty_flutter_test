import 'package:floor/floor.dart';

@Entity(tableName: 'movies')
@Entity(tableName: 'movies')
class MovieEntity {
  @primaryKey
  final int id;
  final String title;
  final String originalTitle;
  final String originalLanguage;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final String? releaseDate;
  final String genreIds; // stored as comma-separated string
  final bool adult;
  final bool video;
  final double popularity;
  final double voteAverage;
  final int voteCount;

  MovieEntity(
    this.id,
    this.title,
    this.originalTitle,
    this.originalLanguage,
    this.overview,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    this.genreIds,
    this.adult,
    this.video,
    this.popularity,
    this.voteAverage,
    this.voteCount,
  );
}

import 'package:movie_list/data/db/movie_entity.dart';
import 'package:movie_list/data/models/movie_list_model.dart';

extension MovieListModelMapper on MovieListModel {
  MovieEntity toEntity() {
    return MovieEntity(
      id,
      title,
      originalTitle,
      originalLanguage,
      overview,
      posterPath,
      backdropPath,
      releaseDate,
      genreIds.join(','),
      adult,
      video,
      popularity,
      voteAverage,
      voteCount,
    );
  }
}

extension MovieEntityMapper on MovieEntity {
  MovieListModel toModel() {
    return MovieListModel(
      id: id,
      title: title,
      originalTitle: originalTitle,
      originalLanguage: originalLanguage,
      overview: overview,
      posterPath: posterPath,
      backdropPath: backdropPath,
      releaseDate: releaseDate,
      genreIds: genreIds.split(',').map(int.parse).toList(),
      adult: adult,
      video: video,
      popularity: popularity,
      voteAverage: voteAverage,
      voteCount: voteCount,
    );
  }
}

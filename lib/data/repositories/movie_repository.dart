import 'package:movie_list/data/models/movie_detail_model.dart';
import 'package:movie_list/data/models/movie_list_model.dart';

import 'package:movie_list/data/api/tmdb_client.dart';
import 'package:movie_list/data/models/video_model.dart';
import 'package:movie_list/data/db/movie_dao.dart';
import 'package:movie_list/data/mappers/movie_mapper.dart';

class MovieRepository {
  final TMDBClient client;
  final MovieDao movieDao;

  MovieRepository(this.client, this.movieDao);

  int _currentPage = 1;
  bool _isFetching = false;

  Stream<List<MovieListModel>> watchUpcomingMovies({required int page}) async* {
    if (_isFetching) return;
    _isFetching = true;

    _currentPage = page;

    final cached = await movieDao.getAllMovies();
    if (cached.isNotEmpty) {
      yield cached.map((e) => e.toListModel()).toList();
    }

    final response = await client.dio.get('/discover/movie?page=$_currentPage');
    final List results = response.data['results'];

    final movies = results.map((e) => MovieListModel.fromJson(e)).toList();

    await movieDao.insertMovies(movies.map((e) => e.toEntity()).toList());

    final updatedCache = await movieDao.getAllMovies();
    yield updatedCache.map((e) => e.toListModel()).toList();

    _isFetching = false;
  }

  Future<MovieDetailModel> getMovieDetail(int movieId) async {
    final response = await client.dio.get('/movie/$movieId');
    return MovieDetailModel.fromJson(response.data);
  }

  Future<List<VideoModel>> getMovieTrailers(int movieId) async {
    final response = await client.dio.get('/movie/$movieId/videos');
    final List results = response.data['results'];
    return results.map((e) => VideoModel.fromJson(e)).where((v) => v.site == 'YouTube' && v.type == 'Trailer').toList();
  }

  Future<List<MovieListModel>> searchMovies(String query) async {
    if (query.isEmpty) return [];

    final response = await client.dio.get('/search/movie', queryParameters: {'query': query});

    final List results = response.data['results'];
    return results.map((e) => MovieListModel.fromJson(e)).toList();
  }

}

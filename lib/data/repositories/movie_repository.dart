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

  Stream<List<MovieListModel>> watchUpcomingMovies({required int page}) async* {
    // Always emit cached data first
    final cached = await movieDao.getAllMovies();
    if (cached.isNotEmpty) {
      yield cached.map((e) => e.toModel()).toList();
    }

    try {
      // Try network
      final response = await client.dio.get('/discover/movie', queryParameters: {'page': page});

      final List results = response.data['results'];
      final movies = results.map((e) => MovieListModel.fromJson(e)).toList();

      // Only replace cache AFTER success
      await movieDao.replaceMovies(movies.map((e) => e.toEntity()).toList());

      yield movies;
    } catch (_) {
      // Network failed → do NOTHING
      // Cached data already emitted
    }
  }

  Future<MovieDetailModel> getMovieDetail(int movieId) async {
    try {
      final response = await client.dio.get('/movie/$movieId');
      return MovieDetailModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load movie details');
    }
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

  Future<List<MovieListModel>> getUpcomingMovies({required int page}) async {
    final response = await client.dio.get('/discover/movie', queryParameters: {'page': page});

    final List results = response.data['results'];
    return results.map((e) => MovieListModel.fromJson(e)).toList();
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_list/data/models/movie_list_model.dart';
import 'package:movie_list/data/notifiers/movie_list_notifier.dart';
import '../api/tmdb_client.dart';
import '../repositories/movie_repository.dart';
import '../db/app_database.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError();
});

final tmdbClientProvider = Provider<TMDBClient>((ref) {
  return TMDBClient();
});

final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  final client = ref.read(tmdbClientProvider);
  final db = ref.read(databaseProvider);
  return MovieRepository(client, db.movieDao);
});

final upcomingMoviesProvider = StreamProvider.autoDispose.family<List<MovieListModel>, int>((ref, page) {
  return ref.read(movieRepositoryProvider).watchUpcomingMovies(page: page);
});

final movieSearchQueryProvider = StateProvider<String>((ref) => '');

final movieSearchResultsProvider = FutureProvider.autoDispose<List<MovieListModel>>((ref) async {
  final query = ref.watch(movieSearchQueryProvider);

  if (query.trim().isEmpty) return [];
  
  await Future.delayed(const Duration(milliseconds: 350));

  if (query.isEmpty) return [];

  return ref.read(movieRepositoryProvider).searchMovies(query);
});

final movieListProvider = StateNotifierProvider<MovieListNotifier, AsyncValue<List<MovieListModel>>>((ref) => MovieListNotifier(ref));


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_list/data/models/movie_list_model.dart';
import 'package:movie_list/data/providers/providers.dart';

class MovieListNotifier extends StateNotifier<AsyncValue<List<MovieListModel>>> {
  MovieListNotifier(this.ref) : super(const AsyncValue.loading()) {
    loadInitial();
  }

  final Ref ref; // 👈 NOT Reader

  int _page = 1;
  bool _isLoading = false;

  Future<void> loadInitial() async {
    _page = 1;
    await _load();
  }

  Future<void> loadMore() async {
    if (_isLoading) return;
    _page++;
    await _load();
  }

  Future<void> _load() async {
    _isLoading = true;

    try {
      final movies = await ref.read(movieRepositoryProvider).getUpcomingMovies(page: _page);

      final current = state.value ?? [];
      state = AsyncValue.data([...current, ...movies]);
    } catch (e, st) {
      if (state.hasValue) {
        // keep already loaded data
        state = AsyncValue.data(state.value!);
      } else {
        state = AsyncValue.error(e, st);
      }
    } finally {
      _isLoading = false;
    }
  }
}

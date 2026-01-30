import 'package:flutter/material.dart';
import 'package:movie_list/data/models/movie_list_model.dart';
import 'package:movie_list/ui/search/search_results_screen.dart';
import '../movie_list/movie_list_screen.dart';
import '../search/search_screen.dart';
enum WatchPage { list, search, results }

class WatchStack extends StatefulWidget {
  const WatchStack({super.key});

  @override
  WatchStackState createState() => WatchStackState();
}

class WatchStackState extends State<WatchStack> {
  WatchPage _page = WatchPage.list;
  List<MovieListModel> _searchResults = [];

  void resetToMovieList() {
    setState(() => _page = WatchPage.list);
  }

  void openSearch() {
    setState(() => _page = WatchPage.search);
  }

  void openResults(List<MovieListModel> results) {
    setState(() {
      _searchResults = results;
      _page = WatchPage.results;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_page) {
      case WatchPage.search:
        return SearchScreen(
          onBack: resetToMovieList,
          onDone: openResults,
        );

      case WatchPage.results:
        return SearchResultsScreen(results: _searchResults, onBack: () => setState(() => _page = WatchPage.search));

      case WatchPage.list:
      return MovieListScreen(onSearchTap: openSearch);
    }
  }
}

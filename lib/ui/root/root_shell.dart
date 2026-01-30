import 'package:flutter/material.dart';
import 'package:movie_list/ui/watch/watch_stack.dart';

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _currentIndex = 1; // Watch is default
  final GlobalKey<WatchStackState> _watchKey = GlobalKey<WatchStackState>();

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _EmptyScreen(title: 'Dashboard'),
          WatchStack(key: _watchKey), // Watch
          _EmptyScreen(title: 'Media Library'),
          _EmptyScreen(title: 'More'),
        ],
      ),
      bottomNavigationBar: isKeyboardOpen
          ? null
          : BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                if (index == 1) {
                  _watchKey.currentState?.resetToMovieList();
                }

                setState(() {
                  _currentIndex = index;
                });
              },
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
                BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Watch'),
                BottomNavigationBarItem(icon: Icon(Icons.video_library), label: 'Media Library'),
                BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'More'),
              ],
            ),
    );
  }
}

class _EmptyScreen extends StatelessWidget {
  final String title;

  const _EmptyScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(title, style: const TextStyle(fontSize: 18)));
  }
}

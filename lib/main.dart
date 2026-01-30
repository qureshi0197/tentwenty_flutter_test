import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_list/theme/app_colors.dart';
import 'package:movie_list/ui/root/root_shell.dart';
import 'data/db/app_database.dart';
import 'data/providers/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = await $FloorAppDatabase.databaseBuilder('movies.db').build();

  runApp(ProviderScope(overrides: [databaseProvider.overrideWithValue(database)], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie List',
      theme: ThemeData(fontFamily: 'Poppins', scaffoldBackgroundColor: AppColors.background, primaryColor: AppColors.primary),
      home: const RootShell(),
    );
  }
}

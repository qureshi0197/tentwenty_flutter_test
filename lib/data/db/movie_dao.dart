import 'package:floor/floor.dart';
import 'movie_entity.dart';

@dao
abstract class MovieDao {
  @Query('SELECT * FROM movies')
  Future<List<MovieEntity>> getAllMovies();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertMovies(List<MovieEntity> movies);

  @Query('DELETE FROM movies')
  Future<void> clearMovies();
}

import 'package:cinemapedia/domain/entities/movie.dart';

abstract class LocalStorageRepository{
  Future<void> toggleFavorite(Movie movie);
  Future<bool> isMovieFavorite(int movieId);
  Future<List<Movie>> loadMovies({int lmit = 15 , offset =0});

}
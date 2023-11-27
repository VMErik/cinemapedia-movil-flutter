import 'package:cinemapedia/domain/entities/movie.dart';

// El repositorio se encarga de llamar al Datasource
abstract class MovieRepository{
  Future<List<Movie>>getNowPlaying({int page = 1});

  Future<List<Movie>>getPopular({int page = 1});

  Future<List<Movie>>getUpcoming({int page = 1});

  Future<List<Movie>>getTopReated({int page = 1});

  Future<Movie>getMovieById(String id);
  
  Future<List<Movie>>searchMovies(String query); 

}
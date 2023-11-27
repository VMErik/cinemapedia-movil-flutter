// Aqui definiremos como queremos que sean nuestros origenes de datos
// Definiremos los metodos que existiran para traer data

import 'package:cinemapedia/domain/entities/movie.dart';

abstract class MovieDataSource{

  Future<List<Movie>>getNowPlaying({int page = 1});

  Future<List<Movie>>getPopular({int page = 1});

  Future<List<Movie>>getUpcoming({int page = 1});

  Future<List<Movie>>getTopReated({int page = 1});

  Future<Movie>getMovieById(String id);

  Future<List<Movie>>searchMovies(String query);  
}
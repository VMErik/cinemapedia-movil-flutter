// Aqui definiremos como queremos que sean nuestros origenes de datos
// Definiremos los metodos que existiran para traer data

import 'package:cinemapedia/domain/entities/movie.dart';

abstract class MovieDataSource{

  Future<List<Movie>>getNowPlaying({int page = 1});


}
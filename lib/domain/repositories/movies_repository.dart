import 'package:cinemapedia/domain/entities/movie.dart';

// El repositorio se encarga de llamar al Datasource
abstract class MovieRepository{
  Future<List<Movie>>getNowPlaying({int page = 1});
}
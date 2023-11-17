import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/movies_repository.dart';

class MovieRepositoryImpl extends MovieRepository{
  
  // Mandaremos a llamar a nuestro datasource
  final MovieDataSource datasource;

  MovieRepositoryImpl(this.datasource);

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) {
    
    return datasource.getNowPlaying(page: page); // Mandamos allamar a nuestro repositorio y pasamos la pagina
  }

}
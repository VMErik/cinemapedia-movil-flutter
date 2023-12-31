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

  @override
  Future<List<Movie>> getPopular({int page = 1}) {
    
    return datasource.getPopular(page: page); // Mandamos allamar a nuestro repositorio y pasamos la pagina
  }
  
  @override
  Future<List<Movie>> getTopReated({int page = 1}) {
     return datasource.getTopReated(page: page); // Mandamos allamar a nuestro repositorio y pasamos la pagina
  }
  
  @override
  Future<List<Movie>> getUpcoming({int page = 1}) {
    return datasource.getUpcoming(page: page); // Mandamos allamar a nuestro repositorio y pasamos la pagina
  }
  
  @override
  Future<Movie> getMovieById(String id) {
    return datasource.getMovieById(id); // Mandamos allallamar a nuestro repositorio y pasamos el id
  }
  
  @override
  Future<List<Movie>> searchMovies(String query) {
    return datasource.searchMovies(query); // Mandamos all
  }


}
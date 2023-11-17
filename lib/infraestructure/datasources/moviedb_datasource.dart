// Sera el encargado de las interacciones con moviedb exclusivamente


import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infraestructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infraestructure/models/moviedb/moviedb_response.dart';
import 'package:dio/dio.dart';

class MovieDBDataSource extends MovieDataSource{

    final dio  = Dio(
      BaseOptions(
        baseUrl:  'https://api.themoviedb.org/3/' ,  // Todas laspeticiones iran a esta URl
        queryParameters: { 
          'api_key' : Environment.movieDBKey,
          'language' : 'es-MX'
        }
      )
    );

  // Implementamos los metodos de nuestro doman, datasource
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async  {
    
    final response = await dio.get('/movie/now_playing'); // Hacemos nuestro get
    final movieDBResponse = MovieDbResponse.fromJson(response.data);
    // Con un maper, maepamos nuestra respuesta a nuestras entidades
    final List<Movie> movies = movieDBResponse.results
    .where((movie) => movie.posterPath != 'no-poster') // Aplicamos un filtro, para que traiga puros no poster
    .map(
      (e) => MovieMapper.movieDBtoEntity(e) ).toList(); // Mapeamos a nuestras entidades

    return movies;
  }

}
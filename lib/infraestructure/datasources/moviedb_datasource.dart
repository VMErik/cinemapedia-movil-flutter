// Sera el encargado de las interacciones con moviedb exclusivamente


import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infraestructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infraestructure/models/moviedb/movie_details.dart';
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

  // Metodo que convertira nuestro json en una lista de peliculas
  List<Movie> _jsonToMovies(Map<String,dynamic> json){
  final movieDBResponse = MovieDbResponse.fromJson(json);
      // Con un maper, maepamos nuestra respuesta a nuestras entidades
      final List<Movie> movies = movieDBResponse.results
      .where((movie) => movie.posterPath != 'no-poster') // Aplicamos un filtro, para que traiga puros no poster
      .map(
        (e) => MovieMapper.movieDBtoEntity(e) ).toList(); // Mapeamos a nuestras entidades

    return movies;
  }


  // Implementamos los metodos de nuestro doman, datasource
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async  {
    
    final response = await dio.get('/movie/now_playing'  , 
      queryParameters : { 
        'page' : page,
      }
    ); // Hacemos nuestro get
    return _jsonToMovies(response.data); // llamamos a nuestro Cconvertidor de json a lista de entidades
  }
  
  @override
  Future<List<Movie>> getPopular({int page = 1}) async  {
    final response = await dio.get('/movie/popular'  , 
      queryParameters : { 
        'page' : page,
      }
    ); // Hacemos nuestro get
    return _jsonToMovies(response.data);  // llamamos a nuestro Cconvertidor de json a lista de entidades
    
  }
  
  @override
  Future<List<Movie>> getTopReated({int page = 1}) async{
    final response = await dio.get('/movie/top_rated'  , 
      queryParameters : { 
        'page' : page,
      }
    ); // Hacemos nuestro get
    return _jsonToMovies(response.data);  // llamamos a nuestro Cconvertidor de json a lista de entidades
  }
  
  @override
  Future<List<Movie>> getUpcoming({int page = 1})  async{
    final response = await dio.get('/movie/upcoming'  , 
      queryParameters : { 
        'page' : page,
      }
    ); // Hacemos nuestro get
    return _jsonToMovies(response.data);  // llamamos a nuestro Cconvertidor de json a lista de entidades
  }
  
  @override
  Future<Movie> getMovieById(String id) async {
    final response = await dio.get('/movie/$id'); // Hacemos nuestro get
    if(response.statusCode != 200) throw Exception('Movie with id $id not found');

    // Sacamos nuestro movie detail
    final movieDB = MovieDetails.fromJson(response.data);
    // Lo convertimos a Movie
    final movie = MovieMapper.movieDetailsToEntity(movieDB);
    return movie;
  }
  
  @override
  Future<List<Movie>> searchMovies(String query) async {


    if(query.isEmpty) return [];

    final response = await dio.get('/search/movie'  , 
      queryParameters : { 
        'query' : query,
      }
    ); // Hacemos nuestro get
    return _jsonToMovies(response.data);  // llamamos a nuestro Cconvertidor de json a lista de entidades
  }

}
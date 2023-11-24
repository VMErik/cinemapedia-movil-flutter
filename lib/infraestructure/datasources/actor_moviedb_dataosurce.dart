import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infraestructure/mappers/actor_mapper.dart';
import 'package:cinemapedia/infraestructure/models/moviedb/credits_response.dart';
import 'package:dio/dio.dart';

class ActorMovieDatasource extends ActorsDataSource{

  final dio  = Dio(
    BaseOptions(
      baseUrl:  'https://api.themoviedb.org/3/' ,  // Todas laspeticiones iran a esta URl
      queryParameters: { 
        'api_key' : Environment.movieDBKey,
        'language' : 'es-MX'
      }
    )
  );

    // Metodo que convertira nuestro json en una lista de actores
  List<Actor> _jsonToActors(Map<String,dynamic> json){
  final movieDBResponse = CreditsResponse.fromJson(json);
      // Con un maper, maepamos nuestra respuesta a nuestras entidades
      final List<Actor> movies = movieDBResponse.cast
      .where((actor) => actor.profilePath != 'no-image') // Aplicamos un filtro, para que traiga puros diferentes a no poster
      .map(
        (e) => ActorMapper.astToEntity(e) ).toList(); // Mapeamos a nuestras entidades

    return movies;
  }
  
  @override
  Future<List<Actor>> getActorsByMovie(String movieId) async{
     final response = await dio.get('/movie/$movieId/credits'); // Hacemos nuestro get
    return _jsonToActors(response.data);  // llamamos a nuestro Cconvertidor de json a lista de entidades
  }

}
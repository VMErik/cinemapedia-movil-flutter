

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



// Creamos el provider
final movieInfoProvider = StateNotifierProvider<MovieMapNotifier , Map<String, Movie>>((ref) {
  final movieRepository = ref.watch( movieRepositoryProvider ); // Extraemos la referencia a la funcion
  return MovieMapNotifier( getMovie: movieRepository.getMovieById ); // Pasamos la referencia a la funcion 
});



/* Esta es laestructura que tendria en cache
{
  '1' : Movie(),
  '2' : Movie(),
  '3' : Movie(),
  '4' : Movie(),
  '5' : Movie(),
}
*/


// Esta es la funcion que ejecutaremos
typedef GetMoveCallBack = Future<Movie> Function (String movieId);


// Por esta clase va a fluir la estructura que queremos que sealmacenen en cache
class MovieMapNotifier extends StateNotifier<Map<String, Movie>> {


  final GetMoveCallBack getMovie;

  // Constructor
  MovieMapNotifier({required this.getMovie}) :super({});

  Future<void> loadMovie(String movieId) async{
    // Buscaremos la pelicula
    if(state[movieId] != null) return;

    print('Realizando peticion HTTP');
    // Si no la tenemos, la pedimos
    final movie = await getMovie(movieId);

    // Notificamos el cambio del estado
    state  = {...state , movieId : movie};
  }
}
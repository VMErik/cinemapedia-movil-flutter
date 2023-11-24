

import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/presentation/providers/actors/actors_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



// Creamos el provider
final actorsByMovieProvider = StateNotifierProvider<ActorsByMovieNotifier , Map<String, List<Actor>>>((ref) {
  final actorsRepository = ref.watch( actorsRepositoryProvider ); // Extraemos la referencia a la funcion
  return ActorsByMovieNotifier( getActors: actorsRepository.getActorsByMovie ); // Pasamos la referencia a la funcion 
});



/* Esta es laestructura que tendria en cache
{
  '1' : <Actor>[],
  '2' : <Actor>[],
  '3' : <Actor>[],
  '4' : <Actor>[],
  '5' : <Actor>[],
}
*/


// Esta es la funcion que ejecutaremos
typedef GetActorsCallBack = Future<List<Actor>> Function (String movieId);


// Por esta clase va a fluir la estructura que queremos que sealmacenen en cache
class ActorsByMovieNotifier extends StateNotifier<Map<String, List<Actor>>> {


  final GetActorsCallBack getActors;

  // Constructor
  ActorsByMovieNotifier({required this.getActors}) :super({});

  Future<void> loadActors(String movieId) async{
    // Buscaremos la pelicula
    if(state[movieId] != null) return;

    print('Realizando peticion HTTP Actores');
    // Si no la tenemos, la pedimos
     
    final List<Actor> actors = await getActors(movieId);

    // Notificamos el cambio del estado
    state  = {...state , movieId : actors};
  }
}
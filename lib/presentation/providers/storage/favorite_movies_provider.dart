import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Manjeador de las peliculas favoritas
final favoriteMoviesProvider = StateNotifierProvider<StorageMoviesNotifier , Map<int, Movie> >((ref){
  final localStorageRepository  = ref.watch(localStorageRepositoryProvider);
  // Le mandamos a neustra clase que cntrolara los favorits, nuestro dataSource
  return StorageMoviesNotifier(localStorageRepository: localStorageRepository);
});


// La informacion lucira asi
// {
//   1234: Movie , 
//   2234: Movie
// }
class StorageMoviesNotifier extends StateNotifier<Map<int, Movie>> {

  int page = 0 ;
  final LocalStorageRepository localStorageRepository;
  
  StorageMoviesNotifier({required this.localStorageRepository}) : super({});


  Future<List<Movie>> loadNextPage() async{
    final movies = await localStorageRepository.loadMovies(offset: page * 10, lmit: 20);
    page ++;
    final tempMoviesMap = <int, Movie>{};
    for (final movie in movies) {
      tempMoviesMap[movie.id] = movie;
    }

    // Actualizamos nuestro estado
    // A nuestro estado le bajamos todo lo que esta, y le agregamos las nuevas movies
    state = {...state , ...tempMoviesMap};
    return movies;
  }


  Future<void> toggleFavorite(Movie movie) async{
    await localStorageRepository.toggleFavorite(movie);
    // Si existe en la lista
    final bool isMovieInFavorites = state[movie.id] != null;
    if(isMovieInFavorites){
      state.remove(movie.id);
      // Actualizamos el estado
      state = {...state};
    }else{
      state = {...state , movie.id : movie};
    }
  }

}
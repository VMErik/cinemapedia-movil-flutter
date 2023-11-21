import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


// Consultaremos este provider para consultar las peliculas en el cine
// La clase que lo controla es MoviesNotifier, y la data que fluye en el es una List<Movie>
final nowPlayingMoviesProvider = StateNotifierProvider<MoviesNotifier , List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch( movieRepositoryProvider ).getNowPlaying; // Extraemos la referencia a la funcion
  
  return MoviesNotifier( fetchMoreMovies: fetchMoreMovies );
});


// Este es para controlar el estado de las populares
final popularMoviesProvider = StateNotifierProvider<MoviesNotifier , List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch( movieRepositoryProvider ).getPopular; // Extraemos la referencia a la funcion
  
  return MoviesNotifier( fetchMoreMovies: fetchMoreMovies );
});


// Este es para controlar el estado de las upcoming
final upcomingMoviesProvider = StateNotifierProvider<MoviesNotifier , List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch( movieRepositoryProvider ).getUpcoming; // Extraemos la referencia a la funcion
  
  return MoviesNotifier( fetchMoreMovies: fetchMoreMovies );
});


// Este es para controlar el estado de las top rated
final topRatedMoviesProvider = StateNotifierProvider<MoviesNotifier , List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch( movieRepositoryProvider ).getTopReated; // Extraemos la referencia a la funcion
  
  return MoviesNotifier( fetchMoreMovies: fetchMoreMovies );
});





typedef MovieCallback = Future<List<Movie>> Function ({ int page });


class MoviesNotifier extends StateNotifier<List<Movie>> {
  
  // Con este sabremos la pagina actual
  int currentPage = 0;
  MovieCallback fetchMoreMovies;
  bool isLoading = false;

  // Inicializamos en vacio
  MoviesNotifier({required this.fetchMoreMovies}): super([]);

  Future<void> loadNextPage() async{

    if (isLoading) return; // Si ya esta haciendo una llamada, hacermos que salga

    currentPage ++;
    isLoading = true;
    // Haremos una modificacion al State
    final List<Movie> movies = await fetchMoreMovies(page: currentPage);
    // COn esto cambiamos el estado
    state = [...state , ...movies]; // Riverpod se encarga de notificar el cambio de estado
    await Future.delayed(const Duration(milliseconds: 300)); // Damos tiempo para el renderizado
    isLoading = false;
  }

}
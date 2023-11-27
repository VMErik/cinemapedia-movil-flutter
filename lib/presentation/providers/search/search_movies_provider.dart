
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchQueryProvider = StateProvider<String> ( (ref) => '' ); // Declaramos gestor de estado de string

final searchMoviesProvider = StateNotifierProvider<SearchedMoviesNotifier , List<Movie>> ( (ref){

  final movieRepository =ref.read(movieRepositoryProvider);

  return SearchedMoviesNotifier(
    searchMovies: movieRepository.searchMovies,
    ref: ref
  );
});


typedef SearchMoviesCallBack = Future<List<Movie>> Function(String query);

class SearchedMoviesNotifier extends StateNotifier<List<Movie>>{


  final SearchMoviesCallBack searchMovies;
  final Ref ref;

  SearchedMoviesNotifier({
    required this.searchMovies, required this.ref
  }) : super([]);

  Future<List<Movie>> searchMoviesByQuery(String query) async{

    // Actualizamos el estado del query
    ref.read(searchQueryProvider.notifier).update((state) => query);

    final List<Movie> movies = await searchMovies(query);
    state = movies;
    return movies;
  }
}
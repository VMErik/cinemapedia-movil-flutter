
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Este provider se encargara de escuchar las 6 peliculas solamente que mostraremos en el slideshow
final moviesSlideshowProvider = Provider<List<Movie>>((ref){
    // Buscamos nuestras peliculas que se estan reproduciendo
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider); // Esuchamos cambios en nuestro estado
    if(nowPlayingMovies.isEmpty){
      return [];
    }
    return nowPlayingMovies.sublist(0,6);
  
});
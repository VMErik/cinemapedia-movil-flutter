import 'dart:ffi';

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/delegates/search_movie_delegate.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context , ref) {

    final colors = Theme.of(context).colorScheme;
    final  titleStyle =Theme.of(context).textTheme.titleMedium;

    // Incluimos el safe area para no dejarl tan pegado arriba
    return SafeArea(
      child: Padding(
        
        padding: const EdgeInsets.symmetric(horizontal: 10), 
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Icon(Icons.movie_outlined , color: colors.primary,) , 
              const SizedBox(width: 5,) , 
              Text('Cinemapedia' , style: titleStyle,),
              const Spacer(), // Este widget, rellena todo el espaci disponible
              IconButton(
                onPressed: ()  {

                  final searchedMovies = ref.read(searchMoviesProvider);
                  final searchQuery = ref.read(searchQueryProvider);
                  // Funcion para realizar busquedas de Flutter
                  // Hacemos referencia a nuestro delegate en delegates dentro de presentation
                  showSearch<Movie?>(
                    query: searchQuery,
                    context: context, 
                    delegate: SearchMovieDelegate(
                      initialMovies: searchedMovies,
                      // Mandamos solo la referencia
                      searchMovies: ref.read( searchMoviesProvider.notifier).searchMoviesByQuery
                  )).then(
                    (movie) {
                      if(movie == null) return;
                        context.push('/movie/${ movie.id }');
                    }
                  );

                
                }, 
                icon: const Icon(Icons.search)
              )
            ],
          ),
        ),
      ),
    );
  }
}
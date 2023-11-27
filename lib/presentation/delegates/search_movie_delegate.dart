import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';



typedef SearchMoviesCallBack = Future<List<Movie>> Function(String query);


class SearchMovieDelegate extends SearchDelegate<Movie?> {


  final SearchMoviesCallBack searchMovies;
  List<Movie> initialMovies;
  // Multiples wigets podran escuchar este stream controller gracias al broadcast
  StreamController<List<Movie>> debouncedMovies = StreamController.broadcast(); 
  StreamController<bool> isLoadingStream = StreamController.broadcast(); 

  Timer? _debounceTimer; // Definiremos un timer

  SearchMovieDelegate({ required this.searchMovies, required this.initialMovies});

  void clearStreams(){
    debouncedMovies.close();
  }


  void _onQueryChanged(String query){
      isLoadingStream.add(true);

    if(_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration( milliseconds: 500) ,  () async {
      // if(query.isEmpty){
      //   debouncedMovies.add([]); // Agrgamos una lista de peluiculas vacio
      //   return;
      // }
      final movies = await searchMovies(query);
      debouncedMovies.add(movies);
      initialMovies = movies;
      isLoadingStream.add(false);

      return;
    });
  }

  Widget buildResultsAndSugesttions(){
    return StreamBuilder(
        initialData: initialMovies,
        stream: debouncedMovies.stream,
        builder:(context, snapshot){

          final movies = snapshot.data ?? [];
          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) => _MovieItem(
              movie: movies[index],onMovieSelected: (context , movie){
                clearStreams();
                close(context, movie);
              }, // Mandamos comoparametro la funcion de close de nuestro delegate
            )
          );
        },
      );
  }


  // Este es el texto que aparecera en la parte de la busqueda
  @override
  String get searchFieldLabel => 'Buscar pelicula';

  // Constructor de acciones
  @override
  List<Widget>? buildActions(BuildContext context) {
    // Mostraremos solo el icono para poder borrar la busqueda cuando escribamos
    return [

          StreamBuilder(
            stream: isLoadingStream.stream,
            initialData: false,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if(snapshot.data ?? false){
                  return SpinPerfect(
                            duration : const Duration(seconds: 10),
                            infinite: true,
                            spins: 10,
                            child: IconButton(onPressed:(){
                              query = '';
                            }, icon: const Icon(Icons.refresh)),
                          );
              }

               return FadeIn(
                  animate: query.isNotEmpty,
                  duration:  const Duration(milliseconds: 400),
                  child: IconButton(onPressed:(){
                    query = '';
                  }, icon: const Icon(Icons.clear)),
                );
            },
          ),

        
         
    ];
  }

  // Costructor de icono
  @override
  Widget? buildLeading(BuildContext context) {
    
        return IconButton(onPressed: (){
          clearStreams();
          return close(context, null);
        }, icon: const Icon(Icons.arrow_back_ios_new_rounded));
  }

  // Esto es los resultados que queremos mostrar
  @override
  Widget buildResults(BuildContext context) {
    return buildResultsAndSugesttions();
  }


  // Esto es que queremos hacer cuando la persona este escribiendo
  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query);
    return buildResultsAndSugesttions();
  }

}


class _MovieItem extends StatelessWidget {
  
  final Movie movie;
  final Function onMovieSelected; //m Funcion que mandaremos a llamar

  const _MovieItem({ required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {

    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: (){
        onMovieSelected(context, movie);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10 , vertical: 5),
        child : Row(
          children: [
            SizedBox(
              width: size.width * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(movie.posterPath)
                )
              ),
            const SizedBox(width: 10,),
            SizedBox(
              width: size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title , style: textStyles.titleMedium,),
                  (movie.overview.length > 100)
                    ? Text( '${movie.overview.substring(0,100)}...')
                    : Text( movie.overview)
                    ,
                  Row(
                    children: [
                      Icon(Icons.star_half_rounded, color: Colors.yellow.shade800),
                      const SizedBox(width: 5,),
                      Text(
                        HumanFormats.number(movie.voteAverage , 1) , 
                        style: textStyles.bodyMedium!.copyWith(color: Colors.yellow.shade900),
                        )
                    ],
                  )
                ],
              ),
            )
          ]),
      ),
    );
  }
}
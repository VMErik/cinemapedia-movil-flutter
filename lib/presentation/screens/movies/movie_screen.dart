import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/movie.dart';

class MovieScreen extends ConsumerStatefulWidget {
  static const name = 'movie-screen';
  // Utilizaremos un id como parametro, para podercargar la pelicula
  final String movieId;

  const MovieScreen({super.key, required this.movieId});

  @override
  ConsumerState<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();

    // Haremos la peticion http
    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    // Traemos actores
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId);

  }

  @override
  Widget build(BuildContext context) {
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];

    if (movie == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
          physics:
              const ClampingScrollPhysics(), // Quitamos el efecto de rebote
          slivers: [
            // Este es el de la portada con el nombre
            _CustomSliverWidget(
              movie: movie,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: 1, // Solo para que cree bloque
                (context, index) => _MovieDetails(movie: movie,)
              ),
            
            )
          ]),
    );
  }
}

class _MovieDetails extends StatelessWidget {
  final Movie movie;
  const _MovieDetails({ required this.movie});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final textStyles = Theme.of(context).textTheme;


    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8) ,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  movie.posterPath , 
                  width: size.width *0.3,
                ),
              ),
              const SizedBox(width: 10,),
              SizedBox( 
                width: (size.width - 50) * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(movie.title , style: textStyles.titleLarge, textAlign: TextAlign.start,),
                    Text(movie.overview, )

                  ],
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8) ,
          child: Wrap(
            children: [
              ...movie.genreIds.map((gender) => Container(
                margin: const EdgeInsets.only(right: 10),
                child: Chip(
                  label: Text(gender),
                  shape:  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                ),
              ))
            ],
          ),
        ),

        //Mostrar los actores
        _ActorsByMovie(movieId: movie.id.toString(),),

        const SizedBox(height: 50,) ,

      ],
    );
  }
}

class _ActorsByMovie extends ConsumerWidget {
  final String movieId;
  const _ActorsByMovie({ required this.movieId});

  @override
  Widget build(BuildContext context , ref) {


    final actorByMovie = ref.watch(actorsByMovieProvider);
    if(actorByMovie[movieId] == null){
      return const CircularProgressIndicator(strokeWidth: 2,);
    }

    final actors =actorByMovie[movieId]!;

    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        itemBuilder: (context, index){
          final actor = actors[index];
          return Container(
            padding: const EdgeInsets.all(8.0),
            width: 135,
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children : [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(actor.profilePath , width: 135, height: 180, fit: BoxFit.cover,),
                ) , 
                const SizedBox(
                  height: 5 ,
                ) , 
                Text(actor.name , maxLines: 2,) , 
                Text(actor.character ?? '' , maxLines: 2, style: TextStyle(fontWeight: FontWeight.bold , overflow: TextOverflow.ellipsis),) , 
                

              ]

            )
          );
        }
      ),
    );
  }
}


final isFavoriteProvider = FutureProvider.family.autoDispose((ref, int movieId){
  // Retornaremos para saber si esta en la base de datos o no
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
  return localStorageRepository.isMovieFavorite(movieId); // Esta accion retornara un booleano
});



class _CustomSliverWidget extends ConsumerWidget {
  final Movie movie;

  const _CustomSliverWidget({required this.movie});

  @override
  Widget build(BuildContext context , WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    // Va a estar escuchando con esta movie id
    final isFavoriteFuture = ref.watch(isFavoriteProvider(movie.id)); 
    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.6,
      foregroundColor: Colors.white,
      actions : [
        IconButton(
          onPressed: () async {
            // Hacemos la accion en Base de datos local
            // ref.read(localStorageRepositoryProvider).toggleFavorite(movie);
            await ref.read(favoriteMoviesProvider.notifier).toggleFavorite(movie);
            // Invalida el estado del provider, y lo regresa al estado inicial
            ref.invalidate(isFavoriteProvider(movie.id));
          },
          icon: isFavoriteFuture.when(          
            loading: ()=> const CircularProgressIndicator(strokeWidth: 2,),
            data: (isFavorite) => isFavorite
            ? const Icon(Icons.favorite_rounded , color: Colors.red) 
            : const Icon(Icons.favorite_border) , 
            error: (_ , __)=> throw UnimplementedError()
          ),
        )
      ] , 
      // title: Text(movie.title),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        // title: Text(
        //   movie.title,
        //   style: const TextStyle(fontSize: 20),
        //   textAlign: TextAlign.start,
        // ),
          // Usaremos el stack para poner cosas arriba de otra
        background: Stack(children: [
          SizedBox.expand(
            child: Image.network(
              movie.posterPath , 
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress){
                if(loadingProgress != null) return SizedBox();
                return FadeIn(child: child);
              },
              ),
          ),

          // Este es el gradiente para el corazon de favoritos
          const _CustomGradient(
            alignmentStart: Alignment.topRight,
             alignmentEnd: Alignment.topLeft, 
             start: 0.0, 
             end: 0.2, 
             colorStart: Colors.black54, 
             colorEnd: Colors.transparent) ,
          // Este es el gradiente para el nombre de la pelicula
          const _CustomGradient(
            alignmentStart: Alignment.topCenter,
             alignmentEnd: Alignment.bottomCenter, 
             start: 0.5, 
             end: 1.0, 
             colorStart: Colors.transparent, 
             colorEnd: Colors.black87) , 
          // Este es el gradiente para la flecha, para que no se pierda
          const _CustomGradient(
            alignmentStart: Alignment.bottomCenter,
             alignmentEnd: Alignment.topCenter, 
             start: 0.7, 
             end: 1.0, 
             colorStart: Colors.transparent, 
             colorEnd: Colors.black87) , 
        ]),
      ),
    );
  }
}


class _CustomGradient extends StatelessWidget {
  final Alignment alignmentStart;
  final Alignment alignmentEnd;
  final double start;
  final double end;
  final Color colorStart;
  final Color colorEnd;

  const _CustomGradient({ required this.alignmentStart, required this.alignmentEnd, required this.start, required this.end, required this.colorStart, required this.colorEnd});


  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
            child: DecoratedBox(decoration: BoxDecoration(
              // Creamos un gradiente
              gradient: LinearGradient(
                // Le decimos que comience de arriba a abajo
                begin: alignmentStart,
                end: alignmentEnd,
                // Le indicamos que empiece desde la mitad de lapantalla hasta el final
                stops: [start,end],
                colors: [
                  // Establecemos que vaya desde estos colores
                colorStart, 
                colorEnd
              ])
            )),
          );
  }
}
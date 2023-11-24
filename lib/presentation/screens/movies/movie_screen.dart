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




class _CustomSliverWidget extends StatelessWidget {
  final Movie movie;

  const _CustomSliverWidget({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.6,
      foregroundColor: Colors.white,
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
          // Este es el gradiente para el nombre de la pelicula
          const SizedBox.expand(
            child: DecoratedBox(decoration: BoxDecoration(
              // Creamos un gradiente
              gradient: LinearGradient(
                // Le decimos que comience de arriba a abajo
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                // Le indicamos que empiece desde la mitad de lapantalla hasta el final
                stops: [0.5,1.0],
                colors: [
                  // Establecemos que vaya desde estos colores
                Colors.transparent, 
                Colors.black87
              ])
            )),
          ),
          // Este es el gradiente para la flecha, para que no se pierda
          const SizedBox.expand(
            child: DecoratedBox(decoration: BoxDecoration(
              // Creamos un gradiente
              gradient: LinearGradient(
                // Le decimos que comience de arriba a abajo
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                // Le indicamos que empiece desde la mitad de lapantalla hasta el final
                stops: [0.7,1.0],
                colors: [
                  // Establecemos que vaya desde estos colores
                Colors.transparent, 
                Colors.black87
              ])
            )),
          )
        ]),
      ),
    );
  }
}

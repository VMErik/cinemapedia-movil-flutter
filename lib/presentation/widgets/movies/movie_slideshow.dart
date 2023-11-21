import 'package:animate_do/animate_do.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

class MoviesSlideShow extends StatelessWidget {
  
  final List<Movie> movies;

  const MoviesSlideShow( {super.key , required this.movies} );

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      // Establecemos tamaños
      height: 210,
      width: double.infinity,
      child: Swiper(
        autoplay: true,
        // Agregamos la paginacion
        pagination: SwiperPagination(
          margin: const EdgeInsets.only(top: 0),
          builder: DotSwiperPaginationBuilder(
            activeColor: colors.primary, 
            color: colors.secondary
          )
        ) ,
        viewportFraction: 0.85, // Es que tanto de la pantalla va a  ocupar
        scale: 0.9, // Si queremos que esten pegados es 1, si queremos muy despegados 0.1
        itemCount: movies.length, 
        // Cramos nuestro slide
        itemBuilder: (context, index)=> _Slide(movie: movies[index])         ,
      ),
    );
  }
}


class _Slide extends StatelessWidget {

  final Movie movie;
  const _Slide({required this.movie});

  @override
  Widget build(BuildContext context) {


    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(
          color : Colors.black45,
          blurRadius: 10, 
          offset: Offset(0, 10)
        )
      ]
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: DecoratedBox(
        decoration: decoration,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            movie.backdropPath, 
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) { // Nos ayuda a saber cuando secargo
              if(loadingProgress != null){
                // Esta cargando
                return const Center(child: CircularProgressIndicator());
              }
              // Si si tenemos la iamgen, retornamos el child, hace referencia al child control
              return FadeIn(child: child);
            },
          )
          ),
      ),
    );
  }
}
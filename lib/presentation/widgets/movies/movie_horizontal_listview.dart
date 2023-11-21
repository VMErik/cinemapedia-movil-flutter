import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

class MovieHorizontalListview extends StatefulWidget {

  final List<Movie> movies;
  final String? title;
  final String? subtitle;

  // Es la funcion que llamaremos cuando lleguemos al final
  final VoidCallback? loadNextPage;

  const MovieHorizontalListview(
    {
      super.key, 
      required this.movies, 
      this.title, 
      this.subtitle, 
      this.loadNextPage
      }
  );

  @override
  State<MovieHorizontalListview> createState() => _MovieHorizontalListviewState();
}

class _MovieHorizontalListviewState extends State<MovieHorizontalListview> {

  final scrollController = ScrollController(); // Controlador para list VIEW

  @override
  void initState() {
    
    super.initState();
    scrollController.addListener(() {
      if(widget.loadNextPage == null) return;
      // Si hay un callbacckc en el widget
      if( (scrollController.position.pixels + 200 ) >= scrollController.position.maxScrollExtent){
        // Ejecutamos nuestra funcion
        widget.loadNextPage!();
      }

    });
  }


  @override
  void dispose() {
    // Haccemos dspose de nuestro controlador
    scrollController.dispose();
    
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: Column(
        children: [
          // Validamos si tenemos que renderizaar, si alguno tiene info
          if(widget.title != null || widget.subtitle != null)
            _Title(title: widget.title,subtitle: widget.subtitle,),
          Expanded(
            child : ListView.builder(
              controller: scrollController, // Asociamos a neustro controlador
              itemCount: widget.movies.length,
              scrollDirection: Axis.horizontal, // En lugar de vertical lo ponemos horizontal
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index){
                return FadeInRight(child: _Slide(movie: widget.movies[index],));
              }
            )
          )
        ],
      ),
    );
  }
}



class _Slide extends StatelessWidget {

final Movie movie;

  const _Slide({ required this.movie});


  @override
  Widget build(BuildContext context) {

    final textStyle = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Esto es la imagen
          SizedBox(
            width: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                movie.posterPath, 
                fit:  BoxFit.cover,
                width: 150,
                loadingBuilder: (context, child, loadingProgress){

                  if(loadingProgress != null){
                    return const Center(
                      child: const CircularProgressIndicator(strokeWidth: 2,)
                      );
                  }
                  return FadeIn(child: child);
                },
              
              ),
              

            ),
          ),
          const SizedBox(height: 5,) ,
          SizedBox(
            width: 150, 
            child : Text(movie.title , maxLines: 2 , style: textStyle.titleSmall ,
            ) 
          ) ,
          // Raitting
          SizedBox(
            width: 150,
            child: Row(
              children: [
                Icon(
                  Icons.star_half_outlined , 
                  color: Colors.yellow.shade800
                ),
                Text(
                  '${ movie.voteAverage }' , 
                  style: textStyle.bodyMedium?.copyWith(
                    // Usamos el copuy with para agregarle igual el color
                    color: Colors.yellow.shade800
                    )
                ),
                Spacer(),
                Text(HumanFormats.number(movie.popularity)  , style: textStyle.bodySmall),
              ],
            ),
          )
        ],
      ),
    );
  }
}



class _Title extends StatelessWidget {
  final String? title;
  final String? subtitle;
  const _Title({this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {

    final stileStyle = Theme.of(context).textTheme.titleLarge;

    return Container(
      padding: const EdgeInsets.only(top : 10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          if(title != null)
            Text(title! , style: stileStyle,),
          const Spacer(),
          if(subtitle != null)
            FilledButton.tonal(
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
              onPressed: (){} , 
              child: Text(subtitle!),
            ),
        ],
      ),
    );
  }
}
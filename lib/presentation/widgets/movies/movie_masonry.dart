import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MovieMasonry extends StatefulWidget {

  final List<Movie> movies;
  final VoidCallback? loadNextPage;

  const MovieMasonry(
    {
      super.key, 
      required this.movies, 
      this.loadNextPage
      }
    );

  @override
  State<MovieMasonry> createState() => _MovieMasonryState();
}

class _MovieMasonryState extends State<MovieMasonry> {

  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if(widget.loadNextPage == null) return;


      if((scrollController.position.pixels + 200) >= scrollController.position.maxScrollExtent){
        widget.loadNextPage!();
      }

    });

  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:const EdgeInsets.symmetric(horizontal: 10),
      child: MasonryGridView.count(
        // Especificamos el numero de columnas
        crossAxisCount: 3, 
        controller: scrollController,
        itemCount: widget.movies.length,
        // Espacios entre separacion
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        itemBuilder: (context, index){

          if (index == 1){
            return Column(
              children: [
                const SizedBox(height: 40,),
                MoviePosterLink(movie: widget.movies[index])
              ],
            );
          }
          return MoviePosterLink(movie: widget.movies[index]);
        }
      ),
    );
  }
}
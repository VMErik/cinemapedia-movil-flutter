import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FavoriteView extends ConsumerStatefulWidget {
  const FavoriteView({super.key});

  @override
  FavoriteViewState createState() => FavoriteViewState();
}

class FavoriteViewState extends ConsumerState<FavoriteView> {

  bool isLastPage = false;
  bool isLoading = false;



  @override
  void initState() {
    super.initState();
    // Cargamos las peliculas
    loadNextPage();
  }

  void loadNextPage() async{
    if(isLoading || isLastPage) return;
    isLoading = true;

    final movies = await ref.read(favoriteMoviesProvider.notifier).loadNextPage();
    isLoading = false;
    if(movies.isEmpty){
      isLastPage = true;
    }

  }

  @override
  Widget build(BuildContext context) {

    // Otebenemos la lista de movies
    final favoriteMovies = ref.watch(favoriteMoviesProvider).values.toList();

    if(favoriteMovies.isEmpty){
      final colors= Theme.of(context).colorScheme;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.favorite_outline_sharp, size: 60 , color: colors.primary,),
            Text('Ooh nooo!!',style: TextStyle(fontSize:30, color:colors.primary)),
            const Text('No tienes peliculas favoritas!!',style: TextStyle(fontSize:20, color:Colors.black45)),
            const SizedBox(height: 20,),
            FilledButton(
              onPressed: (){
                context.go('/home/0') ;
              }, 
              child: const Text('Empiezaa buscar')
            )
          ],
        ),
      );
    }

    return MovieMasonry(
      loadNextPage: loadNextPage,
      movies: favoriteMovies
    );
  }
}
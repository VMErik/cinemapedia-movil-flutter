import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/providers.dart';
import '../../widgets/widgets.dart';


// El consumer loutiliamospara los estados
class HomeView extends ConsumerStatefulWidget {
  const HomeView();

  @override
  HomeViewState createState() =>
      HomeViewState(); // Instanciamos neustra clase
}

class HomeViewState extends ConsumerState<HomeView> {
  // Cunado entremos, cargaremos nuestra pagina de peliculas
  @override
  void initState() {
    super.initState();
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage(); // Llamaremos a nuestr siguiente pagina
    ref.read(popularMoviesProvider.notifier).loadNextPage(); // Llamaremos a nuestra linea de populaes
    ref.read(topRatedMoviesProvider.notifier).loadNextPage(); // Llamaremos a nuestra linea de toprated
    ref.read(upcomingMoviesProvider.notifier).loadNextPage(); // Llamaremos a nuestra linea de upcoming

  }

  @override
  Widget build(BuildContext context) {

    final initialLoading = ref.watch(initialLoadingProvider);

  
    if(initialLoading){
      // Hasta que este marcado que ya no este cargado, mostramos todo
      return const FullScreenloader();
    }


    final movieSlideShow = ref.watch(moviesSlideshowProvider);
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider); // Esuchamos cambios en nuestro estado
    final popularMovies = ref.watch(popularMoviesProvider); // Esuchamos cambios en nuestro estado de pipulares
    final upcomingMovies = ref.watch(upcomingMoviesProvider); // Esuchamos cambios en nuestro estado de upcoming
    final topratedMovies = ref.watch(topRatedMoviesProvider); // Esuchamos cambios en nuestro estado de toprated


    return CustomScrollView(slivers: [

      const SliverAppBar(
        floating: true,
        flexibleSpace: FlexibleSpaceBar(
          title : CustomAppbar()
        ),
      ),


      SliverList(delegate: SliverChildBuilderDelegate((context, index) {
        return Column(
          children: [
            // const CustomAppbar(),
            MoviesSlideShow(
              movies: movieSlideShow,
            ),
            MovieHorizontalListview(
              movies: nowPlayingMovies,
              title: 'En Cines',
              subtitle: 'Hoy',
              loadNextPage: () {
                ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
              },
            ),
            MovieHorizontalListview(
              movies: popularMovies,
              title: 'Populares',
              subtitle: 'En este mes',
              loadNextPage: () {
                ref.read(popularMoviesProvider.notifier).loadNextPage();
              },
            ),
            MovieHorizontalListview(
              movies: upcomingMovies,
              title: 'Proximamente',
              // subtitle: 'Hoy',
              loadNextPage: () {
                ref.read(upcomingMoviesProvider.notifier).loadNextPage();
              },
            ),
            MovieHorizontalListview(
              movies: topratedMovies,
              title: 'Mejor calificadas',
              subtitle: 'De todos los tiempos',
              loadNextPage: () {
                ref.read(topRatedMoviesProvider.notifier).loadNextPage();
              },
            ),
            const SizedBox(
              height: 50,
            )
          ],
        );
      }, childCount: 1))
    ]);
  }
}

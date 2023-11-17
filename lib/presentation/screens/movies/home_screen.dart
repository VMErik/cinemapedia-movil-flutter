import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class HomeScreen extends StatelessWidget {

  static const name ='home-screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body:  _HomeView()
    );
  }
}

// El consumer loutiliamospara los estados
class _HomeView extends ConsumerStatefulWidget {

  const _HomeView();

  @override
  _HomeViewState createState() => _HomeViewState(); // Instanciamos neustra clase
}

class _HomeViewState extends ConsumerState<_HomeView> {

  // Cunado entremos, cargaremos nuestra pagina de peliculas
  @override
  void initState() {
    super.initState();
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage(); // Llamaremos a nuestr siguiente pagina
  }

  @override
  Widget build(BuildContext context) {

    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider); // Esuchamos cambios en nuestro estado

    if ( nowPlayingMovies.length == 0) return CircularProgressIndicator();

    return ListView.builder(
      itemCount: nowPlayingMovies.length,
      itemBuilder: (context , index){
        final movie = nowPlayingMovies[index];
        return ListTile(
          title:  Text(movie.title),
        );
      }
    );
  }
}


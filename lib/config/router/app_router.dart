
import 'package:cinemapedia/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/', 
  routes: [
    GoRoute(
      path: '/',
      name: HomeScreen.name,
      builder: (context, state) => const HomeScreen() , 
      routes: [
        // Agregamos rutas hijas, para que en navegador se pueda regresar
         GoRoute(
          // Indicamos que recibiremos un id, siempre seran string, los parametros (:nombreparam)
          path: 'movie/:id',
          name: MovieScreen.name,
          builder: (context, state) {
            // Obtenemos el parametro
            final movieId = state.pathParameters['id'] ?? 'no-id';
            // Cargamos nuestra nueva screen, y mandamos el parametro
            return MovieScreen(movieId: movieId,);
          }
        ) , 
      ]
    ) , 
  ]
);
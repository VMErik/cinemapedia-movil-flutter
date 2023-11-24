import 'package:cinemapedia/infraestructure/datasources/actor_moviedb_dataosurce.dart';
import 'package:cinemapedia/infraestructure/repositories/actor_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final actorsRepositoryProvider = Provider((ref) {
  // Retornamos nuestro  implementacion y pasamos nuestro datasource de MovieDB 
  // EN caso de cambiar de datasource, solo cambiaramos el DataSource que pasariamos
  return ActorsRepositoryImpl(ActorMovieDatasource());
});
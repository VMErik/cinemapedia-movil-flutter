
// Este sera un provider de solo lectura, no cambiara una vez creado
import 'package:cinemapedia/infraestructure/datasources/moviedb_datasource.dart';
import 'package:cinemapedia/infraestructure/repositories/movie_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final movieRepositoryProvider = Provider((ref) {
  // Retornamos nuestro  implementacion y pasamos nuestro datasource de MovieDB 
  // EN caso de cambiar de datasource, solo cambiaramos el DataSource que pasariamos
  return MovieRepositoryImpl(MovieDBDataSource());
});
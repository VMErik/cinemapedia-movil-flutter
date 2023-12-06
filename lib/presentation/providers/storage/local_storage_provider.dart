import 'package:cinemapedia/infraestructure/datasources/isar_datasource.dart';
import 'package:cinemapedia/infraestructure/repositories/local_storage_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Creamos nuestro repositorio de Riverpod con la informacion de Isar
final localStorageRepositoryProvider = Provider((ref){
  return LocalStorageRepositoryImpl(datasource: IsarDatasource());
});
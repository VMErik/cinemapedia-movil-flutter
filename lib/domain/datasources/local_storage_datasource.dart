import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

abstract class LocalStorageDatasource{
  Future<void> toggleFavorite(Movie movie);
  Future<bool> isMovieFavorite(int movieId);
  Future<List<Movie>> loadMovies({int lmit = 10 , offset =0});

}
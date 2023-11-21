// Este provider va a cambiar en base a otros provider
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';

final initialLoadingProvider = Provider<bool>((ref){
  // vamos a determinar el true, en base a los otros providers
  final step1 = ref.watch(moviesSlideshowProvider).isEmpty;
  final step2 = ref.watch(nowPlayingMoviesProvider).isEmpty; // Esuchamos cambios en nuestro estado
  final step3 = ref.watch(popularMoviesProvider).isEmpty; // Esuchamos cambios en nuestro estado de pipulares
  final step4 = ref.watch(upcomingMoviesProvider).isEmpty; // Esuchamos cambios en nuestro estado de upcoming
  final step5 = ref.watch(topRatedMoviesProvider).isEmpty; // Esuchamos cambios en nuestro estado de toprated

  if(step1 || step2 || step3 || step4 || step5) return true;

  return false; // Terminamos de cargar
});
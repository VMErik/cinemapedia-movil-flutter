import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infraestructure/models/moviedb/credits_response.dart';

class ActorMapper {
  static Actor astToEntity(Cast cast) =>
      Actor(
        id: cast.id, 
        name: cast.name, 
        profilePath: cast.profilePath != null  
          ? 'https://image.tmdb.org/t/p/w500/${cast.profilePath}' 
          : 'https://banffventureforum.com/wp-content/uploads/2019/08/No-Image.png', 
        character: cast.character
        );
}

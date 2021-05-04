import 'package:flix/actor.dart';

class Movie {
  String id, title, rating, posterUrl, description;
  List<String> genres;
  List<Actor> cast;
  int runtime;

  Movie(
      {this.id,
      this.title,
      this.rating,
      this.posterUrl,
      this.description,
      this.genres,
      this.cast,
      this.runtime});

  String get runtimeToStr {
    int minutes = runtime;
    var d = Duration(minutes: minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0]}h ${parts[1]}m';
  }

  String get genresToStr {
    return genres.join(', ');
  }
}

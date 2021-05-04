import 'dart:convert';
import 'package:flix/actor.dart';
import 'package:flix/movie.dart';
import 'package:http/http.dart' as http;

final api_key = 'def1092048c27281fdcef233de2b9878';
final base_url = 'api.themoviedb.org';
final images_base_url = 'https://image.tmdb.org/t/p/w500';

Future<Map<String, List<Movie>>> fetchHome() async {
  Map<String, List<Movie>> homeData = new Map();
  List<Movie> nowPlaying;
  List<Movie> trending;
  http.Response nowPlayingResponse;
  http.Response trendingResponse;
  final client = http.Client();
  try {
    nowPlayingResponse = await http.get(
        Uri.https(base_url, '/3/movie/now_playing', {'api_key': api_key}),
        headers: {"Content-Type": "application/json"});

    trendingResponse = await http.get(
        Uri.https(base_url, '/3/trending/movie/day', {'api_key': api_key}),
        headers: {"Content-Type": "application/json"});

    if (nowPlayingResponse.statusCode != 200 ||
        trendingResponse.statusCode != 200) {
      throw Exception('Failed to load movies');
    }

    List<String> trendingMovieIds =
        fetchTrendingMovieIds(jsonDecode(trendingResponse.body)['results']);

    trending = await fetchTrendingMoviesFromMovieIds(trendingMovieIds);
    nowPlaying = parseMovies(jsonDecode(nowPlayingResponse.body)['results']);

    homeData['nowPlaying'] = nowPlaying;
    homeData['trending'] = trending;
    return homeData;
  } finally {
    client.close();
  }
}

Future<Movie> fetchMovieDetail(String movieId) async {
  Movie movie;
  http.Response movieResponse;
  http.Response movieCreditsResponse;

  final client = http.Client();
  try {
    movieResponse = await http.get(
        Uri.https(base_url, '/3/movie/$movieId', {'api_key': api_key}),
        headers: {"Content-Type": "application/json"});

    movieCreditsResponse = await http.get(
        Uri.https(base_url, '/3/movie/$movieId/credits', {'api_key': api_key}),
        headers: {"Content-Type": "application/json"});

    if (movieResponse.statusCode != 200 ||
        movieCreditsResponse.statusCode != 200) {
      throw Exception('Failed to load movie');
    }
  } finally {
    client.close();
  }
  movie = parseMovie(jsonDecode(movieResponse.body),
      jsonDecode(movieCreditsResponse.body)['cast']);

  return movie;
}

List<Movie> parseMovies(List<dynamic> moviesJson) {
  List<Movie> movies = [];
  Movie movie;
  moviesJson.forEach((movieItem) {
    movie = Movie();
    movie.id = movieItem['id'].toString();
    movie.title = movieItem['title'];
    movie.rating = movieItem['vote_average'].toString();
    movie.posterUrl = '$images_base_url${movieItem['poster_path']}';
    movies.add(movie);
  });
  return movies;
}

Movie parseMovie(dynamic movieJson, List<dynamic> movieCreditsJson) {
  Movie movie = parseTrendingMovie(movieJson);
  movie.description = movieJson['overview'];
  movie.cast = [];

  movieCreditsJson.forEach((castJson) {
    Actor actor = Actor();
    actor.name = castJson['name'];
    actor.imageUrl = '$images_base_url${castJson['profile_path']}';
    movie.cast.add(actor);
  });

  return movie;
}

List<String> fetchTrendingMovieIds(List<dynamic> moviesJson) {
  List<String> movieIds = [];
  moviesJson.forEach((movieItem) => movieIds.add(movieItem['id'].toString()));
  return movieIds;
}

Future<List<Movie>> fetchTrendingMoviesFromMovieIds(
    List<String> trendingMovieIds) async {
  List<Movie> trendingMovies = [];
  http.Response trendingMovieResponse;

  await Future.forEach(trendingMovieIds, (movieId) async {
    trendingMovieResponse = await http.get(
        Uri.https(base_url, '/3/movie/$movieId', {'api_key': api_key}),
        headers: {"Content-Type": "application/json"});

    Movie movie = parseTrendingMovie(jsonDecode(trendingMovieResponse.body));
    trendingMovies.add(movie);
  });

  return trendingMovies;
}

Movie parseTrendingMovie(dynamic movieJson) {
  Movie movie = Movie();
  movie.id = movieJson['id'].toString();
  movie.title = movieJson['title'];
  movie.rating = movieJson['vote_average'].toString();
  movie.posterUrl = '$images_base_url${movieJson['poster_path']}';
  movie.runtime = movieJson['runtime'];
  movie.genres = [];
  List<dynamic> genresJson = movieJson['genres'];
  genresJson.forEach((genre) => movie.genres.add(genre['name']));
  return movie;
}

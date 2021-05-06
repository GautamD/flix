import 'dart:async';

import 'package:flix/movie.dart';
import 'package:flix/movie_detail.dart';
import 'package:flix/networking.dart';
import 'package:flix/rating_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';

StreamSubscription _sub;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, List<Movie>> _homeData;

  @override
  void initState() {
    super.initState();
    initUniLinks(context);
    fetchHome().then((homeData) => setState(() => _homeData = homeData));
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Movies'),
          actions: [
            IconButton(icon: const Icon(Icons.search), onPressed: () {})
          ],
        ),
        body: _homeData == null
            ? Center(child: CircularProgressIndicator())
            : homeWidget(_homeData['nowPlaying'], _homeData['trending']));
  }
}

Widget homeWidget(List<Movie> nowPlayingMovies, List<Movie> trendingMovies) {
  return Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(
        flex: 4,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: nowPlayingMovies.length,
            itemBuilder: (BuildContext context, int index) {
              Movie movie = nowPlayingMovies.elementAt(index);
              return GestureDetector(
                onTap: () {
                  goToMovieDetail(context, movie.id);
                },
                child: Column(children: [
                  Image.network(movie.posterUrl, width: 230, height: 300),
                  SizedBox(height: 20),
                  Row(children: [
                    SizedBox(width: 15),
                    SizedBox(
                        width: 160,
                        child: Text(movie.title,
                            maxLines: 1, overflow: TextOverflow.ellipsis)),
                    RatingWidget(rating: movie.rating)
                  ])
                ], crossAxisAlignment: CrossAxisAlignment.start),
              );
            }),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 15.0, top: 10.0, bottom: 30.0),
        child: Text('Trending',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
      ),
      Expanded(
        flex: 4,
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: trendingMovies.length,
            itemBuilder: (BuildContext context, int index) {
              Movie movie = trendingMovies.elementAt(index);
              return GestureDetector(
                onTap: () {
                  goToMovieDetail(context, movie.id);
                },
                child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, bottom: 25.0),
                    child: Row(children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: <Widget>[
                          Container(
                              height: 100,
                              width: 100,
                              child: Image.network(movie.posterUrl,
                                  width: 100, height: 100, fit: BoxFit.cover)),
                          Positioned(
                              child: RatingWidget(rating: movie.rating),
                              left: 75,
                              bottom: 0)
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 30.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                SizedBox(
                                    width: 250,
                                    child: Text(movie.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis)),
                                SizedBox(height: 5),
                                Text(movie.runtimeToStr,
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 11)),
                                SizedBox(height: 20),
                                SizedBox(
                                    width: 200,
                                    child: Text(movie.genresToStr,
                                        style: TextStyle(
                                            color: Colors.pink, fontSize: 11)))
                              ]))
                    ], crossAxisAlignment: CrossAxisAlignment.start)),
              );
            }),
      )
    ]),
  );
}

void goToMovieDetail(BuildContext context, String movieId) {
  Navigator.push(context,
      MaterialPageRoute(builder: (context) => MovieDetail(movieId: movieId)));
}

Future<Null> initUniLinks(BuildContext context) async {
  try {
    final initialLink = await getInitialLink();
    if (initialLink != null) {
      String movieId = initialLink.replaceFirst("MOVIES://flix.com/", "");
      goToMovieDetail(context, movieId);
    }
  } on PlatformException {
    print("ERROR: Processing initial link failed.");
  }

  _sub = linkStream.listen((String link) {
    String movieId = link.replaceFirst("MOVIES://flix.com/", "");
    goToMovieDetail(context, movieId);
  }, onError: (error) => print("ERROR: ${error.toString()}"));
}

import 'dart:ui';
import 'package:flix/actor.dart';
import 'package:flix/movie.dart';
import 'package:flix/networking.dart';
import 'package:flix/rating_widget.dart';
import 'package:flutter/material.dart';

class MovieDetail extends StatefulWidget {
  final String movieId;
  MovieDetail({this.movieId});

  @override
  _MovieDetailState createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  Movie _movie;

  @override
  void initState() {
    super.initState();
    fetchMovieDetail(widget.movieId)
        .then((movie) => setState(() => _movie = movie));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        extendBodyBehindAppBar: true,
        body: _movie == null
            ? Center(child: CircularProgressIndicator())
            : movieDetailWidget(_movie));
  }
}

Widget movieDetailWidget(Movie movie) {
  return Stack(children: [
    Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(movie.posterUrl), fit: BoxFit.cover))),
    Positioned(
        top: 300,
        left: 0,
        right: 0,
        bottom: 0,
        child: ClipRect(
            child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 5.0,
                  sigmaY: 5.0,
                ),
                child: movieDetailSection(movie))))
  ]);
}

Widget movieDetailSection(Movie movie) {
  return Container(
    padding: const EdgeInsets.all(8.0),
    child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            SizedBox(
              width: 300,
              child: Text(movie.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            SizedBox(width: 15),
            RatingWidget(rating: movie.rating)
          ]),
          SizedBox(height: 10),
          Text(movie.genresToStr,
              style:
                  TextStyle(color: Colors.pink, fontWeight: FontWeight.w500)),
          SizedBox(height: 20),
          sectionTitleWidget('Info'),
          SizedBox(height: 20),
          SizedBox(
              height: 90,
              child: Text(movie.description,
                  maxLines: 5, overflow: TextOverflow.ellipsis)),
          SizedBox(height: 20),
          sectionTitleWidget('Cast'),
          SizedBox(height: 20),
          Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: movie.cast.length,
                  itemBuilder: (BuildContext context, int index) {
                    Actor actor = movie.cast[index];
                    return Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(actor.imageUrl,
                                  width: 120, height: 150, fit: BoxFit.cover),
                              SizedBox(height: 10),
                              Text(actor.name)
                            ]));
                  }))
        ]),
  );
}

Widget sectionTitleWidget(String title) {
  return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.pink, width: 2))),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 7.0),
        child: Text(title, style: TextStyle(fontSize: 20, color: Colors.grey)),
      ));
}

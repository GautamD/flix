import 'package:flutter/material.dart';

class RatingWidget extends StatelessWidget {
  final String rating;
  RatingWidget({this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 40,
        height: 15,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Icon(Icons.star, size: 10, color: Colors.white),
          Text(rating,
              style: TextStyle(fontSize: 9, fontWeight: FontWeight.w500))
        ]),
        decoration: BoxDecoration(
            color: Colors.pink,
            borderRadius: BorderRadius.all(Radius.circular(20))));
  }
}

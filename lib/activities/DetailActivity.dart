import 'dart:convert';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;

class DetailActivity extends StatefulWidget {
  int id;
  String title;
  String poster;

  @override
  State<StatefulWidget> createState() {
    return new _DetailState();
  }

  DetailActivity(this.id, this.poster, this.title);
}

class _DetailState extends State<DetailActivity> {
  Movie movie;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getmovie(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: ExtendedImage.network(
                "https://image.tmdb.org/t/p/w300/${widget.poster}",
                fit: BoxFit.fill,
                cache: true,
                scale: 2,
                border: Border.all(color: Colors.red, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
              ),
            ),
            title: Text(widget.title),
          ),
          SliverFillRemaining(
            child: ListView(
              padding: EdgeInsets.all(5),
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(child:Text(
                      '${movie == null ? "" : movie.original_title}',
                      style: TextStyle(fontSize: 14),
                    ), flex: 1 ),

                    RatingBar(
                      initialRating: 3.4,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) =>
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
//                          onRatingUpdate: (rating) {
//                            print(rating);
//                          },
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.all(5)),
                Text(
                  'language : ${movie == null ? "" : movie.original_language}',
                  style: TextStyle(fontSize: 14),
                ),
                Padding(padding: EdgeInsets.all(5)),
                Text(
                  'revenue : ${movie == null ? "" : movie.revenue}',
                  style: TextStyle(fontSize: 14),
                ),
                Padding(padding: EdgeInsets.all(5)),
                Text(
                  'status : ${movie == null ? "" : movie.status}',
                  style: TextStyle(fontSize: 14),
                ),
                Padding(padding: EdgeInsets.all(5)),
                Container(
                  width: double.infinity,
                  child: Text(
                    '${movie == null ? "" : movie.overview}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 100,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<Movie> getmovie(int id) async {
    http
        .get(
        "http://api.themoviedb.org/3/movie/${id}?api_key=832f13a97b5d2df50ecf0dbc8a0f46ae")
        .then((http.Response response) {
      if (response.statusCode == 200) {
        setState(() {
          movie = Movie.fromJson(jsonDecode(response.body));
        });

        print(response.body);
      } else
        print('${response.statusCode}');
    });
  }
}

class Movie {
  String original_language;
  String original_title;
  String overview;
  int revenue;
  String status;

  Movie({this.original_language,
    this.original_title,
    this.overview,
    this.revenue,
    this.status});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return new Movie(
      original_language: json["original_language"],
      original_title: json["original_title"],
      overview: json["overview"],
      revenue: json["revenue"],
      status: json["status"],
    );
  }
}

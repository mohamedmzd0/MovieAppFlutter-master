import 'dart:convert';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/activities/DetailActivity.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Placeholder extends StatefulWidget {
  String data;

  @override
  State<StatefulWidget> createState() {
    return new _PlaceholderState();
  }

  Placeholder(this.data);
}

class _PlaceholderState extends State<Placeholder> {
  List<Results> _list = null;
  RefreshController _refreshController = new RefreshController();
  int page = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTopRated();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SmartRefresher(
        onRefresh: getTopRated,
        onLoading: _loadmore,
        enablePullDown: true,
        controller: _refreshController,
        enablePullUp: true,
        child: GridView.count(
            padding: EdgeInsets.all(1),
            crossAxisCount: 2,
            children: List.generate(_list == null ? 0 : _list.length, (index) {
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DetailActivity(_list[index].id, _list[index].poster_path,_list[index].original_title)),
                ),
                child: Card(
                  borderOnForeground: true,
                  elevation: 2,
                  color: Colors.white,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        ExtendedImage.network(
                          "https://image.tmdb.org/t/p/w300/${_list[index].poster_path}",
                          fit: BoxFit.fill,
                          cache: true,
                          scale: 2,
                          border: Border.all(color: Colors.red, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
                        ),
                        Text(
                          '${_list[index].original_title}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
                        ),
                        Text(
                          '${_list[index].release_date}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            })),
      ),
    );
  }

  Future<List<Results>> getTopRated() async {
    var URL = "http://api.themoviedb.org/3/movie/" +
        widget.data +
        "?api_key=832f13a97b5d2df50ecf0dbc8a0f46ae&page=${page}";
    http.get(URL).then((http.Response response) {
      print(response.body);
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      MovieResponse res = MovieResponse.fromJson(jsonDecode(response.body));
      setState(() {
        if (_list == null)
          _list = res.results;
        else
          _list.addAll(res.results);
      });
      _refreshController.refreshCompleted();
      _refreshController.loadComplete();
      return res.results;
    });
  }

  void _loadmore() {
    page++;
    getTopRated();
    print('load more');
  }
}

class MovieResponse {
  int page;
  List<Results> results;

  MovieResponse({this.page, this.results});

  factory MovieResponse.fromJson(Map<String, dynamic> json) {
    return MovieResponse(page: json["page"], results: getResults(json));
  }

  static List<Results> getResults(json) {
    var list = json['results'] as List;
    return list.map((i) => Results.fromJson(i)).toList();
  }
}

class Results {
  int id;
  String poster_path;
  String original_title;
  double vote_average;
  String overview;
  String release_date;

  Results(
      {this.id,
      this.poster_path,
      this.original_title,
//      this.vote_average,
      this.overview,
      this.release_date});

  factory Results.fromJson(Map<String, dynamic> json) {
    return Results(
        id: json["id"],
        poster_path: json["poster_path"],
        original_title: json["original_title"],
//        vote_average: json["vote_average"],
        overview: json["overview"],
        release_date: json["release_date"]);
  }
}

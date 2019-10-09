import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
            child: FittedBox(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                RatingBar(
                          itemSize: 3,
                          initialRating: 3,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
//                          onRatingUpdate: (rating) {
//                            print(rating);
//                          },

                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

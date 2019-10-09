import 'package:flutter/material.dart';
import 'package:flutter_app/activities/Plcaeholder.dart' as Popular;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = new TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(controller: _controller, tabs: [
          Tab(
            icon: Icon(Icons.movie),
            text: 'Top Rated',
          ),
          Tab(
            icon: Icon(Icons.movie),
            text: 'Popular',
          )
        ]),
        title: Text(widget.title),
      ),
      body: TabBarView(
        controller: _controller,
        children: <Widget>[
          new Popular.Placeholder("top_rated"),
          new Popular.Placeholder("popular")
        ],
      ),
    );
  }
}

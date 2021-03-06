/*
import 'package:flutter/material.dart';
import 'package:nhkeasynews/store/main.dart';
import 'package:nhkeasynews/utility/ui_element/NewsCard.dart';
import 'package:scoped_model/scoped_model.dart';

class HomePage extends StatefulWidget {
  */
/* Prodution Modal*/ /*

  final MainModel model;
  HomePage(this.model);
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}


class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    */
/* Prodution Modal*/ /*

    widget.model.startGetAllNewsList();
    super.initState();
  }

  */
/* Build the Home page with Custom Scroll View*/ /*
*/
/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          Appbar(),
        ],
      ),
    );
  }*/ /*


  */
/* Home Page App Bar */ /*

  Widget Appbar() => SliverAppBar(
        backgroundColor: Color.fromRGBO(255, 250, 250, 0.8),
        pinned: true,
        elevation: 15.0,
        forceElevated: true,
        expandedHeight: 100.0,
//    flexibleSpace: FlexibleSpaceBar(
//      centerTitle:false,
//
//    ),
      );

  */
/* Home Page Body Scroll View */ /*

  Widget BodyGrid() => SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 0.0,
          crossAxisSpacing: 0.0,
          childAspectRatio: 1.0,
        ),
      delegate: SliverChildBuilderDelegate((BuildContext context,int index){
        return null;
      },childCount: 10),
  );

*/
import 'package:flutter/material.dart';
import 'package:nhkeasynews/store/main.dart';
import 'package:nhkeasynews/utility/ui_element/NewsCard.dart';
import 'package:scoped_model/scoped_model.dart';

class HomePage extends StatefulWidget {
  final MainModel model;

  HomePage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollViewController;

  @override
  void initState() {
    super.initState();
    _scrollViewController = new ScrollController();
    widget.model.startGetAllNewsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
          Widget content = new NestedScrollView(
            controller: _scrollViewController,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                new SliverAppBar(
                  actions: <Widget>[
                    new IconButton(
                        icon: new Icon(Icons.lightbulb_outline),
                        onPressed: () => model.toggleDarkMode()),
                  ],
                  centerTitle: true,
                  title: new Text(
                    "NHK EASY NEWS",
                    style: new TextStyle(color: Colors.grey[700]),
                  ),
                  floating: true,
                  forceElevated: innerBoxIsScrolled,
                )
              ];
            },
            body: GridView.count(
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
              crossAxisCount: 2,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 7.0,
              children: List.generate(model.allNewsList.length, (int index) {
                return new Container(
                  child: NewsCard(index, model),
                );
              }),
            ),
          );
          if (model.isLoading) {
            content = Center(child: CircularProgressIndicator());
          }
          return RefreshIndicator(
            child: content,
            onRefresh: model.startGetAllNewsList,
          );
        },
      ),
    );
  }
}

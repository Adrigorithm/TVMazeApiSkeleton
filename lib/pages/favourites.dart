import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test_1/components/shared.dart';
import 'package:flutter_test_1/entities/show.dart';
import 'package:flutter_test_1/entities/tvmaze_client.dart';
import 'package:flutter_test_1/helpers/extensions.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({Key? key}) : super(key: key);

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  final Future<ShowList> showsCacheFavourite = TVMazeClient().getShows();

  @override
  Widget build(BuildContext context) {
    var args = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    final String filter;
    (args["filter"] == null) ? filter = "" : filter = args["filter"];

    return Scaffold(
      appBar: SharedWidgets(context).mainAppBar,
      body: FutureBuilder<ShowList>(
        future: showsCacheFavourite, // Future<T>
        builder: (BuildContext context, AsyncSnapshot<ShowList> snapshot) {
          List<Widget> children = List.empty(growable: true);
          if (snapshot.hasData) {
            for (var show in snapshot.data!.shows) {
              // Implement this
              if (RegExp(".*" + filter.toLowerCase() + ".*")
                  .hasMatch(show.name.toLowerCase())) {
                children.add(GestureDetector(
                  child: Container(
                    child: Row(
                      children: [
                        Expanded(
                            child: Image.network(show.image["medium"],
                                errorBuilder: (context, error, stackTrace) {
                              return Image.file(
                                  File("images/coverDefault.png"));
                            }),
                            flex: 1),
                        Expanded(child: Text(show.name), flex: 2)
                      ],
                    ),
                    height: 200,
                    margin: const EdgeInsets.only(top: 10),
                  ),
                  onTap: () {
                    // Change state
                    Navigator.of(context).pushReplacementNamed("/details",
                        arguments: {"show": show});
                  },
                ));
              }
            }
          } else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ];
          } else {
            children = const <Widget>[
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              )
            ];
          }
          return ListView(
            children: children,
          );
        },
      ),
    );
  }
}

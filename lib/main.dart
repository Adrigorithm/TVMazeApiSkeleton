import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_test_1/components/shared.dart';
import 'package:flutter_test_1/entities/show.dart';
import 'package:flutter_test_1/entities/tvmaze_client.dart';
import 'package:html/parser.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.from(colorScheme: scheme),
        title: _title,
        initialRoute: "/",
        home: const HomePage(),
        routes: <String, WidgetBuilder>{
          '/details': (BuildContext context) => const DetailsPage(),
        });
  }
}

class DetailsPage extends StatelessWidget {
  const DetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var args = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    final Show show;
    if (args["show"] == null) {
      show = Show(-1, "Film not found", [], "", <String, dynamic>{"average": 0},
          <String, dynamic>{}, "How did you get here?");
    } else {
      show = args["show"];
    }

    return Scaffold(
      appBar: SharedWidgets().mainAppBar,
      body: GestureDetector(
        child: Stack(children: [
          DecoratedBox(
            child: FittedBox(
              child: Image.network(show.image["original"],
                  errorBuilder: (context, error, stackTrace) {
                return Image.file(File("images/coverFullDefault.png"));
              }),
              fit: BoxFit.cover,
            ),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                  Colors.black87,
                  Colors.black.withAlpha(0)
                ])),
            position: DecorationPosition.foreground,
          ),
          Column(children: [
            RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: show.name,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                TextSpan(text: "Description " + parse(show.summary).outerHtml),
                TextSpan(text: "" + show.rating["average"].toString())
              ], style: TextStyle(color: scheme.onSecondary)),
            ),
            Row(children: getRatingIcons(show.rating["average"] ?? -1))
          ])
        ], fit: StackFit.expand),
        onTap: () {
          Navigator.of(context).pushReplacementNamed("/");
        },
      ),
    );
  }

  List<Widget> getRatingIcons(dynamic rating) {
    List<Widget> ratingIcons = List.empty(growable: true);
    var localRating = rating * 0.5;
    Color iconColour = Colors.red;

    if (rating >= 9.5) {
      iconColour = Colors.yellow;
    } else if (rating >= 6) {
      iconColour = Colors.green;
    } else if (rating >= 3) {
      iconColour = Colors.orange;
    }

    while (localRating > 0) {
      if (localRating - 1 >= -0.25) {
        localRating -= 1;
        ratingIcons.add(Icon(Icons.star_rounded, color: iconColour));
      } else if (localRating - 0.5 >= -0.25) {
        localRating -= 0.5;
        ratingIcons.add(Icon(Icons.star_half_rounded, color: iconColour));
      } else {
        break;
      }
    }

    return (ratingIcons.isEmpty)
        ? [
            const Icon(Icons.star_border_rounded, color: Colors.grey),
            const Icon(Icons.star_border_rounded, color: Colors.grey),
            const Icon(Icons.star_border_rounded, color: Colors.grey),
            const Icon(Icons.star_border_rounded, color: Colors.grey),
            const Icon(Icons.star_border_rounded, color: Colors.grey)
          ]
        : ratingIcons;
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Future<ShowList> showsCache = TVMazeClient().getShows();

  @override
  Widget build(BuildContext context) {
    var args = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    final String filter;
    (args["filter"] == null) ? filter = "" : filter = args["filter"];

    return Scaffold(
      appBar: SharedWidgets().mainAppBar,
      body: FutureBuilder<ShowList>(
        future: showsCache, // Future<T>
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

const ColorScheme scheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color.fromRGBO(120, 195, 251, 1),
    onPrimary: Color.fromARGB(255, 24, 16, 16),
    secondary: Color.fromRGBO(85, 0, 213, 1),
    onSecondary: Color.fromRGBO(249, 249, 237, 1),
    error: Color.fromRGBO(255, 127, 80, 1),
    onError: Color.fromRGBO(249, 249, 237, 1),
    background: Color.fromRGBO(249, 249, 237, 1),
    onBackground: Color.fromRGBO(0, 0, 128, 1),
    surface: Color.fromRGBO(120, 195, 251, 1),
    onSurface: Color.fromRGBO(116, 116, 116, 1));

import 'package:flutter/material.dart';

import 'package:flutter_test_1/components/shared.dart';
import 'package:flutter_test_1/entities/show.dart';
import 'package:flutter_test_1/entities/tvmaze_client.dart';
import 'package:universal_io/prefer_universal/io.dart';

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
    Show show = ModalRoute.of(context)?.settings.arguments as Show;
    return Scaffold(
      appBar: SharedWidgets().mainAppBar,
      body: GestureDetector(
        child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        show.image["original"] ?? show.image["medium"]),
                    colorFilter: const ColorFilter.mode(
                        Color.fromARGB(255, 0, 0, 0), BlendMode.darken)))),
        onTap: () {
          Navigator.of(context).pushReplacementNamed("/");
        },
      ),
    );
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
    return Scaffold(
      appBar: SharedWidgets().mainAppBar,
      body: FutureBuilder<ShowList>(
        future: showsCache, // Future<T>
        builder: (BuildContext context, AsyncSnapshot<ShowList> snapshot) {
          List<Widget> children = List.empty(growable: true);
          if (snapshot.hasData) {
            for (var show in snapshot.data!.shows) {
              String filter = "the"; // Implement this
              if (RegExp(".*" + filter.toLowerCase() + ".*")
                  .hasMatch(show.name.toLowerCase())) {
                children.add(GestureDetector(
                  child: Row(
                    children: [
                      Expanded(
                          child: Image.network(show.image["medium"]), flex: 1),
                      Expanded(child: Text(show.name), flex: 2),
                    ],
                  ),
                  onTap: () {
                    // Change state
                    Navigator.of(context)
                        .pushReplacementNamed("/details", arguments: show);
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
          return SingleChildScrollView(
              child: Column(
            children: children,
          ));
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

import 'package:flutter/material.dart';

import 'package:flutter_test_1/components/shared.dart';
import 'package:flutter_test_1/entities/show.dart';
import 'package:flutter_test_1/entities/tvmaze_client.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.from(colorScheme: scheme),
      title: _title,
      home: const MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final Future<ShowList> showsCache = TVMazeClient().getShows();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SharedWidgets().mainAppBar,
      body: FutureBuilder<ShowList>(
        future: showsCache, // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<ShowList> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            children = [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              snapshot.data?.shows[0].image["medium"]))),
                ),
              )
            ];
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
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          );
        },
      ),
    );
  }
}

const ColorScheme scheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color.fromRGBO(120, 195, 251, 1),
    onPrimary: Color.fromRGBO(116, 116, 116, 1),
    secondary: Color.fromRGBO(85, 0, 213, 1),
    onSecondary: Color.fromRGBO(249, 249, 237, 1),
    error: Color.fromRGBO(255, 127, 80, 1),
    onError: Color.fromRGBO(249, 249, 237, 1),
    background: Color.fromRGBO(249, 249, 237, 1),
    onBackground: Color.fromRGBO(0, 0, 128, 1),
    surface: Color.fromRGBO(120, 195, 251, 1),
    onSurface: Color.fromRGBO(116, 116, 116, 1));

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   // Root widget
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData.from(colorScheme: scheme),
//       title: 'Welcome to Flutter',
//       home: const MyStatefulWidget(),
//     );
//   }

// class MyStatefulWidget extends StatefulWidget {
//   const MyStatefulWidget({Key? key}) : super(key: key);

//   @override
//   State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
// }

// class _MyStatefulWidgetState extends State<MyStatefulWidget> {
//   final Future<String> _calculation = Future<String>.delayed(
//     const Duration(seconds: 2),
//     () => 'Data Loaded',
//   );
  
//   var tvmClient = TVMazeClient();
//   tvmClient.getShows();
  
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(children: [
//       Expanded(
//           child: Container(
//             decoration: BoxDecoration(
//             image: tvmClient.showCache.shows[0].image["medium"]),
//             color: Colors.red,
//           ),
//           flex: 4),
//       Expanded(child: Container(color: Colors.green), flex: 1)
//     ]);
//   }
  
// }

import 'package:flutter/material.dart';
import 'package:flutter_test_1/pages/details.dart';
import 'package:flutter_test_1/pages/home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  /// Defines routing table and app root (starting point)
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.from(colorScheme: scheme),
        title: _title,
        initialRoute: "/",
        home: const HomePage(),
        routes: <String, WidgetBuilder>{
          '/details': (BuildContext context) => const DetailsPage()
        });
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

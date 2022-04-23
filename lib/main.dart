import 'package:flutter/material.dart';

import 'package:flutter_test_1/components/shared.dart';
import 'package:flutter_test_1/components/layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // Root widget
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.from(colorScheme: scheme),
      title: 'Welcome to Flutter',
      home: const StatelessWidgetScaffold(),
    );
  }

  final ColorScheme scheme = const ColorScheme(
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
}

class StatelessWidgetScaffold extends StatelessWidget {
  const StatelessWidgetScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sharedWidgets = SharedWidgets();

    // Pass maxWidth in case flexbox doesn't suffice
    return Scaffold(
        appBar: sharedWidgets.mainAppBar,
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (constraints.maxWidth <= 600) {
              return buildLayout(width: 600);
            } else if (constraints.maxWidth <= 1000) {
              return buildLayout(width: 1000);
            } else {}
            return buildLayout();
          },
        ));
  }

  Widget buildLayout({int width = -1}) {
    return Layout.build(width);
  }
}

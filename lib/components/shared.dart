import 'package:flutter/material.dart';

class SharedWidgets {
  var mainAppBar = AppBar(
    title: const Text('TVMazeAPI'),
    actions: [
      IconButton(
        onPressed: () {},
        icon: const Icon(Icons.home, semanticLabel: "Home"),
        tooltip: "Home",
      )
    ],
  );
}

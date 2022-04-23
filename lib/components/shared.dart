import 'package:flutter/material.dart';

class SharedWidgets {
  var mainAppBar = AppBar(
    title: const Text('Weebshop lmao'),
    actions: [
      IconButton(
        onPressed: () {
          // home href something
        },
        icon: const Icon(Icons.home, semanticLabel: "Home"),
        tooltip: "Home",
      ),
      IconButton(
        onPressed: () {
          // home href something
        },
        icon: const Icon(Icons.info, semanticLabel: "About"),
        tooltip: "Contact",
      ),
      IconButton(
        onPressed: () {
          // home href something
        },
        icon: const Icon(Icons.local_grocery_store, semanticLabel: "Store"),
        tooltip: "Store",
      )
    ],
  );
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SharedWidgets {
  static late BuildContext context;

  var mainAppBar = AppBar(
    title: const Text('TVMazeAPI'),
    actions: [
      IconButton(
        onPressed: () {
          Navigator.of(context).pushReplacementNamed("/");
        },
        icon: const Icon(Icons.home, semanticLabel: "Home"),
        tooltip: "Home",
      )
    ],
  );

  SharedWidgets(BuildContext buildContext) {
    context = buildContext;
  }
}

class IOManager {
  static Future<String> readFile(String fileName) async {
    final file = File((await _getCachingDirectory()).path + "/" + fileName);
    return await file.exists() ? await file.readAsString() : "";
  }

  static void saveFile(String fileName, String content) async {
    final file = File((await _getCachingDirectory()).path + "/" + fileName);
    await file.writeAsString(content);
  }

  static Future<Directory> _getCachingDirectory() async {
    return Directory(
            (await getApplicationDocumentsDirectory()).path + "/tvmaze_app")
        .create();
  }
}

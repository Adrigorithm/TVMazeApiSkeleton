import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SharedWidgets {
  static late BuildContext context;

  /// Shared navigation menu for all screens
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
  /// Reads file in documents directory. Returns the file content if successful, otherwise an empty string.
  static Future<String> readFile(String fileName) async {
    final file = File((await _getCachingDirectory()).path + "/" + fileName);
    return await file.exists() ? await file.readAsString() : "";
  }

  /// Writes file to documents directory
  static void saveFile(String fileName, String content,
      {FileMode mode = FileMode.write}) async {
    final file = File((await _getCachingDirectory()).path + "/" + fileName);
    await file.writeAsString(content, mode: mode);
  }

  /// returns full app cache path
  static Future<Directory> _getCachingDirectory() async {
    return Directory(
            (await getApplicationDocumentsDirectory()).path + "/tvmaze_app")
        .create();
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test_1/components/shared.dart';
import 'package:flutter_test_1/entities/show.dart';

extension CrudOperations on List<Show> {
  /// Alters showsList to include favourites
  Future<List<Show>> getFavourites() async {
    final content = const LineSplitter()
        .convert(await IOManager.readFile("shows_favourites.txt"));

    for (var show in this) {
      if (content.contains(show.id.toString())) {
        show.isFavourite = true;
      }
    }
    return this;
  }
}

extension CrudOperations1 on Show {
  /// Adds favourite by saving show ID
  void saveFavourite() async {
    await IOManager.saveFile("shows_favourites.txt", id.toString() + "\n",
        mode: FileMode.append);
  }

  void deleteFavourite() async {
    await IOManager.removeLine("shows_favourites.txt", id.toString());
  }
}

extension StringManipulation on String {
  /// API returns strings including html tags for whatever reason
  String removeHTMLTags() {
    return replaceAll(RegExp("<[^>]+>"), "");
  }
}

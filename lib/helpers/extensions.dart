import 'dart:convert';

import 'package:flutter_test_1/components/shared.dart';
import 'package:flutter_test_1/entities/show.dart';

extension CrudOperations on List<Show> {
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
  void triggerFavourite() {
    if (isFavourite) {}
  }
}

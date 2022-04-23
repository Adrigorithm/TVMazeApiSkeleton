import 'package:flutter/material.dart';
import 'package:flutter_test_1/entities/tvmaze_client.dart';

class Layout {
  static Container build(int width) {
    return Container(child: getContent(width));
  }

  static Widget getContent(int width) {
    var tvmClient = TVMazeClient();
    tvmClient.getShows();

    return Column(children: [
      Expanded(
          child: Container(
            color: Colors.red,
          ),
          flex: 4),
      Expanded(child: Container(color: Colors.green), flex: 1)
    ]);
  }
}

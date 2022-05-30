import 'dart:convert';
import 'package:flutter_test_1/helpers/extensions.dart';
import 'package:universal_io/io.dart';

import 'package:flutter_test_1/components/shared.dart';
import 'package:flutter_test_1/entities/show.dart';
import 'package:flutter_test_1/secret/secret.dart';

class TVMazeClient {
  final String token = Secret.tvMazeToken;
  final String baseUri = "https://api.tvmaze.com/";

  /// Converts raw json to dart objects
  Future<ShowList> getShows() async {
    var showList = ShowList.fromJson(jsonDecode((await _getShowsAsync())));
    showList.shows = await showList.shows.getFavourites();
    return showList;
  }

  /// GET shows from cache or HTTP if connected to the internet
  Future<String> _getShowsAsync() async {
    String showsJson = "";

    try {
      var client = HttpClient();

      // I know this is bad, but my phone is also bad :)
      client.badCertificateCallback = (cert, host, port) => true;
      var request = await client.getUrl(Uri.parse(baseUri + "shows"));

      var response = await request.close();
      showsJson = await response.transform(const Utf8Decoder()).join();
      IOManager.saveFile("shows.json", showsJson);
      showsJson = await IOManager.readFile("shows.json");
    } catch (e) {
      showsJson = await IOManager.readFile("shows.json");
    }
    return showsJson;
  }
}

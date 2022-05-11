import 'dart:convert';
import 'package:universal_io/io.dart';

import 'package:flutter_test_1/entities/show.dart';
import 'package:flutter_test_1/secret/secret.dart';

class TVMazeClient {
  final String token = Secret.tvMazeToken;
  final String baseUri = "https://api.tvmaze.com/";

  Future<ShowList> getShows() async {
    return ShowList.fromJson(jsonDecode(await _getShowsAsync()));
  }

  /// GET shows : raw JSON
  Future<String> _getShowsAsync() async {
    var client = HttpClient();

    // I know this is bad, but my phone is also bad :)
    client.badCertificateCallback = (cert, host, port) => true;
    var request = await client.getUrl(Uri.parse(baseUri + "shows"));

    var response = await request.close();

    return await response.transform(const Utf8Decoder()).join();
  }
}

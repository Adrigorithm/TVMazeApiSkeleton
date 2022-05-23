import 'dart:convert';
import 'package:path_provider/path_provider.dart';
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
    String showsJson = "";

    try {
      var client = HttpClient();

      // I know this is bad, but my phone is also bad :)
      client.badCertificateCallback = (cert, host, port) => true;
      var request = await client.getUrl(Uri.parse(baseUri + "shows"));

      var response = await request.close();
      showsJson = await response.transform(const Utf8Decoder()).join();
      _writeShowsCache(showsJson);
    } catch (e) {
      showsJson = await _readShowsCache();
    }

    return showsJson;
  }

  void _writeShowsCache(String data) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(directory.path + "/shows.json");

    await file.writeAsString(data);
  }

  Future<String> _readShowsCache() async {
    final file =
        File((await getApplicationDocumentsDirectory()).path + "/shows.json");

    return file.existsSync() ? await file.readAsString() : "";
  }
}

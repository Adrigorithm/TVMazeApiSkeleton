// Minimalistic model
class Show {
  Show(this.id, this.name, this.genres, this.premiered, this.rating, this.image,
      this.summary, this.isFavourite);

  final int id;
  final String name;
  final List<dynamic> genres;
  final String premiered;
  final Map<String, dynamic> rating;
  final Map<String, dynamic> image;
  final String summary;
  bool isFavourite;

  /// Data model abstraction
  factory Show.fromJson(Map<String, dynamic> data) {
    return Show(
        data["id"],
        data["name"],
        data["genres"],
        data["premiered"],
        data["rating"],
        data["image"],
        data["summary"],
        data["isFavourite"] ?? false);
  }
}

class ShowList {
  List<Show> shows;

  ShowList(this.shows);

  factory ShowList.fromJson(List<dynamic> parsedData) {
    List<Show> shows = parsedData.map((e) => Show.fromJson(e)).toList();

    return ShowList(shows);
  }
}

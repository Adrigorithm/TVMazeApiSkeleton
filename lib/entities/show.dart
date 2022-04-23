// Minimalistic model
class Show {
  Show(this.id, this.name, this.genres, this.premiered, this.rating, this.image,
      this.summary);

  final int id;
  final String name;
  final List<dynamic> genres;
  final String premiered;
  final Map<String, dynamic> rating;
  final Map<String, dynamic> image;
  final String summary;

  factory Show.fromJson(Map<String, dynamic> data) {
    return Show(data["id"], data["name"], data["genres"], data["premiered"],
        data["rating"], data["image"], data["summary"]);
  }
}

class ShowList {
  final List<Show> shows;

  ShowList(this.shows);

  factory ShowList.fromJson(List<dynamic> parsedData) {
    List<Show> shows = parsedData.map((e) => Show.fromJson(e)).toList();

    return ShowList(shows);
  }
}

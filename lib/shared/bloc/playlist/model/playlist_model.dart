class PlaylistModel {
  List<Movies>? moviesList;
  String? description;
  String? title;
  String? type;

  PlaylistModel({this.moviesList, this.description, this.title, this.type});

  PlaylistModel.fromJson(Map<String, dynamic> json) {
    moviesList = [];
    if (json['movies_list'] != null && json['movies_list']?.isNotEmpty) {
      json['movies_list'].forEach((v) {
        moviesList?.add(Movies.fromJson(v));
      });
    }
    description = json['description'];
    title = json["title"];
    type = json["type"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (moviesList != null) {
      data['movies_list'] = moviesList?.map((v) => v.toJson()).toList();
    }
    data['description'] = description;
    data["title"] = title;
    data["type"] = type;
    return data;
  }
}

class Movies {
  Image? image;
  String? titleType;
  int? year;
  String? id;
  String? title;

  Movies({this.image, this.titleType, this.year, this.id, this.title});

  Movies.fromJson(Map<String, dynamic> json) {
    image = json['image'] != null ? new Image.fromJson(json['image']) : null;
    titleType = json['titleType'];
    year = json['year'];
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.image != null) {
      data['image'] = this.image?.toJson();
    }
    data['titleType'] = this.titleType;
    data['year'] = this.year;
    data['id'] = this.id;
    data['title'] = this.title;
    return data;
  }
}

class Image {
  int? width;
  String? id;
  String? url;
  int? height;

  Image({this.width, this.id, this.url, this.height});

  Image.fromJson(Map<String, dynamic> json) {
    width = json['width'];
    id = json['id'];
    url = json['url'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['width'] = this.width;
    data['id'] = this.id;
    data['url'] = this.url;
    data['height'] = this.height;
    return data;
  }
}

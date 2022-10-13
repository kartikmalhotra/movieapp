class MoviesList {
  String? type;
  String? paginationKey;
  List<Results>? results;
  int? totalMatches;

  MoviesList({
    this.type,
    this.paginationKey,
    this.results,
    this.totalMatches,
  });

  MoviesList.fromJson(Map<String, dynamic> json) {
    type = json['@type'];
    paginationKey = json['paginationKey'];
    if (json['results'] != null) {
      results = [];
      json['results'].forEach((v) {
        results?.add(Results.fromJson(v));
      });
    }
    totalMatches = json['totalMatches'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['@type'] = type;
    data['paginationKey'] = paginationKey;
    if (results != null) {
      data['results'] = results?.map((v) => v.toJson()).toList();
    }
    data['totalMatches'] = totalMatches;
    return data;
  }
}

class Results {
  String? id;
  ImageModel? image;
  String? title;
  String? titleType;
  int? year;

  Results({this.id, this.image, this.title, this.titleType, this.year});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'] != null ? ImageModel.fromJson(json['image']) : null;
    title = json['title'];
    titleType = json['titleType'];
    year = json['year'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    if (image != null) {
      data['image'] = image?.toJson();
    }
    data['title'] = title;
    data['titleType'] = titleType;
    data['year'] = year;
    return data;
  }
}

class ImageModel {
  int? height;
  String? id;
  String? url;
  int? width;

  ImageModel({this.height, this.id, this.url, this.width});

  ImageModel.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    id = json['id'];
    url = json['url'];
    width = json['width'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['height'] = height;
    data['id'] = id;
    data['url'] = url;
    data['width'] = width;
    return data;
  }
}

class HashtagGroups {
  List<Hashtags>? items;

  HashtagGroups({this.items});

  HashtagGroups.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Hashtags>[];
      json['items'].forEach((v) {
        items!.add(Hashtags.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Hashtags {
  String? sId;
  String? title;
  String? removeHashTitle;
  String? userId;
  String? createdAt;
  String? updatedAt;
  String? groupId;
  int? iV;

  Hashtags({
    this.sId,
    this.title,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.groupId,
    this.iV,
    this.removeHashTitle,
  });

  Hashtags.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = "#" + json['title'];
    removeHashTitle = json['title'];
    userId = json['userId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    groupId = json['groupId'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['title'] = title;
    data['userId'] = userId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['groupId'] = groupId;
    data['__v'] = iV;
    return data;
  }
}

class ImageHashtags {
  List<String>? hashtags;

  ImageHashtags({this.hashtags});

  ImageHashtags.fromJson(Map<String, dynamic> json) {
    hashtags = json['hashtags']?.cast<String>() ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hashtags'] = this.hashtags;
    return data;
  }
}

class FolderList {
  List<Folders>? items;

  FolderList(this.items);

  FolderList.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items!.add(new Folders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Folders {
  String? sId;
  int? count;
  String? title;
  String? userId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Folders({
    this.sId,
    this.count,
    this.title,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  Folders.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    count = json['count'];
    title = json['title'];
    userId = json['userId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['count'] = this.count;
    data['title'] = this.title;
    data['userId'] = this.userId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

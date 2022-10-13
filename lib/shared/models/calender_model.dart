class CalenderList {
  List<CalenderModel>? items;

  CalenderList({this.items});

  CalenderList.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <CalenderModel>[];
      json['items'].forEach((v) {
        items!.add(CalenderModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CalenderModel {
  String? sId;
  String? name;
  String? userId;
  String? createdAt;
  String? updatedAt;
  int? iV;
  bool? showReconnect;

  CalenderModel({
    this.sId,
    this.name,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.showReconnect,
  });

  CalenderModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    userId = json['userId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    showReconnect = json['showReconnect'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = sId;
    data['name'] = name;
    data['userId'] = userId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['showReconnect'] = showReconnect;
    return data;
  }
}

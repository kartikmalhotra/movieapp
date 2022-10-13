class CategoryList {
  List<CategoryModel>? categoryModel;

  CategoryList({this.categoryModel});

  CategoryList.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      categoryModel = <CategoryModel>[];
      json['items'].forEach((v) {
        categoryModel!.add(CategoryModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (categoryModel != null) {
      data['items'] = categoryModel!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategoryModel {
  String? sId;
  int? count;
  bool? readonly;
  String? userId;
  String? title;
  String? createdAt;
  String? updatedAt;
  int? iV;

  CategoryModel({
    this.sId,
    this.count,
    this.readonly,
    this.userId,
    this.title,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  CategoryModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    count = json['count'];
    readonly = json['readonly'];
    userId = json['userId'];
    title = json['title'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['count'] = count;
    data['readonly'] = readonly;
    data['userId'] = userId;
    data['title'] = title;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

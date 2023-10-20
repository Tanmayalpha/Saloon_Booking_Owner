class GenderModel {
  String id;
  String name;

  GenderModel({this.id, this.name});

  GenderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['text']!=null?json['text']:json['name'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
class CatModel {
  int id;
  String title;
  int status;
  String salonCategoryId;
  String createdAt;
  String updatedAt;

  CatModel(
      {this.id,
        this.title,
        this.status,
        this.salonCategoryId,
        this.createdAt,
        this.updatedAt});

  CatModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    status = json['status'];
    salonCategoryId = json['salon_category_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['status'] = this.status;
    data['salon_category_id'] = this.salonCategoryId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
class StateModel {
  int id;
  String name;
  int countryId;
  List<City> city;

  StateModel({this.id, this.name, this.countryId, this.city});

  StateModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    countryId = json['country_id'];
    if (json['city'] != null) {
      city = <City>[];
      json['city'].forEach((v) {
        city.add(new City.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['country_id'] = this.countryId;
    if (this.city != null) {
      data['city'] = this.city.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class City {
  int id;
  String city;
  int stateId;

  City({this.id, this.city, this.stateId});

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    city = json['city'];
    stateId = json['state_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['city'] = this.city;
    data['state_id'] = this.stateId;
    return data;
  }
}

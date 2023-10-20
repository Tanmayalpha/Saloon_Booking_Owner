import 'package:flutter/material.dart';

import 'e_service_model.dart';
import 'media_model.dart';
import 'parents/model.dart';

class Category extends Model {
  String id;
  String name;
  String description;
  Color color;
  Media image;
  bool selected = false;
  bool featured;
  List<Category> subCategories;
  List<EService> eServices;
  List<ServiceModel> services;
  Category({this.id, this.name, this.description, this.color, this.image, this.featured, this.subCategories, this.eServices,this.selected});

  Category.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    name = transStringFromJson(json, 'name');
    color = colorFromJson(json, 'color');
    description = transStringFromJson(json, 'description');
    image = mediaFromJson(json, 'image');
    featured = boolFromJson(json, 'featured');
    eServices = listFromJsonArray(json, ['e_services', 'featured_e_services'], (v) => EService.fromJson(v));
    subCategories = listFromJson(json, 'sub_categories', (v) => Category.fromJson(v));
    services = listFromJson(json, 'services', (v) => ServiceModel.fromJson(v));
    selected = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['color'] = '#${this.color.value.toRadixString(16)}';
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is Category &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          color == other.color &&
          image == other.image &&
          featured == other.featured &&
          subCategories == other.subCategories &&
          eServices == other.eServices;

  @override
  int get hashCode =>
      super.hashCode ^ id.hashCode ^ name.hashCode ^ description.hashCode ^ color.hashCode ^ image.hashCode ^ featured.hashCode ^ subCategories.hashCode ^ eServices.hashCode;
}
class ServiceModel {
  int id;
  String name;
  int categoryId;
  int subCategoryId;
  String price;
  String gender;
  String genderText;
  String duration;
  String createdAt;
  String updatedAt;

  ServiceModel(
      {this.id,
        this.name,
        this.categoryId,
        this.subCategoryId,
        this.gender,
        this.genderText,
        this.price,
        this.duration,
        this.createdAt,
        this.updatedAt});

  ServiceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    gender =json['gender'];
    genderText = json['gender_text'];
    categoryId = json['category_id'];
    subCategoryId = json['sub_category_id'];
    price = json['price'] ?? '';
    duration = json['duration'] ?? '';
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['category_id'] = this.categoryId;
    data['sub_category_id'] = this.subCategoryId;
    data['price'] = this.price;
    data['duration'] = this.duration;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
class BankModel {
  int id;
  String name;
  int status;
  String createdAt;
  String updatedAt;

  BankModel({this.id, this.name, this.status, this.createdAt, this.updatedAt});

  BankModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

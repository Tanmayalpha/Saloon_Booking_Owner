/*
 * File name: address_model.dart
 * Last modified: 2022.10.16 at 12:23:16
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'dart:math';

import 'package:beauty_salons_owner/app/models/main_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'parents/model.dart';

class Address extends Model {
  String id;
  String description;
  String address;
  String zipCode;
  StateModel state;
  double latitude;
  double longitude;
  bool isDefault;
  String state_id;
  String city_id;
  String userId;
  City city;
  Address({this.id,this.city,this.state, this.state_id,this.city_id,this.zipCode,this.description, this.address, this.latitude, this.longitude, this.isDefault, this.userId});

  Address.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    description = stringFromJson(json, 'description').replaceAll('\n', ' ');
    address = stringFromJson(json, 'address').replaceAll('\n', ' ');
    latitude = doubleFromJson(json, 'latitude', defaultValue: null, decimal: 10);
    longitude = doubleFromJson(json, 'longitude', defaultValue: null, decimal: 10);
    isDefault = boolFromJson(json, 'default');
    city = objectFromJson(json, 'city', (v) => City.fromJson(v));
    state = objectFromJson(json, 'state', (v) => StateModel.fromJson(v));
    state_id = stringFromJson(json, 'state_id');
    zipCode = stringFromJson(json, 'zip_code');
    city_id = stringFromJson(json, 'city_id');
    userId = stringFromJson(json, 'user_id');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['zip_code'] = this.zipCode;
    data['default'] = this.isDefault;
    if (this.state != null) {
      data['state_id'] = this.state.id;
    }
    if (this.city != null) {
      data['city_id'] = this.city.id;
    }
    if (this.userId != null) {
      data['user_id'] = this.userId;
    }
    return data;
  }

  bool isUnknown() {
    return latitude == null || longitude == null;
  }

  String get getDescription {
    if (hasDescription()) return description;
    return address.substring(0, min(address.length, 10));
  }

  bool hasDescription() {
    if (description != null && description.isNotEmpty) return true;
    return false;
  }

  LatLng getLatLng() {
    if (this.isUnknown()) {
      return LatLng(38.806103, 52.4964453);
    } else {
      return LatLng(this.latitude, this.longitude);
    }
  }
}

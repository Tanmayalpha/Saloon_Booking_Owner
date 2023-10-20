/*
 * File name: salon_model.dart
 * Last modified: 2022.10.16 at 12:23:16
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'dart:core';

import 'package:beauty_salons_owner/app/models/main_model.dart';
import 'package:flutter/material.dart';

import '../../common/uuid.dart';
import 'address_model.dart';
import 'availability_hour_model.dart';
import 'media_model.dart';
import 'parents/model.dart';
import 'review_model.dart';
import 'salon_level_model.dart';
import 'tax_model.dart';
import 'user_model.dart';

class Salon extends Model {
  String id;
  String name;
  String code;
  String cash_balance;
  String online_balance;
  String ownerName;
  String email;
  String salonType;
  String password;
  String description;
  List<Media> images;
  String phoneNumber;

  List<Media> panImage;
  List<Media> businessImage;
  int bankId;
  String pan_no;
  String gst_no;
  String account_no;String confirm_account_no;
  String ifsc_code;
  String is_kyc;
  String account_holder;
  String bank_name;
  String branch_name;
  String fbLink;
  String instaLink;
  String websiteLink;
  String closedMessage;
  String mobileNumber;
  SalonLevel salonLevel;
  GenderModel genders;
  GenderModel partners;
  List<GenderModel> amenities;
  CatModel salonCategory;
  List<AvailabilityHour> availabilityHours;
  double availabilityRange;
  double distance;
  bool closed;
  bool accepted;
  bool featured;
  Address address;
  List<Tax> taxes;
  String totalSeat;
  List<User> employees;
  double rate;
  List<Review> reviews;
  int totalReviews;
  bool verified;
  bool subscription;
  String subscriptionEndDate;
  Salon(
      {this.id,
      this.name,
      this.description,
        this.code,
        this.salonType,
        this.accepted,
        this.subscription,
        this.subscriptionEndDate,
        this.cash_balance,
        this.closedMessage,
        this.confirm_account_no,
        this.online_balance,
        this.panImage,
        this.bankId,
        this.businessImage,
        this.pan_no,
        this.gst_no,
        this.account_no,
        this.ifsc_code,
        this.is_kyc,
        this.account_holder,
        this.bank_name,
        this.branch_name,
      this.images,
        this.amenities,
        this.fbLink,
        this.websiteLink,
        this.totalSeat,
        this.instaLink,
      this.phoneNumber,
      this.mobileNumber,
      this.salonLevel,
      this.availabilityHours,
      this.availabilityRange,
      this.distance,
      this.closed,
      this.featured,
      this.address,
      this.employees,
      this.rate,
      this.reviews,
      this.totalReviews,
      this.verified});

  Salon.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
  //  panImage = mediaListFromJson(json, 'panImage');
  //  businessImage = mediaListFromJson(json, 'businessImage');
    code = stringFromJson(json, 'code');
    salonType = stringFromJson(json, 'salon_type');
    subscription = boolFromJson(json, 'subscription');
    subscriptionEndDate = json['subscription_end_date'].toString();
    cash_balance = stringFromJson(json, 'cash_balance');
    closedMessage = stringFromJson(json, 'closed_message');
    online_balance = stringFromJson(json, 'online_balance');
    branch_name = stringFromJson(json, 'branch_name');
    bank_name = stringFromJson(json, 'bank_name');
    account_holder = stringFromJson(json, 'account_holder');
    is_kyc = stringFromJson(json, 'is_kyc');
    ifsc_code = stringFromJson(json, 'ifsc_code');
    account_no = stringFromJson(json, 'account_no');
    confirm_account_no = stringFromJson(json, 'account_no');
    gst_no = stringFromJson(json, 'gst_no');
    pan_no = stringFromJson(json, 'pan_no');
    name = transStringFromJson(json, 'name');
    description = transStringFromJson(json, 'description', defaultValue: null);
    images = mediaListFromJson(json, 'images');
    phoneNumber = stringFromJson(json, 'phone_number');
    fbLink = stringFromJson(json, 'fb_link');
    totalSeat = stringFromJson(json, 'total_seat');
    instaLink = stringFromJson(json, 'insta_link');
    websiteLink = stringFromJson(json, 'website_link');
    mobileNumber = stringFromJson(json, 'mobile_number');
    genders = objectFromJson(json, 'salon_gender_type', (v) => GenderModel.fromJson(v));
    partners = objectFromJson(json, 'salon_partner_size', (v) => GenderModel.fromJson(v));
    amenities = listFromJson(json, 'amenities', (v) => GenderModel.fromJson(v));
    salonCategory = objectFromJson(json, 'salon_category', (v) => CatModel.fromJson(v));
    salonLevel = objectFromJson(json, 'salon_level', (v) => SalonLevel.fromJson(v));
    availabilityHours = listFromJson(json, 'availability_hours', (v) => AvailabilityHour.fromJson(v));
    availabilityRange = doubleFromJson(json, 'availability_range');
    distance = doubleFromJson(json, 'distance');
    closed = boolFromJson(json, 'closed');
    accepted = boolFromJson(json, 'accepted');
    featured = boolFromJson(json, 'featured');
    address = objectFromJson(json, 'address', (v) => Address.fromJson(v));
    taxes = listFromJson(json, 'taxes', (v) => Tax.fromJson(v));
    employees = listFromJson(json, 'users', (v) => User.fromJson(v));
    rate = doubleFromJson(json, 'rate');
    reviews = listFromJson(json, 'salon_reviews', (v) => Review.fromJson(v));
    totalReviews = reviews.isEmpty ? intFromJson(json, 'total_reviews') : reviews.length;
    verified = boolFromJson(json, 'verified');
  }

  Map<String, dynamic> toJson() {

    final Map<String, dynamic> data = Map<String, dynamic>();
    if (id != null) data['id'] = this.id;
    if (name != null) data['name'] = this.name;
    if (ownerName != null) data['owner_name'] = this.ownerName;
    if (email != null) data['email'] = this.email;
    if (password != null) data['password'] = this.password;
    if (description != null) data['description'] = this.description;
    if (closed != null) data['closed'] = this.closed;
    if (phoneNumber != null) data['phone_number'] = this.phoneNumber;
    if (mobileNumber != null) data['mobile_number'] = this.mobileNumber;
    if (rate != null) data['rate'] = this.rate;
    if (totalReviews != null) data['total_reviews'] = this.totalReviews;
    if (verified != null) data['verified'] = this.verified;
    if (distance != null) data['distance'] = this.distance;
    if (this.salonLevel != null) {
      data['salon_level_id'] = this.salonLevel.id;
    }
    if (this.images != null) {
      data['image'] = this.images.where((element) => Uuid.isUuid(element.id)).map((v) => v.id).toList();
    }
    if (this.address != null) {
      data['address_id'] = this.address.id;
    }
    if (this.partners != null) {
      data['partner_size'] = this.partners.id;
    }
    if (this.employees != null) {
      data['employees'] = this.employees.map((v) => v?.id).toList();
    }
    if (this.taxes != null) {
      data['taxes'] = this.taxes.map((v) => v?.id).toList();
    }
    if (this.genders != null) {
      data['salon_type'] = this.genders.id;
    }
    if (this.salonCategory != null) {
      data['salon_category_id'] = this.salonCategory.id;;
    }
    if (this.availabilityRange != null) {
      data['availability_range'] = availabilityRange;
    }
    return data;
  }

  String get firstImageUrl => this.images?.first?.url ?? '';

  String get firstImageThumb => this.images?.first?.thumb ?? '';

  String get firstImageIcon => this.images?.first?.icon ?? '';

  @override
  bool get hasData {
    return id != null && name != null;
  }

  Map<String, List<AvailabilityHour>> groupedAvailabilityHours() {
    Map<String, List<AvailabilityHour>> result = {};
    this.availabilityHours.forEach((element) {
      if (result.containsKey(element.day)) {
        result[element.day].add(element);
      } else {
        result[element.day] = [element];
      }
    });
    return result;
  }

  List<String> getAvailabilityHoursData(String day) {
    List<String> result = [];
    this.availabilityHours.forEach((element) {
      if (element.day == day) {
        result.add(element.data);
      }
    });
    return result;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is Salon &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          images == other.images &&
          phoneNumber == other.phoneNumber &&
          mobileNumber == other.mobileNumber &&
          salonLevel == other.salonLevel &&
          availabilityRange == other.availabilityRange &&
          distance == other.distance &&
          closed == other.closed &&
          featured == other.featured &&
          address == other.address &&
          rate == other.rate &&
          reviews == other.reviews &&
          totalReviews == other.totalReviews &&
          verified == other.verified;

  @override
  int get hashCode =>
      super.hashCode ^
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      images.hashCode ^
      phoneNumber.hashCode ^
      mobileNumber.hashCode ^
      salonLevel.hashCode ^
      availabilityRange.hashCode ^
      distance.hashCode ^
      closed.hashCode ^
      featured.hashCode ^
      address.hashCode ^
      rate.hashCode ^
      reviews.hashCode ^
      totalReviews.hashCode ^
      verified.hashCode;
}

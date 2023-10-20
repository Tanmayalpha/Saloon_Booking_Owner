/*
 * File name: salon_repository.dart
 * Last modified: 2022.10.16 at 12:23:14
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:beauty_salons_owner/app/models/offer_model.dart';
import 'package:beauty_salons_owner/app/models/query_model.dart';
import 'package:get/get.dart';

import '../models/address_model.dart';
import '../models/availability_hour_model.dart';
import '../models/award_model.dart';
import '../models/e_service_model.dart';
import '../models/experience_model.dart';
import '../models/gallery_model.dart';
import '../models/review_model.dart';
import '../models/salon_level_model.dart';
import '../models/salon_model.dart';
import '../models/tax_model.dart';
import '../models/user_model.dart';
import '../providers/laravel_provider.dart';

class SalonRepository {
  LaravelApiClient _laravelApiClient;

  SalonRepository() {
    this._laravelApiClient = Get.find<LaravelApiClient>();
  }

  Future<Salon> get(String salonId) {
    return _laravelApiClient.getSalon(salonId);
  }

  Future<Map> paymentDone(String orderId, amount) {
    return _laravelApiClient.paymentDone(orderId, amount);
  }
  Future<Map> subscribe(String salonId,String orderId,String amount,String type,String time) {
    return _laravelApiClient.subscribe(salonId,orderId, amount,type,time);
  }
  Future<Map> getBank(String salonId) {
    return _laravelApiClient.getBank(salonId);
  }

  Future<List<Salon>> getAll() {
    return _laravelApiClient.getSalons(null);
  }

  Future<Map> getInsight({String toDate, fromDate}) {
    return _laravelApiClient.getInsight(toDate, fromDate);
  }

  Future<Map> getContact() {
    return _laravelApiClient.getContact();
  }
  Future<Map> deleteBooking(String employeeId) {
    return _laravelApiClient.deleteBooking(employeeId);
  }
  Future<Map> countBooking(String from,String to) {
    return _laravelApiClient.countBooking(from,to);
  }
  Future<List<OfferModel>> getOffer({String type}) {
    return _laravelApiClient.getOffer(type);
  }

  Future<Map> onOffOffer(status) {
    return _laravelApiClient.onOffOffer(status);
  }

  Future<Map> deleteOffer(id) {
    return _laravelApiClient.deleteOffer(id);
  }

  Future<Map> updateSeats(Map param) {
    return _laravelApiClient.updateSeats(param);
  }

  Future<Map> updateDuty(Map param) {
    return _laravelApiClient.updateDuty(param);
  }

  Future<String> updateQuery(Map param) {
    return _laravelApiClient.updateQuery(param);
  }
  Future<List<QueryModel>> getQuery() {
    return _laravelApiClient.getContactQuery();
  }
  Future<String> addOffer(Map param) {
    return _laravelApiClient.addOffer(param);
  }

  Future<List<Review>> getReviews() {
    return _laravelApiClient.getSalonReviews();
  }

  Future<Review> getReview(String reviewId) {
    return _laravelApiClient.getSalonReview(reviewId);
  }

  Future<List<Gallery>> getGalleries(String salonId) {
    return _laravelApiClient.getSalonGalleries(salonId);
  }

  Future<List<Award>> getAwards(String salonId) {
    return _laravelApiClient.getSalonAwards(salonId);
  }

  Future<List<Experience>> getExperiences(String salonId) {
    return _laravelApiClient.getSalonExperiences(salonId);
  }

  Future<List<EService>> getEServices({String salonId, int page}) {
    return _laravelApiClient.getSalonEServices(salonId, page);
  }

  Future<Map> getEServices1({String salonId, int page}) {
    return _laravelApiClient.getEServices1();
  }

  Future<List<User>> getAllEmployees() {
    return _laravelApiClient.getAllEmployees();
  }

  Future<List<Tax>> getTaxes() {
    return _laravelApiClient.getTaxes();
  }

  Future<List<User>> getEmployees(String salonId) {
    return _laravelApiClient.getSalonEmployees(salonId);
  }

  Future<List<EService>> getPopularEServices({String salonId, int page}) {
    return _laravelApiClient.getSalonPopularEServices(salonId, page);
  }

  Future<List<EService>> getAvailableEServices({String salonId, int page}) {
    return _laravelApiClient.getSalonAvailableEServices(salonId, page);
  }

  Future<List<EService>> getFeaturedEServices({String salonId, int page}) {
    return _laravelApiClient.getSalonFeaturedEServices(salonId, page);
  }

  Future<List<Salon>> getSalons({int page}) {
    print('okay');
    return _laravelApiClient.getSalons(page);
  }

  Future<List<SalonLevel>> getSalonLevels() {
    return _laravelApiClient.getSalonLevels();
  }

  /**
   * Get the User's address
   */
  Future<List<Address>> getAddresses() {
    return _laravelApiClient.getAddresses();
  }

  /**
   * Create a User's address
   */
  Future<Address> createAddress(Address address) {
    return _laravelApiClient.createAddress(address);
  }

  Future<Address> updateAddress(Address address) {
    return _laravelApiClient.updateAddress(address);
  }

  Future<Address> deleteAddress(Address address) {
    return _laravelApiClient.deleteAddress(address);
  }

  Future<List<AvailabilityHour>> getAvailabilityHours(Salon salon) {
    return _laravelApiClient.getAvailabilityHours(salon);
  }

  Future<bool> createAvailabilityHourNew(Map data) {
    return _laravelApiClient.createAvailabilityHourNew(data);
  }

  Future<AvailabilityHour> createAvailabilityHour(
      AvailabilityHour availabilityHour) {
    return _laravelApiClient.createAvailabilityHour(availabilityHour);
  }

  Future<AvailabilityHour> deleteAvailabilityHour(
      AvailabilityHour availabilityHour) {
    return _laravelApiClient.deleteAvailabilityHour(availabilityHour);
  }

  Future<List<Salon>> getAcceptedSalons({int page}) {
    return _laravelApiClient.getAcceptedSalons(page);
  }

  Future<List<Salon>> getFeaturedSalons({int page}) {
    return _laravelApiClient.getFeaturedSalons(page);
  }

  Future<List<Salon>> getPendingSalons({int page}) {
    return _laravelApiClient.getPendingSalons(page);
  }

  Future<Salon> create(Salon salon) {
    return _laravelApiClient.createSalon(salon);
  }

  Future<bool> createAmenities(Map data) {
    return _laravelApiClient.createAmenities(data);
  }

  Future<bool> createService(Map data) {
    return _laravelApiClient.createService(data);
  }

  Future<bool> createBank(Map data) {
    return _laravelApiClient.createBank(data);
  }

  Future<Salon> update(Salon salon) {
    return _laravelApiClient.updateSalon(salon);
  }

  Future<Salon> delete(Salon salon) {
    return _laravelApiClient.deleteSalon(salon);
  }
}

import 'package:get/get.dart';

import '../models/booking_model.dart';
import '../models/booking_status_model.dart';
import '../providers/laravel_provider.dart';

class BookingRepository {
  LaravelApiClient _laravelApiClient;

  BookingRepository() {
    this._laravelApiClient = Get.find<LaravelApiClient>();
  }

  Future<List<Booking>> all(String statusId, {int page,String seat,date,toDate}) {
    print(statusId);
    return _laravelApiClient.getBookings(statusId, page,seat,date,toDate);
  }
  Future<bool> submitOTP(String bookingId,otp) {
    print(bookingId);
    return _laravelApiClient.submitOTP(bookingId, otp);
  }

  Future<Map> getStatuses() {
    return _laravelApiClient.getBookingStatuses();
  }

  Future<Booking> get(String bookingId) {
    return _laravelApiClient.getBooking(bookingId);
  }

  Future<Booking> update(Booking booking) {
    return _laravelApiClient.updateBooking(booking);
  }
}

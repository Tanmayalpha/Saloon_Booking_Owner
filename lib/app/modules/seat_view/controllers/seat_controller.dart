import 'package:beauty_salons_owner/app/models/payment_model.dart';
import 'package:beauty_salons_owner/app/models/payment_status_model.dart';
import 'package:beauty_salons_owner/app/repositories/payment_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as Intl;
import 'package:intl/intl.dart';
import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../../models/booking_status_model.dart';
import '../../../models/statistic.dart';
import '../../../models/user_model.dart';
import '../../../repositories/booking_repository.dart';
import '../../../repositories/statistic_repository.dart';
import '../../../services/global_service.dart';
import '../../root/controllers/root_controller.dart';

class SeatController extends GetxController {
  StatisticRepository _statisticRepository;
  BookingRepository _bookingsRepository;
  final statistics = <Statistic>[].obs;
  final bookings = <Booking>[].obs;
  final seats = <User>[].obs;
  final seatId = Rxn<String>();
  final selectedDate = "".obs;
  final bookingStatuses = <BookingStatus>[].obs;
  final filterStatuses = <BookingStatus>[].obs;
  final page = 0.obs;
  final isLoading = true.obs;
  final isDone = false.obs;
  final currentStatus = '1'.obs;
  TextEditingController dateCon = new TextEditingController(text: DateFormat("yyyy-MM-dd").format(DateTime.now()));
  TextEditingController toCon = new TextEditingController(text: DateFormat("yyyy-MM-dd").format(DateTime.now().add(Duration(days: 1))));
  ScrollController scrollController;
  PaymentRepository _paymentRepository;
  SeatController() {
    _statisticRepository = new StatisticRepository();
    _bookingsRepository = new BookingRepository();
    _paymentRepository = PaymentRepository();
  }

  @override
  Future<void> onInit() async {
    currentStatus.value = Get.arguments as String;
    await refreshHome();
    super.onInit();
  }

  @override
  void onClose() {
    scrollController?.dispose();
  }
  Future<DateTime> selectDate(BuildContext context,
      {DateTime startDate, DateTime endDate}) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: startDate ?? DateTime(2015, 8),
        lastDate: endDate??DateTime(2101));
    return picked;
    if (picked != null && picked != selectedDate) {
      selectedDate.value = Intl.DateFormat("yyyy-MM-dd").format(picked);
      dateCon.text = Intl.DateFormat("yyyy-MM-dd").format(picked);
      this.bookings.clear();
      loadBookingsOfStatus(statusId: currentStatus.value);
    }
  }
  Future<void> confirmPaymentBookingService(Booking booking) async {
    try {
      final _payment = new Payment(id: booking.payment.id, paymentStatus: PaymentStatus(id: '2')); //Paid
      final result = await _paymentRepository.update(_payment);

    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

 /* Future<void> declineBookingService(Booking booking) async {
    try {
      if (booking.status.order < Get.find<GlobalService>().global.value.onTheWay) {
        final _status = Get.find<SeatController>().getStatusByOrder(Get.find<GlobalService>().global.value.failed);
        final _booking = new Booking(id: booking.id, cancel: true, status: _status);
        await _bookingsRepository.update(_booking);

      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }*/
  Future refreshHome({bool showMessage = false, String statusId}) async {
    await getBookingStatuses();
 //   await getStatistics();
 //   Get.find<RootController>().getNotificationsCount();
    changeTab(statusId);
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Seat page refreshed successfully".tr));
    }
  }

  void initScrollController() {
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isDone.value) {
      //  loadBookingsOfStatus(statusId: currentStatus.value,from: true);
      }
    });
  }
  Future<void> submitOTP(showOTP,bookingId,otp) async {
    try {
      if(!showOTP){
        int i = bookings.value.indexWhere((element) =>
        element.id.toString() == bookingId.toString());
        if (i != -1) {
          bookings.value
              .elementAt(i)
              .showOtp = true;

        }
        bookings.refresh();
      }else{
        if(otp==""){
          Get.showSnackbar(Ui.ErrorSnackBar(message: "Please enter otp"));
          return;
        }
        bool response = await _bookingsRepository.submitOTP(bookingId, otp);
        if(response){
          refreshHome();
        }
      }

    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
  Future<void> finishBookingService(Booking booking) async {
    try {
      final _status = Get.find<SeatController>().getStatusByOrder(Get.find<GlobalService>().global.value.done);
      var _booking = new Booking(id: booking.id, endsAt: DateTime.now(), status: _status);
      final result = await _bookingsRepository.update(_booking);
      refreshHome();
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
  void changeTab(String statusId) async {
    this.bookings.clear();
    currentStatus.value = statusId ?? currentStatus.value;
    page.value = 0;
    await loadBookingsOfStatus(statusId: currentStatus.value);
  }

  Future getStatistics() async {
    try {
      statistics.assignAll(await _statisticRepository.getHomeStatistics());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getBookingStatuses() async {
    Map data = await _bookingsRepository.getStatuses();
    bookingStatuses.assignAll(data['status']);
    filterStatuses.assignAll(data['filter']);
    seats.assignAll(data['user']);
    if(seats.isNotEmpty){
      seats[0].selected = true;
     seatId.value = seats[0].userId;
      seats.refresh();
      bookings.clear();
      loadBookingsOfStatus(statusId: currentStatus.value);
    }
   // seats.addAll(data['users'].map<User>((obj) => User.fromJson(obj)).toList());
    try {

    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  BookingStatus getStatusByOrder(int order) => bookingStatuses.firstWhere((s) => s.order == order, orElse: () {
        Get.showSnackbar(Ui.ErrorSnackBar(message: "Booking status not found".tr));
        return BookingStatus();
      });

  Future loadBookingsOfStatus({String statusId,bool from = false,bool fromDate = false,}) async {
    isLoading.value = true;
    isDone.value = false;
    if(fromDate&&(dateCon.text==""||toCon.text=="")){
      return;
    }
    if(!from){
       this.bookings.clear();
    }else{
      page.value++;
    }
    List<Booking> _bookings = [];
    if (bookingStatuses.isNotEmpty) {

    }
    debugPrint(statusId);
    _bookings = await _bookingsRepository.all(statusId, page: page.value,seat: seatId.value,date: dateCon.text,toDate: toCon.text);
    if (_bookings.isNotEmpty) {
      bookings.addAll(_bookings);
    } else {
      isDone.value = true;
    }
    try {

    } catch (e) {
      isDone.value = true;
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changeBookingStatus(Booking booking, BookingStatus bookingStatus) async {
    try {
      final _booking = new Booking(id: booking.id, status: bookingStatus);
      await _bookingsRepository.update(_booking);
      bookings.removeWhere((element) => element.id == booking.id);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future<void> acceptBookingService(Booking booking) async {
    final _status = Get.find<SeatController>().getStatusByOrder(Get.find<GlobalService>().global.value.accepted);
    await changeBookingStatus(booking, _status);
    Get.showSnackbar(Ui.SuccessSnackBar(title: "Status Changed".tr, message: "Booking has been accepted".tr));
  }

  Future<void> declineBookingService(Booking booking) async {
    try {
      if (booking.status.order < Get.find<GlobalService>().global.value.onTheWay) {
        final _status = getStatusByOrder(Get.find<GlobalService>().global.value.failed);
        final _booking = new Booking(id: booking.id, cancel: true, status: _status,cancel_by: "owner");
        await _bookingsRepository.update(_booking);
        bookings.removeWhere((element) => element.id == booking.id);
        Get.showSnackbar(Ui.defaultSnackBar(title: "Status Changed".tr, message: "Booking has been declined".tr));
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}

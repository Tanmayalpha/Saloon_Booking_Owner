import 'package:beauty_salons_owner/app/models/payment_model.dart';
import 'package:beauty_salons_owner/app/models/payment_status_model.dart';
import 'package:beauty_salons_owner/app/repositories/payment_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as Intl;
import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../../models/booking_status_model.dart';
import '../../../models/statistic.dart';
import '../../../models/user_model.dart';
import '../../../repositories/booking_repository.dart';
import '../../../repositories/statistic_repository.dart';
import '../../../services/global_service.dart';
import '../../root/controllers/root_controller.dart';

class HomeController extends GetxController {
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
  TextEditingController dateCon = new TextEditingController();
  ScrollController scrollController;
  PaymentRepository _paymentRepository;
  HomeController() {
    _statisticRepository = new StatisticRepository();
    _bookingsRepository = new BookingRepository();
    _paymentRepository = PaymentRepository();
  }

  @override
  Future<void> onInit() async {
    await refreshHome();
    super.onInit();
  }

  @override
  void onClose() {
    scrollController?.dispose();
  }
  Future<void> selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
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
        final _status = Get.find<HomeController>().getStatusByOrder(Get.find<GlobalService>().global.value.failed);
        final _booking = new Booking(id: booking.id, cancel: true, status: _status);
        await _bookingsRepository.update(_booking);

      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }*/
  Future refreshHome({bool showMessage = false, String statusId}) async {
    await getBookingStatuses();
    await getStatistics();
    Get.find<RootController>().getNotificationsCount();
    Get.find<RootController>().getSalons();
    changeTab(statusId);
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Home page refreshed successfully".tr));
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
        int i = bookings.value.indexWhere((element) =>
        element.id.toString() == bookingId.toString());
        if (i != -1) {
          bookings.value
              .elementAt(i)
              .showOtp = true;

        }
        if(otp==""){
          Get.showSnackbar(Ui.ErrorSnackBar(message: "Please enter otp"));
          return;
        }
        bool response = await _bookingsRepository.submitOTP(bookingId, otp);
        if(response){
          Booking _booking = bookings.value
              .elementAt(i);
          showDialog(context: Get.context, builder: (BuildContext context){
            return AlertDialog(
              title: Text(
                  "Payment Method - ${ _booking.payment.paymentStatus.status=="Pending"?"Cash":"Online"}"
              ),
              content: Text(
                  _booking.payment.paymentMethod.name=="Cash"?"Please collect cash after the service":"Online payment already completed"
              ),
              actions: [
                TextButton(onPressed: (){
                  Get.back();
                }, child: Text("OK")),
              ],
            );


          });
          refreshHome();
        }
      }

    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
  Future<void> finishBookingService(Booking booking) async {
    try {
      final _status = Get.find<HomeController>().getStatusByOrder(Get.find<GlobalService>().global.value.done);
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

  Future loadBookingsOfStatus({String statusId,bool from = false}) async {
    isLoading.value = true;
    isDone.value = false;
    if(!from){
       this.bookings.clear();
    }else{
      page.value++;
    }
    List<Booking> _bookings = [];
    if (bookingStatuses.isNotEmpty) {

    }
    debugPrint(statusId);
    _bookings = await _bookingsRepository.all(statusId, page: page.value,seat: seatId.value,date: selectedDate.value);

    _bookings.sort((a,b) => a.bookingAt.compareTo(b.bookingAt));

      bookings.clear();
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
      await refreshHome();
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future<void> acceptBookingService(Booking booking) async {
    final _status = Get.find<HomeController>().getStatusByOrder(Get.find<GlobalService>().global.value.accepted);
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
        await refreshHome();
        Get.showSnackbar(Ui.defaultSnackBar(title: "Status Changed".tr, message: "Booking has been declined".tr));
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
  Future<void> noShowBookingService(Booking booking) async {
    try {
      if (booking.status.order < Get.find<GlobalService>().global.value.onTheWay) {
        final _status = getStatusByOrder(Get.find<GlobalService>().global.value.noShow);
        final _booking = new Booking(id: booking.id, status: _status,cancel: true);
        await _bookingsRepository.update(_booking);
        bookings.removeWhere((element) => element.id == booking.id);
        await refreshHome();
        Get.showSnackbar(Ui.defaultSnackBar(title: "Status Changed".tr, message: "Client not arrived".tr));
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}

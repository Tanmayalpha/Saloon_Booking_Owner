import 'dart:convert';

import 'package:beauty_salons_owner/app/models/main_model.dart';
import 'package:beauty_salons_owner/app/models/salon_model.dart';
import 'package:beauty_salons_owner/app/models/user_model.dart';
import 'package:beauty_salons_owner/app/modules/global_widgets/select_dialog.dart';
import 'package:beauty_salons_owner/app/modules/root/controllers/root_controller.dart';
import 'package:beauty_salons_owner/app/providers/laravel_provider.dart';
import 'package:beauty_salons_owner/app/repositories/salon_repository.dart';
import 'package:beauty_salons_owner/app/services/auth_service.dart';
import 'package:beauty_salons_owner/common/Razorpay.dart';
import 'package:beauty_salons_owner/common/ui.dart';
import 'package:beauty_salons_owner/common/upi_payment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:upi_pay_x/upi_pay.dart';

import '../../../models/offer_model.dart';

class InsightController extends GetxController {
  final Rx<User> currentUser = Get.find<AuthService>().user;
  SalonRepository _salonRepository;
  final onlineBal = "0".obs;
  final cashBal = "0".obs;
  final selectedOffer = true.obs;
  final loading = true.obs;
  final onOffOffer = false.obs;
  final showOffer = false.obs;
  final salon = Salon().obs;
  final offerList = <OfferModel>[].obs;
  final selectedService = ''.obs;
  final selectedFilterDate = ''.obs;
  final discount = '0'.obs;
  final startAt = ''.obs;
  final endAt = ''.obs;
  final selectedDay = ''.obs;
  final bookData = {}.obs;
  final selectedDate = ''.obs;
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  TextEditingController dateCon = new TextEditingController(text: DateFormat("yyyy-MM-dd").format(DateTime.now()));
  TextEditingController toCon = new TextEditingController(text: DateFormat("yyyy-MM-dd").format(DateTime.now().add(Duration(days: 1))));
  bool fromEdit = false;
  String offerId ="";
  final rangeCount = ''.obs;
  final contactData = {}.obs;
  TextEditingController nameCon = new TextEditingController();
  TextEditingController emailCon = new TextEditingController();
  TextEditingController mobileCon = new TextEditingController();
  TextEditingController titleCon = new TextEditingController();
  TextEditingController discountCon = new TextEditingController();
  TextEditingController msgCon = new TextEditingController();
  TextEditingController descCon = new TextEditingController();
  final services = <String>[
    "Services",
    "Booking",
    "Cancellation",
    "Add Settlement",
    //"Refund",
    "Account Creation",
    "Partner Affiliation"
  ].obs;
  final days = <String>[
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ].obs;
  List<ApplicationMeta> apps;
  InsightController() {
    _salonRepository = new SalonRepository();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    /* Get.find<LaravelApiClient>().forceRefresh();
    getInsight();
    getContact();
    getOffer();
    Get.find<LaravelApiClient>().unForceRefresh();*/
  }

  void refresh() {}
  Future<DateTime> selectDate(BuildContext context,
      {DateTime startDate, DateTime endDate,DateTime initialDate}) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate:initialDate ?? DateTime.now(),
        firstDate:startDate ??   DateTime(2015, 8),
        lastDate: endDate??DateTime(2101));
    return picked;

  }
  List<SelectDialogItem<String>> getServices() {
    return services.map((element) {
      return SelectDialogItem(element, element);
    }).toList();
  }

  List<SelectDialogItem<String>> getDay() {
    return days.map((element) {
      return SelectDialogItem(element, element);
    }).toList();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    Get.find<LaravelApiClient>().forceRefresh();
    getInsight();
    getContact();
    getOffer();
    //Get.find<LaravelApiClient>().unForceRefresh();
  }

  void getInsight() async {
    try{
    loading.value = true;
    apps = await UpiPay.getInstalledUpiApplications();
    print(apps.length);
    Map response = await _salonRepository.getInsight(
        toDate: toCon.text, fromDate: dateCon.text);
    loading.value = false;
    if (response['cash_balance'] != null) {
      cashBal.value = response['cash_balance'];
    }
    if (response['off_time_from'] != null) {
      fromDate.text = response['off_time_from'];
    }
    if (response['discount_percent'] != null) {
      discount.value = response['discount_percent'].toString();
    }
    if (response['offer_status'] != null) {
      onOffOffer.value = response['offer_status'] == 1 ? true : false;
    }
    if (response['off_time_to'] != null) {
      toDate.text = response['off_time_to'];
    }
    salon.value = Salon.fromJson(response);
    if (response['online_balance'] != null) {
      onlineBal.value = response['online_balance'];
    }
    if (response['bussiness_insight'] != null) {
      bookData.value = response['bussiness_insight'];
    }}catch(e){

    }
  }

  void getContact() async {
    loading.value = true;
    Map response = await _salonRepository.getContact();
    loading.value = false;
    nameCon.text = currentUser.value.name ?? "";
    emailCon.text = currentUser.value.email ?? "";
    mobileCon.text = currentUser.value.phoneNumber.replaceAll("+91", "") ?? "";
    contactData.value = response;
  }
  void getCountBooking() async {
    loading.value = true;
    Map response = await _salonRepository.countBooking(fromDate.text,toDate.text);
    loading.value = false;
    if(response['success']){
      showDialog(context: Get.context, builder: (BuildContext ctx){
        return AlertDialog(
          title: Text(
            "Off Duty".tr,
            style: Get.textTheme.headline3,
          ),
          content: Text(
              response['data']['counter']==0?"Do you want to proceed?":"You have ${response['data']['counter']} number of bookings – Do you want to cancel all the bookings related to this dates ?"
          ),
          actions: [
            TextButton(onPressed: (){
              Get.back();
            }, child:Text(
              "No".tr,
              style: Get.textTheme.bodyText2,
            ), ),
            TextButton(onPressed: (){
              Get.back();
            updateDuty();
            }, child:Text(
              "Yes".tr,
              style: Get.textTheme.bodyText2,
            ), ),
          ],
        );
      });
    }

  }
  void getDeleteBooking(String employeeId,int index) async {
    loading.value = true;
    Map response = await _salonRepository.deleteBooking(employeeId);
    loading.value = false;
    if(response['success']){
      showDialog(context: Get.context, builder: (BuildContext ctx){
        return AlertDialog(
          title: Text(
            "Delete Seat".tr,
            style: Get.textTheme.headline3,
          ),
          content: Text(
              response['data']['totalbookings']==0?"Do you want to proceed?":"You have ${response['data']['totalbookings']} number of bookings for this seat – Do you want to cancel all the bookings related to this seat ?"
          ),
          actions: [
            TextButton(onPressed: (){
              Get.back();
            }, child:Text(
              "No".tr,
              style: Get.textTheme.bodyText2,
            ), ),
            TextButton(onPressed: (){
              Get.back();
              updateSeats(index, "delete");
            }, child:Text(
              "Yes".tr,
              style: Get.textTheme.bodyText2,
            ), ),
          ],
        );
      });
    }

  }
  void getOffer() async {
    loading.value = true;
    List<OfferModel> _offer = await _salonRepository.getOffer(
        type: selectedOffer.value ? "Flat" : "Utilize");
    loading.value = false;
    offerList.assignAll(_offer);
    if (offerList.isNotEmpty) {
      startAt.value = offerList.elementAt(0).fromTime;
      endAt.value = offerList.elementAt(0).toTime;
    }
    for (int i = 0; i < offerList.length; i++) {
      if (days.contains(offerList[i].day)) {
        days.remove(offerList[i].day);
      }
    }
  }
  void getOnOff() async {
    loading.value = true;
    int status = 0;
    if (onOffOffer.value) {
      status = 1;
    } else {
      status = 0;
    }
    Map response = await _salonRepository.onOffOffer(status);
    loading.value = false;
  }
  void deleteOffer(id) async {
    loading.value = true;
    Map response = await _salonRepository.deleteOffer(id);
    loading.value = false;
    offerList.clear();
    getOffer();
  }

  void onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      fromDate.text =
          '${DateFormat('yyyy-MM-dd').format(args.value.startDate)}';
      // ignore: lines_longer_than_80_chars
      toDate.text =
          '${DateFormat('yyyy-MM-dd').format(args.value.endDate ?? args.value.startDate)}';
    } else if (args.value is DateTime) {
      selectedDate.value = args.value.toString();
    } else if (args.value is List<DateTime>) {
    } else {
      rangeCount.value = args.value.length.toString();
    }
  }

  void onSelectionChanged1(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      fromDate.text =
          '${DateFormat('yyyy-MM-dd').format(args.value.startDate)}';
      // ignore: lines_longer_than_80_chars
      toDate.text =
          '${DateFormat('yyyy-MM-dd').format(args.value.endDate ?? args.value.startDate)}';
    } else if (args.value is DateTime) {
      selectedDate.value = args.value.toString();
    } else if (args.value is List<DateTime>) {
    } else {
      rangeCount.value = args.value.length.toString();
    }
  }

  void upiPayment(amount, context) {
    UpiPayment upiPayment = new UpiPayment(amount, context, (value) {
      if (value.status == UpiTransactionStatus.success) {
        Navigator.pop(context);
        paymentDone(amount, value.txnId.toString());
      } else {
        Get.showSnackbar(
            Ui.ErrorSnackBar(message: "Payment Failed".toString()));
      }
    });
    upiPayment.initPayment();
  }

  void razorPayment(amount, context) {
    RazorPayHelper razorPayHelperPayment =
        new RazorPayHelper(amount, context, (value) {
      if (!value.toString().contains("error")) {
        paymentDone(amount, value.toString());
      } else {
        Get.showSnackbar(
            Ui.ErrorSnackBar(message: "Payment Failed".toString()));
      }
    });
    razorPayHelperPayment.init();
  }

  void paymentDone(amount, orderId) async {
    Map response = await _salonRepository.paymentDone(orderId, amount);
    if (response['success']) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Payment Done".toString()));
    }
  }

  void updateSeats(index, type) async {
    loading.value = true;
    Map param = {};
    if (type == "delete") {
      param['delete_seats'] = salon.value.employees[index].userId;
      salon.update((val) {
        val.employees.removeAt(index);
      });
    }
    if (type == "add") {
      Map data = {
        "name": salon.value.employees[index].name.toString(),
        "seat_no": index.toString(),
      };
      param['new_seats'] = "${[jsonEncode(data)]}";
    }
    if (type == "update") {
      Map data = {
        "name": salon.value.employees[index].name.toString(),
        "seat_no": index.toString(),
        "is_off":salon.value.employees[index].isOff?"1":"0",
        "id": salon.value.employees[index].userId.toString(),
      };
      param['update_seats'] = "${[jsonEncode(data)]}";
    }
    var response = await _salonRepository.updateSeats(param);
    salon.value = Salon.fromJson(response);
    loading.value = false;
    debugPrint(response.toString());
  }

  void updateDuty() async {
    Map param = {};
    param['from_date'] = fromDate.text;
    param['to_date'] = toDate.text;
    var response = await _salonRepository.updateDuty(param);
    salon.value = Salon.fromJson(response);
    if(Get.isRegistered<RootController>()){
      Get.find<RootController>().getSalons();
    }
    Get.showSnackbar(Ui.SuccessSnackBar(message: "Requested Submitted"));
  }
  void updateDuty1(closed) async {
    /*if(DateTime.now().isAfter(DateTime.parse(fromDate.text))){
      Get.showSnackbar(Ui.ErrorSnackBar(message: "Invalid Date"));
      return;
    }*/
    Map param = {};
    param['from_date'] = fromDate.text;
    param['to_date'] = fromDate.text;
    if(!closed){
      param['closed'] = closed;
      param['from_date'] = "";
      param['to_date'] = "";
    }
    fromDate.text = '';
    toDate.text = '';
    var response = await _salonRepository.updateDuty(param);
    salon.value = Salon.fromJson(response);
    if(Get.isRegistered<RootController>()){
      Get.find<RootController>().getSalons();
    }
    Get.showSnackbar(Ui.SuccessSnackBar(message: "Date Cleared"));
    //Get.back();
  }
  void updateQuery() async {
    /*if (nameCon.text == "" ||
        (emailCon.text == ""&&!emailCon.text.contains('@')) ||
        mobileCon.text == "" ||
        descCon.text == "" ||
        selectedService.value == "") {
      Get.showSnackbar(Ui.ErrorSnackBar(
          message: "There are errors in some fields please correct them!".tr));
      return;
    }*/
    if(nameCon.text == ""){
      Get.showSnackbar(Ui.ErrorSnackBar(
          message: "Please Enter Name".tr));
      return;
    }
    if(selectedService.value == ""){
      Get.showSnackbar(Ui.ErrorSnackBar(
          message: "Please Select Service".tr));
      return;
    }
    if(emailCon.text == ""||!emailCon.text.contains('@')){
      Get.showSnackbar(Ui.ErrorSnackBar(
          message: "Please Enter Valid Email".tr));
      return;
    }
    if(mobileCon.text == ""||mobileCon.text.length!=10){
      Get.showSnackbar(Ui.ErrorSnackBar(
          message: "Please Enter Valid Mobile".tr));
      return;
    }

    if(descCon.text == ""){
      Get.showSnackbar(Ui.ErrorSnackBar(
          message: "Please Enter Description".tr));
      return;
    }
    Map param = {};
    param['name'] = nameCon.text;
    param['service'] = selectedService.value;
    param['email'] = emailCon.text;
    param['phone'] = mobileCon.text;
    param['message'] = descCon.text;
    var response = await _salonRepository.updateQuery(param);
    Get.back();
    Get.showSnackbar(Ui.SuccessSnackBar(message: response.toString()));
    debugPrint(response.toString());
  }

  void addOffer() async {
    if (!selectedOffer.value &&
        (discountCon.text == "" ||
            startAt.value == "" ||
            endAt.value == "" ||
            selectedDay.value == "")) {
      Get.showSnackbar(Ui.ErrorSnackBar(
          message: "There are errors in some fields please correct them!".tr));
      return;
    } else {
      if (discountCon.text == "") {
        Get.showSnackbar(Ui.ErrorSnackBar(
            message:
                "There are errors in some fields please correct them!".tr));
        return;
      }
    }
    Map param = {};
    if (selectedDay.value != "") param['day'] = selectedDay.value;
    if (startAt.value != "") param['from_time'] = startAt.value;
    if (endAt.value != "") param['to_time'] = endAt.value;
    if (discountCon.text != "") param['discount'] = discountCon.text;
    if (descCon.text != "") param['message'] = descCon.text;
    if (selectedOffer.value) {
      param['type'] = "Flat";
    } else {
      param['type'] = "Utilize";
    }
    if(offerId!=""){
      param['id'] = offerId;
    }
    var response = await _salonRepository.addOffer(param);
    showOffer.value = false;
    discount.value = discountCon.text;
    getInsight();
    getOffer();
   // Get.back();
   // Get.showSnackbar(Ui.SuccessSnackBar(message: response.toString()));
    debugPrint(response.toString());
  }
}

import 'dart:convert';

import 'package:beauty_salons_owner/app/models/query_model.dart';
import 'package:beauty_salons_owner/app/models/salon_model.dart';
import 'package:beauty_salons_owner/app/models/user_model.dart';
import 'package:beauty_salons_owner/app/modules/global_widgets/select_dialog.dart';
import 'package:beauty_salons_owner/app/providers/laravel_provider.dart';
import 'package:beauty_salons_owner/app/repositories/salon_repository.dart';
import 'package:beauty_salons_owner/app/services/auth_service.dart';
import 'package:beauty_salons_owner/common/ui.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart' show DateFormat;


class ContactController extends GetxController {
  final Rx<User> currentUser = Get.find<AuthService>().user;
  SalonRepository _salonRepository;
  final onlineBal = "0".obs;
  final cashBal = "0".obs;
  final selectedOffer = true.obs;
  final loading = true.obs;
  final onOffOffer = false.obs;
  final showOffer = false.obs;
  final salon = Salon().obs;

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
   // "Refund",
    "Add Settlement",
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

  ContactController() {
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

    getContact();
    getQuery();
    //Get.find<LaravelApiClient>().unForceRefresh();
  }



  void getContact() async {
    loading.value = true;
    nameCon.text = currentUser.value.name ?? "";
    emailCon.text = currentUser.value.email ?? "";
    mobileCon.text = currentUser.value.phoneNumber.replaceAll("+91", "") ?? "";
    Map response = await _salonRepository.getContact();

    loading.value = false;

    contactData.value = response;
  }
  final query = <QueryModel>[].obs;
  Future getQuery() async {
    try {
      query.clear();
      query.assignAll(await _salonRepository.getQuery());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
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
    await getQuery();
    Get.back();
    Get.showSnackbar(Ui.SuccessSnackBar(message: response.toString()));
    debugPrint(response.toString());
  }

}

/*
 * Copyright (c) 2020 .
 */

import 'dart:async';

import 'package:beauty_salons_owner/app/models/salon_model.dart';
import 'package:beauty_salons_owner/app/modules/salons/controllers/salons_controller.dart';
import 'package:beauty_salons_owner/app/providers/laravel_provider.dart';
import 'package:beauty_salons_owner/app/repositories/salon_repository.dart';
import 'package:beauty_salons_owner/app/services/settings_service.dart';
import 'package:beauty_salons_owner/common/Razorpay.dart';
import 'package:beauty_salons_owner/common/ui.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../models/custom_page_model.dart';
import '../../../repositories/custom_page_repository.dart';
import '../../../repositories/notification_repository.dart';
import '../../../routes/app_routes.dart';
import '../../account/views/account_view.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/views/home_view.dart';
import '../../messages/controllers/messages_controller.dart';
import '../../messages/views/messages_view.dart';
import '../../reviews/views/reviews_view.dart';
import 'package:intl/intl.dart';
class RootController extends GetxController {
  final currentIndex = 0.obs;
  final notificationsCount = 0.obs;
  final customPages = <CustomPage>[].obs;
  NotificationRepository _notificationRepository;
  CustomPageRepository _customPageRepository;
  SalonRepository _salonRepository;
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final salons = <Salon>[].obs;
  RootController() {
    _salonRepository = new SalonRepository();
    _notificationRepository = new NotificationRepository();
    _customPageRepository = new CustomPageRepository();
  }
  final loading = false.obs;
  String fromDate = "";
  String toDate = "";
  void updateDuty(closed) async {
    Map param = {};
    param['from_date'] = fromDate;
    param['to_date'] = toDate;
    if(!closed){
      param['closed'] = closed;
      param['from_date'] = "";
      param['to_date'] = "";
    }
    var response = await _salonRepository.updateDuty(param);
    salons[0] = Salon.fromJson(response);
    salons.refresh();
    Get.back();
  }
  void onSelectionChanged1(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
    fromDate =
      '${DateFormat('yyyy-MM-dd').format(args.value.startDate)}';
      // ignore: lines_longer_than_80_chars
     toDate =
      '${DateFormat('yyyy-MM-dd').format(args.value.endDate ?? args.value.startDate)}';
    } else if (args.value is DateTime) {
      fromDate =
      '${DateFormat('yyyy-MM-dd').format(args.value)}';
     toDate =
      '${DateFormat('yyyy-MM-dd').format(args.value)}';
    } else if (args.value is List<DateTime>) {
    } else {

    }
  }
  @override
  void onInit() async {
    await getCustomPages();
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
    getSalons();
    if (Get.arguments != null && Get.arguments is int) {
      changePageInRoot(Get.arguments as int);
    } else {
      changePageInRoot(0);
      await Get.find<HomeController>().refreshHome();
    }
    super.onInit();
  }
  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if(result.name=="none"){
      Get.showSnackbar(
          Ui.ErrorSnackBar(message: "No Internet Connection".toString()));
    }else{
      if(Get.isRegistered<HomeController>()){
        await getCustomPages();
        getSalons();
        await Get.find<HomeController>().refreshHome();
      }
    }
    print(result.name);
  }
  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
  Future getSalons() async {
    try {
      Get.find<LaravelApiClient>().forceRefresh();
      salons.clear();
      loading.value = true;
      final salon = await _salonRepository.getSalons(page: 1);
      print(salon.first.subscriptionEndDate);
      salons.value = salon.toList();
      loading.value = false;
      print(salons.length);
    } catch (e) {
      loading.value = false;
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }

  }

  List<Widget> pages = [
    HomeView(),
    ReviewsView(),
    MessagesView(),
    AccountView(),
  ];
  void razorPayment(context) {
    String amount = Get.find<SettingsService>().setting.value.subscriptionAmount;
    RazorPayHelper razorPayHelperPayment =
    new RazorPayHelper(amount, context, (value) {
      if (!value.toString().contains("error")) {
        paymentDone(amount, value.toString());
      } else {
        Get.closeAllSnackbars();
        Get.showSnackbar(
            Ui.ErrorSnackBar(message: "Payment Failed".toString()));
      }
    });
    razorPayHelperPayment.init();
  }
  void paymentDone(amount, orderId) async {
    String type = Get.find<SettingsService>().setting.value.subscriptionTypeId;
    String time = Get.find<SettingsService>().setting.value.subscriptionTime;
    Map response = await _salonRepository.subscribe(salons.first.id,orderId, amount,type,time);
    if (response['success']) {
      await getSalons();
      if(Get.isRegistered<SalonsController>()){
        print("refresh Salon");
          Get.find<SalonsController>().refreshSalons();
      }
      Get.closeAllSnackbars();
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Payment Done".toString()));
    }
  }
  Widget get currentPage => pages[currentIndex.value];

  /**
   * change page in route
   * */
  void changePageInRoot(int _index) {
    currentIndex.value = _index;
  }

  void changePageOutRoot(int _index) {
    currentIndex.value = _index;
    Get.offNamedUntil(Routes.ROOT, (Route route) {
      if (route.settings.name == Routes.ROOT) {
        return true;
      }
      return false;
    }, arguments: _index);
  }

  Future<void> changePage(int _index) async {
    if (Get.currentRoute == Routes.ROOT) {
      changePageInRoot(_index);
    } else {
      changePageOutRoot(_index);
    }
    await refreshPage(_index);
  }

  Future<void> refreshPage(int _index) async {
    switch (_index) {
      case 0:
        {
          await Get.find<HomeController>().refreshHome();
          break;
        }
      case 2:
        {
          await Get.find<MessagesController>().refreshMessages();
          break;
        }
    }
  }

  void getNotificationsCount() async {
    notificationsCount.value = await _notificationRepository.getCount();
  }

  Future<void> getCustomPages() async {
    customPages.assignAll(await _customPageRepository.all());
  }
}

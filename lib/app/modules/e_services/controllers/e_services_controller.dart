/*
 * File name: e_services_controller.dart
 * Last modified: 2022.10.16 at 12:23:15
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:beauty_salons_owner/app/models/category_model.dart';
import 'package:beauty_salons_owner/app/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/e_service_model.dart';
import '../../../repositories/e_service_repository.dart';
import '../../../repositories/salon_repository.dart';

enum CategoryFilter { ALL, AVAILABILITY, FEATURED, POPULAR }

class EServicesController extends GetxController {
  final selected = Rx<CategoryFilter>(CategoryFilter.ALL);
  final eServices = <EService>[].obs;
  final page = 0.obs;
  final isLoading = true.obs;
  final catIndex = 0.obs;
  final isDone = false.obs;
  final category = <Category>[].obs;
  SalonRepository _salonRepository;
  EServiceRepository _eServiceRepository;
  ScrollController scrollController = ScrollController();
  UserRepository _userRepository;
  EServicesController() {
    _salonRepository = new SalonRepository();
    _eServiceRepository = new EServiceRepository();
    _userRepository = UserRepository();
  }

  @override
  Future<void> onInit() async {
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isDone.value) {
        //loadEServicesOfCategory(filter: selected.value);
      }
    });
    await refreshEServices();
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
  }

  Future refreshEServices({bool showMessage}) async {
    toggleSelected(selected.value);
    category.clear();
    Map data2 = await _salonRepository.getEServices1();
    category.addAll(
        data2['data'].map<Category>((obj) => Category.fromJson(obj)).toList());
    if(category.isNotEmpty){
      catIndex.value = 0;
      category[0].selected=true;
    }

  //  await loadEServicesOfCategory(filter: selected.value);
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "List of services refreshed successfully".tr));
    }
  }

  bool isSelected(CategoryFilter filter) => selected == filter;

  void toggleSelected(CategoryFilter filter) {
    this.eServices.clear();
    this.page.value = 0;
    if (isSelected(filter)) {
      selected.value = CategoryFilter.ALL;
    } else {
      selected.value = filter;
    }
  }

  Future loadEServicesOfCategory({CategoryFilter filter}) async {
    try {
      isLoading.value = true;
      isDone.value = false;
      this.page.value++;
      List<EService> _eServices = [];
      switch (filter) {
        case CategoryFilter.ALL:
          _eServices = await _salonRepository.getEServices(page: this.page.value);
          break;
        case CategoryFilter.FEATURED:
          _eServices = await _salonRepository.getFeaturedEServices(page: this.page.value);
          break;
        case CategoryFilter.POPULAR:
          _eServices = await _salonRepository.getPopularEServices(page: this.page.value);
          break;
        case CategoryFilter.AVAILABILITY:
          _eServices = await _salonRepository.getAvailableEServices(page: this.page.value);
          break;
        default:
          _eServices = await _salonRepository.getEServices(page: this.page.value);
      }
      if (_eServices.isNotEmpty) {
        this.eServices.addAll(_eServices);
      } else {
        isDone.value = true;
      }
    } catch (e) {
      this.isDone.value = true;
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      isLoading.value = false;
    }
  }

  void deleteEService(EService eService) async {
    try {
      await _eServiceRepository.delete(eService.id);
      await refreshEServices();
     // catIndex.value = 0;
      Get.showSnackbar(Ui.SuccessSnackBar(message: eService.name + " " + "has been removed".tr));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}

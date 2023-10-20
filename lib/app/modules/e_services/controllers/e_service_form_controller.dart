import 'package:beauty_salons_owner/app/models/main_model.dart';
import 'package:beauty_salons_owner/app/modules/root/controllers/root_controller.dart';
import 'package:beauty_salons_owner/app/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/category_model.dart';
import '../../../models/e_service_model.dart';
import '../../../models/option_group_model.dart';
import '../../../models/salon_model.dart';
import '../../../repositories/category_repository.dart';
import '../../../repositories/e_service_repository.dart';
import '../../../repositories/salon_repository.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/multi_select_dialog.dart';
import '../../global_widgets/select_dialog.dart';

class EServiceFormController extends GetxController {
  final eService = EService().obs;
  final optionGroups = <OptionGroup>[].obs;
  final categories = <Category>[].obs;
  final salons = <Salon>[].obs;
  final genders = <GenderModel>[].obs;
  final loading = false.obs;
  TextEditingController durationCon  = new TextEditingController();
  GlobalKey<FormState> eServiceForm = new GlobalKey<FormState>();
  EServiceRepository _eServiceRepository;
  CategoryRepository _categoryRepository;
  SalonRepository _salonRepository;
  UserRepository _userRepository;


  EServiceFormController() {
    _userRepository = UserRepository();
    _eServiceRepository = new EServiceRepository();
    _categoryRepository = new CategoryRepository();
    _salonRepository = new SalonRepository();
  }

  @override
  void onInit() async {
    var arguments = Get.arguments as Map<String, dynamic>;
    if (arguments != null) {
      eService.value = arguments['eService'] as EService;
    }
    super.onInit();
    await getData();
  }

  @override
  void onReady() async {
    await refreshEService();
    super.onReady();
  }
  Future getData() async {
    print("okay");
    loading.value = true;
    Map data = await _userRepository.getData();
    loading.value = false;

    genders.addAll(data['gender']
        .map<GenderModel>((obj) => GenderModel.fromJson(obj))
        .toList());
    genders.removeAt(genders.length-1);
    if(eService.value.gender!=null){
      int index = genders.indexWhere((element) => element.id==eService.value.gender);
      if(index!=-1){
        eService.update((val) {
          val.genderText = genders[index].name;
        });
      }

    }
    if(Get.isRegistered<RootController>()&&Get.find<RootController>().salons.first.salonType!="3"){
      eService.update((val) {
        val.gender = Get.find<RootController>().salons.first.salonType;
      });
    }
  }
  Future refreshEService({bool showMessage = false}) async {

    await getEService();
    await getCategories();
    await getSalons();
    await getOptionGroups();
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: eService.value.name + " " + "page refreshed successfully".tr));
    }
  }
  List<SelectDialogItem<GenderModel>> getMultiSelectTaxesItems() {
    return genders.map((element) {
      return SelectDialogItem(element, element.name);
    }).toList();
  }
  Future getEService() async {
    if (eService.value.hasData) {
      try {
        eService.value = await _eServiceRepository.get(eService.value.id);
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      }
    }
    eService.update((val) {
      val.enableAtSalon =true;
      val.enableBooking =true;
    });
  }

  Future getCategories() async {
    try {
      categories.assignAll(await _categoryRepository.getAll());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getSalons() async {
    try {
      salons.assignAll(await _salonRepository.getAll());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  List<MultiSelectDialogItem<Category>> getMultiSelectCategoriesItems() {
    return categories.map((element) {
      return MultiSelectDialogItem(element, element.name);
    }).toList();
  }

  List<SelectDialogItem<Salon>> getSelectSalonsItems() {
    return salons.map((element) {
      return SelectDialogItem(element, element.name);
    }).toList();
  }

  Future getOptionGroups() async {
    if (eService.value.hasData) {
      try {
        var _optionGroups = await _eServiceRepository.getOptionGroups(eService.value.id);
        optionGroups.assignAll(_optionGroups);
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      }
    }
  }

  /*
  * Check if the form for create new service or edit
  * */
  bool isCreateForm() {
    return !eService.value.hasData;
  }

  void createEServiceForm({bool createOptions = false}) async {
    Get.focusScope.unfocus();
    if (eServiceForm.currentState.validate()) {
      try {
        eServiceForm.currentState.save();
        var _eService = await _eServiceRepository.create(eService.value);
        if (createOptions)
          Get.offAndToNamed(Routes.OPTIONS_FORM, arguments: {'eService': _eService});
        else
          Get.offAndToNamed(Routes.E_SERVICE, arguments: {'eService': _eService, 'heroTag': 'e_service_create_form'});
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {}
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "There are errors in some fields please correct them!".tr));
    }
  }

  void updateEServiceForm() async {
    Get.focusScope.unfocus();
    if (eServiceForm.currentState.validate()) {
      try {
        eServiceForm.currentState.save();
        var _eService = await _eServiceRepository.update(eService.value);
        Get.offAndToNamed(Routes.E_SERVICE, arguments: {'eService': _eService, 'heroTag': 'e_service_update_form'});
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {}
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "There are errors in some fields please correct them!".tr));
    }
  }

  void deleteEService() async {
    try {
      await _eServiceRepository.delete(eService.value.id);
      Get.offAndToNamed(Routes.E_SERVICES);
      Get.showSnackbar(Ui.SuccessSnackBar(message: eService.value.name + " " + "has been removed".tr));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}

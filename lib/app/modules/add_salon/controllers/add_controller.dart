/*
 * File name: add_controller.dart
 * Last modified: 2022.10.16 at 12:23:16
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'dart:async';
import 'dart:convert';

import 'package:beauty_salons_owner/app/models/availability_hour_model.dart';
import 'package:beauty_salons_owner/app/models/category_model.dart';
import 'package:beauty_salons_owner/app/models/salon_level_model.dart';
import 'package:beauty_salons_owner/app/models/salon_model.dart';
import 'package:beauty_salons_owner/app/models/tax_model.dart';
import 'package:beauty_salons_owner/app/modules/global_widgets/multi_select_dialog.dart';
import 'package:beauty_salons_owner/app/modules/global_widgets/select_dialog.dart';
import 'package:beauty_salons_owner/app/modules/root/controllers/root_controller.dart';
import 'package:beauty_salons_owner/app/modules/salons/controllers/salons_controller.dart';
import 'package:beauty_salons_owner/app/repositories/salon_repository.dart';
import 'package:beauty_salons_owner/common/location_details.dart';
import 'package:beauty_salons_owner/common/uuid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/address_model.dart';
import '../../../models/main_model.dart';
import '../../../models/user_model.dart';
import '../../../repositories/user_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../../services/firebase_messaging_service.dart';
import '../../../services/settings_service.dart';

class AddSalonController extends GetxController {
  final Rx<User> currentUser = Get.find<AuthService>().user;
  final salon = Salon().obs;
  final user = <String>[].obs;
  final seat = <int>[].obs;
  final category = <Category>[].obs;
  final services = <ServiceModel>[].obs;
  final bankModel = <BankModel>[].obs;
  ScrollController scroll = new ScrollController();
  TextEditingController durationCon = TextEditingController();
  GlobalKey<FormState> loginFormKey;
  GlobalKey<FormState> registerFormKey;
  GlobalKey<FormState> bankFormKey;
  GlobalKey<FormState> amenitiesFormKey;
  GlobalKey<FormState> forgotPasswordFormKey;
  SalonRepository _salonRepository;
  GlobalKey<FormState> salonForm = new GlobalKey<FormState>();
  final hidePassword = true.obs;
  final hideIfsc = true.obs;
  final findBranch = false.obs;
  final hidePan = true.obs;
  final hideGst = true.obs;
  final hideKyc = true.obs;
  final showLoading = false.obs;
  final hideAccount = true.obs;
  bool amenitiesDone = false;
  final loading = false.obs;
  final linkLoading = true.obs;
  final bankLoading = true.obs;
  final addressLoading = false.obs;
  final smsSent = ''.obs;
  int index = 0;
  UserRepository _userRepository;
  final genders = <GenderModel>[].obs;
  final tempGenders = <GenderModel>[].obs;
  final partners = <GenderModel>[].obs;
  final amenities = <GenderModel>[].obs;
  final state = <StateModel>[].obs;
  final catIndex = 0.obs;
  final subIndex = 0.obs;
  final salonLevels = <SalonLevel>[].obs;
  final cat = <CatModel>[].obs;
  final selectedGender = <String>[].obs;
  final workingDays = {}.obs;
  bool fromEdit =false;
  final availabilityHours = <AvailabilityHour>[].obs;
  AddSalonController() {
    _salonRepository = new SalonRepository();
    _userRepository = UserRepository();
  }
  @override
  void onInit() async {
    if (Get.arguments != null) {
      var arguments = Get.arguments as Map<String, dynamic>;
      if (arguments != null) {
        salon.value = arguments['salon'] as Salon;
      }
      if (arguments['index'] != null) {
        index = arguments['index'] as int;
      }
      print("check2${arguments['from']}");
      if (arguments['from'] != null) {

        fromEdit = arguments['from'] as bool;
      }
    }
    //await getData();
    super.onInit();
    getLocation();
  }

  @override
  void onReady() async {
    super.onReady();
    /*scroll.animateTo(
      index.toDouble()*50.0,
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );*/
    await getData();
  }

  bool isCreateForm() {
    return !salon.value.hasData;
  }

  void addUser(String value) {
    print("hello");
    seat.clear();
    user.clear();
    if (salon.value.employees != null) {
      for (int i = 1; i < salon.value.employees.length; i++) {
        seat.add(i);
        user.add(salon.value.employees[0].name);
      }
    }
    int val = int.parse(value);
    for (int i = 0; i < val; i++) {
      if (salon.value.employees != null && i < salon.value.employees.length) {
      } else {
        seat.add(i);
        user.add("");
      }
    }
    seat.refresh();
    user.refresh();
  }

  Future getData() async {
    print("okay");
    loading.value = true;
    Map data = await _userRepository.getData();
    state.addAll(data['states']
        .map<StateModel>((obj) => StateModel.fromJson(obj))
        .toList());

    Map data3 = await _userRepository.getBankName();
    bankModel.addAll(data3['data']
        .map<BankModel>((obj) => BankModel.fromJson(obj))
        .toList());

    loading.value = false;
    if (salon.value.id != null) {
      salon.value = await _salonRepository.get(salon.value.id);
    }
    salon.update((val) {
      val.ownerName = currentUser.value.name;
      val.phoneNumber = currentUser.value.phoneNumber;
      val.email = currentUser.value.email;
      if (salon.value.employees != null) {
        val.totalSeat = (salon.value.employees.length - 1).toString();
      }
    });
    int j = 0;
    if (salon.value.employees != null) {
      for (int i = 1; i < salon.value.employees.length; i++) {
        seat.add(j);
        user.add(salon.value.employees[i].name);
        j++;
      }
      user.refresh();
      seat.refresh();
    }

    /* if(salon.value.availabilityHours!=null) {
      availabilityHours.clear();
      for (int i = 0; i < salon.value.availabilityHours.length; i++) {
        availabilityHours.add(salon.value.availabilityHours[i]);
      }

    }*/
    /* final _salon = await _salonRepository.getAll();
    if(_salon.length>0){
      salon.value = _salon[0];
    }*/
    genders.addAll(data['gender']
        .map<GenderModel>((obj) => GenderModel.fromJson(obj))
        .toList());
    tempGenders.addAll(genders);
    amenities.addAll(data['amenities']
        .map<GenderModel>((obj) => GenderModel.fromJson(obj))
        .toList());
    partners.addAll(data['partner_size']
        .map<GenderModel>((obj) => GenderModel.fromJson(obj))
        .toList());
    cat.addAll(data['salon_category']
        .map<CatModel>((obj) => CatModel.fromJson(obj))
        .toList());
    salonLevels.addAll(data['salon_level']
        .map<SalonLevel>((obj) => SalonLevel.fromJson(obj))
        .toList());
    workingDays.value = data['working_days'];
    print(workingDays.value);
    if (salon.value.availabilityHours != null) {
      for (int i = 0; i < salon.value.availabilityHours.length; i++) {
        availabilityHours.add(salon.value.availabilityHours[i]);
      }
    }
    for (int i = 0; i < workingDays.entries.length; i++) {
      if(availabilityHours.indexWhere((element) => element.day==workingDays.entries.elementAt(i).value)!=-1){

      }else{
        availabilityHours.add(AvailabilityHour(
            day: workingDays.entries.elementAt(i).value, check: false));
      }
    }
    if (index > 150) {
      await Future.delayed(Duration(seconds: 1));
      scroll.animateTo(
        index.toDouble(),
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    }
    Map data1;
    if (salon != null && salon.value.id != null) {
      data1 = await _salonRepository.getBank(salon.value.id);
      bankLoading.value = false;
      linkLoading.value = false;
      if (data1 != null && data1['bank_details'] != null) {
        print("check");
        salon.update((val) {
          print("check1");
          val.gst_no = data1['bank_details']['gst_no'];
          print(val.gst_no);
          val.pan_no = data1['bank_details']['pan_no'];
          val.bank_name = data1['bank_details']['bank_name'];
          val.branch_name = data1['bank_details']['branch_name'];
          val.account_holder = data1['bank_details']['account_holder'];
          val.account_no = data1['bank_details']['account_no'];
          val.confirm_account_no = data1['bank_details']['account_no'];
          val.ifsc_code = data1['bank_details']['ifsc_code'];
          val.is_kyc = data1['bank_details']['is_kyc'];
          val.bankId = data1['bank_details']['id'];
        });
        //  salon.refresh();
        // loading.value = true;
      }
    } else {
      bankLoading.value = false;
      linkLoading.value = false;
    }
    print(data1);
    // availabilityHours.addAll(workingDays.entries.map((e) => AvailabilityHour(day: e.value,check: false)));

    try {} catch (e) {}
  }


  void getService()async{
    category.clear();
    Map data2 = await _userRepository.getCat();
    category.addAll(
        data2['data'].map<Category>((obj) => Category.fromJson(obj)).toList());
    category[catIndex.value].selected = true;
    category[catIndex.value].subCategories[0].selected = true;
  }
  void createAvailabilityHour() async {
    Get.focusScope.unfocus();
    List<String> day = [];
    List<String> start = [];
    List<String> end = [];
    for (int i = 0; i < availabilityHours.length; i++) {
      if (availabilityHours[i].check) {
        if (availabilityHours[i].startAt != null &&
            availabilityHours[i].endAt != null) {
          day.add(availabilityHours[i].day);
          start.add(availabilityHours[i].startAt);
          end.add(availabilityHours[i].endAt);
        } else {
          day.clear();
          Get.showSnackbar(Ui.ErrorSnackBar(
              message:
                  "There are errors in some fields please correct them!".tr));
          break;
        }
      }
    }
    if (day.length > 0) {
      try {
        Map data = {
          "day": day.join(","),
          "start_at": start.join(","),
          "end_at": end.join(","),
          "salon_id": salon.value.id,
        };
        final _availabilityHour =
            await _salonRepository.createAvailabilityHourNew(data);
        if (_availabilityHour) {
          if(fromEdit){
            await Get.offAndToNamed(Routes.SALONS, arguments: {'salon': salon});
          }else{
            Get.toNamed(Routes.SALON_LINK_FORM, arguments: {'salon': salon});
            index = 3;
            await Future.delayed(Duration(seconds: 1));
            scroll.animateTo(
              index.toDouble() * 55.0,
              duration: Duration(seconds: 1),
              curve: Curves.fastOutSlowIn,
            );
          }

        }
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {}
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(
          message: "There are errors in some fields please correct them!".tr));
    }
  }

  getLocation() {
    GetLocation getLocation = new GetLocation((value) {
      Get.find<SettingsService>().address.update((val) {
        if (salon.value.address == null) {
          salon.update((val) {
            Address address = new Address(
              description: value.first.locality,
              address: value.first.addressLine,
              latitude: value.first.coordinates.latitude,
              longitude: value.first.coordinates.longitude,
              userId: Get.find<AuthService>().user.value.id,
            );
            val.address = address;
          });
        }
      });
    });
    getLocation.getLoc();
  }

  Future<void> createAddress(Address address) async {
    try {
      address = await _salonRepository.createAddress(address);
      salon.update((val) {
        val.address = address;
      });
      if (isCreateForm()) {
        final _salon = await _salonRepository.create(salon.value);
        getService();
        salon.value.id = _salon.id;
        Get.toNamed(Routes.SALON_WORKING_FORM, arguments: {'salon': salon});
        index = 2;
        await Future.delayed(Duration(seconds: 1));
        scroll.animateTo(
          index.toDouble() * 50.0,
          duration: Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
        );
      } else {
        final _salon = await _salonRepository.update(salon.value);
        salon.value.id = _salon.id;
        Get.find<RootController>().salons[0].salonCategory = _salon.salonCategory;
        await Get.offAndToNamed(Routes.SALONS, arguments: {'salon': salon});
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  void createAmenitiesForm() async {
    if (!amenitiesDone) {
      Get.focusScope.unfocus();
      if (amenitiesFormKey.currentState.validate()) {
        amenitiesFormKey.currentState.save();
        List<String> amenities = [];
        List<String> seats = [];
        List<String> ameId = [];
        List<String> usersId = [];
        if (salon.value.amenities != null) {
        for (int i = 0; i < salon.value.amenities.length; i++) {
          GenderModel model = salon.value.amenities[i];
          amenities.add(model.name);
          ameId.add(model.id);
        }}
        if (salon.value.employees != null) {
          for (int i = 1; i < salon.value.employees.length; i++) {
            User model = salon.value.employees[i];
            usersId.add(model.id);
          }
        }
        for (int i = 0; i < int.parse(salon.value.totalSeat); i++) {
          seats.add((i + 1).toString());
        }
        Map param = {
          "fb_link": salon.value.fbLink,
          "insta_link": salon.value.instaLink,
          "website_link": salon.value.websiteLink,
          "amenities": amenities.join(","),
          "total_seats": salon.value.totalSeat,
          "employee_names": user.join(","),
          "seat_nos": seats.join(","),
          "amenity_ids": "",
          "user_ids": usersId.join(","),
          "salon_id": salon.value.id,
        };
        print(usersId.length);
        if (usersId.length > 0) {
          param['user_ids'] = usersId.join(",");
          //   param['amenity_ids'] = ameId.join(",");
        }
        final _salon = await _salonRepository.createAmenities(param);

        if (_salon) {
          amenitiesDone = true;
          if(fromEdit){
            await Get.offAndToNamed(Routes.SALONS, arguments: {'salon': salon});
          }else{
          if (usersId.length > 0) {
            Get.offAndToNamed(
              Routes.SALONS,
            );
            // Get.find<SalonsController>().refreshSalons();
          } else {
            Get.toNamed(Routes.SALON_BANK_FORM, arguments: {'salon': salon});
            index = 4;
            await Future.delayed(Duration(seconds: 1));
            scroll.animateTo(
              index.toDouble() * 50.0,
              duration: Duration(seconds: 1),
              curve: Curves.fastOutSlowIn,
            );
          }}
        }
        try {

        } catch (e) {
          Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
        } finally {}
      } else {
        Get.showSnackbar(Ui.ErrorSnackBar(
            message:
                "There are errors in some fields please correct them!".tr));
      }
    } else {
      Get.toNamed(Routes.SALON_BANK_FORM, arguments: {'salon': salon});
    }
  }

  void createSalonForm() async {
    /* await Get.toNamed(Routes.SALON_BANK_FORM,arguments: {'salon': salon});
    return;*/
    Get.focusScope.unfocus();
    if (salonForm.currentState.validate()) {
      try {
        salonForm.currentState.save();
        /* final _salon = await _salonRepository.create(salon.value);
        salon.value.id = _salon.id;*/
        Get.toNamed(Routes.SALON_ADDRESS_FORM, arguments: {'salon': salon});
        index = 1;
        await Future.delayed(Duration(seconds: 1));
        scroll.animateTo(
          index.toDouble() * 50.0,
          duration: Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
        );
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {}
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(
          message: "There are errors in some fields please correct them!".tr));
    }
  }

  Future<void> addService() async {
    Map param = {};
    List<Map> serviceList = [];
    for (int i = 0; i < services.length; i++) {
      Map data = {
        "service": services[i].name,
        "price": services[i].price,
        "time": services[i].duration,
        "gender": services[i].gender,
        "category_id": services[i].subCategoryId,
      };
      serviceList.add(data);
    }
    param['services'] = jsonEncode(serviceList);
    var response = await _salonRepository.createService(param);
    print(response);
    Get.offAllNamed(Routes.ROOT);
  }

  void createBankForm() async {
    Get.focusScope.unfocus();
    if (bankFormKey.currentState.validate()) {
      try {
        bankFormKey.currentState.save();
        Map param = {
          "pan_no": salon.value.pan_no,
          "gst_no": salon.value.gst_no,
          "bank_name": salon.value.bank_name,
          "branch_name": salon.value.branch_name,
          "account_no": salon.value.account_no,
          "account_holder": salon.value.account_holder,
          "ifsc_code": salon.value.ifsc_code,
          "is_kyc": salon.value.is_kyc,
          "salon_id": salon.value.id,
        };
        if (salon.value.panImage != null) {
          param['pan_card_doc'] = salon.value.panImage
              .where((element) => Uuid.isUuid(element.id))
              .map((v) => v.id)
              .toList();
        }
        if (salon.value.bankId != null) {
          param['id'] = salon.value.bankId.toString();
        } else {
          param['id'] = "";
        }
        if (salon.value.businessImage != null) {
          param['bussiness_doc'] = salon.value.businessImage
              .where((element) => Uuid.isUuid(element.id))
              .map((v) => v.id)
              .toList();
        }
        final _salon = await _salonRepository.createBank(param);
        if (_salon) {
          if(fromEdit){
            await Get.offAndToNamed(Routes.SALONS, arguments: {'salon': salon});
          }else{
            Get.toNamed(Routes.SALON_SERVICE_FORM);
          }

          // Get.find<RootController>().changePageOutRoot(0);
        }
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {}
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(
          message: "There are errors in some fields please correct them!".tr));
    }
  }

  void login() async {
    Get.focusScope.unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      loading.value = true;
      try {
        await Get.find<FireBaseMessagingService>().setDeviceToken();
        currentUser.value = await _userRepository.login(currentUser.value);
        await _userRepository.signInWithEmailAndPassword(
            currentUser.value.email, currentUser.value.apiToken);
        loading.value = false;
        print("showUser" + currentUser.value.toJson().toString());
        await Get.toNamed(Routes.ROOT, arguments: 0);
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {
        loading.value = false;
      }
    }
  }

  void register() async {
    Get.focusScope.unfocus();
    if (registerFormKey.currentState.validate()) {
      registerFormKey.currentState.save();
      loading.value = true;
      try {
        if (Get.find<SettingsService>().setting.value.enableOtp) {
          await _userRepository.sendCodeToPhone();
          loading.value = false;
          await Get.toNamed(Routes.PHONE_VERIFICATION);
        } else {
          await Get.find<FireBaseMessagingService>().setDeviceToken();
          currentUser.value = await _userRepository.register(currentUser.value);
          await _userRepository.signUpWithEmailAndPassword(
              currentUser.value.email, currentUser.value.apiToken);
          loading.value = false;
          await Get.toNamed(Routes.SALONS);
        }
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {
        loading.value = false;
      }
    }
  }

  Future<void> verifyPhone() async {
    try {
      loading.value = true;
      await _userRepository.verifyPhone(smsSent.value);
      await Get.find<FireBaseMessagingService>().setDeviceToken();
      currentUser.value = await _userRepository.register(currentUser.value);
      await _userRepository.signUpWithEmailAndPassword(
          currentUser.value.email, currentUser.value.apiToken);
      loading.value = false;
      await Get.toNamed(Routes.SALONS);
    } catch (e) {
      loading.value = false;
      Get.toNamed(Routes.REGISTER);
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      loading.value = false;
    }
  }

  Future<void> resendOTPCode() async {
    await _userRepository.sendCodeToPhone();
  }

  void sendResetLink() async {
    Get.focusScope.unfocus();
    if (forgotPasswordFormKey.currentState.validate()) {
      forgotPasswordFormKey.currentState.save();
      loading.value = true;
      try {
        await _userRepository.sendResetLinkEmail(currentUser.value);
        loading.value = false;
        Get.showSnackbar(Ui.SuccessSnackBar(
            message:
                "The Password reset link has been sent to your email: ".tr +
                    currentUser.value.email));
        Timer(Duration(seconds: 5), () {
          Get.offAndToNamed(Routes.LOGIN);
        });
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {
        loading.value = false;
      }
    }
  }

  List<MultiSelectDialogItem<GenderModel>> getMultiSelectAmenitiesItems() {
    return amenities.map((element) {
      return MultiSelectDialogItem(element, element.name);
    }).toList();
  }

  List<SelectDialogItem<SalonLevel>> getSelectSalonLevelsItems() {
    return salonLevels.map((element) {
      return SelectDialogItem(element, element.name);
    }).toList();
  }

  List<SelectDialogItem<BankModel>> getSelectBankItems() {
    return bankModel.map((element) {
      return SelectDialogItem(element, element.name);
    }).toList();
  }

  List<SelectDialogItem<GenderModel>> getMultiSelectTaxesItems() {
    return genders.map((element) {
      return SelectDialogItem(element, element.name);
    }).toList();
  }

  List<SelectDialogItem<CatModel>> getMultiSelectCatItems() {
    return cat.map((element) {
      return SelectDialogItem(element, element.title);
    }).toList();
  }

  List<SelectDialogItem<GenderModel>> getSelectPartnerLevelsItems() {
    return partners.map((element) {
      return SelectDialogItem(element, element.name);
    }).toList();
  }

  List<SelectDialogItem<StateModel>> getStateItems() {
    return state.map((element) {
      return SelectDialogItem(element, element.name);
    }).toList();
  }
}

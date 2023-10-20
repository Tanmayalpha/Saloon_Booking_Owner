/*
 * File name: add_controller.dart
 * Last modified: 2022.10.16 at 12:23:16
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'dart:async';

import 'package:beauty_salons_owner/app/modules/root/controllers/root_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/user_model.dart';
import '../../../repositories/user_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../../services/firebase_messaging_service.dart';
import '../../../services/settings_service.dart';

class AuthController extends GetxController {
  final Rx<User> currentUser = Get.find<AuthService>().user;
  GlobalKey<FormState> loginFormKey;
  GlobalKey<FormState> registerFormKey;
  GlobalKey<FormState> forgotPasswordFormKey;
  final hidePassword = true.obs;
  final loading = false.obs;

  final smsSent = ''.obs;
  bool from =false,fromRegister = false;
  UserRepository _userRepository;
  final mobileNumber = ''.obs;
  final otp = ''.obs;
  TextEditingController mobileCon = new TextEditingController();
  AuthController() {
    _userRepository = UserRepository();
  }
  @override
  void onInit() async {
    super.onInit();
    /* MobileNumber.listenPhonePermission((isPermissionGranted) {
      if (isPermissionGranted) {
        initMobileNumberState();
      } else {}
    });*/

    mobileCon..addListener(() {
     // FocusManager.instance.primaryFocus.unfocus();
      if(mobileCon.text.contains("+91")){
        mobileCon.text=mobileCon.text.replaceAll("+91", "");
      }
      if(mobileCon.text.length==10){
        FocusManager.instance.primaryFocus.unfocus();
      }
      currentUser.value.phoneNumber = mobileCon.text.replaceAll("+91", "");
    });
    //   initMobileNumberState();
  }
  void login1() async {
    Get.focusScope.unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      if(mobileCon.text.length!=10){
        Get.showSnackbar(Ui.ErrorSnackBar(message: "Please enter valid mobile number".toString()));
        return;
      }
      loading.value = true;
      try {
        await Get.find<FireBaseMessagingService>().setDeviceToken();
        currentUser.value = await _userRepository.login(currentUser.value);
        await _userRepository.signInWithEmailAndPassword(currentUser.value.email, currentUser.value.apiToken);
        loading.value = false;
        print("showUser"+currentUser.value.toJson().toString());
        await Get.toNamed(Routes.ROOT, arguments: 0);
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {
        loading.value = false;
      }
    }
  }
  void login({bool from =false}) async {
    Get.focusScope.unfocus();
    if (loginFormKey.currentState.validate()) {
      if(!from&&currentUser.value.phoneNumber.toString().length!=10){
        Get.showSnackbar(Ui.ErrorSnackBar(message: "Enter a valid mobile number".toString()));
        return;
      }
      loginFormKey.currentState.save();
      loading.value = true;
      try {
        await Get.find<FireBaseMessagingService>().setDeviceToken();
        otp.value = await _userRepository.loginOtp(currentUser.value.phoneNumber.replaceAll("+91", ""));
        if(currentUser.value.email!=null){
        //  await _userRepository.signInWithEmailAndPassword(currentUser.value.email, currentUser.value.apiToken);
        }
        loading.value = false;
        fromRegister = false;
        await Get.toNamed(Routes.PHONE_VERIFICATION);
         //await Get.find<RootController>().changePage(0);
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {
        loading.value = false;
      }
    }
  }
  Future<void> verifyLoginPhone() async {
    try {
      loading.value = true;
      // await _userRepository.verifyPhone(smsSent.value);
      await Get.find<FireBaseMessagingService>().setDeviceToken();
      currentUser.value = await _userRepository.verifyOtp({
        "mobile":"+91"+currentUser.value.phoneNumber.replaceAll("+91", ""),
        "otp":smsSent.value,
      });
      loading.value = false;
      print(currentUser.value.email);
      print(currentUser.value.apiToken);
      // await _userRepository.signInWithEmailAndPassword(currentUser.value.email, currentUser.value.apiToken);
     // await Get.toNamed(Routes.SALONS);
      if(from){
        await Get.toNamed(Routes.SALONS);
      }else{
        await Get.toNamed(Routes.ROOT);
       // Get.find<RootController>().refresh();
      }
    } catch (e) {
      Get.back();
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      loading.value = false;
    }
  }
  void registerOtp() async {
    Get.focusScope.unfocus();

    if (registerFormKey.currentState.validate()) {
      registerFormKey.currentState.save();
      if(currentUser.value.phoneNumber.toString().length<10){
        Get.showSnackbar(Ui.ErrorSnackBar(message: "Enter a valid mobile number".toString()));
        return;
      }
      loading.value = true;
      try {
        await Get.find<FireBaseMessagingService>().setDeviceToken();
        otp.value = await _userRepository.registerOtp(currentUser.value.phoneNumber.replaceAll("+91", ""));
        if(currentUser.value.email!=null){
          //  await _userRepository.signInWithEmailAndPassword(currentUser.value.email, currentUser.value.apiToken);
        }
        loading.value = false;
        fromRegister = true;
        await Get.toNamed(Routes.PHONE_VERIFICATION);
        //await Get.find<RootController>().changePage(0);
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {
        loading.value = false;
      }
    }
  }
  void register() async {
    Get.focusScope.unfocus();
    /*if (registerFormKey.currentState.validate()) {
      registerFormKey.currentState.save();
    }*/
      if(currentUser.value.phoneNumber.toString().length<10){
        Get.showSnackbar(Ui.ErrorSnackBar(message: "Enter a valid mobile number".toString()));
        return;
      }
      loading.value = true;
      try {
        await Get.find<FireBaseMessagingService>().setDeviceToken();
        currentUser.value = await _userRepository.register(currentUser.value);

       // await _userRepository.signUpWithEmailAndPassword(currentUser.value.email, currentUser.value.apiToken);
        loading.value = false;
        from = true;
        await Get.toNamed(Routes.SALONS);
        //login(from: true);
        return;
        if (Get.find<SettingsService>().setting.value.enableOtp) {
          await _userRepository.sendCodeToPhone();
          loading.value = false;
          await Get.toNamed(Routes.PHONE_VERIFICATION);
        } else {
          await Get.find<FireBaseMessagingService>().setDeviceToken();
          currentUser.value = await _userRepository.register(currentUser.value);
          await _userRepository.signUpWithEmailAndPassword(currentUser.value.email, currentUser.value.apiToken);
          loading.value = false;
          await Get.toNamed(Routes.SALONS);
        }
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {
        loading.value = false;
      }

  }

  Future<void> verifyPhone() async {
    try {
      loading.value = true;
      await _userRepository.verifyPhone(smsSent.value);
      await Get.find<FireBaseMessagingService>().setDeviceToken();
      currentUser.value = await _userRepository.register(currentUser.value);
      await _userRepository.signUpWithEmailAndPassword(currentUser.value.email, currentUser.value.apiToken);
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
        Get.showSnackbar(Ui.SuccessSnackBar(message: "The Password reset link has been sent to your email: ".tr + currentUser.value.email));
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
}

/*
 * File name: user_repository.dart
 * Last modified: 2022.10.16 at 12:23:16
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/user_model.dart';
import '../providers/firebase_provider.dart';
import '../providers/laravel_provider.dart';
import '../services/auth_service.dart';

class UserRepository {
  LaravelApiClient _laravelApiClient;
  FirebaseProvider _firebaseProvider;

  UserRepository() {}

  Future<User> login(User user) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.login(user);
  }
  Future<String> loginOtp(String mobile) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    print("Login Mobile No.${mobile.toString()}");
    return _laravelApiClient.sendOtp(mobile.toString());
  }
  Future<User> verifyOtp(Map param) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.verifyOtp(param);
  }
  Future<Map> getData() {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.getData();
  }
  Future<Map> getCat() {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.getCat();
  }
  Future<Map> getBankName() {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.getBankName();
  }
  Future<User> get(User user) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.getUser(user);
  }

  Future<User> update(User user) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.updateUser(user);
  }

  Future<bool> sendResetLinkEmail(User user) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.sendResetLinkEmail(user);
  }

  Future<User> getCurrentUser() {
    return this.get(Get.find<AuthService>().user.value);
  }

  Future<void> deleteCurrentUser() async {
    _laravelApiClient = Get.find<LaravelApiClient>();
    _firebaseProvider = Get.find<FirebaseProvider>();
    await _laravelApiClient.deleteUser(Get.find<AuthService>().user.value);
    await _firebaseProvider.deleteCurrentUser();
    Get.find<AuthService>().user.value = new User();
    GetStorage().remove('current_user');
  }
  Future<String> registerOtp(String mobile) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.sendRegisterOtp(mobile);
  }
  Future<User> register(User user) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.register(user);
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    return _firebaseProvider.signInWithEmailAndPassword(email, password);
  }

  Future<bool> signUpWithEmailAndPassword(String email, String password) async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    return _firebaseProvider.signUpWithEmailAndPassword(email, password);
  }

  Future<void> verifyPhone(String smsCode) async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    return _firebaseProvider.verifyPhone(smsCode);
  }

  Future<void> sendCodeToPhone() async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    return _firebaseProvider.sendCodeToPhone();
  }

  Future signOut() async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    return await _firebaseProvider.signOut();
  }
}

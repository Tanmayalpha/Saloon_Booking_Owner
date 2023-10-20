/*
 * File name: laravel_provider.dart
 * Last modified: 2022.10.16 at 12:23:16
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'dart:convert';
import 'dart:io';

import 'package:beauty_salons_owner/app/models/offer_model.dart';
import 'package:beauty_salons_owner/app/models/query_model.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';

import '../../common/uuid.dart';
import '../models/address_model.dart';
import '../models/availability_hour_model.dart';
import '../models/award_model.dart';
import '../models/booking_model.dart';
import '../models/booking_status_model.dart';
import '../models/category_model.dart';
import '../models/custom_page_model.dart';
import '../models/e_service_model.dart';
import '../models/experience_model.dart';
import '../models/faq_category_model.dart';
import '../models/faq_model.dart';
import '../models/gallery_model.dart';
import '../models/notification_model.dart';
import '../models/option_group_model.dart';
import '../models/option_model.dart';
import '../models/payment_method_model.dart';
import '../models/payment_model.dart';
import '../models/review_model.dart';
import '../models/salon_level_model.dart';
import '../models/salon_model.dart';
import '../models/salon_subscription_model.dart';
import '../models/setting_model.dart';
import '../models/statistic.dart';
import '../models/subscription_package_model.dart';
import '../models/tax_model.dart';
import '../models/user_model.dart';
import '../models/wallet_model.dart';
import '../models/wallet_transaction_model.dart';
import '../routes/app_routes.dart';
import 'api_provider.dart';
import 'dio_client.dart';
import 'package:http/http.dart' as http;

class LaravelApiClient extends GetxService with ApiClient {
  DioClient _httpClient;
  dio.Options _optionsNetwork;
  dio.Options _optionsCache;

  LaravelApiClient() {
    this.baseUrl = this.globalService.global.value.laravelBaseUrl;
    _httpClient = DioClient(this.baseUrl, new dio.Dio());
  }

  Future<LaravelApiClient> init() async {
    _optionsNetwork = _httpClient.optionsNetwork;
    _optionsCache = _httpClient.optionsCache;
    return this;
  }

  bool isLoading({String task, List<String> tasks}) {
    return _httpClient.isLoading(task: task, tasks: tasks);
  }

  void setLocale(String locale) {
    _optionsNetwork.headers['Accept-Language'] = locale;
    _optionsCache.headers['Accept-Language'] = locale;
  }

  void forceRefresh() {
    if (!foundation.kIsWeb && !foundation.kDebugMode) {
      _optionsCache = dio.Options(headers: _optionsCache.headers);
      _optionsNetwork = dio.Options(headers: _optionsNetwork.headers);
    }
    final authService = this.authService;
    authService.isRoleChanged().then((value) {
      if (value) {
        authService.removeCurrentUser();
        Get.offAllNamed(Routes.LOGIN);
      }
    });
  }

  void unForceRefresh() {
    if (!foundation.kIsWeb && !foundation.kDebugMode) {
      _optionsNetwork = buildCacheOptions(Duration(days: 3),
          forceRefresh: true, options: _optionsNetwork);
      _optionsCache = buildCacheOptions(Duration(minutes: 10),
          forceRefresh: false, options: _optionsCache);
    }
  }

  Future<User> getUser(User user) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("salon_owner/user")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(
      _uri,
      options: _optionsNetwork,
    );

    if (response.data['success'] == true) {
      response.data['data']['auth'] = true;
      print("User Api" + response.data['data']['role'].toString());
      return User.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }
  Future<String> sendRegisterOtp(String mobile) async {
    print("check api.....${mobile.toString()}");
    var _queryParameters = {
      'phone_number': "+91" + mobile,
    };
    print("Parameters ${_queryParameters.toString()}");
    Uri _uri = getApiBaseUri("salon_owner/register-otp");
    //.replace(queryParameters: _queryParameters)
    // Get.log(_uri.toString());
    // Uri _uri = getApiBaseUri("login-with-otp");
    Get.log(_uri.toString());
    Get.log(_queryParameters.toString());
    var response = await _httpClient.postUri(
      _uri,
      data: _queryParameters,
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      print("Now Working");
      print(response.data);
      var otp = response.data['data']['otp'];
      response.data['data']['auth'] = true;
      // Otp = LoginWithOtp.fromJson(jsonDecode(response.data['Otp']));
      print("Otp Here.....${otp.toString()}");
      //  response.data['data']['data']['otp']=otp.toString();
      // Get.toNamed(Routes.LOGIN_OTP_VIEW);
      // Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginOtpView()));
      return otp.toString();
      //return User.fromJson(response.data['data']['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }
  Future<String> sendOtp(String mobile) async {
    print("check api.....${mobile.toString()}");
    var _queryParameters = {
      'mobile': "+91" + mobile,
    };
    print("Parameters ${_queryParameters.toString()}");
    Uri _uri = getApiBaseUri("salon_owner/login_with_otp");
    //.replace(queryParameters: _queryParameters)
    // Get.log(_uri.toString());
    // Uri _uri = getApiBaseUri("login-with-otp");
    Get.log(_uri.toString());
    Get.log(_queryParameters.toString());
    var response = await _httpClient.postUri(
      _uri,
      data: _queryParameters,
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      print("Now Working");
      print(response.data);
      var otp = response.data['data']['otp'];
      response.data['data']['auth'] = true;
      // Otp = LoginWithOtp.fromJson(jsonDecode(response.data['Otp']));
      print("Otp Here.....${otp.toString()}");
      //  response.data['data']['data']['otp']=otp.toString();
      // Get.toNamed(Routes.LOGIN_OTP_VIEW);
      // Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginOtpView()));
      return otp.toString();
      //return User.fromJson(response.data['data']['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<User> verifyOtp(Map param) async {
    Uri _uri = getApiBaseUri("salon_owner/verify_login");
    Get.log(_uri.toString());
    print(param);
    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(param),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      response.data['data']['auth'] = true;
      return User.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<User> login(User user) async {
    Uri _uri = getApiBaseUri("salon_owner/login");
    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(user.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      response.data['data']['auth'] = true;
      return User.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<User> register(User user) async {
    Uri _uri = getApiBaseUri("salon_owner/register");

    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(user.toJson()),
      options: _optionsNetwork,
    );
    print(json.encode(user.toJson()));
    if (response.data['success'] == true) {
      response.data['data']['auth'] = true;
      return User.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> sendResetLinkEmail(User user) async {
    Uri _uri = getApiBaseUri("salon_owner/send_reset_link_email");

    // to remove other attributes from the user object
    user = new User(email: user.email);
    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(user.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<User> updateUser(User user) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("salon_owner/users/${user.id}")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(user.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      response.data['data']['auth'] = true;
      return User.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Statistic>> getHomeStatistics() async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("salon_owner/dashboard")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Statistic>((obj) => Statistic.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> deleteUser(User user) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ deleteUser() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri =
        getApiBaseUri("users").replace(queryParameters: _queryParameters);
    var response = await _httpClient.deleteUri(
      _uri,
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return response.data['success'];
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Address>> getAddresses() async {
    var _queryParameters = {
      'api_token': authService.apiToken,
      'orderBy': 'updated_at',
      'sortedBy': 'desc',
    };
    Uri _uri =
        getApiBaseUri("addresses").replace(queryParameters: _queryParameters);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Address>((obj) => Address.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Address> createAddress(Address address) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri =
        getApiBaseUri("addresses").replace(queryParameters: _queryParameters);
    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(address.toJson()),
      options: _optionsNetwork,
    );
    print("data print" + address.toJson().toString());
    if (response.data['success'] == true) {
      return Address.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Address> updateAddress(Address address) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("addresses/${address.id}")
        .replace(queryParameters: _queryParameters);
    var response = await _httpClient.putUri(
      _uri,
      data: json.encode(address.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return Address.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Address> deleteAddress(Address address) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("addresses/${address.id}")
        .replace(queryParameters: _queryParameters);
    var response = await _httpClient.deleteUri(
      _uri,
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return Address.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> searchEServices(
      String keywords, List<String> categories, int page) async {
    // TODO Pagination
    var _queryParameters = {
      'with': 'salon;salon.address;categories',
      'search': 'categories.id:${categories.join(',')};name:$keywords',
      'searchFields': 'categories.id:in;name:like',
      'searchJoin': 'and',
    };
    Uri _uri =
        getApiBaseUri("e_services").replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<EService> getEService(String id) async {
    var _queryParameters = {
      'with': 'salon;categories',
    };
    if (authService.isAuth) {
      _queryParameters['api_token'] = authService.apiToken;
    }
    Uri _uri = getApiBaseUri("e_services/$id")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return EService.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<EService> createEService(EService eService) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri =
        getApiBaseUri("e_services").replace(queryParameters: _queryParameters);

    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(eService.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return EService.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<EService> updateEService(EService eService) async {
    if (!authService.isAuth || !eService.hasData) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ updateEService(EService eService) ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("e_services/${eService.id}")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.patchUri(
      _uri,
      data: json.encode(eService.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return EService.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> deleteEService(String eServiceId) async {
    if (!authService.isAuth || eServiceId == null) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ deleteEService(String eServiceId) ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("e_services/${eServiceId}")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.deleteUri(
      _uri,
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Option> createOption(Option option) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri =
        getApiBaseUri("options").replace(queryParameters: _queryParameters);
    print(option.toJson());

    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(option.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return Option.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Option> updateOption(Option option) async {
    if (!authService.isAuth || !option.hasData) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ updateOption(Option option) ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("options/${option.id}")
        .replace(queryParameters: _queryParameters);

    print(option.toJson());
    var response = await _httpClient.patchUri(
      _uri,
      data: json.encode(option.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return Option.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> deleteOption(String optionId) async {
    if (!authService.isAuth || optionId == null) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ deleteOption(String optionId) ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("options/${optionId}")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.deleteUri(
      _uri,
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Salon> getSalon(String salonId) async {
    var _queryParameters = {
      'with': 'salonLevel;availabilityHours;users;taxes;address',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("salon_owner/salons/$salonId")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Salon.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }
  Future<Map> subscribe(String salonId,String orderId,String amount,String type,String time) async {
    var _queryParameters = {
      //   'with': 'salonLevel;availabilityHours;users;taxes;address',
      'api_token': authService.apiToken,
      'amount': amount,
      'transaction_id': orderId,
      'type': type,
      'time':time
    };
    Uri _uri = getApiBaseUri("salon_owner/subscription-success/$salonId")
        .replace(queryParameters: _queryParameters);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data;
    } else {
      throw new Exception(response.data['message']);
    }
  }
  Future<Map> paymentDone(String orderId, amount) async {
    var _queryParameters = {
      //   'with': 'salonLevel;availabilityHours;users;taxes;address',
      'api_token': authService.apiToken,
      'amount': amount,
      'txn_id': orderId,
    };
    Uri _uri = getApiBaseUri("salon_owner/payment-success")
        .replace(queryParameters: _queryParameters);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Map> getBank(String salonId) async {
    var _queryParameters = {
      // 'with': 'salonLevel;availabilityHours;users;taxes;address',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("salon_owner/get-bank/$salonId")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    print(response.data);
    if (response != null && response.data['success'] == true) {
      return response.data['data'];
    } else {
      return null;
    }
  }

  Future<Map> getBankName() async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("salon_owner/get-bank-lists")
        .replace(queryParameters: _queryParameters);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Map> getCat() async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("salon_owner/get-service-category")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Map> getData() async {
    var _queryParameters = {
      'with': 'salonLevel;availabilityHours;users;taxes;address',
      'api_token': authService.apiToken,
    };
    Uri _uri =
        getApiBaseUri("lists").replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'];
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Salon> createSalon(Salon _salon) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("salon_owner/salons")
        .replace(queryParameters: _queryParameters);
    print(_salon.toJson());
    var response = await _httpClient.postUri(_uri,
        data: _salon.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Salon.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> createAmenities(Map data) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("salon_owner/add-social-links")
        .replace(queryParameters: _queryParameters);
    print(data);
    var response = await _httpClient.postUri(_uri,
        data: jsonEncode(data), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> createService(Map data) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("salon_owner/add-salon-service")
        .replace(queryParameters: _queryParameters);
    print(data);
    var response =
        await _httpClient.postUri(_uri, data: data, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> createBank(Map data) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("salon_owner/add-bank")
        .replace(queryParameters: _queryParameters);
    data['user_id'] = authService.user.value.id;
    print(data);
    var response = await _httpClient.postUri(_uri,
        data: jsonEncode(data), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Salon> updateSalon(Salon _salon) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("salon_owner/salons/${_salon.id}")
        .replace(queryParameters: _queryParameters);
    print(_salon.toJson());
    var response = await _httpClient.putUri(_uri,
        data: _salon.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Salon.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Salon> deleteSalon(Salon _salon) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("salons/${_salon.id}")
        .replace(queryParameters: _queryParameters);
    var response = await _httpClient.deleteUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Salon.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<AvailabilityHour> createAvailabilityHour(
      AvailabilityHour availabilityHour) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("salon_owner/availability_hours")
        .replace(queryParameters: _queryParameters);
    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(availabilityHour.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return AvailabilityHour.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> createAvailabilityHourNew(Map data) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    print(data);
    Uri _uri = getApiBaseUri("availability_hours")
        .replace(queryParameters: _queryParameters);
    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(data),
      options: _optionsNetwork,
    );

    if (response.data['success'] == true) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<AvailabilityHour> deleteAvailabilityHour(
      AvailabilityHour availabilityHour) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri =
        getApiBaseUri("salon_owner/availability_hours/${availabilityHour.id}")
            .replace(queryParameters: _queryParameters);
    var response = await _httpClient.deleteUri(
      _uri,
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return AvailabilityHour.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<AvailabilityHour>> getAvailabilityHours(Salon _salon) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("availability_hours/${_salon.id}")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<AvailabilityHour>((obj) => AvailabilityHour.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Salon>> getSalons(int page) async {
    var _queryParameters = {
      'only': 'id;name',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
      'api_token': authService.apiToken,
    };
    if (page != null) {
      _queryParameters['only'] =
          'id;name;description;salonLevel;salonLevel.name;media';
      _queryParameters['with'] = 'salonLevel;media';

      _queryParameters['limit'] = '4';
      //  _queryParameters['offset'] = ((page - 1) * 4).toString();
    }
    Uri _uri = getApiBaseUri("salon_owner/salons")
        .replace(queryParameters: _queryParameters);
    print(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    print(response.data);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Salon>((obj) => Salon.fromJson(obj))
          .toList();
    } else {
      //throw new Exception(response.data['message']);
    }
  }

  Future<Map> getInsight(String toDate, fromDate) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    if (toDate != null && toDate != "") {
      _queryParameters['toDate'] = toDate;
      _queryParameters['fromDate'] = fromDate;
    }
    Uri _uri = getApiBaseUri("salon_owner/get-bussiness-insight")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'];
    } else {
      throw new Exception(response.data['message']);
    }
  }
  Future<Map> countBooking(String from,String to) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
      'from_date':from,
      'to_date':to,
    };
    Uri _uri = getApiBaseUri("salon_owner/booking-counter")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    print("countboking${response}");
    if (response.data['success'] == true) {
      return response.data;
    } else {
      throw new Exception(response.data['message']);
    }
  }
  Future<Map> deleteBooking(String employeeId) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("salon_owner/cancel-bookings/${employeeId}")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    print("deleteboking${response}");
    if (response.data['success'] == true) {
      return response.data;
    } else {
      throw new Exception(response.data['message']);
    }
  }
  Future<Map> getContact() async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("salon_owner/contact-details")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'][0];
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<OfferModel>> getOffer(String type) async {
    var _queryParameters = {'api_token': authService.apiToken, 'type': type};
    Uri _uri = getApiBaseUri("salon_owner/get-offers")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<OfferModel>((obj) => OfferModel.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Map> onOffOffer(status) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
      'status': status.toString(),
    };
    Uri _uri = getApiBaseUri("salon_owner/active-inactive-offers")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Map> deleteOffer(id) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
      'id': id.toString(),
    };
    Uri _uri = getApiBaseUri("salon_owner/remove-offers")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Map> updateSeats(Map param) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    print(jsonEncode(param));
    Uri _uri = getApiBaseUri("salon_owner/update-salon-seats")
        .replace(queryParameters: _queryParameters);
    var response = await _httpClient.postUri(_uri,
        data: jsonEncode(param), options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'];
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Map> updateDuty(Map param) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    print(jsonEncode(param));
    Uri _uri = getApiBaseUri("salon_owner/update-offduty-seats")
        .replace(queryParameters: _queryParameters);
    var response = await _httpClient.postUri(_uri,
        data: jsonEncode(param), options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'];
    } else {
      throw new Exception(response.data['message']);
    }
  }
  Future<List<QueryModel>> getContactQuery() async {

    // TODO get Only Recommended
    Map<String, dynamic> _queryParameters = {

    };
    if (authService.apiToken != "") {
      _queryParameters['api_token'] = authService.apiToken;
    }

    Uri _uri =
    getApiBaseUri("salon_owner/get-contact-info").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<QueryModel>((obj) => QueryModel.fromJson(obj))
          .toList();
    } else {
      return  [];
      //  throw new Exception(response.data['message']);
    }
  }
  Future<String> updateQuery(Map param) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    print(jsonEncode(param));
    Uri _uri = getApiBaseUri("salon_owner/send-contact-info")
        .replace(queryParameters: _queryParameters);
    var response = await _httpClient.postUri(_uri,
        data: jsonEncode(param), options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['message'];
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<String> addOffer(Map param) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    print(jsonEncode(param));
    Uri _uri = getApiBaseUri("salon_owner/add-offers")
        .replace(queryParameters: _queryParameters);
    var response = await _httpClient.postUri(_uri,
        data: jsonEncode(param), options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['message'];
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Salon>> getAcceptedSalons(int page) async {
    var _queryParameters = {
      'only': 'id;name;description;salonLevel;salonLevel.name;media',
      'with': 'salonLevel;media',
      'search': 'accepted:1',
      'searchFields': 'accepted:=',
      'searchJoin': 'and',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
      'api_token': authService.apiToken,
    };
    if (page != null) {
      _queryParameters['limit'] = '4';
      _queryParameters['offset'] = ((page - 1) * 4).toString();
    }
    Uri _uri = getApiBaseUri("salon_owner/salons")
        .replace(queryParameters: _queryParameters);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Salon>((obj) => Salon.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Salon>> getFeaturedSalons(int page) async {
    var _queryParameters = {
      'only': 'id;name;description;salonLevel;salonLevel.name;media',
      'with': 'salonLevel;media',
      'search': 'featured:1',
      'searchFields': 'accepted:=',
      'searchJoin': 'and',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
      'api_token': authService.apiToken,
    };
    if (page != null) {
      _queryParameters['limit'] = '4';
      _queryParameters['offset'] = ((page - 1) * 4).toString();
    }
    Uri _uri = getApiBaseUri("salon_owner/salons")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Salon>((obj) => Salon.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Salon>> getPendingSalons(int page) async {
    var _queryParameters = {
      'only': 'id;name;description;salonLevel;salonLevel.name;media',
      'with': 'salonLevel;media',
      'search': 'accepted:0',
      'searchFields': 'accepted:=',
      'searchJoin': 'and',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
      'api_token': authService.apiToken,
    };
    if (page != null) {
      _queryParameters['limit'] = '4';
      _queryParameters['offset'] = ((page - 1) * 4).toString();
    }
    Uri _uri = getApiBaseUri("salon_owner/salons")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Salon>((obj) => Salon.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<SalonLevel>> getSalonLevels() async {
    var _queryParameters = {
      'only': 'id;name',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("salon_owner/salon_levels")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<SalonLevel>((obj) => SalonLevel.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Review>> getSalonReviews() async {
    var _queryParameters = {
      'with': 'booking;booking.user',
      'only': 'id;review;rate;created_at;booking',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
      'limit': '10',
      'api_token': authService.apiToken,
    };
    print(_queryParameters);
    Uri _uri = getApiBaseUri("salon_reviews")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Review>((obj) => Review.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Review> getSalonReview(String reviewId) async {
    var _queryParameters = {
      'with': 'eService;user',
      'only': 'id;review;rate;user;eService',
    };
    Uri _uri = getApiBaseUri("salon_reviews/$reviewId")
        .replace(queryParameters: _queryParameters);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return Review.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Gallery>> getSalonGalleries(String salonId) async {
    var _queryParameters = {
      'with': 'media',
      'search': 'salon_id:$salonId',
      'searchFields': 'salon_id:=',
      'orderBy': 'updated_at',
      'sortedBy': 'desc',
    };
    Uri _uri =
        getApiBaseUri("galleries").replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Gallery>((obj) => Gallery.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Award>> getSalonAwards(String salonId) async {
    var _queryParameters = {
      'search': 'salon_id:$salonId',
      'searchFields': 'salon_id:=',
      'orderBy': 'updated_at',
      'sortedBy': 'desc',
    };
    Uri _uri =
        getApiBaseUri("awards").replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Award>((obj) => Award.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Experience>> getSalonExperiences(String salonId) async {
    var _queryParameters = {
      'search': 'salon_id:$salonId',
      'searchFields': 'salon_id:=',
      'orderBy': 'updated_at',
      'sortedBy': 'desc',
    };
    Uri _uri =
        getApiBaseUri("experiences").replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Experience>((obj) => Experience.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getSalonFeaturedEServices(
      String salonId, int page) async {
    var _queryParameters = {
      'with': 'salon;salon.address;categories',
      'search': 'featured:1',
      'searchFields': 'featured:=',
      'limit': '4',
      'offset': ((page - 1) * 4).toString(),
      'api_token': authService.apiToken,
    };
    if (salonId != null) {
      _queryParameters['search'] += ';salon_id:$salonId';
      _queryParameters['searchFields'] += ';salon_id:=';
      _queryParameters['searchJoin'] = 'and';
    }
    Uri _uri = getApiBaseUri("salon_owner/e_services")
        .replace(queryParameters: _queryParameters);
    print(_uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']['eServices']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getSalonPopularEServices(
      String salonId, int page) async {
    // TODO popular eServices
    var _queryParameters = {
      'with': 'salon;salon.address;categories',
      'rating': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString(),
      'api_token': authService.apiToken,
    };
    if (salonId != null) {
      _queryParameters['search'] = 'salon_id:$salonId';
      _queryParameters['searchFields'] = 'salon_id:=';
      _queryParameters['searchJoin'] = 'and';
    }
    Uri _uri = getApiBaseUri("salon_owner/e_services")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']['eServices']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getSalonAvailableEServices(
      String salonId, int page) async {
    var _queryParameters = {
      'with': 'salon;salon.address;categories',
      'available_salon': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString(),
      'api_token': authService.apiToken
    };
    if (salonId != null) {
      _queryParameters['search'] = 'salon_id:$salonId';
      _queryParameters['searchFields'] = 'salon_id:=';
      _queryParameters['searchJoin'] = 'and';
    }
    Uri _uri = getApiBaseUri("salon_owner/e_services")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']['eServices']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<User>> getSalonEmployees(String salonId) async {
    var _queryParameters = {
      'with': 'users',
      'only':
          'users;users.id;users.name;users.email;users.phone_number;users.device_token'
    };
    Uri _uri = getApiBaseUri("salons/$salonId")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']['users']
          .map<User>((obj) => User.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<User>> getAllEmployees() async {
    var _queryParameters = {
      'only': 'id;name;email',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("salon_owner/employees")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<User>((obj) => User.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Tax>> getTaxes() async {
    var _queryParameters = {
      'only': 'id;name;value;type',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("salon_owner/taxes")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Tax>((obj) => Tax.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Map> getEServices1() async {
    var _queryParameters = {
      'with': 'salon;salon.address;categories;media',
      'limit': '4',
      // 'offset': ((page - 1) * 4).toString(),
      'api_token': authService.apiToken,
    };

    Uri _uri = getApiBaseUri("salon_owner/category_services")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getSalonEServices(String salonId, int page) async {
    var _queryParameters = {
      'with': 'salon;salon.address;categories;media',
      'limit': '4',
      'offset': ((page - 1) * 4).toString(),
      'api_token': authService.apiToken,
    };
    if (salonId != null) {
      _queryParameters['search'] = 'salon_id:$salonId';
      _queryParameters['searchFields'] = 'salon_id:=';
      _queryParameters['searchJoin'] = 'and';
    }
    Uri _uri = getApiBaseUri("salon_owner/e_services")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']['eServices']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Review>> getEServiceReviews(String eServiceId) async {
    var _queryParameters = {
      'with': 'booking;booking.user',
      'only': 'created_at;review;rate;booking',
      'search': "booking.e_services.id:$eServiceId",
      'orderBy': 'created_at',
      'sortBy': 'desc',
      'limit': '10',
    };
    Uri _uri = getApiBaseUri("salon_reviews")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Review>((obj) => Review.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<OptionGroup>> getEServiceOptionGroups(String eServiceId) async {
    var _queryParameters = {
      'with': 'options;options.media',
      'only':
          'id;name;allow_multiple;options.id;options.name;options.description;options.price;options.option_group_id;options.e_service_id;options.media',
      'search': "options.e_service_id:$eServiceId",
      'searchFields': 'options.e_service_id:=',
      'orderBy': 'name',
      'sortBy': 'desc'
    };
    Uri _uri = getApiBaseUri("option_groups")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<OptionGroup>((obj) => OptionGroup.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<OptionGroup>> getOptionGroups() async {
    var _queryParameters = {
      'with': 'options',
      'only':
          'id;name;allow_multiple;options.id;options.name;options.description;options.price;options.option_group_id;options.e_service_id',
      'orderBy': 'name',
      'sortBy': 'desc'
    };
    Uri _uri = getApiBaseUri("option_groups")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<OptionGroup>((obj) => OptionGroup.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Category>> getAllCategories() async {
    const _queryParameters = {
      'orderBy': 'order',
      'sortBy': 'asc',
    };
    Uri _uri =
        getApiBaseUri("categories").replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Category>((obj) => Category.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Category>> getAllParentCategories() async {
    const _queryParameters = {
      'parent': 'true',
      'orderBy': 'order',
      'sortBy': 'asc',
    };
    Uri _uri =
        getApiBaseUri("categories").replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Category>((obj) => Category.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Category>> getAllWithSubCategories() async {
    const _queryParameters = {
      'with': 'subCategories',
      'parent': 'true',
      'orderBy': 'order',
      'sortBy': 'asc',
    };
    Uri _uri =
        getApiBaseUri("categories").replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Category>((obj) => Category.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Booking>> getBookings(
      String statusId, int page, String seat, date,toDate) async {
    var _queryParameters = {
      'only': 'id;salon;salon.name;salon.media;salon.has_media;address;booking_at;cancel;at_salon;bookingStatus;bookingStatus.status;'
          'bookingStatus.id;bookingStatus.order;payment;payment.paymentStatus;user;user.id;user.name;employee;employee.id;employee.name',
      'with': 'bookingStatus;payment;payment.paymentMethod;user;employee;payment.paymentStatus',
      'api_token': authService.apiToken,
      // 'search': 'booking_status_id:${statusId}',
      "filters": "${statusId}",
      'from_date': date != null ? date : "",
      'to_date': toDate != null ? toDate : "",
      'seat_no': seat != null ? seat : "",
      'orderBy': 'created_at',
      'sortedBy': 'desc',
      'limit': '50',
      'offset': ((page - 1) * 50).toString()
    };
    print(_queryParameters);
    Uri _uri =
        getApiBaseUri("bookings").replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Booking>((obj) => Booking.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> submitOTP(String bookingId, otp) async {
    var _queryParameters = {
      'only': 'id;salon;salon.name;salon.media;salon.has_media;address;booking_at;cancel;at_salon;bookingStatus;bookingStatus.status;'
          'bookingStatus.id;bookingStatus.order;payment;payment.paymentStatus;user;user.id;user.name;employee;employee.id;employee.name',
      'with': 'bookingStatus;payment;user;employee;payment.paymentStatus',
      'api_token': authService.apiToken,
      'orderBy': 'created_at',
      'sortedBy': 'desc',
      'limit': '4',
    };
    Map data = {
      "booking_id": bookingId,
      "otp": otp,
    };
    print(data);
    print(_queryParameters);
    Uri _uri =
        getApiBaseUri("verify-otp").replace(queryParameters: _queryParameters);
    var response =
        await _httpClient.postUri(_uri, data: data, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Map> getBookingStatuses() async {
    var _queryParameters = {
      // 'only': 'id;status;order',
      'api_token': authService.apiToken,
      // 'orderBy': 'order',
      //'sortedBy': 'asc',
    };
    Uri _uri = getApiBaseUri("vendor_booking_statuses")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      print(response.data['vendor_status']);
      List<BookingStatus> status = response.data['data']
          .map<BookingStatus>((obj) => BookingStatus.fromJson(obj))
          .toList();
      List<BookingStatus> filter = response.data['vendor_status']
          .map<BookingStatus>((obj) => BookingStatus.fromJson(obj))
          .toList();
      List<User> user = response.data['users']
          .map<User>((obj) => User.fromJson(obj))
          .toList();
      if (user.length > 0) {
        user.removeAt(0);
      }

      return {
        "status": status,
        "filter": filter,
        "user": user,
      };
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Booking> getBooking(String bookingId) async {
    var _queryParameters = {
      'with':
          'bookingStatus;user;employee;payment;payment.paymentMethod;payment.paymentStatus',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("bookings/${bookingId}")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Booking.fromJson(response.data['data']);
    } else {
      print(response.data['message']);
      throw new Exception(response.data['message']);
    }
  }

  Future<Booking> updateBooking(Booking booking) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("bookings/${booking.id}")
        .replace(queryParameters: _queryParameters);
    print(booking.toJson());
    var response = await _httpClient.putUri(_uri,
        data: booking.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Booking.fromJson(response.data['data']);
    } else {
      print(response.data['message']);
      throw new Exception(response.data['message']);
    }
  }

  Future<Payment> updatePayment(Payment payment) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    print(payment.toJson());
    Uri _uri = getApiBaseUri("salon_owner/payments/${payment.id}")
        .replace(queryParameters: _queryParameters);
    print(_uri);
    var response = await _httpClient.putUri(_uri,
        data: payment.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Payment.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<PaymentMethod>> getPaymentMethods() async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ getPaymentMethods() ]");
    }
    var _queryParameters = {
      'with': 'media',
      'search': 'enabled:1',
      'searchFields': 'enabled:=',
      'orderBy': 'order',
      'sortBy': 'asc',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("payment_methods")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<PaymentMethod>((obj) => PaymentMethod.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Wallet>> getWallets() async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ getWallets() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri =
        getApiBaseUri("wallets").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Wallet>((obj) => Wallet.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Wallet> createWallet(Wallet _wallet) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ createWallet() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri =
        getApiBaseUri("wallets").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.postUri(_uri,
        data: _wallet.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Wallet.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Wallet> updateWallet(Wallet _wallet) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ updateWallet() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("wallets/${_wallet.id}")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.putUri(_uri,
        data: _wallet.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Wallet.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> deleteWallet(Wallet _wallet) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ deleteWallet() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("wallets/${_wallet.id}")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.deleteUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'];
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<WalletTransaction>> getWalletTransactions(Wallet wallet) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ getWalletTransactions() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'with': 'user',
      'search': 'wallet_id:${wallet.id}',
      'searchFields': 'wallet_id:=',
    };
    Uri _uri = getApiBaseUri("wallet_transactions")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<WalletTransaction>((obj) => WalletTransaction.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  String getPayPalUrl(SalonSubscription salonSubscription) {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ getPayPalUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'subscription_package_id': salonSubscription.subscriptionPackage.id,
      'salon_id': salonSubscription.salon.id,
    };
    Uri _uri = getBaseUri("subscription/payments/paypal/express-checkout")
        .replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  String getRazorPayUrl(SalonSubscription salonSubscription) {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ getRazorPayUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'subscription_package_id': salonSubscription.subscriptionPackage.id,
      'salon_id': salonSubscription.salon.id,
    };
    Uri _uri = getBaseUri("subscription/payments/razorpay/checkout")
        .replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  String getStripeUrl(SalonSubscription salonSubscription) {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ getStripeUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'subscription_package_id': salonSubscription.subscriptionPackage.id,
      'salon_id': salonSubscription.salon.id,
    };
    Uri _uri = getBaseUri("subscription/payments/stripe/checkout")
        .replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  String getPayStackUrl(SalonSubscription salonSubscription) {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ getPayStackUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'subscription_package_id': salonSubscription.subscriptionPackage.id,
      'salon_id': salonSubscription.salon.id,
    };
    Uri _uri = getBaseUri("subscription/payments/paystack/checkout")
        .replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  String getPayMongoUrl(SalonSubscription salonSubscription) {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ getPayMongoUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'subscription_package_id': salonSubscription.subscriptionPackage.id,
      'salon_id': salonSubscription.salon.id,
    };
    Uri _uri = getBaseUri("subscription/payments/paymongo/checkout")
        .replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  String getFlutterWaveUrl(SalonSubscription salonSubscription) {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ getFlutterWaveUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'subscription_package_id': salonSubscription.subscriptionPackage.id,
      'salon_id': salonSubscription.salon.id,
    };
    Uri _uri = getBaseUri("subscription/payments/flutterwave/checkout")
        .replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  String getStripeFPXUrl(SalonSubscription salonSubscription) {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ getStripeFPXUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'subscription_package_id': salonSubscription.subscriptionPackage.id,
      'salon_id': salonSubscription.salon.id,
    };
    Uri _uri = getBaseUri("subscription/payments/stripe-fpx/checkout")
        .replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  Future<List<Notification>> getNotifications() async {
    var _queryParameters = {
      'search': 'notifiable_id:${authService.user.value.id}',
      'searchFields': 'notifiable_id:=',
      'searchJoin': 'and',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
      'limit': '50',
      'only': 'id;type;data;read_at;created_at',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("notifications")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Notification>((obj) => Notification.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Notification> markAsReadNotification(Notification notification) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("notifications/${notification.id}")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.patchUri(_uri,
        data: notification.markReadMap(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Notification.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> sendNotification(
      List<User> users, User from, String type, String text, String id) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    var data = {
      'users': users.map((e) => e.id).toList(),
      'from': from.id,
      'type': type,
      'text': text,
      'id': id,
    };
    Uri _uri = getApiBaseUri("notifications")
        .replace(queryParameters: _queryParameters);

    Get.log(data.toString());
    var response =
        await _httpClient.postUri(_uri, data: data, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Notification> removeNotification(Notification notification) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("notifications/${notification.id}")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.deleteUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Notification.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<int> getNotificationsCount() async {
    if (!authService.isAuth) {
      return 0;
    }
    var _queryParameters = {
      'search': 'notifiable_id:${authService.user.value.id}',
      'searchFields': 'notifiable_id:=',
      'searchJoin': 'and',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("notifications/count")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'];
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<FaqCategory>> getFaqCategories() async {
    var _queryParameters = {
      'orderBy': 'created_at',
      'sortedBy': 'asc',
    };
    Uri _uri = getApiBaseUri("faq_categories")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<FaqCategory>((obj) => FaqCategory.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Faq>> getFaqs(String categoryId) async {
    var _queryParameters = {
      'search': 'faq_category_id:${categoryId}',
      'searchFields': 'faq_category_id:=',
      'searchJoin': 'and',
      'orderBy': 'updated_at',
      'sortedBy': 'desc',
    };
    Uri _uri = getApiBaseUri("faqs").replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Faq>((obj) => Faq.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Setting> getSettings() async {
    Uri _uri = getApiBaseUri("salon_owner/settings");

    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Setting.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List> getModules() async {
    Uri _uri = getApiBaseUri("modules");
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'];
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Map<String, String>> getTranslations(String locale) async {
    var _queryParameters = {
      'locale': locale,
    };
    Uri _uri = getApiBaseUri("salon_owner/translations")
        .replace(queryParameters: _queryParameters);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return Map<String, String>.from(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<String>> getSupportedLocales() async {
    Uri _uri = getApiBaseUri("salon_owner/supported_locales");

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return List.from(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<CustomPage>> getCustomPages() async {
    var _queryParameters = {
      'only': 'id;title',
      'search': 'published:1',
      'orderBy': 'created_at',
      'sortedBy': 'asc',
    };
    Uri _uri = getApiBaseUri("custom_pages")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<CustomPage>((obj) => CustomPage.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<CustomPage> getCustomPageById(String id) async {
    Uri _uri = getApiBaseUri("custom_pages/$id");

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return CustomPage.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<String> uploadImage(File file, String field) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ uploadImage() ]");
    }
    if (file != null) {
      var _queryParameters = {
        'api_token': authService.apiToken,
      };
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("https://saloon.developmentalphawizz.com/api/uploads/store")
            .replace(queryParameters: _queryParameters),
      );
      print(
          Uri.parse("https://saloon.developmentalphawizz.com/api/uploads/store")
              .replace(queryParameters: _queryParameters)
              .toString());
      final httpImage = http.MultipartFile.fromBytes(
          'file', file.readAsBytesSync(),
          contentType: MediaType("image", "${file.path.split(".").last}"),
          filename: file.path.split('/').last);
      request.files.add(httpImage);
      request.fields.addAll({
        "field": field,
        "uuid": Uuid().generateV4(),
      });
      /*request.files.add(
           await http.MultipartFile.fromPath(
              'profileImage',
              _image!.path,
              filename: _image!.path,
            ),
          );*/
      print(file.path.split('/').last);
      //   request.headers.addAll(headers);
      print("request: " + request.toString());
      print("PARAMETER: " + request.fields.toString());
      print("IMAGE PARAMETER: " + request.files.toString());
      var res = await request.send();
      print("This is response:" + res.toString());
      /*  setState(() {
            loading = false;
          });*/
      print(res.statusCode);
      final respStr = await res.stream.bytesToString();
      print(respStr.toString());
      Map data = jsonDecode(respStr.toString());
      print(data);
      if (res.statusCode == 200) {
        if (data['data'] != false) {
          return data['data'];
        } else {
          throw new Exception(data['message']);
        }
      }
    }
  }

  Future<String> uploadImage1(File file, String field) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ uploadImage() ]");
    }
    String fileName = file.path.split('/').last;
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("uploads/store")
        .replace(queryParameters: _queryParameters);
    dio.FormData formData = dio.FormData.fromMap({
      "file": await dio.MultipartFile.fromFile(file.path, filename: fileName),
      "uuid": Uuid().generateV4(),
      "field": field,
    });
    print(Uuid().generateV4());
    print(field);
    var response = await _httpClient.postUri(_uri,
        data: formData,
        options: dio.Options(
          headers: {"Accept": "*/*", 'Content-Type': "multipart/form-data"},
          // contentType: "multipart/form-data; boundary=<calculated when request is sent>",
        ));
    print({"Accept": "*/*", 'Content-Type': "multipart/form-data"});
    print(response.data);
    if (response.data['data'] != false) {
      return response.data['data'];
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> deleteUploaded(String uuid) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ deleteUploaded() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("uploads/clear")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.postUri(_uri, data: {'uuid': uuid});
    print(response.data);
    if (response.data['data'] != false) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> deleteAllUploaded(List<String> uuids) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ deleteUploaded() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("uploads/clear")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.postUri(_uri, data: {'uuid': uuids});
    print(response.data);
    if (response.data['data'] != false) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<SubscriptionPackage>> getSubscriptionPackages() async {
    var _queryParameters = {
      'orderBy': 'duration_in_days',
      'sortedBy': 'asc',
    };
    Uri _uri = getApiBaseUri("subscription/subscription_packages")
        .replace(queryParameters: _queryParameters);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<SubscriptionPackage>((obj) => SubscriptionPackage.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<SalonSubscription> cashSalonSubscription(
      SalonSubscription salonSubscription) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("subscription/salon_subscriptions/cash")
        .replace(queryParameters: _queryParameters);
    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(salonSubscription.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return SalonSubscription.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<SalonSubscription> walletSalonSubscription(
      SalonSubscription salonSubscription, Wallet _wallet) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
      'wallet_id': _wallet.id,
    };
    Uri _uri = getApiBaseUri("subscription/salon_subscriptions/wallet")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(salonSubscription.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return SalonSubscription.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<SalonSubscription>> getSalonSubscriptions() async {
    var _queryParameters = {
      'with': 'salon;subscriptionPackage;payment;payment.paymentMethod',
      'orderBy': 'updated_at',
      'sortedBy': 'desc',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("subscription/salon_subscriptions")
        .replace(queryParameters: _queryParameters);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<SalonSubscription>((obj) => SalonSubscription.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }
}

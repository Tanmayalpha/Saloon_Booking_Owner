import 'dart:convert';
import 'dart:math';

import 'package:beauty_salons_owner/app/services/auth_service.dart';
import 'package:beauty_salons_owner/common/ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


import 'package:razorpay_flutter/razorpay_flutter.dart';

String razorPayKey="rzp_test_UUBtmcArqOLqIY";
String razorPaySecret="NTW3MUbXOtcwUrz5a4YCshqk";
class RazorPayHelper{
  String amount;
  String orderId;
  BuildContext context;
  ValueChanged onResult;
  Razorpay _razorpay;
  final authService = Get.find<AuthService>();
  RazorPayHelper(this.amount, this.context, this.onResult);
  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  init(){
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    getOrder();
  }
  void getOrder() async {
    String username = razorPayKey;
    String password = razorPaySecret;
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));
    double newmoney=double.parse(amount.toString())*100;
    int nw=newmoney.toInt();
    print(nw);
    Map data = {
      "amount":nw.toString(),
      "currency": "INR",
      "receipt": "receipt_" + getRandomString(5)
    }; // as per my experience the receipt doesn't play any role in helping you generate a certain pattern in your Order ID!!

    var headers = {"content-type": "application/json"};

    var res = await http.post(Uri.parse('https://api.razorpay.com/v1/orders'),
        headers: <String, String>{'authorization': basicAuth}, body: data);
    print(res.body);
    if (res.statusCode == 200) {
      Map data2 = json.decode(res.body);
      orderId = data2['id'];
      openCheckout(amount);
    }
    else
    {

      print(res.body);
      print(res.statusCode);
    }
  }
  void openCheckout(String amt) async {

  String  name = authService.user.value.name;
  String   email =authService.user.value.email;
    var options = {
      'key': razorPayKey,
      'amount': amt,
      'name': 'Trimzzy',
      "order_id":orderId,
      'description': "Order #"+getRandomString(5),
      'external': {
        'wallets': ['paytm']
      },
      'prefill': {
        'name': name,
        'email': email,
      },
      "notify": {
        "sms": true,
        "email": true
      },
      "reminder_enable": true,
    };

    try {
      _razorpay.open(options);
    } catch (e) {

      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {

    onResult(response.orderId);
    // Fluttertoast.showToast(
    //     msg: "SUCCESS: " + response.paymentId!, toastLength: Toast.LENGTH_SHORT);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    onResult("error");
    Get.closeAllSnackbars();
    Get.showSnackbar(Ui.ErrorSnackBar(message: "Payment Cancelled".toString()));
    //setSnackbar("ERROR: " + response.code.toString() + " - " + response.message.toString(), context);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    onResult(response.walletName);
    }
}
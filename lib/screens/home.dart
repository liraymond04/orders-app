import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:orders_app/widgets/list/list_widget.dart';
import 'package:orders_app/widgets/payment/pay_button.dart';
import 'package:orders_app/config.dart';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/google_pay_constants.dart' as google_pay_constants;
import 'package:square_in_app_payments/models.dart';

class HomePage extends StatefulWidget {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  const HomePage({ Key? key, required this.firestore, required this.storage }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  bool applePayEnabled = false;
  bool googlePayEnabled = false;

  @override
  void initState() {
    super.initState();
    _initSquarePayment();
  }

  Future<void> _initSquarePayment() async {
    await InAppPayments.setSquareApplicationId(squareApplicationId);

    var canUseApplePay = false;
    var canUseGooglePay = false;
    if (Platform.isAndroid) {
      await InAppPayments.initializeGooglePay(squareLocationId, google_pay_constants.environmentTest);
      canUseGooglePay = await InAppPayments.canUseGooglePay;
    } else if (Platform.isIOS) {
      await _setIOSCardEntryTheme();
      await InAppPayments.initializeApplePay(applePayMerchantId);
      canUseApplePay = await InAppPayments.canUseApplePay;
    }

    setState(() {
      isLoading = false;
      applePayEnabled = canUseApplePay;
      googlePayEnabled = canUseGooglePay;
    });
  }

  Future _setIOSCardEntryTheme() async {
    var themeConfiguationBuilder = IOSThemeBuilder();
    themeConfiguationBuilder.saveButtonTitle = 'Pay';
    themeConfiguationBuilder.errorColor = RGBAColorBuilder()
      ..r = 255
      ..g = 0
      ..b = 0;
    themeConfiguationBuilder.tintColor = RGBAColorBuilder()
      ..r = 36
      ..g = 152
      ..b = 141;
    themeConfiguationBuilder.keyboardAppearance = KeyboardAppearance.light;
    themeConfiguationBuilder.messageColor = RGBAColorBuilder()
      ..r = 114
      ..g = 114
      ..b = 114;
    await InAppPayments.setIOSCardEntryTheme(themeConfiguationBuilder.build());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: isLoading ? Center(
        child: CircularProgressIndicator(),
      ) : Column(
        children: <Widget>[
          ListWidget(firestore: widget.firestore),
          Container(
            margin: EdgeInsets.only(bottom: 10.0),
            child: PayButton(
              applePayEnabled: applePayEnabled,
              googlePayEnabled: googlePayEnabled,
              applePayMerchantId: applePayMerchantId,
              squareLocationId: squareLocationId,
            ),
          ),
        ],
      ),
    );
  }
}
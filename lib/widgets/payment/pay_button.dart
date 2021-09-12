import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:orders_app/models/cart.dart';
import 'package:orders_app/widgets/payment/pay_card_select.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as custom_modal_bottom_sheet;
import 'package:orders_app/widgets/dialog_modal.dart';
import 'package:orders_app/services/payment.dart';

import 'package:provider/provider.dart';
import 'package:square_in_app_payments/models.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/google_pay_constants.dart' as google_pay_constants;

enum ApplePayStatus { success, fail, unknown }

class PayButton extends StatefulWidget {
  final bool? applePayEnabled;
  final bool? googlePayEnabled;
  final String? squareLocationId;
  final String? applePayMerchantId;

  const PayButton({ Key? key, this.applePayEnabled, this.googlePayEnabled, this.applePayMerchantId, this.squareLocationId }) : super(key: key);

  @override
  _PayButtonState createState() => _PayButtonState();
}

class _PayButtonState extends State<PayButton> {
  ApplePayStatus _applePayStatus = ApplePayStatus.unknown;

  bool get _chargeServerHostReplaced => chargeServerHost != "REPLACE_ME";
  bool get _squareLocationSet => widget.squareLocationId != "REPLACE_ME";
  bool get _applePayMerchantIdSet => widget.applePayMerchantId != "REPLACE_ME";

  void _showPayCardSelect() async {
    var selection = await custom_modal_bottom_sheet.showMaterialModalBottomSheet<PaymentType>(
      context: this.context,
      builder: (context) => PayCardSelect(
        applePayEnabled: widget.applePayEnabled!,
        googlePayEnabled: widget.googlePayEnabled!,
      ),
      backgroundColor: Colors.transparent,
    );

    switch (selection) {
      case PaymentType.cardPayment:
        await _onStartCardEntryFlow();
        break;
      case PaymentType.googlePay:
        if (_squareLocationSet && widget.googlePayEnabled!) {
          _onStartGooglePay();
        } else {
          _showSquareLocationIdNotSet();
        }
        break;
      case PaymentType.applePay:
        if (_applePayMerchantIdSet && widget.applePayEnabled!) {
          _onStartApplePay();
        } else {
          _showapplePayMerchantIdNotSet();
        }
        break;
      default:
        break;
    }
  }

  void _showSquareLocationIdNotSet() {
    showAlertDialog(
      context: this.context,
      title: "Missing Square Location ID",
      description: "To request a Google Pay nonce, replace squareLocationId in main.dart with a Square Location ID."
    );
  }

  void _showapplePayMerchantIdNotSet() {
    showAlertDialog(
      context: this.context,
      title: "Missing Apple Merchant ID",
      description: "To request an Apple Pay nonce, replace applePayMerchantId in main.dart with an Apple Merchant ID."
    );
  }

  void _onCardEntryComplete() {
    if (_chargeServerHostReplaced) {
      showAlertDialog(
        context: this.context,
        title: "Your order was successful",
        description: "Go to your Square dashboard to see this order reflected in the sales tab."
      );
    }
  }

  void _onCardEntryCardNonceRequestSuccess(CardDetails result) async {
    if (!_chargeServerHostReplaced) {
      InAppPayments.completeCardEntry(
        onCardEntryComplete: _onCardEntryComplete
      );
      return;
    }
    try {
      await chargeCard(context, result);
      InAppPayments.completeCardEntry(
        onCardEntryComplete: _onCardEntryComplete
      );
    } on ChargeException catch (ex) {
      InAppPayments.showCardNonceProcessingError(ex.errorMessage);
    }
  }

  Future<void> _onStartCardEntryFlow() async {
    await InAppPayments.startCardEntryFlow(
      onCardNonceRequestSuccess: _onCardEntryCardNonceRequestSuccess,
      onCardEntryCancel: _onCancelCardEntryFlow,
      collectPostalCode: false
    );
  }

  void _onCancelCardEntryFlow() {
    _showPayCardSelect();
  }

  void _onStartGooglePay() async {
    try {
      await InAppPayments.requestGooglePayNonce(
        priceStatus: google_pay_constants.totalPriceStatusFinal,
        price: getPrice(this.context, 1.05),
        currencyCode: 'CAD',
        onGooglePayNonceRequestSuccess: _onGooglePayNonceRequestSuccess,
        onGooglePayNonceRequestFailure: _onGooglePayNonceRequestFailure,
        onGooglePayCanceled: onGooglePayEntryCanceled
      );
    } on PlatformException catch (ex) {
      showAlertDialog(
        context: this.context,
        title: "Failed to start GooglePay",
        description: ex.toString()
      );
    }
  }

  void _onGooglePayNonceRequestSuccess(CardDetails result) async {
    if (!_chargeServerHostReplaced) {
      return;
    }
    try {
      await chargeCard(context, result);
      showAlertDialog(
        context: this.context,
        title: "Your order was successful",
        description: "Go to your Square dashbord to see this order reflected in the sales tab."
      );
    } on ChargeException catch (ex) {
      showAlertDialog(
        context: this.context,
        title: "Error processing GooglePay payment",
        description: ex.errorMessage
      );
    }
  }

  void _onGooglePayNonceRequestFailure(ErrorInfo errorInfo) {
    showAlertDialog(
      context: this.context,
      title: "Failed to request GooglePay nonce",
      description: errorInfo.toString()
    );
  }

  void onGooglePayEntryCanceled() {
    _showPayCardSelect();
  }

  void _onStartApplePay() async {
    try {
      await InAppPayments.requestApplePayNonce(
        price: getPrice(this.context, 1.05),
        summaryLabel: 'Cookie',
        countryCode: 'CA',
        currencyCode: 'CAD',
        paymentType: ApplePayPaymentType.finalPayment,
        onApplePayNonceRequestSuccess: _onApplePayNonceRequestSuccess,
        onApplePayNonceRequestFailure: _onApplePayNonceRequestFailure,
        onApplePayComplete: _onApplePayEntryComplete
      );
    } on PlatformException catch (ex) {
      showAlertDialog(
        context: this.context,
        title: "Failed to start ApplePay",
        description: ex.toString()
      );
    }
  }

  void _onApplePayNonceRequestSuccess(CardDetails result) async {
    if (!_chargeServerHostReplaced) {
      await InAppPayments.completeApplePayAuthorization(isSuccess: false);
      return;
    }
    try {
      await chargeCard(context, result);
      _applePayStatus = ApplePayStatus.success;
      showAlertDialog(
        context: this.context,
        title: "Your order was successful",
        description: "Go to your Square dashbord to see this order reflected in the sales tab."
      );
      await InAppPayments.completeApplePayAuthorization(isSuccess: true);
    } on ChargeException catch (ex) {
      await InAppPayments.completeApplePayAuthorization(
        isSuccess: false, errorMessage: ex.errorMessage
      );
      showAlertDialog(
        context: this.context,
        title: "Error processing ApplePay payment",
        description: ex.errorMessage
      );
      _applePayStatus = ApplePayStatus.fail;
    }
  }

  void _onApplePayNonceRequestFailure(ErrorInfo errorInfo) async {
    _applePayStatus = ApplePayStatus.fail;
    await InAppPayments.completeApplePayAuthorization(
      isSuccess: false, errorMessage: errorInfo.message
    );
    showAlertDialog(
      context: this.context,
      title: "Error request ApplePay nonce",
      description: errorInfo.toString()
    );
  }

  void _onApplePayEntryComplete() {
    if (_applePayStatus == ApplePayStatus.unknown) {
      _showPayCardSelect();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, child) {
        return ElevatedButton(
          onPressed: (cart.totalItems > 0) ? _showPayCardSelect : null,
          child: Text('Pay (${cart.totalItems}): \$${cart.totalPrice.toStringAsFixed(2)}'),
        );
      },
    );
  }
}
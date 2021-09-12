import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:orders_app/models/cart.dart';
import 'package:square_in_app_payments/models.dart';
import 'package:http/http.dart' as http;

String chargeServerHost = "https://orders-app2.herokuapp.com";
Uri chargeUrl = Uri.parse("$chargeServerHost/chargePayment");

class ChargeException implements Exception {
  String errorMessage;
  ChargeException(this.errorMessage);
}

Future<void> chargeCard(BuildContext context, CardDetails result) async {
  var cart = context.read<Cart>();
  var body = jsonEncode({"nonce": result.nonce, "orders": cart.toLineItems()});
  http.Response response;
  try {
    response = await http.post(chargeUrl, body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    });
  } on SocketException catch (ex) {
    throw ChargeException(ex.message);
  }

  var responseBody = json.decode(response.body);
  if (response.statusCode == 200) {
    return;
  } else {
    throw ChargeException(responseBody["errorMessage"]);
  }
}
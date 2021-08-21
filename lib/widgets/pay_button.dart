import 'package:flutter/material.dart';
import 'package:orders_app/models/cart.dart';
import 'package:orders_app/screens/pay.dart';

import 'package:provider/provider.dart';

class PayButton extends StatefulWidget {
  const PayButton({ Key? key }) : super(key: key);

  @override
  _PayButtonState createState() => _PayButtonState();
}

class _PayButtonState extends State<PayButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, child) {
        return ElevatedButton(
          onPressed: (cart.totalItems > 0) ? () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return PaymentPage();
              }),
            );
          } : null,
          child: Text('Pay (${cart.totalItems}): \$${cart.totalPrice.toStringAsFixed(2)}'),
        );
      },
    );
  }
}
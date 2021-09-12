import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:orders_app/models/cart.dart';
import 'package:orders_app/models/item.dart';
import 'package:provider/provider.dart';

enum PaymentType { cardPayment, googlePay, applePay }

List<Item> getCartItems(BuildContext context) {
  var cart = context.read<Cart>();
  List<Item> retVal = new List<Item>.from(cart.items);
  retVal.sort((a, b) {
    if (a.day_order == b.day_order) return a.order.compareTo(b.order);
    return a.day_order.compareTo(b.day_order); 
  });
  return retVal;
}

String getPrice(BuildContext context, [num mult = 1]) {
  var cart = context.read<Cart>();
  return (cart.totalPrice * mult).toStringAsFixed(2);
}

class PayCardSelect extends StatelessWidget {
  final bool googlePayEnabled;
  final bool applePayEnabled;
  PayCardSelect({required this.googlePayEnabled, required this.applePayEnabled});

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: const Radius.circular(20.0),
        topRight: const Radius.circular(20.0),
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, top: 10),
          child: _title(context),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width,
            minHeight: 0,
            maxHeight: MediaQuery.of(context).size.height,
            maxWidth: MediaQuery.of(context).size.width),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: _PaymentList(),
              ),
              Container(
                margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: _LineDivider(),
              ),
              Container(
                margin: EdgeInsets.only(top: 5.0),
                child: _PaymentSubtotal(),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 5.0),
                child: _PaymentGST(),
              ),
              Container(
                margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: _PaymentTotal(),
              ),
              Container(
                margin: EdgeInsets.only(top: 10.0, bottom: 20.0),
                child: _payButtons(context),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _title(context) => Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      Container(
        child: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.close),
        color: Colors.black,
      )),
      Container(
        child: Expanded(
          child: Text(
            "Place your order",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      Padding(padding: EdgeInsets.only(right: 56)),
    ]
  );

  Widget _payButtons(context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      ElevatedButton(
        child: Text("Pay with card"),
        onPressed: () {
          Navigator.pop(context, PaymentType.cardPayment);
        },
      ),
      Container(
        height: 64,
        width: MediaQuery.of(context).size.width * .3,
        child: ElevatedButton(
          onPressed: googlePayEnabled || applePayEnabled ? () {
            if (Platform.isAndroid) {
              Navigator.pop(context, PaymentType.googlePay);
            } else if (Platform.isIOS) {
              Navigator.pop(context, PaymentType.applePay);
            }
          } : null,
          child: Image(
            image: (Theme.of(context).platform == TargetPlatform.iOS) ? AssetImage("assets/applePayLogo.png") : AssetImage("assets/googlePayLogo.png")
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0)
            ),
          ),
        ),
      ),
    ],
  );
}

class _PaymentList extends StatelessWidget {
  _PaymentList({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> _children = [];
    for (var _item in getCartItems(context)) {
      _children.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(left: 30)),
            Text(
              _item.name,
              style: TextStyle(color: Colors.black),
            ),
            Spacer(),
            Text(
              "\$${_item.price.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            Padding(padding: EdgeInsets.only(right: 150)),
          ],
        ),
      );
    }
    return Column(
      children: _children,
    );
  }
}

class _LineDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    margin: EdgeInsets.only(left: 30, right: 30),
    child: Divider(
      height: 1,
    ),
    color: Colors.black,
  );
}

class _PaymentSubtotal extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Padding(padding: EdgeInsets.only(left: 30)),
      Text(
        "Subtotal",
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[600]),
      ),
      Spacer(),
      Text(
        "\$${getPrice(context)}",
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[600]),
        textAlign: TextAlign.center,
      ),
      Padding(padding: EdgeInsets.only(right: 150)),
    ],
  );
}

class _PaymentGST extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Padding(padding: EdgeInsets.only(left: 30)),
      Text(
        "GST",
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[600]),
      ),
      Spacer(),
      Text(
        "\$${getPrice(context, 0.05)}",
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[600]),
        textAlign: TextAlign.center,
      ),
      Padding(padding: EdgeInsets.only(right: 150)),
    ],
  );
}

class _PaymentTotal extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Padding(padding: EdgeInsets.only(left: 30)),
      Text(
        "Total",
        style: TextStyle(color: Colors.black),
      ),
      Spacer(),
      Text(
        "\$${getPrice(context, 1.05)}",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
        textAlign: TextAlign.center,
      ),
      Padding(padding: EdgeInsets.only(right: 150)),
    ],
  );
}
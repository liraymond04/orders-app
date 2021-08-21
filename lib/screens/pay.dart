import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orders_app/orders_app_icons.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({ Key? key }) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(left: 85.0, right: 85.0),
              child: ElevatedButton(
                onPressed: () {

                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(right: 10.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.payment,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Text('Credit/Debit Card'),
                  ]
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 85.0, right: 85.0),
              child: ElevatedButton(
                onPressed: () {

                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(right: 10.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            OrdersApp.apple, 
                            size: 20,
                          ),
                          SizedBox(width: 5),
                          Icon(
                            OrdersApp.google,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Text('Native Payment'),
                  ]
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 85.0, right: 85.0),
              child: ElevatedButton(
                onPressed: () {

                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(right: 10.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            OrdersApp.paypal,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Text('Paypal'),
                  ]
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
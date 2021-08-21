import 'package:flutter/material.dart';
import 'package:orders_app/widgets/list_widget.dart';
import 'package:orders_app/widgets/pay_button.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  final FirebaseFirestore firestore;

  const HomePage({ Key? key, required this.firestore }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Column(
        children: <Widget>[
          ListWidget(firestore: widget.firestore),
          PayButton(),
        ],
      ),
    );
  }
}
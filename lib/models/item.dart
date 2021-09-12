import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  String name = '';
  String description = '';
  num price = 0;
  int order = -1;
  int day_order = -1;
  String image = '';

  Item({
    required this.name,
    required this.description,
    required this.price,
    required this.order,
    required this.day_order,
    required this.image,
  });

  Item.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot, required day}) {
    name = documentSnapshot['name'] as String;
    description = documentSnapshot['description'] as String;
    price = documentSnapshot['price'] as num;
    order = documentSnapshot['order'] as int;
    day_order = day;
    image = documentSnapshot['image'] as String;
  }

  Map<String, dynamic> toLineItem() => {
    'quantity': '1',
    'name': name,
    'basePriceMoney': {
      'amount': (price * 100).toStringAsFixed(0),
      'currency': 'CAD',
    },
  };
}
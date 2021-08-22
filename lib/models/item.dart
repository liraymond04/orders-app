import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  String name = '';
  String description = '';
  num price = 0;
  int order = -1;
  String image = '';
  bool selected = false;

  Item({
    required this.name,
    required this.description,
    required this.price,
    required this.order,
    required this.image,
    required this.selected,
  });

  Item.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    name = documentSnapshot['name'] as String;
    description = documentSnapshot['description'] as String;
    price = documentSnapshot['price'] as num;
    order = documentSnapshot['order'] as int;
    image = documentSnapshot['image'] as String;
  }
}
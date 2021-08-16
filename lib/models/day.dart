import 'package:cloud_firestore/cloud_firestore.dart';

class Day {
  String name = '';
  String id = '';
  int order = -1;

  Day({
    required this.name,
    required this.id,
    required this.order,
  });

  Day.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    name = documentSnapshot['name'] as String;
    id = documentSnapshot['id'] as String;
    order = documentSnapshot['order'] as int;
  }
}
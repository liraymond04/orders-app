import 'package:orders_app/models/day.dart';
import 'package:orders_app/models/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  final FirebaseFirestore firestore;

  Database({required this.firestore});

  Stream<List<Day>> streamDays() {
    try {
      return firestore
          .collection("days")
          .snapshots()
          .map((query) {
        final List<Day> retVal = <Day>[];
        for (final DocumentSnapshot doc in query.docs) {
          retVal.add(Day.fromDocumentSnapshot(documentSnapshot: doc));
        }
        retVal.sort((a, b) => a.order.compareTo(b.order));
        return retVal;
      });
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Item>> streamItems({required String id, required int index}) {
    try {
      return firestore
          .collection("days")
          .doc(id)
          .collection("items")
          .snapshots()
          .map((query) {
        final List<Item> retVal = <Item>[];
        for (final DocumentSnapshot doc in query.docs) {
          retVal.add(Item.fromDocumentSnapshot(documentSnapshot: doc, day: index));
        }
        retVal.sort((a, b) => a.order.compareTo(b.order));
        return retVal;
      });
    } catch (e) {
      rethrow;
    }
  }
}
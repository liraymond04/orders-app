import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:orders_app/models/item.dart';

class Cart extends ChangeNotifier {
  final List<Item> _items = [];

  UnmodifiableListView<Item> get items => UnmodifiableListView(_items);

  num get totalPrice {
    num value = 0;
    _items.forEach((item) {
      value += item.price;
    });
    return value;
  }

  int get totalItems {
    return _items.length;
  }

  void add(Item item) {
    if (!_items.contains(item)) {
      _items.add(item);
    }
    notifyListeners();
  }

  void remove(Item item) {
    _items.remove(item);
    notifyListeners();
  }
}
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
    if (!contains(item)) {
      _items.add(item);
    }
    notifyListeners();
  }

  void remove(Item item) {
    int remove = -1;
    for (int i=0; i<_items.length; i++) {
      if (_items[i].name == item.name) {
        remove = i;
      };
    }
    if (remove != -1) {
      _items.removeAt(remove);
    }
    notifyListeners();
  }

  bool contains(Item item) {
    for (Item i in _items) {
      if (i.name == item.name) return true;
    }
    return false;
  }

  List<Map<String, dynamic> > toLineItems() {
    List<Map<String, dynamic> > result = [];
    for (int i=0; i<_items.length; i++) {
      Map<String, dynamic> cur = _items[i].toLineItem();
      result.add(cur);
    }
    return result;
  }
}
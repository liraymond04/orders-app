import 'package:flutter/material.dart';
import 'package:orders_app/screens/home.dart';
import 'package:orders_app/screens/settings.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class TabNavigationItem {
  final Widget page;
  final String title;
  final Icon icon;

  TabNavigationItem({
    required this.page,
    required this.title,
    required this.icon,
  });

  static List<TabNavigationItem> items({ required FirebaseFirestore firestore, required FirebaseStorage storage}) {
    return [
      TabNavigationItem(
        page: HomePage(
          firestore: firestore,
          storage: storage,
        ),
        icon: Icon(Icons.home),
        title: "Home",
      ),
      TabNavigationItem(
        page: SettingsPage(),
        icon: Icon(Icons.settings),
        title: "Settings",
      ),
    ];
  }
}
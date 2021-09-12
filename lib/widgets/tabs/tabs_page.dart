import 'package:flutter/material.dart';
import 'package:orders_app/widgets/tabs/tabs_item.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class TabsPage extends StatefulWidget {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  const TabsPage({ Key? key, required this.firestore, required this.storage }) : super(key: key);
  
  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          for (final tabItem in TabNavigationItem.items(firestore: widget.firestore, storage: widget.storage)) tabItem.page,
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index) => setState(() => _currentIndex = index),
          items: <BottomNavigationBarItem>[
            for (final tabItem in TabNavigationItem.items(firestore: widget.firestore, storage: widget.storage)) 
              BottomNavigationBarItem(
                icon: tabItem.icon,
                label: tabItem.title,
              ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:orders_app/models/item.dart';
import 'package:orders_app/services/database.dart';
import 'package:orders_app/widgets/list/list_item.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class ListDay extends StatefulWidget {
  final String id;
  final int index;
  final FirebaseFirestore firestore;

  const ListDay({ Key? key, required this.id, required this.index, required this.firestore }) : super(key: key);

  @override
  _ListDayState createState() => _ListDayState();
}

class _ListDayState extends State<ListDay> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Database(firestore: widget.firestore).streamItems(id: widget.id, index: widget.index),
        builder: (BuildContext context, AsyncSnapshot<List<Item> > snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data!.isEmpty) {
              print(widget.id);
              return const Center(
                child: Text('Could not find items'),
              );
            }
            return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) {
                return ListItem(
                  item: snapshot.data![index],
                  firestore: widget.firestore,
                );
              }
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
    );
  }
}
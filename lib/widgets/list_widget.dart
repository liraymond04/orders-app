import 'package:flutter/material.dart';
import 'package:orders_app/models/day.dart';
import 'package:orders_app/services/database.dart';
import 'package:orders_app/widgets/list_day.dart';

import 'package:cloud_firestore/cloud_firestore.dart';


class ListWidget extends StatefulWidget {
  final FirebaseFirestore firestore;
  
  const ListWidget({ Key? key, required this.firestore }) : super(key: key);

  @override
  ListWidgetState createState() => ListWidgetState();
}

class ListWidgetState extends State<ListWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Database(firestore: widget.firestore).streamDays(),
      builder: (BuildContext context, AsyncSnapshot<List<Day> > snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data?.isEmpty ?? true) {
            return const Center(
              child: Text('Cannot load items'),
            );
          }
          return Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) {
                return Container(
                  margin: const EdgeInsets.only(top: 7.5),
                child: Column(
                  children: <Widget>[
                    Text(
                      snapshot.data![index].name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    ListDay(
                      id: snapshot.data![index].id,
                      firestore: widget.firestore,
                    ),
                  ],
                ),
                );
              },
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:orders_app/models/day.dart';
import 'package:orders_app/services/database.dart';
import 'package:orders_app/widgets/list_day.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  final FirebaseFirestore firestore;

  const HomePage({ Key? key, required this.firestore }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body:Column(
        children: <Widget>[
          StreamBuilder(
            stream: Database(firestore: widget.firestore).streamDays(),
            builder: (BuildContext context, AsyncSnapshot<List<Day> > snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.data?.isEmpty ?? true) {
                  return const Center(
                    child: Text('Cannot load items'),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, index) {
                    return Column(
                      children: <Widget>[
                        Text(snapshot.data![index].name),
                        ListDay(id: snapshot.data![index].id, firestore: widget.firestore),
                      ],
                    );
                  },
                );
              }
              return Center(
                child: Text('Loading...'),
              );
            },
          ),
        ],
      ),
    );
  }
}
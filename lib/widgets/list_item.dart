import 'package:flutter/material.dart';
import 'package:orders_app/models/item.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class ListItem extends StatefulWidget {
  final Item item;
  final FirebaseFirestore firestore;

  const ListItem({ Key? key, required this.item, required this.firestore }) : super(key: key);

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                widget.item.name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Text(
                widget.item.description,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Expanded(
              child: Text(
                '\$${widget.item.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Checkbox(
              value: widget.item.selected,
              onChanged: (newValue) {
                setState(() {
                  widget.item.selected = newValue as bool;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
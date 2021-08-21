import 'package:flutter/material.dart';
import 'package:orders_app/models/item.dart';
import 'package:orders_app/models/cart.dart';
import 'package:orders_app/screens/item.dart';
// import 'package:orders_app/utils/constants.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

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
    var cart = context.read<Cart>();
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return ItemPage(item: widget.item);
            }),
          );
        },
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
                  if (newValue as bool) {
                    cart.add(widget.item);
                  } else {
                    cart.remove(widget.item);
                  }
                  setState(() {
                    widget.item.selected = newValue;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
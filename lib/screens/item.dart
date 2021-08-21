import 'package:flutter/material.dart';
import 'package:orders_app/models/item.dart';

class ItemPage extends StatefulWidget {
  final Item item;

  const ItemPage({ Key? key, required this.item }) : super(key: key);

  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.name),
      ),
      body: Column(
        children: <Widget>[
          Text(widget.item.description),
        ],
      ),
    );
  }
}
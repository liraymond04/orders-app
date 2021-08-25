import 'package:flutter/material.dart';
import 'package:orders_app/models/item.dart';
import 'package:orders_app/models/cart.dart';
// import 'package:orders_app/screens/item.dart';
// import 'package:orders_app/utils/constants.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) {
          //     return ItemPage(item: widget.item);
          //   }),
          // );
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              CachedNetworkImage(
                imageUrl: widget.item.image,
                imageBuilder: (context, imageProvider) => ClipOval(
                  child: Container(
                    width: 65.0,
                    height: 43.0,
                    child: Center(
                      child: Image(
                        image: imageProvider
                      ),
                    ),
                  ),
                ),
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                children: [
                  Text(
                    widget.item.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '\$${widget.item.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 10,
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
              Spacer(),
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
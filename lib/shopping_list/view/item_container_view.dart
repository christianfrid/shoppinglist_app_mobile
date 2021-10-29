import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:shoppinglist_app_mobile/shopping_list/bloc/shopping_list_bloc.dart';
import 'package:shoppinglist_app_mobile/shopping_list/bloc/shopping_list_event.dart';
import 'package:shoppinglist_app_mobile/shopping_list/models/item.dart';
import 'package:shoppinglist_app_mobile/shopping_list/models/item_status.dart';

class ItemContainerView extends StatefulWidget {
  ItemContainerView(
      {Key? key,
      required this.id,
      required this.desc,
      required this.order,
      required this.status})
      : super(key: key);
  final String id;
  final String desc;
  final String order;
  final ItemStatus status;

  @override
  _ItemContainerViewState createState() => _ItemContainerViewState();
}

class _ItemContainerViewState extends State<ItemContainerView> {
  final double _opacity = 0.6;
  late ShoppingListBloc _shoppingListBloc;

  @override
  void initState() {
    super.initState();
    _shoppingListBloc = context.read<ShoppingListBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  widget.status == ItemStatus.ADDED_TO_CART
                      ? Colors.green.withOpacity(_opacity)
                      : Colors.tealAccent.withOpacity(_opacity),
                  Colors.white.withOpacity(_opacity),
                ],
              ),
            ),
            child: ListTile(
              title: Text(
                utf8.decode(widget.desc.codeUnits),
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              trailing: IconButton(
                icon: _getStatusIcon(widget.status),
                onPressed: () {
                  setState(() {
                    Item item = Item(
                        widget.id,
                        utf8.decode(widget.desc.codeUnits),
                        widget.order,
                        widget.status);
                    _shoppingListBloc.add(AddToCartEvent(item));
                  });
                },
              ),
            )));
  }

  Icon _getStatusIcon(ItemStatus flightStatus) {
    switch (flightStatus) {
      case ItemStatus.ADDED_TO_SHOPPING_LIST:
        return Icon(Icons.add_shopping_cart, color: Colors.white);
      case ItemStatus.ADDED_TO_CART:
        return Icon(Icons.check_circle, color: Colors.lightGreen);
      default:
        return Icon(Icons.error, color: Colors.red[800]);
    }
  }
}

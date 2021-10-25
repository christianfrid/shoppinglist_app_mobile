import 'dart:convert';
import 'dart:convert' show utf8;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppinglist_app_mobile/shopping_list/bloc/shopping_list_bloc.dart';
import 'package:shoppinglist_app_mobile/shopping_list/bloc/shopping_list_event.dart';
import 'package:shoppinglist_app_mobile/shopping_list/bloc/shopping_list_state.dart';
import 'package:shoppinglist_app_mobile/shopping_list/models/item.dart';
import 'package:shoppinglist_app_mobile/shopping_list/models/item_status.dart';
import 'package:shoppinglist_app_mobile/shopping_list/view/add_item_dialog_box.dart';
import 'package:shoppinglist_app_mobile/shopping_list/view/bg_animation/background.dart';

class ShoppingListView extends StatefulWidget {
  final AnimationController controller;

  const ShoppingListView({required Key key, required this.controller})
      : super(key: key);

  @override
  _ShoppingListViewState createState() => _ShoppingListViewState();
}

class _ShoppingListViewState extends State<ShoppingListView> {
  Color gradientStart = Colors.transparent;
  late ShoppingListBloc _shoppingListBloc;

  @override
  void initState() {
    super.initState();
    _shoppingListBloc = context.read<ShoppingListBloc>()
      ..add(GetShoppingListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var result = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AddItemDialogBox();
              });
          _shoppingListBloc.add(AddNewItemEvent(result));
        },
        child: const Icon(Icons.add, size: 30,),
        backgroundColor: Colors.teal,
      ),
      body: Stack(
        children: <Widget>[
          ShaderMask(
            shaderCallback: (rect) {
              return LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  gradientStart,
                  getBackground().evaluate(
                      AlwaysStoppedAnimation(widget.controller.value))!
                ],
              ).createShader(rect);
            },
            blendMode: BlendMode.srcATop,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image:
                      ExactAssetImage('assets/images/github_globe_edit1.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          ListView(
            children: [
              Padding(
                padding:
                    EdgeInsets.only(left: 30, right: 40, top: 40, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Inköpslista",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 40),
                    ),
                  ],
                ),
              ),
              BlocBuilder<ShoppingListBloc, ShoppingState>(
                builder: (BuildContext context, ShoppingState state) {
                  switch (state.status) {
                    case ShoppingListStatus.failure:
                      return Center(
                        child: Text(
                          'Failed to fetch items',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    case ShoppingListStatus.success:
                      List<ItemContainer> addedToShoppingList = state
                          .addedToShoppingList
                          .map((item) => ItemContainer(
                              id: item.id,
                              desc: item.desc,
                              order: item.order,
                              status: item.status))
                          .toList();
                      List<ItemContainer> addedToCart = state.addedToCart
                          .map((item) => ItemContainer(
                              id: item.id,
                              desc: item.desc,
                              order: item.order,
                              status: item.status))
                          .toList();

                      if (addedToShoppingList.isNotEmpty &&
                          addedToCart.isEmpty) {
                        return ListView(
                          shrinkWrap: true,
                          children: List<Widget>.of(addedToShoppingList)
                            ..add(_buildDeleteButton()),
                        );
                      }
                      if (addedToCart.isNotEmpty) {
                        return ListView(
                          shrinkWrap: true,
                          children: List<Widget>.of(addedToShoppingList)
                            ..add(_buildRuler())
                            ..addAll(addedToCart)
                            ..add(_buildDeleteButton()),
                        );
                      }
                      return Center();
                    default:
                      return Center();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteButton() {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Center(
        child: IconButton(
          iconSize: 35.0,
          icon: Icon(Icons.delete_rounded, color: Colors.white),
          onPressed: () {
            setState(() {
              _shoppingListBloc.add(DeleteShoppingListEvent());
            });
          },
        ),
      ),
    );
  }

  Widget _buildRuler() {
    return Padding(
      padding: EdgeInsets.only(left: 30, bottom: 10, top: 10),
      child: Row(children: [
        Text(
          "Tillagt i kundvagnen",
          style: TextStyle(color: Colors.white),
        ),
        Expanded(child: Divider())
      ]),
    );
  }
}

class ItemContainer extends StatefulWidget {
  ItemContainer(
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
  _ItemContainerState createState() => _ItemContainerState();
}

class _ItemContainerState extends State<ItemContainer> {
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

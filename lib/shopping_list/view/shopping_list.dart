import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppinglist_app_mobile/shopping_list/bloc/shopping_list_bloc.dart';
import 'package:shoppinglist_app_mobile/shopping_list/bloc/shopping_list_event.dart';
import 'package:shoppinglist_app_mobile/shopping_list/bloc/shopping_list_state.dart';
import 'package:shoppinglist_app_mobile/shopping_list/models/ItemStatus.dart';
import 'package:shoppinglist_app_mobile/shopping_list/models/item.dart';
import 'package:shoppinglist_app_mobile/shopping_list/view/add_item_dialog_box.dart';
import 'package:shoppinglist_app_mobile/shopping_list/view/bg_animation/background.dart';

class ShoppingList extends StatefulWidget {
  final AnimationController controller;

  const ShoppingList({required Key key, required this.controller})
      : super(key: key);

  @override
  _ShoppingListState createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
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
    return Stack(
      children: <Widget>[
        ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                gradientStart,
                getBackground()
                    .evaluate(AlwaysStoppedAnimation(widget.controller.value))!
              ],
            ).createShader(rect);
          },
          blendMode: BlendMode.srcATop,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: ExactAssetImage('assets/images/github_globe_edit1.jpg'),
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
                  IconButton(
                    icon: Icon(
                      Icons.add_outlined,
                      color: Colors.white,
                      size: 45,
                    ),
                    onPressed: () async {
                      var result = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AddItemDialogBox();
                          });
                      _shoppingListBloc.add(AddNewItemEvent(result));
                    },
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
                            itemDesc: item.itemDesc,
                            itemStatus: item.itemStatus))
                        .toList();
                    List<ItemContainer> addedToCart = state.addedToCart
                        .map((item) => ItemContainer(
                            itemDesc: item.itemDesc,
                            itemStatus: item.itemStatus))
                        .toList();
                    Widget ruler = Padding(
                      padding: EdgeInsets.only(left: 30, bottom: 10, top: 10),
                      child: Row(children: [
                        Text(
                          "Tillagt i kundvagnen",
                          style: TextStyle(color: Colors.white),
                        ),
                        Expanded(child: Divider())
                      ]),
                    );

                    if (addedToShoppingList.isEmpty && addedToCart.isEmpty) {
                      return Center(
                          child: Text(
                        "Listan är tom.",
                        style: TextStyle(color: Colors.white),
                      ));
                    }
                    if (addedToShoppingList.isNotEmpty && addedToCart.isEmpty) {
                      return ListView(
                        shrinkWrap: true,
                        children: List<Widget>.of(addedToShoppingList)
                          ..add(Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Center(
                              child: IconButton(
                                iconSize: 35.0,
                                icon: Icon(Icons.delete, color: Colors.white),
                                onPressed: () {
                                  setState(() {
                                    _shoppingListBloc
                                        .add(DeleteShoppingListEvent());
                                  });
                                },
                              ),
                            ),
                          )),
                      );
                    }
                    return ListView(
                      shrinkWrap: true,
                      children: List<Widget>.of(addedToShoppingList)
                        ..add(ruler)
                        ..addAll(addedToCart)
                        ..add(Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Center(
                            child: IconButton(
                              iconSize: 35.0,
                              icon: Icon(Icons.delete, color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  _shoppingListBloc
                                      .add(DeleteShoppingListEvent());
                                });
                              },
                            ),
                          ),
                        )),
                    );
                  default:
                    return Center(
                        child: Text(
                      "Listan är tom.",
                      style: TextStyle(color: Colors.white),
                    ));
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}

class ItemContainer extends StatefulWidget {
  ItemContainer({Key? key, required this.itemDesc, required this.itemStatus})
      : super(key: key);
  final String itemDesc;
  final ItemStatus itemStatus;

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
                  widget.itemStatus == ItemStatus.ADDED_TO_CART
                      ? Colors.green.withOpacity(_opacity)
                      : Colors.tealAccent.withOpacity(_opacity),
                  Colors.white.withOpacity(_opacity),
                ],
              ),
            ),
            child: ListTile(
              title: Text(
                widget.itemDesc,
                style: TextStyle(color: Colors.white),
              ),
              trailing: IconButton(
                icon: _getStatusIcon(widget.itemStatus),
                onPressed: () {
                  setState(() {
                    Item item = Item(widget.itemDesc, widget.itemStatus);
                    _shoppingListBloc.add(AddToCartEvent(item));
                  });
                },
              ),
            )));
  }

  Icon _getStatusIcon(ItemStatus flightStatus) {
    switch (flightStatus) {
      case ItemStatus.IN_SHOPPING_LIST:
        return Icon(Icons.add_shopping_cart, color: Colors.white);
      case ItemStatus.ADDED_TO_CART:
        return Icon(Icons.check_circle, color: Colors.lightGreen);
      default:
        return Icon(Icons.error, color: Colors.red[800]);
    }
  }
}

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
import 'package:uuid/uuid.dart';

class ShoppingListView extends StatefulWidget {
  const ShoppingListView({required Key key}) : super(key: key);

  @override
  _ShoppingListViewState createState() => _ShoppingListViewState();
}

class _ShoppingListViewState extends State<ShoppingListView> {
  Color gradientStart = Colors.transparent;
  late ShoppingListBloc _shoppingListBloc;
  late List<Dismissible> _addedToShoppingList;
  late List<Dismissible> _addedToCart;

  @override
  void initState() {
    super.initState();
    _shoppingListBloc = context.read<ShoppingListBloc>()
      ..add(GetShoppingListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingListBloc, ShoppingState>(
        builder: (BuildContext context, ShoppingState state) {
      switch (state.status) {
        case ShoppingListStatus.failure:
          return Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: Text(
                  'Failed to fetch items',
                  style: TextStyle(color: Colors.white),
                ),
              ));
        case ShoppingListStatus.success:
          _addedToShoppingList = state.addedToShoppingList
              .map((item) => _setDismissable(ItemContainer(
                  id: item.id,
                  desc: item.desc,
                  order: item.order,
                  status: item.status)))
              .toList();
          _addedToCart = state.addedToCart
              .map((item) => _setDismissable(ItemContainer(
                  id: item.id,
                  desc: item.desc,
                  order: item.order,
                  status: item.status)))
              .toList();
          return Scaffold(
              backgroundColor: Colors.transparent,
              floatingActionButton: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children:
                      _buildActionButtons(_addedToShoppingList, _addedToCart)),
              body: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate(
                      _buildShoppingList(_addedToShoppingList, _addedToCart),
                    ),
                  ),
                ],
              ));

        default:
          return Scaffold(
              backgroundColor: Colors.transparent,
              body: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      _buildHeader(),
                    ]),
                  ),
                ],
              ));
      }
    });
  }

  List<Widget> _buildShoppingList(
      List<Widget> addedToShoppingList, List<Widget> addedToCart) {
    // Only add ruler when something is added to cart
    if (addedToShoppingList.isEmpty && addedToCart.isNotEmpty) {
      return [
        _buildHeader(),
        Column(
          children: addedToCart,
        )
      ];
    }
    if (addedToCart.isNotEmpty) {
      return [
        _buildHeader(),
        Column(
          children: addedToShoppingList,
        ),
        _buildRuler(),
        Column(
          children: addedToCart,
        )
      ];
    }
    return [
      _buildHeader(),
      Column(
        children: addedToShoppingList,
      ),
    ];
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.only(left: 30, right: 40, top: 60, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Inköpslista",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 40),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildActionButtons(List addedToShoppingList, List addedToCart) {
    // AddButton is always needed
    FloatingActionButton addItemButton = FloatingActionButton(
      heroTag: Uuid().v4().toString(),
      onPressed: () async {
        var result = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddItemDialogBox();
            });
        _shoppingListBloc.add(AddNewItemEvent(result));
      },
      child: const Icon(
        Icons.add,
        size: 30,
      ),
      backgroundColor: Colors.teal,
    );
    FloatingActionButton syncButton = FloatingActionButton(
      heroTag: Uuid().v4().toString(),
      onPressed: () async {
        _shoppingListBloc.add(GetShoppingListEvent());
      },
      child: const Icon(
        Icons.sync,
        size: 30,
      ),
      backgroundColor: Colors.teal,
    );

    // Add DeleteButton only if needed
    if (addedToShoppingList.isNotEmpty || addedToCart.isNotEmpty) {
      return [
        Padding(
          padding: EdgeInsets.only(bottom: 15),
          child: syncButton,
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 15),
          child: FloatingActionButton(
            heroTag: Uuid().v4().toString(),
            onPressed: () async {
              _shoppingListBloc.add(DeleteShoppingListEvent());
            },
            child: const Icon(
              Icons.delete_rounded,
              size: 30,
            ),
            backgroundColor: Colors.teal,
          ),
        ),
        addItemButton
      ];
    }
    return [
      Padding(
        padding: EdgeInsets.only(bottom: 15),
        child: syncButton,
      ),
      addItemButton
    ];
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

  Dismissible _setDismissable(ItemContainer itemContainer) {
    return Dismissible(
      key: Key("${itemContainer.id}"),
      background: Container(
        color: Colors.transparent,
      ),
      onDismissed: (DismissDirection direction) {
        _shoppingListBloc.add(DeleteOneItemEvent(itemContainer.id));
      },
      child: itemContainer,
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

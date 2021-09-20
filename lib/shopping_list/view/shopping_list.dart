import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppinglist_app_mobile/shopping_list/bloc/shopping_list_bloc.dart';
import 'package:shoppinglist_app_mobile/shopping_list/bloc/shopping_list_event.dart';
import 'package:shoppinglist_app_mobile/shopping_list/bloc/shopping_list_state.dart';
import 'package:shoppinglist_app_mobile/shopping_list/models/ItemStatus.dart';
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

  @override
  void initState() {
    super.initState();
    context.read<ShoppingListBloc>()..add(GetShoppingListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingListBloc, ShoppingState>(
      builder: (context, state) {
        switch (state.status) {
          case ShoppingListStatus.failure:
            return const Center(child: Text('failed to fetch items'));
          case ShoppingListStatus.success:
            List<ItemContainer> addedToShoppingList = state.items
                .where((item) => item.itemStatus == ItemStatus.IN_SHOPPING_LIST)
                .map((item) => ItemContainer(
                    itemDesc: item.itemDesc, itemStatus: item.itemStatus))
                .toList();

            List<ItemContainer> addedToCart = state.items
                .where((item) => item.itemStatus == ItemStatus.ADDED_TO_CART)
                .map((item) => ItemContainer(
                    itemDesc: item.itemDesc, itemStatus: item.itemStatus))
                .toList();

            var itemWidgetList = <Widget>[];
            itemWidgetList.add(
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
                        context.read<ShoppingListBloc>()
                          ..add(AddNewItemEvent(result));
                      },
                    ),
                  ],
                ),
              ),
            );
            itemWidgetList.addAll(addedToShoppingList);
            itemWidgetList.add(
              Padding(
                padding: EdgeInsets.only(left: 30, top: 30),
                child: Row(children: [
                  Text(
                    "Tillagt i kundvagnen",
                    style: TextStyle(color: Colors.white),
                  ),
                  Expanded(child: Divider())
                ]),
              ),
            );
            itemWidgetList.addAll(addedToCart);
            itemWidgetList.add(Padding(
              padding: EdgeInsets.only(top: 50, bottom: 30),
              child: Center(
                child: Text(
                  "Copyrajtat av Chres Inc.",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ));

            return Stack(
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
                        image: ExactAssetImage(
                            'assets/images/github_globe_edit1.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                ListView(
                  children: itemWidgetList,
                ),
              ],
            );
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
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

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 3),
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
              trailing: _getStatusIcon(widget.itemStatus)),
        ));
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppinglist_app_mobile/shopping_list/bloc/shopping_list_bloc.dart';
import 'package:shoppinglist_app_mobile/shopping_list/bloc/shopping_list_event.dart';
import 'package:shoppinglist_app_mobile/shopping_list/bloc/shopping_list_state.dart';
import 'package:shoppinglist_app_mobile/shopping_list/models/item.dart';
import 'package:shoppinglist_app_mobile/shopping_list/models/item_status.dart';
import 'package:shoppinglist_app_mobile/shopping_list/view/add_item_dialog_box.dart';
import 'package:shoppinglist_app_mobile/shopping_list/view/item_container_view.dart';
import 'package:uuid/uuid.dart';

class ShoppingListView extends StatefulWidget {
  const ShoppingListView({required Key key}) : super(key: key);

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
          return Scaffold(
              backgroundColor: Colors.transparent,
              floatingActionButton: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: _buildActionButtons(state.allItems)),
              body: CustomScrollView(
                slivers: [
                  _buildHeader(),
                  SliverList(
                    delegate: SliverChildListDelegate(
                        List.generate(state.allItems.length, (index) {
                      String itemId = state.allItems[index].id;
                      return Dismissible(
                        key: Key("$itemId-$index"),
                        background: Container(
                          color: Colors.transparent,
                        ),
                        onDismissed: (DismissDirection direction) {
                          var currentId = state.allItems[index].id;
                          state.allItems.remove(state.allItems[index]);
                          _shoppingListBloc.add(DeleteOneItemEvent(currentId));
                        },
                        child: ItemContainerView(
                            id: state.allItems[index].id,
                            desc: state.allItems[index].desc,
                            order: state.allItems[index].order,
                            status: state.allItems[index].status),
                      );
                    })),
                  ),
                ],
              ));

        default:
          return Scaffold(
              backgroundColor: Colors.transparent,
              body: CustomScrollView(
                slivers: [
                  _buildHeader(),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Center(
                        child: CircularProgressIndicator(),
                      )
                    ]),
                  ),
                ],
              ));
      }
    });
  }

  Widget _buildHeader() {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      title: Text(
        "Inköpslista",
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.white, fontSize: 40),
      ),
      floating: true,
    );
  }

  List<Widget> _buildActionButtons(List<Item> allTimes) {
    // AddButton
    FloatingActionButton addItemButton = FloatingActionButton(
      heroTag: Uuid().v4().toString(),
      onPressed: () async {
        var result = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddItemDialogBox();
            });
        if (result != "") {
          _shoppingListBloc.add(AddNewItemEvent(result));
        }
      },
      child: const Icon(
        Icons.add,
        size: 30,
      ),
      backgroundColor: Colors.teal,
    );
    // SyncButton
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

    // DeleteButton if items exits
    if (allTimes
            .where((element) =>
                element.status == ItemStatus.ADDED_TO_SHOPPING_LIST)
            .isNotEmpty ||
        allTimes
            .where((element) => element.status == ItemStatus.ADDED_TO_CART)
            .isNotEmpty) {
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
}

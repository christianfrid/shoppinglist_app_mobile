import 'dart:async';
import 'package:shoppinglist_app_mobile/shopping_list/models/ItemStatus.dart';
import 'package:shoppinglist_app_mobile/shopping_list/models/item.dart';

const _delay = Duration(milliseconds: 800);

class ShoppingRepository {
  final _items = <Item>[];

  //Future<List<String>> loadCatalog() => Future.delayed(_delay, () => _catalog);

  Future<List<Item>> loadShoppingListItems() => Future.delayed(_delay, () => _items);

  void addItemToShoppingList(String itemName) => _items.add(Item(itemName, ItemStatus.IN_SHOPPING_LIST));

  void addItemToCart(Item item) {
    int updateIndex = _items.indexOf(item);
    _items.elementAt(updateIndex).itemStatus = ItemStatus.ADDED_TO_CART;
  }

  void printItems() => print("Items are currently: " + _items.toString());
}

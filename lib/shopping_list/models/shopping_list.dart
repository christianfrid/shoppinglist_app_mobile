import 'package:shoppinglist_app_mobile/shopping_list/models/item.dart';

class ShoppingList {
  final List<Item> addedToShoppingList;
  final List<Item> addedToCart;
  ShoppingList(this.addedToShoppingList, this.addedToCart);

  @override
  String toString() {
    return "added_to_shopping_list: " +
        addedToShoppingList.toString() +
        "\nadded_to_cart: " +
        addedToCart.toString();
  }

  factory ShoppingList.fromJson(Map<String, dynamic> jsonMap) {
    List<Item> addedToShoppingList = (jsonMap['added_to_shopping_list'] as List)
        .map((item) => Item.fromJson(item))
        .toList();
    List<Item> addedToCart = (jsonMap['added_to_cart'] as List)
        .map((item) => Item.fromJson(item))
        .toList();
    return ShoppingList(addedToShoppingList, addedToCart);
  }
}

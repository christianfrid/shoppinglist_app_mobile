import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shoppinglist_app_mobile/shopping_list/models/item.dart';

abstract class BackendInterface {
  /// Throws [NetworkException]
  Future<List<Item>> fetchShoppingListItems();
  Future<List<Item>> addItemToShoppingList(String itemName);
  Future<List<Item>> addItemToCart(Item item);
}

class ShoppingRepository implements BackendInterface {

  List<Item> _convertItemsResponse(String json){
    print((jsonDecode(json) as List));
    return (jsonDecode(json) as List).map((i) => Item.fromJson(i)).toList();
  }

  @override
  Future<List<Item>> addItemToCart(Item item) async {
    return Future.delayed(
      const Duration(milliseconds: 200),
          () => List.empty(),
    );
  }

  @override
  Future<List<Item>> addItemToShoppingList(String itemName) async {
    return Future.delayed(
      const Duration(milliseconds: 200),
          () => List.empty(),
    );
  }

  @override
  Future<List<Item>> fetchShoppingListItems() async {
    print('Fetching current shopping list...');
    final response = await http.get(
        Uri.parse('https://existenz.ew.r.appspot.com/v1/shoppinglist/items')
    );
    if (response.statusCode == 200) {
      return _convertItemsResponse(response.body);
    }
    log("Response != 200. Returning empty list.");
    return List.empty();
  }

}


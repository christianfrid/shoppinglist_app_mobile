import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:http/http.dart' as http;
import 'package:shoppinglist_app_mobile/shopping_list/models/ItemStatus.dart';
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
    log("Trying to set \"" + item.itemDesc + "\" to ADDED_TO_CART...");
    final response = await http.put(
      Uri.parse('https://existenz.ew.r.appspot.com/v1/shoppinglist/item/update'),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
      },
      body: jsonEncode(<String, String>{
        "item_desc": item.itemDesc,
        "item_status": EnumToString.convertToString(ItemStatus.IN_SHOPPING_LIST)
      }),
    );
    if (response.statusCode == 200) {
      return _convertItemsResponse(response.body);
    }
    log("Response != 200. Returning empty list.");
    return List.empty();
  }

  @override
  Future<List<Item>> addItemToShoppingList(String itemDesc) async {
    log("Trying to add \"" + itemDesc + "\" to shopping list...");
    final response = await http.post(
      Uri.parse('https://existenz.ew.r.appspot.com/v1/shoppinglist/item/add'),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
      },
      body: jsonEncode(<String, String>{
        "item_desc": itemDesc,
        "item_status": EnumToString.convertToString(ItemStatus.IN_SHOPPING_LIST)
      }),
    );
    if (response.statusCode == 200) {
      return _convertItemsResponse(response.body);
    }
    log("Response != 200. Returning empty list.");
    return List.empty();
  }

  @override
  Future<List<Item>> fetchShoppingListItems() async {
    log('Fetching current shopping list...');
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


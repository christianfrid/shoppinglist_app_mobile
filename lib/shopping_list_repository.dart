import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:http/http.dart' as http;
import 'package:shoppinglist_app_mobile/shopping_list/models/item_status.dart';
import 'package:shoppinglist_app_mobile/shopping_list/models/item.dart';
import 'package:shoppinglist_app_mobile/shopping_list/models/shopping_list.dart';

abstract class BackendInterface {
  /// Throws [NetworkException]
  ///
  Future<int> wake();
  Future<ShoppingList> fetchShoppingListItems();
  Future<int> addItemToShoppingList(String desc);
  Future<int> addItemToCart(Item item);
  Future<int> clearShoppingList();
}

class ShoppingRepository implements BackendInterface {
  @override
  Future<int> addItemToCart(Item item) async {
    log("Trying to set \"" +
        item.desc +
        "\" to " +
        EnumToString.convertToString(ItemStatus.ADDED_TO_SHOPPING_LIST) +
        "...");
    final response = await http.put(Uri.parse(
        'https://existenz.ew.r.appspot.com/v1/shoppinglist/item/cart?itemId=${item.id}'));
    return response.statusCode;
  }

  @override
  Future<int> addItemToShoppingList(String desc) async {
    log("Trying to add \"" + desc + "\" to shopping list...");
    final response = await http.post(
      Uri.parse('https://existenz.ew.r.appspot.com/v1/shoppinglist/item/add'),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
      },
      body: jsonEncode(<String, String>{"item_desc": desc}),
    );
    return response.statusCode;
  }

  @override
  Future<ShoppingList> fetchShoppingListItems() async {
    log('Fetching current shopping list...');
    final response = await http
        .get(Uri.parse('https://existenz.ew.r.appspot.com/v1/shoppinglist'));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonMap = jsonDecode(response.body);
      return ShoppingList.fromJson(jsonMap);
    }
    log("Response != 200. Returning empty list.");
    return ShoppingList(List.empty(), List.empty());
  }

  @override
  Future<int> clearShoppingList() async {
    log('Deleting shopping list...');
    final response = await http.delete(
        Uri.parse('https://existenz.ew.r.appspot.com/v1/shoppinglist/clear'));
    return response.statusCode;
  }

  @override
  Future<int> wake() async {
    log('Waking backend...');
    final response = await http.get(
        Uri.parse('https://existenz.ew.r.appspot.com/v1/wake'));
    return response.statusCode;
  }
}
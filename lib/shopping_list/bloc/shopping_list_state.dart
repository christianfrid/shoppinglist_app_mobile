import 'package:equatable/equatable.dart';
import 'package:shoppinglist_app_mobile/shopping_list/models/item.dart';

enum ShoppingListStatus { initial, success, failure }

class ShoppingState extends Equatable {
  final ShoppingListStatus status;
  final List<Item> addedToShoppingList;
  final List<Item> addedToCart;

  ShoppingState({
    this.status = ShoppingListStatus.initial,
    this.addedToShoppingList = const <Item>[],
    this.addedToCart = const <Item>[],
  });

  ShoppingState copyWith({
    ShoppingListStatus? status,
    List<Item>? addedToShoppingList,
    List<Item>? addedToCart,
  }) {
    return ShoppingState(
        status: status ?? this.status,
        addedToShoppingList: addedToShoppingList ?? this.addedToShoppingList,
        addedToCart: addedToCart ?? this.addedToCart);
  }

  @override
  List<Object> get props => [status, addedToShoppingList, addedToCart];
}

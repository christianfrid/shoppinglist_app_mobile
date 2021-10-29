import 'package:equatable/equatable.dart';
import 'package:shoppinglist_app_mobile/shopping_list/models/item.dart';

enum ShoppingListStatus { initial, success, failure }

class ShoppingState extends Equatable {
  final ShoppingListStatus status;
  final List<Item> allItems;

  ShoppingState({
    this.status = ShoppingListStatus.initial,
    this.allItems = const <Item>[],
  });

  ShoppingState copyWith({
    ShoppingListStatus? status,
    List<Item>? allItems,
  }) {
    return ShoppingState(
        status: status ?? this.status,
        allItems: allItems ?? this.allItems);
  }

  @override
  List<Object> get props => [status, allItems];
}

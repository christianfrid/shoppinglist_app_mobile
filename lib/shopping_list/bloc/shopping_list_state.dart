import 'package:equatable/equatable.dart';
import 'package:shoppinglist_app_mobile/shopping_list/models/item.dart';

enum ShoppingListStatus { initial, success, failure }

class ShoppingState extends Equatable {
  const ShoppingState({
    this.status = ShoppingListStatus.initial,
    this.items = const <Item>[],
  });

  final ShoppingListStatus status;
  final List<Item> items;

  ShoppingState copyWith({
    ShoppingListStatus? status,
    List<Item>? items,
  }) {
    return ShoppingState(
      status: status ?? this.status,
      items: items ?? this.items
    );
  }

  @override
  List<Object> get props => [status, items];
}
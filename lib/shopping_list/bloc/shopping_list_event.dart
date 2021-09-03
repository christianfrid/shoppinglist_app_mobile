import 'package:equatable/equatable.dart';
import 'package:shoppinglist_app_mobile/shopping_list/models/item.dart';

class ShoppingListEvent extends Equatable {
  @override
  List<Object> get props => [];
}
class GetShoppingListEvent extends ShoppingListEvent {}
class AddNewItemEvent extends ShoppingListEvent {
  final String itemName;
  AddNewItemEvent(this.itemName);
}
class AddToCartEvent extends ShoppingListEvent {
  final Item item;
  AddToCartEvent(this.item);
}
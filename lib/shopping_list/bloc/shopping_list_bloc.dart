import 'package:bloc/bloc.dart';
import 'package:shoppinglist_app_mobile/shopping_list/bloc/shopping_list_event.dart';
import 'package:shoppinglist_app_mobile/shopping_list/bloc/shopping_list_state.dart';
import 'package:shoppinglist_app_mobile/shopping_list/models/ItemStatus.dart';
import 'package:shoppinglist_app_mobile/shopping_list/models/item.dart';
import 'package:shoppinglist_app_mobile/shopping_list_repository.dart';
import 'package:rxdart/rxdart.dart';

class ShoppingListBloc extends Bloc<ShoppingListEvent, ShoppingState> {
  ShoppingListBloc({required this.shoppingRepository}) : super(ShoppingState());
  final ShoppingRepository shoppingRepository;

  @override
  Stream<Transition<ShoppingListEvent, ShoppingState>> transformEvents(
    Stream<ShoppingListEvent> events,
    TransitionFunction<ShoppingListEvent, ShoppingState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 200)),
      transitionFn,
    );
  }

  @override
  Stream<ShoppingState> mapEventToState(ShoppingListEvent event) async* {
    if (event is GetShoppingListEvent) {
      yield await _mapGetShoppingListToState();
    } else if (event is AddNewItemEvent) {
      yield await _mapAddNewItemToState(event);
    } else if (event is AddToCartEvent) {
      yield await _mapAddToCartToState(event);
    }
  }

  Future<ShoppingState> _mapGetShoppingListToState() async {
    try {
      final items = await shoppingRepository.fetchShoppingListItems();
      List<Item> addedToShoppingList = items
          .where((item) => item.itemStatus == ItemStatus.IN_SHOPPING_LIST)
          .toList();
      List<Item> addedToCart = items
          .where((item) => item.itemStatus == ItemStatus.ADDED_TO_CART)
          .toList();
      return state.copyWith(
          status: ShoppingListStatus.success,
          addedToShoppingList: addedToShoppingList,
          addedToCart: addedToCart);
    } on Exception {
      return state.copyWith(status: ShoppingListStatus.failure);
    }
  }

  Future<ShoppingState> _mapAddNewItemToState(AddNewItemEvent event) async {
    try {
      await shoppingRepository.addItemToShoppingList(event.itemName);
      final items = await shoppingRepository.fetchShoppingListItems();
      List<Item> addedToShoppingList = items
          .where((item) => item.itemStatus == ItemStatus.IN_SHOPPING_LIST)
          .toList();
      List<Item> addedToCart = items
          .where((item) => item.itemStatus == ItemStatus.ADDED_TO_CART)
          .toList();
      return state.copyWith(
          status: ShoppingListStatus.success,
          addedToShoppingList: addedToShoppingList,
          addedToCart: addedToCart);
    } on Exception {
      return state.copyWith(status: ShoppingListStatus.failure);
    }
  }

  Future<ShoppingState> _mapAddToCartToState(AddToCartEvent event) async {
    try {
      await shoppingRepository.addItemToCart(event.item);
      final items = await shoppingRepository.fetchShoppingListItems();
      List<Item> addedToShoppingList = items
          .where((item) => item.itemStatus == ItemStatus.IN_SHOPPING_LIST)
          .toList();
      List<Item> addedToCart = items
          .where((item) => item.itemStatus == ItemStatus.ADDED_TO_CART)
          .toList();
      return state.copyWith(
          status: ShoppingListStatus.success,
          addedToShoppingList: addedToShoppingList,
          addedToCart: addedToCart);
    } on Exception {
      return state.copyWith(status: ShoppingListStatus.failure);
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shoppinglist_app_mobile/shopping_list/bloc/shopping_list_event.dart';
import 'package:shoppinglist_app_mobile/shopping_list/bloc/shopping_list_state.dart';
import 'package:shoppinglist_app_mobile/shopping_list/models/shopping_list.dart';
import 'package:shoppinglist_app_mobile/shopping_list_repository.dart';

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
    } else if (event is DeleteOneItemEvent) {
      yield await _mapDeleteOneItemEventToState(event);
    } else if (event is DeleteShoppingListEvent) {
      yield await _mapDeleteShoppingListToState();
    }
  }

  Future<ShoppingState> _mapGetShoppingListToState() async {
    try {
      final ShoppingList items =
          await shoppingRepository.fetchShoppingListItems();
      return state.copyWith(
          status: ShoppingListStatus.success,
          allItems: []
            ..addAll(items.addedToShoppingList)
            ..addAll(items.addedToCart));
    } on Exception {
      return state.copyWith(status: ShoppingListStatus.failure);
    }
  }

  Future<ShoppingState> _mapAddNewItemToState(AddNewItemEvent event) async {
    try {
      await shoppingRepository.addItemToShoppingList(event.itemName);
      final ShoppingList items =
          await shoppingRepository.fetchShoppingListItems();
      return state.copyWith(
          status: ShoppingListStatus.success,
          allItems: []
            ..addAll(items.addedToShoppingList)
            ..addAll(items.addedToCart));
    } on Exception {
      return state.copyWith(status: ShoppingListStatus.failure);
    }
  }

  Future<ShoppingState> _mapAddToCartToState(AddToCartEvent event) async {
    try {
      await shoppingRepository.addItemToCart(event.item);
      final ShoppingList items =
          await shoppingRepository.fetchShoppingListItems();
      return state.copyWith(
          status: ShoppingListStatus.success,
          allItems: []
            ..addAll(items.addedToShoppingList)
            ..addAll(items.addedToCart));
    } on Exception {
      return state.copyWith(status: ShoppingListStatus.failure);
    }
  }

  Future<ShoppingState> _mapDeleteShoppingListToState() async {
    try {
      await shoppingRepository.clearShoppingList();
      final ShoppingList emptyList =
          await shoppingRepository.fetchShoppingListItems();
      return state.copyWith(
          status: ShoppingListStatus.success,
          allItems: []
            ..addAll(emptyList.addedToShoppingList)
            ..addAll(emptyList.addedToCart));
    } on Exception {
      return state.copyWith(status: ShoppingListStatus.failure);
    }
  }

  Future<ShoppingState> _mapDeleteOneItemEventToState(
      DeleteOneItemEvent event) async {
    try {
      await shoppingRepository.deleteOneItem(event.id);
      final ShoppingList items =
          await shoppingRepository.fetchShoppingListItems();
      return state.copyWith(
          status: ShoppingListStatus.success,
          allItems: []
            ..addAll(items.addedToShoppingList)
            ..addAll(items.addedToCart));
    } on Exception {
      return state.copyWith(status: ShoppingListStatus.failure);
    }
  }
}

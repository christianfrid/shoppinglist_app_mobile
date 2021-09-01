import 'package:shoppinglist_app_mobile/shopping_list/models/ItemStatus.dart';

class Item {
  final String itemName;
  ItemStatus itemStatus;
  Item(this.itemName, this.itemStatus);

  @override
  String toString() {
    return itemName + " " + itemStatus.toString();
  }
}
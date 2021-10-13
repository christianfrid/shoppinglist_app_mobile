import 'package:enum_to_string/enum_to_string.dart';
import 'package:shoppinglist_app_mobile/shopping_list/models/ItemStatus.dart';

class Item {
  final String itemDesc;
  ItemStatus itemStatus;
  Item(this.itemDesc, this.itemStatus);

  @override
  String toString() {
    return itemDesc + " " + itemStatus.toString();
  }

  factory Item.fromJson(Map<String, dynamic> jsonMap) {
    return Item(
        jsonMap['item_desc'],
        EnumToString.fromString(ItemStatus.values, jsonMap['item_status'])!
    );
  }
}
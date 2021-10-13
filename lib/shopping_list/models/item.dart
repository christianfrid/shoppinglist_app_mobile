import 'package:enum_to_string/enum_to_string.dart';
import 'package:shoppinglist_app_mobile/shopping_list/models/item_status.dart';

class Item {
  final String id;
  final String desc;
  final String order;
  ItemStatus status;
  Item(this.id, this.desc, this.order, this.status);

  @override
  String toString() {
    return id + " " + desc + " " + order + " " + status.toString();
  }

  factory Item.fromJson(Map<String, dynamic> jsonMap) {
    return Item(jsonMap['id'], jsonMap['desc'], jsonMap['order'],
        EnumToString.fromString(ItemStatus.values, jsonMap['status'])!);
  }
}

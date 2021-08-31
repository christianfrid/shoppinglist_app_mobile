class ItemList {
  List itemList = []..length = 15;

  void printList() {
    print("Shoppinglist is currently: " + itemList.where((element) => element != null).toString());
  }

  // Add item to the list
  void addItemToList(String itemName) {
    itemList.add(itemName);
  }

  // Remove item from list
  void removeItemFromList(String itemName) {
    int removeIndex = itemList.indexOf(itemName);
    itemList.removeAt(removeIndex);
  }
}
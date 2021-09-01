import "dart:math";

class DataMocker {

  final _random = new Random();
  final List<String> items = [
    "Korv",
    "Basilika",
    "Glutenfritt bröd",
    "Lax",
    "Lök",
    "Grädde",
    "Gurka",
    "Smör"
  ];

  String getRandomItem() {
    String itemName = items[_random.nextInt(items.length)];
    return itemName;
  }
}
import "dart:math";

class DataMocker {

  final _random = new Random();
  final List<String> amounts = [
    "7",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6"
  ];
  final List<String> items= [
    "Korv",
    "Basilika",
    "Glutenfritt bröd",
    "Lax",
    "Lök",
    "Grädde",
    "Gurka",
    "Smör"
  ];

  String getRandomAmount() {
    return amounts[_random.nextInt(amounts.length)];
  }

  String getRandomItem() {
    String itemName = items[_random.nextInt(items.length)];
    return itemName;
  }
}
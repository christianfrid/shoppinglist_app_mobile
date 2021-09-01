import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoppinglist_app_mobile/DataMocker.dart';
import 'package:shoppinglist_app_mobile/shopping_list/models/ItemStatus.dart';
import 'package:shoppinglist_app_mobile/shopping_list/view/add_item_dialog_box.dart';
import 'package:shoppinglist_app_mobile/shopping_list_repository.dart';

class ShoppingListPage extends StatefulWidget {
  ShoppingListPage({Key? key, required this.title, required this.shoppingRepository}) : super(key: key);
  final String title;
  final ShoppingRepository shoppingRepository;

  @override
  _ShoppingListPageState createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage>
    with SingleTickerProviderStateMixin {
  DataMocker _mock = DataMocker();
  Color gradientStart = Colors.transparent;

  AnimationController? _controller;
  Animatable<Color?> background = TweenSequence<Color?>(
    [
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
          begin: Colors.purple,
          end: Colors.blue,
        ),
      ),
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
          begin: Colors.blue,
          end: Colors.tealAccent,
        ),
      ),
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
          begin: Colors.tealAccent,
          end: Colors.purple,
        ),
      ),
    ],
  );

  // Mocking these...
  Item? _ticketItemUpcoming1;
  Item? _ticketItemUpcoming2;
  final _spentTickets = <Item>[];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();

    // Setting up mocked data
    _ticketItemUpcoming1 = Item(
        itemName: "Mjölk",
        itemStatus: ItemStatus.IN_SHOPPING_LIST
    );
    _ticketItemUpcoming2 = Item(
        itemName: "Bröd",
        itemStatus: ItemStatus.IN_SHOPPING_LIST
    );

    for (int i = 0; i < 10; i++) {
      _spentTickets.add(Item(
          itemName: _mock.getRandomItem(),
          itemStatus: ItemStatus.ADDED_TO_CART
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller!,
        builder: (context, child) {
          return Scaffold(
            body: Stack(
              children: <Widget>[
                ShaderMask(
                  shaderCallback: (rect) {
                    return LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        gradientStart,
                        background.evaluate(AlwaysStoppedAnimation(_controller!.value))!
                      ],
                    ).createShader(rect);
                  },
                  blendMode: BlendMode.srcATop,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: ExactAssetImage(
                            'assets/images/github_globe_edit1.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                ListView(
                  children: [
                    Padding(
                      padding:
                      EdgeInsets.only(left: 30, right: 40, top: 40, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Inköpslista",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 40),
                          ),
                          IconButton(
                            icon: Icon(Icons.add_outlined, color: Colors.white, size: 45,),
                            onPressed: () {
                              showDialog(context: context,
                                  builder: (BuildContext context){
                                    return AddItemDialogBox(
                                      shoppingRepository: widget.shoppingRepository,
                                      title: "Lägg till ny vara",
                                      itemName: "Här kan man skriva typ \"mjölk\" senare.",
                                      text: "Lägg till!", key: ValueKey(context),
                                    );
                                  }
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    _ticketItemUpcoming1!,
                    _ticketItemUpcoming2!,
                    Padding(
                      padding: EdgeInsets.only(left: 30, top: 30),
                      child: Row(children: [
                        Text(
                          "Tillagt i kundvagnen",
                          style: TextStyle(color: Colors.white),
                        ),
                        Expanded(child: Divider())
                      ]),
                    ),
                    _spentTickets[0],
                    _spentTickets[1],
                    _spentTickets[2],
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Inköpshistorik ",
                            style: TextStyle(
                                fontSize: 20, color: Colors.white),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 20,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 50, bottom: 30),
                      child: Center(
                        child: Text(
                          "Copyrajtat av Chres Inc.",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }
}

class Item extends StatefulWidget {
  Item(
      {Key? key, required this.itemName, required this.itemStatus})
      : super(key: key);
  final String itemName;
  final ItemStatus itemStatus;

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.tealAccent,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                widget.itemStatus == ItemStatus.ADDED_TO_CART
                    ? Colors.green
                    : Colors.lightBlueAccent,
                Colors.white,
              ],
            ),
          ),
          child: ListTile(
              title: Text(widget.itemName),
              trailing: _getStatusIcon(widget.itemStatus)),
        ));
  }

  Icon _getStatusIcon(ItemStatus flightStatus) {
    switch (flightStatus) {
      case ItemStatus.IN_SHOPPING_LIST:
        return Icon(Icons.add_shopping_cart, color: Colors.white);
      case ItemStatus.ADDED_TO_CART:
        return Icon(Icons.check_circle, color: Colors.green[800]);
      default:
        return Icon(Icons.error, color: Colors.red[800]);
    }
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoppinglist_app_mobile/shopping_list/view/shopping_list_view.dart';

class ListPageBase extends StatefulWidget {
  ListPageBase({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _ListPageBaseState createState() => _ListPageBaseState();
}

class _ListPageBaseState extends State<ListPageBase>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Scaffold(
            body: ShoppingListView(
              controller: _controller,
              key: ValueKey("ListPage"),
            ),
          );
        });
  }
}

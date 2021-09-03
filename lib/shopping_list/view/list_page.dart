import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppinglist_app_mobile/shopping_list/bloc/shopping_list_bloc.dart';
import 'package:shoppinglist_app_mobile/shopping_list/view/shopping_list.dart';
import 'package:shoppinglist_app_mobile/shopping_list_repository.dart';

class ListPage extends StatefulWidget {
  ListPage({Key? key, required this.title, required this.shoppingRepository}) : super(key: key);
  final String title;
  final ShoppingRepository shoppingRepository;

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage>
    with SingleTickerProviderStateMixin {

  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller!,
        builder: (context, child) {
          return Scaffold(
            body: BlocProvider(
              create: (_) => ShoppingListBloc(shoppingRepository: widget.shoppingRepository),
              child: ShoppingList(controller: _controller, key: ValueKey("ListPage"),),
            ),
          );
        });
  }
}
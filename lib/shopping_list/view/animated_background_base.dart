import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoppinglist_app_mobile/shopping_list/view/bg_animation/background.dart';
import 'package:shoppinglist_app_mobile/shopping_list/view/shopping_list_view.dart';

class AnimatedBackgroundView extends StatefulWidget {
  AnimatedBackgroundView({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _AnimatedBackgroundViewState createState() => _AnimatedBackgroundViewState();
}

class _AnimatedBackgroundViewState extends State<AnimatedBackgroundView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Color gradientStart = Colors.transparent;

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
              body: Stack(children: <Widget>[
            ShaderMask(
              shaderCallback: (rect) {
                return LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    gradientStart,
                    getBackground()
                        .evaluate(AlwaysStoppedAnimation(_controller.value))!
                  ],
                ).createShader(rect);
              },
              blendMode: BlendMode.srcATop,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image:
                        ExactAssetImage('assets/images/github_globe_edit1.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            ShoppingListView(key: Key("ShoppingListView"))
          ]));
        });
  }
}

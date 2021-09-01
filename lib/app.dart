import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shoppinglist_app_mobile/shopping_list/view/shopping_list_page.dart';
import 'package:shoppinglist_app_mobile/shopping_list_repository.dart';

class App extends StatelessWidget {
  const App({Key? key, required this.shoppingRepository}) : super(key: key);

  final ShoppingRepository shoppingRepository;

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
      );
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      if (MediaQuery.of(context).padding.top == 0) {
        SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
      }
    }
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          dividerTheme: DividerThemeData(
            color: Colors.white,
            thickness: 2,
            indent: 10,
            endIndent: 30,
          )),
      home: ShoppingListPage(title: 'Inköpslista', shoppingRepository: shoppingRepository),
    );
  }
}
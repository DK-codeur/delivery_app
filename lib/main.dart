import 'package:delivery_app/providers/cart_provider.dart';
import 'package:delivery_app/providers/cmd.dart';
import 'package:delivery_app/screen/cart_screen.dart';
import 'package:delivery_app/screen/cmd_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Commandes(),
        ),

        ChangeNotifierProvider.value(
          value: Cart(),
        ),
      ],
      child: MaterialApp(
        title: 'App commande',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        debugShowCheckedModeBanner: false,
        home: CmdScreen(),
        routes: {
          CartScreen.routeName: (context) => CartScreen(),
        },
      ),
    );
  }
}



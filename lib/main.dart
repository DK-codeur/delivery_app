import './providers/cart_provider.dart';
import './providers/cmd.dart';
import './providers/commande_history.dart';
import './screen/cart_screen.dart';
import './screen/cmd_screen.dart';
import './screen/commande_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
 

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

        ChangeNotifierProvider.value(
          value: CommandeHistory()
        )


      ],
      child: MaterialApp(
        title: 'App Livraison',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        debugShowCheckedModeBanner: false,
        home: CmdScreen(),
        routes: {
          CartScreen.routeName: (context) => CartScreen(),
          CommandeHistoryScreen.routeName: (context) => CommandeHistoryScreen(),
        },
      ),
    );
  }
}



import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../widgets/main_drawer.dart';
import '../providers/cart_provider.dart';
import '../providers/cmd.dart';
import '../widgets/badge.dart';
import '../widgets/cmd_item.dart' as widgetCmd;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_screen.dart';


class CmdScreen extends StatefulWidget {
  static const routeName = '/cmdscreen';
  

  @override
  _CmdScreenState createState() => _CmdScreenState();
}


class _CmdScreenState extends State<CmdScreen> {
  var test = 1;
  var _isInit = true;
  var _isLoading = false;  

  
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true; 
      });

      Provider.of<Commandes>(context).fetchAndSetCommande().then((_) {
        setState(() {
          _isLoading = false; 
        });
      });
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  
  Future onSelectNotification(String payload) async {
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: Text('Nouvelle Commande'),
        content: Text('De nouvelles commandes sont disponible'),
      )
    );
  }

Future _showNotificationWithSound() async {
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
    'your channel id', 'your channel name', 'your channel description',
    sound: 'hit',
    importance: Importance.Max,
    priority: Priority.High
  );
  var iOSPlatformChannelSpecifics =
      new IOSNotificationDetails(sound: "hit.aiff");
  var platformChannelSpecifics = new NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0,
    'Nouvelle Commande',
    'de nouvelles commandes sont disponible',
    platformChannelSpecifics,
    payload: 'Custom_Sound',
  );
}


  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

  @override
  void initState() {

    var initializationSettingsAndroid = new AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsIOS = new IOSInitializationSettings();

    var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification
    );

      
      super.initState();
  }


  Future<void> _refreshCmd() async {
    await Provider.of<Commandes>(context).fetchAndSetCommande();
  }

  @override
  Widget build(BuildContext context) {
      
  // void _showErrorDialog(String message) {
  //   showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (ctx) => AlertDialog(
  //       title: Text('Ouups! Error', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),),
  //       content: Text(message),

  //       actions: <Widget>[
  //         FlatButton(
  //           child: Text('OK'),
  //           onPressed: () async {
  //             await _refreshCmd();
  //             Navigator.of(context).pop();
  //           },
  //         )
  //       ],
  //     )
  //   );
  // }


      final cmdData = Provider.of<Commandes>(context, listen: false);
      final commande = cmdData.commandes;

      var ttcmd = cmdData.getTotalCmd();
      
      
      
      final Stream<int> _periodicStream = Stream.periodic(
        Duration(seconds: 30), 
        (i) => i
      );
    
    return Scaffold(
      appBar: AppBar(
        title: Text('COMMANDES'),
        centerTitle: true,
        actions: <Widget>[
          Consumer<Cart>(
              builder: (_, cart, ch) => Badge(
                value: cart.itemCount.toString(),
                child: ch,
              ),

              child: IconButton(
                icon: Icon(Icons.room_service, size: 30,),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ),
          )
        ],
      ),
      drawer: MainDrawer(),
      

      body: (_isLoading) 
      ? SpinKitChasingDots(color: Colors.red, size: 45)
      : StreamBuilder(
        stream: _periodicStream,
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (snapshot.data != null) {
            try {
              _refreshCmd();                
            } catch (e) {
              var msg = 'erreur verifiez la connexion';
              // _showErrorDialog(msg);
              Fluttertoast.showToast(
                msg: msg,
                toastLength: Toast.LENGTH_LONG, 
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 13.0
              );
            }

          }
            if((ttcmd + 1) == this.test) {
              print(this.test);
              print(ttcmd);
              // return null;
            } else if((ttcmd + 2) == this.test) {
              this.test = this.test - 1;     
              print(this.test);
              print(ttcmd);        
            } else if(ttcmd == this.test) {
               print(this.test);
              print(ttcmd);
              _showNotificationWithSound();
            
              this.test = this.test + 1; 
            }

          return ListView.builder(
            itemCount: commande.length,
            itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              value: commande[i],
              child: widgetCmd.CmdItem(
                //all prop
                ii: i+1,
              ),
            )
          );
        },

        
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        elevation: 8,
        child: Text('${cmdData.getTotalCmd()}', style: TextStyle(fontSize: 18),)
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat
    );
  }
}
      

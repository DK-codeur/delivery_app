import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../widgets/main_drawer.dart';
import '../providers/cart_provider.dart';
import '../providers/cmd.dart';
import '../widgets/badge.dart';
import '../widgets/cmd_item.dart' as widgetCmd;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_screen.dart';


class CmdScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _CmdScreenState createState() => _CmdScreenState();
}


class _CmdScreenState extends State<CmdScreen> {
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


  Future<void> _refreshCmd() async {
    await Provider.of<Commandes>(context).fetchAndSetCommande();
  }

  @override
  Widget build(BuildContext context) {

      final cmdData = Provider.of<Commandes>(context, listen: false);
      final commande = cmdData.commandes;
    
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
                icon: Icon(Icons.room_service),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ),
          )
        ],
      ),
      drawer: MainDrawer(),
      

      body: RefreshIndicator(
        onRefresh: () => _refreshCmd(),

        child: (_isLoading) 
      ? Center(child: SpinKitChasingDots(color: Colors.redAccent, size: 50,)) 
      : ListView.builder(
          itemCount: commande.length,
          itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
            value: commande[i],
            child: widgetCmd.CmdItem(
              //all prop
              ii: i+1,
            ),
          )
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
        },
        child: Text('${cmdData.getTotalCmd()}', style: TextStyle(fontSize: 18),)
      ),
    );
  }
}
      

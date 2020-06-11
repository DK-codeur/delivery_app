import 'dart:math';
import 'package:delivery_app/providers/cart_provider.dart';
import 'package:delivery_app/providers/cmd.dart';
import 'package:delivery_app/providers/produit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CartItemModel extends StatefulWidget {

  final String id;
  final String cmdItemId;
  final double amount;
  final List<Produit> products;
  final String name;
  final String adress;
  final String phone;
  final DateTime dateTime;
  final int ii;

  CartItemModel(
    this.id, 
    this.cmdItemId, 
    this.amount, 
    this.products, 
    this.name, 
    this.adress, 
    this.phone, 
    this.dateTime,
   { this.ii}
  );

  @override
  _CartItemModelState createState() => _CartItemModelState();
}

class _CartItemModelState extends State<CartItemModel> {
  var _expanded = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {

    final cmdActions = Provider.of<Commandes>(context, listen: false);
    final cartItem = Provider.of<Cart>(context);

    void _showErrorDialog(String message) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Ouups! Error', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),),
        content: Text(message),

        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      )
    );
  }

    return Card(
      margin: EdgeInsets.all(10),
      elevation: 3,
      child: Column(
        children: <Widget>[
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('${widget.name}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                Text('${widget.amount.toInt()} F', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange)),
              ],
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(DateFormat('dd-MM-yyyy hh:mm').format(widget.dateTime)),
                IconButton(
                  icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  },
                )
              ],
            ),
            
          ),

          if(_expanded) 
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: min(
                widget.products.length * 20.0 + (40*3.5), 
                190
              ),
              child: ListView(
                children: <Widget> [
                  Column(
                    children : widget.products.map((prod) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              prod.title,
                            ),
                            Text(prod.isMenu, style: TextStyle(color: Colors.redAccent),)
                          ],
                        ),

                        Text(
                          '${prod.quantity}x ${prod.price.toInt()} F',
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        )
                      ],
                    )).toList()
                  ),

                  Column(
                    children: <Widget>[
                      SizedBox(height: 10,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Client :'),
                            Text(widget.name),
                          ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Tel. :'),
                            Text(widget.phone),
                          ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Adr. livraison :'),
                          Text(widget.adress)
                        ],
                      ),

                      Divider(),

                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[

                            (_isLoading) 
                          ? SpinKitFadingCircle(color: Colors.green, size: 32,) 
                          : RaisedButton(
                              color: Colors.green,
                              child: Text('Livrer', style: TextStyle(color: Colors.white)),
                              
                              onPressed: () { 
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Livrer ?', style: TextStyle(fontSize: 22, color: Colors.green),),
                                  content: Text('La commande est-elle prête pour la livraison ?'),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('Annuler', style: TextStyle(color: Colors.black),),
                                      onPressed: (){ 
                                        Navigator.of(context).pop(context);
                                      },
                                    ),

                                    SizedBox(width: 30,),

                                    RaisedButton(
                                        color: Colors.green,
                                        child: Text('Livrer', style: TextStyle(color: Colors.white),),

                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          setState(() {
                                            _isLoading = true; 
                                          });

                                          try{
                                            await cmdActions.addCommandeToHistory(
                                            widget.products.map((prod) => Produit(
                                              id: prod.id,
                                              price: prod.price,
                                              quantity: prod.quantity,
                                              title: prod.title,
                                              isMenu: prod.isMenu,
                                            )).toList(), 
                                            widget.amount, 
                                            widget.name, 
                                            widget.adress, 
                                            widget.phone,
                                          );
                                        
                                            // print(widget.cmdItemId);
                                            cartItem.removeItem(widget.cmdItemId); //cart
                                            await cmdActions.deleteCommande(widget.cmdItemId);//cmd

                                            Fluttertoast.showToast(
                                              msg: 'Commande embarquée pour la livraison',
                                              toastLength: Toast.LENGTH_LONG, 
                                              gravity: ToastGravity.BOTTOM,
                                              backgroundColor: Colors.green,
                                              textColor: Colors.white,
                                              fontSize: 13.0
                                            );

                                        } catch (error) {
                                          var msg = 'Livraison impossible réessayez! erreur';
                                          _showErrorDialog(msg);

                                        }

                                          setState(() {
                                          _isLoading = false;
                                        });


                                  },

                                      ),
                                  ],
                                )

                              );
                              }

                            )
                          ],
                        ),
                      )
                    ],
                  )
                
                 ]

                
                
              )
            )
          


        ],
      ),
    );

    
  }
}



// class CommandeHistoryButton extends StatefulWidget {
//   const CommandeHistoryButton({
//     Key key,
//     @required this.cart,
//   }) : super(key: key);

//   final Cart cart;

//   @override
//   _CommandeHistoryButtonState createState() => _CommandeHistoryButtonState();
// }

// class _CommandeHistoryButtonState extends State<CommandeHistoryButton> {
//   var _isLoading = false;

//   @override
//   Widget build(BuildContext context) {
//     return RaisedButton(
//       textColor: Colors.white,
//       child: (_isLoading)
//         ? CircularProgressIndicator() 
//         : Text('Livrer'),
        
//       onPressed: () 
//       ? null 
//       :  () async {

//         setState(() {
//           _isLoading = true;
//         });

//         await Provider.of<Commandes>(context, listen: false).addCommandeToHistory(
//           widget.cart.items.
//         );

//         setState(() {
//           _isLoading = false;
//         });

//         widget.cart.clear();
//       },
//     );
//   }
// }
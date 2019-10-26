import 'package:delivery_app/providers/cart_provider.dart';
import 'package:delivery_app/providers/produit.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:delivery_app/providers/cmd.dart' as cmd;
import 'package:provider/provider.dart'; 

//cmd Item widget
class CmdItem extends StatefulWidget {

  final int ii;

  CmdItem({this.ii,});

  @override
  _CmdItemState createState() => _CmdItemState();
}

class _CmdItemState extends State<CmdItem> {
  var _expanded = false;

  bool _isInactive = false;
  Color _inactiveColor = Colors.grey[300];

  bool setInactive() {
    setState(() {
      _isInactive = true;
    });

    return _isInactive;
  }



  @override
  Widget build(BuildContext context) {

   //cmdItem de cmd provider == cmdItem
    final commande = Provider.of<cmd.CmdItem>(context, listen: false);
    final commandes = Provider.of<cmd.Commandes>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 3,
      child: Column(
        children: <Widget>[
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Commande N°${widget.ii}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: (_isInactive) ? _inactiveColor : Colors.black)),
                Text('${commande.amount.toInt()} F', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: (_isInactive) ? _inactiveColor : Colors.orange)),
              ],
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('${DateFormat('dd-MM-yyyy hh:mm').format(commande.dateTime)}', style: TextStyle(color: (_isInactive) ? _inactiveColor : Colors.black),),
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
                commande.products.length * 20.0 + (40*3.3), 
                190
              ),
              child: ListView(
                children: <Widget> [
                  Column(
                    children : commande.products.map((prod) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              '${prod.title}', style: TextStyle(color: (_isInactive) ? _inactiveColor : Colors.black),
                            ),
                            Text(' ${prod.isMenu}', style: TextStyle(color: (_isInactive) ? _inactiveColor : Colors.redAccent),)
                          ],
                        ),

                        Text(
                          '${prod.quantity}x ${prod.price.toInt()} F',
                          style: TextStyle(fontSize: 15, color: (_isInactive) ? _inactiveColor : Colors.grey),
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
                            Text('Client :', style: TextStyle(color: (_isInactive) ? _inactiveColor : Colors.black)),
                            Text('${commande.name}', style: TextStyle(color: (_isInactive) ? _inactiveColor : Colors.black)),
                          ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Tel. :', style: TextStyle(color: (_isInactive) ? _inactiveColor : Colors.black)),
                            Text('${commande.phone}', style: TextStyle(color: (_isInactive) ? _inactiveColor : Colors.black)),
                          ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Adr. livraison :', style: TextStyle(color: (_isInactive) ? _inactiveColor : Colors.black)),
                          Text(commande.adress, style: TextStyle(color: (_isInactive) ? _inactiveColor : Colors.black))
                        ],
                      ),

                      Divider(),

                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[

                            OutlineButton(
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 2.0,
                              ),
                              child: Text('Supprimer', style: TextStyle(color: (_isInactive) ? _inactiveColor : Colors.red)),
                              onPressed: (_isInactive) ? null : () {},
                            ),

          
                          RaisedButton(
                              color: Colors.red,
                              child: Text('Valider', style: TextStyle(color: Colors.white)),

                              onPressed: (_isInactive) ? null : () => showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text('Valider ?', style: TextStyle(fontSize: 22, color: Colors.red),),
                                  content: Text('Voulez-vous valider cette commande ?'),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('Annuler'),
                                      onPressed: (){ 
                                        Navigator.of(context).pop();
                                      },
                                    ),

                                    SizedBox(width: 30,),

                                    RaisedButton(
                                      color: Colors.red,
                                      child: Text('Valider', style: TextStyle(color: Colors.white),),

                                      onPressed: () {
                                        cart.addItem(
                                          commande.id, 
                                          commande.amount, 
                                          commande.products.map((prod) => Produit(
                                            id: prod.id,
                                            price: prod.price,
                                            quantity: prod.quantity,
                                            title: prod.title,
                                            isMenu: prod.isMenu,
                                          )).toList(), 
                                          commande.name, 
                                          commande.adress, 
                                          commande.phone, 
                                          commande.dateTime
                                        );

                                      Fluttertoast.showToast(
                                        msg: 'Commande validée !',
                                        toastLength: Toast.LENGTH_LONG, 
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.green,
                                        textColor: Colors.white,
                                        fontSize: 13.0
                                      );

                                      setInactive();
                                      commandes.deleteTempCommande(commande.id);
                                      Navigator.of(context).pop();
                                  },

                                    )
                                  ],
                                )

                              )
                            ),

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



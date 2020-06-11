import 'package:delivery_app/providers/cart_provider.dart';
import 'package:delivery_app/providers/produit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
  bool _isLoading = false;
  bool changeColor = false;

  @override
  Widget build(BuildContext context) {

   //cmdItem de cmd provider == cmdItem
    final commande = Provider.of<cmd.CmdItem>(context);
    final commandes = Provider.of<cmd.Commandes>(context); //special
    final cart = Provider.of<Cart>(context, listen: false);


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
                Text('${commande.name}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: (changeColor) ? Colors.grey[400] : Colors.black)),
                Text('${commande.amount.toInt()} F', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: (changeColor) ? Colors.grey[400] : Colors.orange)),
              ],
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('${DateFormat('dd-MM-yyyy hh:mm a').format(commande.dateTime)}', style: TextStyle(color: (changeColor) ? Colors.grey[400] : Colors.black),),
                IconButton(
                  icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more, color: Colors.grey[400],),
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
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: ListView(
                  children: <Widget> [
                    Column(
                      children : commande.products.map((prod) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                '${prod.title}', style: TextStyle(color: (changeColor) ? Colors.grey[400] : Colors.black),
                              ),
                              Text(' ${prod.isMenu}', style: TextStyle(color: (changeColor) ? Colors.grey[400] : Colors.redAccent),)
                            ],
                          ),

                          Text(
                            '${prod.quantity}x ${prod.price.toInt()} F',
                            style: TextStyle(fontSize: 15, color: (changeColor) ? Colors.grey[400] : Colors.grey),
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
                              Text('Client :', style: TextStyle(color: (changeColor) ? Colors.grey[400] : Colors.black)),
                              Text('${commande.name}', style: TextStyle(color: (changeColor) ? Colors.grey[400] : Colors.black)),
                            ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Tel. :', style: TextStyle(color: (changeColor) ? Colors.grey[400] : Colors.black)),
                              Text('${commande.phone}', style: TextStyle(color: (changeColor) ? Colors.grey[400] : Colors.black)),
                            ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Adr. livraison :', style: TextStyle(color: (changeColor) ? Colors.grey[400] : Colors.black)),
                            Text(commande.adress, style: TextStyle(color: (changeColor) ? Colors.grey[400] : Colors.black))
                          ],
                        ),

                        Divider(),

                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[

                              (_isLoading) 
                              ? SpinKitFadingCircle(size: 30, color: Colors.red) 
                              : OutlineButton(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 2.0,
                                ),
                                child: Text('Supprimer', style: TextStyle(color: Colors.red)),
                                onPressed: () async {

                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Supprimer ?', style: TextStyle(color: Colors.red, fontSize: 20),),
                                      content: Text(
                                        'Voulez vous supprimer cette commande ? \n\n'
                                        'ATTENTION !!! cette action est irréversible'
                                      ),

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
                                        child: Text('Supprimer', style: TextStyle(color: Colors.white),),

                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                          setState(() {
                                            _isLoading = true; 
                                          });

                                          try {
                                            commandes.deleteTempCommande(commande.id);
                                            await commandes.deleteCommande(commande.id);
                                            // CmdScreen
                                          } catch (error) {
                                            var msg = 'Une erreur s\'est produite suppression impossible';
                                            
                                            _showErrorDialog(msg);
                                          }

                                          //  setState(() {
                                            _isLoading = false; 
                                          // });


                                        Fluttertoast.showToast(
                                          msg: 'Commande Spprimer !',
                                          toastLength: Toast.LENGTH_LONG, 
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: Colors.black,
                                          textColor: Colors.white,
                                          fontSize: 14.0
                                        );

                                        
                                    },

                                      )
                                    ],
                                    )
                                  );
                                  
                                },
                              ),

          
                            RaisedButton(
                                color: Colors.red,
                                child: Text('Valider', style: TextStyle(color: Colors.white)),

                                onPressed: (changeColor) ? null : () => showDialog(
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

                                        
                                        setState(() {
                                          changeColor = true;
                                        });
                                        // commandes.deleteTempCommande(commande.id);
                                         //id car le screen lui envoi des donnee
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

                  
                  
                ),
              )
            )
          


        ],
      ),
    );

    
  }

  
}



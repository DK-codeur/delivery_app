import 'dart:math';

import 'package:delivery_app/providers/commande_history.dart' as cmdhist;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CmdHistoryItem extends StatefulWidget {
  @override
  _CmdHistoryItemState createState() => _CmdHistoryItemState();
}

class _CmdHistoryItemState extends State<CmdHistoryItem> {

  var _expanded = false; 
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {

    final cmdHistoryItem = Provider.of<cmdhist.CmdHistoryItem>(context, listen: false);
    // final cmdHistoryData = Provider.of<cmdhist.CommandeHistory>(context, listen: false);

    return Card(
      margin: EdgeInsets.all(10),
      elevation: 3,
      child: Column(
        children: <Widget>[
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('${DateFormat('dd/MM/yyyy').format(cmdHistoryItem.dateTime)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.green)),
                Text('${cmdHistoryItem.name.toUpperCase()}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black)),
              ],
            ),
            subtitle: Column(
              children: <Widget>[
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('${cmdHistoryItem.adress}'),
                    SizedBox(width: 5,),
                    Text('-'),
                    SizedBox(width: 5,),
                    Text('Tel: ${cmdHistoryItem.phone}', ),
                  ],
                ),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                      onPressed: () {
                        setState(() {
                          _expanded = !_expanded;
                        });
                      },
                    ),
                  ],
                )
              ],
            ),
            
          ),

          if(_expanded) 
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15,),
              height: min(
                cmdHistoryItem.products.length * 20.0 + (40*2), 
                190
              ),
              child: ListView(
                children: <Widget> [
                  Column(
                    children : cmdHistoryItem.products.map((prod) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              '${prod.title}', style: TextStyle(color: Colors.black),
                            ),
                            Text(' ${prod.isMenu}', style: TextStyle(color: Colors.redAccent),)
                          ],
                        ),

                        Text(
                          '${prod.quantity}x ${prod.price.toInt()} F',
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        )
                      ],
                    )).toList(),

                    
                  ),

                  Column(
                    children: <Widget>[
                      SizedBox(height: 10,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: <Widget>[
                          Text('TOTAL', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),),
                          Text('${cmdHistoryItem.amount.toInt()} F', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),),
                       ],
                      ),

                      Divider(),

                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[

                          (_isLoading) 
                          ? SpinKitFadingCircle(color: Colors.green, size: 32) 
                          : OutlineButton(
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 2.0,
                              ),
                              child: Text('Supprimer',),

                              onPressed: null
                              //() => showDialog(
                              //   context: context,
                              //   barrierDismissible: false,
                              //   builder: (context) => AlertDialog(
                              //     title: Text('Supprimer l\'historique ?', style: TextStyle(fontSize: 22, color: Colors.red),),
                              //     content: Text('Voulez-vous supprimer cette vente de votre histoique de vente ?'),
                              //     actions: <Widget>[

                              //       FlatButton(
                              //         child: Text('Annuler', style: TextStyle(color: Colors.black),),
                              //         onPressed: (){ 
                              //           Navigator.of(context).pop(context);
                              //         },
                              //       ),

                              //       SizedBox(width: 30,),

                              //       OutlineButton(
                              //         child: Text('Supprimer'),
                              //         borderSide: BorderSide(
                              //           color: Colors.red,
                              //           width: 2.0,
                              //         ),

                              //         onPressed: () {}

                              //         // onPressed: () async {
                              //         //   Navigator.of(context).pop();
                              //         //   setState(() {
                              //         //     _isLoading = true; 
                              //         //   });

                              //         //   try{
                              //         //     await cmdHistoryData.deleteCommandeHistory(cmdHistoryItem.id);
                              //         //     Fluttertoast.showToast(
                              //         //         msg: 'vente supprimée de l\'historique',
                              //         //         toastLength: Toast.LENGTH_LONG, 
                              //         //         gravity: ToastGravity.BOTTOM,
                              //         //         backgroundColor: Colors.green,
                              //         //         textColor: Colors.white,
                              //         //         fontSize: 13.0
                              //         //     );
                              //         //   } catch(error) {
                              //         //     throw 'erreur lors de la supression de l\'historique $error';
                              //         //   }

                              //         //   setState(() {
                              //         //   _isLoading = true; 
                              //         //   });
                              //         // },
                              //       )
                              //     ],
                              //   )
                              // ),
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



  // onPressed: () async {
  //                               setState(() {
  //                                _isLoading = true; 
  //                               });

  //                               try{
  //                                 await cmdHistoryData.deleteCommandeHistory(cmdHistoryItem.id);
  //                               } catch(error) {
  //                                 throw 'erreur lors de la supression de l\'historique $error';
  //                               }

  //                               setState(() {
  //                                _isLoading = true; 
  //                               });
  //                             },
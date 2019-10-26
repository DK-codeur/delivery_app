import 'dart:math';
import 'package:delivery_app/providers/produit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CartItemModel extends StatefulWidget {

  final String id;
  final double amount;
  final List<Produit> products;
  final String name;
  final String adress;
  final String phone;
  final DateTime dateTime;
  final int ii;

  CartItemModel(
    this.id, 
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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 3,
      child: Column(
        children: <Widget>[
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Cmd acceptée N°${widget.ii}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
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
                widget.products.length * 20.0 + (40*3.3), 
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
                            RaisedButton(
                              color: Colors.green,
                              child: Text('Livrer', style: TextStyle(color: Colors.white)),
                              onPressed: () {},
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
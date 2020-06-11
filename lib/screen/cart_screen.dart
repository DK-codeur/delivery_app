import 'package:delivery_app/providers/cart_provider.dart';
import 'package:delivery_app/widgets/cart_item_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = 'cartScreen';

  @override
  Widget build(BuildContext context) {

    final cmdAccepted = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('COMMANDES ACCEPTEES')
      ),

      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: Center(
              child: Text(
                '${cmdAccepted.getCmdAcceptedLength()} Commandes à livrer', 
                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey, fontSize: 22)
              )
            )
          ),

          Expanded(
            child: ListView.builder(
              itemCount: cmdAccepted.items.length,
              itemBuilder: (ctx, i) => CartItemModel(
                cmdAccepted.items.values.toList()[i].id,
                cmdAccepted.items.keys.toList()[i],
                cmdAccepted.items.values.toList()[i].amount,
                cmdAccepted.items.values.toList()[i].products, //
                cmdAccepted.items.values.toList()[i].name,               
                cmdAccepted.items.values.toList()[i].adress,              
                cmdAccepted.items.values.toList()[i].phone,              
                cmdAccepted.items.values.toList()[i].dateTime,   
                ii: i+1,           
              ),
            )
          ),

        ],
      )
    );
  }
}
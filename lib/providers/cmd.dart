import 'dart:async';
import 'dart:convert';

import 'package:delivery_app/models/http_exception.dart';
import 'package:delivery_app/providers/produit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CmdItem with ChangeNotifier{ // commande item
  final String id;
  final double amount;
  final List<Produit> products;
  final String name;
  final String adress;
  final String phone;
  final DateTime dateTime;

  CmdItem({
    @required this.id, 
    @required this.amount, 
    @required this.products, 
    @required this.name, 
    @required this.adress, 
    @required this.phone, 
    @required this.dateTime
  });



}

class CmdItemList {
  final CmdItem cmdItem;

  CmdItemList({this.cmdItem});

}


class Commandes with ChangeNotifier {
  List<CmdItem> _commandes = [];


  List<CmdItem> get commandes {
    return [..._commandes];
  }


  Future<void> fetchAndSetCommande() async {
    final url = 'https://hit78f-food3b.firebaseio.com/orders.json';
    final response =  await http.get(url);
    final List<CmdItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    // print(extractedData);

    if(extractedData == null) {
      return '';
    }

    extractedData.forEach((cmdId, cmdData) {
      loadedOrders.add(
        CmdItem(
          id: cmdId,
          amount: cmdData['amount'],
          dateTime: DateTime.parse(cmdData['dateTime']),
          products: (cmdData['products'] as List<dynamic>).map((item) => Produit(
            id: item['id'],
            price: item['price'],
            quantity: item['quantity'],
            title: item['title'],
            isMenu: item['isMenu']
          )).toList(),
          name: cmdData['name'],
          adress: cmdData['adress'],
          phone: cmdData['phone']
        )
      );
    });

    // _commandes = loadedOrders.reversed.toList();
    _commandes = loadedOrders.toList();
    notifyListeners();

  }


  Future<void> addCommandeToHistory(List<Produit> cartProducts, double total, String name, String adress, String phone) async {
    final url = 'https://hit78f-food3b.firebaseio.com/ordershistory.json';
    final timeStamp = DateTime.now();
    await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': timeStamp.toIso8601String(),
        //'userId': idU, //cmd's user
        'name': name,
        'adress': adress,
        'phone': phone,
        'products': cartProducts.map((cp) => {
          'id': cp.id,
          'title': cp.title,
          'quantity': cp.quantity,
          'price': cp.price,
          'isMenu': cp.isMenu,

        }).toList()
      })
    );

    notifyListeners();
  }

  Future<void> deleteCommande(String id) async {
    final url = 'https://hit78f-food3b.firebaseio.com/orders/$id.json';
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      // _commandes.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Reessayez');  
    }
    // existingProduct = null;
    
  }
  

  void deleteTempCommande(String id) {
    _commandes.removeWhere((cmd) => cmd.id == id);
    notifyListeners();
  }



  int getTotalCmd() {
    return commandes.length;
  }

  int getTotalCmdPlus() {
    return 19;
  }


}

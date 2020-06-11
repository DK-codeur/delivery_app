import 'dart:convert';

import 'package:delivery_app/models/http_exception.dart';
import 'package:delivery_app/providers/produit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CmdHistoryItem with ChangeNotifier{ // commande Hist item
  final String id;
  final double amount;
  final List<Produit> products;
  final String name;
  final String adress;
  final String phone;
  final DateTime dateTime;

  CmdHistoryItem({
    @required this.id, 
    @required this.amount, 
    @required this.products, 
    @required this.name, 
    @required this.adress, 
    @required this.phone, 
    @required this.dateTime
  });
}

class CommandeHistory with ChangeNotifier  {

  List<CmdHistoryItem> _commandesHistory = [];

  List<CmdHistoryItem> get commandesHistory {
    return [..._commandesHistory];
  }



  Future<void> fetchAndSetCommandeHistory() async {
    final url = 'https://hit78f-food3b.firebaseio.com/ordershistory.json';
    final response = await http.get(url);
    final List<CmdHistoryItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    // print(extractedData);

    if(extractedData == null) {
      return;
    }

    extractedData.forEach((cmdId, cmdData) {
      loadedOrders.add(
        CmdHistoryItem(
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
    _commandesHistory = loadedOrders.reversed.toList();
    notifyListeners();

  }

  Future<void> deleteCommandeHistory(String id) async {
    final url = 'https://hit78f-food3b.firebaseio.com/ordershistory/$id.json';
    final existingProductIndex = _commandesHistory.indexWhere((cmd) => cmd.id == id);
    var existingProduct = _commandesHistory[existingProductIndex];
    _commandesHistory.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _commandesHistory.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Reessayez');  
    }
    // existingProduct = null;
    
  }
  
}
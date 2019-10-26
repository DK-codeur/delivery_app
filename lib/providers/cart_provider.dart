import 'package:delivery_app/providers/produit.dart';
import 'package:flutter/material.dart';

class CartItem { //cart item
  final String id;
  final double amount;
  final List<Produit> products;
  final String name;
  final String adress;
  final String phone;
  final DateTime dateTime;

  CartItem({
    @required this.id, 
    @required this.amount, 
    @required this.products, 
    @required this.name, 
    @required this.adress, 
    @required this.phone, 
    @required this.dateTime
  });
}

class Cart with ChangeNotifier {

  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  // double get totalAmount {
  //   var total = 0.0;
  //   _items.forEach((key, cartItem) {
  //     total += cartItem.price * cartItem.quantity;
  //   });

  //   return total;
  // }

  void addItem(String cmdId, double amount, List<Produit> products, String name, String adress, String phone, DateTime dateTime) {
   
   _items.putIfAbsent(
      cmdId, 
      () => CartItem(
        id: cmdId, //date id 
        amount: amount, 
        products: (products).map((item) => Produit( //no cast cme => (products as List<dynamic>).map...
          id: item.id,
          price: item.price,
          quantity: item.quantity,
          title: item.title,
          isMenu: item.isMenu,
        )).toList(),
        name: name,
        adress: adress,
        phone: phone,
        dateTime: dateTime,
      )
  );
    notifyListeners();
  }

  void removeItem(String cmdId) {
    _items.remove(cmdId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  int getCmdAcceptedLength() {
    return items.length;
  }

}




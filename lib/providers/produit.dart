import 'package:flutter/material.dart';

class Produit {
  final String id;
  final double price;
  final int quantity;
  final String title;
  final String isMenu;

  Produit({
    @required this.id, 
    @required this.price, 
    @required this.quantity, 
    @required this.title, 
    @required this.isMenu
  });
}
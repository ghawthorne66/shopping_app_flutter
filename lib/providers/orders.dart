import 'package:flutter/material.dart';
import 'package:shopping_app/providers/cart.dart';
import './cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future <void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.https(
        'flutterapp-1a145-default-rtdb.firebaseio.com', '/products.json');
    final timeStamp = DateTime.now();
    final response = await http.post(url, body: json.encode({
    'amount': total,
    'dateTime': timeStamp.toIso8601String(),
      'products': cartProducts.map((cp) =>
      {
        'id': cp.id,
        'title': cp.title,
        'quantity': cp.quantity,
        'price': cp.price,
      })
          .toList(),

    }),);

    _orders.insert(0,
    OrderItem(
      id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: DateTime.now(),
    ),
    );
    notifyListeners();
  }
}

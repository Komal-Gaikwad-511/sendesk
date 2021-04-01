import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sendesk/locator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sendesk/src/products/product.dart';
import 'package:sendesk/src/products/products_api_service.dart';

class ProductModel extends ChangeNotifier {
  ProductApiService _api = locator<ProductApiService>();                                                                                                                                                                                                                                                                                                                                                                                                                                                      

  List<Product> products;

  Future<List<Product>> fetchProducts() async {
    var result = await _api.getDataCollection();
    products = result.documents
        .map((doc) => Product.fromMap(doc.data, doc.documentID))
        .toList();
    return products;
  }

  Stream<QuerySnapshot> fetchProductsAsStream() {
    return _api.streamDataCollection();
  }

  Future<Product> getProductById(String id) async {
    var doc = await _api.getDocumentById(id);
    return Product.fromMap(doc.data, doc.documentID);
  }

  Future removeProduct(String id) async {
    await _api.removeDocument(id);
    return;
  }

  Future updateProduct(Product data, String id) async {
    await _api.updateDocument(data.toJson(), id);
    return;
  }

  Future addProduct(Product data) async {
    await _api.addDocument(data.toJson());

    return;
  }
}

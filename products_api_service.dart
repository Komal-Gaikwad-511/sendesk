import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class ProductApiService {
  final Firestore _db = Firestore.instance;
  CollectionReference ref;

  ProductApiService() {
    ref = _db.collection('OUTLET/L1l0s1Ugd5ePcBGwwZnZ/PRODUCT/');
  }

  Future<QuerySnapshot> getDataCollection() {
    return ref.getDocuments() ;
  }
  Stream<QuerySnapshot> streamDataCollection() {
    return ref.where('type', isEqualTo: 0)
      .orderBy('code', descending: false).limit(30).snapshots();
  }
  Future<DocumentSnapshot> getDocumentById(String id) {
    return ref.document(id).get();
  }
  Future<void> removeDocument(String id){
    return ref.document(id).delete();
  }
  Future<DocumentReference> addDocument(Map data) {
    return ref.add(data);
  }
  Future<void> updateDocument(Map data , String id) {
    return ref.document(id).updateData(data) ;
  }


}
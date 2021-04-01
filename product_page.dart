import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sendesk/src/products/product.dart';
import 'package:sendesk/src/products/product_list_card.dart';
import 'package:sendesk/src/products/product_model.dart';
//import 'package:sendesk/src/products/search_product.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  Widget appBarTitle = new Text("Products");
  Icon actionIcon = new Icon(Icons.search);

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: appBarTitle,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
               /* Navigator.push(
                  context,
                  MaterialPageRoute(
                   builder: (_) => SearchListExample(),
                  ),
                );*/

                /*setState(() {
              if(this.actionIcon.icon == Icons.search)
              {
                this.actionIcon=new Icon(Icons.close);
                this.appBarTitle=new TextField(
                  style:new TextStyle(color:Colors.white),
                  decoration:new InputDecoration(
                  hintText:"search product...",
                  hintStyle:new TextStyle(color:Colors.white),
                ),
              );             
              }
              else{
                this.actionIcon = new Icon(Icons.search);
                this.appBarTitle =new Text("Product");
              }            
          });*/
              }),
        ],
      ),
      body: Container(
        child: StreamBuilder(
            stream: productProvider.fetchProductsAsStream(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                List<Product> products = snapshot.data.documents
                    .map((doc) => Product.fromMap(doc.data, doc.documentID))
                    .toList();
                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (buildContext, index) =>
                      ProductListCard(products[index]),
                );
              } else {
                return Center(child: Text('Lodding data...'));
              }
            }),
      ),
    );
  }
}

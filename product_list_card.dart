import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sendesk/src/cart/cart.dart';
import 'package:sendesk/src/modules/item.dart';
import 'package:sendesk/src/products/product.dart';
//import 'package:sendesk/src/products/product_detailsPage.dart';
import 'package:sendesk/src/products/product_details_page.dart';

class ProductListCard extends StatelessWidget {
  final Product product;
  ProductListCard(this.product);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Card(
      child: ListTile(
        leading: product.image == null
            ? Image.asset('assets/favicon.png')
            : Image.network(product.image),
        title: Text(product.name),
        //subtitle: Text('Rs. ${product.price}'),
        subtitle: new RichText(
          text: new TextSpan(
            children: <TextSpan>[
              TextSpan(
                  text: 'Rs. ${product.price}',
                  style: new TextStyle(
                    color: const Color(0xff546e7a),
                    decorationStyle: TextDecorationStyle.solid,
                  )),
              TextSpan(text: '\t\t\t\t\t'),
              //if (product.mrp_price > product.price)
              TextSpan(
                  text: _widgetMrpPrice(),
                  style: new TextStyle( color: const Color(0xff546e7a), decoration: TextDecoration.lineThrough)),
            ],
          ),
        ),
        
        trailing: IconButton(
          padding: const EdgeInsets.all(20),
          icon: Icon(Icons.add_shopping_cart),
          onPressed: () {
            double price = product.price;
            cart.addItem(
                //Item(product.id, product.name, "category", price, 1.0, 0));
                Item(id: product.id, name: product.name, category: "catgory", price: price, quantity: 1, discount: 0));
            Fluttertoast.showToast(
                msg: "Item added into cart", toastLength: Toast.LENGTH_SHORT);
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailsPage(product: product),
            ),
          );
        },
      ),
    );
  }
  String _widgetMrpPrice(){
      String mrp;
       product.mrp_price == null ?  mrp='' : product.mrp_price > product.price ? mrp='Rs.'+product.mrp_price.toString()+'/-':mrp='';
       return mrp;
  }

}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sendesk/src/cart/cart_page.dart';
import 'package:sendesk/src/products/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;
  ProductDetailsPage({@required this.product});

  WebViewController _webViewController;
  String filePath = '';
  String description;
  @override
  Widget build(BuildContext context) {
    // final cart = Provider.of<Cart>(context);
    /*** IMAGE CAROUSEL ***/
    Widget image_carousel = new Container(
      height: 200.0,
      child: new Carousel(
        boxFit: BoxFit.fill,
        images: [
          product.image == null? Image.asset('assets/sensible_logo.jpeg'): Image.network(product.image),
          product.image == null? Image.asset('assets/sensible_logo.jpeg'): Image.network(product.image),
          product.image == null? Image.asset('assets/sensible_logo.jpeg'): Image.network(product.image),
        ],
        autoplay: false,
        indicatorBgPadding: 8.0,
        dotSize: 7.0,
        dotColor: Colors.blueGrey,
        dotBgColor: Colors.transparent,
        dotIncreasedColor: Colors.green,
      ),
    );

    return Scaffold(
        appBar: AppBar(
          title: Text('Product Details'),
          centerTitle: true,
          actions: <Widget>[
            Stack(
              alignment: Alignment.topRight,
              children:<Widget>[
                IconButton(
              //iconSize: 35,
              padding: const EdgeInsets.all(15),
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                        builder: (BuildContext context) => CartPage()));
                // Navigator.pushNamed(context,  'CartPage()');
              },
            ),
            new CircleAvatar(radius:10.0,
            backgroundColor:Colors.red,
            child: new Text("0",style:new TextStyle(color:Colors.white,fontSize: 12.0)),)
              ]
            ),
            
          ],
        ),
        body: new ListView(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.height / 91,
              vertical: MediaQuery.of(context).size.height / 85),
          children: <Widget>[
            image_carousel,
            Container(
              alignment: Alignment.topCenter,
              child: new Column(mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new ListTile(
                    title: new Text(product.name,
                        style: new TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize:29.0)), //, fontSize: MediaQuery.of(context).size.width/30)),
                    /*** PRODUCT PRICE,DISCOUNT ***/
                    subtitle: new RichText(
                      text: new TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                              text: "\u20b9 ${product.price}/-\t",
                              style: new TextStyle(color: Colors.black,fontSize: 22.0,fontWeight: FontWeight.bold)),
                          TextSpan(text: '\t\t\t\t'),
                          TextSpan( text: _widgetMrpPrice(),
                                    style: new TextStyle( color: const Color(0xff546e7a), decoration: TextDecoration.lineThrough)),
                          TextSpan(text: '\t\t\t'),
                          TextSpan( text: _widgetDiscount(),
                                    style: TextStyle(color: const Color(0xffffffff),backgroundColor: Color(0xff00c853)),),
                        ],
                      ),
                    ),
                  ),
                  Divider(color: Colors.blueGrey,thickness: 1,),
                ],
              ),
            ),

            /*** PRODUCT DESCRIPTION ***/
              if(product.description != null)
                 Text(' \u2022 Highlights :',style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold,color:Colors.black),),
                   _widgetHighlights(),
                   //Divider(color: Colors.black),
              
            /*** WEBVIEW FOR PRODUCT DETAILS***/
            loadWebView(),
          ],
        ),
        
        /*** BOTTOM NAVIGATOR FOR 'ADD TO CART' & 'BUY NOW' ***/
        bottomNavigationBar: new SizedBox(
          height: 58,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                fit: FlexFit.tight,
                flex: 2,
                child: RaisedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute( builder: (BuildContext context) => CartPage()));
                  },
                  //color: Colors.deepOrangeAccent,
                  color: Colors.redAccent,
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon( Icons.list, color: Colors.white,),
                      SizedBox(width: 1.0,),
                      Text( "Buy Now", style: TextStyle(color: Colors.white), ),
                    ],
                  )),
                ),
              ),
              Flexible(
                flex: 2,
                child: RaisedButton(
                  onPressed: () {
                    //double price = product.price;
                    //  cart.addItem(Item(product.id, product.name, "category",price, 1.0, 0));
                    Fluttertoast.showToast( msg: "Item added into cart",toastLength: Toast.LENGTH_SHORT); },
                  color: Colors.grey,
                  child: Center(
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon( Icons.shopping_cart,color: Colors.white, ),
                      SizedBox( width: 1.0, ),
                      Text( "Add To Cart", style: TextStyle(color: Colors.white),),
                    ],
                  )),
                ),
              ),
            ],
          ),
        ));
  }
String _widgetMrpPrice(){
      String mrp;
        product.mrp_price == null ?  mrp='' : product.mrp_price > product.price ? mrp='Rs.'+product.mrp_price.toString()+'/-' : mrp='';
   return mrp;
  }
  
  String _widgetDiscount(){
      String discount;
       product.mrp_price == null?  discount='':  product.mrp_price > product.price ? discount=(((product.mrp_price-product.price)*100)/product.mrp_price).toString()+'% OFF' : discount=''; 
       return discount;
  }
  Widget _widgetHighlights(){
      //String description;
       return Text( product.description == null?  description='':   description='\n\t\t'+product.description); 

      }
   
  /* ** LOAD WEBVIEW ** */
  Widget loadWebView() {
    switch (product.code) {
      case 1:
        filePath = 'assets/webview/POS_TT.html';
        break;
      case 2:
        filePath = 'assets/webview/POS_307.html';
        break;
      case 3:
        filePath = 'assets/webview/POS_Magic.html';
        break;
      case 4:
        filePath = 'assets/webview/ViewSonic_MONITOR.html';
        break;
      case 8:
        filePath = 'assets/webview/POS_Printer.html';
        break;
      case 11:
        filePath = 'assets/webview/TSC_TE244_Barcode_lable.html';
        break;
      /*case 12: filePath= 'assets/webview/Pos_TT.html';break;
      case 13: filePath= 'assets/webview/TT_Eco.html';break;
      case 14: filePath= 'assets/webview/Pos_TT.html';break;
      case 15: filePath= 'assets/webview/TT_Eco.html';break;*/

    }
    return Container(
      height: 1120,
      child: WebView(
        initialUrl: '',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _webViewController = webViewController;
          _loadHtmlFromAssets();
        },
      ),
    );
  }

  _loadHtmlFromAssets() async {
    
    String fileHtmlContents = await rootBundle.loadString(filePath);
    _webViewController.loadUrl(Uri.dataFromString(fileHtmlContents,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
  
}

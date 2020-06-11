import 'dart:developer';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kulinaapp/src/models/cart.dart';
import 'package:kulinaapp/src/pages/ProductPage.dart';

import 'models/product.dart';

class ProductList extends StatelessWidget{
  List<Product> products;
  List<Cart> cartItem;
  String date;
  ProductList({Key key,this.products,this.cartItem,this.date}) : super(key:key);


  addToCart(product){
    Cart cart = Cart(date: date,product: product);
    cartItem.add(cart);
  }

  @override
  Widget build(BuildContext context) {
    ProductPageState state = context.findAncestorStateOfType<ProductPageState>();
    return Expanded(
      flex: 1,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75
        ),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: products.length,
        itemBuilder: (context, index){
          return Container(
            child: Column(
              children: <Widget>[
                Container(
                  width: 260,
                  height: 160,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(products[index].image_url),
                          fit: BoxFit.fill
                      )
                  ),
                ),
                Container(
                  width: 260,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 16,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          products[index].rating.toStringAsFixed(2),
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          products[index].name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'by ' + products[index].brand_name,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          products[index].name,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text (
                              'Rp. ' + products[index].price.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              ' termasuk ongkir',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                OutlineButton(
                  child: Text(
                      'Tambahkan ke keranjang'
                  ),
                  onPressed: (){
                    state.setState(() {
                      addToCart(products[index]);
                      print(cartItem);
                    });
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

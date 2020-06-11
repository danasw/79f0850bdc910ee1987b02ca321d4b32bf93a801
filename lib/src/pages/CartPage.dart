import 'dart:collection';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kulinaapp/src/models/cart.dart';

class CartPage extends StatefulWidget {
  List<Cart> cart = [];

  CartPage({Key key, this.cart}) : super(key: key);

  @override
  CartPageState createState() => CartPageState();
}

class CartPageState extends State<CartPage> {
  int _itemCount = 0;
  Map filterCart;
  List<String> key = [];
  List uniqueKey;


  void add() {
    setState(() {
      _itemCount++;
    });
  }

  void minus() {
    setState(() {
      if (_itemCount != 0) _itemCount--;
    });
  }

  getKey(){
    widget.cart.forEach((element) {key.add(element.date);});
    uniqueKey = key.toSet().toList();
    print(uniqueKey);
  }


  filterByDate(){
    filterCart = widget.cart.groupBy((n) => n.date);
  }

  @override
  Widget build(BuildContext context) {
    filterByDate();
    getKey();

    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text("Review Pesanan"),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(shrinkWrap: true, itemCount: filterCart.length,itemBuilder: (context,i){
          return Column(
            children: <Widget>[
              Container(
                child: Text(
                  filterCart[uniqueKey[i]][0].date,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              ListView.builder(physics: ClampingScrollPhysics(), shrinkWrap: true, itemCount: filterCart[uniqueKey[i]].length, itemBuilder: (context,index){
                return Column(
                  children: <Widget>[
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 260,
                              height: 200,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          filterCart[uniqueKey[i]][index].product.image_url),
                                      fit: BoxFit.fill)),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Container(
                              width: 260,
                              height: 200,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      filterCart[uniqueKey[i]][index].product.name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      filterCart[uniqueKey[i]][index].product.brand_name,
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.black87),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Rp. ' + filterCart[uniqueKey[i]][index].product.price.toString(),
                                      style:
                                      TextStyle(fontSize: 14, color: Colors.grey),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      SizedBox(
                                        width: 20,
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.remove),
                                        onPressed: minus,
                                      ),
                                      Text(_itemCount.toString()),
                                      IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: add,
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () {
                                          setState(() {
                                            _itemCount = 0;
                                          });
                                        },
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },),
            ],
          );
        }),
      ),
    );
  }
}

extension Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
      <K, List<E>>{},
          (Map<K, List<E>> map, E element) =>
      map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));
}


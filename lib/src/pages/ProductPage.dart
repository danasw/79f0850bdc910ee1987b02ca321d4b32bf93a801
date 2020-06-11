
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:calendar_strip/calendar_strip.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:kulinaapp/src/models/cart.dart';
import 'dart:async';
import 'dart:convert';
import 'package:kulinaapp/src/models/product.dart';
import 'package:kulinaapp/src/pages/CartPage.dart';

import '../ProductList.dart';



List<Product> parseProduct(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Product>((json) => Product.fromJson(json)).toList();
}

Future<List<Product>> fetchProduct(http.Client client) async {
  final response = await client.get('https://kulina-recruitment.herokuapp.com/products');
  return compute(parseProduct, response.body);
}

class ProductPage extends StatefulWidget {
  @override
  ProductPageState createState() => ProductPageState();
}

class ProductPageState extends State<ProductPage> {
  int page = 0;
  String dropDownValue = 'Kulina';
  String formattedDate = DateFormat.yMMMMEEEEd().format(DateTime.now()).toString();
  List<Cart> cartItem = [];

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(Duration(days: 55));
  DateTime selectedDate = DateTime.now();

  onSelect(data) {
    setState(() {
      formattedDate = DateFormat.yMMMMEEEEd().format(data).toString();
    });
  }

  totalHarga(){
    int sum = cartItem.map((e) => e.product.price).fold(0, (a, b) => a+b);
    return sum;
  }

  dateTileBuilder(date, selectedDate, rowIndex, dayName, isDateMarked, isDateOutOfRange) {
    bool isSelectedDate = date.compareTo(selectedDate) == 0;
    Color fontColor = isDateOutOfRange ? Colors.black26 : Colors.black87;
    TextStyle normalStyle = TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: fontColor);
    TextStyle selectedStyle = TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Colors.black87);
    TextStyle dayNameStyle = TextStyle(fontSize: 14.5, color: fontColor);
    List<Widget> _children = [
      Text(dayName, style: dayNameStyle),
      Text(date.day.toString(), style: !isSelectedDate ? normalStyle : selectedStyle),
    ];

    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 8, left: 5, right: 5, bottom: 5),
      decoration: BoxDecoration(
        color: !isSelectedDate ? Colors.transparent : Colors.white70,
        borderRadius: BorderRadius.all(Radius.circular(60)),
      ),
      child: Column(
        children: _children,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        elevation: 0.3,
        backgroundColor: Colors.red,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Alamat Pengiriman',
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.start,
            ),
            DropdownButton<String>(
              dropdownColor: Colors.redAccent,
              value: dropDownValue,
              isDense: true,
              onChanged: (String newValue) {
                setState(() {
                  dropDownValue = newValue;
                });
              },
              items: <String>['Kulina', 'Kul', 'Ina', 'Yogyakarta']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value,
                  style: TextStyle(
                    color: Colors.white
                  ),),
                );
              }).toList(),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.navigate_before),
          tooltip: 'Back',
          onPressed: () {

          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.navigate_next),
            tooltip: 'Next page',
            onPressed: () {

            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(16.0, 0.0, 8.0, 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: Colors.white),
              child: CalendarStrip(
                startDate: startDate,
                endDate: endDate,
                onDateSelected: onSelect,
                dateTileBuilder: dateTileBuilder,
                iconColor: Colors.black87,
                addSwipeGesture: true,
                containerDecoration: BoxDecoration(color: Colors.black12),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
              child: Text(
                formattedDate,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Roboto'
                ),
              ),
            ),
            FutureBuilder<List<Product>>(
              future: fetchProduct(http.Client()),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                return snapshot.hasData
                    ? ProductList(products: snapshot.data, cartItem: cartItem, date: formattedDate,)
                    : Center(child: CircularProgressIndicator());
              }
            )
          ],
        ),
      ),
      floatingActionButton: Visibility(
        child: Container(
          width: 400,
          height: 100,
          child: FittedBox(
            child: FloatingActionButton.extended(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
                  onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartPage(cart: cartItem,)
                      )
                  );
                },
                label: Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              cartItem.length.toString(),
                              style: TextStyle(
                                  fontSize: 10
                              ),
                            ),
                            Text(
                                ' | '
                            ),
                            Text(
                              'Rp. ' + totalHarga().toString(),
                              style: TextStyle(
                                  fontSize: 10
                              ),
                            )
                          ],
                        ),
                        Text(
                          'Termasuk Ongkir',
                          style: TextStyle(
                              fontSize: 8
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 60,
                    ),
                    Text (
                        'Checkout >',
                    )
                  ],
                )
            ),
          ),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:kulinaapp/src/pages/ProductPage.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: ThemeData(fontFamily: 'Roboto', hintColor: Color(0xFFd0cece)),
  home: ProductPage(),
));
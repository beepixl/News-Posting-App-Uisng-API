import 'package:flutter/material.dart';

import 'Home.dart';
import 'Login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News Post',
      // theme: ,
    //  home: Login(),
    );
  }
}
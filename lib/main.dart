import 'package:flutter/material.dart';
import 'package:quotes_app/common/quote_widget.dart';
import 'package:quotes_app/screens/quotes_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: Scaffold(
        body: QuotesScreen(
        ),
      ),
    );
  }
}

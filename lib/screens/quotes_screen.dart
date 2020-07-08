import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quotes_app/common/quote_widget.dart';
import 'package:random_color/random_color.dart';

class QuotesScreen extends StatelessWidget {
  final Firestore _firestore = Firestore(); 
  final RandomColor _randomColor = RandomColor();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: _firestore.collection('quotes').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return _LoadingIndicator();
            return PageView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  final document = snapshot.data.documents[index];
                  return QuoteWidget(
                      backgroundColor: _randomColor.randomColor(
                          colorBrightness: ColorBrightness.dark),
                      quote: document['quote'],
                      author: document['author']);
                });
          }),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator(
    ));
  }
}

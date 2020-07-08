import 'package:flutter/material.dart';
import 'package:quotes_app/common/style.dart';

class QuoteWidget extends StatelessWidget {
  final Color backgroundColor;
  final String quote, author;

  const QuoteWidget({Key key, this.backgroundColor, this.author, this.quote})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        color: backgroundColor,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.asset('assets/quote_left.png', width: 80, height: 80,color: Colors.white.withOpacity(0.4) ),
            Expanded(
                child: Center(
              child: Text(
                quote,
                style: Style.headline,
              ),
            )),
            Center(
              child: Text(
                author,
                style: Style.subhead,
              ),
            ),
          ],
        ));
  }
}

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quotes_app/common/quote_widget.dart';
import 'package:random_color/random_color.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

String directoryName = 'Quotes';

class QuotesScreen extends StatefulWidget {
  static final globalKey = GlobalKey();

  @override
  _QuotesScreenState createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {
  final Firestore _firestore = Firestore();
  final RandomColor _randomColor = RandomColor();
  int quoteIndex = 01;
  Uint8List pngBytes;
  final Permission _permission = Permission.WriteExternalStorage;

  Future<void> _capturePng() async {
    RenderRepaintBoundary boundary =
        QuotesScreen.globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    setState(() {
      pngBytes = byteData.buffer.asUint8List();
    });
  }

  void _saveQuote() async {
    await _capturePng();

    if (!(await checkPermission())) await requestPermission();
    // Use plugin [path_provider] to export image to storage
    Directory directory = await getExternalStorageDirectory();
    String path = directory.path;
    print(path);
    await Directory('$path/$directoryName').create(recursive: true);
    File('$path/$directoryName/${fileName()}.png').writeAsBytesSync(pngBytes);
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('Quote saved $path/$directoryName/${fileName()}.png'),
    ));
  }

  Future<void> _shareQuote() async {
    await _capturePng();
    await WcFlutterShare.share(
        sharePopupTitle: 'Share Amazing Quote',
        subject:
            'See this amazing quote. I am using Quotes App by Om Prakash. Check the app source code at https://github.com/om8007/flutter-quotes-app',
        text:
            'See this amazing quote. I am using Quotes App by Om Prakash. Check the app source code at https://github.com/om8007/flutter-quotes-app',
        fileName: '${fileName()}.png',
        mimeType: 'image/png',
        bytesOfFile: pngBytes);
  }

  requestPermission() async {
    PermissionStatus result =
        await SimplePermissions.requestPermission(_permission);
    return result;
  }

  checkPermission() async {
    bool result = await SimplePermissions.checkPermission(_permission);
    return result;
  }

  getPermissionStatus() async {
    final result = await SimplePermissions.getPermissionStatus(_permission);
    print("permission status is " + result.toString());
  }

  String fileName() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('j-m-s');
    final String formatted = formatter.format(now);
    return 'Quote_$formatted';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          StreamBuilder(
              stream: _firestore.collection('quotes').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return _LoadingIndicator();
                return RepaintBoundary(
                  key: QuotesScreen.globalKey,
                  child: PageView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        final document = snapshot.data.documents[index];
                        return QuoteWidget(
                            backgroundColor: _randomColor.randomColor(
                                colorBrightness: ColorBrightness.dark),
                            quote: document['quote'],
                            author: document['author']);
                      }),
                );
              }),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  CircleAvatar(
                    radius: 25.0,
                    backgroundColor: Colors.white24,
                    child: IconButton(
                      color: Colors.black54,
                      icon: Icon(
                        Icons.share,
                      ),
                      onPressed: () {
                        _shareQuote();
                      },
                    ),
                  ),
                  SizedBox(height: 12),
                  CircleAvatar(
                    radius: 25.0,
                    backgroundColor: Colors.white24,
                    child: IconButton(
                      color: Colors.black54,
                      icon: Icon(
                        Icons.save,
                      ),
                      onPressed: () {
                        _saveQuote();
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}

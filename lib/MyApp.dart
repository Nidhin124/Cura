import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyApp extends StatelessWidget {
  final String chatbotUrl = 'https://www.chatbase.co/chatbot-iframe/2PNH7-kaAEFihAbe1kJ-w';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatbot App',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Chatbot'),
        ),
        body: WebView(
          initialUrl: chatbotUrl,
          javascriptMode: JavascriptMode.unrestricted,
          gestureNavigationEnabled: true,
        ),
      ),
    );
  }
}
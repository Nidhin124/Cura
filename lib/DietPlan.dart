import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DietPlan extends StatelessWidget {
  final String chatbotUrl = 'https://app-diet.streamlit.app/';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diet Plan',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Diet Plan'),
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
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Nutrition extends StatelessWidget {
  final String chatbotUrl = 'https://meal-nutrition-analysis.streamlit.app/';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nutritional Analysis',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Nutritional Analysis'),
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
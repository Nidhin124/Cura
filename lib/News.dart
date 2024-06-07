import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyApp3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      home: NewsPage(),
    );
  }
}

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final String newsFeedUrl = "http://feeds.bbci.co.uk/news/world/asia/india/rss.xml";
  final int numArticles = 5;
  List<RssItem> articles = [];

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    try {
      final response = await http.get(Uri.parse(newsFeedUrl));
      if (response.statusCode == 200) {
        final feed = RssFeed.parse(response.body);
        setState(() {
          articles = feed.items?.take(numArticles)?.toList() ?? [];
        });
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      print('Error fetching news: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Latest News'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/newsold.jpg'), // Replace 'assets/background_image.jpg' with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          itemCount: articles.length,
          itemBuilder: (context, index) {
            final article = articles[index];
            return Card(
              child: ListTile(
                title: Text(article.title ?? ''),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NewsWebView(article.link ?? ''),
                  ));
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class NewsWebView extends StatelessWidget {
  final String url;

  NewsWebView(this.url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Details'),
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cura/memorygame.dart';
import 'package:video_player/video_player.dart';
import 'package:cura/sudoku.dart';


class AppPage extends StatefulWidget {
  @override
  _AppPageState createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  late VideoPlayerController _controller;
  late VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
      'assets/gamesbg.mp4', // Path to your background video
    )..initialize().then((_) {
      _controller.play();
      _controller.setLooping(true);
      setState(() {});
    });

    _listener = () {
      if (_controller.value.isInitialized) {
        setState(() {});
      }
    };

    _controller.addListener(_listener);
  }

  @override
  void dispose() {
    _controller.removeListener(_listener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            ),
            Container(
              color: Colors.black.withOpacity(0.5), // Adjust the opacity as needed
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularButtonWithImage(
                      imagePath: "assets/gameface.png",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Mind(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    CircularButtonWithImage(
                      imagePath: "assets/sudokulogo.png",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyApp(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CircularButtonWithImage extends StatelessWidget {
  final String imagePath;
  final VoidCallback? onPressed;

  const CircularButtonWithImage({
    required this.imagePath,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.7), // Button background color with opacity
        ),
        child: Padding(
          padding: const EdgeInsets.all(7.0),
          child: ClipOval(
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

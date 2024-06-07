import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cura/MyApp.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cura/DietPlan.dart';
import 'package:cura/Nutrition.dart';
import 'package:video_player/video_player.dart';
import 'package:cura/gamepage.dart';
import 'package:cura/News.dart';
import 'dart:async';


void main() {
  runApp(MyApps());
}
class MyApps extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(), // Display splash screen initially
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // After 3 seconds, navigate to the login page
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon image
            Image.asset(
              'assets/logosplash.png',
              width: 150,
              height: 150,
            ),
            SizedBox(height: 20),
            // Text at the bottom
            Text(
              'Cura',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: LoginForm(),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/background_video.mp4')
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        setState(() {});
      });
    _loadPrefs(); // Load SharedPreferences
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _emergencyNumber = 'tel:+918301930773'; // Default emergency number

  // Initialize SharedPreferences instance
  late SharedPreferences _prefs;

  void _loadPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _emergencyNumber =
          _prefs.getString('emergencyNumber') ?? _emergencyNumber;
    });
  }

  // Method to save emergency number to SharedPreferences
  void _saveEmergencyNumber(String newNumber) async {
    await _prefs.setString('emergencyNumber', newNumber);
    setState(() {
      _emergencyNumber = newNumber;
    });
  }

  // Login function
  void _login() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Sample dataset of username-password pairs (replace with your actual data)
    Map<String, String> users = {
      'safal1': 'safalsakeer1',
      'shilpa2': 'shilpabalaji2',
      'nidhin3': 'nidhinbiju3',
    };

    // Check if the entered username exists in the dataset
    if (users.containsKey(username)) {
      // If it does, check if the password matches
      if (users[username] == password) {
        // Navigate to the home page if authentication is successful
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        return; // Exit the function after navigation
      }
    }

    // If username or password is incorrect, show error message
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Invalid username or password.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Send SOS function
  void _sendSOS() async {
    String url = 'tel:$_emergencyNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Change Emergency Number function
  void _changeEmergencyNumber() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newNumber = _emergencyNumber;
        return AlertDialog(
          title: Text('Change Emergency Number'),
          content: TextField(
            onChanged: (value) {
              newNumber = value;
            },
            decoration: InputDecoration(hintText: 'Enter new emergency number'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _saveEmergencyNumber(newNumber); // Save new number
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Video or Container
        SizedBox.expand(
          child: _controller.value.isInitialized
              ? AspectRatio(
            aspectRatio: 19.5/ 9, // Updated aspect ratio (16:9 for example)
            child: VideoPlayer(_controller),
          )
              : Container(),
        ),
        // Logo Image at Top Left with Text
        Positioned(
          top: 10.0,
          left: 10.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipOval(
                child: Image.asset(
                  'assets/logo.png',
                  width: 100,
                  height: 100,
                ),
              ),
              SizedBox(width: 5.0), // Adjust spacing as needed
              Text(
                'Cura', // Your text here
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        // Login UI
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Username TextField
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(fontSize: 24,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.5),
                ),
              ),
              SizedBox(height: 16.0),
              // Password TextField
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(fontSize: 24,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.5),
                ),
                obscureText: true,
              ),
              SizedBox(height: 16.0),
              // Login Button
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor:  Colors
                      .lightBlue[100], // Change the background color here
                  // Other button properties like padding, shape, etc. can be modified here
                ),
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.black87),
                ),
              ),
              SizedBox(height: 10.0),
              // Change Emergency Number & SOS Button Row
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _changeEmergencyNumber,
                    child: Text(
                      'Change Emergency Number',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: _sendSOS,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      child: Icon(
                        Icons.phone,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class HomePage extends StatelessWidget {
  final List<Widget> pages = [
    HomePageContent(),
    MyApp3(), // Add your new page widget here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemCount: pages.length,
        itemBuilder: (BuildContext context, int index) {
          return pages[index];
        },
      ),
    );
  }
}

class HomePageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/eld_1.png'), // Your background image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: Text(
              'Home',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 90), // Space for the top image
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Circle buttons with icons
                            CircleIconButton(
                              icon: 'assets/dietplan.png',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DietPlan(),
                                  ),
                                );
                              },
                              label: 'Diet Plan',
                            ),
                            SizedBox(height: 30),
                            CircleIconButton(
                              icon: 'assets/nutrition.png',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Nutrition(),
                                  ),
                                );
                              },
                              label: 'Nutrition Analysis',
                            ),
                            SizedBox(height: 30),
                            CircleIconButton(
                              icon: 'assets/chat.png',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyApp(),
                                  ),
                                );
                              },
                              label: 'Chat Bot',
                            ),
                            SizedBox(height: 30),
                            // Mind Game Button
                            CircleIconButton(
                              icon: 'assets/pokemon.jpg',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AppPage(),
                                  ),
                                );
                              },
                              label: 'Games',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 50), // Space between buttons and text sections
                      Text(
                        'ABOUT',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Welcome to Cura - Where Wellness Meets Wisdom.At Cura, we believe in embracing the journey of aging with grace, joy, and vitality. Our mission is to provide you with the tools, knowledge, and support you need, to live your best life at every stage. Join us on this transformative journey towards vibrant health and radiant living. Together,lets unlock the secrets to longevity and embrace each day with vitality and purpose.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        'OUR TEAM',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Nidhin Biju\nSafal Sakeer Hussain\nShilpa Balaji',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 200, // Adjust this value as needed
            right: -100 ,
            child: Container(
              width: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              padding: EdgeInsets.symmetric(vertical: 100),
              child: RotatedBox(
                quarterTurns: 3,
                child:Text(
                  'Latest News',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CircleIconButton extends StatelessWidget {
  final String icon;
  final VoidCallback onPressed;
  final String label;

  const CircleIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 175,
          height: 175,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(icon),
              fit: BoxFit.cover,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(50),
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          label,
          style: TextStyle(fontSize: 30, color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

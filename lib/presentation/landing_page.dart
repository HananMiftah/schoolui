import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:schoolui/presentation/school/school_homepage.dart';

import 'signin/signin.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool isFirstLaunch = true;

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? seen = prefs.getBool('isFirstLaunch') ?? true;

    if (!seen) {
      // Not first launch, navigate to HomePage directly
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SignInPage()),
      );
    } else {
      // First launch, set the flag to false
      await prefs.setBool('isFirstLaunch', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://png.pngtree.com/background/20221028/original/pngtree-free-back-to-school-background-stationery-elements-picture-image_1931565.jpg',
              height: 200,
              width: 300,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            const Text(
              'Welcome to Our School App!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to home page and replace the current page
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const SignInPage()),
                );
              },
              child: const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}

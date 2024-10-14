import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:schoolui/presentation/signin/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String? userEmail;
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  void _loadUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('email') ?? 'No Email';
    });
  }

  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove('email');
    await prefs.remove('accessToken');

    // Redirect to Sign-In Page
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => SignInPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: const Color.fromARGB(
                  255, 216, 131, 2), // Add your theme color
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage:
                      AssetImage('assets/profile.jpg'), // Profile picture
                ),
                SizedBox(height: 10),
                Text(
                  "Your Name",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  userEmail ?? "No Email",
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Profile"),
            onTap: () {
              // Navigate to profile page
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Settings"),
            onTap: () {
              // Navigate to settings page
            },
          ),
          SwitchListTile(
            activeColor: Colors.orange,
            secondary: Icon(Icons.dark_mode),
            title: Text("Dark Mode"),
            value: isDarkMode,
            onChanged: (bool value) {
              setState(() {
                isDarkMode = value; // Toggle dark mode state
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: () {
              _logout(context);
            },
          ),
        ],
      ),
    );
  }
}

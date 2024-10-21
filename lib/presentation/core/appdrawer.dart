import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:schoolui/bloc/school_homepage/school/school_homepage_bloc.dart';
import 'package:schoolui/bloc/school_homepage/school/school_homepage_state.dart';
import 'package:schoolui/presentation/core/themeProvider.dart';
import 'package:schoolui/presentation/signin/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bloc/school_homepage/school/school_homepage_event.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
    // context.read<HomeBloc>()..add(LoadSchool());
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
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SignInPage()));
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 216, 131, 2), // Add your theme color
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage:
                      AssetImage('assets/profile.jpg'), // Profile picture
                ),
                const SizedBox(height: 10),
                // BlocBuilder<HomeBloc, SchoolHomepageState>(
                //   builder: (context, state) {
                //     if ( state is SchoolLoaded){
                //       return Text(
                //       state.school.name,
                //       style: const TextStyle(
                //         color: Colors.white,
                //         fontSize: 18,
                //         fontWeight: FontWeight.bold,
                //       ),
                //     );
                //     }
                // return const
                Text(
                  "Your Name",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  // );
                  // },
                ),
                Text(
                  userEmail ?? "No Email",
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Profile"),
            onTap: () {
              // Navigate to profile page
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () {
              // Navigate to settings page
            },
          ),
          SwitchListTile(
            activeColor: Colors.orange,
            secondary: const Icon(Icons.dark_mode),
            title: const Text("Dark Mode"),
            value: isDarkMode,
            onChanged: (bool value) {
              themeProvider.toggleTheme(value); // Toggle theme mode
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () {
              _logout(context);
            },
          ),
        ],
      ),
    );
  }
}

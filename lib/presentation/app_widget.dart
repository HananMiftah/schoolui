import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schoolui/presentation/signin/signin.dart';

import '../bloc/signin/auth_bloc.dart';
import '../data_provider/auth_provider/auth_provider.dart';
import '../repository/auth_repository/auth_repository.dart';
import 'landing_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(AuthRepository(AuthProvider())),
        ),
      ],
      child: MaterialApp(
        title: 'School App',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: {
          '/': (context) => LandingPage(),
          '/login': (context) => SignInPage(),
          // '/home-parent': (context) => HomePageParent(),
          // '/home-admin': (context) => HomePageAdmin(),
        },
      ),
    );
  }
}

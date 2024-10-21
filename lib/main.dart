import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/app_widget.dart';
import 'presentation/core/themeProvider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child:  MyApp(),
    ),
  );
}

import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

/// Main Entry Point
/// 
/// This is where the Flutter application starts. The main() function is called
/// when the app launches, and it runs the MyApp widget.
void main() {
  runApp(const MyApp());
}

/// MyApp Widget
/// 
/// This is the root widget of the application. It sets up the overall theme
/// and navigation structure. In this simple app, we just have one screen.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // App title (shown in browser tab)
      title: 'Resource Browser',
      
      // Remove the debug banner in the top-right corner
      debugShowCheckedModeBanner: false,
      
      // App theme configuration
      theme: ThemeData(
        // Primary color used throughout the app
        primarySwatch: Colors.blue,
        
        // Use Material 3 design
        useMaterial3: true,
        
        // Font family for the entire app
        fontFamily: 'Roboto',
      ),
      
      // The home screen of the app
      home: const HomeScreen(),
    );
  }
}

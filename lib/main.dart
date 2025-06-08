import 'package:bicicleta_segura/screens/auth_intro_screen.dart';
import 'package:bicicleta_segura/screens/auth_screen.dart';
import 'package:bicicleta_segura/screens/home_screen.dart';
import 'package:bicicleta_segura/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bicicleta Segura',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/auth': (context) => const AuthIntroScreen(),
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const AuthScreen(),
        '/register': (context) => const RegisterScreen(),
      },
    );
  }
}

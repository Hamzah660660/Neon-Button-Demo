 
import 'package:flutter/material.dart';
import 'package:neon_button_demo/neon_button.dart';
 
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Neon Button Demo',
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(    
          //COMMENT
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Neon Button Demo',
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 70),
              NeonButton(
                text: 'Click me',
                neonColor: const Color(0xFF00FFFF),
                sparkCount: 50,
                width: 260,
                height: 75,
                fontSize: 22,
                onPressed: () {
                 },
              ),
              const SizedBox(height: 70),
              NeonButton(
                text: 'Click me',
                neonColor: const Color.fromARGB(255, 255, 0, 191),
                sparkCount: 50,
                width: 260,
                height: 75,
                fontSize: 22,
                onPressed: () {
                 },
              ),              const SizedBox(height: 70),
//new //new
              NeonButton(
                text: 'Click ME',
                neonColor: const Color.fromARGB(255, 179, 255, 0),
                sparkCount: 50,
                width: 260,
                height: 75,
                fontSize: 22,
                onPressed: () {
                 },
              ),
            ],
          ),
        ),
      ),
    );
  }
} 
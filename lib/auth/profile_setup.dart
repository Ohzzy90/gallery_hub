import 'package:flutter/material.dart';

class ProfileSetup extends StatelessWidget {
  const ProfileSetup({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Profile Setup'),
        ),
        body: const Center(
          child: Text('Welcome to the Profile Setup Page!'),
        ),
      ),
    );
  }
}
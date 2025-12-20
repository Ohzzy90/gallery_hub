import 'package:flutter/material.dart';
import 'package:gallery_hub/auth/auth_server.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Home Page'),
        ),
        body: Center(
          child: Text("Welcome, ${authServer.value.currentUser?.displayName ?? 'User'}!"),
        ),
      )
    );
  }
}
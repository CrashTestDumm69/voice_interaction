import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voice_interaction/routing/routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.menu_rounded)
          )
        ],
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.deepPurple.withValues(alpha: 0.15),
              Colors.black
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          )
        ),
        child: Image.asset(
          "assets/centelon_logo.png"
        )
      ),
    );
  }
}
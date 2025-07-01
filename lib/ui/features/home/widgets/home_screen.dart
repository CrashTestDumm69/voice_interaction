import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voice_interaction/routing/routes.dart';

import 'package:voice_interaction/ui/features/home/widgets/menu_tile_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Define list of MenuTileWidgets
    final List<MenuTileWidget> menuItems = [
      MenuTileWidget(icon: Icons.mic_rounded, label: "Interaction", color: Colors.red, onTap: () => context.push(Routes.interaction)),
      MenuTileWidget(icon: Icons.search, label: "Playlists", color: Colors.deepPurple, onTap: () => context.push(Routes.mediaPlayer)),
      MenuTileWidget(icon: Icons.settings, label: "Tile 3", color: Colors.yellow.shade700, onTap: () {}),
      MenuTileWidget(icon: Icons.info, label: "Tile 4", color: Colors.blueAccent, onTap: () {}),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black,
              Colors.deepPurple.withAlpha(50),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset("assets/centelon_logo.png"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: menuItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 100,
                  mainAxisSpacing: 20,
                  childAspectRatio: 2.5,
                ),
                itemBuilder: (context, index) => menuItems[index],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
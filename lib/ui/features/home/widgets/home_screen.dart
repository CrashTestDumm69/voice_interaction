import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import 'package:voice_interaction/routing/routes.dart';
import 'package:voice_interaction/ui/features/home/widgets/menu_tile_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<MenuTileWidget> menuItems = [
      MenuTileWidget(icon: Icons.mic_rounded, label: "Interaction", color: Colors.red, onTap: () => context.push(Routes.interaction)),
      MenuTileWidget(icon: Icons.search, label: "Playlists", color: Colors.green, onTap: () => context.go(Routes.mediaPlayer)),
      MenuTileWidget(icon: Icons.settings, label: "Settings", color: Colors.yellow.shade700, onTap: () => context.push(Routes.settings)),
      MenuTileWidget(icon: Icons.info, label: "Stop detection", color: Colors.blueAccent, onTap: () {}),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: Lottie.asset(
              "assets/background.json",
              fit: BoxFit.fill,
            )
          ),
          Positioned.fill(
            child: Container(
              color: Colors.transparent,
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
          ),
        ],
      ),
    );
  }
}
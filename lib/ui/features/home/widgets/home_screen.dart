import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:voice_interaction/routing/routes.dart';

import 'package:voice_interaction/ui/features/home/widgets/menu_tile_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Define list of MenuTileWidgets
    final List<MenuTileWidget> menuItems = [
      MenuTileWidget(icon: Icons.mic_rounded, label: "Interaction", onTap: () => context.push(Routes.interaction)),
      MenuTileWidget(icon: Icons.search, label: "Tile 2", onTap: () {}),
      MenuTileWidget(icon: Icons.settings, label: "Tile 3", onTap: () {}),
      MenuTileWidget(icon: Icons.info, label: "Tile 4", onTap: () {}),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.deepPurple.withAlpha(50),
              Colors.black,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // AppBar that scrolls with content
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.menu_rounded, color: Colors.white)
                )
              ],
            ),
            const Gap(16),
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
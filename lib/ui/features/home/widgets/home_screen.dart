import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:voice_interaction/data/services/face_detector_service.dart';
import 'package:voice_interaction/routing/routes.dart';
import 'package:voice_interaction/ui/features/home/widgets/menu_tile_widget.dart';
import 'package:voice_interaction/utils/injection_container.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Define list of MenuTileWidgets
    final List<MenuTileWidget> menuItems = [
      MenuTileWidget(icon: Icons.mic_rounded, label: "Interaction", color: Colors.red, onTap: () => context.push(Routes.interaction)),
      MenuTileWidget(icon: Icons.search, label: "Playlists", color: Colors.deepPurple, onTap: () => context.push(Routes.mediaPlayer)),
      MenuTileWidget(icon: Icons.settings, label: "Start detection", color: Colors.yellow.shade700, onTap: () => sl<FaceDetectorService>().startDetection()),
      MenuTileWidget(icon: Icons.info, label: "Stop detection", color: Colors.blueAccent, onTap: () => sl<FaceDetectorService>().stopDetection()),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            color: Colors.transparent,
            height: double.maxFinite,
            width: double.maxFinite,
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
        ],
      ),
    );
  }
}
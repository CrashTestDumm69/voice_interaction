import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';
import 'package:voice_interaction/ui/interaction/view_model/interaction_view_model.dart';
import 'package:voice_interaction/ui/interaction/widgets/package_details_widget.dart';

class InteractionScreen extends ConsumerStatefulWidget {
  const InteractionScreen({super.key});

  @override
  ConsumerState<InteractionScreen> createState() => _InteractionScreenState();
}

class _InteractionScreenState extends ConsumerState<InteractionScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(voiceInteractionProvider.notifier).init());
  }

  @override
  void dispose() {
    ref.read(voiceInteractionProvider.notifier).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = ref.read(voiceInteractionProvider.notifier);
    final packageDetails = ref.watch(voiceInteractionProvider.select((_) => model.packageDetails));

    return Stack(
      children: [
        GestureDetector(
          onDoubleTap: model.unmuteMic,
          child: RiveAnimation.asset(
            'assets/face.riv',
            fit: BoxFit.contain,
            onInit: model.onRiveInit,
          ),
        ),
        if (packageDetails != null)
          PackageDetailsWidget(
            data: packageDetails,
            onDone: model.clearPackageDetails,
          ),
      ],
    );
  }
}

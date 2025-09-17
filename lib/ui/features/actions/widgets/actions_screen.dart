import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voice_interaction/ui/features/actions/view_model/actions_view_model.dart';

class ActionsScreen extends StatelessWidget {
  final ActionsViewModel viewModel;
  const ActionsScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActionsViewModel, ActionsState>(
      bloc: viewModel,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Actions'),
          ),
          body: state.error == null ? ListView.builder(
            itemCount: state.actions.length,
            itemBuilder: (context, index) {
              final action = state.actions[index];
              return ListTile(
                title: Text(action), // Adjust based on your action model
                onTap: () {
                  viewModel.add(SendArmAction(action: action));
                },
              );
            },
          ) : Center(
            child: Text('Error: ${state.error}'),
          ),
        );
      },
    );
  }
}
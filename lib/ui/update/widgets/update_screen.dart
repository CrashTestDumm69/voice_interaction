import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:voice_interaction/ui/update/view_model/update_view_model.dart';
import 'package:voice_interaction/utils/injection_container.dart';

class UpdateScreen extends StatelessWidget {
  final UpdateViewModel _viewModel;

  const UpdateScreen({super.key, required UpdateViewModel viewModel})
      : _viewModel = viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Update Available'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: BlocBuilder<UpdateViewModel, UpdateState>(
        bloc: sl<UpdateViewModel>(),
        builder: (context, state) {
          if (state is UpdateInProgress) {
            return Center(
              child: SizedBox(
                height: 100,
                width: 500,
                child: Column(
                  children: [
                    CircularProgressIndicator(
                      color: Colors.deepPurple,
                      backgroundColor: Colors.deepPurpleAccent.shade100,
                      value: (state.progress/state.total)
                    ),
                    const Gap(10),
                    Text("${(state.progress / 1000000).toStringAsFixed(2)} Mb / ${(state.total / 1000000).toStringAsFixed(2)} Mb")
                  ],
                ),
              ),
            );
          }

          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.system_update, size: 64, color: Colors.deepPurple),
                      const SizedBox(height: 16),
                      const Text(
                        'A new update is available!',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'To ensure the best experience, please update to the latest version.',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _viewModel.add(PerformUpdate());
                          },
                          icon: const Icon(Icons.download),
                          label: const Text('Update Now'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

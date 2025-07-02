import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:voice_interaction/ui/features/update/view_model/update_view_model.dart';

class UpdateScreen extends StatelessWidget {
  final UpdateViewModel _viewModel;
  const UpdateScreen({super.key, required UpdateViewModel viewModel})
      : _viewModel = viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: BlocBuilder<UpdateViewModel, UpdateState>(
        bloc: _viewModel,
        builder: (context, state) {
          return Stack(
            children: [
              Center(
                child: Card(
                  elevation: 8,
                  color: Colors.grey.shade800,
                  child: Container(
                    width: 500,
                    height: 350,
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: _getIconColor(state),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Icon(
                            _getIcon(state),
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          _getTitle(state),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        _buildStateContent(context, state),
                        _buildActionButton(context, state),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 5,
                left: 5,
                child: BackButton(color: Colors.white)
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildStateContent(BuildContext context, UpdateState state) {
    switch (state.runtimeType) {
      case const (UpdateInitial):
        return const Text(
          'Check if a newer version is available',
          style: TextStyle(fontSize: 16, color: Colors.grey),
          textAlign: TextAlign.center,
        );

      case const (UpdateAvailable):
        final availableState = state as UpdateAvailable;
        return Column(
          children: [
            Text(
              'Version ${availableState.version} is available!',
              style: const TextStyle(fontSize: 16, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const Gap(8),
            const Text(
              'Update now to get the latest features and improvements',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        );

      case const (UpdateNotAvailable):
        return Column(
          children: [
            Text(
              'Already up to date',
              style: TextStyle(fontSize: 16, color: Colors.green.shade800),
              textAlign: TextAlign.center,
            ),
            const Gap(8),
            const Text(
              "You're running the latest version",
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        );

      case const (UpdateInProgress):
        final progressState = state as UpdateInProgress;
        return Column(
          children: [
            Text(
              progressState.percent == null ? "Updating..." : "${(progressState.percent! * 100).toStringAsFixed(1)}%",
              style: const TextStyle(fontSize: 16, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const Gap(16),
            LinearProgressIndicator(
              value: progressState.percent,
              backgroundColor: Colors.grey.shade700,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade900),
            ),
            const Gap(8),
            const Text(
              "Please don't close the app during update",
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        );

      case const (UpdateCompleted):
        return Column(
          children: [
            Text(
              'Update downloaded successfully!',
              style: TextStyle(fontSize: 16, color: Colors.green.shade800),
              textAlign: TextAlign.center,
            ),
            const Gap(8),
            Text(
              'Update is ready to install',
              style: const TextStyle(fontSize: 14, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const Gap(8),
            const Text(
              'The app will restart after installation',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        );

      case const (UpdateFailed):
        final failedState = state as UpdateFailed;
        return Column(
          children: [
            Text(
              'Update failed',
              style: TextStyle(fontSize: 16, color: Colors.red.shade900),
              textAlign: TextAlign.center,
            ),
            const Gap(8),
            Text(
              failedState.message,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const Gap(8),
            const Text(
              'Please try again later',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        );

      case const (CheckingForUpdate):
        return Column(
          children: const [
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
            Gap(16),
            Text(
              'Checking for updates...',
              style: TextStyle(fontSize: 16, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildActionButton(BuildContext context, UpdateState state) {
    switch (state.runtimeType) {
      case const (UpdateInitial):
        return SizedBox(
          width: double.maxFinite,
          child: ElevatedButton(
            onPressed: () => _viewModel.add(CheckForUpdate()),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade900,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Check for Update'),
          ),
        );

      case const (UpdateAvailable):
        return SizedBox(
          width: double.maxFinite,
          child: ElevatedButton(
            onPressed: () => _viewModel.add(PerformUpdate()),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade800,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Update Now'),
          ),
        );

      case const (UpdateNotAvailable):
        return SizedBox(
          width: double.maxFinite,
          child: OutlinedButton(
            onPressed: () => _viewModel.add(CheckForUpdate()),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Check Again'),
          ),
        );

      case const (UpdateCompleted):
        return SizedBox(
          width: double.maxFinite,
          child: ElevatedButton(
            onPressed: () => _viewModel.add(InstallUpdate()),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Install Now'),
          ),
        );

      case const (UpdateFailed):
        return SizedBox(
          width: double.maxFinite,
          child: ElevatedButton(
            onPressed: () => _viewModel.add(CheckForUpdate()),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Try Again'),
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  IconData _getIcon(UpdateState state) {
    switch (state.runtimeType) {
      case const (UpdateInitial):
        return Icons.system_update;
      case const (UpdateAvailable):
        return Icons.download;
      case const (UpdateNotAvailable):
        return Icons.check_circle;
      case const (UpdateInProgress):
        return Icons.downloading;
      case const (UpdateCompleted):
        return Icons.install_desktop;
      case const (UpdateFailed):
        return Icons.error;
      case const (CheckingForUpdate):
        return Icons.search;
      default:
        return Icons.system_update;
    }
  }

  Color _getIconColor(UpdateState state) {
    switch (state.runtimeType) {
      case const (UpdateInitial):
        return Colors.blue.shade900;
      case const (UpdateAvailable):
        return Colors.green.shade800;
      case const (UpdateNotAvailable):
        return Colors.green.shade800;
      case const (UpdateInProgress):
        return Colors.orange.shade700;
      case const (UpdateCompleted):
        return Colors.green.shade700;
      case const (UpdateFailed):
        return Colors.red.shade800;
      case const (CheckingForUpdate):
        return Colors.grey;
      default:
        return Colors.blue.shade900;
    }
  }

  String _getTitle(UpdateState state) {
    switch (state.runtimeType) {
      case const (UpdateInitial):
        return 'App Update';
      case const (UpdateAvailable):
        return 'Update Available';
      case const (UpdateNotAvailable):
        return 'Up to Date';
      case const (UpdateInProgress):
        return 'Updating';
      case const (UpdateCompleted):
        return 'Ready to Install';
      case const (UpdateFailed):
        return 'Update Failed';
      case const (CheckingForUpdate):
        return 'Checking';
      default:
        return 'App Update';
    }
  }
}
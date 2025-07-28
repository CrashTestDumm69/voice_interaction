import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voice_interaction/ui/features/settings/view_model/settings_view_model.dart';

class SettingsScreen extends StatefulWidget {
  final SettingsViewModel viewModel;

  const SettingsScreen({
    super.key,
    required this.viewModel,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? _selectedLocation;
  bool _isLoading = true;
  String? _errorMessage;

  static const List<String> availableLocations = ["Home", "Media Player"];

  @override
  void initState() {
    super.initState();
    widget.viewModel.add(LoadSettings());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: BlocListener<SettingsViewModel, SettingsState>(
        bloc: widget.viewModel,
        listener: (context, state) {
          if (state is SettingsLoading) {
            setState(() {
              _isLoading = true;
              _errorMessage = null;
            });
          } else if (state is SettingsLoaded) {
            setState(() {
              _isLoading = false;
              _selectedLocation = state.initialLocation;
              _errorMessage = null;
            });
          } else if (state is SettingsError) {
            setState(() {
              _isLoading = false;
              _errorMessage = state.message;
            });
          }
        },
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(child: Text(_errorMessage!))
                : _buildSettingsForm(),
      ),
    );
  }

  Widget _buildSettingsForm() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Initial Location'),
        DropdownButtonFormField<String>(
          value: _selectedLocation,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          items: availableLocations.map((location) {
            return DropdownMenuItem(
              value: location,
              child: Text(location),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedLocation = value;
              });
              widget.viewModel.add(ChangeInitialLocation(value));
            }
          },
        ),
      ],
    );
  }
}

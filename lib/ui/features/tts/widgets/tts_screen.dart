import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:voice_interaction/ui/features/tts/view_model/tts_view_model.dart';

class TtsScreen extends StatefulWidget {
  final TtsViewModel viewModel;

  const TtsScreen({super.key, required this.viewModel});

  @override
  State<TtsScreen> createState() => _TtsScreenState();
}

class _TtsScreenState extends State<TtsScreen> {
  List<File> _speechFiles = [];
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    widget.viewModel.add(LoadTtsFiles());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("TTS Audio Files")),
      body: BlocListener<TtsViewModel, TtsState>(
        bloc: widget.viewModel,
        listener: (context, state) {
          if (state is TtsLoading) {
            setState(() {
              _loading = true;
              _error = null;
            });
          } else if (state is TtsLoaded) {
            setState(() {
              _speechFiles = state.speechFiles;
              _loading = false;
              _error = null;
            });
          } else if (state is TtsError) {
            setState(() {
              _loading = false;
              _error = state.message;
            });
          }
        },
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(child: Text(_error!))
                : _speechFiles.isEmpty
                    ? const Center(child: Text("No audio files available."))
                    : ListView.builder(
                        itemCount: _speechFiles.length,
                        itemBuilder: (context, index) {
                          final file = _speechFiles[index];
                          return ListTile(
                            title: Text(file.path.split('/').last),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                widget.viewModel.add(DeleteSpeech(file));
                              },
                            ),
                          );
                        },
                      ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.viewModel.add(
            GenerateSpeech(text: "Hello from Cento!", name: "Cento"),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

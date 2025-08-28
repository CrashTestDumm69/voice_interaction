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

  Future<void> _showGenerateSpeechDialog(BuildContext context) async {
    final TextEditingController textController = TextEditingController();
    final TextEditingController nameController = TextEditingController();

    InputDecoration pillDecoration = const InputDecoration.collapsed(hintText: '');

    Widget pillField(String label, TextEditingController controller) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: TextStyle(fontSize: 20)),
            const SizedBox(height: 6),
            TextField(
              controller: controller,
              decoration: pillDecoration,
              maxLines: 1,
            ),
          ],
        ),
      );
    }

    Widget multiLineField(String label, TextEditingController controller) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: TextStyle(fontSize: 20)),
            const SizedBox(height: 6),
            TextField(
              controller: controller,
              maxLines: 4,
              minLines: 4,
              decoration: pillDecoration,
            ),
          ],
        ),
      );
    }

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Generate Speech"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                pillField("Name", nameController),
                const SizedBox(height: 12),
                multiLineField("Text", textController),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final text = textController.text.trim();
                final name = nameController.text.trim();
                if (text.isNotEmpty && name.isNotEmpty) {
                  Navigator.of(context).pop({"text": text, "name": name});
                }
              },
              child: const Text("Generate"),
            ),
          ],
        );
      },
    );

    if (result != null) {
      widget.viewModel.add(
        GenerateSpeech(text: result["text"]!, name: result["name"]!),
      );
    }
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
        onPressed: () => _showGenerateSpeechDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

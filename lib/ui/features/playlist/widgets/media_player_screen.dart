import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:voice_interaction/ui/features/playlist/view_model/media_player_view_model.dart';

class MediaPlayerScreen extends StatefulWidget {
  final MediaPlayerViewModel viewModel;
  const MediaPlayerScreen({super.key, required this.viewModel});

  @override
  State<MediaPlayerScreen> createState() => _MediaPlayerScreenState();
}

class _MediaPlayerScreenState extends State<MediaPlayerScreen> {
  VideoPlayerController? _videoController;
  AudioPlayer? _audioPlayer;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.viewModel.add(CheckForUpdate());
    });
    super.initState();
  }

  @override
  void dispose() {
    _cleanupControllers();
    super.dispose();
  }

  void _cleanupControllers() {
    _videoController?.dispose();
    _videoController = null;
    _audioPlayer?.dispose();
    _audioPlayer = null;
    _isVideoInitialized = false;
  }

  Future<void> _setupVideoPlayer(String filePath) async {
    _cleanupControllers();
    
    _videoController = VideoPlayerController.file(File(filePath));
    await _videoController!.initialize();
    
    setState(() {
      _isVideoInitialized = true;
    });
    
    _videoController!.play();
    
    _videoController!.addListener(() {
      if (_videoController!.value.position >= _videoController!.value.duration) {
        widget.viewModel.add(PlayNextMedia());
      }
    });
  }

  Future<void> _setupAudioPlayer(String filePath) async {
    _cleanupControllers();
    
    _audioPlayer = AudioPlayer();
    await _audioPlayer!.play(DeviceFileSource(filePath));
    
    // Listen for audio completion
    _audioPlayer!.onPlayerComplete.listen((_) {
      widget.viewModel.add(PlayNextMedia());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocConsumer<MediaPlayerViewModel, MediaPlayerState>(
        bloc: widget.viewModel,
        listener: (context, state) async {
          if (state is PlayVideo) {
            await _setupVideoPlayer(state.filePath);
          } else if (state is PlayAudio) {
            await _setupAudioPlayer(state.filePath);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              _buildMainContent(state),
              
              if (state is MediaDownloading || state is MediaDelay)
                _buildStatusOverlay(state),
              
              if (state is MediaError)
                _buildErrorOverlay(state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMainContent(MediaPlayerState state) {
    if (state is PlayVideo && _isVideoInitialized && _videoController != null) {
      return SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _videoController!.value.size.width,
            height: _videoController!.value.size.height,
            child: VideoPlayer(_videoController!),
          ),
        ),
      );
    } else if (state is PlayAudio) {
      if (state.hasImage && state.backgroundImagePath.isNotEmpty) {
        return SizedBox.expand(
          child: Image.file(
            File(state.backgroundImagePath),
            fit: BoxFit.cover,
          ),
        );
      } else {
        // Show red screen for audio without image
        return Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.red,
        );
      }
    }
    
    // Default black screen
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black,
    );
  }

  Widget _buildStatusOverlay(MediaPlayerState state) {
    String message;
    if (state is MediaDownloading) {
      message = 'Downloading updates...';
    } else if (state is MediaDelay) {
      message = 'Loading...';
    } else {
      message = 'Please wait...';
    }

    return Container(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorOverlay(MediaError state) {
    return Container(
      color: Colors.black87,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                'Error',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                state.message,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  widget.viewModel.add(PlayNextMedia());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
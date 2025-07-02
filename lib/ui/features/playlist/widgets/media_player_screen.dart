import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
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
  int _currentIndex = 0;
  Timer? _playbackTimer;

  @override
  void initState() {
    super.initState();
    widget.viewModel.add(StartUpdateCheck());
  }

  @override
  void dispose() {
    // Stop update check when view is disposed
    widget.viewModel.add(StopUpdateCheck());
    _disposeControllers();
    _playbackTimer?.cancel();
    super.dispose();
  }

  void _disposeControllers() {
    _videoController?.dispose();
    _videoController = null;
    _audioPlayer?.dispose();
    _audioPlayer = null;
  }

  Future<void> _playMediaFile(MediaFile file) async {
    _disposeControllers();

    if (file.delay > 0) {
      await Future.delayed(Duration(seconds: file.delay));
    }

    if (file.isVideo) {
      await _playVideo(file);
    } else if (file.isAudio) {
      await _playAudio(file);
    }
  }

  Future<void> _playVideo(MediaFile file) async {
    _videoController = VideoPlayerController.file(File(file.filePath));
    await _videoController!.initialize();
    setState(() {});
    await _videoController!.play();

    _videoController!.addListener(() {
      if (_videoController!.value.position >= _videoController!.value.duration) {
        _playNextFile();
      }
    });
  }

  Future<void> _playAudio(MediaFile file) async {
    _audioPlayer = AudioPlayer();
    await _audioPlayer!.play(DeviceFileSource(file.filePath));
    
    // Listen for audio completion
    _audioPlayer!.onPlayerComplete.listen((_) {
      _playNextFile();
    });
  }

  void _playNextFile() {
    final state = widget.viewModel.state;
    if (state is MediaReady) {
      _currentIndex = (_currentIndex + 1) % state.files.length;
      _playMediaFile(state.files[_currentIndex]);
    }
  }

  Widget _buildVideoPlayer() {
    if (_videoController == null || !_videoController!.value.isInitialized) {
      return Container(
        color: Colors.black,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    
    return Center(
      child: AspectRatio(
        aspectRatio: _videoController!.value.aspectRatio,
        child: VideoPlayer(_videoController!),
      ),
    );
  }

  Widget _buildAudioPlayer(MediaFile file) {
    if (file.hasImage && file.imageFilePath != null) {
      return Image.file(
        File(file.imageFilePath!),
        fit: BoxFit.cover,
        width: double.maxFinite,
        height: double.maxFinite,
      );
    } else {
      return Container(
        color: Colors.grey.shade900,
        width: double.maxFinite,
        height: double.maxFinite,
        child: Icon(Icons.volume_up_outlined, size: 80, color: Colors.grey.shade600),
      );
    }
  }

  Widget _buildMediaContent(List<MediaFile> files) {
    if (files.isEmpty) return Container();
    
    final currentFile = files[_currentIndex];
    
    if (currentFile.isVideo) {
      return _buildVideoPlayer();
    } else {
      return _buildAudioPlayer(currentFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocConsumer<MediaPlayerViewModel, MediaPlayerState>(
        bloc: widget.viewModel,
        listenWhen: (previous, current) => previous.runtimeType != current.runtimeType,
        listener: (context, state) {
          if (state is MediaReady) {
            _currentIndex = 0;
            _playMediaFile(state.files[0]);
          } else {
            _disposeControllers();
          }
        },
        builder: (context, state) {
          if (state is MediaPlayerInitial) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          
          if (state is MediaDownloading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colors.white,
                    value: state.percent == null ? null : (state.percent! / 100),
                  ),
                  Gap(16),
                  Text(
                    '${state.curFile} / ${state.totalFiles}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    '${state.percent != null ? state.percent!.round() : 0}%',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  )
                ],
              ),
            );
          }
          
          if (state is MediaError) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                ),
              ),
            );
          }
          
          if (state is MediaReady) {
            return _buildMediaContent(state.files);
          }
          
          return Container();
        },
      ),
    );
  }
}
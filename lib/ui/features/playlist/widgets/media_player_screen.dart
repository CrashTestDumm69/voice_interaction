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
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioPlayer _announcementPlayer = AudioPlayer();
  int _currentPlaylistIndex = 0;
  int _currentAnnouncementIndex = 0;
  Timer? _playlistTimer;
  Timer? _announcementTimer;
  bool _isPlayingAnnouncement = false;

  @override
  void initState() {
    super.initState();
    widget.viewModel.add(StartUpdateCheck());
    
    _announcementPlayer.onPlayerComplete.listen((_) {
      _unmuteCurrentMedia();
      _playNextAnnouncement();
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      _playNextFile();
    });
  }

  @override
  void dispose() {
    // Stop update check when view is disposed
    widget.viewModel.add(StopUpdateCheck());
    _disposeControllers();
    _playlistTimer?.cancel();
    _announcementTimer?.cancel();
    super.dispose();
  }

  void _disposeControllers() {
    _videoController?.dispose();
    _videoController = null;
    _audioPlayer.release();
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
    await _audioPlayer.setSource(DeviceFileSource(file.filePath));
    await _audioPlayer.resume();
  }

  void _playNextFile() {
    final state = widget.viewModel.state;
    if (state is MediaReady) {
      _currentPlaylistIndex = (_currentPlaylistIndex + 1) % state.playlistFiles.length;
      _playMediaFile(state.playlistFiles[_currentPlaylistIndex]);
    }
  }

  Future<void> _playAnnouncement(MediaFile announcementFile) async {
    setState(() {
      _isPlayingAnnouncement = true;
    });

    await _muteCurrentMedia();

    if (announcementFile.delay > 0) {
      await Future.delayed(Duration(seconds: announcementFile.delay));
    }

    await _announcementPlayer.setSource(DeviceFileSource(announcementFile.filePath));
    await _announcementPlayer.resume();
  }

  Future<void> _muteCurrentMedia() async {
    if (_videoController != null && _videoController!.value.isInitialized) {
      await _videoController!.setVolume(0.2);
    }
    await _audioPlayer.setVolume(0.2);
  }

  Future<void> _unmuteCurrentMedia() async {
    if (_videoController != null && _videoController!.value.isInitialized) {
      await _videoController!.setVolume(1.0);
    }
    
    await _audioPlayer.setVolume(1.0);
  }

  void _playNextAnnouncement() async {
    _announcementPlayer.release();

    setState(() {
      _isPlayingAnnouncement = false;
    });

    final state = widget.viewModel.state;
    if (state is MediaReady && state.announcementFiles != null) {
      _currentAnnouncementIndex = (_currentAnnouncementIndex + 1) % state.announcementFiles!.length;
      _playAnnouncement(state.announcementFiles![_currentAnnouncementIndex]);
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

  Widget _buildAnnouncementOverlay() {
    return Container(
      color: Colors.black.withValues(alpha: 0.8),
      width: double.maxFinite,
      height: double.maxFinite,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.campaign,
              size: 100,
              color: Colors.white,
            ),
            Gap(20),
            Text(
              'Announcement',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaContent(List<MediaFile> files) {
    if (files.isEmpty) return Container();
    
    final currentFile = files[_currentPlaylistIndex];
    
    Widget mainContent;
    if (currentFile.isVideo) {
      mainContent = _buildVideoPlayer();
    } else {
      mainContent = _buildAudioPlayer(currentFile);
    }

    if (_isPlayingAnnouncement) {
      return Stack(
        children: [
          mainContent,
          _buildAnnouncementOverlay(),
        ],
      );
    }

    return mainContent;
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
            _currentPlaylistIndex = 0;
            _playMediaFile(state.playlistFiles[_currentPlaylistIndex]);
            
            if (state.announcementFiles != null && state.announcementFiles!.isNotEmpty) {
              _currentAnnouncementIndex = 0;
              _playAnnouncement(state.announcementFiles![_currentAnnouncementIndex]);
            }
          } else {
            _disposeControllers();
            _announcementTimer?.cancel();
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
            return _buildMediaContent(state.playlistFiles);
          }
          
          return Container();
        },
      ),
    );
  }
}
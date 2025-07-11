import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import 'package:voice_interaction/ui/features/playlist/view_model/media_player_view_model.dart';

class MediaPlayerScreen extends StatefulWidget {
  final MediaPlayerViewModel viewModel;

  const MediaPlayerScreen({super.key, required this.viewModel});

  @override
  State<MediaPlayerScreen> createState() => _MediaPlayerScreenState();
}

class _MediaPlayerScreenState extends State<MediaPlayerScreen> {
  late final _playlistPlayer = Player();
  late final _announcementPlayer = Player();
  late final _videoController = VideoController(_playlistPlayer, configuration: VideoControllerConfiguration(enableHardwareAcceleration: false));
  
  List<MediaFile> _playlistFiles = [];
  List<MediaFile> _announcementFiles = [];

  Timer? _announcementTimer;
  bool _isPlayingAnnouncement = false;
  StreamSubscription? _playlistSubscription;
  StreamSubscription? _announcementSubscription;

  // UI state variables
  bool _isLoading = true;
  bool _isDownloading = false;
  String? _errorMessage;
  int _downloadCurFile = 0;
  int _downloadTotalFiles = 0;
  double? _downloadPercent;

  int _currentPlaylistIndex = 0;
  int _currentAnnouncementIndex = 0;

  @override
  void initState() {
    super.initState();

    _playlistSubscription = _playlistPlayer.stream.completed.listen((completed) {
      if (completed) {
        setState(() {
          _currentPlaylistIndex = (_currentPlaylistIndex + 1) % _playlistFiles.length;
        });
        _playNextPlaylistFile();
      }
    });

    _announcementSubscription = _announcementPlayer.stream.completed.listen((completed) async {
      if (completed) {
        setState(() {
          _isPlayingAnnouncement = false;
          _currentAnnouncementIndex = (_currentAnnouncementIndex + 1) % _announcementFiles.length;
        });
        await _increasePlaylistVolume();
        _playNextAnnouncementFile();
      }
    });

    widget.viewModel.add(StartUpdateCheck());
  }

  @override
  void dispose() {
    widget.viewModel.add(StopUpdateCheck());
    _announcementTimer?.cancel();
    _playlistSubscription?.cancel();
    _announcementSubscription?.cancel();
    _playlistPlayer.dispose();
    _announcementPlayer.dispose();
    super.dispose();
  }

  Future<void> _setupPlaylist() async {
    if (_playlistFiles.isEmpty) return;
    
    try {
      final medias = _playlistFiles.map((file) => Media(file.filePath)).toList();
      await _playlistPlayer.open(Playlist(medias), play: false);

      _playNextPlaylistFile();
    } catch (e) {
      debugPrint('Error setting up playlist: $e');
    }
  }

  Future<void> _setupAnnouncementPlaylist() async {
    if (_announcementFiles.isEmpty) return;
    
    try {
      final medias = _announcementFiles.map((file) => Media(file.filePath)).toList();
      await _announcementPlayer.open(Playlist(medias), play: false);
      
      _playNextAnnouncementFile();
    } catch (e) {
      debugPrint('Error setting up announcement playlist: $e');
    }
  }

  Future<void> _playNextPlaylistFile() async {    
    final currentFile = _playlistFiles[_currentPlaylistIndex];
    
    
    if (currentFile.delay > 0) {
      await Future.delayed(Duration(seconds: currentFile.delay));
    }
    
    try {
      await _playlistPlayer.jump(_currentPlaylistIndex);
      debugPrint('Playing playlist file: ${currentFile.filePath}');
    } catch (e) {
      debugPrint('Error playing playlist file: $e');
    }
  }

  Future<void> _playNextAnnouncementFile() async {
    final currentFile = _announcementFiles[_currentAnnouncementIndex];
    

    if (currentFile.delay > 0) {
      await Future.delayed(Duration(seconds: currentFile.delay));
    }

    setState(() {
      _isPlayingAnnouncement = true;
    });

    await _lowerPlaylistVolume();

    try {
      await _announcementPlayer.jump(_currentAnnouncementIndex);
      debugPrint('Playing announcement: ${currentFile.filePath}');
    } catch (e) {
      debugPrint('Error playing announcement: $e');
    }
  }

  Future<void> _lowerPlaylistVolume() async {
    const duration = Duration(milliseconds: 500);
    const double from = 100.0;
    const double to = 60.0;
    const int steps = 10;

    final stepDuration = duration ~/ steps;
    final stepSize = (from - to) / steps;

    for (int i = 0; i < steps; i++) {
      final vol = from - stepSize * i;
      try {
        await _playlistPlayer.setVolume(vol.clamp(60.0, 100.0));
      } catch (_) {}
      await Future.delayed(stepDuration);
    }

    try {
      await _playlistPlayer.setVolume(to);
    } catch (_) {}
  }

  Future<void> _increasePlaylistVolume() async {
    const duration = Duration(milliseconds: 500);
    const double from = 60.0;
    const double to = 100.0;
    const int steps = 10;

    final stepDuration = duration ~/ steps;
    final stepSize = (to - from) / steps;

    for (int i = 0; i < steps; i++) {
      final vol = from + stepSize * i;
      try {
        await _playlistPlayer.setVolume(vol.clamp(60.0, 100.0));
      } catch (_) {}
      await Future.delayed(stepDuration);
    }

    try {
      await _playlistPlayer.setVolume(to);
    } catch (_) {}
  }

  Widget _buildVideoPlayer() {
    return Center(
      child: Video(
        controller: _videoController,
        controls: NoVideoControls,
      ),
    );
  }

  Widget _buildAudioPlayer() {
    final file = _playlistFiles[_currentPlaylistIndex];
    debugPrint('Building audio player for: ${file.hasImage} - ${file.imageFilePath}');
    if (file.hasImage && file.imageFilePath != null) {
      return Image.file(
        File(file.imageFilePath!),
        fit: BoxFit.cover,
        width: double.maxFinite,
        height: double.maxFinite,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Error loading image: $error');
          return _buildDefaultAudioDisplay();
        },
      );
    } else {
      return _buildDefaultAudioDisplay();
    }
  }

  Widget _buildDefaultAudioDisplay() {
    return Container(
      color: Colors.grey.shade900,
      width: double.maxFinite,
      height: double.maxFinite,
      child: Icon(
        Icons.volume_up_outlined, 
        size: 80, 
        color: Colors.grey.shade600
      ),
    );
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

  Widget _buildMediaContent() {
    if (_playlistFiles.isEmpty) {
      return Center(
        child: Text(
          'No media files available',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      );
    }
    
    final currentFile = _playlistFiles[_currentPlaylistIndex];
    
    Widget mainContent;
    if (currentFile.isVideo) {
      mainContent = _buildVideoPlayer();
    } else {
      mainContent = _buildAudioPlayer();
    }

    return Stack(
      children: [
        mainContent,
        IgnorePointer(
          ignoring: _isPlayingAnnouncement,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: _isPlayingAnnouncement ? 1.0 : 0.0,
            child: _buildAnnouncementOverlay()
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentState() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }
    
    if (_isDownloading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Colors.white,
              value: _downloadPercent == null ? null : (_downloadPercent! / 100),
            ),
            Gap(16),
            Text(
              '$_downloadCurFile / $_downloadTotalFiles',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            Text(
              '${_downloadPercent != null ? _downloadPercent!.round() : 0}%',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            )
          ],
        ),
      );
    }
    
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 64,
            ),
            Gap(16),
            Text(
              'Error: $_errorMessage',
              style: TextStyle(
                color: Colors.red,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    
    return _buildMediaContent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocListener<MediaPlayerViewModel, MediaPlayerState>(
        bloc: widget.viewModel,
        listener: (context, state) {
          if (state is MediaReady) {
            setState(() {
              _isLoading = false;
              _isDownloading = false;
              _errorMessage = null;
            
              _playlistFiles = state.playlistFiles;
              _announcementFiles = state.announcementFiles;
              
              _currentPlaylistIndex = 0;
              _currentAnnouncementIndex = 0;
            });

            if (_playlistFiles.isNotEmpty) {
              _setupPlaylist();
            }
            
            if (_announcementFiles.isNotEmpty) {
              _setupAnnouncementPlaylist();
            }
          } else if (state is MediaPlayerInitial) {
            setState(() {
              _isLoading = true;
              _isDownloading = false;
              _errorMessage = null;
            });
            
            // Stop all playback
            _playlistPlayer.stop();
            _announcementPlayer.stop();
            _announcementTimer?.cancel();
            setState(() {
              _isPlayingAnnouncement = false;
            });
          } else if (state is MediaDownloading) {
            setState(() {
              _isLoading = false;
              _isDownloading = true;
              _errorMessage = null;
              _downloadCurFile = state.curFile;
              _downloadTotalFiles = state.totalFiles;
              _downloadPercent = state.percent;
            });
          } else if (state is MediaError) {
            setState(() {
              _isLoading = false;
              _isDownloading = false;
              _errorMessage = state.message;
            });
            
            // Stop all playback on error
            _playlistPlayer.stop();
            _announcementPlayer.stop();
            _announcementTimer?.cancel();
            setState(() {
              _isPlayingAnnouncement = false;
            });
          }
        },
        child: _buildCurrentState(),
      ),
    );
  }
}
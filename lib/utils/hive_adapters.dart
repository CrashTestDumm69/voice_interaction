import 'package:hive_ce/hive.dart';

import 'package:voice_interaction/domain/models/playlist/playlist.dart';
import 'package:voice_interaction/domain/models/playlist/playlist_file.dart';
import 'package:voice_interaction/domain/models/settings/settings.dart';

@GenerateAdapters([
  AdapterSpec<Playlist>(),
  AdapterSpec<PlaylistFile>(),
  AdapterSpec<Settings>()
])

part 'hive_adapters.g.dart';
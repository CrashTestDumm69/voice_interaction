import 'package:hive_ce/hive.dart';

import 'package:voice_interaction/domain/models/playlist/playlist.dart';
import 'package:voice_interaction/domain/models/playlist/playlist_file.dart';

@GenerateAdapters([
  AdapterSpec<Playlist>(),
  AdapterSpec<PlaylistFile>()
])
part 'hive_adapters.g.dart';
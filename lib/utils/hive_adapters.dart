import 'package:hive_ce/hive.dart';

import 'package:voice_interaction/domain/models/playlist/playlist.dart';
import 'package:voice_interaction/domain/models/playlist/playlist_file.dart';
import 'package:voice_interaction/domain/models/playlist/playlist_type.dart';

@GenerateAdapters([AdapterSpec<Playlist>()])
part 'hive_adapters.g.dart';
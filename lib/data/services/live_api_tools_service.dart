import 'package:voice_interaction/config/live_api_tools.dart';
import 'package:voice_interaction/data/services/native_volume_handler_service.dart';
import 'package:voice_interaction/domain/models/live_api/live_api_tool.dart';
import 'package:voice_interaction/domain/models/live_api/live_api_tool_param.dart';

class LiveApiToolsService {
  final List<LiveApiTool> _tools = [];

  List<LiveApiTool> get tools => List.unmodifiable(_tools);

  final NativeVolumeHandlerService _volumeHandlerService;

  LiveApiToolsService({
    required NativeVolumeHandlerService volumeHandlerService
  }) : _volumeHandlerService = volumeHandlerService;

  LiveApiTool _loadVolumeSetTool() {
    final volumeParam = LiveApiToolParam(
      name: LiveApiTools.changeVolumeToolParamName,
      description: LiveApiTools.changeVolumeToolParamDescription,
      type: LiveApiToolParamType.number,
      minimum: 0,
      maximum: _volumeHandlerService.maxVolume,
      required: true,
    );

    final changeVolumeTool = LiveApiTool(
      name: LiveApiTools.changeVolumeToolName,
      description: LiveApiTools.changeVolumeToolDescription,
      parameters: List.filled(1, volumeParam),
    );

    return changeVolumeTool;
  }

  LiveApiTool _loadVolumeGetTool() {
    final getCurrentVolumeTool = LiveApiTool(
      name: LiveApiTools.getCurrentVolumeToolName,
      description: LiveApiTools.getCurrentVolumeToolDescription,
    );

    return getCurrentVolumeTool;
  }

  void loadTools() {
    final changeVolumeTool = _loadVolumeSetTool();
    final getCurrentVolumeTool = _loadVolumeGetTool();

    _tools.add(changeVolumeTool);
    _tools.add(getCurrentVolumeTool);
  }
}

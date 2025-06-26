import 'package:voice_interaction/config/realtime_api_tools.dart';
import 'package:voice_interaction/data/services/native_volume_handler_service.dart';
import 'package:voice_interaction/domain/models/realtime_api_tool/realtime_api_tool.dart';
import 'package:voice_interaction/domain/models/realtime_api_tool/realtime_api_tool_param.dart';

class RealtimeApiToolsService {
  final List<RealtimeApiTool> _tools = [];

  List<RealtimeApiTool> get tools => List.unmodifiable(_tools);

  final NativeVolumeHandlerService _volumeHandlerService;

  RealtimeApiToolsService({
    required NativeVolumeHandlerService volumeHandlerService
  }) : _volumeHandlerService = volumeHandlerService;

  RealtimeApiTool _loadVolumeSetTool() {
    final volumeParam = RealtimeApiToolParam(
      name: RealtimeApiTools.changeVolumeToolParamName,
      description: RealtimeApiTools.changeVolumeToolParamDescription,
      type: RealtimeApiToolParamType.number,
      minimum: 0,
      maximum: _volumeHandlerService.maxVolume,
      required: true,
    );

    final changeVolumeTool = RealtimeApiTool(
      name: RealtimeApiTools.changeVolumeToolName,
      description: RealtimeApiTools.changeVolumeToolDescription,
      parameters: List.filled(1, volumeParam),
    );

    return changeVolumeTool;
  }

  RealtimeApiTool _loadVolumeGetTool() {
    final getCurrentVolumeTool = RealtimeApiTool(
      name: RealtimeApiTools.getCurrentVolumeToolName,
      description: RealtimeApiTools.getCurrentVolumeToolDescription,
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

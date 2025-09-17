import 'package:roslibdart_new/core/core.dart';

class RosService {
  late final Ros _ros;
  late final Topic _armActionsSubscriber;
  late final Topic _batterySubscriber;
  late final Topic _speechPublisher;
  late final Topic _blockCodePublisher;
  late final Topic _armPublisher;

  void init(String url) {
    _ros = Ros(url: url);
    _ros.connect();
    _initTopics();
  }

  void _initTopics() {
    _armActionsSubscriber = Topic(name: "/c20000002/arm_actions", type: "std_msgs/String", ros: _ros);
    _batterySubscriber = Topic(name: "/c20000002/battery", type: "std_msgs/Float64", ros: _ros);
    _armPublisher = Topic(name: "/c20000002/arm_topic", type: "std_msgs/String", ros: _ros);
    _speechPublisher = Topic(name: "/c20000002/speech_control", type: "std_msgs/String", ros: _ros);
    _blockCodePublisher = Topic(name: "/c20000002/block_code", type: "std_msgs/String", ros: _ros);
  }

  void sendArmAction(String action) {
    final msg = {'data': action};
    _armPublisher.publish(msg);
  }

  void publishSpeechString(String message) {
    final msg = {'data': message};
    _speechPublisher.publish(msg);
  }

  void publishBlockCodeString(String message) {
    final msg = {'data': message};
    _blockCodePublisher.publish(msg);
  }

  void subscribeArmActionsString(void Function(String) onData) {
    _armActionsSubscriber.subscribe((message) async {
      if (message['data'] != null) {
        onData(message['data']);
      }
    });
  }

  void subscribeBatteryState(void Function(double) onData) {
    _batterySubscriber.subscribe((message) async {
      if (message['data'] != null) {
        onData(message['data']);
      }
    });
  }
}
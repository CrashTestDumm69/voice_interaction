package com.centelon.voice_interaction

import android.media.AudioManager
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "volume"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            val audioManager = getSystemService(AUDIO_SERVICE) as AudioManager

            when (call.method) {
                "setCallVolume" -> {
                    val level = call.argument<Int>("level") ?: 0
                    audioManager.setStreamVolume(
                        AudioManager.STREAM_VOICE_CALL,
                        level,
                        0
                    )
                    result.success(null)
                }

                "getCallVolume" -> {
                    val current = audioManager.getStreamVolume(AudioManager.STREAM_VOICE_CALL)
                    val max = audioManager.getStreamMaxVolume(AudioManager.STREAM_VOICE_CALL)
                    result.success(mapOf("current" to current, "max" to max))
                }

                else -> result.notImplemented()
            }
        }
    }
}

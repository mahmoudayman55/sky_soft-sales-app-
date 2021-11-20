package com.example.skysoft
import com.tekartik.sqflite.SqflitePlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.PluginRegistry

class MainActivity: FlutterActivity() {
    fun registerWith(registry: PluginRegistry) {
        com.tekartik.sqflite.SqflitePlugin.registerWith(
                registry.registrarFor("com.tekartik.sqflite.SqflitePlugin"))
    }
}
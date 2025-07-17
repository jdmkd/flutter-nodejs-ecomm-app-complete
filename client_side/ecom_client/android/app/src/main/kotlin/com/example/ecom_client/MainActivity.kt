package com.example.ecom_client

import android.content.ContentResolver
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "content_uri_file").setMethodCallHandler { call, result ->
            if (call.method == "copyContentUriToFile") {
                val uriStr = call.argument<String>("uri")
                val filePath = call.argument<String>("filePath")
                if (uriStr != null && filePath != null) {
                    try {
                        val uri = Uri.parse(uriStr)
                        val inputStream = contentResolver.openInputStream(uri)
                        val file = File(filePath)
                        val outputStream = FileOutputStream(file)
                        inputStream?.copyTo(outputStream)
                        inputStream?.close()
                        outputStream.close()
                        result.success(true)
                    } catch (e: Exception) {
                        result.success(false)
                    }
                } else {
                    result.success(false)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}

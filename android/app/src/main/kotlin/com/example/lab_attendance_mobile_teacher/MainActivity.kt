package com.example.lab_attendance_mobile_teacher

import android.os.Bundle
import io.flutter.plugin.common.MethodChannel
import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingService

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Create a notification channel for Android 8.0 (API level 26) or higher
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channelId = "lab_attendance_student_channel"
            val channelName = "Default Channel"
            val channelDescription = "This is the default notification channel"
            val importance = NotificationManager.IMPORTANCE_DEFAULT

            val channel = NotificationChannel(channelId, channelName, importance).apply {
                description = channelDescription
            }

            val notificationManager: NotificationManager =
                getSystemService(NotificationManager::class.java)
            notificationManager.createNotificationChannel(channel)
        }
    }    
    private val CHANNEL = "com.example.lab_attendance_mobile_student/lifecycle"

    override fun onDestroy() {
        super.onDestroy()
        // Panggil method channel untuk memberi tahu Flutter bahwa aplikasi akan ditutup
        flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
    MethodChannel(messenger, CHANNEL).invokeMethod("onAppClose", null)
    }
    }
}
package com.example.eldercare

import android.app.Notification
import android.app.Service
import android.content.Intent
import android.os.IBinder
import androidx.core.app.NotificationCompat

class AlarmService : Service() {
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val notification = NotificationCompat.Builder(this, "CHANNEL_ID")
            .setContentTitle("Alarm Service")
            .setContentText("Running...")
            .setSmallIcon(android.R.drawable.ic_dialog_alert) // Use a built-in Android icon
            .build()

        startForeground(1, notification)

        // Your service logic here

        return START_NOT_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }
}

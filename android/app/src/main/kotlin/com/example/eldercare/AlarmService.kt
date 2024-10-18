package com.example.eldercare

import android.app.AlarmManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.IBinder
import android.util.Log

class AlarmService : Service() {

    private val TAG = "AlarmService"

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    fun setAlarm(context: Context, alarmTimeInMillis: Long) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(context, AlarmReceiver::class.java)
        val pendingIntent = PendingIntent.getBroadcast(context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
        alarmManager.setExact(AlarmManager.RTC_WAKEUP, alarmTimeInMillis, pendingIntent)
        Log.d(TAG, "Alarm set for: $alarmTimeInMillis")
    }

    fun cancelAlarm(context: Context) {
        val intent = Intent(context, AlarmReceiver::class.java)
        val pendingIntent = PendingIntent.getBroadcast(context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        alarmManager.cancel(pendingIntent)
        Log.d(TAG, "Alarm cancelled")
    }
}

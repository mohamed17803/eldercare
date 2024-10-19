package com.example.eldercare

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import java.util.Calendar

class MainActivity : FlutterActivity() {

    private lateinit var alarmManagerHelper: AlarmManagerHelper

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Initialize AlarmManagerHelper
        alarmManagerHelper = AlarmManagerHelper(this)

        // Set an alarm for a specific time
        val calendar = Calendar.getInstance()
        calendar.set(Calendar.HOUR_OF_DAY, 8) // Set hour
        calendar.set(Calendar.MINUTE, 0) // Set minute

        // Set the alarm
        alarmManagerHelper.setAlarm(calendar, 1)
    }
}

package com.example.eldercare

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.widget.Toast

class AlarmReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        Toast.makeText(context, "Alarm Triggered!", Toast.LENGTH_LONG).show()

        // Play sound or vibrate
        // You can use MediaPlayer or Vibrator or deal with the flashlight
    }
}

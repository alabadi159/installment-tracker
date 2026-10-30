package com.example.installment_tracker

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log
import androidx.core.app.NotificationCompat
import org.json.JSONException
import org.json.JSONArray

class ReminderReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == Intent.ACTION_BOOT_COMPLETED) {
            restoreReminders(context)
            return
        }
        val manager =
            context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            manager.createNotificationChannel(
                NotificationChannel(
                    CHANNEL_ID,
                    "Payment and contract reminders",
                    NotificationManager.IMPORTANCE_DEFAULT
                )
            )
        }
        val openApp = PendingIntent.getActivity(
            context,
            intent.getIntExtra("notificationId", 1),
            Intent(context, MainActivity::class.java),
            pendingIntentFlags()
        )
        val notification = NotificationCompat.Builder(context, CHANNEL_ID)
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setContentTitle(intent.getStringExtra("title") ?: "AuraWelth Pro reminder")
            .setContentText(intent.getStringExtra("message") ?: "A payment is due soon.")
            .setContentIntent(openApp)
            .setAutoCancel(true)
            .setPriority(NotificationCompat.PRIORITY_DEFAULT)
            .build()
        manager.notify(intent.getIntExtra("notificationId", 1), notification)
    }

    private fun restoreReminders(context: Context) {
        val preferences = context.getSharedPreferences(
            MainActivity.STORAGE_FILE_NAME,
            Context.MODE_PRIVATE
        )
        val schedule = preferences.getString(
            MainActivity.REMINDER_SCHEDULE_KEY,
            null
        ) ?: return
        val alarms = context.getSystemService(Context.ALARM_SERVICE) as android.app.AlarmManager
        val scheduledIds = mutableSetOf<String>()
        try {
            val entries = JSONArray(schedule)
            for (index in 0 until entries.length()) {
                val reminder = entries.getJSONObject(index)
                val id = reminder.getInt("id")
                val triggerAt = reminder.getLong("at")
                if (triggerAt <= System.currentTimeMillis()) continue
                val pendingIntent = PendingIntent.getBroadcast(
                    context,
                    id,
                    Intent(context, ReminderReceiver::class.java)
                        .putExtra("notificationId", id)
                        .putExtra("title", reminder.optString("title"))
                        .putExtra("message", reminder.optString("message")),
                    pendingIntentFlags()
                )
                alarms.setAndAllowWhileIdle(
                    android.app.AlarmManager.RTC_WAKEUP,
                    triggerAt,
                    pendingIntent
                )
                scheduledIds.add(id.toString())
            }
        } catch (error: JSONException) {
            Log.e("ReminderReceiver", "Saved reminder schedule is invalid.", error)
            return
        }
        preferences.edit().putStringSet("reminder_ids", scheduledIds).apply()
    }

    private fun pendingIntentFlags(): Int =
        PendingIntent.FLAG_UPDATE_CURRENT or
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                PendingIntent.FLAG_IMMUTABLE
            } else {
                0
            }

    companion object {
        const val CHANNEL_ID = "aurawelth_payment_reminders"
    }
}

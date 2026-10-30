package com.example.installment_tracker

import android.Manifest
import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import org.json.JSONObject
import java.net.HttpURLConnection
import java.net.URL
import java.util.concurrent.Executors
import androidx.core.content.ContextCompat

class MainActivity : FlutterActivity() {
    private val storageChannelName = "com.example.installment_tracker/storage"
    private val storageFileName = "AuraWelthProData"
    private val plansKey = "payment_plans"
    private val appDataKey = "app_data"
    private val remindersKey = "reminder_ids"
    private val reminderScheduleKey = "reminder_schedule"
    private val networkExecutor = Executors.newSingleThreadExecutor()
    private val mainHandler = Handler(Looper.getMainLooper())

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            storageChannelName
        ).setMethodCallHandler { call, result ->
            val preferences = getSharedPreferences(storageFileName, Context.MODE_PRIVATE)
            when (call.method) {
                "loadPlans" -> result.success(preferences.getString(plansKey, null))
                "loadAppData" -> result.success(preferences.getString(appDataKey, null))
                "savePlans" -> {
                    val json = call.arguments as? String
                    if (json == null) {
                        result.error("invalid_data", "Payment plan data is invalid.", null)
                    } else if (preferences.edit().putString(plansKey, json).commit()) {
                        result.success(null)
                    } else {
                        result.error("storage_error", "Payment plans could not be saved.", null)
                    }
                }
                "saveAppData" -> {
                    val json = call.arguments as? String
                    if (json == null) {
                        result.error("invalid_data", "App data is invalid.", null)
                    } else if (preferences.edit().putString(appDataKey, json).commit()) {
                        result.success(null)
                    } else {
                        result.error("storage_error", "App data could not be saved.", null)
                    }
                }
                "requestNotificationPermission" -> {
                    if (Build.VERSION.SDK_INT < 33 ||
                        ContextCompat.checkSelfPermission(
                            this,
                            Manifest.permission.POST_NOTIFICATIONS
                        ) == PackageManager.PERMISSION_GRANTED
                    ) {
                        result.success(true)
                    } else {
                        requestPermissions(
                            arrayOf(Manifest.permission.POST_NOTIFICATIONS),
                            NOTIFICATION_PERMISSION_REQUEST
                        )
                        result.success(false)
                    }
                }
                "scheduleReminders" -> {
                    @Suppress("UNCHECKED_CAST")
                    val reminders = call.arguments as? List<Map<String, Any>>
                    if (reminders == null) {
                        result.error("invalid_data", "Reminder schedule is invalid.", null)
                    } else {
                        scheduleReminders(reminders)
                        result.success(null)
                    }
                }
                "getGoldSpot" -> networkExecutor.execute {
                    var connection: HttpURLConnection? = null
                    try {
                        connection = URL("https://api.gold-api.com/price/XAU")
                            .openConnection() as HttpURLConnection
                        connection.connectTimeout = 8000
                        connection.readTimeout = 8000
                        connection.requestMethod = "GET"
                        val status = connection.responseCode
                        if (status !in 200..299) {
                            throw IllegalStateException("Gold price service returned HTTP $status.")
                        }
                        val response = connection.inputStream.bufferedReader().use { it.readText() }
                        mainHandler.post { result.success(response) }
                    } catch (error: Exception) {
                        mainHandler.post {
                            result.error("gold_price_error", error.message, null)
                        }
                    } finally {
                        connection?.disconnect()
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun scheduleReminders(reminders: List<Map<String, Any>>) {
        val manager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val preferences = getSharedPreferences(storageFileName, Context.MODE_PRIVATE)
        val editor = preferences.edit()
        preferences.getStringSet(remindersKey, emptySet()).orEmpty().forEach { oldId ->
            oldId.toIntOrNull()?.let { id ->
                reminderIntent(id)?.let(manager::cancel)
            }
        }
        val scheduledIds = mutableSetOf<String>()
        reminders.forEach { reminder ->
            val id = (reminder["id"] as? Number)?.toInt() ?: return@forEach
            val triggerAt = (reminder["at"] as? Number)?.toLong() ?: return@forEach
            if (triggerAt <= System.currentTimeMillis()) return@forEach
            val pendingIntent = reminderIntent(id, reminder)
            if (pendingIntent != null) {
                manager.setAndAllowWhileIdle(
                    AlarmManager.RTC_WAKEUP,
                    triggerAt,
                    pendingIntent
                )
                scheduledIds.add(id.toString())
            }
        }
        val schedule = JSONArray().apply {
            reminders.forEach { reminder -> put(JSONObject(reminder)) }
        }
        editor.putStringSet(remindersKey, scheduledIds)
            .putString(reminderScheduleKey, schedule.toString())
            .apply()
    }

    private fun reminderIntent(
        id: Int,
        reminder: Map<String, Any>? = null
    ): PendingIntent? {
        val intent = Intent(this, ReminderReceiver::class.java).putExtra("notificationId", id)
        if (reminder != null) {
            intent.putExtra("title", reminder["title"] as? String)
            intent.putExtra("message", reminder["message"] as? String)
        }
        return PendingIntent.getBroadcast(
            this,
            id,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    PendingIntent.FLAG_IMMUTABLE
                } else {
                    0
                }
        )
    }

    override fun onDestroy() {
        networkExecutor.shutdownNow()
        super.onDestroy()
    }

    companion object {
        private const val NOTIFICATION_PERMISSION_REQUEST = 601
        const val STORAGE_FILE_NAME = "AuraWelthProData"
        const val REMINDER_SCHEDULE_KEY = "reminder_schedule"
    }
}

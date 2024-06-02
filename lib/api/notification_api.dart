import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future notificationDetails(String sound) async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        channelDescription: 'channel description',
        importance: Importance.max,
        sound: RawResourceAndroidNotificationSound(sound.split('.').first),
        enableVibration: true,
      ),
      iOS: DarwinNotificationDetails(
        sound: sound,
      ),
    );
  }

  static Future init({bool initScheduled = false}) async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = const DarwinInitializationSettings();
    final settings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await _notifications.initialize(
      settings,
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveBackgroundNotificationResponse,
    );

    final details = await _notifications.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      onNotifications.add(details.notificationResponse!.payload);
    }

    // await _notifications.initialize(
    //   settings,
    //   onDidReceiveBackgroundNotificationResponse:onDidReceiveBackgroundNotificationResponse,
    // );
  }

  static Future<void> onDidReceiveBackgroundNotificationResponse(
      notification) async {
    onNotifications.add(notification.payload);
  }

  static Future showScheduledNotification(
      {required int id,
      String? title,
      String? body,
      String? payload,
      required DateTime scheduledDate,
      required String sound}) async {
    _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      await notificationDetails(sound),
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static void cancel(int id) => _notifications.cancel(id);
  static void cancelAll() => _notifications.cancelAll();
}

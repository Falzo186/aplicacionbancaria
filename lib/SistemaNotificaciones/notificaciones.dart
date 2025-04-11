import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void inicializarNotificaciones() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings();

  const LinuxInitializationSettings initializationSettingsLinux =
      LinuxInitializationSettings(defaultActionName: 'Open notification');

  const WindowsInitializationSettings initializationSettingsWindows =
      WindowsInitializationSettings(
        appName: 'Aplicacion Bancaria',
        appUserModelId: 'com.example.aplicacionbancaria',
        guid: '12345678-1234-1234-1234-123456789abc',
      );

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
    linux: initializationSettingsLinux,
    windows: initializationSettingsWindows, // Ahora incluye Windows
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

void mostrarNotificacionEnApp(String mensaje) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'canal_notificaciones',
        'Notificaciones',
        channelDescription: 'Notificaciones del sistema',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
      );

  const WindowsNotificationDetails windowsPlatformChannelSpecifics =
      WindowsNotificationDetails();

  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    windows: windowsPlatformChannelSpecifics,
  );

  await flutterLocalNotificationsPlugin.show(
    0,
    'Nueva Notificación',
    mensaje,
    platformChannelSpecifics,
  );
}

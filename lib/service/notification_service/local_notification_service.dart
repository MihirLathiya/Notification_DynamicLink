import 'dart:convert';
import 'dart:developer';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification_demo/service/dynamic_link/dynamic_link_service.dart';

class LocalNotificationController {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    // 'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  ///get fcm token
  static Future getFcmToken() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

    try {
      String? token = await firebaseMessaging.getToken();
      log("=========fcm-token===$token");
      // await PreferenceManager.setNewFcm(token!);
      return token;
    } catch (e) {
      log("=========fcm- Error :$e");
      return null;
    }
  }

  ///call when app in fore ground
  static void showMsgHandler() {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage? message) {
        RemoteNotification? notification = message!.notification;
        print(
            'NOtification Call :${notification?.apple}${notification!.body}${notification.title}${notification.bodyLocKey}${notification.bodyLocKey}');

        if (message != null) {
          print(
              "action==onMessage.listen====1=== ${message.data['action_click']}");
          print("slug======2=== ${message.data}");
          const InitializationSettings initializationSettings =
              InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"),
          );
          flutterLocalNotificationsPlugin.initialize(
            initializationSettings,
            onDidReceiveNotificationResponse: (payload) async {
              print('-----NOTIFICATION ACTION TYPOE----${payload.actionId}');

              if (payload.actionId.toString().toLowerCase() == 'read') {
                print('----MESSAGE REARD---');
                flutterLocalNotificationsPlugin.cancel(notification.hashCode);
              } else {
                flutterLocalNotificationsPlugin.cancel(notification.hashCode);
                DynamicLinksService.handleDeeplinkData(
                  PendingDynamicLinkData(
                    link: Uri.parse(
                      message.data['link'].toString(),
                    ),
                    utmParameters: {
                      'id': message.data['id'].toString(),
                    },
                  ),
                );

                print('-----notification.hashCode----${notification.hashCode}');
              }
            },
          );
          showMsg(notification, message);
        }
      },
    );
  }

  /// handle notification when app in fore ground..///close app
  static void getInitialMsg() {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      print('------RemoteMessage message------$message');
      if (message != null) {
        print("action======2=== ${message.data['action_click']}");
        print("slug======3=== ${message.data['slug_name']}");
      }
    });
  }

  static Future<String?> networkImageToBase64(String imageUrl) async {
    http.Response response = await http.get(Uri.parse(imageUrl));
    final bytes = response.bodyBytes;
    return (bytes != null ? base64Encode(bytes) : null);
  }

  ///show notification msg
  static Future<void> showMsg(
      RemoteNotification notification, RemoteMessage messagessss) async {
    String? data =
        await networkImageToBase64(messagessss.data['image'].toString());
    BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(
      ByteArrayAndroidBitmap.fromBase64String(data!),
      largeIcon: ByteArrayAndroidBitmap.fromBase64String(data),
    );
    log('----SHOW MESSAGE-----');
    print('-----notification.hashCode----${notification.hashCode}');

    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel', // id
          'High Importance Notifications', // title
          importance: Importance.high,
          icon: '@mipmap/ic_launcher',
          styleInformation: bigPictureStyleInformation,
          actions: [
            AndroidNotificationAction(
              'Check Out',
              'Check Out',
              showsUserInterface: true,
              inputs: [
                AndroidNotificationActionInput(
                  label: 'Send',
                  allowFreeFormInput: true,
                )
              ],
            ),
            AndroidNotificationAction(
              'Read',
              'Read',
              showsUserInterface: true,
            ),
            AndroidNotificationAction('Dismiss', 'Dismiss',
                cancelNotification: true),
          ],
        ),
      ),
    );
  }

  ///background notification handler..
  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    print('Handling a background message ${message.messageId}');
    RemoteNotification? notification = message.notification;
    print(
        '--------split body ${notification!.body.toString().split(' ').first}');
    if (notification.body.toString().split(' ').first == 'calling') {
      print('----in this app');
    }
  }

  ///call when click on notification back
  static void onMsgOpen() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print('listen->${message.data}');

      if (message != null) {
        print("action======2=== ${message.data['action_click']}");
      }
    });
  }

  /// send notification device to device
  static Future<bool?> sendMessage(
      {String? msg,
      String? link = '',
      String? id = '',
      String image = ''}) async {
    var serverKey =
        "AAAATFIKZp4:APA91bFvgEMK1M8CDltABZpELOOA88zBVUqDe9AsYgKvHUy-RF2oWu4NT5MMqpz6d5EKu1eUQoGPl5B9U2Js7ThxuH5B-sjJnCAVlYGuXBgl6TIaZUfFpt45e4B3spJvjwFyAs_YEdog"; /////   YOUR SERVER KEY
    try {
      // for (String token in receiverFcmToken) {

      http.Response response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': msg,
              'title': 'Rank',
              'bodyLocKey': 'true'
            },
            "data": {
              "link": "$link",
              'id': id,
              'image': '$image',
              'name': 'Rank',
              "status": "done"
            },
            'priority': 'high',
            'to':
                'dUFKqZuwRY6dQ5pCDrUnYi:APA91bGY9Fb8AYwu0RxqxHTR3Ub0VR5eUmlnk8va4mnlz4_AzztWl8ITKlWgD1huLdGDSPKLX9RtyGoRW3G2lH_rtJA8gxATnR-aWkfpG-ww3dSAamtg2IivJdDOPPCHO56-tXbDFZHR',
          },
        ),
      );
      log("RESPONSE CODE ${response.statusCode}");

      log("RESPONSE BODY ${response.body}");
      // return true}
    } catch (e) {
      print("error push notification");
      // return false;
    }
    return null;
  }
}

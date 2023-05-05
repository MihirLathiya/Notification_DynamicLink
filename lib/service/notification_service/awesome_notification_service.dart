// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'package:awesome_notifications/android_foreground_service.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:firebase_core/firebase_core.dart';
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:notification_demo/main.dart';
// import 'package:http/http.dart' as http;
//
// class NotificationController {
//   static ReceivedAction? initialAction;
//
//   /// To get FCM token of the device:
//   static Future getFcmToken() async {
//     FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
//
//     try {
//       String? token = await firebaseMessaging.getToken();
//       log("=========fcm-token===$token");
//       // await GetStorageServices.setFCMToken(token!);
//       return token;
//     } catch (e) {
//       return null;
//     }
//   }
//
//   ///  *********************************************
//   ///     MESSAGE HANDLER
//   ///  *********************************************
//   ///
//   static void showMsgHandler() async {
//     try {
//       FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
//         RemoteNotification? notification = message!.notification;
//
//         try {
//           debugPrint('Notification Title  ${notification!.title}');
//         } catch (e) {
//           // TODO
//         }
//
//         if (Platform.isAndroid) {
//           AndroidForegroundService.startAndroidForegroundService(
//             foregroundStartMode: ForegroundStartMode.stick,
//             foregroundServiceType: ForegroundServiceType.phoneCall,
//             content: NotificationContent(
//                 id: 2341234,
//                 body: notification?.body ?? "test",
//                 title: notification?.title ?? "test",
//                 channelKey: 'alerts',
//                 category: NotificationCategory.Service),
//             actionButtons: [
//               NotificationActionButton(
//                 key: 'OKAY',
//                 label: 'OKAY',
//               ),
//               // NotificationActionButton(
//               //     key: 'REPLY',
//               //     label: 'Reply Message',
//               //     requireInputText: true,
//               //     actionType: ActionType.SilentAction),
//               NotificationActionButton(
//                   key: 'DISMISS',
//                   label: 'Dismiss',
//                   actionType: ActionType.DismissAction,
//                   isDangerousOption: true)
//             ],
//           );
//         }
//       });
//     } on FirebaseException catch (e) {
//       debugPrint('notification error ${e.message}');
//       return null;
//     }
//     return null;
//   }
//
//   ///  *********************************************
//   ///     INITIALIZATIONS
//   ///  *********************************************
//   ///
//   static Future<void> initializeLocalNotifications() async {
//     await AwesomeNotifications().initialize(
//         null, //'resource://drawable/res_app_icon',//
//         [
//           NotificationChannel(
//               channelKey: 'alerts',
//               channelName: 'Alerts',
//               channelDescription: 'Notification tests as alerts',
//               playSound: true,
//               onlyAlertOnce: true,
//               groupAlertBehavior: GroupAlertBehavior.Children,
//               importance: NotificationImportance.High,
//               defaultPrivacy: NotificationPrivacy.Private,
//               defaultColor: Colors.amberAccent,
//               ledColor: Colors.amber)
//         ],
//         debug: true);
//
//     // Get initial notification action is optional
//     initialAction = await AwesomeNotifications()
//         .getInitialNotificationAction(removeFromActionEvents: false);
//   }
//
//   ///  *********************************************
//   ///     NOTIFICATION EVENTS LISTENER  Notifications events are only delivered after call this method
//   ///  *********************************************
//
//   static Future<void> startListeningNotificationEvents() async {
//     print('-----CATCH IT---00');
//     AwesomeNotifications()
//         .setListeners(onActionReceivedMethod: onActionReceivedMethod);
//   }
//
//   ///  *********************************************
//   ///     NOTIFICATION EVENTS
//   ///  *********************************************
//   ///
//   @pragma('vm:entry-point')
//   static Future<void> onActionReceivedMethod(
//       ReceivedAction receivedAction) async {
//     if (receivedAction.actionType == ActionType.SilentAction ||
//         receivedAction.actionType == ActionType.SilentBackgroundAction) {
//       print('---------HELLO----');
//       // For background actions, you must hold the execution until the end
//       print(
//           'Message sent via notification input: "${receivedAction.buttonKeyInput}"');
//       print('-------${receivedAction}');
//
//       await executeLongTaskInBackground();
//     } else {
//       print('-------${receivedAction}');
//     }
//   }
//
//   ///  *********************************************
//   ///     REQUESTING NOTIFICATION PERMISSIONS
//   ///  *********************************************
//   ///
//
//   ///  *********************************************
//   ///     BACKGROUND TASKS TEST
//   ///  *********************************************
//   static Future<void> executeLongTaskInBackground() async {
//     print("starting long task");
//     await Future.delayed(const Duration(seconds: 4));
//     final url = Uri.parse("http://google.com");
//     final re = await http.get(url);
//     print(re.statusCode);
//     print("long task done");
//   }
//
//   ///  *********************************************
//   ///     CREATE NOTIFICATION
//   ///  *********************************************
//   static Future<void> createNewNotification(
//       {String? title,
//       String? body,
//       String? image,
//       Map<String, String>? payLoad}) async {
//     bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
//     if (!isAllowed)
//       isAllowed =
//           await AwesomeNotifications().requestPermissionToSendNotifications();
//     ;
//     if (!isAllowed) return;
//
//     await AwesomeNotifications().createNotification(
//       content: NotificationContent(
//           id: 123456, // -1 is replaced by a random number
//           channelKey: 'alerts',
//           title: '$title',
//           body: "$body",
//           bigPicture: 'https://wallpapercave.com/wp/wp7771186.jpg',
//           largeIcon: 'https://wallpapercave.com/wp/wp7771186.jpg',
//           notificationLayout: NotificationLayout.Default,
//           payload: payLoad),
//
//       /// FOR ADD BUTTON
//       actionButtons: [
//         NotificationActionButton(
//           key: 'OKAY',
//           label: 'OKAY',
//         ),
//         // NotificationActionButton(
//         //     key: 'REPLY',
//         //     label: 'Reply Message',
//         //     requireInputText: true,
//         //     actionType: ActionType.SilentAction),
//         NotificationActionButton(
//             key: 'DISMISS',
//             label: 'Dismiss',
//             actionType: ActionType.DismissAction,
//             isDangerousOption: true)
//       ],
//     );
//   }
//
//   ///  *********************************************
//   ///     SEND MESSAGE
//   ///  *********************************************
//   static Future<bool?> sendMessage(
//       {String? receiverFcmToken, String? msg}) async {
//     var serverKey =
//         "AAAATFIKZp4:APA91bFvgEMK1M8CDltABZpELOOA88zBVUqDe9AsYgKvHUy-RF2oWu4NT5MMqpz6d5EKu1eUQoGPl5B9U2Js7ThxuH5B-sjJnCAVlYGuXBgl6TIaZUfFpt45e4B3spJvjwFyAs_YEdog"; /////   YOUR SERVER KEY
//     try {
//       // for (String token in receiverFcmToken) {
//       log("RESPONSE TOKEN  $receiverFcmToken");
//
//       http.Response response = await http.post(
//         Uri.parse('https://fcm.googleapis.com/fcm/send'),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'key=$serverKey',
//         },
//         body: jsonEncode(
//           <String, dynamic>{
//             'notification': <String, dynamic>{
//               'body': msg,
//               'title': 'Messaging',
//               'bodyLocKey': 'true',
//             },
//             'priority': 'high',
//             'to': receiverFcmToken,
//           },
//         ),
//       );
//       log("RESPONSE CODE ${response.statusCode}");
//
//       log("RESPONSE BODY ${response.body}");
//       // return true}
//     } catch (e) {
//       print("error push notification");
//       // return false;
//     }
//     return null;
//   }
// }

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:notification_demo/view/product_detail_screen.dart';
import 'package:notification_demo/view_model/details_view_model.dart';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

String pageLink = 'https://rankcreator.page.link';

class DynamicLinksService {
  static Future<String> createDynamicLink({
    final String? userId,
  }) async {
    String _linkMessage;

    var parameters = DynamicLinkParameters(
      uriPrefix: '$pageLink',
      link: Uri.parse('$pageLink/Product?id=$userId'),
      androidParameters: const AndroidParameters(
        packageName: "com.example.notification_demo",
        minimumVersion: 0,
      ),
    );

    print("parameters-----$parameters");
    Uri url;
    final ShortDynamicLink shortLink =
        await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    url = shortLink.shortUrl;

    print("url-----$url");
    _linkMessage = url.toString();
    // Share.share(_linkMessage);
    return _linkMessage;
  }

  static Future<void> handleDynamicLinks() async {
    print('--------LISTEN----');
    // STARTUP FROM DYNAMIC LINK LOGIC
    // Get initial dynamic link if the app is started using the link

    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    handleDeeplinkData(data);

    // IF APP IS IN BACKGROUND AND OPENED FROM DEEP LINKING
    FirebaseDynamicLinks.instance.onLink.listen((event) {
      print('onLink$event');
      handleDeeplinkData(event);
    });
  }

  static handleDeeplinkData(PendingDynamicLinkData? data) async {
    final Uri? deepLink = data?.link;
    log('------URL------$deepLink');
    if (deepLink != null) {
      var id = deepLink.queryParameters['id'];
      print("status---${id}");
      // await Get.put(ProductDetailsViewModel()).productDetailsViewModel(id: id);
      if (id != null) {
        Get.to(
          () => ProductDetailScreen(
            productId: id,
          ),
        );
      } else {
        try {
          var id = data?.utmParameters['id'];
          if (id != null) {
            Get.to(
              () => ProductDetailScreen(
                productId: id,
              ),
            );
          }
        } catch (e) {
          print('-----ERROR----$e');
        }
      }
    }
  }
}

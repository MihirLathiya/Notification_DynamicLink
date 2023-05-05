import 'dart:developer';

import 'package:notification_demo/api_routs/api_handler.dart';
import 'package:notification_demo/api_routs/api_routs.dart';
import 'package:notification_demo/model/response_model/detail_response_model.dart';
import 'package:notification_demo/model/response_model/product_response_model.dart';

class ProductRepo {
  static Future<ProductResponseModel> productRepo() async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: ApiRouts.productUrl,
    );
    ProductResponseModel productResponseModel =
        ProductResponseModel.fromJson(response);
    log('response --------- $response');
    return productResponseModel;
  }

  static Future<ProductDetailsResponseModel> productDetailRepo(
      {String? id}) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: ApiRouts.productDesUrl + id!,
    );
    ProductDetailsResponseModel productDetailsResponseModel =
        ProductDetailsResponseModel.fromJson(response);
    return productDetailsResponseModel;
  }
}

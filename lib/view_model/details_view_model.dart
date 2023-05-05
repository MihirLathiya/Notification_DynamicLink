import 'package:get/get.dart';
import 'package:notification_demo/api_routs/api_response.dart';
import 'package:notification_demo/model/repo/product_repo.dart';
import 'package:notification_demo/model/response_model/detail_response_model.dart';

class ProductDetailsViewModel extends GetxController {
  int selectIndex = 0;

  updateIndex(int value) {
    selectIndex = value;
    update();
  }

  Rx<ProductDetailsResponseModel> productDetails =
      ProductDetailsResponseModel().obs;

  ApiResponse _productDetailApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get productDetailApiResponse => _productDetailApiResponse;

  Future<void> productDetailsViewModel(
      {bool loading = true, String? id}) async {
    if (loading == true) {
      _productDetailApiResponse = ApiResponse.loading(message: 'Loading');
    }
    try {
      productDetails.value = await ProductRepo.productDetailRepo(id: id);
      print("ProductResponseModel=response==>${productDetails}");

      _productDetailApiResponse = ApiResponse.complete({productDetails});
    } catch (e) {
      print("ProductResponseModel=e==>$e");

      _productDetailApiResponse = ApiResponse.error(message: 'error');
    } finally {}
    update();
  }
}

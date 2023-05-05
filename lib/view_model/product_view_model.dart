import 'package:get/get.dart';
import 'package:notification_demo/api_routs/api_response.dart';
import 'package:notification_demo/model/repo/product_repo.dart';
import 'package:notification_demo/model/response_model/product_response_model.dart';

class ProductViewModel extends GetxController {
  Rx<ProductResponseModel> products = ProductResponseModel().obs;

  ApiResponse _productApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get productApiResponse => _productApiResponse;

  Future<void> productViewModel({bool loading = true}) async {
    if (loading == true) {
      _productApiResponse = ApiResponse.loading(message: 'Loading');
    }
    try {
      products.value = await ProductRepo.productRepo();
      print("ProductResponseModel=response==>${products}");

      _productApiResponse = ApiResponse.complete({products});
    } catch (e) {
      print("ProductResponseModel=e==>$e");

      _productApiResponse = ApiResponse.error(message: 'error');
    } finally {}
    update();
  }
}

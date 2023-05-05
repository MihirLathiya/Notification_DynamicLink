import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:notification_demo/api_routs/api_response.dart';
import 'package:notification_demo/service/dynamic_link/dynamic_link_service.dart';
import 'package:notification_demo/service/notification_service/local_notification_service.dart';
import 'package:notification_demo/view/product_detail_screen.dart';
import 'package:notification_demo/view_model/product_view_model.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ProductViewModel productViewModel = Get.put(ProductViewModel());
  @override
  void initState() {
    DynamicLinksService.handleDynamicLinks();

    LocalNotificationController.getFcmToken();
    productViewModel.productViewModel();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GetBuilder<ProductViewModel>(
          builder: (controller) {
            if (controller.productApiResponse.status == Status.LOADING) {
              return Center(
                child: CupertinoActivityIndicator(),
              );
            }
            if (controller.productApiResponse.status == Status.COMPLETE) {
              return MasonryGridView.count(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(15),
                itemCount: controller.products.value.products?.length,
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      String link = await DynamicLinksService.createDynamicLink(
                          userId: controller.products.value.products![index].id
                              .toString());
                      print('----------${link}');

                      LocalNotificationController.sendMessage(
                          msg: 'This is New Product CheckOut',
                          link: link,
                          image: controller
                              .products.value.products![index].thumbnail
                              .toString(),
                          id: controller.products.value.products![index].id
                              .toString());
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              controller
                                  .products.value.products![index].thumbnail!,
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  controller
                                      .products.value.products![index].title!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '\$ ${controller.products.value.products![index].price!}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text('Something went wrong'),
              );
            }
          },
        ),
      ),
    );
  }
}

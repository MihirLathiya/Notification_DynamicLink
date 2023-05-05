import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notification_demo/api_routs/api_response.dart';
import 'package:notification_demo/service/dynamic_link/dynamic_link_service.dart';
import 'package:notification_demo/view_model/details_view_model.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;
  const ProductDetailScreen({Key? key, required this.productId})
      : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  ProductDetailsViewModel productDetailsViewModel =
      Get.put(ProductDetailsViewModel());
  @override
  void initState() {
    if (widget.productId.isNotEmpty) {
      productDetailsViewModel.productDetailsViewModel(id: widget.productId);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: GetBuilder<ProductDetailsViewModel>(
        builder: (controller) {
          if (controller.productDetailApiResponse.status == Status.LOADING) {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }
          if (controller.productDetailApiResponse.status == Status.COMPLETE) {
            return Container(
              height: 100,
              width: Get.width,
              color: Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () async {
                      print('-----widget.productId----${widget.productId}');
                      // String dynamicUrl =
                      await DynamicLinksService.createDynamicLink(
                          userId: widget.productId);
                      // if (dynamicUrl.isNotEmpty) {
                      //   Share.share(dynamicUrl);
                      // }
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(),
                      ),
                      child: Center(
                        child: FittedBox(
                          child: Icon(
                            Icons.share,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {},
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Add to cart',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '\$ ${controller.productDetails.value.price}',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return Center(
              child: Text('Something went wrong'),
            );
          }
        },
      ),
      body: GetBuilder<ProductDetailsViewModel>(
        builder: (controller) {
          if (controller.productDetailApiResponse.status == Status.LOADING) {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }
          if (controller.productDetailApiResponse.status == Status.COMPLETE) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.arrow_back_ios),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 300,
                  child: PageView.builder(
                    onPageChanged: (value) {
                      controller.updateIndex(value);
                    },
                    itemCount: controller.productDetails.value.images!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            controller.productDetails.value.images![index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...List.generate(
                      controller.productDetails.value.images!.length,
                      (index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            radius: controller.selectIndex == index ? 5 : 3,
                            backgroundColor: controller.selectIndex == index
                                ? Colors.red
                                : Colors.grey,
                          ),
                        );
                      },
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${controller.productDetails.value.brand!} - ${controller.productDetails.value.title!} ',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        '${controller.productDetails.value.description!}',
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.5,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Text(
                            'Rating',
                            style: TextStyle(
                              fontSize: 18,
                              height: 1.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            ' : ${controller.productDetails.value.rating!}',
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.5,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Discount',
                            style: TextStyle(
                              fontSize: 18,
                              height: 1.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            ' : ${controller.productDetails.value.discountPercentage!} %',
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.5,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: Text('Something went wrong'),
            );
          }
        },
      ),
    );
  }
}

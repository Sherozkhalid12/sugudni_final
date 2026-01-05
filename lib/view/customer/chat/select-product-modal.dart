import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sugudeni/models/orders/GetAllOrdersCutomerModel.dart';
import 'package:sugudeni/repositories/orders/customer-order-repository.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/utils/customWidgets/cached-network-image.dart';
import 'package:sugudeni/models/products/SimpleProductModel.dart';

class SelectProductModal extends StatelessWidget {
  final Function(String orderId, String productId) onProductSelected;

  const SelectProductModal({
    super.key,
    required this.onProductSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: borderColor.withOpacity(0.2)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText(
                  text: 'Select Product',
                  size: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          // Products List
          Expanded(
            child: FutureBuilder<GetCustomerAllOrderResponseModel>(
              future: CustomerOrderRepository.allCustomersOrders(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: MyText(
                      text: 'Error: ${snapshot.error}',
                      color: redColor,
                    ),
                  );
                }
                if (snapshot.data == null || snapshot.data!.orders.isEmpty) {
                  return Center(
                    child: MyText(
                      text: 'No products found',
                      color: textSecondaryColor,
                    ),
                  );
                }

                // Extract all products from all orders
                final products = <Map<String, dynamic>>[];
                for (var order in snapshot.data!.orders) {
                  for (var cartItem in order.cartItem) {
                    if (cartItem.productId.id.isNotEmpty) {
                      products.add({
                        'orderId': order.id,
                        'productId': cartItem.productId.id,
                        'product': cartItem.productId,
                        'order': order,
                      });
                    }
                  }
                }

                if (products.isEmpty) {
                  return Center(
                    child: MyText(
                      text: 'No products found',
                      color: textSecondaryColor,
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.all(15.w),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final productData = products[index];
                    final product = productData['product'] as Product;
                    final order = productData['order'] as Order;
                    return _buildProductCard(
                      context,
                      product,
                      productData['orderId'] as String,
                      productData['productId'] as String,
                      order,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    Product product,
    String orderId,
    String productId,
    Order order,
  ) {
    final imageUrl = product.imgCover.isNotEmpty
        ? "${ApiEndpoints.productUrl}/${product.imgCover}"
        : '';

    return GestureDetector(
      onTap: () {
        onProductSelected(orderId, productId);
        Navigator.pop(context);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 15.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: borderColor.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            // Product Image
            Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: Colors.grey[100],
              ),
              child: imageUrl.isEmpty
                  ? Center(
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey[400],
                        size: 30.sp,
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: MyCachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
            12.width,
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    text: product.title,
                    size: 14.sp,
                    fontWeight: FontWeight.w600,
                    maxLine: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  4.height,
                  MyText(
                    text: 'Order #${order.id.substring(order.id.length - 8)}',
                    size: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: textSecondaryColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


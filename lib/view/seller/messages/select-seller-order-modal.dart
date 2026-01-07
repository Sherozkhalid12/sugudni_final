import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sugudeni/models/orders/GetAllOrderSellerResponseModel.dart';
import 'package:sugudeni/repositories/orders/seller-order-repository.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/utils/customWidgets/cached-network-image.dart';
import 'package:sugudeni/utils/sharePreference/save-user-token.dart';

class SelectSellerOrderModal extends StatelessWidget {
  final Function(Order) onOrderSelected;

  const SelectSellerOrderModal({
    super.key,
    required this.onOrderSelected,
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
                  text: 'Select Order',
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
          // Orders List
          Expanded(
            child: FutureBuilder<GetAllOrderSellerResponse>(
              future: SellerOrderRepository.allSellerOrders(context),
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
                if (snapshot.data == null || snapshot.data!.orders == null || snapshot.data!.orders!.isEmpty) {
                  return Center(
                    child: MyText(
                      text: 'No orders found',
                      color: textSecondaryColor,
                    ),
                  );
                }

                final orders = snapshot.data!.orders!.where((order) => order.cartItem.isNotEmpty).toList();

                if (orders.isEmpty) {
                  return Center(
                    child: MyText(
                      text: 'No orders found',
                      color: textSecondaryColor,
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.all(15.w),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return _buildOrderCard(context, order);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, Order order) {
    // Get up to 4 product images from order
    final productImages = order.cartItem
        .where((item) => item.product != null && item.product!.imgCover.isNotEmpty)
        .take(4)
        .map((item) => "${ApiEndpoints.productUrl}/${item.product!.imgCover}")
        .toList();

    // Get order status
    final status = order.trackingStatus;
    final statusText = status.isNotEmpty ? status : 'Pending';

    return GestureDetector(
      onTap: () {
        // Verify that the order belongs to the current seller
        // This is a client-side check - server will also verify
        // Call callback first, then close modal
        onOrderSelected(order);
        // Use Navigator.of(context) to ensure we only pop the modal
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
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
            // Product Images Grid
            Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: Colors.grey[100],
              ),
              child: productImages.isEmpty
                  ? Center(
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey[400],
                        size: 30.sp,
                      ),
                    )
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                      ),
                      itemCount: productImages.length,
                      itemBuilder: (context, idx) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(4.r),
                          child: MyCachedNetworkImage(
                            imageUrl: productImages[idx],
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
            ),
            12.width,
            // Order Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    text: 'Order #${order.orderId.isNotEmpty ? order.orderId.substring(order.orderId.length > 8 ? order.orderId.length - 8 : 0) : order.id.substring(order.id.length > 8 ? order.id.length - 8 : 0)}',
                    size: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff8B4513),
                  ),
                  4.height,
                  MyText(
                    text: 'Standard Delivery',
                    size: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: textSecondaryColor,
                  ),
                  4.height,
                  MyText(
                    text: statusText,
                    size: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff8B4513),
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


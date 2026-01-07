import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/models/orders/GetAllOrdersCutomerModel.dart';
import 'package:sugudeni/models/products/SimpleProductModel.dart';
import 'package:sugudeni/providers/chatSocketProvider/chat-socket-provider.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/cached-network-image.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';

class ChatAttachmentPreview extends StatelessWidget {
  const ChatAttachmentPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatSocketProvider>(
      builder: (context, chatProvider, child) {
        if (!chatProvider.hasPendingAttachment) {
          return const SizedBox.shrink();
        }

        final attachmentData = chatProvider.pendingAttachment!;
        final attachmentType = attachmentData['attachmentType'] as String?;

        if (attachmentType == 'product') {
          return _buildProductPreview(context, chatProvider, attachmentData);
        } else if (attachmentType == 'order') {
          return _buildOrderPreview(context, chatProvider, attachmentData);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildProductPreview(
    BuildContext context,
    ChatSocketProvider chatProvider,
    Map<String, dynamic> attachmentData,
  ) {
    try {
      final productData = attachmentData['productid'];
      if (productData == null || productData is! Map) {
        return const SizedBox.shrink();
      }

      Product? product;
      try {
        product = Product.fromJson(Map<String, dynamic>.from(productData));
      } catch (e) {
        customPrint('Error parsing product in preview: $e');
        return const SizedBox.shrink();
      }

      final imageUrl = product.imgCover.isNotEmpty
          ? "${ApiEndpoints.productUrl}/${product.imgCover}"
          : '';

      return Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: primaryColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Product Image
            Container(
              width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: Colors.grey[100],
              ),
              child: imageUrl.isEmpty
                  ? Center(
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey[400],
                        size: 24.sp,
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  MyText(
                    text: product.title.length > 30 ? '${product.title.substring(0, 30)}...' : product.title,
                    size: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: textPrimaryColor,
                  ),
                  4.height,
                  MyText(
                    text: "\$${product.price.toStringAsFixed(2)}",
                    size: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: primaryColor,
                  ),
                ],
              ),
            ),
            // Remove button
            GestureDetector(
              onTap: () {
                chatProvider.clearPendingAttachment();
              },
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  size: 18.sp,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      customPrint('Error building product preview: $e');
      return const SizedBox.shrink();
    }
  }

  Widget _buildOrderPreview(
    BuildContext context,
    ChatSocketProvider chatProvider,
    Map<String, dynamic> attachmentData,
  ) {
    try {
      final orderData = attachmentData['orderid'];
      if (orderData == null || orderData is! Map) {
        return const SizedBox.shrink();
      }

      Order? order;
      try {
        // Filter out invalid cart items before parsing
        final orderJson = Map<String, dynamic>.from(orderData);
        if (orderJson['cartItem'] != null && orderJson['cartItem'] is List) {
          final cartItems = (orderJson['cartItem'] as List)
              .where((item) =>
                  item is Map &&
                  item['productId'] != null &&
                  item['productId'] is Map)
              .toList();
          orderJson['cartItem'] = cartItems;
        }
        order = Order.fromJson(orderJson);
      } catch (e) {
        customPrint('Error parsing order in preview: $e');
        return const SizedBox.shrink();
      }

      // Get up to 4 product images from order
      final productImages = order.cartItem
          .where((item) => item.productId.imgCover.isNotEmpty)
          .take(4)
          .map((item) => "${ApiEndpoints.productUrl}/${item.productId.imgCover}")
          .toList();

      final status = order.status.isNotEmpty ? order.status : 'Pending';
      final totalPrice = order.totalPriceAfterDiscount > 0
          ? order.totalPriceAfterDiscount
          : order.totalPrice;

      return Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: primaryColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Order Images
            Container(
              width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: Colors.grey[100],
              ),
              child: productImages.isEmpty
                  ? Center(
                      child: Icon(
                        Icons.receipt_long,
                        color: Colors.grey[400],
                        size: 24.sp,
                      ),
                    )
                  : Stack(
                      children: [
                        if (productImages.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: MyCachedNetworkImage(
                              imageUrl: productImages[0],
                              fit: BoxFit.cover,
                              width: 60.w,
                              height: 60.h,
                            ),
                          ),
                        if (productImages.length > 1)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(2.w),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(8.r),
                                  bottomLeft: Radius.circular(8.r),
                                ),
                              ),
                              child: MyText(
                                text: '+${productImages.length - 1}',
                                size: 8.sp,
                                fontWeight: FontWeight.w600,
                                color: whiteColor,
                              ),
                            ),
                          ),
                      ],
                    ),
            ),
            12.width,
            // Order Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  MyText(
                    text: "Order #${order.id.length > 8 ? order.id.substring(order.id.length - 8) : order.id}",
                    size: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: textPrimaryColor,
                  ),
                  4.height,
                  MyText(
                    text: "${order.itemsCount} ${order.itemsCount == 1 ? 'item' : 'items'} • \$${totalPrice.toStringAsFixed(2)}",
                    size: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: textSecondaryColor,
                  ),
                  2.height,
                  MyText(
                    text: status,
                    size: 10.sp,
                    fontWeight: FontWeight.w500,
                    color: primaryColor,
                  ),
                ],
              ),
            ),
            // Remove button
            GestureDetector(
              onTap: () {
                chatProvider.clearPendingAttachment();
              },
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  size: 18.sp,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      customPrint('Error building order preview: $e');
      return const SizedBox.shrink();
    }
  }
}


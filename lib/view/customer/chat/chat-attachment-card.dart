import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/models/messages/ChatHistoryModel.dart';
import 'package:sugudeni/models/orders/GetAllOrdersCutomerModel.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/cached-network-image.dart';
import 'package:sugudeni/models/products/SimpleProductModel.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';
import 'package:sugudeni/view/customer/products/customer-specific-product-detail-view.dart';
import 'package:sugudeni/utils/global-functions.dart';

class ChatAttachmentCard extends StatelessWidget {
  final ChatMessage message;
  final bool isSender;
  final GetCustomerAllOrderResponseModel? cachedOrders;

  const ChatAttachmentCard({
    super.key,
    required this.message,
    required this.isSender,
    this.cachedOrders,
  });

  @override
  Widget build(BuildContext context) {
    // Check if message has attachment and attachmentData is not null
    if (message.attachment != true || message.attachmentData == null) {
      return const SizedBox.shrink();
    }

    // Safely extract attachment data
    final attachmentData = message.attachmentData!;
    
    // Safely extract attachmentType - handle both String and dynamic types
    final attachmentTypeValue = attachmentData['attachmentType'];
    String? attachmentType;
    if (attachmentTypeValue is String) {
      attachmentType = attachmentTypeValue;
    } else if (attachmentTypeValue != null) {
      attachmentType = attachmentTypeValue.toString();
    }
    
    // Safely extract orderId - handle both String and Map types
    final orderIdValue = attachmentData['orderid'];
    String? orderId;
    if (orderIdValue is String) {
      orderId = orderIdValue;
    } else if (orderIdValue is Map) {
      // If orderid is a Map (full order object), extract the _id field
      final orderIdFromMap = orderIdValue['_id'];
      if (orderIdFromMap is String) {
        orderId = orderIdFromMap;
      } else if (orderIdFromMap != null) {
        orderId = orderIdFromMap.toString();
      }
    } else if (orderIdValue != null) {
      orderId = orderIdValue.toString();
    }
    
    // Safely extract productId - handle both String and Map types
    final productIdValue = attachmentData['productid'];
    String? productId;
    if (productIdValue is String) {
      productId = productIdValue;
    } else if (productIdValue is Map) {
      // If productid is a Map (full product object), extract the _id field
      final productIdFromMap = productIdValue['_id'];
      if (productIdFromMap is String) {
        productId = productIdFromMap;
      } else if (productIdFromMap != null) {
        productId = productIdFromMap.toString();
      }
    } else if (productIdValue != null) {
      productId = productIdValue.toString();
    }
    
    // Validate that we have the required data
    if (attachmentType == null || attachmentType.isEmpty) {
      return const SizedBox.shrink();
    }

    // Handle order attachment
    if (attachmentType == 'order' && orderId != null && orderId.toString().isNotEmpty) {
      customPrint('Processing order attachment - orderId: $orderId, attachmentType: $attachmentType');
      try {
        Order? order;
        
        // First, try to use the order data directly from attachmentData if it's a full object
        final orderIdValue = attachmentData['orderid'];
        customPrint('OrderId value type: ${orderIdValue.runtimeType}, is Map: ${orderIdValue is Map}');
        
        if (orderIdValue is Map) {
          // Server sent full order object - parse it, handling nested userId
          try {
            // Create a copy of the order data and normalize userId if it's a Map
            Map<String, dynamic> orderJson = Map<String, dynamic>.from(orderIdValue);
            customPrint('Order JSON keys: ${orderJson.keys.toList()}');
            
            // Normalize userId if it's a Map
            if (orderJson['userId'] is Map) {
              final userIdMap = orderJson['userId'] as Map;
              orderJson['userId'] = userIdMap['_id']?.toString() ?? '';
            } else if (orderJson['userId'] == null) {
              orderJson['userId'] = '';
            }
            
            // Ensure paymentMethod exists
            if (orderJson['paymentMethod'] == null) {
              orderJson['paymentMethod'] = '';
            }
            
            // Ensure status exists
            if (orderJson['status'] == null) {
              orderJson['status'] = '';
            }
            
            // Ensure cartItem exists and is a List, and normalize nested structures
            if (orderJson['cartItem'] == null || orderJson['cartItem'] is! List) {
              orderJson['cartItem'] = [];
            } else {
              // Normalize cartItem entries - handle nested sellerId and productId
              final cartItems = orderJson['cartItem'] as List;
              orderJson['cartItem'] = cartItems.map((item) {
                if (item is Map) {
                  Map<String, dynamic> normalizedItem = Map<String, dynamic>.from(item);
                  // Normalize sellerId if it's a Map
                  if (normalizedItem['sellerId'] is Map) {
                    final sellerIdMap = normalizedItem['sellerId'] as Map;
                    normalizedItem['sellerId'] = sellerIdMap['_id']?.toString() ?? '';
                  } else if (normalizedItem['sellerId'] == null) {
                    normalizedItem['sellerId'] = '';
                  }
                  return normalizedItem;
                }
                return item;
              }).toList();
            }
            
            // Handle createdAt - must be a parseable string
            if (orderJson['createdAt'] is String) {
              // Try to parse it to ensure it's valid
              try {
                DateTime.parse(orderJson['createdAt']);
              } catch (e) {
                customPrint('Error parsing createdAt, using current time: $e');
                orderJson['createdAt'] = DateTime.now().toIso8601String();
              }
            } else if (orderJson['createdAt'] == null) {
              customPrint('createdAt is null, using current time');
              orderJson['createdAt'] = DateTime.now().toIso8601String();
            } else {
              customPrint('createdAt is not a string, using current time');
              orderJson['createdAt'] = DateTime.now().toIso8601String();
            }
            
            // Handle updatedAt - must be a parseable string
            // If updatedAt is missing, use createdAt or current time
            if (orderJson['updatedAt'] is String) {
              // Try to parse it to ensure it's valid
              try {
                DateTime.parse(orderJson['updatedAt']);
              } catch (e) {
                customPrint('Error parsing updatedAt, using createdAt: $e');
                // Use createdAt if updatedAt is invalid
                orderJson['updatedAt'] = orderJson['createdAt'] ?? DateTime.now().toIso8601String();
              }
            } else if (orderJson['updatedAt'] == null) {
              customPrint('updatedAt is null, using createdAt or current time');
              // Use createdAt if available, otherwise use current time
              orderJson['updatedAt'] = orderJson['createdAt'] ?? DateTime.now().toIso8601String();
            } else {
              customPrint('updatedAt is not a string, using createdAt or current time');
              orderJson['updatedAt'] = orderJson['createdAt'] ?? DateTime.now().toIso8601String();
            }
            
            // Ensure numeric fields exist
            if (orderJson['totalPrice'] == null) {
              orderJson['totalPrice'] = 0;
            }
            if (orderJson['totalPriceAfterDiscount'] == null) {
              orderJson['totalPriceAfterDiscount'] = 0;
            }
            if (orderJson['itemsCount'] == null) {
              orderJson['itemsCount'] = 0;
            }
            
            customPrint('Attempting to parse order from JSON...');
            order = Order.fromJson(orderJson);
            customPrint('Successfully parsed order from attachmentData: ${order.id}');
          } catch (e, stackTrace) {
            customPrint('Error parsing order from attachmentData: $e');
            customPrint('Stack trace: $stackTrace');
          }
        } else {
          // orderid is a String (just the ID) - need to look it up in cached orders
          customPrint('OrderId value is not a Map, it is: ${orderIdValue.runtimeType}. Looking up in cached orders...');
        }
        
        // If we couldn't parse from attachmentData (or it's just a String ID), try to find it in cached orders
        if (order == null) {
          final orderIdString = orderId.toString();
          customPrint('Looking for order with ID: $orderIdString in cached orders');
          
          if (cachedOrders != null) {
            try {
              order = cachedOrders!.orders.firstWhere(
                (o) => o.id == orderIdString,
              );
              customPrint('Found order in cached orders: ${order.id}');
            } catch (e) {
              customPrint('Order not found in cached orders: $e');
              customPrint('Available order IDs: ${cachedOrders!.orders.map((o) => o.id).toList()}');
            }
          } else {
            customPrint('Cached orders is null, cannot look up order');
          }
        }
        
        if (order != null) {
          return _buildOrderCard(context, order, isSender);
        } else {
          // Show loading if we don't have cached orders yet
          if (cachedOrders == null) {
            return Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isSender 
                      ? const Color(0xffD5FF00).withOpacity(0.3)
                      : primaryColor.withOpacity(0.3),
                ),
              ),
              child: const Center(child: CircularProgressIndicator()),
            );
          }
          // Order not found - return empty widget
          return const SizedBox.shrink();
        }
      } catch (e) {
        customPrint('Error building order card: $e');
        return const SizedBox.shrink();
      }
    } 
    // Handle product attachment
    else if (attachmentType == 'product' && orderId != null && orderId.toString().isNotEmpty && productId != null && productId.toString().isNotEmpty) {
      try {
        Product? product;
        Order? order;
        
        // First, try to use the product and order data directly from attachmentData if they're full objects
        final productIdValue = attachmentData['productid'];
        final orderIdValue = attachmentData['orderid'];
        
        // Parse product from attachmentData if it's a Map
        if (productIdValue is Map) {
          try {
            product = Product.fromJson(Map<String, dynamic>.from(productIdValue));
          } catch (e) {
            customPrint('Error parsing product from attachmentData: $e');
          }
        }
        
        // Parse order from attachmentData if it's a Map
        if (orderIdValue is Map) {
          try {
            // Create a copy of the order data and normalize userId if it's a Map
            Map<String, dynamic> orderJson = Map<String, dynamic>.from(orderIdValue);
            
            // Normalize userId if it's a Map
            if (orderJson['userId'] is Map) {
              final userIdMap = orderJson['userId'] as Map;
              orderJson['userId'] = userIdMap['_id']?.toString() ?? '';
            } else if (orderJson['userId'] == null) {
              orderJson['userId'] = '';
            }
            
            // Ensure paymentMethod exists
            if (orderJson['paymentMethod'] == null) {
              orderJson['paymentMethod'] = '';
            }
            
            // Ensure status exists
            if (orderJson['status'] == null) {
              orderJson['status'] = '';
            }
            
            // Ensure cartItem exists and is a List, and normalize nested structures
            if (orderJson['cartItem'] == null || orderJson['cartItem'] is! List) {
              orderJson['cartItem'] = [];
            } else {
              // Normalize cartItem entries - handle nested sellerId and productId
              final cartItems = orderJson['cartItem'] as List;
              orderJson['cartItem'] = cartItems.map((item) {
                if (item is Map) {
                  Map<String, dynamic> normalizedItem = Map<String, dynamic>.from(item);
                  // Normalize sellerId if it's a Map
                  if (normalizedItem['sellerId'] is Map) {
                    final sellerIdMap = normalizedItem['sellerId'] as Map;
                    normalizedItem['sellerId'] = sellerIdMap['_id']?.toString() ?? '';
                  } else if (normalizedItem['sellerId'] == null) {
                    normalizedItem['sellerId'] = '';
                  }
                  return normalizedItem;
                }
                return item;
              }).toList();
            }
            
            // Handle createdAt - must be a parseable string
            if (orderJson['createdAt'] is String) {
              // Try to parse it to ensure it's valid
              try {
                DateTime.parse(orderJson['createdAt']);
              } catch (e) {
                orderJson['createdAt'] = DateTime.now().toIso8601String();
              }
            } else {
              orderJson['createdAt'] = DateTime.now().toIso8601String();
            }
            
            // Handle updatedAt - must be a parseable string
            if (orderJson['updatedAt'] is String) {
              // Try to parse it to ensure it's valid
              try {
                DateTime.parse(orderJson['updatedAt']);
              } catch (e) {
                orderJson['updatedAt'] = DateTime.now().toIso8601String();
              }
            } else {
              orderJson['updatedAt'] = DateTime.now().toIso8601String();
            }
            
            // Ensure numeric fields exist
            if (orderJson['totalPrice'] == null) {
              orderJson['totalPrice'] = 0;
            }
            if (orderJson['totalPriceAfterDiscount'] == null) {
              orderJson['totalPriceAfterDiscount'] = 0;
            }
            if (orderJson['itemsCount'] == null) {
              orderJson['itemsCount'] = 0;
            }
            
            order = Order.fromJson(orderJson);
          } catch (e, stackTrace) {
            customPrint('Error parsing order from attachmentData for product: $e');
            customPrint('Stack trace: $stackTrace');
          }
        }
        
        // If we couldn't parse from attachmentData, try to find them in cached orders
        if ((product == null || order == null) && cachedOrders != null) {
          final orderIdString = orderId.toString();
          final productIdString = productId.toString();
          
          try {
            // Find order if not already parsed
            Order? foundOrder = order;
            if (foundOrder == null) {
              foundOrder = cachedOrders!.orders.firstWhere(
                (o) => o.id == orderIdString,
              );
              order = foundOrder;
            }
            
            // Find product if not already parsed
            if (product == null) {
              final cartItem = foundOrder.cartItem.firstWhere(
                (item) => item.productId.id == productIdString,
              );
              product = cartItem.productId;
            }
          } catch (e) {
            customPrint('Product or order not found in cached orders: $e');
          }
        }
        
        if (product != null && order != null) {
          return _buildProductCard(context, product, order, isSender);
        } else {
          // Show loading if we don't have cached orders yet
          if (cachedOrders == null) {
            return Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isSender 
                      ? const Color(0xffD5FF00).withOpacity(0.3)
                      : primaryColor.withOpacity(0.3),
                ),
              ),
              child: const Center(child: CircularProgressIndicator()),
            );
          }
          // Product or order not found - return empty widget
          return const SizedBox.shrink();
        }
      } catch (e) {
        customPrint('Error building product card: $e');
        return const SizedBox.shrink();
      }
    }

    return const SizedBox.shrink();
  }

  Widget _buildOrderCard(BuildContext context, Order order, bool isSender) {
    // Get up to 4 product images from order
    final productImages = order.cartItem
        .where((item) => item.productId.imgCover.isNotEmpty)
        .take(4)
        .map((item) => "${ApiEndpoints.productUrl}/${item.productId.imgCover}")
        .toList();

    // Get order status
    final status = order.status;
    final statusText = status.isNotEmpty ? status : 'Pending';

    return GestureDetector(
      onTap: () async {
        try {
          // Validate order has required fields before navigation
          if (order.id.isEmpty) {
            customPrint('Cannot navigate: Order ID is empty');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Invalid order data'),
                duration: Duration(seconds: 2),
              ),
            );
            return;
          }
          
          // Validate cartItem is not empty (order detail view expects at least one item)
          if (order.cartItem.isEmpty) {
            customPrint('Cannot navigate: Order has no cart items');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Order has no items'),
                duration: Duration(seconds: 2),
              ),
            );
            return;
          }
          
          // Navigate to order details
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CustomerOrderDetailView(orderSellerResponse: order),
            ),
          );
        } catch (e, stackTrace) {
          customPrint('Error navigating to order details: $e');
          customPrint('Stack trace: $stackTrace');
          // Show error to user
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error opening order details: ${e.toString()}'),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSender 
                ? const Color(0xffD5FF00).withOpacity(0.3)
                : primaryColor.withOpacity(0.3),
            width: 1,
          ),
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
                  text: 'Order #${order.id.substring(order.id.length - 8)}',
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

  Widget _buildProductCard(
    BuildContext context,
    Product product,
    Order order,
    bool isSender,
  ) {
    final imageUrl = product.imgCover.isNotEmpty
        ? "${ApiEndpoints.productUrl}/${product.imgCover}"
        : '';

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          RoutesNames.customerProductDetailView,
          arguments: product,
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSender 
                ? const Color(0xffD5FF00).withOpacity(0.3)
                : primaryColor.withOpacity(0.3),
            width: 1,
          ),
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


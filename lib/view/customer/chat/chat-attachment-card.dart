import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/models/messages/ChatHistoryModel.dart';
import 'package:sugudeni/models/orders/GetAllOrdersCutomerModel.dart';
import 'package:sugudeni/models/orders/GetAllOrderSellerResponseModel.dart' as SellerOrderModel;
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/cached-network-image.dart';
import 'package:sugudeni/models/products/SimpleProductModel.dart';
import 'package:sugudeni/models/products/SellerIdProductReponseModel.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';
import 'package:sugudeni/view/customer/products/customer-specific-product-detail-view.dart';
import 'package:sugudeni/utils/global-functions.dart';

class ChatAttachmentCard extends StatelessWidget {
  final ChatMessage message;
  final bool isSender;
  final GetCustomerAllOrderResponseModel? cachedOrders;
  final SellerOrderModel.GetAllOrderSellerResponse? cachedSellerOrders;

  const ChatAttachmentCard({
    super.key,
    required this.message,
    required this.isSender,
    this.cachedOrders,
    this.cachedSellerOrders,
  });

  @override
  Widget build(BuildContext context) {
    // Check if message has attachment and attachmentData is not null
    if (message.attachment != true) {
      customPrint('ChatAttachmentCard: message.attachment is not true, returning empty');
      return const SizedBox.shrink();
    }
    
    if (message.attachmentData == null) {
      customPrint('ChatAttachmentCard: message.attachment is true but attachmentData is null!');
      customPrint('Message ID: ${message.id}, senderId: ${message.senderId}');
      // Show error message instead of empty
      return Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: MyText(
          text: 'Attachment data missing',
          size: 12.sp,
          color: Colors.red.shade700,
        ),
      );
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
            
            // Check if this is a seller order (has trackingStatus) or customer order (has status)
            final isSellerOrder = orderJson.containsKey('trackingStatus');
            
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
            
            // Handle status - seller orders use trackingStatus, customer orders use status
            if (isSellerOrder) {
              // Convert seller order to customer order format
              if (orderJson['trackingStatus'] != null) {
                orderJson['status'] = orderJson['trackingStatus'];
              } else {
                orderJson['status'] = '';
              }
            } else {
              // Ensure status exists for customer orders
              if (orderJson['status'] == null) {
                orderJson['status'] = '';
              }
            }
            
            // Ensure cartItem exists and is a List, and normalize nested structures
            if (orderJson['cartItem'] == null || orderJson['cartItem'] is! List) {
              orderJson['cartItem'] = [];
            } else {
              // Normalize cartItem entries - handle nested sellerId and productId
              // Filter out items with null or invalid productId
              final cartItems = orderJson['cartItem'] as List;
              orderJson['cartItem'] = cartItems.where((item) {
                // Filter out items with null productId
                if (item is Map) {
                  final productId = item['productId'];
                  return productId != null && productId is Map;
                }
                return false;
              }).map((item) {
                if (item is Map) {
                  Map<String, dynamic> normalizedItem = Map<String, dynamic>.from(item);
                  // Normalize sellerId if it's a Map
                  if (normalizedItem['sellerId'] is Map) {
                    final sellerIdMap = normalizedItem['sellerId'] as Map;
                    normalizedItem['sellerId'] = sellerIdMap['_id']?.toString() ?? '';
                  } else if (normalizedItem['sellerId'] == null) {
                    normalizedItem['sellerId'] = '';
                  }
                  // Ensure productId is a valid Map (not null) - already filtered above but double-check
                  if (normalizedItem['productId'] == null || normalizedItem['productId'] is! Map) {
                    return null; // Skip this item
                  }
                  return normalizedItem;
                }
                return null;
              }).where((item) => item != null).cast<Map<String, dynamic>>().toList();
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
            
            // Final validation: Ensure all cartItems have valid productId before parsing
            if (orderJson['cartItem'] is List) {
              final cartItems = orderJson['cartItem'] as List;
              orderJson['cartItem'] = cartItems.where((item) {
                if (item is Map) {
                  final productId = item['productId'];
                  return productId != null && productId is Map && (productId as Map).isNotEmpty;
                }
                return false;
              }).toList();
            }
            
            customPrint('Attempting to parse order from JSON...');
            customPrint('CartItem count after filtering: ${(orderJson['cartItem'] as List).length}');
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
          
          // Try seller orders first
          if (cachedSellerOrders != null && cachedSellerOrders!.orders != null) {
            try {
              final sellerOrder = cachedSellerOrders!.orders!.firstWhere(
                (o) => o.id == orderIdString,
              );
              // Convert seller order to customer order format for display
              // We'll create a compatible order object
              order = _convertSellerOrderToCustomerOrder(sellerOrder);
              customPrint('Found order in cached seller orders: ${order.id}');
            } catch (e) {
              customPrint('Order not found in cached seller orders: $e');
            }
          }
          
          // Try customer orders if not found in seller orders
          if (order == null && cachedOrders != null) {
            try {
              order = cachedOrders!.orders.firstWhere(
                (o) => o.id == orderIdString,
              );
              customPrint('Found order in cached customer orders: ${order.id}');
            } catch (e) {
              customPrint('Order not found in cached customer orders: $e');
              customPrint('Available order IDs: ${cachedOrders!.orders.map((o) => o.id).toList()}');
            }
          }
        }
        
        if (order != null) {
          return _buildOrderCard(context, order, isSender);
        } else {
          // Show loading if we don't have cached orders yet
          if (cachedOrders == null && cachedSellerOrders == null) {
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
    // For seller products, orderId may be empty string, but productId must be present
    else if (attachmentType == 'product' && productId != null && productId.toString().isNotEmpty) {
      try {
        Product? product;
        Order? order;
        
        // First, try to use the product and order data directly from attachmentData if they're full objects
        final productIdValue = attachmentData['productid'];
        final orderIdValue = attachmentData['orderid'];
        
        // Parse product from attachmentData if it's a Map
        if (productIdValue is Map) {
          try {
            // Normalize the product data before parsing
            Map<String, dynamic> productJson = Map<String, dynamic>.from(productIdValue);
            
            // Ensure category is a Map or null (not an object instance)
            if (productJson['category'] != null && productJson['category'] is! Map) {
              // If category is not a Map, try to convert it or set to null
              if (productJson['category'].toString().contains('Instance of')) {
                customPrint('Category is an object instance, setting to null');
                productJson['category'] = null;
              } else {
                productJson['category'] = null;
              }
            }
            
            // Ensure sellerId is a Map (required field)
            if (productJson['sellerId'] != null && productJson['sellerId'] is! Map) {
              // If sellerId is not a Map, try to convert it or create a minimal one
              if (productJson['sellerId'].toString().contains('Instance of')) {
                customPrint('SellerId is an object instance, creating minimal sellerId');
                productJson['sellerId'] = {
                  '_id': productJson['_id'] ?? '',
                  'firstname': '',
                  'lastname': '',
                };
              } else {
                // Try to extract ID if it's a string
                productJson['sellerId'] = {
                  '_id': productJson['sellerId'].toString(),
                  'firstname': '',
                  'lastname': '',
                };
              }
            } else if (productJson['sellerId'] == null) {
              // Create minimal sellerId if null
              productJson['sellerId'] = {
                '_id': productJson['_id'] ?? '',
                'firstname': '',
                'lastname': '',
              };
            }
            
            // Also check for 'sellerid' (lowercase) as alternative - Product.fromJson expects 'sellerid'
            if (productJson.containsKey('sellerid') && productJson['sellerid'] is Map) {
              // Keep sellerid (lowercase) as that's what Product.fromJson expects
              // Don't overwrite it with sellerId
            } else if (productJson.containsKey('sellerId') && productJson['sellerId'] is Map) {
              // If only sellerId (camelCase) exists, copy it to sellerid (lowercase)
              productJson['sellerid'] = productJson['sellerId'];
            }
            
            product = Product.fromJson(productJson);
            customPrint('Successfully parsed product from attachmentData (productIdValue is Map)');
          } catch (e, stackTrace) {
            customPrint('Error parsing product from attachmentData: $e');
            customPrint('Stack trace: $stackTrace');
            customPrint('Product data keys: ${productIdValue is Map ? (productIdValue as Map).keys.toList() : 'not a map'}');
          }
        }
        
        // Also check if there's a 'product' key in attachmentData with full product object
        // This is used for optimistic messages where we include the full product
        if (product == null && attachmentData.containsKey('product') && attachmentData['product'] is Map) {
          try {
            product = Product.fromJson(Map<String, dynamic>.from(attachmentData['product']));
            customPrint('Successfully parsed product from attachmentData (product key)');
          } catch (e) {
            customPrint('Error parsing product from attachmentData product key: $e');
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
        // For seller products, orderId may be empty, so we only need product
        final orderIdString = orderId?.toString() ?? '';
        final hasOrderId = orderIdString.isNotEmpty;
        
        if (product == null) {
          final productIdString = productId.toString();
          
          // If we have orderId, try to find in cached orders
          if (hasOrderId && cachedOrders != null) {
            try {
              // Find order if not already parsed
              Order? foundOrder = order;
              if (foundOrder == null) {
                foundOrder = cachedOrders!.orders.firstWhere(
                  (o) => o.id == orderIdString,
                );
                order = foundOrder;
              }
              
              // Find product in order
              final cartItem = foundOrder.cartItem.firstWhere(
                (item) => item.productId.id == productIdString,
              );
              product = cartItem.productId;
            } catch (e) {
              customPrint('Product or order not found in cached orders: $e');
            }
          }
        }
        
        // For seller products without orderId, we can still display if we have the product
        if (product != null) {
          // If we don't have an order, create a minimal one for display purposes
          final displayOrder = order ?? Order(
            id: '',
            userId: '',
            paymentMethod: '',
            isPaid: false,
            status: '',
            totalPrice: 0,
            totalPriceAfterDiscount: 0,
            itemsCount: 0,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            cartItem: [],
          );
          return _buildProductCard(context, product, displayOrder, isSender);
        } else {
          // Show loading if we don't have the product yet
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
                  if (order.id.isNotEmpty)
                    MyText(
                      text: 'Order #${order.id.length > 8 ? order.id.substring(order.id.length - 8) : order.id}',
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

  // Helper method to convert seller order to customer order format for display
  Order _convertSellerOrderToCustomerOrder(dynamic sellerOrder) {
    // Import the seller Order type with an alias to avoid conflict
    // Since both use the same name, we need to handle this carefully
    try {
      // The seller order has different structure, so we need to adapt it
      // Create cart items compatible with customer order format
      final sellerOrderTyped = sellerOrder as SellerOrderModel.Order; // This will be the seller Order type
      final customerCartItems = sellerOrderTyped.cartItem.map((item) {
        // Convert seller cart item to customer cart item format
        final product = item.product ?? Product(
          sku: '',
          supplierName: '',
          brand: '',
          upc: '',
          condition: 'new',
          shippingPrice: 0.0,
          manufacturerProdId: '',
          shippingLength: '',
          shippingWidth: '',
          shippingHeight: '',
          salesTaxState: '',
          salesTaxPct: '',
          shipFrom: '',
          shipTo: '',
          returnPolicy: '',
          avgShippingDays: '',
          w2bFee: 0.0,
          attributes: '',
          handlingFee: 0.0,
          mapPrice: 0.0,
          wholesale: 0.0,
          bulk: false,
          saleDiscount: 0.0,
          featured: false,
          ratingAvg: 0.0,
          ratingCount: 0,
          id: '',
          sellerId: SellerIdProductResponseModel(
            id: '',
            firstname: '',
            lastname: '',
            adminPrivileges: [],
            appleId: '',
            twitterId: '',
            fcmToken: [],
            driverStatus: '',
            rejectionReason: '',
            pickups: [],
            name: '',
            phone: '',
            email: '',
            password: '',
            role: '',
            isActive: false,
            verified: false,
            blocked: false,
            emailVerified: false,
            phoneVerified: false,
            profilePic: '',
            licenseNumber: '',
            bikeRegistrationNumber: '',
            licenseFront: '',
            licenseBack: '',
            wishlist: [],
            addresses: [],
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            walletId: '',
          ),
          title: 'Unknown Product',
          imgCover: '',
          weight: '',
          color: '',
          size: '',
          images: [],
          description: '',
          price: 0.0,
          priceAfterDiscount: 0.0,
          quantity: 0,
          sold: 0,
          category: null,
          subcategory: null,
          status: '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          v: 0,
          reviews: [],
        );
        
        return CartItem(
          sellerId: item.sellerId,
          productId: product,
          quantity: item.quantity,
          price: item.price,
          totalProductDiscount: item.totalProductDiscount,
          priceAfterDiscount: item.priceAfterDiscount,
          trackingId: '',
          status: sellerOrderTyped.trackingStatus,
          isDelivered: sellerOrderTyped.isDelivered,
          failureReason: sellerOrderTyped.failureReason,
          deliveredAt: sellerOrderTyped.deliveredAt,
          estimatedArrival: sellerOrderTyped.estimatedArrival,
          currentLocation: sellerOrderTyped.currentLocation,
          currentLocationLatLong: sellerOrderTyped.currentLocationLatLong,
          id: item.id,
        );
      }).toList();

      // Return customer order format (using Order from GetAllOrdersCutomerModel)
      return Order(
        id: sellerOrderTyped.id,
        userId: sellerOrderTyped.userId?.id ?? '',
        paymentMethod: sellerOrderTyped.paymentMethod,
        isPaid: sellerOrderTyped.isPaid,
        status: sellerOrderTyped.trackingStatus,
        totalPrice: sellerOrderTyped.totalPrice,
        totalPriceAfterDiscount: sellerOrderTyped.totalPriceAfterDiscount,
        itemsCount: sellerOrderTyped.itemsCount,
        createdAt: sellerOrderTyped.createdAt,
        updatedAt: sellerOrderTyped.updatedAt,
        cartItem: customerCartItems,
      );
    } catch (e) {
      customPrint('Error converting seller order: $e');
      // Return a minimal order if conversion fails
      final sellerOrderTyped = sellerOrder as SellerOrderModel.Order;
      return Order(
        id: sellerOrderTyped.id,
        userId: sellerOrderTyped.userId?.id ?? '',
        paymentMethod: sellerOrderTyped.paymentMethod,
        isPaid: sellerOrderTyped.isPaid,
        status: sellerOrderTyped.trackingStatus,
        totalPrice: sellerOrderTyped.totalPrice,
        totalPriceAfterDiscount: sellerOrderTyped.totalPriceAfterDiscount,
        itemsCount: sellerOrderTyped.itemsCount,
        createdAt: sellerOrderTyped.createdAt,
        updatedAt: sellerOrderTyped.updatedAt,
        cartItem: [],
      );
    }
  }
}


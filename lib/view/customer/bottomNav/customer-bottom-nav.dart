import 'dart:convert';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/providers/bottom_navigation_provider.dart';
import 'package:sugudeni/providers/chatSocketProvider/chat-socket-provider.dart';
import 'package:sugudeni/providers/loading-provider.dart';
import 'package:sugudeni/repositories/orders/customer-order-repository.dart';
import 'package:sugudeni/services/firebase-messaging-service.dart';
import 'package:sugudeni/utils/constants/fonts.dart';
import 'package:sugudeni/view/customer/account/customer-account-view.dart';
import 'package:sugudeni/view/customer/account/rating-bottom-sheet.dart';
import 'package:sugudeni/view/customer/cart/customer-cart-view.dart';
import 'package:sugudeni/view/customer/categories/customer-categories-view.dart';
import 'package:sugudeni/view/customer/home/customer-home-view.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/orders/GetAllOrdersCutomerModel.dart';
import '../../../utils/constants/app-assets.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/global-functions.dart';


class CustomerBottomNavBar extends StatefulWidget {
  const CustomerBottomNavBar({super.key});

  @override
  State<CustomerBottomNavBar> createState() => _CustomerBottomNavBarState();
}

class _CustomerBottomNavBarState extends State<CustomerBottomNavBar> {
  /// Controller to handle bottom nav bar and also handles initial page
  late NotchBottomBarController _controller;

  int maxCount = 4;

  @override
  void initState() {
    // TODO: implement initState
    context.read<ChatSocketProvider>().connectSocketInInitial(context);

    // Initialize controller with provider's current index
    final bottomNavProvider = context.read<BottomNavigationProvider>();
    _controller = NotchBottomBarController(index: bottomNavProvider.currentIndex);

    // Set up notification handler
    _setupNotificationHandler();

    super.initState();
  }
  
  void _setupNotificationHandler() {
    final messagingService = FirebaseMessagingService();
    
    // Set up handler for notification taps
    messagingService.onMessageTap = (RemoteMessage message) {
      customPrint('========== NOTIFICATION TAP HANDLER ==========');
      customPrint('Notification title: ${message.notification?.title}');
      customPrint('Notification data: ${message.data}');
      
      // Check if notification is for delivery rating
      // Format: activityType: "delivery-rating" and activityData.trackingId
      final activityType = message.data['activityType'] ?? 
                          message.data['activity_type'] ?? 
                          message.data['activityType'];
      
      // Also check title as fallback
      final notificationTitle = message.notification?.title ?? '';
      final isReviewDelivery = (activityType == 'delivery-rating') ||
                               (notificationTitle.toLowerCase().contains('review delivery'));
      
      if (isReviewDelivery) {
        customPrint('Opening review bottom sheet for delivery...');
        
        // Extract orderId from activityData
        String? orderId;
        
        // Try to get from activityData object
        if (message.data.containsKey('activityData')) {
          final activityData = message.data['activityData'];
          if (activityData is Map) {
            orderId = activityData['orderId']?.toString() ?? 
                     activityData['order_id']?.toString() ??
                     activityData['orderID']?.toString();
          } else if (activityData is String) {
            // If activityData is a JSON string, try to parse it
            try {
              final parsed = jsonDecode(activityData);
              if (parsed is Map) {
                orderId = parsed['orderId']?.toString() ?? 
                         parsed['order_id']?.toString() ??
                         parsed['orderID']?.toString();
              }
            } catch (e) {
              customPrint('Could not parse activityData as JSON: $e');
            }
          }
        }
        
        // Fallback: try direct keys
        if (orderId == null || orderId.isEmpty) {
          orderId = message.data['orderId']?.toString() ?? 
                   message.data['order_id']?.toString() ??
                   message.data['orderID']?.toString();
        }
        
        if (orderId != null && orderId.isNotEmpty) {
          customPrint('Order ID from notification: $orderId');
          
          // Use post frame callback to ensure context is available
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _openReviewBottomSheetByOrderId(context, orderId!);
            }
          });
        } else {
          customPrint('⚠️  WARNING: No orderId found in notification data');
          customPrint('Available data keys: ${message.data.keys}');
          customPrint('activityData type: ${message.data['activityData']?.runtimeType}');
          if (mounted) {
            showSnackbar(context, 'Order not found', color: redColor);
          }
        }
      } else {
        customPrint('Notification is not for review delivery, ignoring...');
      }
      customPrint('===========================================');
    };
  }
  
  Future<void> _openReviewBottomSheetByOrderId(BuildContext context, String orderId) async {
    customPrint('Opening review bottom sheet with orderId: $orderId');
    
    final loadingProvider = Provider.of<LoadingProvider>(context, listen: false);
    
    try {
      // Show loading
      loadingProvider.setLoading(true);
      
      // Fetch all orders to find the specific order by orderId
      final orderResponse = await CustomerOrderRepository.allCustomersOrders(context);
      
      // Find the order with matching orderId
      Order? targetOrder;
      CartItem? targetCartItem;
      
      for (var order in orderResponse.orders) {
        if (order.id == orderId) {
          targetOrder = order;
          // Get the first cart item for product info
          if (order.cartItem.isNotEmpty) {
            targetCartItem = order.cartItem.first;
          }
          break;
        }
      }
      
      loadingProvider.setLoading(false);
      
      if (targetOrder == null) {
        customPrint('⚠️  Order not found with orderId: $orderId');
        if (context.mounted) {
          showSnackbar(context, 'Order not found', color: redColor);
        }
        return;
      }
      
      if (targetCartItem == null) {
        customPrint('⚠️  No cart items found in order');
        if (context.mounted) {
          showSnackbar(context, 'Order not found', color: redColor);
        }
        return;
      }
      
      final product = targetCartItem.productId;
      
      if (product == null) {
        customPrint('⚠️  Product not found in cart item');
        if (context.mounted) {
          showSnackbar(context, 'Order not found', color: redColor);
        }
        return;
      }
      
      customPrint('Found order and product info:');
      customPrint('  Order ID: ${targetOrder.id}');
      customPrint('  Product ID: ${product.id}');
      customPrint('  Product Title: ${product.title}');
      customPrint('  Product imgCover: ${product.imgCover}');
      customPrint('  Product bulk: ${product.bulk}');
      
      // Show bottom sheet with order and product info
      if (context.mounted) {
        showModalBottomSheet(
          backgroundColor: Colors.white,
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: RatingBottomSheet(
                orderId: targetOrder!.id,
                productId: product.id,
                title: product.title,
                img: product.imgCover,
                bulk: product.bulk,
                isForDelivery: true,
              ),
            );
          },
        );
      }
    } catch (e) {
      loadingProvider.setLoading(false);
      customPrint('❌ Error fetching order details: $e');
      if (context.mounted) {
        showSnackbar(context, 'Order not found', color: redColor);
      }
    }
  }
  @override
  void dispose() {
    ///NavigationControllers.controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// widget list - using IndexedStack to preserve state
    final List<Widget> bottomBarPages = [
      const CustomerHomeView(),
      const CustomerCategoriesView(),
      const CustomerCartView(),
      const CustomerAccountView()
    ];

    return Consumer<BottomNavigationProvider>(
      builder: (context, bottomNavProvider, child) {
        // Update controller when provider index changes
        _controller = NotchBottomBarController(index: bottomNavProvider.currentIndex);

        return Scaffold(
          body: IndexedStack(
            index: bottomNavProvider.currentIndex,
            children: bottomBarPages,
          ),
      extendBody: true,
      bottomNavigationBar: (bottomBarPages.length <= maxCount)
          ? AnimatedNotchBottomBar(
        /// Provide NotchBottomBarController
        notchBottomBarController: _controller,
        color: primaryColor,
        showLabel: true,
        textOverflow: TextOverflow.visible,
        maxLine: 1,
        shadowElevation: 5,
        kBottomRadius: 10.sp,


        // notchShader: const SweepGradient(
        //   startAngle: 0,
        //   endAngle: pi / 2,
        //   colors: [Colors.red, Colors.green, Colors.orange],
        //   tileMode: TileMode.mirror,
        // ).createShader(Rect.fromCircle(center: Offset.zero, radius: 8.0)),
        notchColor: primaryColor,
        /// restart app if you change removeMargins
        removeMargins: false,
        showShadow: false,
        durationInMilliSeconds: 300,
        itemLabelStyle: TextStyle(fontSize: 10.sp,color: whiteColor,fontWeight: FontWeight.w500,fontFamily: AppFonts.jost),
        elevation: 1,
        bottomBarItems:  [
          BottomBarItem(

            inActiveItem: Image.asset(AppAssets.customerHomeBottomIcon,color: whiteColor,),
            activeItem: Image.asset(AppAssets.customerHomeBottomIcon,color: whiteColor),
            itemLabel: AppLocalizations.of(context)!.home,
          ),
          BottomBarItem(
            inActiveItem: Image.asset(AppAssets.categoriesBottomIcon),
            activeItem: Image.asset(AppAssets.categoriesBottomIcon),
            itemLabel: AppLocalizations.of(context)!.categories,
          ),
          BottomBarItem(
            inActiveItem: Image.asset(AppAssets.cartBottomIcon),
            activeItem: Image.asset(AppAssets.cartBottomIcon),
            itemLabel: AppLocalizations.of(context)!.cart,
          ),
          BottomBarItem(
            inActiveItem: Image.asset(AppAssets.profileBottomIcon),
            activeItem: Image.asset(AppAssets.profileBottomIcon),
            itemLabel: AppLocalizations.of(context)!.account,
          ),

        ],
        onTap: (index) {
          context.read<BottomNavigationProvider>().setIndex(index);
        },
        kIconSize: 18.sp,
      )
          : null,
        );
      },
    );
  }
}

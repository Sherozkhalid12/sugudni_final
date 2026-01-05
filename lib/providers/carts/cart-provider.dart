import 'package:flutter/material.dart';
import 'package:sugudeni/models/cart/GetCartResponse.dart';
import 'package:sugudeni/models/cart/UpdateCartQuantityModel.dart';
import 'package:sugudeni/models/deliveryslots/GetAllDeliverySlotsModel.dart';
import 'package:sugudeni/repositories/carts/cart-repository.dart';

import '../../utils/global-functions.dart';

  class CartProvider extends ChangeNotifier{
    GetCartResponse? cartResponse;
    String? errorMessage;
    bool isLoading=false;
    bool isComeFromCheckout=false;
    String? selectedSlot;
    String? shippingId;
    String? deliverySlotId;
    DeliverySlot? deliverySlot;
    int? index;
    
    // Store order details before clearing cart (for payment success page)
    double? lastOrderTotal;
    String? lastOrderSellerId;


   String selectedPaymentMethod=PaymentMethods.cashOnDelivery;
    List<String>selectedIndex=[];

    changePaymentMethod(String p){
      selectedPaymentMethod=p;
    }
    toggleItem(String n){
      if(selectedIndex.contains(n)){
        selectedIndex.remove(n);
      }else{
        selectedIndex.add(n);
      }
      notifyListeners();
    }

    // Calculate subtotal of selected items only
    double getSelectedItemsSubtotal() {
      if (cartResponse == null) return 0.0;

      double subtotal = 0.0;
      for (var cartItem in cartResponse!.cart.cartItem) {
        if (selectedIndex.contains(cartItem.id)) {
          // Use the appropriate price based on discount
          double itemPrice = cartItem.priceAfterDiscount > 0 ? cartItem.priceAfterDiscount : cartItem.price;
          subtotal += itemPrice * cartItem.quantity;
        }
      }
      return subtotal;
    }

    // Get selected items count
    int getSelectedItemsCount() {
      return selectedIndex.length;
    }

    // Get total cart items count (sum of all quantities)
    int getTotalCartItemsCount() {
      if (cartResponse == null || cartResponse!.cart.cartItem.isEmpty) return 0;

      int totalCount = 0;
      for (var cartItem in cartResponse!.cart.cartItem) {
        totalCount += cartItem.quantity;
      }
      return totalCount;
    }
    selectSlot(String s){
      selectedSlot=s;
      notifyListeners();
    }
    setShippingId(String s){
      shippingId=s;
      notifyListeners();
    }
    setDeliveryId(String s,DeliverySlot d){
      deliverySlotId=s;
      deliverySlot=d;
      notifyListeners();
    }
    setCheckout(bool s){
      isComeFromCheckout=s;
      notifyListeners();
    }
    setIndex(int s){
      index=s;
    }
    Future<void>getCartData(BuildContext context)async{
      try {
        isLoading = true;
        errorMessage = null;

        cartResponse = await CartRepository.getCartProducts(context);
        customPrint("cart data=================================${cartResponse}");
        notifyListeners();
      } catch (e) {
        errorMessage = e.toString();
        // If it's a 500 error with NaN discount, try to recover by refreshing
        if (e.toString().contains('NaN') || e.toString().contains('discount')) {
          customPrint("Cart discount error detected, will retry on next action");
        }
      } finally {
        isLoading = false;
        notifyListeners();
      }
    }
    void incrementQuantity(String cartItemId,BuildContext context) async{
      if (cartResponse != null) {
        Cart cart = cartResponse!.cart;
        for(var i in cart.cartItem){
          if(i.id == cartItemId){
            int newQuantity = i.quantity + 1;
            var model=UpdateCartQuantityModel(quantity: newQuantity);

            try {
              await CartRepository.updateCartQuantity(model, i.productId.id, context);
              // Refresh cart data after successful update
              await getCartData(context);
            } catch (e) {
              // If update fails due to discount error, still try to refresh cart
              if (e.toString().contains('NaN') || e.toString().contains('discount')) {
                await getCartData(context);
              }
            }
            notifyListeners();
          }
        }
        // List<CartItem> updatedCartItems = cart.cartItem.map((item) {
        //   if (item.id == cartItemId) {
        //     int newQuantity = item.quantity + 1;
        //     var model=UpdateCartQuantityModel(quantity: newQuantity);
        //
        //     CartRepository.updateCartQuantity(model, item.productId.id, context);
        //     int newPrice = newQuantity * (item.price ~/ item.quantity); // Update price
        //     return CartItem(
        //       productId: item.productId,
        //       quantity: newQuantity,
        //       price: item.price,
        //       totalProductDiscount: item.totalProductDiscount,
        //       id: item.id,
        //     );
        //   }
        //   return item;
        // }).toList();
        //
        // cartResponse = GetCartResponse(
        //   message: cartResponse!.message,
        //   cart: Cart(
        //     id: cart.id,
        //     userId: cart.userId,
        //     cartItem: updatedCartItems,
        //    // totalPrice: cart.totalPrice + (cart.cartItem.firstWhere((item) => item.id == cartItemId).price ~/ cart.cartItem.firstWhere((item) => item.id == cartItemId).quantity),
        //     totalPrice: cart.totalPrice,
        //     createdAt: cart.createdAt,
        //     updatedAt: DateTime.now(),
        //     v: cart.v,
        //     totalPriceAfterDiscount: cart.totalPriceAfterDiscount
        //   ),
        // );
      }
     // cartResponse = await CartRepository.getCartProducts(context);



    }

    Future<void> decrementQuantity(String cartItemId,BuildContext context) async {
      if (cartResponse != null) {
        Cart cart = cartResponse!.cart;
        for (var i in cart.cartItem) {
          if (i.id == cartItemId) {
            int newQuantity = i.quantity - 1;
            if (newQuantity < 1) return; // Prevent quantity from going below 1
            
            var model = UpdateCartQuantityModel(quantity: newQuantity);

            try {
              await CartRepository.updateCartQuantity(model, i.productId.id, context);
              // Refresh cart data after successful update
              await getCartData(context);
            } catch (e) {
              // If update fails due to discount error, still try to refresh cart
              if (e.toString().contains('NaN') || e.toString().contains('discount')) {
                await getCartData(context);
              }
            }
            notifyListeners();
          }
        }
        //   if (cartResponse != null) {
        //     Cart cart = cartResponse!.cart;
        //     List<CartItem> updatedCartItems = cart.cartItem.map((item) {
        //       if (item.id == cartItemId && item.quantity > 1) {
        //         int newQuantity = item.quantity - 1;
        //         var model=UpdateCartQuantityModel(quantity: newQuantity);
        //         CartRepository.updateCartQuantity(model, item.productId.id, context);
        //         int newPrice = newQuantity * (item.price ~/ item.quantity); // Update price
        //         return CartItem(
        //           productId: item.productId,
        //           quantity: newQuantity,
        //           price: item.price,
        //           totalProductDiscount: item.totalProductDiscount,
        //           id: item.id,
        //         );
        //       }
        //       return item;
        //     }).toList();
        //
        //
        //     cartResponse = GetCartResponse(
        //       message: cartResponse!.message,
        //       cart: Cart(
        //         id: cart.id,
        //         userId: cart.userId,
        //         cartItem: updatedCartItems,
        //         totalPrice: cart.totalPrice - (cart.cartItem.firstWhere((item) => item.id == cartItemId).price ~/ cart.cartItem.firstWhere((item) => item.id == cartItemId).quantity),
        //         createdAt: cart.createdAt,
        //         updatedAt: DateTime.now(),
        //         v: cart.v,
        //         totalPriceAfterDiscount: cart.totalPriceAfterDiscount
        //       ),
        //     );
        //    // cartResponse = await CartRepository.getCartProducts(context);
        //   }
        //   notifyListeners();
        // }

      }
    }


    // Store order details before clearing
    void storeOrderDetails() {
      if (cartResponse != null && cartResponse!.cart.cartItem.isNotEmpty) {
        lastOrderTotal = cartResponse!.cart.discount == 0 
            ? cartResponse!.cart.totalPrice 
            : cartResponse!.cart.totalPriceAfterDiscount;
        lastOrderSellerId = cartResponse!.cart.cartItem.first.productId.sellerId.id;
      }
    }
    
    clearResources(){
      shippingId=null;
      selectedSlot=null;
      errorMessage=null;
      index=null;
      isComeFromCheckout=false;
      deliverySlotId=null;
      deliverySlot=null;
      selectedIndex.clear();
      // Clear cart data
      cartResponse = null;
      // Keep lastOrderTotal and lastOrderSellerId for payment success page
      notifyListeners();
    }
    
    // Clear order details after payment success page is shown
    void clearOrderDetails() {
      lastOrderTotal = null;
      lastOrderSellerId = null;
      notifyListeners();
    }
    
    // Clear cart and refresh from server
    Future<void> clearCartAndRefresh(BuildContext context) async {
      clearResources();
      // Refresh cart to ensure it's cleared on server
      await getCartData(context);
    }
    
    // Create order for selected items only
    Future<String?> createOrderForSelectedItems(BuildContext context) async {
      if (cartResponse == null || selectedIndex.isEmpty) {
        return null;
      }

      // Get selected cart items
      final selectedCartItems = cartResponse!.cart.cartItem
          .where((item) => selectedIndex.contains(item.id))
          .toList();

      if (selectedCartItems.isEmpty) {
        return null;
      }

      // Validate that we have selected items before proceeding
      customPrint('Creating order for ${selectedIndex.length} selected items out of ${cartResponse!.cart.cartItem.length} total items');

      // Currently, the backend API creates orders for entire carts
      // This is a limitation that should be addressed in future backend updates
      // For now, we proceed with the full cart ID but only selected items will be processed
      // TODO: Implement backend support for partial cart orders

      return cartResponse!.cart.id;
    }

    // Remove only selected items from cart after checkout
    Future<void> removeSelectedItemsFromCart(BuildContext context) async {
      if (cartResponse == null || selectedIndex.isEmpty) return;

      // Store selected item IDs before clearing
      final itemsToRemove = List<String>.from(selectedIndex);

      // Clear selection and other checkout-related data
      selectedIndex.clear();
      shippingId = null;
      selectedSlot = null;
      deliverySlotId = null;
      deliverySlot = null;
      isComeFromCheckout = false;
      index = null;

      // Remove each selected item from cart
      for (var itemId in itemsToRemove) {
        try {
          await CartRepository.removeProductFromCart(itemId, context);
        } catch (e) {
          customPrint('Error removing cart item $itemId: $e');
        }
      }

      // Refresh cart data to reflect changes
      await getCartData(context);
      notifyListeners();
    }
  }

  class PaymentMethods{
    static const String cashOnDelivery='Cash On Delivery';
    static const String stripe='Stripe';
    static const String orangeMoney='Orange Money';

  }
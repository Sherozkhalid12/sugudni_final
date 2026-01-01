import 'package:flutter/material.dart';
import 'package:sugudeni/models/wishlist/AddWishListModel.dart';
import 'package:sugudeni/models/wishlist/GetAllWishlistResponseModel.dart';
import 'package:sugudeni/repositories/wishlist/wishlist-repository.dart';

class WishlistProvider extends ChangeNotifier {
  GetAllWishlistResponseModel? wishlistResponse;
  String? errorMessage;
  bool isLoading = false;

  /// Get all wishlist products
  Future<void> getWishlistProducts(BuildContext context) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      wishlistResponse = await WishlistRepository.getWishlistProducts(context);
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Add product to wishlist
  Future<bool> addToWishlist(String productId, BuildContext context) async {
    try {
      var model = AddToWishlistModel(productId: productId);
      await WishlistRepository.addProductToWishlist(model, context);

      // Refresh wishlist after adding
      await getWishlistProducts(context);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Remove product from wishlist
  Future<bool> removeFromWishlist(String productId, BuildContext context) async {
    try {
      var model = AddToWishlistModel(productId: productId);
      await WishlistRepository.removeFromWishlist(model, context);

      // Refresh wishlist after removing
      await getWishlistProducts(context);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Check if product is in wishlist
  bool isProductInWishlist(String productId) {
    if (wishlistResponse == null) return false;
    return wishlistResponse!.getAllUserWishList.any((product) => product.id == productId);
  }

  /// Toggle wishlist status (add if not present, remove if present)
  Future<bool> toggleWishlist(String productId, BuildContext context) async {
    if (isProductInWishlist(productId)) {
      return await removeFromWishlist(productId, context);
    } else {
      return await addToWishlist(productId, context);
    }
  }

  /// Clear wishlist data
  void clearWishlist() {
    wishlistResponse = null;
    errorMessage = null;
    isLoading = false;
    notifyListeners();
  }
}

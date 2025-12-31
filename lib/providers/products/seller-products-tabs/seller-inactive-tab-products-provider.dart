import 'package:flutter/material.dart';
import 'package:sugudeni/utils/product-status.dart';

import '../../../models/products/SellerProductListResponse.dart';
import '../../../models/products/SimpleProductModel.dart';
import '../../../repositories/products/seller-product-repository.dart';


class SellerInActiveTabProductProvider extends ChangeNotifier {
  List<Product> productList = [];
  bool isLoading = false;
  bool hasMoreData = true;
  int currentPage = 1;
  String errorText = '';

  void fetchInActiveProducts(BuildContext context) async {
    if (isLoading || !hasMoreData) return;

    isLoading = true;
    errorText = '';
    // notifyListeners();

    try {
      var response = await SellerProductRepository.allSellerProductsUsingPagination(context, ProductStatus.inactive,currentPage);
      List<Product> newProducts = response.getAllProducts.where((d) => d.status == ProductStatus.inactive).toList();

      if (newProducts.isNotEmpty) {
        productList.addAll(newProducts);
        currentPage++;
      } else {
        hasMoreData = false;
      }
    } catch (e) {
      errorText = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  /// Automatically fetches more data if content height is too small
  void autoLoadMoreIfNeeded(BuildContext context, double screenHeight, double itemHeight) {
    if (!isLoading && hasMoreData) {
      double totalListHeight = productList.length * itemHeight;
      if (totalListHeight < screenHeight) {
        fetchInActiveProducts(context);
      }
    }
  }

  checkMoreData(){
    isLoading = false;
    hasMoreData = true;
    notifyListeners();
  }
  void removeProductById(String productId) {
    productList.removeWhere((product) => product.id == productId);
    notifyListeners();
  }
  void updateProductPrice(String productId, double newPrice) {
    int index = productList.indexWhere((product) => product.id == productId);
    if (index != -1) {
      productList[index] = productList[index].copyWith(price: newPrice);
      notifyListeners();
    }
  }
  void updateProductStock(String productId, int newPrice) {
    int index = productList.indexWhere((product) => product.id == productId);
    if (index != -1) {
      productList[index] = productList[index].copyWith(quantity: newPrice);
      notifyListeners();
    }
  }
  Future<void> refreshProducts(BuildContext context) async {
    isLoading = true;
    errorText = '';
    hasMoreData = true;
    currentPage = 1;
    productList.clear();
    notifyListeners();

    try {
      var response = await SellerProductRepository.allSellerProductsUsingPagination(context,ProductStatus.inactive, currentPage);
      List<Product> newProducts = response.getAllProducts.where((d) => d.status == ProductStatus.inactive).toList();

      if (newProducts.isNotEmpty) {
        productList.addAll(newProducts);
        currentPage++;
      } else {
        hasMoreData = false;
      }
    } catch (e) {
      errorText = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  void addProduct(Product product) {
    productList.add(product);
    notifyListeners();
  }
  void clearResources() {
    productList.clear();
    isLoading = false;
    hasMoreData = true;
    currentPage = 1;
    errorText = '';
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:sugudeni/models/products/SpecificProductResponse.dart';
import 'package:sugudeni/repositories/products/product-repository.dart';
import 'package:sugudeni/utils/product-status.dart';
import '../../../models/products/SellerProductListResponse.dart';
import '../../../models/products/SimpleProductModel.dart';
import '../../../repositories/products/seller-product-repository.dart';

class SellerOutOfStockTabProductProvider extends ChangeNotifier {
  List<Product> productList = [];
  List<Product> filteredProductList = [];

  bool isLoading = false;
  bool hasMoreData = true;
  int currentPage = 1;
  String errorText = '';
  String queryText = '';

  /// Update search query and filter list
  void changeQuery(String value) {
    queryText = value;
    _filterProducts();
    notifyListeners();
  }

  /// Apply search filter based on title
  void _filterProducts() {
    if (queryText.isEmpty) {
      filteredProductList = List.from(productList);
    } else {
      filteredProductList = productList
          .where((product) => product.title.toLowerCase().contains(queryText.toLowerCase()))
          .toList();
    }
  }


  // List<Product> get filteredProductLists {
  //   if (queryText.isEmpty) {
  //     return productList;
  //   }
  //   return productList.where((product) {
  //     return product.title.toLowerCase().contains(queryText.toLowerCase());
  //   }).toList();
  // }

  /// Fetch Products
  void fetchActiveProducts(BuildContext context) async {
    if (isLoading || !hasMoreData) return;

    isLoading = true;
    errorText = '';

    try {
      var response = await SellerProductRepository.allSellerProductsUsingPagination(context, ProductStatus.outofstock,currentPage);
      List<Product> newProducts = response.getAllProducts.where((d) => d.status == ProductStatus.outofstock).toList();

      if (newProducts.isNotEmpty) {
        productList.addAll(newProducts);
        currentPage++;
        _filterProducts(); // Apply filter after fetching data
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

  /// Automatically fetch more data if content height is too small
  void autoLoadMoreIfNeeded(BuildContext context, double screenHeight, double itemHeight) {
    if (!isLoading && hasMoreData) {
      double totalListHeight = productList.length * itemHeight;
      if (totalListHeight < screenHeight) {
        fetchActiveProducts(context);
      }
    }
  }

  /// Reset Loading States
  void checkMoreData() {
    isLoading = false;
    hasMoreData = true;
    notifyListeners();
  }

  /// Remove Product by ID
  void removeProductById(String productId) {
    productList.removeWhere((product) => product.id == productId);
    _filterProducts(); // Reapply filter after removal
    notifyListeners();
  }

  /// Update Product Price
  void updateProductPrice(String productId, double newPrice) {
    int index = productList.indexWhere((product) => product.id == productId);
    if (index != -1) {
      productList[index] = productList[index].copyWith(price: newPrice);
      _filterProducts(); // Reapply filter after update
      notifyListeners();
    }
  }

  /// Update Product Stock
  void updateProductStock(String productId, int newQuantity) {
    int index = productList.indexWhere((product) => product.id == productId);
    if (index != -1) {
      productList[index] = productList[index].copyWith(quantity: newQuantity);
      _filterProducts(); // Reapply filter after update
      notifyListeners();
    }
  }

  /// Add a Product
  void addProduct(Product product) {
    productList.add(product);
    _filterProducts(); // Reapply filter after addition
    notifyListeners();
  }
  Future<void> getSpecificProduct(String id, BuildContext context) async {
    SpecificProductResponse response = await ProductRepository.specificProduct(id, context);
    Product? updatedProduct = response.getSpecificProduct; // Assuming response contains a Product object


    int index = filteredProductList.indexWhere((product) => product.id == id);

    if (index != -1) {
      filteredProductList[index] = updatedProduct!;
    } else {
      filteredProductList.add(updatedProduct!);
    }
    notifyListeners();
  }
  /// Refresh Product List
  Future<void> refreshProducts(BuildContext context) async {
    isLoading = true;
    errorText = '';
    hasMoreData = true;
    currentPage = 1;
    productList.clear();
    notifyListeners();

    try {
      var response = await SellerProductRepository.allSellerProductsUsingPagination(context,ProductStatus.outofstock, currentPage);
      List<Product> newProducts = response.getAllProducts.where((d) => d.status == ProductStatus.outofstock).toList();

      if (newProducts.isNotEmpty) {
        productList.addAll(newProducts);
        currentPage++;
        _filterProducts(); // Reapply filter after fetching
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

  /// Clear Resources
  void clearResources() {
    productList.clear();
    filteredProductList.clear();
    isLoading = false;
    hasMoreData = true;
    currentPage = 1;
    errorText = '';
    notifyListeners();
  }

  void resetFilter(){
    queryText='';
  }
}

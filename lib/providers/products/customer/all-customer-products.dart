import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sugudeni/repositories/products/product-repository.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/utils/product-status.dart';
import '../../../models/products/SellerProductListResponse.dart';
import '../../../models/products/SimpleProductModel.dart';
import '../../../repositories/products/seller-product-repository.dart';
import 'package:http/http.dart' as http;
  class CustomerFetchProductProvider extends ChangeNotifier {
    List<Product> productList = [];
    List<Product> filteredProductList = [];
    List<String> suggestions=[];
    final searchController=TextEditingController();

    double minPrice = 0;
    double maxPrice = 5000;
    double minRating = 0;
    double maxRating = 5;
    double minDiscount = 1;
    double maxDiscount = 100;
    String? selectedCategoryId; // Store the selected category ID
    void updateCategory(String? categoryId) {
      selectedCategoryId = categoryId;
      notifyListeners();
    }
    void updatePriceRange(double newMin, double newMax) {
      minPrice = newMin;
      maxPrice = newMax;
      notifyListeners();
    }
    void updateDiscount(double newMin, double newMax) {
      minDiscount = newMin;
      maxDiscount = newMax;
      notifyListeners();
    }
    void setRatingRange(double min, double max) {
      minRating = min;
      maxRating = max;
      notifyListeners();
    }

    bool isLoading = false;
    bool hasMoreData = true;
    int currentPage = 1;
    String errorText = '';
    String queryText = '';
  
    /// Update search query and filter list
    void changeQuery(String value, BuildContext context) {
      queryText = value;
      searchController.text = value;
      currentPage = 1;
      hasMoreData = true;
      productList.clear();
      filteredProductList.clear();
      fetchActiveProducts(context);
    }

    setValueToController(String value){
      searchController.text=value;
      suggestions.clear();
      notifyListeners();
    }
    clearSuggestions(){
      suggestions.clear();
    }
    void filterProducts(double minPrice, double maxPrice, {
      String? categoryId,
      double minRating = 0,
      double maxRating = 5,
      double minDiscount=1,
      double maxDiscount=100
    }) {
      filteredProductList = productList.where((product) {
        double priceToCompare = product.priceAfterDiscount != 0
            ? product.priceAfterDiscount.toDouble()
            : product.price.toDouble();

        bool priceMatch = priceToCompare >= minPrice && priceToCompare <= maxPrice;
        bool categoryMatch = categoryId == null || product.category == categoryId;
        bool ratingMatch = product.ratingAvg >= minRating && product.ratingAvg <= maxRating;
        bool discountMatch = product.saleDiscount >= minDiscount && product.saleDiscount <= maxDiscount;

        return priceMatch && categoryMatch && ratingMatch &&discountMatch;
      }).toList();

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

    void resetAndFetchProducts(BuildContext context) {
      currentPage = 1;  // Reset pagination
      productList.clear();
      fetchActiveProducts(context);
    }

  
    /// Fetch Products
    Future<void> fetchActiveProducts(BuildContext context) async {
      if (isLoading || !hasMoreData) return;

      isLoading = true;
      errorText = '';
      notifyListeners();

      try {
        final response = await ProductRepository.allProductsUsingPaginationWithFilter(
          context,
          currentPage,
          searchController.text.trim(),
        );

        final List<Product> newProducts = response.getAllProducts
            .where((d) => d.status == ProductStatus.active)
            .toList();

        if (newProducts.isEmpty) {
          hasMoreData = false;
        } else {
          currentPage++;
          productList.addAll(newProducts);
          filteredProductList = List.from(productList); // <- SET filtered list from full list
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

    /// Refresh Product List
    Future<void> refreshProducts(BuildContext context) async {
      isLoading = true;
      errorText = '';
      hasMoreData = true;      // ✅ allow future scrolls to load more
      currentPage = 1;
      productList.clear();
      filteredProductList.clear();
      notifyListeners();

      try {
        var response = await ProductRepository.allProductsUsingPaginationWithFilter(
            context,
            currentPage,
            searchController.text.trim()
        );

        List<Product> newProducts = response.getAllProducts
            .where((d) => d.status == ProductStatus.active)
            .toList();

        if (newProducts.isNotEmpty) {
          productList.addAll(newProducts);
          currentPage++; // ✅ make next scroll load page 2
        } else {
          hasMoreData = false; // only if first page was empty
        }

        filteredProductList = List.from(productList); // ✅ update filtered list always

      } catch (e) {
        errorText = e.toString();
      } finally {
        isLoading = false;
        notifyListeners();
      }
    }
    Future<void> getSuggestions(String input) async {
      final response = await http.get(Uri.parse('https://api.datamuse.com/sug?s=$input'));
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        suggestions = data.map((e) => e['word'].toString()).toList();
        customPrint("Suggestions ==================================$suggestions");
        notifyListeners();
      }
      if(input.isEmpty){
        suggestions.clear();
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
      queryText='';
       minPrice = 0;
       maxPrice = 5000; // Default range


    }
  clearValues(){
    searchController.clear();
    suggestions.clear();
  }
    void resetFilter(){
      queryText='';
      minPrice = 0;
      maxPrice = 5000;
       minRating = 0;
       maxRating = 5;
    }
  }

import 'package:flutter/material.dart';
import 'package:sugudeni/models/review/GetSingleProductReviewModel.dart';
import 'package:sugudeni/repositories/review/review-repositoy.dart';

class SellerReviewProvider extends ChangeNotifier{
  List<Review> reviewList = [];
  List<Review> filteredReviewList = [];
  bool isLoading = false;
  bool hasMoreData = true;
  int currentPage = 1;
  String errorText = '';
  String queryText = '';


  /// Update search query and filter list
  void changeQuery(String value) {
    queryText = value;
    _filterReviews();
    notifyListeners();
  }

  /// Apply search filter based on title
  void _filterReviews() {
    if (queryText.isEmpty) {
      filteredReviewList = List.from(reviewList);
    } else {
      filteredReviewList = reviewList
          .where((product) => product.text.toLowerCase().contains(queryText.toLowerCase()))
          .toList();
    }
  }

  /// Fetch Products
  void fetchSellerReviews(BuildContext context) async {
    if (isLoading || !hasMoreData) return;

    isLoading = true;
    errorText = '';

    try {
      var response = await ReviewRepository.getReviewsForSeller(currentPage, context);
      List<Review> newProducts = response.getAllReviews;

      if (newProducts.isNotEmpty) {
        reviewList.addAll(newProducts);
        currentPage++;
        _filterReviews(); // Apply filter after fetching data
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
      double totalListHeight = reviewList.length * itemHeight;
      if (totalListHeight < screenHeight) {
        fetchSellerReviews(context);
      }
    }
  }
  /// Refresh Product List
  Future<void> refreshReviews(BuildContext context) async {
    isLoading = true;
    errorText = '';
    hasMoreData = true;
    currentPage = 1;
    reviewList.clear();
    notifyListeners();

    try {
      var response = await ReviewRepository.getReviewsForSeller(currentPage, context);
      List<Review> newProducts = response.getAllReviews;

      if (newProducts.isNotEmpty) {
        reviewList.addAll(newProducts);
        currentPage++;
        _filterReviews(); // Apply filter after fetching data
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
    reviewList.clear();
    filteredReviewList.clear();
    isLoading = false;
    hasMoreData = true;
    currentPage = 1;
    queryText='';
    errorText = '';
    notifyListeners();
  }

  void resetFilter(){
    queryText='';
  }
  /// Reset Loading States
  void checkMoreData() {
    isLoading = false;
    hasMoreData = true;
    notifyListeners();
  }


}
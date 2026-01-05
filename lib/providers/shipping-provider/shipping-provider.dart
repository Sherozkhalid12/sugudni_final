import 'package:flutter/material.dart';
import 'package:sugudeni/models/address-model/AddressesModel.dart';
import 'package:sugudeni/models/shipment/GetAllAvailableShipmentModel.dart';
import 'package:sugudeni/repositories/driver/driver-shipping-repository.dart';
import 'package:sugudeni/utils/global-functions.dart';

class ShippingProvider extends ChangeNotifier{

  List<ShipmentModel>? shipmentModel;
  List<ShipmentModel>? completedShipments;
  String? errorText;
  bool isLoading=false;
  bool isLoadingCompleted=false;
  DateTime? lastFetchTime;
  DateTime? lastCompletedFetchTime;
  static const Duration cacheDuration = Duration(seconds: 30); // Reduced to 30 seconds for faster updates
  
  Future<void>getAllAvailableShipments(BuildContext context, {bool forceRefresh = false})async{
    // Use cache if data exists and is fresh
    if (!forceRefresh && shipmentModel != null && lastFetchTime != null) {
      final timeSinceFetch = DateTime.now().difference(lastFetchTime!);
      if (timeSinceFetch < cacheDuration) {
        return; // Use cached data
      }
    }
    
    // Delay notifyListeners to avoid setState during build
    Future.microtask(() {
      isLoading=true;
      notifyListeners();
    });
    
    try{
      final response = await DriverShippingRepository.getAllAvailableShipment(context);
      shipmentModel=response.shipments;
      lastFetchTime = DateTime.now();
      Future.microtask(() {
        isLoading=false;
        notifyListeners();
      });
    }catch(e){
      errorText=e.toString();
      Future.microtask(() {
        isLoading=false;
        notifyListeners();
      });
    }
  }
  
  Future<void>getAllCompletedShipments(BuildContext context, {bool forceRefresh = false})async{
    // Use cache if data exists and is fresh
    if (!forceRefresh && completedShipments != null && lastCompletedFetchTime != null) {
      final timeSinceFetch = DateTime.now().difference(lastCompletedFetchTime!);
      if (timeSinceFetch < cacheDuration) {
        return; // Use cached data
      }
    }
    
    // Delay notifyListeners to avoid setState during build
    Future.microtask(() {
      isLoadingCompleted=true;
      notifyListeners();
    });
    
    try{
      final response = await DriverShippingRepository.getAllPendingShipment(context);
      completedShipments = response.shipments
          .where((shipment) => shipment.isDelivered == true && shipment.shippingAddress != null)
          .toList();
      lastCompletedFetchTime = DateTime.now();
      Future.microtask(() {
        isLoadingCompleted=false;
        notifyListeners();
      });
    }catch(e){
      errorText=e.toString();
      Future.microtask(() {
        isLoadingCompleted=false;
        notifyListeners();
      });
    }
  }
  
  void clearCache(){
    shipmentModel = null;
    completedShipments = null;
    lastFetchTime = null;
    lastCompletedFetchTime = null;
    notifyListeners();
  }
  
  // Remove a specific shipment from the list immediately (for instant UI update)
  void removeShipmentById(String shipmentId) {
    if (shipmentModel != null) {
      shipmentModel = shipmentModel!.where((shipment) => shipment.id != shipmentId).toList();
      notifyListeners();
    }
  }

  String selectDate=orderFormatDate(DateTime.now());

  changeDate(DateTime date){
    selectDate=orderFormatDate(date);
    notifyListeners();
  }

  String? pickupAddressId;
  bool isComeFromOrder=false;
  AddressesModel? addressesModel;

  setData(String s,AddressesModel m){
    pickupAddressId=s;
    addressesModel=m;
    notifyListeners();
  }
  setComeFromOder(){
    isComeFromOrder=true;
  }

  clearResources(){
    addressesModel=null;
    isComeFromOrder=false;
    pickupAddressId=null;
  }

}
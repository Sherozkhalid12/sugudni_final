import 'package:flutter/material.dart';
import 'package:sugudeni/models/address-model/AddressesModel.dart';
import 'package:sugudeni/models/shipment/GetAllAvailableShipmentModel.dart';
import 'package:sugudeni/repositories/driver/driver-shipping-repository.dart';
import 'package:sugudeni/utils/global-functions.dart';

class ShippingProvider extends ChangeNotifier{

  List<ShipmentModel>? shipmentModel;
  String? errorText;
  bool isLoading=false;
  Future<void>getAllAvailableShipments(BuildContext context)async{
    isLoading=true;
    try{
      await DriverShippingRepository.getAllAvailableShipment(context).then((v){
        shipmentModel=v.shipments;
        isLoading=false;
        notifyListeners();
      });
    }catch(e){
      errorText==e.toString();
      isLoading=false;
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
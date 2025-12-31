import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/models/address-model/AddAddressModel.dart';
import 'package:sugudeni/models/address-model/AddressesModel.dart';
import 'package:sugudeni/models/review/GetSingleProductReviewModel.dart';
import 'package:sugudeni/models/user/CustomerDataResponseModel.dart';
import 'package:sugudeni/models/user/SellerDataResponseModel.dart';
import 'package:sugudeni/providers/loading-provider.dart';
import 'package:sugudeni/repositories/user-repository.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/global-functions.dart';

import '../../models/address-model/billing-model.dart';
import '../../models/user/SellerModel.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class SellerAddressProvider extends ChangeNotifier{
  SellerDataResponse? sellerData;
  bool isLoading=true;
  String errorText = '';
  String? addressId;
  bool isUpdate=false;
  setAddressId(String id){
    addressId=id;
  }
  final recipientNameController=TextEditingController();
  final phoneController=TextEditingController();
  final countryController=TextEditingController();
  final cityController=TextEditingController();
  final addressController=TextEditingController();
  final landMarkController=TextEditingController();
  GoogleMapController? mapController;
  LatLng? selectedLocation;
  String selectedAddress = "Fetching current location...";
  bool isDragging = false;
  bool safeForUpdate = false;
  Marker? marker;

  String? lat;
  String? lng;
  String? postalCode;
  /// Get user's current location
  // Future<void> getUserLocation(BuildContext context) async {
  //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     return showErrorDialog("Location services are disabled.",context);
  //   }
  //
  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return showErrorDialog("Location permission is denied.",context);
  //     }
  //   }
  //
  //   if (permission == LocationPermission.deniedForever) {
  //     return showErrorDialog(
  //         "Location permission is permanently denied. Enable it from settings.",context);
  //   }
  //
  //   // Get current location
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //
  //   LatLng currentLatLng = LatLng(position.latitude, position.longitude);
  //   selectedLocation = currentLatLng;
  //   marker = Marker(
  //     markerId: const MarkerId("selected-location"),
  //     position: currentLatLng,
  //   );
  //
  //   mapController?.animateCamera(CameraUpdate.newLatLngZoom(currentLatLng, 14));
  //   _getAddressFromLatLng(currentLatLng);
  //   notifyListeners();
  // }
  Future<void> getUserLocation(BuildContext context) async {
    while (!await Geolocator.isLocationServiceEnabled()) {
       //showErrorDialog("Location services are disabled. Please enable them.", context);
      await Geolocator.openLocationSettings();
      await Future.delayed(const Duration(seconds: 2));
    }

    LocationPermission permission;
    do {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
         showErrorDialog(
          "Location permission is permanently denied. Enable it from settings.",
          context,
        );
        await Geolocator.openAppSettings();
        await Future.delayed(const Duration(seconds: 2));
      }
    } while (permission == LocationPermission.denied || permission == LocationPermission.deniedForever);

    // Get current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    LatLng currentLatLng = LatLng(position.latitude, position.longitude);
    selectedLocation = currentLatLng;
    marker = Marker(
      markerId: const MarkerId("selected-location"),
      position: currentLatLng,
    );

    mapController?.animateCamera(CameraUpdate.newLatLngZoom(currentLatLng, 14));
    _getAddressFromLatLng(currentLatLng);
    notifyListeners();
  }

  void moveToLocation() {
    safeForUpdate=false;
    LatLng newLatlng=LatLng(double.parse(lat!), double.parse(lng!));
    mapController?.animateCamera(
      CameraUpdate.newLatLng(newLatlng),
    );
    notifyListeners();
  }

  /// Get address from LatLng
  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        selectedAddress =
        "${place.street}, ${place.locality}, ${place.country}";
        addressController.text=place.street!;
        cityController.text=place.locality!;
        countryController.text=place.country!;
        postalCode=place.postalCode!;
        lat=position.latitude.toString();
        lng=position.longitude.toString();
        notifyListeners();
      }
    } catch (e) {
      print("Error getting address: $e");
    }
  }

  /// When user scrolls the map
  void onCameraMove(CameraPosition position) {
    isDragging = true;
    selectedLocation = position.target;
    notifyListeners();

  }

  /// When user stops scrolling, update marker and address
  void onCameraIdle() {
    if (selectedLocation != null) {
      //safeForUpdate==false? updateLocation(selectedLocation!):null;
      notifyListeners();

    }
  }

  /// When user taps on map
  void onMapTapped(LatLng position) {
    safeForUpdate=false;
    updateLocation(position);
    notifyListeners();

  }

  /// Update marker position and address
  void updateLocation(LatLng position) {
    selectedLocation = position;
    marker = Marker(
      markerId: const MarkerId("selected-location"),
      position: position,
    );
    _getAddressFromLatLng(position);
    notifyListeners();

  }

  /// Show error dialog
  void showErrorDialog(String message,BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"))
          ],
        ));
  }
  void fetchUserData(BuildContext context) async {
    isLoading = true;
    errorText = '';

    try {
      var response = await UserRepository.getSellerData(context);
      
      sellerData = response;
      customPrint("In provider response =================${response}");
      isLoading = false;

      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorText = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  Future<void>updateData(BuildContext context)async{
    final loadingProvider=Provider.of<LoadingProvider>(context,listen: false);
    var model=BillingAddressModel(
        id: '',
        firstName: recipientNameController.text,
        lastName: '',
        company: '',
        street: addressController.text,
        country: countryController.text,
        state: "",
        zipcode: postalCode?? "123456",
        email: '',
        phone: phoneController.text);
    if(isUpdate==true){
      try{
        loadingProvider.setLoading(true);
        await UserRepository.updateShippingAddress(model, context).then((v){
          showSnackbar(context, "Shipping address added successfully",color: greenColor);
          loadingProvider.setLoading(false);
        }).onError((e,err){
          loadingProvider.setLoading(false);
        });
      }catch(e){
        loadingProvider.setLoading(false);

      }
    }else{
      try{
        loadingProvider.setLoading(true);
        await UserRepository.updateBillingAddress(model, context).then((v){
          showSnackbar(context, "Billing address added successfully",color: greenColor);
          loadingProvider.setLoading(false);

        }).onError((e,err){
          loadingProvider.setLoading(false);

        });
      }catch(e){
        loadingProvider.setLoading(false);

      }
    }
  }
  Future<void>addAddress(BuildContext context)async{
    if(recipientNameController.text.isEmpty||cityController.text.isEmpty||addressController.text.isEmpty||countryController.text.isEmpty
        ||phoneController.text.isEmpty
    ){
      showSnackbar(context, "All fields are required",color: redColor);
      return;
    }
    final loadingProvider=Provider.of<LoadingProvider>(context,listen: false);
    var model=AddAddressModel(
        firstname: recipientNameController.text,
        city:cityController.text ,
        lastname: 'test',
        lat: lat?? "",
        long: lng??"",
        company: '2323',
        street: addressController.text,
        country: countryController.text,
        state: '23',
        zipcode: postalCode??"123456",
        email: '23',
        phone: phoneController.text);
    try{
      loadingProvider.setLoading(true);
      await UserRepository.addCustomerAddress(model, context).then((v){
        showSnackbar(context, "Pickup address added successfully",color: greenColor);
        clearResources();
        loadingProvider.setLoading(false);
      }).onError((e,err){
        loadingProvider.setLoading(false);
      });
    }catch(e){
      loadingProvider.setLoading(false);

    }

  }
  Future<void>updateAddress(BuildContext context)async{
    if(recipientNameController.text.isEmpty||cityController.text.isEmpty||addressController.text.isEmpty||countryController.text.isEmpty
        ||phoneController.text.isEmpty
    ){
      showSnackbar(context, "All fields are required",color: redColor);
      return;
    }
    final loadingProvider=Provider.of<LoadingProvider>(context,listen: false);
    var model=AddAddressModel(
        firstname: recipientNameController.text,
        city:cityController.text ,
        lastname: 'test',
        lat: lat?? "",
        long: lng??"",
        company: '2323',
        street: addressController.text,
        country: countryController.text,
        state: '23',
        zipcode: postalCode??"123456",
        email: '23',
        phone: phoneController.text);
    try{
      loadingProvider.setLoading(true);
      await UserRepository.updateCustomerAddress(addressId!,model, context).then((v){
        showSnackbar(context, "Shipping address updated successfully",color: greenColor);
        loadingProvider.setLoading(false);
      }).onError((e,err){
        loadingProvider.setLoading(false);
      });
    }catch(e){
      loadingProvider.setLoading(false);

    }

  }

  setDataForUpdate(int index){
    isUpdate=true;
    setAddressId(sellerData!.user!.pickups[index].id);
    recipientNameController.text=sellerData!.user!.pickups[index].firstname;
    phoneController.text=sellerData!.user!.pickups[index].phone;
    countryController.text=sellerData!.user!.pickups[index].country;
    addressController.text=sellerData!.user!.pickups[index].street;
    cityController.text=sellerData!.user!.pickups[index].city;
    lat=sellerData!.user!.pickups[index].latitude.toString();
    lng=sellerData!.user!.pickups[index].longitude.toString();
    postalCode=sellerData!.user!.pickups[index].zipcode;
    moveToLocation();
    notifyListeners();
  }
  clearResources(){
    isUpdate=false;
    addressId=null;
    recipientNameController.clear();
    phoneController.clear();
    countryController.clear();
    cityController.clear();
    addressController.clear();
    lng=null;
    lat=null;
    postalCode=null;
  }
}
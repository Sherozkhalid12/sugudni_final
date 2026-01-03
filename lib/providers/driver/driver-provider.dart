import 'package:flutter/material.dart';
import 'package:sugudeni/repositories/auth/driver-auth-repository.dart';
import 'package:sugudeni/repositories/user-repository.dart';
import 'package:sugudeni/utils/global-functions.dart';

import '../../utils/constants/colors.dart';
import '../../utils/sharePreference/isDriver-online.dart';

class DriverProvider extends ChangeNotifier{

  bool isDriver=false;
  bool isToggling = false;
  bool _isPendingApproval = false;
  String? _driverStatus; // 'approved', 'pending', 'rejected', etc.
  bool? _isOnline; // Cache online status for instant UI updates

  bool get isPendingApproval => _isPendingApproval;
  String? get driverStatus => _driverStatus;
  bool? get isOnline => _isOnline;
  
  bool get isApproved => _driverStatus == 'approved';
  
  // Load online status from preferences
  Future<void> loadOnlineStatus() async {
    _isOnline = await isDriverOnline();
    notifyListeners();
  }

  Future<void> loadApprovalStatus([BuildContext? context]) async {
    // Load online status immediately from preferences
    await loadOnlineStatus();
    
    // First try to load from API if context is available
    if (context != null) {
      try {
        await fetchDriverStatus(context);
        return;
      } catch (e) {
        customPrint("Error fetching driver status from API: $e");
      }
    }
    // Fallback to stored preference
    _isPendingApproval = await isDriverPendingApproval();
    notifyListeners();
  }

  Future<void> fetchDriverStatus(BuildContext context) async {
    try {
      final response = await UserRepository.getDriverData(context);
      _driverStatus = response.user.driverStatus;
      // Update pending approval based on driverStatus
      _isPendingApproval = _driverStatus != 'approved';
      // Store in preferences for offline access
      await setDriverApprovalStatus(_isPendingApproval);
      customPrint("Driver status fetched from API: $_driverStatus, isPendingApproval: $_isPendingApproval");
      notifyListeners();
    } catch (e) {
      customPrint("Error in fetchDriverStatus: $e");
      rethrow;
    }
  }

  void setPendingApproval(bool value) {
    _isPendingApproval = value;
    setDriverApprovalStatus(value);
    notifyListeners();
  }

  void updateDriverStatus(String status) {
    _driverStatus = status;
    _isPendingApproval = status != 'approved';
    setDriverApprovalStatus(_isPendingApproval);
    notifyListeners();
  }

  Future<void>toggleDriver(BuildContext context)async{
    if (isToggling) return; // Prevent multiple simultaneous toggles
    
    // Optimistic update - update UI immediately
    final currentStatus = _isOnline ?? false;
    _isOnline = !currentStatus;
    isToggling = true;
    notifyListeners(); // Update UI immediately
    
    try{
      await DriverAuthRepository.toggleDriver(context).then((v){
        // Update with actual response
        _isOnline = v.driverOnline;
        setDriverOnlineStatus(v.driverOnline);
        isToggling = false;
        notifyListeners();
        
        // Optionally refresh driver status in background (don't wait for it)
        fetchDriverStatus(context).catchError((e) {
          customPrint("Error refreshing driver status after toggle: $e");
        });
      }).catchError((error) {
        customPrint("Driver toggle error caught in provider: $error");
        
        // Revert optimistic update on error
        _isOnline = currentStatus;
        isToggling = false;
        notifyListeners();
        
        // Handle approval errors - set status but don't show snackbar here
        // (snackbar is already shown in repository)
        if (context.mounted) {
          String errorMessage = error.toString().replaceAll('Exception: ', '');
          
          // Format the message for approval errors
          if (errorMessage.toLowerCase().contains('not approved') || 
              errorMessage.toLowerCase().contains('approval') ||
              errorMessage.toLowerCase().contains('pending approval')) {
            // Refresh driver status from API to get the latest status (in background)
            fetchDriverStatus(context).catchError((e) {
              customPrint("Error refreshing driver status after approval error: $e");
              // Fallback to setting pending approval
              setPendingApproval(true);
            });
            // Snackbar is already shown in repository, but show it here as backup
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                try {
                  final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
                  if (scaffoldMessenger != null) {
                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                        content: const Text('Your driver account is pending approval. Please wait for admin approval before going online.'),
                        duration: const Duration(seconds: 4),
                        backgroundColor: redColor,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    customPrint("Backup snackbar shown in provider");
                  }
                } catch (e) {
                  customPrint("Error showing backup snackbar: $e");
                }
              }
            });
          }
        }
      });
    }catch(e){
      customPrint("Driver toggle exception caught in provider: $e");
      // Revert optimistic update on exception
      _isOnline = currentStatus;
      isToggling = false;
      notifyListeners();
      
      // Handle approval errors - set status and show snackbar
      if (context.mounted) {
        String errorMessage = e.toString().replaceAll('Exception: ', '');
        
        // Format the message for approval errors
        if (errorMessage.toLowerCase().contains('not approved') || 
            errorMessage.toLowerCase().contains('approval') ||
            errorMessage.toLowerCase().contains('pending approval')) {
          errorMessage = 'Your driver account is pending approval. Please wait for admin approval before going online.';
          // Set pending approval status
          setPendingApproval(true);
        }
        
        // Show snackbar for exceptions
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            try {
              final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
              if (scaffoldMessenger != null) {
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text(errorMessage),
                    duration: const Duration(seconds: 4),
                    backgroundColor: redColor,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                customPrint("Snackbar shown for exception in provider");
              }
            } catch (err) {
              customPrint("Error showing snackbar in provider: $err");
            }
          }
        });
      }
    }
  }
}
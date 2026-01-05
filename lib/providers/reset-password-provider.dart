import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/models/auth/ResetPasswordModel.dart';
import 'package:sugudeni/providers/loading-provider.dart';
import 'package:sugudeni/repositories/auth/auth-repository.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';
import '../../l10n/app_localizations.dart';

class ResetPasswordProvider extends ChangeNotifier{
  String _signupName = "";
  String _signupEmail = "";
  String _signupPass = "";
  String _profileURL = "";
  String _authPhoneNumber = "";
  String _dialCode = "+33";
  String _verificationIdCode = "";
  String _level = "";
  String _completePhoneNumber = "";

  int _resendTokenCode = 0;
  bool _allSignInField = false;
  bool _allLoginInField = false;

  bool _signingUp = false;
  bool _fromLogin = false;

  String _sentOTP = "";
  String _receivedOTP = "";

  bool usingEmail=true;
  String otpPreference = 'sms'; // Default selection

  bool _showPassword = false;
  bool _showConfirmPassword = false;

  bool get showPassword => _showPassword;
  bool get showConfirmPassword => _showConfirmPassword;

  ValueKey<bool> get passwordFieldKey => ValueKey(_showPassword);
  ValueKey<bool> get confirmPasswordFieldKey => ValueKey(_showConfirmPassword);

  final TextEditingController otpController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  void togglePasswordVisibility() {
    _showPassword = !_showPassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _showConfirmPassword = !_showConfirmPassword;
    notifyListeners();
  }

  // Add methods to refresh state if necessary
  void notify() {
    notifyListeners();
  }
  // Getters
  String get signupName => _signupName;
  String get signupEmail => _signupEmail;
  String get signupPass => _signupPass;
  String get profileURL => _profileURL;
  String get authPhoneNumber => _authPhoneNumber;

  String get verificationIdCode => _verificationIdCode;
  String get level => _level;
  String get completePhoneNumber => _completePhoneNumber;

  int get resendTokenCode => _resendTokenCode;
  bool get allSignInField => _allSignInField;
  bool get allLoginInField => _allLoginInField;

  bool get signingUp => _signingUp;
  bool get fromLogin => _fromLogin;

  String get sentOTP => _sentOTP;
  String get receivedOTP => _receivedOTP;
  String get dialCode => _dialCode;

  // Setters
  set signupName(String value) {
    _signupName = value;
    notifyListeners();
  }

  set signupEmail(String value) {
    _signupEmail = value;
    notifyListeners();
  }

  set signupPass(String value) {
    _signupPass = value;
    notifyListeners();
  }

  set profileURL(String value) {
    _profileURL = value;
    notifyListeners();
  }

  set authPhoneNumber(String value) {
    _authPhoneNumber = value;
    notifyListeners();
  }

  set verificationIdCode(String value) {
    _verificationIdCode = value;
    notifyListeners();
  }

  set level(String value) {
    _level = value;
    notifyListeners();
  }

  set completePhoneNumber(String value) {
    _completePhoneNumber = value;
    notifyListeners();
  }

  set resendTokenCode(int value) {
    _resendTokenCode = value;
    notifyListeners();
  }

  set allSignInField(bool value) {
    _allSignInField = value;
    notifyListeners();
  }

  set allLoginInField(bool value) {
    _allLoginInField = value;
    notifyListeners();
  }

  set signingUp(bool value) {
    _signingUp = value;
    notifyListeners();
  }

  set fromLogin(bool value) {
    _fromLogin = value;
    notifyListeners();
  }

  set sentOTP(String value) {
    _sentOTP = value;
    notifyListeners();
  }

  set receivedOTP(String value) {
    _receivedOTP = value;
    notifyListeners();
  }

  setDialCode(String v) {
    _dialCode=v;
  }
  setOptPreferences(String value){
    otpPreference=value;
    notifyListeners();
  }
  Future<void>resetPasswordRequestUsingEmail(BuildContext context)async{
    final loadingProvider=Provider.of<LoadingProvider>(context,listen: false);
    if(emailController.text.isEmpty){
      showSnackbar(context, AppLocalizations.of(context)!.pleaseenteryouremail,color: redColor);
      return;
    }
    var model=ResetPasswordModel(
      email: emailController.text.trim()
    );
    try{
      loadingProvider.setLoading(true);
      await AuthRepository.resetPasswordRequest(model, context).then((v){
       if(context.mounted){
         usingEmail=true;
         showSnackbar(context, v.message,color: greenColor);
         Navigator.pushNamed(context, RoutesNames.enterCodeView);
       }
        loadingProvider.setLoading(false);
      }).onError((err,e){
        loadingProvider.setLoading(false);
      });
    }catch(e){
      loadingProvider.setLoading(false);
    }
  }
  Future<void>resetPasswordRequestUsingPhone(BuildContext context)async{
    final loadingProvider=Provider.of<LoadingProvider>(context,listen: false);
    if(phoneController.text.isEmpty){
      showSnackbar(context, AppLocalizations.of(context)!.pleaseenteryourphonenumber,color: redColor);
      return;
    }
    String phone="$_dialCode${phoneController.text.toString()}";
    var model=ResetPasswordModel(
      phone: phone,
      otpChannel: otpPreference
    );
    try{
      loadingProvider.setLoading(true);
      await AuthRepository.resetPasswordRequest(model, context).then((v){
       if(context.mounted){
         usingEmail=false;

         showSnackbar(context, v.message,color: greenColor);
         Navigator.pushNamed(context, RoutesNames.enterCodeView);
       }
        loadingProvider.setLoading(false);
      }).onError((err,e){
        loadingProvider.setLoading(false);
      });
    }catch(e){
      loadingProvider.setLoading(false);
    }
  }
  Future<void>verifyResetPasswordRequest(BuildContext context,ResetPasswordModel model)async{
    final loadingProvider=Provider.of<LoadingProvider>(context,listen: false);


    try{
      loadingProvider.setLoading(true);
      await AuthRepository.verifyPasswordRequest(model, context).then((v){
       if(context.mounted){

         showSnackbar(context, v.message,color: greenColor);

         Navigator.pushReplacementNamed(context, RoutesNames.resetPasswordView);
       }
        loadingProvider.setLoading(false);
      }).onError((err,e){
        //showSnackbar(context, err.toString(),color: redColor);
        loadingProvider.setLoading(false);
      });
    }catch(e){
      loadingProvider.setLoading(false);
    }
  }
  Future<void>setNewPassword(BuildContext context)async{
    final loadingProvider=Provider.of<LoadingProvider>(context,listen: false);

    String password=passwordController.text.trim().toString();
    String confirmPassword=confirmPasswordController.text.trim().toString();

    if(password.isEmpty||confirmPassword.isEmpty){
      showSnackbar(context, AppLocalizations.of(context)!.pleaseenterbothpasswordandconfirmation,color: redColor);
      return;
    }
    if(password!=confirmPassword){
      showSnackbar(context,  AppLocalizations.of(context)!.passworddoesnotmatch,color: redColor);
      return;
    }
    String phone="$_dialCode${phoneController.text.isEmpty?'321':phoneController.text.toString()}";
    var model=usingEmail==true?
    ResetPasswordModel(
        email: emailController.text.trim().toString(),
        password: password
    ):ResetPasswordModel(
        phone: phone,
        password: password
    );
    try{
      loadingProvider.setLoading(true);
      await AuthRepository.setNewPassword(model, context).then((v){
        if(context.mounted){
          showSnackbar(context, v.message,color: greenColor);
          Navigator.pushNamedAndRemoveUntil(context, RoutesNames.loginView,(route) => false,);
          clearResources();
        }
        loadingProvider.setLoading(false);
      }).onError((err,e){
        loadingProvider.setLoading(false);
      });
    }catch(e){
      loadingProvider.setLoading(false);
    }
  }
  clearResources(){
    otpPreference='sms';
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    phoneController.clear();
  }
  // Dispose controllers
  @override
  void dispose() {
    otpController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
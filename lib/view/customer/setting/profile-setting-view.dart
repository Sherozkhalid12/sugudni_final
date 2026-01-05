import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/models/user/UpdateCustomerModel.dart';
import 'package:sugudeni/repositories/user-repository.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';

import '../../../l10n/app_localizations.dart';
import '../../../providers/sellerProfile/user-profile-provider.dart';
import '../../../utils/constants/app-assets.dart';
import '../../../utils/customWidgets/my-text.dart';
import '../../../utils/customWidgets/round-button.dart';
import '../../../utils/customWidgets/text-field.dart';

class CustomerProfileSettingView extends StatefulWidget {
  const CustomerProfileSettingView({super.key});

  @override
  State<CustomerProfileSettingView> createState() => _CustomerProfileSettingViewState();
}

class _CustomerProfileSettingViewState extends State<CustomerProfileSettingView> {
  final nameController=TextEditingController();
  final emailController=TextEditingController();
  final phoneController=TextEditingController();
  final passwordController=TextEditingController();
  String profilePicture='';

  bool _showPassword = false;
  void fetchData()async{
    customPrint("Init ===============================================");
    var data=await UserRepository.getCustomerData(context);
    customPrint("Init data===============================================${data.user!.email}");

    nameController.text=data.user!.name;
    emailController.text=data.user!.email;
    phoneController.text=data.user!.phone;
    profilePicture=data.user!.profilePic;
    setState(() {
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchData();
    context.read<UserProfileProvider>().fetchUserData(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final provider=Provider.of<UserProfileProvider>(context,listen: false);

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        provider.clearResources();
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: SymmetricPadding(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  30.height,
                  Row(
                    children: [
                      InkWell(
                          onTap:(){
                            Navigator.pop(context);
                          },
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Icon(Icons.arrow_back_ios))
                    ],
                  ),
                  MyText(text:AppLocalizations.of(context)!.setting, size: 28.sp, fontWeight: FontWeight.w700),
                  5.height,
                  MyText(text: AppLocalizations.of(context)!.yourprofile, size: 16.sp, fontWeight: FontWeight.w500),
                  10.height,
                  SizedBox(
                    height: 150.h,
                    width: 120.w,
                    child: Stack(
                      children: [
                        Container(
                          height: 105.h,
                          width: 105.w,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: whiteColor
                          ),
                        ),
              
                       Consumer<UserProfileProvider>(builder: (context,provider,child){
                         return profilePicture.isNotEmpty &&provider.isChangePicture==false?
                         Positioned(
                             top: 7,
                             left: 10,
                             child: Consumer<UserProfileProvider>(builder: (context,provider,child){
                               return Container(
                                 height: 105.h,
                                 width: 105.w,
                                 decoration:  BoxDecoration(
                                   shape: BoxShape.circle,
                                   image: DecorationImage(image: NetworkImage("${ApiEndpoints.productUrl}/$profilePicture"),fit: BoxFit.cover),
                                 ),
                               );
                             })
                         ):
                         Positioned(
                             top: 7,
                             left: 10,
                             child: Consumer<UserProfileProvider>(builder: (context,provider,child){
                               return Container(
                                 height: 105.h,
                                 width: 105.w,
                                 decoration:  BoxDecoration(
                                   shape: BoxShape.circle,
                                   color: provider.customerProfilePic == null ? Colors.orange.shade400 : null,
                                   image: provider.customerProfilePic == null
                                       ? null
                                       : DecorationImage(image: FileImage(File(provider.customerProfilePic!.path)), fit: BoxFit.cover),
                                 ),
                                 child: provider.customerProfilePic == null
                                     ? Icon(
                                         Icons.person,
                                         color: whiteColor,
                                         size: 50.sp,
                                       )
                                     : null,
                               );
                             })
                         );
                       }),
                        Positioned(
                          right: 5,
                          child: GestureDetector(
                            onTap: (){
                              provider.pickCustomerImage();
                            },
                            child: Container(
                              height: 30.h,
                              width: 30.w,
                              decoration:  BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: primaryColor,
                                border: Border.all(color: whiteColor,width: 4)
                              ),
                              child: Center(
                                child: Icon(Icons.edit,color: whiteColor,size: 14.sp,),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  30.height,
              
                  CustomTextFiled(
                    controller: nameController,
                    borderRadius: 15.r,
                    isBorder: true,
                    isShowPrefixIcon: true,
                    isFilled: true,
                    hintText: AppLocalizations.of(context)!.fullname,
                    isShowPrefixImage: true,
                    prefixImgUrl: AppAssets.personIcon,
              
                  ),
                  10.height,
              
                  CustomTextFiled(
                    controller: emailController,
                    borderRadius: 15.r,
                    isBorder: true,
                    isShowPrefixIcon: true,
                    isFilled: true,
                    hintText: AppLocalizations.of(context)!.enteryouremail,
                    isShowPrefixImage: true,
                    prefixImgUrl: AppAssets.emailIcon,
              
                  ),
                  10.height,
              
                  CustomTextFiled(
                    controller: phoneController,
                    borderRadius: 15.r,
                    isBorder: true,
                    isShowPrefixIcon: true,
                    isFilled: true,
                    hintText: AppLocalizations.of(context)!.pleaseinputphonenumber,
                    isShowPrefixImage: true,
                    prefixImgUrl: AppAssets.callIcon,
              
                  ),
                  10.height,
                  CustomTextFiled(
                    key: ValueKey(_showPassword),
                    controller: passwordController,
                    borderRadius: 15.r,
                    isShowPrefixIcon: true,
                    isBorder: true,
                    isPassword: true,
                    isObscure: !_showPassword,
                    passwordFunction: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                    isFilled: true,
                    hintText: AppLocalizations.of(context)!.enterpassword,
                    isShowPrefixImage: true,
                    prefixImgUrl: AppAssets.passwordIcon,
                  ),
                  150.height,
                  RoundButton(
                      isLoad: true,
                      title: AppLocalizations.of(context)!.savechanges, onTap: ()async{
                     if(nameController.text.isEmpty||emailController.text.isEmpty||phoneController.text.isEmpty){
                       showSnackbar(context, AppLocalizations.of(context)!.allfieldsarerequired,color: redColor);
                       return;
                     }
                     var model=UpdateCustomerModel(
                         name: nameController.text.trim(),
                         email: emailController.text.trim(),
                         phone: phoneController.text.trim(),
                       password: passwordController.text.isNotEmpty == true ? passwordController.text.trim(): null, // Only include password if not empty
              
              
                     );
              
              
                        provider.isChangePicture==true? await  provider.addProfilePicture(context):null;
                        provider.updateCustomerData(model, context);
              
              
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

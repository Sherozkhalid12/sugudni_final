import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/providers/auth/auth-provider.dart';
import 'package:sugudeni/providers/category/category-provider.dart';
import 'package:sugudeni/providers/products/products-provider.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/round-button.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/sharePreference/is-user-registered.dart';
import 'package:sugudeni/utils/user-roles.dart';
import 'package:sugudeni/view/auth/main-login-view.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/select-role-provider.dart';
import '../../utils/constants/app-assets.dart';
import '../../utils/customWidgets/text-field.dart';
import '../../utils/global-functions.dart';
import '../../utils/routes/routes-name.dart';

class LoginWithEmailView extends StatefulWidget {
  const LoginWithEmailView({super.key});

  @override
  State<LoginWithEmailView> createState() => _LoginWithEmailViewState();
}

class _LoginWithEmailViewState extends State<LoginWithEmailView> {
  @override
  void initState() {
    // TODO: implement initState
    Provider.of<AuthProvider>(context,listen: false).clearResources();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final signUpProvider=Provider.of<AuthProvider>(context,listen: false);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SymmetricPadding(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                40.height,
                Row(
                  children: [
                    MyText(text: "${AppLocalizations.of(context)!.hi} !",color: textPrimaryColor,size: 22.sp,fontWeight: FontWeight.w700,),
                  ],
                ),
                MyText(text: AppLocalizations.of(context)!.welcometotelimani,color: textPrimaryColor.withOpacity(0.8),size: 22.sp,fontWeight: FontWeight.w700,),
                MyText(text:  AppLocalizations.of(context)!.pleasesigininwithemail,color: textPrimaryColor.withOpacity(0.8),size: 16.sp,fontWeight: FontWeight.w500,),
                20.height,

                Center(
                  child: Image.asset(
                      height: 200.h,
                      width: 300.w,
                      AppAssets.appLogo),
                ),
                20.height,
                CustomTextFiled(
                  controller: signUpProvider.emailController,

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
                  controller: signUpProvider.passwordController,
                  borderRadius: 15.r,
                  isShowPrefixIcon: true,
                  isBorder: true,
                  isPassword: true,

                  isFilled: true,
                  hintText: AppLocalizations.of(context)!.enteryourpassword,
                  isShowPrefixImage: true,
                  prefixImgUrl: AppAssets.passwordIcon,

                ),
                Row(
                  children: [
                   Consumer<AuthProvider>(builder: (context,provider,child){
                     return  Checkbox(
                         fillColor: const WidgetStatePropertyAll(textFieldColor),
                         side: const BorderSide(
                           color: primaryColor,
                         ),
                         value: provider.isRemember, onChanged: (v){
                           provider.toggleRemember(v!);
                     });
                   }),
                    MyText(text: AppLocalizations.of(context)!.rememberinformation,size: 14.sp,)
                  ],
                ),
                40.height,
                Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, RoutesNames.forgetPasswordEmailView);

                      },
                      child: MyText(text: AppLocalizations.of(context)!.forgetpassword,size: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,),
                    )),
                10.height,
                RoundButton(
                    isLoad: true,
                    title: AppLocalizations.of(context)!.signin, onTap: ()async{
                  // final provider=Provider.of<SelectRoleProvider>(context,listen: false);
                  //
                  // provider.selectedRole==UserRoles.customer? setUserRegistered(true):setUserRegistered(false);
                  // navigateBasedOnRole(provider.selectedRole, context);

                // await context.read<ProductsProvider>().getAllProducts(context);
                 //await context.read<ProductsProvider>().getSpecificProduct('67bc15707e19eff41f9a34e7',context);
                // await context.read<ProductsProvider>().deleteProduct('67bee3eeb021a551f943dbd8',context);
                // await context.read<CategoryProvider>().deleteCategory('6537c7f68785709b48ad896f',context);


                  await signUpProvider.signInUser(context);

                }),
                100.height,
                const HaventSignupWidget(),
                10.height,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
    Provider.of<AuthProvider>(context, listen: false).clearResources();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    MyText(
                      text: "${AppLocalizations.of(context)!.hi} !",
                      color: textPrimaryColor,
                      size: 22.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
                MyText(
                  text: AppLocalizations.of(context)!.welcometotelimani,
                  color: textPrimaryColor.withOpacity(0.8),
                  size: 22.sp,
                  fontWeight: FontWeight.w700,
                ),
                MyText(
                  text: AppLocalizations.of(context)!.pleasesigininwithemail,
                  color: textPrimaryColor.withOpacity(0.8),
                  size: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
                20.height,

                Center(
                  child: Image.asset(
                    AppAssets.appLogo,
                    height: 200.h,
                    width: 300.w,
                  ),
                ),
                20.height,

                // Email Field
                CustomTextFiled(
                  controller: context.read<AuthProvider>().emailController,
                  borderRadius: 15.r,
                  isBorder: true,
                  isShowPrefixIcon: true,
                  isFilled: true,
                  hintText: AppLocalizations.of(context)!.enteryouremail,
                  isShowPrefixImage: true,
                  prefixImgUrl: AppAssets.emailIcon,
                ),
                10.height,

                // Password Field - Using Provider State
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return CustomTextFiled(
                      key: authProvider.passwordFieldKey, // THIS IS THE KEY FIX
                      controller: authProvider.passwordController,
                      borderRadius: 15.r,
                      isShowPrefixIcon: true,
                      isBorder: true,
                      isFilled: true,
                      hintText: AppLocalizations.of(context)!.enteryourpassword,
                      isShowPrefixImage: true,
                      prefixImgUrl: AppAssets.passwordIcon,
                      isPassword: true,
                      isObscure: !authProvider.showPassword, // Invert showPassword to isObscure
                      passwordFunction: () {
                        authProvider.togglePasswordVisibility();
                        return null;
                      }, // Toggle via provider
                    );
                  },
                ),
                10.height,

                Row(
                  children: [
                    Consumer<AuthProvider>(builder: (context, provider, child) {
                      return Checkbox(
                        fillColor: const WidgetStatePropertyAll(textFieldColor),
                        side: const BorderSide(color: primaryColor),
                        value: provider.isRemember,
                        onChanged: (v) {
                          provider.toggleRemember(v!);
                        },
                      );
                    }),
                    MyText(
                      text: AppLocalizations.of(context)!.rememberinformation,
                      size: 14.sp,
                    ),
                  ],
                ),
                40.height,

                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, RoutesNames.forgetPasswordEmailView);
                    },
                    child: MyText(
                      text: AppLocalizations.of(context)!.forgetpassword,
                      size: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                ),
                10.height,

                RoundButton(
                  isLoad: true,
                  title: AppLocalizations.of(context)!.signin,
                  onTap: () async {
                    await context.read<AuthProvider>().signInUser(context);
                  },
                ),
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
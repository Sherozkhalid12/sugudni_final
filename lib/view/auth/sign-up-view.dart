import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:sugudeni/main.dart';
import 'package:sugudeni/models/auth/SignUpModel.dart';
import 'package:sugudeni/providers/auth/auth-provider.dart';
import 'package:sugudeni/providers/loading-provider.dart';
import 'package:sugudeni/providers/select-role-provider.dart';
import 'package:sugudeni/repositories/auth/auth-repository.dart';
import 'package:sugudeni/services/social-services.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/round-button.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/utils/customWidgets/custom-phone-number-field.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/customWidgets/text-field.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';
import 'package:sugudeni/utils/customWidgets/text-field.dart' as custom_text_field;
import 'package:sugudeni/l10n/app_localizations.dart';
import 'package:crypto/crypto.dart';

import '../../providers/auth/social-provider.dart';
import '../../utils/constants/fonts.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  @override
  void initState() {
    super.initState();
  }

  String generateNonce([int length = 32]) {
    final charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> signInWithApple() async {
    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
      );

      print("Apple Identity Token: ${appleCredential.identityToken}");

      final oauthCredential = auth.OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final auth.UserCredential userCredential = await auth.FirebaseAuth.instance.signInWithCredential(oauthCredential);

      print("User Credential: $userCredential");

      if (userCredential.user != null) {
        if (userCredential.additionalUserInfo?.isNewUser ?? false) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user?.uid)
              .set({
            'email': userCredential.user?.email,
            'username': appleCredential.givenName ?? "Anonymous",
            'createdAt': Timestamp.now(),
          });
          print('New Apple user signed up!');
        } else {
          print('Existing Apple user signed in!');
        }
      }
    } catch (e) {
      print("Apple sign-in sss: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final signUpProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 390.h,
              decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage(AppAssets.signUpEllipse)),
              ),
              child: Column(
                children: [
                  100.height,
                  Image.asset(AppAssets.signUpImage, width: 254.w, height: 196.h),
                  40.height,
                  MyText(
                    text: AppLocalizations.of(context)!.signup,
                    color: textPrimaryColor,
                    size: 25.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
            ),
            20.height,
            SymmetricPadding(
              child: Column(
                children: [
                  // Selection between email and phone
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: ListTile(
                          title: const Text('Email'),
                          leading: Radio<bool>(
                            value: true,
                            groupValue: signUpProvider.isEmail,
                            onChanged: (value) {
                              signUpProvider.toggleSignUpMethod(value!);
                            },
                          ),
                        ),
                      ),
                      Flexible(
                        child: ListTile(
                          title: const Text('Phone'),
                          leading: Radio<bool>(
                            value: false,
                            groupValue: signUpProvider.isEmail,
                            onChanged: (value) {
                              signUpProvider.toggleSignUpMethod(value!);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  CustomTextFiled(
                    controller: signUpProvider.nameController,
                    borderRadius: 15.r,
                    isBorder: true,
                    isShowPrefixIcon: true,
                    isFilled: true,
                    hintText: AppLocalizations.of(context)!.fullname,
                    isShowPrefixImage: true,
                    prefixImgUrl: AppAssets.personIcon,
                  ),
                  10.height,
                  if (signUpProvider.isEmail)
                    CustomTextFiled(
                      controller: signUpProvider.signUpEmailController,
                      borderRadius: 15.r,
                      isBorder: true,
                      isShowPrefixIcon: true,
                      isFilled: true,
                      hintText: AppLocalizations.of(context)!.youremail,
                      isShowPrefixImage: true,
                      prefixImgUrl: AppAssets.emailIcon,
                    ),
                  if (!signUpProvider.isEmail)
                    Container(
                      decoration: BoxDecoration(
                        color: textFieldColor,
                        borderRadius: BorderRadius.circular(13.r),
                      ),
                      child: Row(
                        children: [
                          CountryCodePicker(
                            onChanged: (CountryCode countryCode) {
                              signUpProvider.changeCountryCode(countryCode.dialCode!);
                            },
                            padding: EdgeInsets.zero,
                            flagWidth: 23.w,
                            initialSelection: 'FR',
                            textStyle: TextStyle(
                              fontSize: 13.sp,
                              color: blackColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Flexible(
                            child: CustomTextFiled(
                              controller: signUpProvider.signUpPhoneController,
                              borderRadius: 15.r,
                              isBorder: true,
                              isShowPrefixIcon: false,
                              isFilled: true,
                              hintText: AppLocalizations.of(context)!.yourphonenumber,
                              isShowPrefixImage: false,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                    ),
                  10.height,
                  CustomTextFiled(
                    controller: signUpProvider.signUpPasswordController,
                    borderRadius: 15.r,
                    isShowPrefixIcon: true,
                    isBorder: true,
                    isFilled: true,
                    hintText: AppLocalizations.of(context)!.enterpassword,
                    isShowPrefixImage: true,
                    isPassword: true,
                    prefixImgUrl: AppAssets.passwordIcon,
                  ),
                  10.height,
                  if (!signUpProvider.isEmail)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: MyText(
                            text: AppLocalizations.of(context)!.otppreference,
                            size: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Consumer<AuthProvider>(builder: (context, provider, child) {
                          return Row(
                            children: [
                              Flexible(
                                child: ListTile(
                                  title: const Text('SMS'),
                                  leading: Radio<String>(
                                    value: 'sms',
                                    groupValue: provider.otpPreference,
                                    onChanged: (value) {
                                      provider.setOptPreferences(value!);
                                    },
                                  ),
                                ),
                              ),
                              Flexible(
                                child: ListTile(
                                  title: const Text('WhatsApp'),
                                  leading: Radio<String>(
                                    value: 'whatsapp',
                                    groupValue: provider.otpPreference,
                                    onChanged: (value) {
                                      provider.setOptPreferences(value!);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  30.height,
                  RoundButton(
                    isLoad: true,
                    title: AppLocalizations.of(context)!.signup,
                    onTap: () async {
                      signUpProvider.signUpUser(context);
                    },
                  ),
                  10.height,
                  InkWell(
                    onTap: () async {
                      context.read<SocialProvider>().registerWithGoogle(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(AppAssets.googleIcon, scale: 2.5),
                        20.width,
                        MyText(
                          text: AppLocalizations.of(context)!.signupwithgoogle,
                          color: textPrimaryColor,
                          size: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                  10.height,
                  if (Platform.isIOS)
                    InkWell(
                      onTap: () async {
                        context.read<SocialProvider>().registerApple(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(AppAssets.appleIcon, scale: 2.5),
                          20.width,
                          MyText(
                            text: AppLocalizations.of(context)!.signupwithapple,
                            color: textPrimaryColor,
                            size: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                  20.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyText(
                        text: AppLocalizations.of(context)!.alreadyhaveanaccount,
                        size: 14.sp,
                        fontFamily: AppFonts.jost,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, RoutesNames.loginView);
                        },
                        child: MyText(
                          text: AppLocalizations.of(context)!.signin,
                          size: 16.sp,
                          fontFamily: AppFonts.jost,
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  30.height,
                  Center(
                    child: SizedBox(
                      width: 320.w,
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: '${AppLocalizations.of(context)!.bysigningupyouagreetoour} ',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: blackColor,
                            fontFamily: AppFonts.poppins,
                          ),
                          children: [
                            TextSpan(
                              text: AppLocalizations.of(context)!.termsofservices,
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                                fontFamily: AppFonts.poppins,
                              ),
                              recognizer: TapGestureRecognizer()..onTap = () {},
                            ),
                            TextSpan(
                              text: ' ${AppLocalizations.of(context)!.and} ',
                              style: TextStyle(
                                color: blackColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                                fontFamily: AppFonts.poppins,
                              ),
                            ),
                            TextSpan(
                              text: '${AppLocalizations.of(context)!.privacypolicy}.',
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                                fontFamily: AppFonts.poppins,
                              ),
                              recognizer: TapGestureRecognizer()..onTap = () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  10.height,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:sugudeni/main.dart';
import 'package:sugudeni/providers/auth/social-provider.dart';
import 'package:sugudeni/services/social-services.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../../utils/constants/fonts.dart';
import '../../l10n/app_localizations.dart';

class MainLoginView extends StatefulWidget {
  const MainLoginView({super.key});

  @override
  State<MainLoginView> createState() => _MainLoginViewState();
}

class _MainLoginViewState extends State<MainLoginView> {
  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> signInWithApple() async {
    try {
      // Generate nonce
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      // Request Apple Sign-In credentials
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],

      );

      print("Apple Identity Token: ${appleCredential.identityToken}");

      // Firebase OAuth Credential
      final oauthCredential = auth.OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // Sign in with Firebase
      final auth.UserCredential userCredential =
      await auth.FirebaseAuth.instance.signInWithCredential(oauthCredential);

      print("User Credential: $userCredential");

      // Check if the user is new
      if (userCredential.user != null) {
        if (userCredential.additionalUserInfo?.isNewUser ?? false) {
          // Save new user details in Firestore
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

        // Navigate to main screen
        // Get.offAll(DuaDay());
      } else {
        // Get.snackbar('Sign-In Error', 'Failed to sign in. Please try again.');
      }
    } catch (e) {
      print("Apple sign-in error: $e");
      // Get.snackbar("Sign-In Error", "Failed to sign in with Apple: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(child: SymmetricPadding(

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.height,
              Center(
                child: Image.asset(
                    height: 200.h,
                    width: 500.w,
                    AppAssets.appLogo),
              ),
              MyText(
                overflow: TextOverflow.clip,
                text: "${AppLocalizations.of(context)!.signintoshopsmarterandfaster} !",color: textPrimaryColor,size: 16.sp,fontWeight: FontWeight.w600,),

              20.height,
              Center(child: MyText(text: AppLocalizations.of(context)!.signin,color: textPrimaryColor,size: 35.sp,fontWeight: FontWeight.w700,)),
              20.height,
              GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, RoutesNames.loginWithEmailView);
                },
                child: Container(
                  height: 45.h,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [
                          gradientColorThree,
                          gradientColorTwo,
                          gradientColorOne,
                        ]),
                    borderRadius: BorderRadius.circular(40.r)
                  ),
                  child: Row(
                    children: [
                      20.width,
                      Image.asset(AppAssets.emailIcon,scale: 2,color: whiteColor,),

                      const Spacer(),
                      MyText(text: AppLocalizations.of(context)!.loginwithemail,size: 15.sp,fontWeight: FontWeight.w500,color: whiteColor,),
                      20.width,
                      const Spacer()
                    ],
                  ),
                ),
              ),
              20.height,
              GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, RoutesNames.loginWithPhoneView);

                },
                child: Container(
                  height: 45.h,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [
                          gradientColorThree,
                          gradientColorTwo,
                          gradientColorOne,
                        ]),
                    borderRadius: BorderRadius.circular(40.r)
                  ),
                  child: Row(
                    children: [
                      20.width,
                      const Icon(Icons.call,color: whiteColor,),

                      const Spacer(),
                      SizedBox(
                        width: 200.w,
                        child: MyText(
                          overflow: TextOverflow.clip,
                          text: AppLocalizations.of(context)!.loginwithmobilenumber,size: 14.sp,fontWeight: FontWeight.w500,color: whiteColor,),
                      ),
                      20.width,
                      const Spacer()
                    ],
                  ),
                ),
              ),
              30.height,
              InkWell(
                onTap: ()async{
                 //UserCredential? user=await SocialServices.signInWithGitHub();
                //  UserCredential? user=await SocialServices.signInWithTwitter();
                 // customPrint("Github data==============================$user");
                  context.read<SocialProvider>().loginWithGoogle(context);
                },
                child: Row(
                  children: [
                    Image.asset(AppAssets.googleIcon,scale: 2.5,),
                    20.width,
                    MyText(text: AppLocalizations.of(context)!.loginwithgoogle,color: textPrimaryColor,size: 12.sp,fontWeight: FontWeight.w600,)
                  ],
                ),
              ),
              20.height,
              if(Platform.isIOS)
              InkWell(
                onTap: ()async{
                  //UserCredential? user=await SocialServices.signInWithGitHub();
                  //  UserCredential? user=await SocialServices.signInWithTwitter();
                  // customPrint("Github data==============================$user");
                 // signInWithApple();
                  context.read<SocialProvider>().loginWithApple(context);

                },
                child: Row(
                  children: [
                    Image.asset(AppAssets.appleIcon,scale: 2.5,),
                    20.width,
                    MyText(text: AppLocalizations.of(context)!.loginwithapple,color: textPrimaryColor,size: 12.sp,fontWeight: FontWeight.w600,)
                  ],
                ),
              ),
              20.height,
              const Spacer(),
             HaventSignupWidget(),
              20.height,

            ],
      ))),
    );
  }
}
class HaventSignupWidget extends StatelessWidget {
  const HaventSignupWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyText(text: "${AppLocalizations.of(context)!.haventsignedupyet} ",size: 12.sp,fontFamily: AppFonts.jost,fontWeight: FontWeight.w600,),
            MyText(text: "?",size: 12.sp,fontFamily: AppFonts.jost,color: primaryColor,fontWeight: FontWeight.w600,),
          ],
        ),
        GestureDetector(
          onTap: (){
            Navigator.pushNamed(context, RoutesNames.selectRoleView);
          },
          child: MyText(text: " ${AppLocalizations.of(context)!.signupnow}",size: 12.sp,fontFamily: AppFonts.jost,color: primaryColor,fontWeight: FontWeight.w600,),

        ),
      ],
    );
  }
}

import 'dart:convert';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:sugudeni/models/auth/social/AppleLoginModel.dart';
import 'package:sugudeni/models/auth/social/GoogleLoginModel.dart';
import 'package:sugudeni/providers/bottom_navigation_provider.dart';
import 'package:sugudeni/providers/select-role-provider.dart';
import 'package:sugudeni/repositories/auth/social/social-auth-repository.dart';
import 'package:sugudeni/services/social-services.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/sharePreference/save-user-token.dart';
import 'package:sugudeni/utils/sharePreference/save-user-type.dart';

import '../../utils/global-functions.dart';
import '../../utils/user-roles.dart';
import '../../l10n/app_localizations.dart';

class SocialProvider extends ChangeNotifier{


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
  Future<void>registerWithGoogle(BuildContext context)async{
    final roleProvider=Provider.of<SelectRoleProvider>(context,listen: false);
    try{
      User? user=await SocialServices.signInWithGoogle();
      customPrint("user============================$user");
      if(user!=null){
        DocumentSnapshot data=await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if(data.exists){
          String role=data['role'];
          var model=GoogleLoginModel(
              name: user.displayName!,
              picUrl: user.photoURL!,
              email: user.email!,
              role: role);
          await SocialAuthRepository.loginWithGoogle(model, context).then((v)async{
            await saveUserId(v.user.id);
            await saveSessionToken(v.token);
            await saveUserType(role);
            // Reset bottom navigation to home tab for customers
            if (role == UserRoles.customer) {
              Provider.of<BottomNavigationProvider>(context, listen: false).setIndex(0);
            }
            navigateBasedOnRole(role, context);
          });
        }
        else{
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            "name": user.displayName,
            "picUrl": user.photoURL,
            "email": user.email,
            "role": roleProvider.selectedRole
          }).then((v)async{
            var model=GoogleLoginModel(
                name: user.displayName!,
                picUrl: user.photoURL!,
                email: user.email!,
                role: roleProvider.selectedRole);
            await SocialAuthRepository.loginWithGoogle(model, context).then((v)async{
              await saveUserId(v.user.id);
              await saveSessionToken(v.token);
              await saveUserType(roleProvider.selectedRole);

              // Reset bottom navigation to home tab for customers
              if (roleProvider.selectedRole == UserRoles.customer) {
                Provider.of<BottomNavigationProvider>(context, listen: false).setIndex(0);
              }
              navigateBasedOnRole(roleProvider.selectedRole, context);
            });
          });
        }
      }
    }catch(e){
      showSnackbar(context, e.toString(),color: redColor);
    }
  }
  Future<void>loginWithGoogle(BuildContext context)async{
    final roleProvider=Provider.of<SelectRoleProvider>(context,listen: false);
    try{
      User? user=await SocialServices.signInWithGoogle();
      customPrint("user============================$user");
      if(user!=null){
        DocumentSnapshot data=await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if(data.exists){
          String role=data['role'];
          var model=GoogleLoginModel(
              name: user.displayName!,
              picUrl: user.photoURL!,
              email: user.email!,
              role: role);
          await SocialAuthRepository.loginWithGoogle(model, context).then((v)async{
            await saveUserId(v.user.id);
            await saveSessionToken(v.token);
            await saveUserType(role);
            // Reset bottom navigation to home tab for customers
            if (role == UserRoles.customer) {
              Provider.of<BottomNavigationProvider>(context, listen: false).setIndex(0);
            }
            navigateBasedOnRole(role, context);
          });
        }
        else{
        await SocialServices.signOutUser();
        showSnackbar(context, AppLocalizations.of(context)!.pleasesignupfirsttousethisaccount,color: redColor);
        }
      }
    }catch(e){
      showSnackbar(context, e.toString(),color: redColor);
    }
  }



  Future<void>registerApple(BuildContext context)async{
    final roleProvider=Provider.of<SelectRoleProvider>(context,listen: false);

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
          DocumentSnapshot data=await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).get();
          if(data.exists){
            String role=data['role'];
            var model=AppleLoginModel(
               firstname: '',
                lastname: '',
                name: appleCredential.givenName ?? '',
                appleId:userCredential.user!.uid ,
                email: userCredential.user!.email!,
                role: role);
            await SocialAuthRepository.loginWithApple(model, context).then((v)async{
              await saveUserId(v.user.id);
              await saveSessionToken(v.token);
              await saveUserType(role);

              // Reset bottom navigation to home tab for customers
            if (role == UserRoles.customer) {
              Provider.of<BottomNavigationProvider>(context, listen: false).setIndex(0);
            }
            navigateBasedOnRole(role, context);
            });
          }
          else{
            await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
              "firstname": '',
              "lastname": '',
              "name": appleCredential.givenName ?? '',
              "appleId": userCredential.user!.uid,
              "role": roleProvider.selectedRole,
            }).then((v)async{
              var model=AppleLoginModel(
                  firstname: '',
                  lastname: '',
                  name: appleCredential.givenName ?? '',
                  appleId:userCredential.user!.uid ,
                  email: userCredential.user!.email!,
                  role: roleProvider.selectedRole);
              await SocialAuthRepository.loginWithApple(model, context).then((v)async{
                await saveUserId(v.user.id);
                await saveSessionToken(v.token);
                await saveUserType(roleProvider.selectedRole);

                // Reset bottom navigation to home tab for customers
              if (roleProvider.selectedRole == UserRoles.customer) {
                Provider.of<BottomNavigationProvider>(context, listen: false).setIndex(0);
              }
              navigateBasedOnRole(roleProvider.selectedRole, context);
              });
            });
          }
        } else {
          DocumentSnapshot data=await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).get();
          if(data.exists){
            String role=data['role'];
            var model=AppleLoginModel(
                firstname: '',
                lastname: '',
                name: appleCredential.givenName ?? '',
                appleId:userCredential.user!.uid ,
                email: userCredential.user!.email!,
                role: role);
            await SocialAuthRepository.loginWithApple(model, context).then((v)async{
              await saveUserId(v.user.id);
              await saveSessionToken(v.token);
              await saveUserType(role);
              // Reset bottom navigation to home tab for customers
            if (role == UserRoles.customer) {
              Provider.of<BottomNavigationProvider>(context, listen: false).setIndex(0);
            }
            navigateBasedOnRole(role, context);
            });}
          print('Existing Apple user signeasdasdd in!');
        }

        // Navigate to main screen
        // Get.offAll(DuaDay());
      } else {
        // Get.snackbar('Sign-In Error', 'Failed to sign in. Please try again.');
      }
    } catch (e) {
      print("Apple sign-in errorsssss: $e");
      // Get.snackbar("Sign-In Error", "Failed to sign in with Apple: $e");
    }

  }
  Future<void> loginWithApple(BuildContext context) async {
    final roleProvider = Provider.of<SelectRoleProvider>(context, listen: false);

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
        DocumentSnapshot data = await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (userCredential.additionalUserInfo?.isNewUser ?? false) {
          if (data.exists) {
            String role = data['role'] as String? ?? 'user'; // Fallback to 'user' if null
            var model = AppleLoginModel(
              firstname: '',
              lastname: '',
              name: appleCredential.givenName ?? '',
              appleId: userCredential.user!.uid,
              email: userCredential.user!.email!,
              role: role,
            );
            await SocialAuthRepository.loginWithApple(model, context).then((v) async {
              // Check if v and its properties are non-null
              if (v != null && v.user?.id != null && v.token != null) {
                await saveUserId(v.user!.id);
                await saveSessionToken(v.token);
                await saveUserType(v.role);

                // Reset bottom navigation to home tab for customers
            if (role == UserRoles.customer) {
              Provider.of<BottomNavigationProvider>(context, listen: false).setIndex(0);
            }
            navigateBasedOnRole(role, context);
              } else {
                print("Invalid API response: $v");
                showSnackbar(context, "Login failed: Invalid server response",
                    color: redColor);
              }
            }).catchError((e) {
              print("Error in API call: $e");
              showSnackbar(context, "Login failed: $e", color: redColor);
            });
          } else {
            await SocialServices.signOutUser();
            showSnackbar(context, AppLocalizations.of(context)!.pleasesignupfirsttousethisaccount,
                color: redColor);
          }
        } else {
          if (data.exists) {
            String role = data['role'] as String? ?? 'user'; // Fallback to 'user' if null
            var model = AppleLoginModel(
              firstname: '',
              lastname: '',
              name: appleCredential.givenName ?? '',
              appleId: userCredential.user!.uid,
              email: userCredential.user!.email!,
              role: role,
            );
            await SocialAuthRepository.loginWithApple(model, context).then((v) async {
              // Check if v and its properties are non-null
              if (v != null && v.user?.id != null && v.token != null) {
                await saveUserId(v.user!.id);
                await saveSessionToken(v.token);
                await saveUserType(role);
                // Reset bottom navigation to home tab for customers
            if (role == UserRoles.customer) {
              Provider.of<BottomNavigationProvider>(context, listen: false).setIndex(0);
            }
            navigateBasedOnRole(role, context);
              } else {
                print("Invalid API response: $v");
                showSnackbar(context, AppLocalizations.of(context)!.loginfailedinvalidserverresponse,
                    color: redColor);
              }
            }).catchError((e) {
              print("Error in API call: $e");
              showSnackbar(context, "${AppLocalizations.of(context)!.loginfailed}: $e", color: redColor);
            });
            print('Existing Apple user signed in!');
          } else {
            print("No user data found in Firestore for existing user.");
            showSnackbar(context, AppLocalizations.of(context)!.pleasesignupfirsttousethisaccount,
                color: redColor);
          }
        }
      } else {
        showSnackbar(context, AppLocalizations.of(context)!.signinerrorfailedtosiginin,
            color: redColor);
      }
    } catch (e) {
      print("Apple sign-in error: $e");
      showSnackbar(context, "{Failed to sign in with Apple}: $e", color: redColor);
    }
  }
}
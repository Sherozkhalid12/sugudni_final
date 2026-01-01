import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sugudeni/providers/auth/auth-provider.dart';
import 'package:sugudeni/providers/auth/social-provider.dart';
import 'package:sugudeni/providers/carts/cart-provider.dart';
import 'package:sugudeni/providers/wishlist-provider.dart';
import 'package:sugudeni/providers/category/category-provider.dart';
import 'package:sugudeni/providers/chatSocketProvider/chat-socket-provider.dart';
import 'package:sugudeni/providers/customer-chat-add-doc-provider.dart';
import 'package:sugudeni/providers/customer-help-provider.dart';
import 'package:sugudeni/providers/auth/driver-sign-up-provider.dart';
import 'package:sugudeni/providers/customer/customer-addresses-provider.dart';
import 'package:sugudeni/providers/driver/driver-provider.dart';
import 'package:sugudeni/providers/image-pickers-provider.dart';
import 'package:sugudeni/providers/language-provider.dart';
import 'package:sugudeni/providers/loading-provider.dart';
import 'package:sugudeni/providers/products/customer/all-customer-category-products.dart';
import 'package:sugudeni/providers/products/products-provider.dart';
import 'package:sugudeni/providers/products/seller-products-tabs/seller-draft-tab-products-provider.dart';
import 'package:sugudeni/providers/products/seller-products-tabs/seller-out-of-stock-provider.dart';
import 'package:sugudeni/providers/products/seller-products-tabs/seller-pendingqc-tab-products-provider.dart';
import 'package:sugudeni/providers/products/seller-products-tabs/seller-violation-tab-products-provider.dart';
import 'package:sugudeni/providers/reset-password-provider.dart';
import 'package:sugudeni/providers/review-tab-provider.dart';
import 'package:sugudeni/providers/review/seller-review-provider.dart';
import 'package:sugudeni/providers/select-role-provider.dart';
import 'package:sugudeni/providers/seller-add-product-provider.dart';
import 'package:sugudeni/providers/seller-bottom-nav-provider.dart';
import 'package:sugudeni/providers/messages/seller-messages-provider.dart';
import 'package:sugudeni/providers/seller-product-review-provider.dart';
import 'package:sugudeni/providers/seller-products-tab-provider.dart';
import 'package:sugudeni/providers/seller-return-order-provider.dart';
import 'package:sugudeni/providers/seller-scroll-tab-provider.dart';
import 'package:sugudeni/providers/sellerProfile/seller-address-provider.dart';
import 'package:sugudeni/providers/sellerProfile/user-profile-provider.dart';
import 'package:sugudeni/providers/shipping-provider/shipping-provider.dart';
import 'package:sugudeni/rough/bombora-payments-rough.dart';
import 'package:sugudeni/rough/currency-check.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/view/currency/your-country.dart';
import 'package:sugudeni/view/customer/home/shop-now-grid-home-page.dart';
import 'package:sugudeni/utils/extensions/media-query.dart';
import 'package:sugudeni/view/customer/home/shop-now-product-grid.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/constants/fonts.dart';
import 'package:sugudeni/utils/constants/load-assets.dart';
import 'package:sugudeni/utils/routes/app-routes.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';
import 'package:sugudeni/view/customer/products/scan/scan-product.dart';
import 'package:sugudeni/view/customer/products/scan/scanned-product-detail.dart';
import 'package:sugudeni/view/customer/setting/customer-setting-view.dart';
import 'package:sugudeni/view/seller/messages/rough-chat.dart';

import 'firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'providers/products/customer/all-customer-products.dart';
import 'providers/products/seller-products-tabs/seller-active-tab-products-provider.dart';
import 'providers/products/seller-products-tabs/seller-inactive-tab-products-provider.dart';
import 'view/customer/products/scan/bar-code-scan.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await preloadImages();
  SharedPreferences sp=await SharedPreferences.getInstance();
  final String language=sp.getString('language_code') ??'en';
  customPrint("Selected Language ================================$language");
  runApp( MyApp(local: language,));
}

class MyApp extends StatelessWidget {
  final String local;
  const MyApp({super.key, required this.local});
  @override
  Widget build(BuildContext context) {
    final screenWidth=context.screenWidth;
    final screenHeight=context.screenHeight;
    customPrint("Screen Width ==========================$screenWidth");
    customPrint("Screen Height ==========================$screenHeight");
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_)=>LoadingProvider()),
      ChangeNotifierProvider(create: (_)=>SelectRoleProvider()),
      ChangeNotifierProvider(create: (_)=>DriverSignUpProvider()),
     // ChangeNotifierProvider(create: (_)=>SellerBottomNavProvider()),
      ChangeNotifierProvider(create: (_)=>SellerScrollTabProvider()),
      ChangeNotifierProvider(create: (_)=>SellerProductsTabProvider()),
       ChangeNotifierProvider(create: (_)=>SellerMessagesProvider()),
      ChangeNotifierProvider(create: (_)=>SellerAddProductProvider()),
      ChangeNotifierProvider(create: (_)=>SellerReturnOrderProvider()),
      ChangeNotifierProvider(create: (_)=>SellerProductReviewProvider()),
      ChangeNotifierProvider(create: (_)=>ReviewTabProvider()),
      ChangeNotifierProvider(create: (_)=>SellerChatAddDocProvider()),
      ChangeNotifierProvider(create: (_)=>CustomerHelpCenterProvider()),
      ChangeNotifierProvider(create: (_)=>ResetPasswordProvider()),
      ChangeNotifierProvider(create: (_)=>ImagePickerProviders()),
      ChangeNotifierProvider(create: (_)=>AuthProvider()),
      ChangeNotifierProvider(create: (_)=>ProductsProvider()),
      ChangeNotifierProvider(create: (_)=>CategoryProvider()),
      ChangeNotifierProvider(create: (_)=>SellerActiveTabProductProvider()),
      ChangeNotifierProvider(create: (_)=>SellerInActiveTabProductProvider()),
      ChangeNotifierProvider(create: (_)=>ChatSocketProvider()),
      ChangeNotifierProvider(create: (_)=>CartProvider()),
      ChangeNotifierProvider(create: (_)=>WishlistProvider()),
      ChangeNotifierProvider(create: (_)=>CustomerFetchProductProvider()),
      ChangeNotifierProvider(create: (_)=>UserProfileProvider()),
      ChangeNotifierProvider(create: (_)=>SellerReviewProvider()),
      ChangeNotifierProvider(create: (_)=>CustomerAddressProvider()),
      ChangeNotifierProvider(create: (_)=>SocialProvider()),
      ChangeNotifierProvider(create: (_)=>CustomerFetchProductByCategoryProvider()),
      ChangeNotifierProvider(create: (_)=>SellerDraftTabProductProvider()),
      ChangeNotifierProvider(create: (_)=>SellerAddressProvider()),
      ChangeNotifierProvider(create: (_)=>ShippingProvider()),
      ChangeNotifierProvider(create: (_)=>DriverProvider()),
      ChangeNotifierProvider(create: (_)=>SellerPendingQCTabProductProvider()),
      ChangeNotifierProvider(create: (_)=>SellerViolationTabProductProvider()),
      ChangeNotifierProvider(create: (_)=>SellerOutOfStockTabProductProvider()),
      ChangeNotifierProvider(create: (_)=>ChangeLanguageProvider()),
      ChangeNotifierProvider(create: (_)=>ResetPasswordProvider()),
    ],child: ScreenUtilInit(
      designSize:   Size( 360,screenWidth<380? 685:800),
      minTextAdapt: true,
      splitScreenMode: true,
      child: GestureDetector(
        onTap: (){
          FocusManager.instance.primaryFocus!.unfocus();
        },
        child: Consumer<ChangeLanguageProvider>(
            builder: (context,provider,child){
          return MaterialApp(
            title: 'SUGUDENI',
            debugShowCheckedModeBanner: false,
            locale:local==''? const Locale('en'): provider.appLocal==null ?Locale(local):provider.appLocal,
            theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
                useMaterial3: true,
                fontFamily: AppFonts.poppins,
                scaffoldBackgroundColor:bgColor
            ),
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('fr'),
            ],
            // home: CurrencyChecker(),
            //  home: ChatScreen(senderId: '67c840373f6b059357ea6495', receiverId: '67c8ac073f6b059357ea6659'),
           initialRoute: RoutesNames.splashView,
            onGenerateRoute: Routes.generateRoute,
          );
        }),
      ),
    ),
    );
  }
}

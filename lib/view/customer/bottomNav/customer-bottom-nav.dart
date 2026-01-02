
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/providers/bottom_navigation_provider.dart';
import 'package:sugudeni/providers/chatSocketProvider/chat-socket-provider.dart';
import 'package:sugudeni/utils/constants/fonts.dart';
import 'package:sugudeni/view/customer/account/customer-account-view.dart';
import 'package:sugudeni/view/customer/cart/customer-cart-view.dart';
import 'package:sugudeni/view/customer/categories/customer-categories-view.dart';
import 'package:sugudeni/view/customer/home/customer-home-view.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/constants/app-assets.dart';
import '../../../utils/constants/colors.dart';


class CustomerBottomNavBar extends StatefulWidget {
  const CustomerBottomNavBar({super.key});

  @override
  State<CustomerBottomNavBar> createState() => _CustomerBottomNavBarState();
}

class _CustomerBottomNavBarState extends State<CustomerBottomNavBar> {
  /// Controller to handle bottom nav bar and also handles initial page
  late NotchBottomBarController _controller;

  int maxCount = 4;

  @override
  void initState() {
    // TODO: implement initState
    context.read<ChatSocketProvider>().connectSocketInInitial(context);

    // Initialize controller with provider's current index
    final bottomNavProvider = context.read<BottomNavigationProvider>();
    _controller = NotchBottomBarController(index: bottomNavProvider.currentIndex);

    super.initState();
  }
  @override
  void dispose() {
    ///NavigationControllers.controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// widget list - using IndexedStack to preserve state
    final List<Widget> bottomBarPages = [
      const CustomerHomeView(),
      const CustomerCategoriesView(),
      const CustomerCartView(),
      const CustomerAccountView()
    ];

    return Consumer<BottomNavigationProvider>(
      builder: (context, bottomNavProvider, child) {
        // Update controller when provider index changes
        _controller = NotchBottomBarController(index: bottomNavProvider.currentIndex);

        return Scaffold(
          body: IndexedStack(
            index: bottomNavProvider.currentIndex,
            children: bottomBarPages,
          ),
      extendBody: true,
      bottomNavigationBar: (bottomBarPages.length <= maxCount)
          ? AnimatedNotchBottomBar(
        /// Provide NotchBottomBarController
        notchBottomBarController: _controller,
        color: primaryColor,
        showLabel: true,
        textOverflow: TextOverflow.visible,
        maxLine: 1,
        shadowElevation: 5,
        kBottomRadius: 10.sp,


        // notchShader: const SweepGradient(
        //   startAngle: 0,
        //   endAngle: pi / 2,
        //   colors: [Colors.red, Colors.green, Colors.orange],
        //   tileMode: TileMode.mirror,
        // ).createShader(Rect.fromCircle(center: Offset.zero, radius: 8.0)),
        notchColor: primaryColor,
        /// restart app if you change removeMargins
        removeMargins: false,
        showShadow: false,
        durationInMilliSeconds: 300,
        itemLabelStyle: TextStyle(fontSize: 10.sp,color: whiteColor,fontWeight: FontWeight.w500,fontFamily: AppFonts.jost),
        elevation: 1,
        bottomBarItems:  [
          BottomBarItem(

            inActiveItem: Image.asset(AppAssets.customerHomeBottomIcon,color: whiteColor,),
            activeItem: Image.asset(AppAssets.customerHomeBottomIcon,color: whiteColor),
            itemLabel: AppLocalizations.of(context)!.home,
          ),
          BottomBarItem(
            inActiveItem: Image.asset(AppAssets.categoriesBottomIcon),
            activeItem: Image.asset(AppAssets.categoriesBottomIcon),
            itemLabel: AppLocalizations.of(context)!.categories,
          ),
          BottomBarItem(
            inActiveItem: Image.asset(AppAssets.cartBottomIcon),
            activeItem: Image.asset(AppAssets.cartBottomIcon),
            itemLabel: AppLocalizations.of(context)!.cart,
          ),
          BottomBarItem(
            inActiveItem: Image.asset(AppAssets.profileBottomIcon),
            activeItem: Image.asset(AppAssets.profileBottomIcon),
            itemLabel: AppLocalizations.of(context)!.account,
          ),

        ],
        onTap: (index) {
          context.read<BottomNavigationProvider>().setIndex(index);
        },
        kIconSize: 18.sp,
      )
          : null,
        );
      },
    );
  }
}

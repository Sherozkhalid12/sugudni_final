import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/main.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/view/seller/home/seller-home-view.dart';
import 'package:sugudeni/view/seller/messages/seller-messages-view.dart';
import 'package:sugudeni/view/seller/me/seller-profile-view.dart';
import 'package:sugudeni/view/seller/tools/seller-tools-view.dart';

import '../../../l10n/app_localizations.dart';
import '../../../providers/chatSocketProvider/chat-socket-provider.dart';
import '../../../providers/seller-bottom-nav-provider.dart';


class SellerBottomNavBarView extends StatefulWidget {

   const SellerBottomNavBarView({super.key});

  @override
  State<SellerBottomNavBarView> createState() => _SellerBottomNavBarViewState();
}

class _SellerBottomNavBarViewState extends State<SellerBottomNavBarView> {
  @override
  void initState() {
    super.initState();

    context.read<ChatSocketProvider>().connectSocketInInitial(context);
    //context.read<ChatSocketProvider>().aboutThreads(context);

  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const SellerHomeView(),
      const SellerToolsView(),
      const SellerMessagesView(),
      const SellerProfileView()
    ];
   // final provider=Provider.of<SellerBottomNavProvider>(context,listen: false);
    return ChangeNotifierProvider(create: (_)=>SellerBottomNavProvider(),
    builder: (context, child) {
      return Scaffold(
        body: Consumer<SellerBottomNavProvider>(
          builder: (context, provider, child) {
            return screens[provider.currentIndex];
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          enableFeedback: false,
          elevation: 0,
          currentIndex: context.watch<SellerBottomNavProvider>().currentIndex,
          onTap: (index) {
            context.read<SellerBottomNavProvider>().changeIndex(index);
          },
          selectedItemColor: primaryColor,
          selectedLabelStyle: TextStyle(
              color: primaryColor,
              fontWeight:FontWeight.w500,
              fontSize: 12.sp
          ),
          unselectedLabelStyle: TextStyle(
              color: textPrimaryColor.withOpacity(0.8),
              fontWeight:FontWeight.w500,
              fontSize: 12.sp
          ),

          showSelectedLabels: true,
          showUnselectedLabels: true,
          unselectedItemColor: textPrimaryColor.withOpacity(0.8),
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(AppAssets.homeBottomIcon, width: 24.w,color: context.watch<SellerBottomNavProvider>().currentIndex==0?primaryColor:textPrimaryColor.withOpacity(0.8),),
              label: AppLocalizations.of(context)!.home,
            ),
            BottomNavigationBarItem(
              icon: Image.asset(AppAssets.toolBottomIcon, width: 24.w,color: context.watch<SellerBottomNavProvider>().currentIndex==1?primaryColor:textPrimaryColor.withOpacity(0.8),),
              label: AppLocalizations.of(context)!.tools,
            ),
            BottomNavigationBarItem(
              icon: Image.asset(AppAssets.messageBottomIcon, width: 24.w,color: context.watch<SellerBottomNavProvider>().currentIndex==2?primaryColor:textPrimaryColor.withOpacity(0.8),),
              label: AppLocalizations.of(context)!.messages,
            ),
            BottomNavigationBarItem(
              icon: Image.asset(AppAssets.personBottomIcon, width: 24.w,color:context.watch<SellerBottomNavProvider>().currentIndex==3?primaryColor:textPrimaryColor.withOpacity(0.8),),
              label: AppLocalizations.of(context)!.me,
            ),
          ],
        ),
      );
    },
    );
  }
}




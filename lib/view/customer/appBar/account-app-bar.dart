import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sugudeni/repositories/user-repository.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';
import 'package:sugudeni/view/customer/trackOrder/item-to-review-bottom-sheet.dart';
import 'package:sugudeni/view/language/language-widget.dart';

import '../../../api/api-endpoints.dart';
import '../../../l10n/app_localizations.dart';

class CustomerAccountAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String? text;
  const CustomerAccountAppBar({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 70.h,
      forceMaterialTransparency: true,
      automaticallyImplyLeading: false,
      title:  Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 55.h,
            width: 60.w,
            child: Stack(
              children: [
                Container(
                  height: 55.h,
                  width: 55.w,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: whiteColor
                  ),
                ),
              FutureBuilder(
                  future:UserRepository.getSellerData(context),
                  builder: (context,snapshot){
                    if(snapshot.connectionState==ConnectionState.waiting){
                      return const SizedBox();
                    }
                    final userData = snapshot.data?.user;
                    if (userData == null) {
                      return const SizedBox();
                    }
                return   Positioned(
                  top: 5.h,
                  left: 5.w,
                  child: Container(
                    height: 42.h,
                    width: 42.w,
                    decoration:  BoxDecoration(
                      shape: BoxShape.circle,
                      image: userData.profilePic.isNotEmpty
                      ? DecorationImage(image: NetworkImage("${ApiEndpoints.productUrl}/${userData.profilePic}"),fit: BoxFit.cover)
                      : const DecorationImage(image: AssetImage(AppAssets.dummyUserThree),fit: BoxFit.cover),
                    ),
                  ),
                );
              })

              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(text:text?? AppLocalizations.of(context)!.toreceive,size:16.sp ,fontWeight: FontWeight.w700),
              MyText(text: AppLocalizations.of(context)!.myorders,size:10.sp ,fontWeight: FontWeight.w500),
            ],
          ),
          const Spacer(),
          Row(
            spacing: 10.w,
            children: [
              // Container(
              //   height:35.h,
              //   width: 35.w,
              //   decoration: const BoxDecoration(
              //       color: whiteColor,
              //       shape: BoxShape.circle,
              //       image: DecorationImage(image: AssetImage(AppAssets.customerProfileIcon),scale: 3)
              //   ),
              // ),
              GestureDetector(
                onTap: (){
                  showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: whiteColor,
                      context: context, builder: (context){
                    return Padding(
                      padding:EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: const ItemToReviewBottomSheet(),
                    );
                  });
                },
                child: Stack(
                  children: [
                    Container(
                      height:35.h,
                      width: 35.w,
                      decoration: const BoxDecoration(
                          color: whiteColor,
                          shape: BoxShape.circle,
                          image: DecorationImage(image: AssetImage(AppAssets.customerDraverIcon),scale: 3)
                      ),
                    ),
                    // Positioned(
                    //   right: 0,
                    //   child: Container(
                    //     height: 12.h,
                    //     width: 12.w,
                    //     decoration: BoxDecoration(
                    //         border: Border.all(color: whiteColor,width: 2),
                    //         color: primaryColor,
                    //         shape: BoxShape.circle
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, RoutesNames.customerSettingView);
                },
                child: Container(
                  height:35.h,
                  width: 35.w,
                  decoration: const BoxDecoration(
                      color: whiteColor,
                      shape: BoxShape.circle,
                      image: DecorationImage(image: AssetImage(AppAssets.settingIcon),scale: 3)
                  ),
                ),
              ),
              LanguageSelector()
            ],
          )
        ],
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight+30.h);
}

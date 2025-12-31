import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/view/customer/cart/customer-add-card-view.dart';

import '../../../l10n/app_localizations.dart';

class CustomerPaymentMethodView extends StatelessWidget {
  const CustomerPaymentMethodView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SymmetricPadding(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              30.height,
              GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back_ios)),
              5.height,
              MyText(text:AppLocalizations.of(context)!.setting, size: 28.sp, fontWeight: FontWeight.w700),
              5.height,
              MyText(text: AppLocalizations.of(context)!.paymentmethod, size: 16.sp, fontWeight: FontWeight.w500),
              10.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 155.h,
                    width: 269.w,
                    decoration: BoxDecoration(
                      color: const Color(0xffF1F4FE),
                      borderRadius: BorderRadius.circular(11.r)
                    ),
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 12.sp),
                      child: Column(
                        children: [
                          10.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(AppAssets.masterCardIcon,scale: 3,),
                              Container(
                                height: 35.h,
                                width:35.w ,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xffE5EBFC)
                                ),
                                child: Center(
                                  child: Image.asset(AppAssets.settingIcon,scale: 3,),
                                ),
                              )
                            ],
                          ),
                          30.height,
                          const Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyText(text: "* * * *     * * * * "),
                              MyText(text: "157 "),
                            ],
                          ),
                          15.height,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('AMANDA',style: GoogleFonts.nunitoSans(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600
                              ),),
                              Text('12/02',style: GoogleFonts.nunitoSans(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600
                              ),),

                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      showModalBottomSheet(
                          isScrollControlled: true,
                          context: context, builder: (context){

                        return Padding(
                          padding:EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: const CustomerAddCardView(),
                        );
                      });
                    },
                    child: Container(
                      height: 155.h,
                      width: 43.w,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(11.r)
                      ),
                      child: Center(
                        child: Image.asset(AppAssets.addIcon,scale: 3),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

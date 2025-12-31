
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';

class GrabDeal extends StatelessWidget {
  const GrabDeal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height:138.h,
      width: double.infinity,
      decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            pinkLinearOne,
            pinkLinearTwo
          ])
      ),
      child:  Column(
        children: [

          SizedBox(
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [

                Image.asset(AppAssets.grabDealRectangle,scale: 2.6,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('12.12',style: GoogleFonts.julee(
                        color: whiteColor,
                        fontSize: 16.sp
                    ),),
                    2.width,
                    Container(
                      decoration: BoxDecoration(
                          color: lightPinkColor,
                          borderRadius: BorderRadius.circular(4.r)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Center(
                          child: MyText(text: "11 Dec -\n31Jan",size: 7.sp,fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    15.width,
                    ShaderMask(
                      shaderCallback: (bounds) {
                        return const LinearGradient(
                          colors: [
                            Color(0xffFFFFFF),
                            Color(0xffFD61FF),
                          ],
                        ).createShader(
                          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                        );
                      },
                      blendMode: BlendMode.srcIn,
                      child: Text(
                        "Grab Deals Now!",
                        style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                    )
                  ],
                ),
                Positioned(
                    right: 3.w,
                    child: Image.asset(AppAssets.grabDealPicTwo,scale: 2.5,)),
                Positioned(
                    left: 1.w,
                    child: Image.asset(AppAssets.grabDealPic,scale: 2.5,)),

              ],
            ),
          ),
          5.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GrabDealsWidget(title: "Hot Deals", img: AppAssets.hotDeals),
              GrabDealsWidget(title: "Clearance Sale", img: AppAssets.clearenseSale),
              GrabDealsWidget(title: "Back to School", img: AppAssets.backToSchool),
              GrabDealsWidget(title: "Baby Products", img: AppAssets.babyProducts),
            ],
          )
        ],
      ),
    );
  }
}
class GrabDealsWidget extends StatelessWidget {
  final String title;
  final String img;
  const GrabDealsWidget({super.key, required this.title, required this.img});

  @override
  Widget build(BuildContext context) {
    return   Container(
      height: 92.h,
      // width: 91.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r),
          color: lightPinkColor
      ),child: Column(
      children: [
        5.height,
        Container(
          height: 68.h,
          width: 75.w,
          margin: const EdgeInsets.only(left: 5,right: 5),
          decoration: BoxDecoration(
            color: whiteColor,
            image:  DecorationImage(image: AssetImage(img),fit: BoxFit.contain),
            borderRadius: BorderRadius.circular(3.r),
          ),
        ),
        MyText(text: title,fontWeight: FontWeight.w500,size: 10.sp,)
      ],
    ),
    );
  }
}

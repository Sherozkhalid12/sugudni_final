import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/providers/review-tab-provider.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/constants/fonts.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/media-query.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';

import '../../../utils/constants/app-assets.dart';
import '../appBar/customer-used-appbar.dart';

class CustomerProductReviewView extends StatelessWidget {
  const CustomerProductReviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        forceMaterialTransparency: true,
        toolbarHeight: 70.h,
        flexibleSpace: Container(
          color: whiteColor,
        ),
        title:const CustomerUsedAppBar(),
      ),
      body: SymmetricPadding(
        child: Column(
          children: [
            10.height,
            Container(
              color: whiteColor,
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 12.w,vertical: 3.h),
                child: Row(
                  children: [
                    MyText(text: "4.4",size: 22.sp,fontWeight: FontWeight.w700),
                    5.width,
                    Row(
                      children: List.generate(5, (index) => Image.asset(AppAssets.starIcon,scale: 3,),),
                    ),
                    const Spacer(),
                    MyText(text: "1,762 Reviews",size: 12.sp,fontWeight: FontWeight.w500,color: textPrimaryColor.withOpacity(0.7),),

                  ],
                ),
              ),
            ),
            10.height,
             SizedBox(
               width: double.infinity,
               child: Stack(
                 //alignment: Alignment.center,
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Positioned(
                    // left: 0,
                    // right: 0,
                    child: Consumer<ReviewTabProvider>(builder: (context,provider,child){
                      return RatingTabWidget(
                          onPressed: (){
                            provider.changeTab(ReviewTabs.all);
                          },
                          isSelected:provider.selectedTab== ReviewTabs.all,
                          title: ReviewTabs.all);
                    }),
                  ),
                  Align(alignment: Alignment.center,
                    child: Consumer<ReviewTabProvider>(builder: (context,provider,child){
                      return RatingTabWidget(
                          onPressed: (){
                            provider.changeTab(ReviewTabs.withPhotos);
                          },
                          isSelected:provider.selectedTab== ReviewTabs.withPhotos,
                          title: ReviewTabs.withPhotos);
                    }),
                  ),
                  Positioned(
                    right: 0,
                    child: Consumer<ReviewTabProvider>(builder: (context,provider,child){
                      return RatingTabWidget(
                          onPressed: (){
                            provider.changeTab(ReviewTabs.withVideos);
                          },
                          isSelected:provider.selectedTab== ReviewTabs.withVideos,
                          title: ReviewTabs.withVideos);
                    }),
                  ),

                ],
                           ),
             ),
            10.height,
            const Divider(
              color: greyColor,
            ),
            10.height,
           Expanded(
             child: ListView.builder(
               itemCount: 6,
                 scrollDirection: Axis.vertical,
                 itemBuilder: (context,index){
               return  Container(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Row(
                       children: [
                         Container(
                           width: 50.w,
                           height: 50.h,
                           decoration: const BoxDecoration(
                               shape: BoxShape.circle,
                               color: Color(0xffD9D9D9)
                           ),
                           child: Center(
                             child: MyText(text: "O",size:22.sp ,fontWeight: FontWeight.w700),
                           ),
                         ),
                         10.width,
                         Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             MyText(text: "Olivia grace",size: 12.sp,fontWeight: FontWeight.w500),
                             MyText(text: "Olivia grace | Red Chili",size: 12.sp,fontWeight: FontWeight.w500),
                           ],
                         )
                       ],
                     ),
                     10.height,
                     MyText(
                         overflow: TextOverflow.clip,
                         text: "This red chili product delivers exceptional flavor and heat, perfect for enhancing any dish with its fresh and vibrant quality.",size: 12.sp,fontWeight: FontWeight.w500),
                     10.height,
                     SizedBox(
                       height:90.h ,
                       child: ListView.builder(
                           scrollDirection: Axis.horizontal,
                           shrinkWrap: true,
                           itemCount: 4,
                           itemBuilder: (context,index){

                             return  Container(
                               height:90.h ,
                               width: 90.w,
                               margin: EdgeInsets.only(right: 7.w),
                               decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(6.r),
                                   image: const DecorationImage(image: AssetImage(AppAssets.dummyChilliIcon),fit: BoxFit.cover)
                               ),
                               child:index==0? Center(
                                 child: Image.asset(AppAssets.playIcon,scale: 3,),
                               ):null,
                             );
                           }),
                     ),
                     10.height,
                     const Divider(
                       color: greyColor,
                     ),
                     10.height,

                     Row(
                       children: [
                         Image.asset(AppAssets.likeIcon,scale: 3,),
                         5.width,
                         MyText(text: "92 Likes",size: 9.sp,fontWeight: FontWeight.w500,color: textPrimaryColor.withOpacity(0.7),),
                         20.width,
                         Image.asset(AppAssets.commentIcon,scale: 3,),
                         5.width,
                         MyText(text: "11 Comment",size: 9.sp,fontWeight: FontWeight.w500,color: textPrimaryColor.withOpacity(0.7),),
                         const Spacer(),
                         const Icon(Icons.more_vert,color: primaryColor,)
                       ],
                     ),
                     10.height,

                     const Divider(
                       color: greyColor,

                     ),

                   ],
                 ),
               );
             }),
           )


          ],
        ),
      ),
    );
  }
}
class InwardSlantTabPainter extends CustomPainter {
  final Color color;

  InwardSlantTabPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0) // Top-left corner
      ..lineTo(size.width - 30, 0) // Top-right slant inward
      ..lineTo(size.width, size.height) // Bottom-right corner
      ..lineTo(30, size.height) // Bottom-left slant inward
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
class RatingTabWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isSelected;
  final String title;

  const RatingTabWidget({super.key, this.onPressed, required this.isSelected, required this.title});

  @override
  Widget build(BuildContext context) {
    final screenWidth=context.screenWidth;
    return GestureDetector(
      onTap: onPressed,
      child: CustomPaint(
        painter: InwardSlantTabPainter(isSelected==true?primaryColor:whiteColor),
        child: Container(
          width: screenWidth*0.34,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child:  MyText(text: title,color: isSelected==true?whiteColor:textPrimaryColor,
          size: 12.sp,
            fontWeight: FontWeight.w600,
          )
        ),
      ),
    );
  }
}

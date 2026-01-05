import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/providers/customer-chat-add-doc-provider.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';
import 'package:sugudeni/view/customer/products/customer-all-products-view.dart';
import 'package:sugudeni/view/customer/account/customer-to-receive-order-view.dart';

import '../../../utils/constants/colors.dart';

class ChatWithOwnerView extends StatelessWidget {
  const ChatWithOwnerView({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String,dynamic>> messageList=[
      {
        'text':"Hi, I hope you are good",
        'isSender':false
      },
      {
        'text':"I have facing some issues.",
        'isSender':false
      },
      {
        'text':'Red chili is a vibrant spice known for its intense heat and rich flavor, making it a staple in cuisines worldwide. Packed with capsaicin, it not only enhances taste but also offers health benefits like improved metabolism and antioxidants. Red chili is a vibrant spice known for its intense heat and rich flavor, making it a staple in cuisines worldwide. Packed with capsaicin, it not only enhances taste but also offers health benefits like improved ',
        'isSender':true
      },
      {
        'text':"That's good to know.",
        'isSender':false
      },
      {
        'text':"Thank you so much for your help! I appreciate it.",
        'isSender':false
      },
      {
        'text':"You're very welcome!\nIf you have any more questions in the future or need assistance with anything else, feel free to reach out.",
        'isSender':true
      },
      {
        'text':'Happy shopping!',
        'isSender':true
      },
    ];
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 70.h,
        flexibleSpace: Container(
          color: whiteColor,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: const Icon(Icons.arrow_back_ios)),
            const Spacer(),
            MyText(text: "AMY Online\nShopping Store",size: 16.sp,fontWeight: FontWeight.w600,),
            const Spacer(),
            Image.asset(AppAssets.shopHomePageIcon,scale: 2,width: 20.w,height: 20.h,color: primaryColor,),
            10.width,
            Image.asset(AppAssets.gridIcon,scale: 2,width: 20.w,height: 20.h,color: primaryColor,),

          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 9,
              child: SymmetricPadding(
                child: ListView.builder(
                    itemCount: messageList.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context,index){
                      var messageData=messageList[index];
                      bool isSender=messageData['isSender'];
                      return isSender==true?
                      Align(
                        alignment: Alignment.centerLeft,

                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 40.h,
                              width: 40.w,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: roundProfileColor
                              ),
                              child: Center(
                                child: MyText(text: "AMY",color: whiteColor,size: 12.sp,fontWeight: FontWeight.w600),
                              ),
                            ),
                            5.width,
                            Flexible(
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 5.h),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.sp),
                                    color: whiteColor,
                                    border: Border.all(color: primaryColor,width: 1)
                                ),
                                child: Padding(
                                  padding:EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
                                  child: MyText(
                                    text: messageData['text'],
                                    color: blackColor,
                                    fontWeight: FontWeight.w500,
                                    size: 11.sp,
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ) :
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5.h),

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.sp),
                            color: whiteColor,
                              border: Border.all(color: const Color(0xffD5FF00),width: 1)

                          ),
                          child: Padding(
                            padding:EdgeInsets.symmetric(horizontal: 10.w,vertical: 15.h),
                            child: MyText(
                              text: messageData['text'],
                              color: blackColor,
                              fontWeight: FontWeight.w500,
                              size: 11.sp,
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ),
                      );
                    }),
              )),
          const Spacer(),
          Consumer<SellerChatAddDocProvider>(builder: (context,provider,child){
            return Container(
              // height: 75.h,
              width: double.infinity,
              color: whiteColor,
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 12.w,vertical: 15.h),
                child: Column(
                  spacing: 20.h,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                     provider.isOpenDoc==false?
                     GestureDetector(
                          onTap: (){
                            provider.toggle();
                          },
                          child: Container(
                            height: 42.h,
                            width: 58.w,
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(10.r),
                                image: const DecorationImage(image: AssetImage(AppAssets.addIcon),scale: 3)
                            ),
                          ),
                        ):
                        GestureDetector(
                          onTap: (){
                            provider.toggle();
                          },
                          child: Image.asset(AppAssets.cancelIcon,scale: 2.5,),
                        ),
                        7.width,
                        Flexible(
                            child: TextFormField(
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10.sp,
                                  color: const Color(0xff545454)
                              ),
                              decoration: InputDecoration(
                                hintText: "Type your message",
                                suffixIcon: Image.asset(AppAssets.emojiIcon,scale: 2,),
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10.sp,
                                    color: const Color(0xff545454)
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide: const BorderSide(
                                    color: primaryColor,

                                  ),
                                ),
                                enabledBorder:OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide: const BorderSide(
                                    color: primaryColor,

                                  ),
                                ) ,
                                focusedBorder:OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide: const BorderSide(
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            )),
                        7.width,
                        provider.isOpenDoc==false?       Container(
                          height: 42.h,
                          width: 58.w,
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(10.r),
                              image: const DecorationImage(image: AssetImage(AppAssets.sendIcon),scale: 3)
                          ),
                        ):const SizedBox(),
                      ],
                    ),

                    provider.isOpenDoc?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          spacing: 10.h,
                          children: [
                            Image.asset(AppAssets.cameraImg,scale: 3,),
                            MyText(text: "Camera",size: 10.sp,fontWeight: FontWeight.w500,color: const Color(0xff545454),)
                          ],
                        ),
                        Column(
                          spacing: 10.h,
                          children: [
                            Image.asset(AppAssets.photosImg,scale: 3,),
                            MyText(text: "Photos",size: 10.sp,fontWeight: FontWeight.w500,color: const Color(0xff545454),)
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            provider.toggle(); // Close the options menu
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CustomerAllProductsView(),
                              ),
                            );
                          },
                          child: Column(
                            spacing: 10.h,
                            children: [
                              Image.asset(AppAssets.productChatImg,scale: 3,),
                              MyText(text: "Products",size: 10.sp,fontWeight: FontWeight.w500,color: const Color(0xff545454),)
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            provider.toggle(); // Close the options menu
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CustomerToReceiveOrderView(),
                              ),
                            );
                          },
                          child: Column(
                            spacing: 10.h,
                            children: [
                              Image.asset(AppAssets.ordersChatImg,scale: 3,),
                              MyText(text: "Orders",size: 10.sp,fontWeight: FontWeight.w500,color: const Color(0xff545454),)
                            ],
                          ),
                        )

                        ,                    ],
                    ):const SizedBox()
                  ],
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}

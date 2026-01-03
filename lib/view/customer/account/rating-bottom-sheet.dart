import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/models/delivery/AddDeliveryRatingModel.dart';
import 'package:sugudeni/models/review/AddReviewModel.dart';
import 'package:sugudeni/providers/loading-provider.dart';
import 'package:sugudeni/repositories/review/review-repositoy.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/round-button.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/customWidgets/text-field.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/customWidgets/my-text.dart';

class RatingBottomSheet extends StatefulWidget {
  final String? productId;
  final String? orderId;
  final String? img;
  final String? title;
  final bool? isForDelivery;
  final bool? bulk;
  const RatingBottomSheet({super.key, this.productId, this.img,this.title, this.isForDelivery=false, this.orderId, this.bulk=false});

  @override
  State<RatingBottomSheet> createState() => _RatingBottomSheetState();
}

class _RatingBottomSheetState extends State<RatingBottomSheet> {
  int _selectedRating = 0; // Holds the current rating value
  final textController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    final loadingProvider=Provider.of<LoadingProvider>(context,listen: false);
    return SymmetricPadding(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 15.h,
        children: [
          0.height,
          MyText(
            text: AppLocalizations.of(context)!.review,
            size: 18.sp,
            fontWeight: FontWeight.w700,
          ),
          Row(
            children: [
              Container(
                height: 39.h,
                width: 39.w,
                decoration:  BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(
                            widget.bulk==true?widget.img! :"${ApiEndpoints.productUrl}/${widget.img}"),
                        fit: BoxFit.cover)),
              ),
              10.width,
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      overflow: TextOverflow.clip,
                      text:widget.title?? "Lorem ipsum dolor sit amet consectetur",
                      size: 12.sp,
                    ),
                    MyText(
                      overflow: TextOverflow.clip,

                      text: "Product Id #${widget.productId?? 92287157}",
                      size: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              )
            ],
          ),
          Row(
            children: List.generate(
              5,
              (index) => GestureDetector(
                onTap: (){
                  setState(() {
                    _selectedRating = index + 1; // Update the selected rating
                  });
                },
                child: Image.asset(
                  AppAssets.starIcon,
                  color:index < _selectedRating ? Colors.yellow : const Color(0xffFFD8BD),
                ),
              ),
            ),
          ),
           CustomTextFiled(
            controller: textController,
            hintText: AppLocalizations.of(context)!.yourcomment,
            maxLine: 5,
            isShowPrefixIcon: false,
          ),
          // Spacer(),
          RoundButton(
              borderRadius: BorderRadius.circular(9.r),
              title: "${AppLocalizations.of(context)!.sayit} !",
              isLoad: true,
              onTap:widget.isForDelivery==false? () async{
                if(textController.text.isEmpty){
                  showToast(AppLocalizations.of(context)!.pleaseaddyourcomment, redColor);


                  return;
                }
                if(_selectedRating==0){
                  showToast(AppLocalizations.of(context)!.pleaserate, redColor);
                  return;
                }
                var model=AddReviewModel(text: textController.text, productId: widget.productId!, rate: _selectedRating);
                loadingProvider.setLoading(true);
                try{
                  await ReviewRepository.addReview(model, context).then((v){
                    loadingProvider.setLoading(false);
                    AwesomeDialog(
                      context: context,
                      animType: AnimType.scale,
                      dialogType: DialogType.info,
                      dialogBackgroundColor: whiteColor,
                      barrierColor: whiteColor.withAlpha(getAlpha(0.3)),
                      customHeader: Image.asset(AppAssets.ratingDoneIcon,scale: 2.5,),
                      body: Column(
                        children: [

                          MyText(text: "${AppLocalizations.of(context)!.done} !",size: 19.sp,fontWeight: FontWeight.w700,),
                          MyText(text: AppLocalizations.of(context)!.thatyouforyourreview,size: 13.sp,fontWeight: FontWeight.w600,textAlignment: TextAlign.center,),
                          10.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              5,
                                  (index) => Image.asset(
                                AppAssets.starIcon,
                                color: index < _selectedRating
                                    ? Colors.yellow
                                    :  const Color(0xffFFD8BD),
                              ),
                            ),
                          ),
                          10.height
                        ],
                      ),

                    ).show();
                    showSnackbar(context, AppLocalizations.of(context)!.ratingaddedsuccessfully,color: greenColor);
                  });
                }catch(e){
                  AwesomeDialog(
                    context: context,
                    animType: AnimType.scale,
                    dialogType: DialogType.info,
                    dialogBackgroundColor: whiteColor,
                    barrierColor: whiteColor.withAlpha(getAlpha(0.3)),
                    customHeader: Image.asset(AppAssets.ratingDoneIcon,scale: 2.5,),
                    body: Column(
                      children: [

                        MyText(text: "${AppLocalizations.of(context)!.alreadyreviewed}!",size: 19.sp,fontWeight: FontWeight.w700,),
                        MyText(text: AppLocalizations.of(context)!.youhavealreadyreviewedthisproduct,size: 13.sp,fontWeight: FontWeight.w600,textAlignment: TextAlign.center,),
                        10.height,

                      ],
                    ),

                  ).show();
                  loadingProvider.setLoading(false);
                }
                // Future.delayed(
                //     const Duration(milliseconds: 200),(){
                //   return  AwesomeDialog(
                //     context: context,
                //     animType: AnimType.scale,
                //     dialogType: DialogType.info,
                //     dialogBackgroundColor: whiteColor,
                //     barrierColor: whiteColor.withAlpha(getAlpha(0.3)),
                //     customHeader: Image.asset(AppAssets.ratingDoneIcon,scale: 2.5,),
                //     body: Column(
                //       children: [
                //
                //         MyText(text: "Done !",size: 19.sp,fontWeight: FontWeight.w700,),
                //         MyText(text: "Thank you for your\nreview",size: 13.sp,fontWeight: FontWeight.w600,textAlignment: TextAlign.center,),
                //         10.height,
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: List.generate(
                //             5,
                //                 (index) => Image.asset(
                //               AppAssets.starIcon,
                //               color: index < _selectedRating
                //                   ? Colors.yellow
                //                   :  const Color(0xffFFD8BD),
                //             ),
                //           ),
                //         ),
                //         10.height
                //       ],
                //     ),
                //
                //   ).show();
                // });

              }:
                  () async{
                if(textController.text.isEmpty){
                  showToast(AppLocalizations.of(context)!.pleaseaddyourcomment, redColor);


                  return;
                }
                if(_selectedRating==0){
                  showToast(AppLocalizations.of(context)!.pleaserate, redColor);
                  return;
                }
                var model=AddDeliveryRatingModel( rating: _selectedRating, ratingDescription: textController.text);
                loadingProvider.setLoading(true);
                try{
                  // Use orderId for delivery reviews, not productId
                  final orderIdToUse = widget.orderId ?? widget.productId;
                  if (orderIdToUse == null || orderIdToUse.isEmpty) {
                    loadingProvider.setLoading(false);
                    showToast(AppLocalizations.of(context)!.pleaserate, redColor);
                    return;
                  }
                  await ReviewRepository.addReviewToDelivery(model, orderIdToUse, context).then((v){
                    loadingProvider.setLoading(false);
                    AwesomeDialog(
                      context: context,
                      animType: AnimType.scale,
                      dialogType: DialogType.info,
                      dialogBackgroundColor: whiteColor,
                      barrierColor: whiteColor.withAlpha(getAlpha(0.3)),
                      customHeader: Image.asset(AppAssets.ratingDoneIcon,scale: 2.5,),
                      body: Column(
                        children: [

                          MyText(text: "${AppLocalizations.of(context)!.done} !",size: 19.sp,fontWeight: FontWeight.w700,),
                          MyText(text: AppLocalizations.of(context)!.thatyouforyourreview,size: 13.sp,fontWeight: FontWeight.w600,textAlignment: TextAlign.center,),
                          10.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              5,
                                  (index) => Image.asset(
                                AppAssets.starIcon,
                                color: index < _selectedRating
                                    ? Colors.yellow
                                    :  const Color(0xffFFD8BD),
                              ),
                            ),
                          ),
                          10.height
                        ],
                      ),

                    ).show();
                    showSnackbar(context, AppLocalizations.of(context)!.ratingaddedsuccessfully,color: greenColor);
                  });
                }catch(e){
                  AwesomeDialog(
                    context: context,
                    animType: AnimType.scale,
                    dialogType: DialogType.info,
                    dialogBackgroundColor: whiteColor,
                    barrierColor: whiteColor.withAlpha(getAlpha(0.3)),
                    customHeader: Image.asset(AppAssets.ratingDoneIcon,scale: 2.5,),
                    body: Column(
                      children: [

                        MyText(text: "${AppLocalizations.of(context)!.alreadyreviewed}!",size: 19.sp,fontWeight: FontWeight.w700,),
                        MyText(text: AppLocalizations.of(context)!.youhavealreadyreviewedthisproduct,size: 13.sp,fontWeight: FontWeight.w600,textAlignment: TextAlign.center,),
                        10.height,

                      ],
                    ),

                  ).show();
                  loadingProvider.setLoading(false);
                }
                // Future.delayed(
                //     const Duration(milliseconds: 200),(){
                //   return  AwesomeDialog(
                //     context: context,
                //     animType: AnimType.scale,
                //     dialogType: DialogType.info,
                //     dialogBackgroundColor: whiteColor,
                //     barrierColor: whiteColor.withAlpha(getAlpha(0.3)),
                //     customHeader: Image.asset(AppAssets.ratingDoneIcon,scale: 2.5,),
                //     body: Column(
                //       children: [
                //
                //         MyText(text: "Done !",size: 19.sp,fontWeight: FontWeight.w700,),
                //         MyText(text: "Thank you for your\nreview",size: 13.sp,fontWeight: FontWeight.w600,textAlignment: TextAlign.center,),
                //         10.height,
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: List.generate(
                //             5,
                //                 (index) => Image.asset(
                //               AppAssets.starIcon,
                //               color: index < _selectedRating
                //                   ? Colors.yellow
                //                   :  const Color(0xffFFD8BD),
                //             ),
                //           ),
                //         ),
                //         10.height
                //       ],
                //     ),
                //
                //   ).show();
                // });

              }),
          10.height,
        ],
      ),
    );
  }
}

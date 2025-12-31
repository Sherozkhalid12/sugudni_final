
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/providers/customer-help-provider.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/round-button.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';
import 'package:sugudeni/view/customer/help/select-order-issue-bottom-sheet.dart';

class SelectMainIssueBottomSheet extends StatelessWidget {
  const SelectMainIssueBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SymmetricPadding(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 10.h,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            0.height,
            Row(
              children: [
                MyText(text: "What's your issue?",size: 22.sp,fontWeight: FontWeight.w700,),
                const Spacer(),
                GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Image.asset(AppAssets.cancelIcon,scale: 2,))
              ],
            ),
            Consumer<CustomerHelpCenterProvider>(
                builder: (context,provider,child){
              return IssueWidget(
                width: 125.w,
                  title: MainIssues.orderIssues,
                  isSelected: provider.selectedMainIssue==MainIssues.orderIssues,
                  onPressed: (){
                    provider.changeMainIssue(MainIssues.orderIssues);
                  });
            }),
            Consumer<CustomerHelpCenterProvider>(
                builder: (context,provider,child){
                  return IssueWidget(
                      width: 138.w,
                      title: MainIssues.itemQuantity,
                      isSelected: provider.selectedMainIssue==MainIssues.itemQuantity,
                      onPressed: (){
                        provider.changeMainIssue(MainIssues.itemQuantity);
                      });
                }),
            Consumer<CustomerHelpCenterProvider>(
                builder: (context,provider,child){
                  return IssueWidget(
                      width: 147.w,
                      title: MainIssues.paymentIssues,
                      isSelected: provider.selectedMainIssue==MainIssues.paymentIssues,
                      onPressed: (){
                        provider.changeMainIssue(MainIssues.paymentIssues);
                      });
                }),
            Consumer<CustomerHelpCenterProvider>(
                builder: (context,provider,child){
                  return IssueWidget(
                      width: 158.w,
                      title: MainIssues.technicalIssues,
                      isSelected: provider.selectedMainIssue==MainIssues.technicalIssues,
                      onPressed: (){
                        provider.changeMainIssue(MainIssues.technicalIssues);
                      });
                }),
            Consumer<CustomerHelpCenterProvider>(
                builder: (context,provider,child){
                  return IssueWidget(
                      width: 73.w,
                      title: MainIssues.other,
                      isSelected: provider.selectedMainIssue==MainIssues.other,
                      onPressed: (){
                        provider.changeMainIssue(MainIssues.other);
                      });
                }),

            Row(
              spacing: 5.w,
              children: [
                Flexible(
                  child: RoundButton(
                      borderRadius: BorderRadius.circular(10.r),
                      title: "Next", onTap: (){
                        Navigator.pop(context);
                        Future.delayed(Duration(milliseconds: 3),() =>
                            showModalBottomSheet(context: context,
                                isDismissible: false
                                ,
                                builder: (context){
                                  return const SelectOrderIssueBottomSheet();
                                }),);
                  }),
                ),
                Container(
                  height: 26.w,
                  width: 26.w,
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(7.r)
                  ),
                  child: Center(
                    child: Image.asset(AppAssets.cancelIcon,color: whiteColor,scale: 3),
                  ),
                )
              ],
            ),
            10.height
          ],
        ),
      ),
    );
  }
}
class IssueWidget extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onPressed;
  final double? width;

  const IssueWidget({super.key, required this.title, required this.isSelected, required this.onPressed, this.width});

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 40.h,
        width:isSelected==true?(width!+20.w): width?? 142.w,
        decoration: BoxDecoration(
            border: Border.all(
                color: primaryColor
            ),
            color:isSelected==true? primaryColor:transparentColor,
            borderRadius: BorderRadius.circular(9.r)
        ),
        child: Padding(
          padding:  EdgeInsets.only(left: 8.w,right: 8.w),
          child: Row(
            spacing: 3.w,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Container(
              //   height: 22.h,
              //   width: 22.w,
              //   decoration: BoxDecoration(
              //       color: primaryColor,
              //       border: Border.all(color: whiteColor,width: 3
              //       ),
              //       shape: BoxShape.circle
              //   ),
              //   child: Center(
              //     child: Icon(Icons.check),
              //   ),
              // ),
              isSelected==true? Icon(Icons.check_circle_outline,color: whiteColor,):SizedBox(),
              MyText(text: title,

                color: isSelected==true? whiteColor:primaryColor,
                fontWeight: FontWeight.w500,

              )
            ],
          ),
        ),
      ),
    );
  }
}

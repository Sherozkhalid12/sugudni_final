
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
import 'package:sugudeni/view/customer/help/select-issue-bottom-sheet.dart';
import 'package:sugudeni/view/customer/help/select-order-bottom-sheet.dart';

class SelectOrderIssueBottomSheet extends StatelessWidget {
  const SelectOrderIssueBottomSheet({super.key});

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
                MyText(text: "Order issues",size: 22.sp,fontWeight: FontWeight.w700,),
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
                    width: 227.w,
                      title: OrderIssues.orderIssues,
                      isSelected: provider.selectedOrderIssue==OrderIssues.orderIssues,
                      onPressed: (){
                        provider.changeOrderIssue(OrderIssues.orderIssues);
                      });
                }),
            Consumer<CustomerHelpCenterProvider>(
                builder: (context,provider,child){
                  return IssueWidget(
                      width: 225.w,

                      title: OrderIssues.itemQuantity,
                      isSelected: provider.selectedOrderIssue==OrderIssues.itemQuantity,
                      onPressed: (){
                        provider.changeOrderIssue(OrderIssues.itemQuantity);
                      });
                }),
            Consumer<CustomerHelpCenterProvider>(
                builder: (context,provider,child){
                  return IssueWidget(
                      width: 225.w,

                      title: OrderIssues.paymentIssues,
                      isSelected: provider.selectedOrderIssue==OrderIssues.paymentIssues,
                      onPressed: (){
                        provider.changeOrderIssue(OrderIssues.paymentIssues);
                      });
                }),
            Consumer<CustomerHelpCenterProvider>(
                builder: (context,provider,child){
                  return IssueWidget(
                      width: 215.w,

                      title: OrderIssues.technicalIssues,
                      isSelected: provider.selectedOrderIssue==OrderIssues.technicalIssues,
                      onPressed: (){
                        provider.changeOrderIssue(OrderIssues.technicalIssues);
                      });
                }),
            Consumer<CustomerHelpCenterProvider>(
                builder: (context,provider,child){
                  return IssueWidget(
                      width: 73.w,

                      title: OrderIssues.other,
                      isSelected: provider.selectedOrderIssue==OrderIssues.other,
                      onPressed: (){
                        provider.changeOrderIssue(OrderIssues.other);
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
                    Future.delayed(const Duration(milliseconds: 3),() =>
                        showModalBottomSheet(context: context,
                            isDismissible: false
                            ,
                            builder: (context){
                              return const SelectOrderBottomSheet();
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

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/providers/seller-product-review-provider.dart';
import 'package:sugudeni/providers/seller-return-order-provider.dart';
import 'package:sugudeni/utils/customWidgets/app-bar-title-widget.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/search-product-textfield.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';

import '../../../utils/constants/app-assets.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/customWidgets/tab-bar-widget.dart';
import '../../../utils/routes/routes-name.dart';
import '../products/seller-my-products-view.dart';

class SellerIncomeView extends StatelessWidget {
  const SellerIncomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final productsImages=[
      AppAssets.dummyChilliIcon,
      AppAssets.dummyProductTwo,
      AppAssets.dummyProductThree,
      AppAssets.dummyProductFour,
      AppAssets.dummyProductTwo,

    ];
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.h,
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RoundIconButton(onPressed: (){
              Navigator.pop(context);
            },iconUrl: AppAssets.arrowBack),
            const Spacer(),
            const AppBarTitleWidget(title: "MY Income"),
            20.width,
            const Spacer()
          ],
        ),
      ),
      body:  Column(
        children: [
          15.height,
          10.height,
        ],
      ),
    );
  }
}

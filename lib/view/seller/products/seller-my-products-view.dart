import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/providers/products/products-provider.dart';
import 'package:sugudeni/providers/products/seller-products-tabs/seller-active-tab-products-provider.dart';
import 'package:sugudeni/providers/products/seller-products-tabs/seller-inactive-tab-products-provider.dart';
import 'package:sugudeni/providers/seller-products-tab-provider.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/search-product-textfield.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';

import '../../../l10n/app_localizations.dart';
import '../../../providers/seller-scroll-tab-provider.dart';
import '../../../utils/customWidgets/app-bar-title-widget.dart';
import '../../../utils/customWidgets/tab-bar-widget.dart';
import '../home/seller-home-view.dart';

class SellerMyProductsView extends StatefulWidget {
  const SellerMyProductsView({super.key});

  @override
  State<SellerMyProductsView> createState() => _SellerMyProductsViewState();
}

class _SellerMyProductsViewState extends State<SellerMyProductsView> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final searchController=TextEditingController();
    final sellerActiveTab=Provider.of<SellerActiveTabProductProvider>(context,listen: false);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          // Clean up resources before popping
          Provider.of<SellerActiveTabProductProvider>(context, listen: false).resetFilter();
          Provider.of<SellerActiveTabProductProvider>(context, listen: false).clearResources();
          // Pop the route
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 80.h,
          forceMaterialTransparency: true,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RoundIconButton(onPressed: (){
                // Clean up resources before popping
                Provider.of<SellerActiveTabProductProvider>(context, listen: false).resetFilter();
                Provider.of<SellerActiveTabProductProvider>(context, listen: false).clearResources();
                Navigator.pop(context);
              },iconUrl: AppAssets.arrowBack),
               AppBarTitleWidget(title: AppLocalizations.of(context)!.myproducts),


              RoundIconButton(onPressed: (){
                context.read<ProductsProvider>().clearResources();

                Navigator.pushNamed(context, RoutesNames.sellerAddProductView);
              },iconUrl: AppAssets.addIconT),
            ],
          ),

        ),
        body: Column(
          children: [
            SymmetricPadding(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SearchProductTextField(
                    controller: searchController,
                    onChange: (v) {
                      sellerActiveTab.changeQuery(v!);
                    },
                  ),
                  10.height,
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Consumer<SellerProductsTabProvider>(
                            builder: (context, provider, child) {
                              return SellerTabBarWidget(
                                  onPressed: () {
                                    context.read<SellerActiveTabProductProvider>().checkMoreData();
                                    provider.changeProductTab(SellerProductTabs.active);
                                  },
                                  width: 60.w,
                                  selected:
                                  provider.selectedProductTab == SellerProductTabs.active,
                                  title: AppLocalizations.of(context)!.active);
                            }),
                        Consumer<SellerProductsTabProvider>(
                            builder: (context, provider, child) {
                              return SellerTabBarWidget(
                                  onPressed: () {
                                    context.read<SellerInActiveTabProductProvider>().checkMoreData();
                                    provider.changeProductTab(SellerProductTabs.inActive);
                                  },
                                  width: 60.w,
                                  selected:
                                  provider.selectedProductTab == SellerProductTabs.inActive,
                                  title: AppLocalizations.of(context)!.inactive);
                            }),
                        Consumer<SellerProductsTabProvider>(
                            builder: (context, provider, child) {
                              return SellerTabBarWidget(
                                  onPressed: () {
                                    context.read<SellerActiveTabProductProvider>().checkMoreData();
                                    provider.changeProductTab(SellerProductTabs.draft);
                                  },
                                  selected:
                                  provider.selectedProductTab == SellerProductTabs.draft,
                                  title: AppLocalizations.of(context)!.draft);
                            }),
                        Consumer<SellerProductsTabProvider>(
                            builder: (context, provider, child) {
                              return SellerTabBarWidget(
                                  onPressed: () {
                                    context.read<SellerActiveTabProductProvider>().checkMoreData();
                                    provider.changeProductTab(SellerProductTabs.pendingQc);
                                  },
                                  width: 70.w,
                                  selected:
                                  provider.selectedProductTab == SellerProductTabs.pendingQc,
                                  title: AppLocalizations.of(context)!.pendingqc);
                            }),
                        Consumer<SellerProductsTabProvider>(
                            builder: (context, provider, child) {
                              return SellerTabBarWidget(
                                  onPressed: () {
                                    context.read<SellerActiveTabProductProvider>().checkMoreData();
                                    provider.changeProductTab(SellerProductTabs.violation);
                                  },
                                  width: 60.w,
                                  selected:
                                  provider.selectedProductTab == SellerProductTabs.violation,
                                  title: AppLocalizations.of(context)!.violation);
                            }),
                        Consumer<SellerProductsTabProvider>(
                            builder: (context, provider, child) {
                              return SellerTabBarWidget(
                                  onPressed: () {
                                    context.read<SellerActiveTabProductProvider>().checkMoreData();
                                    provider.changeProductTab(SellerProductTabs.outOfStock);
                                  },
                                  width: 60.w,
                                  selected:
                                  provider.selectedProductTab == SellerProductTabs.outOfStock,
                                  title: AppLocalizations.of(context)!.outofstock);
                            }),
                      ],
                    ),
                  ),
                  10.height,
                ],
              ),
            ),
            Expanded(
              child: Consumer<SellerProductsTabProvider>(
                  builder: (context, provider, child) {
                    return provider.showTab();
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
class RoundIconButton extends StatelessWidget {
  final String iconUrl;
  final VoidCallback? onPressed;
  const RoundIconButton({super.key, required this.iconUrl, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onPressed,
      child: Material(
        elevation: 2,
        shape: const CircleBorder(),
        child: Container(
          height: 44.h,
          width: 44.w,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primaryColor.withOpacity(0.15),
              border: Border.all(color: whiteColor, width: 5),
              image:  DecorationImage(
                  image: AssetImage(iconUrl),
                scale: 3,
              )
          ),
          child: Center(
            child: Image.asset(iconUrl,scale: 3,color: primaryColor,),
          ),
        ),
      ),
    );
  }
}

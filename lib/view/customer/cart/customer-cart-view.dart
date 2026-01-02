import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/providers/carts/cart-provider.dart';
import 'package:sugudeni/repositories/carts/cart-repository.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/customWidgets/cached-network-image.dart';
import 'package:sugudeni/utils/customWidgets/loading-dialog.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/shimmer-widgets.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/view/customer/cart/show-delivery-slots.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/constants/colors.dart';
import '../../currency/find-currency.dart';

class CustomerCartView extends StatefulWidget {
  const CustomerCartView({super.key});

  @override
  State<CustomerCartView> createState() => _CustomerCartViewState();
}

class _CustomerCartViewState extends State<CustomerCartView> {
  @override
  void initState() {
    // TODO: implement initState
    context.read<CartProvider>().getCartData(context).then((_) {
      // Auto-select single item if there's only one item in cart
      final provider = context.read<CartProvider>();
      if (provider.cartResponse != null &&
          provider.cartResponse!.cart.cartItem.length == 1 &&
          provider.selectedIndex.isEmpty) {
        final singleItem = provider.cartResponse!.cart.cartItem.first;
        provider.toggleItem(singleItem.id);
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        automaticallyImplyLeading: false,
        forceMaterialTransparency: true,
        toolbarHeight: 70.h,
        flexibleSpace: Container(
          color: whiteColor,
        ),
        title: Row(
          children: [
           MyText(text: AppLocalizations.of(context)!.mycart,size:14.sp ,fontWeight: FontWeight.w600,),
            10.width,
            const Spacer(),
            // Flexible(
            //   child: SizedBox(
            //     height: 35.h,
            //     child: TextFormField(
            //       style: TextStyle(
            //           fontWeight: FontWeight.w500,
            //           fontSize: 10.sp,
            //           color: const Color(0xff545454)
            //       ),
            //       decoration: InputDecoration(
            //         prefixIcon:  Icon(Icons.location_pin,color: const Color(0xff009EE7),size: 12.sp,),
            //         hintText: "Search address",
            //         hintStyle: TextStyle(
            //             fontWeight: FontWeight.w500,
            //             fontSize: 10.sp,
            //             color: const Color(0xff545454)
            //         ),
            //         filled: true,
            //         focusColor: lightPinkColor,
            //         border: border,
            //         enabledBorder:border,
            //         focusedBorder:border
            //       ),
            //     ),
            //   ),
            // ),
            4.width,
            GestureDetector(
                onTap: ()async{
                  if(context.read<CartProvider>().selectedIndex.isEmpty){
                    showSnackbar(context, "Please select items to delete");
                    return;
                  }
                  showDialog(context: context, builder: (context){
                    return  LoadingDialog(text: AppLocalizations.of(context)!.deleting,);
                  });
                  List<String> selectedItems = List.from(context.read<CartProvider>().selectedIndex);

                  for (var i in selectedItems) {
                    await CartRepository.removeProductFromCart(i, context).then((v) async {
                      // if (context.mounted) {
                      //   await context.read<CartProvider>().getCartData(context);
                      //   if (context.mounted) {
                      //     context.read<CartProvider>().selectedIndex.clear();
                      //     Navigator.pop(context);
                      //   }
                      // }
                    }).onError((err, e) async {
                      // if (context.mounted) {
                      //   await context.read<CartProvider>().getCartData(context);
                      //   if (context.mounted) {
                      //     context.read<CartProvider>().selectedIndex.clear();
                      //     Navigator.pop(context);
                      //   }
                      // }
                    });
                  }
                  if (context.mounted) {
                    await context.read<CartProvider>().getCartData(context);
                    if (context.mounted) {
                      context.read<CartProvider>().selectedIndex.clear();
                      Navigator.pop(context);
                    }
                  }
                 },

                child: Image.asset(AppAssets.deleteIcon,color: primaryColor,scale: 3,))
          ],
        ),
      ),
      body: Consumer<CartProvider>(builder: (context,provider,child){
        if (provider.isLoading) {
          return Column(
            children: List.generate(3, (index) => const ListItemShimmer(height: 120)),
          );
        }

        if (provider.errorMessage != null) {
          return Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppAssets.emptyCart),
               Text(AppLocalizations.of(context)!.emptycard),

             // Text(provider.errorMessage!),
            ],
          ));
        }

        // Handle case where cartResponse is null or cart data is not loaded yet
        if (provider.cartResponse == null) {
          return Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppAssets.emptyCart),
              Text("Loading cart..."),
            ],
          ));
        }

        // Check if cart has items
        if (provider.cartResponse!.cart.cartItem.isEmpty) {
          return  Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppAssets.emptyCart),
               Text(AppLocalizations.of(context)!.emptycard),
            ],
          ));
        }
        return Stack(
          children: [
            10.height,
            ListView.builder(
                itemCount:provider.cartResponse!.cart.cartItem.length ,
                itemBuilder: (context,index){
                  var cartData=provider.cartResponse!.cart.cartItem[index];
              return   Padding(
                padding: const EdgeInsets.only(bottom: 5.0,top: 5),
                child: CartItemWidget(
                  isBulk: cartData.productId.bulk,
                  img: cartData.productId.imgCover,
                  title: cartData.productId.title,quantity: cartData.quantity.toString(),
                priceAfterDiscount:cartData.priceAfterDiscount,
                  totalProductDiscount: cartData.totalProductDiscount,
                  price:cartData.price,
                  incrementPressed: (){
                  provider.incrementQuantity(cartData.id,context);
                  },
                  decrementPressed: (){
                  provider.decrementQuantity(cartData.id,context);
                  },
                  onChange: (v){
                    provider.toggleItem(cartData.id);
                  },
                  isSelected: provider.selectedIndex.contains(cartData.id),
                ),
              );
            }),

            120.height,

            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: 44.h,
                margin: EdgeInsets.only(bottom: 100.h),
                decoration: BoxDecoration(
                    color: whiteColor,
                    border: Border.all(
                        color: primaryColor
                    )
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Checkbox(value: false, onChanged: (v){},
                    //   shape:  ContinuousRectangleBorder(
                    //       side: BorderSide(
                    //           color: textPrimaryColor.withAlpha(getAlpha(0.7)),
                    //           width: 0.5
                    //       ),
                    //       borderRadius: BorderRadius.circular(8.r)
                    //   ),
                    //   side: const BorderSide(
                    //       width: 1
                    //   ),
                    //
                    // ),
                    // MyText(text: "All",size: 12.sp,fontWeight: FontWeight.w600),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            MyText(text: "${AppLocalizations.of(context)!.subtotal} (${provider.getSelectedItemsCount()} ${provider.getSelectedItemsCount() == 1 ? 'item' : 'items'}) : ",size: 12.sp,fontWeight: FontWeight.w600),
                            FindCurrency(usdAmount: provider.getSelectedItemsSubtotal(),
                                size: 12.sp,fontWeight: FontWeight.w600,color: primaryColor),
                            //MyText(text: "USD ${provider.cartResponse!.cart.totalPrice}",size: 12.sp,fontWeight: FontWeight.w600,color: primaryColor,),

                          ],
                        ),
                        Row(
                          children: [
                            MyText(text: "${AppLocalizations.of(context)!.shippingfee} : ",size: 9.sp,fontWeight: FontWeight.w600),
                            FindCurrency(usdAmount: 0,size: 9.sp,fontWeight: FontWeight.w600,color: primaryColor),
                        //    MyText(text: "USD 00.00",size: 9.sp,fontWeight: FontWeight.w600,color: primaryColor,),

                          ],
                        ),


                      ],
                    ),
                    10.width,
                    GestureDetector(
                      onTap: ()async{
                        // Check if items are selected for checkout
                        if (provider.selectedIndex.isEmpty) {
                          showSnackbar(context, "Please select items to proceed with checkout");
                          return;
                        }

                        // var model=CashOrderModel(shippingAddress: "shippingAddress");
                        // await CartRepository.createCashOrder(model, provider.cartResponse!.cart.id, context).then((v){
                        //   showSnackbar(context, "Checkout created successfully",color: greenColor);
                        //   provider.getCartData(context);
                        // });
                        showDeliverySlots(context,false);
                    //   Navigator.pushNamed(context, RoutesNames.customerCheckoutView);
                      },
                      child: Container(
                        width: 107.w,
                        height: 34.h,
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(5.r)
                        ),
                        child: Center(
                          child: MyText(text: AppLocalizations.of(context)!.checkout,color: whiteColor,size: 12.sp,fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    10.width,
                  ],
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// MyText(text: "\$ 76.25",size: 10.sp,
// fontWeight: FontWeight.w500,color: appRedColor,
// ),
// 170.width,
// MyText(text: "Qty: 1",size: 10.sp,
// fontWeight: FontWeight.w500,
// ),
// ],
// ),
class CompanyCartWidget extends StatelessWidget {
  const CompanyCartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: whiteColor,
      child: Column(
        spacing: 10.h,
        children: [
          Row(
            children: [
              Checkbox(value: false, onChanged: (v){},
                  shape:  ContinuousRectangleBorder(
                      side: BorderSide(
                          color: textPrimaryColor.withAlpha(getAlpha(0.7)),
                          width: 1
                      ),
                      borderRadius: BorderRadius.circular(8.r)
                  ),
          side: const BorderSide(
          width: 1
      ),
              ),
              MyText(text: "AMY Online Shopping Store",size: 12.sp,fontWeight: FontWeight.w600)
            ],
          ),
          // const CartItemWidget(),
          //
          // const CartItemWidget(),
          5.height,

        ],
      ),
    );
  }
}

class CartItemWidget extends StatelessWidget {
  final String?title;
  final String?img;
  final double?price;
  final double?priceAfterDiscount;
  final double?totalProductDiscount;
  final double?salesDiscount;
  final String?quantity;
  final VoidCallback? incrementPressed;
  final VoidCallback? decrementPressed;
  final ValueChanged<bool?> onChange;
  final bool? isSelected;
  final bool? isBulk;

  const CartItemWidget({super.key, this.title, this.price, this.priceAfterDiscount, this.quantity, this.incrementPressed, this.decrementPressed, required this.onChange, this.isSelected, this.img, this.isBulk=false, this.salesDiscount, this.totalProductDiscount});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Checkbox(value: isSelected, onChanged: (v){
            onChange(v);
          },
              shape:  ContinuousRectangleBorder(
                  side: BorderSide(
                      color: textPrimaryColor.withAlpha(getAlpha(0.7)),
                      width: 1
                  ),

                  borderRadius: BorderRadius.circular(8.r)
              ),
          side: const BorderSide(
          width: 1
      ),
          ),
         10.width,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyCachedNetworkImage(
                  height:65.h ,
                  width: 65.w,
                  radius: 6.r,
                  imageUrl:isBulk==true? (img ?? ""):"${ApiEndpoints.productUrl}/${img ?? ""}"),

              10.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  8.height,
                  SizedBox(
                    width: 130.w,
                    child: MyText(
                      overflow: TextOverflow.clip,
                      text:capitalizeFirstLetter(title??"Red Chili A Fiery Spice that Adds" ),size: 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  3.height,
                  // MyText(text: "AMY Online Shopping Store",size: 8.sp,
                  //   color: textPrimaryColor.withOpacity(0.7),
                  //   fontWeight: FontWeight.w600,
                  // ),
                  // 3.height,
                  totalProductDiscount==0? FindCurrency(usdAmount: price??1.0):FindCurrency(usdAmount: priceAfterDiscount??1.0),

                 // MyText(text: "\$ ${priceAfterDiscount==0? price:priceAfterDiscount?? 76.25}",size: 10.sp, fontWeight: FontWeight.w500,color: appRedColor,),

                  totalProductDiscount==0?const SizedBox():
                  FindCurrency(usdAmount: price??85.25,color: greyColor,textDecoration: TextDecoration.lineThrough),

                 // MyText(text: "\$ ${price??85.25}",size: 10.sp, fontWeight: FontWeight.w500,color: greyColor,textDecoration: TextDecoration.lineThrough),


                ],
              ),

            ],

          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: decrementPressed,
                child: Container(
                  height: 16.h,
                  width: 16.w,
                  decoration: BoxDecoration(
                      color: appRedColor,
                      borderRadius: BorderRadius.circular(4.r)
                  ),
                  child: Center(
                    child: Icon(Icons.remove,color: whiteColor,size: 12.sp,),
                  ),
                ),
              ),
              5.width,
              Consumer<CartProvider>(builder: (context,provider,child){
                return  Container(
                  height: 16.h,
                  width: 16.w,
                  decoration: BoxDecoration(
                      color: lightPinkColor.withAlpha(getAlpha(0.2)),
                      borderRadius: BorderRadius.circular(4.r)
                  ),
                  child: Center(
                    child:  MyText(text: quantity.toString(),size: 10.sp,fontWeight: FontWeight.w500,),

                  ),
                );
              }),
              5.width,
              GestureDetector(
                onTap: incrementPressed,
                child: Container(
                  height: 16.h,
                  width: 16.w,
                  decoration: BoxDecoration(
                      color: const Color(0xffFF8E8E),
                      borderRadius: BorderRadius.circular(4.r)
                  ),
                  child: Center(
                    child: Icon(Icons.add,color: whiteColor,size: 12.sp,),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

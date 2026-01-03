import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/providers/card_provider.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';

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
              Row(
                children: [
                  InkWell(
                      onTap:(){
                        Navigator.pop(context);
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Icon(Icons.arrow_back_ios))
                ],
              ),
              MyText(text:AppLocalizations.of(context)!.setting, size: 28.sp, fontWeight: FontWeight.w700),
              5.height,
              MyText(text: AppLocalizations.of(context)!.paymentmethod, size: 16.sp, fontWeight: FontWeight.w500),
              10.height,
              Consumer<CardProvider>(
                builder: (context, cardProvider, child) {
                  final displayCard = cardProvider.cards.isNotEmpty ? cardProvider.cards.last : null;

                  return Row(
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
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  MyText(text: displayCard?.getMaskedNumber() ?? "* * * *     * * * * "),
                                  MyText(text: displayCard != null && displayCard.cardNumber.length >= 4
                                      ? displayCard.cardNumber.substring(displayCard.cardNumber.length - 3)
                                      : "157 "),
                                ],
                              ),
                              15.height,
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(displayCard?.cardHolder.toUpperCase() ?? 'AMANDA',style: GoogleFonts.nunitoSans(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w600
                                  ),),
                                  Text(displayCard?.expiryDate ?? '12/02',style: GoogleFonts.nunitoSans(
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
                              child: AddCardBottomSheet(),
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
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AddCardBottomSheet extends StatefulWidget {
  const AddCardBottomSheet({super.key});

  @override
  State<AddCardBottomSheet> createState() => _AddCardBottomSheetState();
}

class _AddCardBottomSheetState extends State<AddCardBottomSheet> {
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  @override
  void dispose() {
    _cardHolderController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xffF8FAFF),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(9.r),
                topLeft: Radius.circular(9.r),
              )
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.close),
                  ),
                  10.width,
                  MyText(text: AppLocalizations.of(context)!.addcard, size: 22.sp, fontWeight: FontWeight.w700),
                ],
              ),
            ),
          ),
          30.height,
          SymmetricPadding(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                text(title: AppLocalizations.of(context)!.cardholder),
                5.height,
                TextFormField(
                  controller: _cardHolderController,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.required,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
                20.height,
                text(title: AppLocalizations.of(context)!.cardnumber),
                5.height,
                TextFormField(
                  controller: _cardNumberController,
                  keyboardType: TextInputType.number,
                  maxLength: 16,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.required,
                    counterText: "",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
                20.height,
                Row(
                  spacing: 5.w,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          text(title: AppLocalizations.of(context)!.valid),
                          5.height,
                          TextFormField(
                            controller: _expiryController,
                            keyboardType: TextInputType.number,
                            maxLength: 5,
                            decoration: InputDecoration(
                              hintText: "MM/YY",
                              counterText: "",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          text(title: AppLocalizations.of(context)!.cvv),
                          5.height,
                          TextFormField(
                            controller: _cvvController,
                            keyboardType: TextInputType.number,
                            maxLength: 3,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)!.required,
                              counterText: "",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          20.height,
          SymmetricPadding(
            child: ElevatedButton(
              onPressed: _addCard,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                minimumSize: Size(double.infinity, 50.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9.r),
                ),
              ),
              child: MyText(
                text: "Add Card",
                color: whiteColor,
                size: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          20.height,
        ],
      ),
    );
  }

  void _addCard() {
    if (_cardHolderController.text.isEmpty ||
        _cardNumberController.text.isEmpty ||
        _expiryController.text.isEmpty ||
        _cvvController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    if (_cardNumberController.text.length != 16) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Card number must be 16 digits")),
      );
      return;
    }

    if (_cvvController.text.length != 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("CVV must be 3 digits")),
      );
      return;
    }

    final card = CardModel(
      cardHolder: _cardHolderController.text.trim(),
      cardNumber: _cardNumberController.text.trim(),
      expiryDate: _expiryController.text.trim(),
      cvv: _cvvController.text.trim(),
      id: DateTime.now().millisecondsSinceEpoch.toString(),
    );

    context.read<CardProvider>().addCard(card);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Card added successfully")),
    );

    Navigator.pop(context);
  }

  Widget text({required String title}) {
    return MyText(text: title, size: 13.sp, fontWeight: FontWeight.w600);
  }
}

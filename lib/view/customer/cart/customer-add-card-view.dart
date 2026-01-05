import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/providers/card_provider.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/round-button.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/customWidgets/text-field.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/global-functions.dart';

class CustomerAddCardView extends StatefulWidget {
  const CustomerAddCardView({super.key});

  @override
  State<CustomerAddCardView> createState() => _CustomerAddCardViewState();
}

class _CustomerAddCardViewState extends State<CustomerAddCardView> {
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // height: 77.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xffF8FAFF),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(9.r),
                topLeft: Radius.circular(9.r),
              )
            ),
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: 12.w,vertical: 20.h),
              child: MyText(text: AppLocalizations.of(context)!.addcard,size:22.sp ,fontWeight: FontWeight.w700),
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
                CustomTextFiled(
                  controller: _cardHolderController,
                  borderRadius: 15.r,
                  isBorder: true,
                  isShowPrefixIcon: false,
                  isFilled: true,
                  hintText: 'Enter card holder name',
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                    LengthLimitingTextInputFormatter(50),
                  ],
                ),
                20.height,
                text(title: AppLocalizations.of(context)!.cardnumber),
                5.height,
                CustomTextFiled(
                  controller: _cardNumberController,
                  keyboardType: TextInputType.number,
                  borderRadius: 15.r,
                  isBorder: true,
                  isShowPrefixIcon: false,
                  isFilled: true,
                  hintText: 'Enter card number',
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(19),
                    _CardNumberFormatter(),
                  ],
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
                          CustomTextFiled(
                            controller: _expiryDateController,
                            keyboardType: TextInputType.number,
                            borderRadius: 15.r,
                            isBorder: true,
                            isShowPrefixIcon: false,
                            isFilled: true,
                            hintText: 'MM/YY',
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(5),
                              _ExpiryDateFormatter(),
                            ],
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
                          CustomTextFiled(
                            controller: _cvvController,
                            keyboardType: TextInputType.number,
                            borderRadius: 15.r,
                            isBorder: true,
                            isShowPrefixIcon: false,
                            isFilled: true,
                            hintText: 'CVV',
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                            ],
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
        //  const Spacer(),
          SymmetricPadding(
            child: RoundButton(
                borderRadius: BorderRadius.circular(9.r),
                title: AppLocalizations.of(context)!.addcard,
                isLoad: true,
                onTap: _validateAndSaveCard,
            ),
          ),
          20.height,
        ],
      ),
    );
  }
  Widget text({required String title}){
    return              MyText(text: title,size: 13.sp,fontWeight: FontWeight.w600,);

  }

  void _validateAndSaveCard() {
    final cardHolder = _cardHolderController.text.trim();
    final cardNumber = _cardNumberController.text.replaceAll(' ', '');
    final expiryDate = _expiryDateController.text;
    final cvv = _cvvController.text;

    if (cardHolder.isEmpty) {
      showSnackbar(context, 'Please enter card holder name', color: redColor);
      return;
    }

    if (cardNumber.length < 13 || cardNumber.length > 19) {
      showSnackbar(context, 'Please enter a valid card number', color: redColor);
      return;
    }

    if (expiryDate.length != 5 || !expiryDate.contains('/')) {
      showSnackbar(context, 'Please enter expiry date in MM/YY format', color: redColor);
      return;
    }

    if (cvv.length < 3 || cvv.length > 4) {
      showSnackbar(context, 'Please enter a valid CVV', color: redColor);
      return;
    }

    // Validate expiry date format and future date
    final parts = expiryDate.split('/');
    if (parts.length != 2) {
      showSnackbar(context, 'Invalid expiry date format', color: redColor);
      return;
    }

    final month = int.tryParse(parts[0]);
    final year = int.tryParse('20${parts[1]}'); // Convert YY to YYYY

    if (month == null || year == null || month < 1 || month > 12) {
      showSnackbar(context, 'Invalid expiry date', color: redColor);
      return;
    }

    final expiryDateTime = DateTime(year, month);
    if (expiryDateTime.isBefore(DateTime.now())) {
      showSnackbar(context, 'Card has expired', color: redColor);
      return;
    }

    // Create card model and save
    final card = CardModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      cardHolder: cardHolder,
      cardNumber: cardNumber,
      expiryDate: expiryDate,
      cvv: cvv,
    );

    context.read<CardProvider>().addCard(card);
    showSnackbar(context, 'Card added successfully', color: greenColor);

    // Clear form
    _cardHolderController.clear();
    _cardNumberController.clear();
    _expiryDateController.clear();
    _cvvController.clear();

    Navigator.pop(context);
  }
}

// Card number formatter (adds spaces every 4 digits)
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i + 1) % 4 == 0 && i + 1 != text.length) {
        buffer.write(' ');
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

// Expiry date formatter (MM/YY format)
class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll('/', '');

    if (text.length > 4) {
      return oldValue;
    }

    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if (i == 1 && i + 1 != text.length) {
        buffer.write('/');
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/providers/currency_provider.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';

// Functions moved to CurrencyProvider

class FindCurrency extends StatelessWidget {
  final double usdAmount;
  final double? size;
  final FontWeight? fontWeight;
  final Color? color;
  final TextDecoration? textDecoration;
  const FindCurrency({super.key, required this.usdAmount, this.size, this.fontWeight, this.color, this.textDecoration});

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrencyProvider>(
      builder: (context, currencyProvider, child) {
        if (currencyProvider.isLoading) {
          return const SizedBox();
        }

        double localAmount = usdAmount * currencyProvider.conversionRate;
        String currencyCode = currencyProvider.currencyCode;

        NumberFormat format = NumberFormat.simpleCurrency(name: currencyCode);
        String formattedAmount = format.format(localAmount);

        return MyText(
          text: formattedAmount,
          size: size ?? 10.sp,
          fontWeight: fontWeight ?? FontWeight.w600,
          color: color ?? appPinkColor,
          textDecoration: textDecoration,
        );
      },
    );
  }
}

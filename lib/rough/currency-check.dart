import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/country_pickers.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/view/currency/find-currency.dart';


class CurrencyChecker extends StatefulWidget {
  const CurrencyChecker({super.key});

  @override
  State<CurrencyChecker> createState() => _CurrencyCheckerState();
}

class _CurrencyCheckerState extends State<CurrencyChecker> {
  String countryTitle = 'Country';
  String currencyTitle = 'Currency';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Currency & Country Picker'),
        ),
        body:  Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const FindCurrency(usdAmount: 2),
              ElevatedButton(
                  onPressed: (){
                    showDialog(
                      context: context,
                      builder: (context) => Theme(
                          data: Theme.of(context).copyWith(primaryColor: whiteColor),
                          child: CountryPickerDialog(

                            titlePadding: const EdgeInsets.all(8.0),
                              searchCursorColor: whiteColor,
                              searchInputDecoration: const InputDecoration(hintText: 'Search...'),
                              isSearchable: true,

                           onValuePicked: (c) async {
                             await  updateConversionRate(c.currencyCode!);
                             setState(() {

                             });
                                customPrint(c.currencyCode!);
                           },
                            itemBuilder: _buildDialogItem,
                          )
                    )
                    );
                  },
                  child: const MyText(text: "text"))
            ],
          ),
        )


    );

  }
  Widget _buildDialogItem(Country country) => Row(
    children: <Widget>[
      CountryPickerUtils.getDefaultFlagImage(country),
      // SizedBox(width: 8.0),
      // Text("+${country.phoneCode}"),
      const SizedBox(width: 8.0),
      Flexible(child: Text(country.name ?? ''))
    ],
  );

}
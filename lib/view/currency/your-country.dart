import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/country_pickers.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sugudeni/view/currency/find-currency.dart';

import '../../utils/constants/colors.dart';
import '../../utils/customWidgets/my-text.dart';
import '../../utils/global-functions.dart';
class YourCountry extends StatelessWidget {
  const YourCountry({super.key});

  @override
  Widget build(BuildContext context) {
    return   Padding(
      padding:  EdgeInsets.symmetric(vertical: 15.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyText(text: "Country", size: 16.sp, fontWeight: FontWeight.w600),
         const FindFlag()

            ],
          ),
          Divider(
            color: borderColor.withOpacity(0.2),
          )
        ],
      ),
    );
  }
}
class FindFlag extends StatefulWidget {
  const FindFlag({super.key});

  @override
  State<FindFlag> createState() => _FindFlagState();
}

class _FindFlagState extends State<FindFlag> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getCountryCOde(),
        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return const SizedBox();
          }
          var data=snapshot.data;
          String countryCode = currencyToCountry[data] ?? 'US';

          return GestureDetector(
              onTap: (){
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
              child: CountryFlag.fromCountryCode(countryCode,height: 20.h,width: 30.w));
        });
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
Map<String, String> currencyToCountry = {
  'AED': 'AE',
  'AFN': 'AF',
  'ALL': 'AL',
  'AMD': 'AM',
  'ANG': 'CW',
  'AOA': 'AO',
  'ARS': 'AR',
  'AUD': 'AU',
  'AWG': 'AW',
  'AZN': 'AZ',
  'BAM': 'BA',
  'BBD': 'BB',
  'BDT': 'BD',
  'BGN': 'BG',
  'BHD': 'BH',
  'BIF': 'BI',
  'BMD': 'BM',
  'BND': 'BN',
  'BOB': 'BO',
  'BRL': 'BR',
  'BSD': 'BS',
  'BTN': 'BT',
  'BWP': 'BW',
  'BYN': 'BY',
  'BZD': 'BZ',
  'CAD': 'CA',
  'CDF': 'CD',
  'CHF': 'CH',
  'CLP': 'CL',
  'CNY': 'CN',
  'COP': 'CO',
  'CRC': 'CR',
  'CUP': 'CU',
  'CVE': 'CV',
  'CZK': 'CZ',
  'DJF': 'DJ',
  'DKK': 'DK',
  'DOP': 'DO',
  'DZD': 'DZ',
  'EGP': 'EG',
  'ERN': 'ER',
  'ETB': 'ET',
  'EUR': 'DE', // Representing EU with Germany
  'FJD': 'FJ',
  'FKP': 'FK',
  'FOK': 'FO',
  'GBP': 'GB',
  'GEL': 'GE',
  'GGP': 'GG',
  'GHS': 'GH',
  'GIP': 'GI',
  'GMD': 'GM',
  'GNF': 'GN',
  'GTQ': 'GT',
  'GYD': 'GY',
  'HKD': 'HK',
  'HNL': 'HN',
  'HRK': 'HR',
  'HTG': 'HT',
  'HUF': 'HU',
  'IDR': 'ID',
  'ILS': 'IL',
  'IMP': 'IM',
  'INR': 'IN',
  'IQD': 'IQ',
  'IRR': 'IR',
  'ISK': 'IS',
  'JEP': 'JE',
  'JMD': 'JM',
  'JOD': 'JO',
  'JPY': 'JP',
  'KES': 'KE',
  'KGS': 'KG',
  'KHR': 'KH',
  'KID': 'KI',
  'KMF': 'KM',
  'KRW': 'KR',
  'KWD': 'KW',
  'KYD': 'KY',
  'KZT': 'KZ',
  'LAK': 'LA',
  'LBP': 'LB',
  'LKR': 'LK',
  'LRD': 'LR',
  'LSL': 'LS',
  'LYD': 'LY',
  'MAD': 'MA',
  'MDL': 'MD',
  'MGA': 'MG',
  'MKD': 'MK',
  'MMK': 'MM',
  'MNT': 'MN',
  'MOP': 'MO',
  'MRU': 'MR',
  'MUR': 'MU',
  'MVR': 'MV',
  'MWK': 'MW',
  'MXN': 'MX',
  'MYR': 'MY',
  'MZN': 'MZ',
  'NAD': 'NA',
  'NGN': 'NG',
  'NIO': 'NI',
  'NOK': 'NO',
  'NPR': 'NP',
  'NZD': 'NZ',
  'OMR': 'OM',
  'PAB': 'PA',
  'PEN': 'PE',
  'PGK': 'PG',
  'PHP': 'PH',
  'PKR': 'PK',
  'PLN': 'PL',
  'PYG': 'PY',
  'QAR': 'QA',
  'RON': 'RO',
  'RSD': 'RS',
  'RUB': 'RU',
  'RWF': 'RW',
  'SAR': 'SA',
  'SBD': 'SB',
  'SCR': 'SC',
  'SDG': 'SD',
  'SEK': 'SE',
  'SGD': 'SG',
  'SHP': 'SH',
  'SLE': 'SL',
  'SLL': 'SL',
  'SOS': 'SO',
  'SRD': 'SR',
  'SSP': 'SS',
  'STN': 'ST',
  'SYP': 'SY',
  'SZL': 'SZ',
  'THB': 'TH',
  'TJS': 'TJ',
  'TMT': 'TM',
  'TND': 'TN',
  'TOP': 'TO',
  'TRY': 'TR',
  'TTD': 'TT',
  'TVD': 'TV',
  'TWD': 'TW',
  'TZS': 'TZ',
  'UAH': 'UA',
  'UGX': 'UG',
  'USD': 'US',
  'UYU': 'UY',
  'UZS': 'UZ',
  'VES': 'VE',
  'VND': 'VN',
  'VUV': 'VU',
  'WST': 'WS',
  'XAF': 'CM',
  'XCD': 'AG',
  'XOF': 'SN',
  'XPF': 'PF',
  'YER': 'YE',
  'ZAR': 'ZA',
  'ZMW': 'ZM',
  'ZWL': 'ZW',
};

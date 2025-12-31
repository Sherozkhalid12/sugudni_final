import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/language-provider.dart'; // update path accordingly

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<ChangeLanguageProvider>(context);
    String currentLang = languageProvider.appLocal?.languageCode ?? 'en';

    return GestureDetector(
      onTap: () => _showLanguageDialog(context, languageProvider),
      child: FutureBuilder(
          future: getUserLanguage(),
          builder: (context,language){

            String currentLang = language.data?? 'en';

            return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.language,color: primaryColor,size: 15.sp,),
            const SizedBox(width: 6),
            Text(currentLang == 'en' ? 'English' : 'Français',style: TextStyle(fontSize: 14.sp),),
          ],
        );
      }),
    );
  }

  void _showLanguageDialog(BuildContext context, ChangeLanguageProvider provider) async{
    SharedPreferences sp=await SharedPreferences.getInstance();

    String currentLang = sp.getString('language_code') ??'en';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: whiteColor,
          title:  MyText(text: AppLocalizations.of(context)!.selectlanguge,size: 14.sp,fontWeight: FontWeight.w600,),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption(
                context,
                flag: CountryFlag.fromLanguageCode('en',height: 20.h,width: 30.w,),
                title: 'English',
                locale: const Locale('en'),
                selected: currentLang == 'en',
                provider: provider,
              ),
              _buildLanguageOption(
                context,
                flag: CountryFlag.fromLanguageCode('fr',height: 20.h,width: 30.w),
                title: 'Français',
                locale: const Locale('fr'),
                selected: currentLang == 'fr',
                provider: provider,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(
      BuildContext context, {
        required Widget flag,
        required String title,
        required Locale locale,
        required bool selected,
        required ChangeLanguageProvider provider,
      }) {
    return ListTile(
      leading: flag,
      title: MyText(text:title,size: 12.sp,),
      trailing: selected ? const Icon(Icons.check, color: Colors.green) : null,
      onTap: () {
        provider.changeLanguage(locale);
        Navigator.pop(context);
      },
    );
  }
}
class LanguageSelectorForSeller extends StatelessWidget {
  const LanguageSelectorForSeller({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<ChangeLanguageProvider>(context);
    String currentLang = languageProvider.appLocal?.languageCode ?? 'en';

    return GestureDetector(
      onTap: () => _showLanguageDialog(context, languageProvider),
      child: FutureBuilder(
          future: getUserLanguage(),
          builder: (context,language){

            String currentLang = language.data?? 'en';

            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(8.r)
              ),
              margin: EdgeInsets.only(bottom: 15.h),
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 15.w,vertical: 7.h),
                child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                // Icon(Icons.language,color: primaryColor,size: 15.sp,),
                // const SizedBox(width: 6),
                            MyText(text: currentLang == 'en' ? 'English' : 'Français',size: 12.sp,fontWeight: FontWeight.w600,),
                            currentLang == 'en' ?CountryFlag.fromLanguageCode('en',height: 15.h,width: 25.w,):CountryFlag.fromLanguageCode('fr',height: 15.h,width: 25.w),
                          ],
                        ),
              ),
            );
      }),
    );
  }

  void _showLanguageDialog(BuildContext context, ChangeLanguageProvider provider) async{
    SharedPreferences sp=await SharedPreferences.getInstance();

    String currentLang = sp.getString('language_code') ??'en';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: whiteColor,
          title:  MyText(text: AppLocalizations.of(context)!.selectlanguge,size: 14.sp,fontWeight: FontWeight.w600,),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption(
                context,
                flag: CountryFlag.fromLanguageCode('en',height: 20.h,width: 30.w,),
                title: 'English',
                locale: const Locale('en'),
                selected: currentLang == 'en',
                provider: provider,
              ),
              _buildLanguageOption(
                context,
                flag: CountryFlag.fromLanguageCode('fr',height: 20.h,width: 30.w),
                title: 'Français',
                locale: const Locale('fr'),
                selected: currentLang == 'fr',
                provider: provider,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(
      BuildContext context, {
        required Widget flag,
        required String title,
        required Locale locale,
        required bool selected,
        required ChangeLanguageProvider provider,
      }) {
    return ListTile(
      leading: flag,
      title: MyText(text:title,size: 12.sp,),
      trailing: selected ? const Icon(Icons.check, color: Colors.green) : null,
      onTap: () {
        provider.changeLanguage(locale);
        Navigator.pop(context);
      },
    );
  }
}
class LanguageSelectorForDriver extends StatelessWidget {
  const LanguageSelectorForDriver({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<ChangeLanguageProvider>(context);
    String currentLang = languageProvider.appLocal?.languageCode ?? 'en';

    return GestureDetector(
      onTap: () => _showLanguageDialog(context, languageProvider),
      child: FutureBuilder(
          future: getUserLanguage(),
          builder: (context,language){

            String currentLang = language.data?? 'en';

            return Container(
              height: 34.h,
              width: double.infinity,
              color: whiteColor,

              margin: EdgeInsets.only(bottom: 20.h),

              child: Padding(
                padding:  EdgeInsets.only(left:15.w),
                child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            currentLang == 'en' ?CountryFlag.fromLanguageCode('en',height: 15.h,width: 25.w,):CountryFlag.fromLanguageCode('fr',height: 15.h,width: 25.w),
                            20.width,
                            MyText(text: currentLang == 'en' ? 'English' : 'Français',size: 12.sp,fontWeight: FontWeight.w600,),
                          ],
                        ),
              ),
            );
      }),
    );
  }

  void _showLanguageDialog(BuildContext context, ChangeLanguageProvider provider) async{
    SharedPreferences sp=await SharedPreferences.getInstance();

    String currentLang = sp.getString('language_code') ??'en';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: whiteColor,
          title:  MyText(text: AppLocalizations.of(context)!.selectlanguge,size: 14.sp,fontWeight: FontWeight.w600,),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption(
                context,
                flag: CountryFlag.fromLanguageCode('en',height: 20.h,width: 30.w,),
                title: 'English',
                locale: const Locale('en'),
                selected: currentLang == 'en',
                provider: provider,
              ),
              _buildLanguageOption(
                context,
                flag: CountryFlag.fromLanguageCode('fr',height: 20.h,width: 30.w),
                title: 'Français',
                locale: const Locale('fr'),
                selected: currentLang == 'fr',
                provider: provider,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(
      BuildContext context, {
        required Widget flag,
        required String title,
        required Locale locale,
        required bool selected,
        required ChangeLanguageProvider provider,
      }) {
    return ListTile(
      leading: flag,
      title: MyText(text:title,size: 12.sp,),
      trailing: selected ? const Icon(Icons.check, color: Colors.green) : null,
      onTap: () {
        provider.changeLanguage(locale);
        Navigator.pop(context);
      },
    );
  }
}

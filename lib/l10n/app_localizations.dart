import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// No description provided for @hi.
  ///
  /// In en, this message translates to:
  /// **'Hi'**
  String get hi;

  /// No description provided for @searchinsugudeni.
  ///
  /// In en, this message translates to:
  /// **'Search in SUGUDENI'**
  String get searchinsugudeni;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @tokenisempty.
  ///
  /// In en, this message translates to:
  /// **'Token is empty'**
  String get tokenisempty;

  /// No description provided for @orderagain.
  ///
  /// In en, this message translates to:
  /// **'Order again'**
  String get orderagain;

  /// No description provided for @selectdeliveryslots.
  ///
  /// In en, this message translates to:
  /// **'Select Delivery Slot'**
  String get selectdeliveryslots;

  /// No description provided for @shopnow.
  ///
  /// In en, this message translates to:
  /// **'Shop Now'**
  String get shopnow;

  /// No description provided for @sold.
  ///
  /// In en, this message translates to:
  /// **'sold'**
  String get sold;

  /// No description provided for @searchproductincategory.
  ///
  /// In en, this message translates to:
  /// **'Search Product in category'**
  String get searchproductincategory;

  /// No description provided for @empty.
  ///
  /// In en, this message translates to:
  /// **'Empty'**
  String get empty;

  /// No description provided for @filterbyprice.
  ///
  /// In en, this message translates to:
  /// **'Filter by Price'**
  String get filterbyprice;

  /// No description provided for @selectpricerange.
  ///
  /// In en, this message translates to:
  /// **'Select Price Range'**
  String get selectpricerange;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @seachproduct.
  ///
  /// In en, this message translates to:
  /// **'Search Product'**
  String get seachproduct;

  /// No description provided for @pleaselogintouseacount.
  ///
  /// In en, this message translates to:
  /// **'Please login to use account'**
  String get pleaselogintouseacount;

  /// No description provided for @producthasbeenaddedtowishlish.
  ///
  /// In en, this message translates to:
  /// **'Product has been added to wishlist'**
  String get producthasbeenaddedtowishlish;

  /// No description provided for @ratingsandreviews.
  ///
  /// In en, this message translates to:
  /// **'Ratings & Reviews'**
  String get ratingsandreviews;

  /// No description provided for @discription.
  ///
  /// In en, this message translates to:
  /// **'Discription'**
  String get discription;

  /// No description provided for @justforyou.
  ///
  /// In en, this message translates to:
  /// **'Just for You'**
  String get justforyou;

  /// No description provided for @visitstore.
  ///
  /// In en, this message translates to:
  /// **'Visit Store'**
  String get visitstore;

  /// No description provided for @pleasewait.
  ///
  /// In en, this message translates to:
  /// **'Please wait........'**
  String get pleasewait;

  /// No description provided for @addtocart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get addtocart;

  /// No description provided for @addingtocart.
  ///
  /// In en, this message translates to:
  /// **'Adding to cart'**
  String get addingtocart;

  /// No description provided for @producthasaddedtocartsuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Product has added to Cart Successfully'**
  String get producthasaddedtocartsuccessfully;

  /// No description provided for @orderdetail.
  ///
  /// In en, this message translates to:
  /// **'Order Detail'**
  String get orderdetail;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @selectaddress.
  ///
  /// In en, this message translates to:
  /// **'Select address'**
  String get selectaddress;

  /// No description provided for @ordernumber.
  ///
  /// In en, this message translates to:
  /// **'Order Number'**
  String get ordernumber;

  /// No description provided for @totalpurchase.
  ///
  /// In en, this message translates to:
  /// **'Total Purchase'**
  String get totalpurchase;

  /// No description provided for @pleaseselectyourshippingaddress.
  ///
  /// In en, this message translates to:
  /// **'Please select your shipping address'**
  String get pleaseselectyourshippingaddress;

  /// No description provided for @orderplacedsuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Order placed successfully'**
  String get orderplacedsuccessfully;

  /// No description provided for @addshippingaddress.
  ///
  /// In en, this message translates to:
  /// **'Add Shipping Address'**
  String get addshippingaddress;

  /// No description provided for @receipientname.
  ///
  /// In en, this message translates to:
  /// **'Recipients’s Name'**
  String get receipientname;

  /// No description provided for @inputtherealname.
  ///
  /// In en, this message translates to:
  /// **'Input the real name'**
  String get inputtherealname;

  /// No description provided for @phonenumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phonenumber;

  /// No description provided for @pleaseinputphonenumber.
  ///
  /// In en, this message translates to:
  /// **'Please Input Phone Number'**
  String get pleaseinputphonenumber;

  /// No description provided for @regioncitydistrict.
  ///
  /// In en, this message translates to:
  /// **'Region/City/District'**
  String get regioncitydistrict;

  /// No description provided for @pleaseinputregioncitydistrict.
  ///
  /// In en, this message translates to:
  /// **'Please Input Region/City/District'**
  String get pleaseinputregioncitydistrict;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @housenobuildingstreetarea.
  ///
  /// In en, this message translates to:
  /// **'House no./building/street/area'**
  String get housenobuildingstreetarea;

  /// No description provided for @landmark.
  ///
  /// In en, this message translates to:
  /// **'Landmark(Optional)'**
  String get landmark;

  /// No description provided for @addadditionalinfo.
  ///
  /// In en, this message translates to:
  /// **'Add Additional Info'**
  String get addadditionalinfo;

  /// No description provided for @selectlocationonmap.
  ///
  /// In en, this message translates to:
  /// **'Select location on Map'**
  String get selectlocationonmap;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Check Out'**
  String get checkout;

  /// No description provided for @merchandisesubtotal.
  ///
  /// In en, this message translates to:
  /// **'Merchandise Subtotal'**
  String get merchandisesubtotal;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'items'**
  String get items;

  /// No description provided for @thanksforshoppingwith.
  ///
  /// In en, this message translates to:
  /// **'Thanks for Shopping with, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore.'**
  String get thanksforshoppingwith;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @vatincluded.
  ///
  /// In en, this message translates to:
  /// **'VAT included where applicable'**
  String get vatincluded;

  /// No description provided for @pleaseselectyourdeliveryaddress.
  ///
  /// In en, this message translates to:
  /// **'Please select your delivery address'**
  String get pleaseselectyourdeliveryaddress;

  /// No description provided for @placeorder.
  ///
  /// In en, this message translates to:
  /// **'Place Order'**
  String get placeorder;

  /// No description provided for @standarddelivery.
  ///
  /// In en, this message translates to:
  /// **'Standard Delivery'**
  String get standarddelivery;

  /// No description provided for @cashondelivery.
  ///
  /// In en, this message translates to:
  /// **'Cash on Delivery'**
  String get cashondelivery;

  /// No description provided for @paywithcard.
  ///
  /// In en, this message translates to:
  /// **'Pay with Card'**
  String get paywithcard;

  /// No description provided for @youmaypayincash.
  ///
  /// In en, this message translates to:
  /// **'You may pay in cash to our courier upon receiving your parcel at the door step Before agreeing to receive the parcel, check if your delivery status has been updated to out for delivery'**
  String get youmaypayincash;

  /// No description provided for @beforereceivingconfirthattheair.
  ///
  /// In en, this message translates to:
  /// **'Before receiving, confirm that the air way bill shows that the parcel is from'**
  String get beforereceivingconfirthattheair;

  /// No description provided for @beforeyoumakepayment.
  ///
  /// In en, this message translates to:
  /// **'Before you make payment to the courier, confirm your order Number, sender information and tracking number on the parcel'**
  String get beforeyoumakepayment;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @cashpaymentfee.
  ///
  /// In en, this message translates to:
  /// **'Cash Payment Fee'**
  String get cashpaymentfee;

  /// No description provided for @totalamount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalamount;

  /// No description provided for @confirmpayment.
  ///
  /// In en, this message translates to:
  /// **'Confirm Payment'**
  String get confirmpayment;

  /// No description provided for @checkoutcreatedsuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Order is placed successfully'**
  String get checkoutcreatedsuccessfully;

  /// No description provided for @emptycard.
  ///
  /// In en, this message translates to:
  /// **'Empty cart'**
  String get emptycard;

  /// No description provided for @mycart.
  ///
  /// In en, this message translates to:
  /// **'My Cart'**
  String get mycart;

  /// No description provided for @pleaseselectproducttodelete.
  ///
  /// In en, this message translates to:
  /// **'Please select product to delete'**
  String get pleaseselectproducttodelete;

  /// No description provided for @deleting.
  ///
  /// In en, this message translates to:
  /// **'Deleting'**
  String get deleting;

  /// No description provided for @shippingfee.
  ///
  /// In en, this message translates to:
  /// **'Shipping fee'**
  String get shippingfee;

  /// No description provided for @myaddress.
  ///
  /// In en, this message translates to:
  /// **'My Address'**
  String get myaddress;

  /// No description provided for @addaddress.
  ///
  /// In en, this message translates to:
  /// **'Add Address'**
  String get addaddress;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @addcard.
  ///
  /// In en, this message translates to:
  /// **'Add Card'**
  String get addcard;

  /// No description provided for @cardholder.
  ///
  /// In en, this message translates to:
  /// **'Card Holder'**
  String get cardholder;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @cardnumber.
  ///
  /// In en, this message translates to:
  /// **'Card Number'**
  String get cardnumber;

  /// No description provided for @valid.
  ///
  /// In en, this message translates to:
  /// **'Valid'**
  String get valid;

  /// No description provided for @cvv.
  ///
  /// In en, this message translates to:
  /// **'CVV'**
  String get cvv;

  /// No description provided for @paynow.
  ///
  /// In en, this message translates to:
  /// **'Pay Now'**
  String get paynow;

  /// No description provided for @payatyouraddress.
  ///
  /// In en, this message translates to:
  /// **'Pay at Your  address'**
  String get payatyouraddress;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @pleasehavethisamount.
  ///
  /// In en, this message translates to:
  /// **'Please have this amount ready on delivery day'**
  String get pleasehavethisamount;

  /// No description provided for @selectpaymentmethod.
  ///
  /// In en, this message translates to:
  /// **'Select Payment Method'**
  String get selectpaymentmethod;

  /// No description provided for @signuplogintoyouraccount.
  ///
  /// In en, this message translates to:
  /// **'Sign up/Login to your account'**
  String get signuplogintoyouraccount;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @myorders.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get myorders;

  /// No description provided for @topay.
  ///
  /// In en, this message translates to:
  /// **'To Pay'**
  String get topay;

  /// No description provided for @toreceive.
  ///
  /// In en, this message translates to:
  /// **'To Receive'**
  String get toreceive;

  /// No description provided for @toreview.
  ///
  /// In en, this message translates to:
  /// **'To Review'**
  String get toreview;

  /// No description provided for @order.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get order;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @readyforshipping.
  ///
  /// In en, this message translates to:
  /// **'Ready For Shipping'**
  String get readyforshipping;

  /// No description provided for @shipping.
  ///
  /// In en, this message translates to:
  /// **'Shipping'**
  String get shipping;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// No description provided for @delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered;

  /// No description provided for @ratedelivery.
  ///
  /// In en, this message translates to:
  /// **'Rate Delivery'**
  String get ratedelivery;

  /// No description provided for @track.
  ///
  /// In en, this message translates to:
  /// **'Track'**
  String get track;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get review;

  /// No description provided for @productid.
  ///
  /// In en, this message translates to:
  /// **'Product Id'**
  String get productid;

  /// No description provided for @yourcomment.
  ///
  /// In en, this message translates to:
  /// **'Your comment'**
  String get yourcomment;

  /// No description provided for @pleaseaddyourcomment.
  ///
  /// In en, this message translates to:
  /// **'Please add your comment'**
  String get pleaseaddyourcomment;

  /// No description provided for @pleaserate.
  ///
  /// In en, this message translates to:
  /// **'Please rate'**
  String get pleaserate;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @thatyouforyourreview.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your\nreview'**
  String get thatyouforyourreview;

  /// No description provided for @ratingaddedsuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Rating added successfully'**
  String get ratingaddedsuccessfully;

  /// No description provided for @alreadyreviewed.
  ///
  /// In en, this message translates to:
  /// **'Already reviewed'**
  String get alreadyreviewed;

  /// No description provided for @youhavealreadyreviewedthisproduct.
  ///
  /// In en, this message translates to:
  /// **'You have already reviewed this product'**
  String get youhavealreadyreviewedthisproduct;

  /// No description provided for @unpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get unpaid;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @shopbycategory.
  ///
  /// In en, this message translates to:
  /// **'Shop by Category'**
  String get shopbycategory;

  /// No description provided for @selectonofyourorder.
  ///
  /// In en, this message translates to:
  /// **'Select one of your orders'**
  String get selectonofyourorder;

  /// No description provided for @setting.
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get setting;

  /// No description provided for @yourprofile.
  ///
  /// In en, this message translates to:
  /// **'Your Profile'**
  String get yourprofile;

  /// No description provided for @fullname.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullname;

  /// No description provided for @enteryouremail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enteryouremail;

  /// No description provided for @enteryourpassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enteryourpassword;

  /// No description provided for @savechanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get savechanges;

  /// No description provided for @allfieldsarerequired.
  ///
  /// In en, this message translates to:
  /// **'All Fields are required'**
  String get allfieldsarerequired;

  /// No description provided for @termsandcondition.
  ///
  /// In en, this message translates to:
  /// **'Terms and Condition'**
  String get termsandcondition;

  /// No description provided for @personal.
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get personal;

  /// No description provided for @shippingaddress.
  ///
  /// In en, this message translates to:
  /// **'Shipping Address'**
  String get shippingaddress;

  /// No description provided for @paymentmethods.
  ///
  /// In en, this message translates to:
  /// **'Payment methods'**
  String get paymentmethods;

  /// No description provided for @requestaccountdeletion.
  ///
  /// In en, this message translates to:
  /// **'Request Account Deletion'**
  String get requestaccountdeletion;

  /// No description provided for @youaregoingtodeleteyouraccount.
  ///
  /// In en, this message translates to:
  /// **'You are going to delete your account'**
  String get youaregoingtodeleteyouraccount;

  /// No description provided for @youwontbeabletorestoreyourdata.
  ///
  /// In en, this message translates to:
  /// **'You won\'t be able to restore your data'**
  String get youwontbeabletorestoreyourdata;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @paymentmethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentmethod;

  /// No description provided for @whichitemyouwanttoreview.
  ///
  /// In en, this message translates to:
  /// **'Which item you want to review?'**
  String get whichitemyouwanttoreview;

  /// No description provided for @trackingnumber.
  ///
  /// In en, this message translates to:
  /// **'Tracking Number'**
  String get trackingnumber;

  /// No description provided for @packed.
  ///
  /// In en, this message translates to:
  /// **'Packed'**
  String get packed;

  /// No description provided for @yourparcelispackedandwillbehandedovertoourdelivery.
  ///
  /// In en, this message translates to:
  /// **'Your parcel is packed and will be handed over to our delivery partner.'**
  String get yourparcelispackedandwillbehandedovertoourdelivery;

  /// No description provided for @waitingforpickingdriver.
  ///
  /// In en, this message translates to:
  /// **'Waiting for picking driver'**
  String get waitingforpickingdriver;

  /// No description provided for @yourparcelisreadytohandover.
  ///
  /// In en, this message translates to:
  /// **'Your parcel is ready to hand over. Waiting for driver'**
  String get yourparcelisreadytohandover;

  /// No description provided for @orderassigned.
  ///
  /// In en, this message translates to:
  /// **'Order assigned'**
  String get orderassigned;

  /// No description provided for @yourorderhasbeenassignedtodriver.
  ///
  /// In en, this message translates to:
  /// **'Your order has been assigned to driver'**
  String get yourorderhasbeenassignedtodriver;

  /// No description provided for @reason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reason;

  /// No description provided for @yourorderhasbeendeliveredsuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Your order has been delivered successfully'**
  String get yourorderhasbeendeliveredsuccessfully;

  /// No description provided for @latestaddiotions.
  ///
  /// In en, this message translates to:
  /// **'LATEST ADDITIONS'**
  String get latestaddiotions;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @searchinwishlist.
  ///
  /// In en, this message translates to:
  /// **'Search in Wishlist'**
  String get searchinwishlist;

  /// No description provided for @emptywishlist.
  ///
  /// In en, this message translates to:
  /// **'Empty wishlist'**
  String get emptywishlist;

  /// No description provided for @removefromwishlish.
  ///
  /// In en, this message translates to:
  /// **'Remove from wishlist'**
  String get removefromwishlish;

  /// No description provided for @productremovedfromwishlish.
  ///
  /// In en, this message translates to:
  /// **'Product removed from wishlist'**
  String get productremovedfromwishlish;

  /// No description provided for @selectrole.
  ///
  /// In en, this message translates to:
  /// **'Select Role'**
  String get selectrole;

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// No description provided for @conti.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get conti;

  /// No description provided for @alreadyhaveanaccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyhaveanaccount;

  /// No description provided for @signin.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signin;

  /// No description provided for @bysigningupyouagreetoour.
  ///
  /// In en, this message translates to:
  /// **'By signing up you agree to our'**
  String get bysigningupyouagreetoour;

  /// No description provided for @termsofservices.
  ///
  /// In en, this message translates to:
  /// **'Terms of Services'**
  String get termsofservices;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get and;

  /// No description provided for @privacypolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacypolicy;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signup;

  /// No description provided for @youremail.
  ///
  /// In en, this message translates to:
  /// **'Your Email'**
  String get youremail;

  /// No description provided for @enterpassword.
  ///
  /// In en, this message translates to:
  /// **'Enter Password'**
  String get enterpassword;

  /// No description provided for @otppreference.
  ///
  /// In en, this message translates to:
  /// **'OTP Preference'**
  String get otppreference;

  /// No description provided for @sms.
  ///
  /// In en, this message translates to:
  /// **'SMS'**
  String get sms;

  /// No description provided for @whatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get whatsapp;

  /// No description provided for @signupwithgoogle.
  ///
  /// In en, this message translates to:
  /// **'Signup with Google'**
  String get signupwithgoogle;

  /// No description provided for @signupwithapple.
  ///
  /// In en, this message translates to:
  /// **'Signup with Apple'**
  String get signupwithapple;

  /// No description provided for @authenticationcode.
  ///
  /// In en, this message translates to:
  /// **'Authentication Code'**
  String get authenticationcode;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @enterotp.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get enterotp;

  /// No description provided for @enter5digitcondewetexttoyouremail.
  ///
  /// In en, this message translates to:
  /// **'Enter 4-digit code we just texted to your email'**
  String get enter5digitcondewetexttoyouremail;

  /// No description provided for @enter5digitcondewetexttoyourphonenumber.
  ///
  /// In en, this message translates to:
  /// **'Enter 4-digit code we just texted to your phone number'**
  String get enter5digitcondewetexttoyourphonenumber;

  /// No description provided for @resendcode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendcode;

  /// No description provided for @pleaseenteraemailaddresstorequestapasswordreset.
  ///
  /// In en, this message translates to:
  /// **'Please enter a email address to request a password reset'**
  String get pleaseenteraemailaddresstorequestapasswordreset;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @enteryourphonenumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enteryourphonenumber;

  /// No description provided for @pleaseenterphonenumbertorequestapasswordreset.
  ///
  /// In en, this message translates to:
  /// **'Please enter a phone number to request a password reset'**
  String get pleaseenterphonenumbertorequestapasswordreset;

  /// No description provided for @yourphonenumber.
  ///
  /// In en, this message translates to:
  /// **'Your phone number'**
  String get yourphonenumber;

  /// No description provided for @pleasesigininwithemail.
  ///
  /// In en, this message translates to:
  /// **'Please Sign in with email'**
  String get pleasesigininwithemail;

  /// No description provided for @rememberinformation.
  ///
  /// In en, this message translates to:
  /// **'Remember information'**
  String get rememberinformation;

  /// No description provided for @forgetpassword.
  ///
  /// In en, this message translates to:
  /// **'Forget password?'**
  String get forgetpassword;

  /// No description provided for @haventsignedupyet.
  ///
  /// In en, this message translates to:
  /// **'Haven\'t Signed Up Yet'**
  String get haventsignedupyet;

  /// No description provided for @signupnow.
  ///
  /// In en, this message translates to:
  /// **'Sign up Now'**
  String get signupnow;

  /// No description provided for @loginwithemail.
  ///
  /// In en, this message translates to:
  /// **'Log in with Email'**
  String get loginwithemail;

  /// No description provided for @loginwithmobilenumber.
  ///
  /// In en, this message translates to:
  /// **'Log in with Mobile Number'**
  String get loginwithmobilenumber;

  /// No description provided for @loginwithgoogle.
  ///
  /// In en, this message translates to:
  /// **'Login with Google'**
  String get loginwithgoogle;

  /// No description provided for @loginwithapple.
  ///
  /// In en, this message translates to:
  /// **'Login with Apple'**
  String get loginwithapple;

  /// No description provided for @resetpassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetpassword;

  /// No description provided for @signintoshopsmarterandfaster.
  ///
  /// In en, this message translates to:
  /// **'Sign in to shop smarter and faster'**
  String get signintoshopsmarterandfaster;

  /// No description provided for @pleaseenteryourmobilenumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter your Mobile Number'**
  String get pleaseenteryourmobilenumber;

  /// No description provided for @welcometotelimani.
  ///
  /// In en, this message translates to:
  /// **'welcome to telimani'**
  String get welcometotelimani;

  /// No description provided for @donthaveandaccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get donthaveandaccount;

  /// No description provided for @buynow.
  ///
  /// In en, this message translates to:
  /// **'Buy Now'**
  String get buynow;

  /// No description provided for @sayit.
  ///
  /// In en, this message translates to:
  /// **'Say it'**
  String get sayit;

  /// No description provided for @selectlanguge.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectlanguge;

  /// No description provided for @addpckupaddress.
  ///
  /// In en, this message translates to:
  /// **'Add Pickup Address'**
  String get addpckupaddress;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @mypickupaddress.
  ///
  /// In en, this message translates to:
  /// **'My Pickup Address'**
  String get mypickupaddress;

  /// No description provided for @bankdetail.
  ///
  /// In en, this message translates to:
  /// **'Bank Detail'**
  String get bankdetail;

  /// No description provided for @accounttitle.
  ///
  /// In en, this message translates to:
  /// **'Account Title'**
  String get accounttitle;

  /// No description provided for @accountholdername.
  ///
  /// In en, this message translates to:
  /// **'Account Holder Name'**
  String get accountholdername;

  /// No description provided for @accountnumber.
  ///
  /// In en, this message translates to:
  /// **'Account Number'**
  String get accountnumber;

  /// No description provided for @bankname.
  ///
  /// In en, this message translates to:
  /// **'Bank Name'**
  String get bankname;

  /// No description provided for @thenameofyourbank.
  ///
  /// In en, this message translates to:
  /// **'The name of your bank'**
  String get thenameofyourbank;

  /// No description provided for @bankcode.
  ///
  /// In en, this message translates to:
  /// **'Bank Code'**
  String get bankcode;

  /// No description provided for @iban.
  ///
  /// In en, this message translates to:
  /// **'IBAN'**
  String get iban;

  /// No description provided for @uploadchequecopy.
  ///
  /// In en, this message translates to:
  /// **'Upload Cheque Copy'**
  String get uploadchequecopy;

  /// No description provided for @bankaccount.
  ///
  /// In en, this message translates to:
  /// **'Bank Account'**
  String get bankaccount;

  /// No description provided for @asyouareupdatingaccountsettingyoualreadyreadandaccepted.
  ///
  /// In en, this message translates to:
  /// **'As you are updating account setting you already read and accepted our'**
  String get asyouareupdatingaccountsettingyoualreadyreadandaccepted;

  /// No description provided for @termsandconditions.
  ///
  /// In en, this message translates to:
  /// **'Term & Conditions'**
  String get termsandconditions;

  /// No description provided for @toots.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get toots;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @me.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get me;

  /// No description provided for @addcategory.
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get addcategory;

  /// No description provided for @categoryimage.
  ///
  /// In en, this message translates to:
  /// **'Category Image'**
  String get categoryimage;

  /// No description provided for @categoryname.
  ///
  /// In en, this message translates to:
  /// **'Category Name'**
  String get categoryname;

  /// No description provided for @mycategories.
  ///
  /// In en, this message translates to:
  /// **'My Categories'**
  String get mycategories;

  /// No description provided for @searchyoucategory.
  ///
  /// In en, this message translates to:
  /// **'Search Your Category'**
  String get searchyoucategory;

  /// No description provided for @letsaddyourfirstcategory.
  ///
  /// In en, this message translates to:
  /// **'Let\'s add your first category'**
  String get letsaddyourfirstcategory;

  /// No description provided for @notfound.
  ///
  /// In en, this message translates to:
  /// **'Not Found'**
  String get notfound;

  /// No description provided for @categoryid.
  ///
  /// In en, this message translates to:
  /// **'Category ID'**
  String get categoryid;

  /// No description provided for @subcategory.
  ///
  /// In en, this message translates to:
  /// **'Sub Category'**
  String get subcategory;

  /// No description provided for @entername.
  ///
  /// In en, this message translates to:
  /// **'Enter Name'**
  String get entername;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @areyousuretodelete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to delete?'**
  String get areyousuretodelete;

  /// No description provided for @subcategories.
  ///
  /// In en, this message translates to:
  /// **'Sub Categories'**
  String get subcategories;

  /// No description provided for @searchsubcategories.
  ///
  /// In en, this message translates to:
  /// **'Search Sub Category'**
  String get searchsubcategories;

  /// No description provided for @subcategoryid.
  ///
  /// In en, this message translates to:
  /// **'Sub Category ID'**
  String get subcategoryid;

  /// No description provided for @sellercenter.
  ///
  /// In en, this message translates to:
  /// **'Seller Center'**
  String get sellercenter;

  /// No description provided for @sellerid.
  ///
  /// In en, this message translates to:
  /// **'Seller ID'**
  String get sellerid;

  /// No description provided for @toprocess.
  ///
  /// In en, this message translates to:
  /// **'To process'**
  String get toprocess;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @toship.
  ///
  /// In en, this message translates to:
  /// **'To Ship'**
  String get toship;

  /// No description provided for @deliverd.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get deliverd;

  /// No description provided for @failure.
  ///
  /// In en, this message translates to:
  /// **'Failure'**
  String get failure;

  /// No description provided for @noordersfound.
  ///
  /// In en, this message translates to:
  /// **'No orders found.'**
  String get noordersfound;

  /// No description provided for @contachbuyer.
  ///
  /// In en, this message translates to:
  /// **'Contact Buyer'**
  String get contachbuyer;

  /// No description provided for @excellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get excellent;

  /// No description provided for @yourstoreisdoingwell.
  ///
  /// In en, this message translates to:
  /// **'Your store is doing well. Review violations (if any) and continue to keep up with the good work!'**
  String get yourstoreisdoingwell;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'Point(s)'**
  String get points;

  /// No description provided for @whenyoureach12points.
  ///
  /// In en, this message translates to:
  /// **'when you reach 12 points. you will experience listing restrictions and your access to sponsored discovery will be suspended for 7 days.'**
  String get whenyoureach12points;

  /// No description provided for @yourviolations.
  ///
  /// In en, this message translates to:
  /// **'Your violations'**
  String get yourviolations;

  /// No description provided for @violationid.
  ///
  /// In en, this message translates to:
  /// **'Violation ID'**
  String get violationid;

  /// No description provided for @viewreasons.
  ///
  /// In en, this message translates to:
  /// **'View Reasons'**
  String get viewreasons;

  /// No description provided for @theparcelhasbeenreturnedbythecustomer.
  ///
  /// In en, this message translates to:
  /// **'The parcel has been returned by the customer due to dissatisfaction with the product. They mentioned it did not meet their expectations or requirements.'**
  String get theparcelhasbeenreturnedbythecustomer;

  /// No description provided for @myproducts.
  ///
  /// In en, this message translates to:
  /// **'My Products'**
  String get myproducts;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @draft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get draft;

  /// No description provided for @pendingqc.
  ///
  /// In en, this message translates to:
  /// **'Pending Qc'**
  String get pendingqc;

  /// No description provided for @violation.
  ///
  /// In en, this message translates to:
  /// **'Violation'**
  String get violation;

  /// No description provided for @outofstock.
  ///
  /// In en, this message translates to:
  /// **'Out of Stock'**
  String get outofstock;

  /// No description provided for @addproduct.
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get addproduct;

  /// No description provided for @productimages.
  ///
  /// In en, this message translates to:
  /// **'Product Images'**
  String get productimages;

  /// No description provided for @productname.
  ///
  /// In en, this message translates to:
  /// **'Product Name'**
  String get productname;

  /// No description provided for @selectcategory.
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get selectcategory;

  /// No description provided for @selectsubcategory.
  ///
  /// In en, this message translates to:
  /// **'Select Sub Category'**
  String get selectsubcategory;

  /// No description provided for @selectweight.
  ///
  /// In en, this message translates to:
  /// **'Select Weight'**
  String get selectweight;

  /// No description provided for @selectcolor.
  ///
  /// In en, this message translates to:
  /// **'Select Color'**
  String get selectcolor;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @selectsize.
  ///
  /// In en, this message translates to:
  /// **'Select Size'**
  String get selectsize;

  /// No description provided for @size.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get size;

  /// No description provided for @adddescription.
  ///
  /// In en, this message translates to:
  /// **'Add Description'**
  String get adddescription;

  /// No description provided for @writediscriptionhere.
  ///
  /// In en, this message translates to:
  /// **'Write discription here....'**
  String get writediscriptionhere;

  /// No description provided for @addstock.
  ///
  /// In en, this message translates to:
  /// **'Add Stock'**
  String get addstock;

  /// No description provided for @stock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get stock;

  /// No description provided for @addprice.
  ///
  /// In en, this message translates to:
  /// **'Add Price'**
  String get addprice;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @senttoreview.
  ///
  /// In en, this message translates to:
  /// **'Sent to review'**
  String get senttoreview;

  /// No description provided for @publishproduct.
  ///
  /// In en, this message translates to:
  /// **'Publish Product'**
  String get publishproduct;

  /// No description provided for @saveasdraft.
  ///
  /// In en, this message translates to:
  /// **'Save as Draft'**
  String get saveasdraft;

  /// No description provided for @selectpickupaddress.
  ///
  /// In en, this message translates to:
  /// **'Select pickup address'**
  String get selectpickupaddress;

  /// No description provided for @waitingfordrivertopickedup.
  ///
  /// In en, this message translates to:
  /// **'Waiting for driver to picked up'**
  String get waitingfordrivertopickedup;

  /// No description provided for @orderdelivered.
  ///
  /// In en, this message translates to:
  /// **'Order Delivered'**
  String get orderdelivered;

  /// No description provided for @driverpickedtheorder.
  ///
  /// In en, this message translates to:
  /// **'Driver Picked the order'**
  String get driverpickedtheorder;

  /// No description provided for @driverhasacceptedtheordetandreadytopicked.
  ///
  /// In en, this message translates to:
  /// **'Driver has accepted the order and ready to Picked'**
  String get driverhasacceptedtheordetandreadytopicked;

  /// No description provided for @failedtodeliver.
  ///
  /// In en, this message translates to:
  /// **'Failed to deliver'**
  String get failedtodeliver;

  /// No description provided for @readytoship.
  ///
  /// In en, this message translates to:
  /// **'Ready to Ship'**
  String get readytoship;

  /// No description provided for @pleaseselectpickupaddress.
  ///
  /// In en, this message translates to:
  /// **'Please select pickup address'**
  String get pleaseselectpickupaddress;

  /// No description provided for @orderhasveebsetforshipsuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Order has been set for ship successfully'**
  String get orderhasveebsetforshipsuccessfully;

  /// No description provided for @printinvoice.
  ///
  /// In en, this message translates to:
  /// **'Print Invoice'**
  String get printinvoice;

  /// No description provided for @grandtotal.
  ///
  /// In en, this message translates to:
  /// **'Grand Total'**
  String get grandtotal;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @nochatfound.
  ///
  /// In en, this message translates to:
  /// **'No Chat found.'**
  String get nochatfound;

  /// No description provided for @typeyourmessage.
  ///
  /// In en, this message translates to:
  /// **'Type your message'**
  String get typeyourmessage;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @photos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get photos;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @numberofdaysasaseller.
  ///
  /// In en, this message translates to:
  /// **'Number of Days as a seller:'**
  String get numberofdaysasaseller;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @shophomepage.
  ///
  /// In en, this message translates to:
  /// **'Shop homepage'**
  String get shophomepage;

  /// No description provided for @shareshop.
  ///
  /// In en, this message translates to:
  /// **'Share Shop'**
  String get shareshop;

  /// No description provided for @accountsetting.
  ///
  /// In en, this message translates to:
  /// **'Account Setting'**
  String get accountsetting;

  /// No description provided for @accounthealth.
  ///
  /// In en, this message translates to:
  /// **'Account Health'**
  String get accounthealth;

  /// No description provided for @pickupaddress.
  ///
  /// In en, this message translates to:
  /// **'Pickup Address'**
  String get pickupaddress;

  /// No description provided for @chatsetting.
  ///
  /// In en, this message translates to:
  /// **'Chat Setting'**
  String get chatsetting;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @chatwithus.
  ///
  /// In en, this message translates to:
  /// **'Chat with Us'**
  String get chatwithus;

  /// No description provided for @deactivateaccount.
  ///
  /// In en, this message translates to:
  /// **'Deactivate Account'**
  String get deactivateaccount;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feed Back'**
  String get feedback;

  /// No description provided for @giveyourfeedback.
  ///
  /// In en, this message translates to:
  /// **'Give your Feedback'**
  String get giveyourfeedback;

  /// No description provided for @writesomethinghere.
  ///
  /// In en, this message translates to:
  /// **'Write something here'**
  String get writesomethinghere;

  /// No description provided for @tools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get tools;

  /// No description provided for @managereviews.
  ///
  /// In en, this message translates to:
  /// **'Manage Reviews'**
  String get managereviews;

  /// No description provided for @storename.
  ///
  /// In en, this message translates to:
  /// **'Store name'**
  String get storename;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @informationmisiing.
  ///
  /// In en, this message translates to:
  /// **'Information missing'**
  String get informationmisiing;

  /// No description provided for @informationupdatedsuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Information updated successfully'**
  String get informationupdatedsuccessfully;

  /// No description provided for @prodcutreview.
  ///
  /// In en, this message translates to:
  /// **'Product Review'**
  String get prodcutreview;

  /// No description provided for @searchreview.
  ///
  /// In en, this message translates to:
  /// **'Search review'**
  String get searchreview;

  /// No description provided for @addyourbydefaultmessage.
  ///
  /// In en, this message translates to:
  /// **'Add your by default message'**
  String get addyourbydefaultmessage;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @addsubcategory.
  ///
  /// In en, this message translates to:
  /// **'Add Sub category'**
  String get addsubcategory;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @seeviolationdetail.
  ///
  /// In en, this message translates to:
  /// **'See Violation Detail'**
  String get seeviolationdetail;

  /// No description provided for @violationdetail.
  ///
  /// In en, this message translates to:
  /// **'Violation Detail'**
  String get violationdetail;

  /// No description provided for @showmore.
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get showmore;

  /// No description provided for @showless.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get showless;

  /// No description provided for @doyouwanttodeleteproduct.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete product?'**
  String get doyouwanttodeleteproduct;

  /// No description provided for @productdeletedsuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Product Deleted successfully'**
  String get productdeletedsuccessfully;

  /// No description provided for @editproduct.
  ///
  /// In en, this message translates to:
  /// **'Edit Product'**
  String get editproduct;

  /// No description provided for @editprice.
  ///
  /// In en, this message translates to:
  /// **'Edit Price'**
  String get editprice;

  /// No description provided for @editstock.
  ///
  /// In en, this message translates to:
  /// **'Edit Stock'**
  String get editstock;

  /// No description provided for @activate.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get activate;

  /// No description provided for @deactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get deactivate;

  /// No description provided for @productactivated.
  ///
  /// In en, this message translates to:
  /// **'Product Activated'**
  String get productactivated;

  /// No description provided for @productdeactivated.
  ///
  /// In en, this message translates to:
  /// **'Product Dactivated'**
  String get productdeactivated;

  /// No description provided for @completelistingandpublish.
  ///
  /// In en, this message translates to:
  /// **'Complete Listing & Publish'**
  String get completelistingandpublish;

  /// No description provided for @incorrectvalue.
  ///
  /// In en, this message translates to:
  /// **'Incorrect value'**
  String get incorrectvalue;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @adddiscount.
  ///
  /// In en, this message translates to:
  /// **'Add Discount'**
  String get adddiscount;

  /// No description provided for @searchyourproduct.
  ///
  /// In en, this message translates to:
  /// **'Search Your Product'**
  String get searchyourproduct;

  /// No description provided for @myprofiles.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myprofiles;

  /// No description provided for @pendingdeliveries.
  ///
  /// In en, this message translates to:
  /// **'Pending Deliveries'**
  String get pendingdeliveries;

  /// No description provided for @viewhistory.
  ///
  /// In en, this message translates to:
  /// **'View History'**
  String get viewhistory;

  /// No description provided for @driverinfo.
  ///
  /// In en, this message translates to:
  /// **'Driver Info'**
  String get driverinfo;

  /// No description provided for @enteryourname.
  ///
  /// In en, this message translates to:
  /// **'Enter your Name'**
  String get enteryourname;

  /// No description provided for @firstname.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstname;

  /// No description provided for @lastname.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastname;

  /// No description provided for @enterphonenumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Phone Number'**
  String get enterphonenumber;

  /// No description provided for @enterdrivinglicencedetails.
  ///
  /// In en, this message translates to:
  /// **'Enter Driving License Detail'**
  String get enterdrivinglicencedetails;

  /// No description provided for @drivinglicensenumber.
  ///
  /// In en, this message translates to:
  /// **'Driving License'**
  String get drivinglicensenumber;

  /// No description provided for @bikeregistrationnumber.
  ///
  /// In en, this message translates to:
  /// **'Bike Registration'**
  String get bikeregistrationnumber;

  /// No description provided for @uploadyourdriverlicences.
  ///
  /// In en, this message translates to:
  /// **'Upload Your Driver’s License'**
  String get uploadyourdriverlicences;

  /// No description provided for @uploadfrontimage.
  ///
  /// In en, this message translates to:
  /// **'Upload Front Image'**
  String get uploadfrontimage;

  /// No description provided for @uploadbackimage.
  ///
  /// In en, this message translates to:
  /// **'Upload Back Image'**
  String get uploadbackimage;

  /// No description provided for @drivingsince.
  ///
  /// In en, this message translates to:
  /// **'Driving Since'**
  String get drivingsince;

  /// No description provided for @birthdate.
  ///
  /// In en, this message translates to:
  /// **'Birth Date'**
  String get birthdate;

  /// No description provided for @accepttermsandcondition.
  ///
  /// In en, this message translates to:
  /// **'Accept terms & Condition'**
  String get accepttermsandcondition;

  /// No description provided for @chatbot.
  ///
  /// In en, this message translates to:
  /// **'Chat Bot'**
  String get chatbot;

  /// No description provided for @customercareservice.
  ///
  /// In en, this message translates to:
  /// **'Customer Care Service'**
  String get customercareservice;

  /// No description provided for @orderissues.
  ///
  /// In en, this message translates to:
  /// **'Order Issues'**
  String get orderissues;

  /// No description provided for @working.
  ///
  /// In en, this message translates to:
  /// **'Working'**
  String get working;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @currentshift.
  ///
  /// In en, this message translates to:
  /// **'Current Shift'**
  String get currentshift;

  /// No description provided for @youareoffline.
  ///
  /// In en, this message translates to:
  /// **'You are offline'**
  String get youareoffline;

  /// No description provided for @availableshipments.
  ///
  /// In en, this message translates to:
  /// **'Available Shipments'**
  String get availableshipments;

  /// No description provided for @value.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get value;

  /// No description provided for @ongoing.
  ///
  /// In en, this message translates to:
  /// **'On going'**
  String get ongoing;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @waitingfordeliveries.
  ///
  /// In en, this message translates to:
  /// **'Waiting for\nDeliveries'**
  String get waitingfordeliveries;

  /// No description provided for @vendor.
  ///
  /// In en, this message translates to:
  /// **'Vendor'**
  String get vendor;

  /// No description provided for @pleaseenterfailurereason.
  ///
  /// In en, this message translates to:
  /// **'Please enter failure reason'**
  String get pleaseenterfailurereason;

  /// No description provided for @orderhasbeenfailedtodeliver.
  ///
  /// In en, this message translates to:
  /// **'Order has been failed to deliver'**
  String get orderhasbeenfailedtodeliver;

  /// No description provided for @failurereason.
  ///
  /// In en, this message translates to:
  /// **'Failure reason'**
  String get failurereason;

  /// No description provided for @arrivedat.
  ///
  /// In en, this message translates to:
  /// **'Arrived at'**
  String get arrivedat;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @destination.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get destination;

  /// No description provided for @contactvendor.
  ///
  /// In en, this message translates to:
  /// **'Contact Vendor'**
  String get contactvendor;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @totalitems.
  ///
  /// In en, this message translates to:
  /// **'Total items'**
  String get totalitems;

  /// No description provided for @itemsvalue.
  ///
  /// In en, this message translates to:
  /// **'Items Value'**
  String get itemsvalue;

  /// No description provided for @contactcustomer.
  ///
  /// In en, this message translates to:
  /// **'Contact Customer'**
  String get contactcustomer;

  /// No description provided for @doyouconfirmyoudeliveredtheorder.
  ///
  /// In en, this message translates to:
  /// **'Do you confirm? you  delivered the Order?'**
  String get doyouconfirmyoudeliveredtheorder;

  /// No description provided for @shipmentdeliveredsuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Shipment Deliverd successfully'**
  String get shipmentdeliveredsuccessfully;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @ordercheckedandpickedup.
  ///
  /// In en, this message translates to:
  /// **'Order checked & picked up'**
  String get ordercheckedandpickedup;

  /// No description provided for @doyouconfirmyoucheckedproperlyandpickedtheorder.
  ///
  /// In en, this message translates to:
  /// **'Do you confirm? you  checked properly and Picked the Order?'**
  String get doyouconfirmyoucheckedproperlyandpickedtheorder;

  /// No description provided for @shipmentpickedsuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Shipment picked successfully'**
  String get shipmentpickedsuccessfully;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @neworder.
  ///
  /// In en, this message translates to:
  /// **'New Order'**
  String get neworder;

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// No description provided for @orderprice.
  ///
  /// In en, this message translates to:
  /// **'Order Price'**
  String get orderprice;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @orderacceptedforshipping.
  ///
  /// In en, this message translates to:
  /// **'Order accepted for shipping'**
  String get orderacceptedforshipping;

  /// No description provided for @pendingshipments.
  ///
  /// In en, this message translates to:
  /// **'Pending Shipments'**
  String get pendingshipments;

  /// No description provided for @completedshipments.
  ///
  /// In en, this message translates to:
  /// **'Completed Shipments'**
  String get completedshipments;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @driverprofile.
  ///
  /// In en, this message translates to:
  /// **'Driver Profile'**
  String get driverprofile;

  /// No description provided for @drivinglicensedetail.
  ///
  /// In en, this message translates to:
  /// **'Driving License Detail'**
  String get drivinglicensedetail;

  /// No description provided for @driverlicenseimage.
  ///
  /// In en, this message translates to:
  /// **'Driver’s License Images'**
  String get driverlicenseimage;

  /// No description provided for @editprofile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editprofile;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'date'**
  String get date;

  /// No description provided for @entercouponcode.
  ///
  /// In en, this message translates to:
  /// **'Use a coupon code to save on your purchase'**
  String get entercouponcode;

  /// No description provided for @couponcodeapplied.
  ///
  /// In en, this message translates to:
  /// **'The coupon has been applied successfully'**
  String get couponcodeapplied;

  /// No description provided for @couponcode.
  ///
  /// In en, this message translates to:
  /// **'Coupon Code'**
  String get couponcode;

  /// No description provided for @applycoupon.
  ///
  /// In en, this message translates to:
  /// **'Apply coupon'**
  String get applycoupon;

  /// No description provided for @media.
  ///
  /// In en, this message translates to:
  /// **'Media'**
  String get media;

  /// No description provided for @enter4digitcodeforemail.
  ///
  /// In en, this message translates to:
  /// **'Enter 4-digit code for reset password we just texted to your email'**
  String get enter4digitcodeforemail;

  /// No description provided for @enter4digitcodeforphone.
  ///
  /// In en, this message translates to:
  /// **'Enter 4-digit code for reset password we just texted to your Phone number'**
  String get enter4digitcodeforphone;

  /// No description provided for @pleaseenterotp.
  ///
  /// In en, this message translates to:
  /// **'Please enter otp'**
  String get pleaseenterotp;

  /// No description provided for @pleasefillallfields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields'**
  String get pleasefillallfields;

  /// No description provided for @emptyotp.
  ///
  /// In en, this message translates to:
  /// **'Empty Otp'**
  String get emptyotp;

  /// No description provided for @loggedinsuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Logged in successfully'**
  String get loggedinsuccessfully;

  /// No description provided for @phonenumberrequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number required'**
  String get phonenumberrequired;

  /// No description provided for @frontsideoflicenseisrequired.
  ///
  /// In en, this message translates to:
  /// **'Front side of license is required'**
  String get frontsideoflicenseisrequired;

  /// No description provided for @backsideoflicenseisrequired.
  ///
  /// In en, this message translates to:
  /// **'Back side of license is required'**
  String get backsideoflicenseisrequired;

  /// No description provided for @informationsuccessfullyupdated.
  ///
  /// In en, this message translates to:
  /// **'Information successfully updated'**
  String get informationsuccessfullyupdated;

  /// No description provided for @pleasesignupfirsttousethisaccount.
  ///
  /// In en, this message translates to:
  /// **'Please sign up first to use this account'**
  String get pleasesignupfirsttousethisaccount;

  /// No description provided for @loginfailedinvalidserverresponse.
  ///
  /// In en, this message translates to:
  /// **'Login failed: Invalid server response'**
  String get loginfailedinvalidserverresponse;

  /// No description provided for @loginfailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginfailed;

  /// No description provided for @signinerrorfailedtosiginin.
  ///
  /// In en, this message translates to:
  /// **'Sign-In Error: Failed to sign in. Please try again.'**
  String get signinerrorfailedtosiginin;

  /// No description provided for @categorynamerequired.
  ///
  /// In en, this message translates to:
  /// **'Category name required'**
  String get categorynamerequired;

  /// No description provided for @categoryimagerequired.
  ///
  /// In en, this message translates to:
  /// **'Category image required'**
  String get categoryimagerequired;

  /// No description provided for @newcategoryhasbeenadded.
  ///
  /// In en, this message translates to:
  /// **'New category has been added'**
  String get newcategoryhasbeenadded;

  /// No description provided for @successfullydeletedcategory.
  ///
  /// In en, this message translates to:
  /// **'Successfully deleted category'**
  String get successfullydeletedcategory;

  /// No description provided for @sucssfullydeletedsubcategory.
  ///
  /// In en, this message translates to:
  /// **'Successfully deleted sub category'**
  String get sucssfullydeletedsubcategory;

  /// No description provided for @categoryupdated.
  ///
  /// In en, this message translates to:
  /// **'Category updated'**
  String get categoryupdated;

  /// No description provided for @subcategorynamerequired.
  ///
  /// In en, this message translates to:
  /// **'Subcategory name required'**
  String get subcategorynamerequired;

  /// No description provided for @locationpermissionispermanentenlydenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission is permanently denied. Enable it from settings.'**
  String get locationpermissionispermanentenlydenied;

  /// No description provided for @shippingaddressaddedsuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Shipping address added successfully'**
  String get shippingaddressaddedsuccessfully;

  /// No description provided for @billingaddressaddedsuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Billing address added successfully'**
  String get billingaddressaddedsuccessfully;

  /// No description provided for @shippingaddressupdatedsuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Shipping address updated successfully'**
  String get shippingaddressupdatedsuccessfully;

  /// No description provided for @billingaddressupdatedsuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Billing address updated successfully'**
  String get billingaddressupdatedsuccessfully;

  /// No description provided for @pleaseuploadproductimages.
  ///
  /// In en, this message translates to:
  /// **'Please upload product images'**
  String get pleaseuploadproductimages;

  /// No description provided for @pleaseenterproducttitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter a product title'**
  String get pleaseenterproducttitle;

  /// No description provided for @pleasechoosecategory.
  ///
  /// In en, this message translates to:
  /// **'Please choose a category'**
  String get pleasechoosecategory;

  /// No description provided for @pleasechoosesubcategory.
  ///
  /// In en, this message translates to:
  /// **'Please choose a sub category'**
  String get pleasechoosesubcategory;

  /// No description provided for @pleasechooseweight.
  ///
  /// In en, this message translates to:
  /// **'Please choose Weight'**
  String get pleasechooseweight;

  /// No description provided for @pleasechoosecolor.
  ///
  /// In en, this message translates to:
  /// **'Please choose Color'**
  String get pleasechoosecolor;

  /// No description provided for @pleasechoosesize.
  ///
  /// In en, this message translates to:
  /// **'Please choose Size'**
  String get pleasechoosesize;

  /// No description provided for @pleaseenterdescription.
  ///
  /// In en, this message translates to:
  /// **'Please enter a description'**
  String get pleaseenterdescription;

  /// No description provided for @addavailablestock.
  ///
  /// In en, this message translates to:
  /// **'Add available stock'**
  String get addavailablestock;

  /// No description provided for @pleaseentertheproductprice.
  ///
  /// In en, this message translates to:
  /// **'Please enter the product price'**
  String get pleaseentertheproductprice;

  /// No description provided for @youproductwasaddedsuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Your product was added successfully'**
  String get youproductwasaddedsuccessfully;

  /// No description provided for @productpriceupdatedsuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Product Price updated successfully'**
  String get productpriceupdatedsuccessfully;

  /// No description provided for @productstockupdatedsuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Product Stock updated successfully'**
  String get productstockupdatedsuccessfully;

  /// No description provided for @successfullydeletedproduct.
  ///
  /// In en, this message translates to:
  /// **'Successfully deleted product'**
  String get successfullydeletedproduct;

  /// No description provided for @successfullyaddedprofile.
  ///
  /// In en, this message translates to:
  /// **'Successfully added profile'**
  String get successfullyaddedprofile;

  /// No description provided for @yourinformationhasbeenupdated.
  ///
  /// In en, this message translates to:
  /// **'Your information has been updated'**
  String get yourinformationhasbeenupdated;

  /// No description provided for @pleaseenteryouremail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseenteryouremail;

  /// No description provided for @pleaseenteryourphonenumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get pleaseenteryourphonenumber;

  /// No description provided for @pleaseenterbothpasswordandconfirmation.
  ///
  /// In en, this message translates to:
  /// **'Please provide both password and confirmation'**
  String get pleaseenterbothpasswordandconfirmation;

  /// No description provided for @passworddoesnotmatch.
  ///
  /// In en, this message translates to:
  /// **'Password doesn\'t match'**
  String get passworddoesnotmatch;

  /// No description provided for @subcategoryupdated.
  ///
  /// In en, this message translates to:
  /// **'Subcategory updated'**
  String get subcategoryupdated;

  /// No description provided for @subcategorycreatedsuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Subcategory successfully created'**
  String get subcategorycreatedsuccessfully;

  /// No description provided for @pleasechooseimage.
  ///
  /// In en, this message translates to:
  /// **'Please choose an image'**
  String get pleasechooseimage;

  /// No description provided for @pleasecheckyourinternet.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet and try again.'**
  String get pleasecheckyourinternet;

  /// No description provided for @requesttimeuout.
  ///
  /// In en, this message translates to:
  /// **'Request timed out. Please try again.'**
  String get requesttimeuout;

  /// No description provided for @newpassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newpassword;

  /// No description provided for @enternewpassword.
  ///
  /// In en, this message translates to:
  /// **'Enter New Password'**
  String get enternewpassword;

  /// No description provided for @confirmpassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmpassword;

  /// No description provided for @reenternewpassword.
  ///
  /// In en, this message translates to:
  /// **'Re Enter New Password'**
  String get reenternewpassword;

  /// No description provided for @yourpasswordlooksweak.
  ///
  /// In en, this message translates to:
  /// **'Your password looks weak'**
  String get yourpasswordlooksweak;

  /// No description provided for @least8characters.
  ///
  /// In en, this message translates to:
  /// **'Least 8 characters'**
  String get least8characters;

  /// No description provided for @leastonenumber.
  ///
  /// In en, this message translates to:
  /// **'Least one number (0-9) or symbol'**
  String get leastonenumber;

  /// No description provided for @lowercaseanduppercase.
  ///
  /// In en, this message translates to:
  /// **'Lowercase (a-z) and uppercase (A-Z)'**
  String get lowercaseanduppercase;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

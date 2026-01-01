
import 'package:flutter/material.dart';
import 'package:sugudeni/utils/routes/custom-page-builder.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';
import 'package:sugudeni/view/auth/enter-code-view.dart';
import 'package:sugudeni/view/auth/enter-otp-view.dart';
import 'package:sugudeni/view/auth/forget-password-email.dart';
import 'package:sugudeni/view/auth/forget-password-phone.dart';
import 'package:sugudeni/view/auth/login-with-email.dart';
import 'package:sugudeni/view/auth/login-with-phone.dart';
import 'package:sugudeni/view/auth/main-login-view.dart';
import 'package:sugudeni/view/auth/reset-password-view.dart';
import 'package:sugudeni/view/auth/sign-up-view.dart';
import 'package:sugudeni/view/customer/account/customer-account-view.dart';
import 'package:sugudeni/view/customer/account/customer-to-receive-order-view.dart';
import 'package:sugudeni/view/customer/bottomNav/customer-bottom-nav.dart';
import 'package:sugudeni/view/customer/cart/customer-add-address-view.dart';
import 'package:sugudeni/view/customer/cart/customer-add-card-view.dart';
import 'package:sugudeni/view/customer/cart/customer-address-view.dart';
import 'package:sugudeni/view/customer/cart/customer-cash-on-delivery-view.dart';
import 'package:sugudeni/view/customer/cart/customer-checkout-view.dart';
import 'package:sugudeni/view/customer/cart/customer-pay-at-your-address.dart';
import 'package:sugudeni/view/customer/cart/customer-select-payment-method-view.dart';
import 'package:sugudeni/view/customer/chat/chat-with-owner-view.dart';
import 'package:sugudeni/view/customer/help/customer-help-center-one-view.dart';
import 'package:sugudeni/view/customer/products/customer-product-detail-view.dart';
import 'package:sugudeni/view/customer/products/customer-product-question-view.dart';
import 'package:sugudeni/view/customer/products/customer-product-review-view.dart';
import 'package:sugudeni/view/customer/setting/customer-payment-method-view.dart';
import 'package:sugudeni/view/customer/setting/customer-setting-view.dart';
import 'package:sugudeni/view/customer/setting/customer-term-and-condition-view.dart';
import 'package:sugudeni/view/customer/setting/profile-setting-view.dart';
import 'package:sugudeni/view/customer/trackOrder/customer-order-tracking-step-one.dart';
import 'package:sugudeni/view/customer/trackOrder/customer-order-tracking-step-three.dart';
import 'package:sugudeni/view/customer/trackOrder/customer-order-tracking-step-two.dart';
import 'package:sugudeni/view/customer/trackOrder/customer-to-delivered-view.dart';
import 'package:sugudeni/view/customer/visitStore/customer-visit-store-view.dart';
import 'package:sugudeni/view/driver/auth/driver-sign-up-view.dart';
import 'package:sugudeni/view/driver/driver-profile-view.dart';
import 'package:sugudeni/view/driver/help/help-center-view.dart';
import 'package:sugudeni/view/driver/home/driver-home-view.dart';
import 'package:sugudeni/view/driver/order/arrived-at-customer.dart';
import 'package:sugudeni/view/driver/order/arrived-at-vendor.dart';
import 'package:sugudeni/view/driver/order/driver-new-order-view.dart';
import 'package:sugudeni/view/driver/privacyAndTerms/driver-privacy-policy-view.dart';
import 'package:sugudeni/view/driver/privacyAndTerms/driver-term-and-condition-view.dart';
import 'package:sugudeni/view/driver/shipments/driver-completed-shipments.dart';
import 'package:sugudeni/view/driver/shipments/driver-pending-shipments.dart';
import 'package:sugudeni/view/selectRole/select-role-view.dart';
import 'package:sugudeni/view/seller/address/seller-add-pickup-address-view.dart';
import 'package:sugudeni/view/seller/address/seller-pickup-address-view.dart';
import 'package:sugudeni/view/seller/bankDetail/seller-bank-detail-view.dart';
import 'package:sugudeni/view/seller/bottomNav/seller-bottom-nav-view.dart';
import 'package:sugudeni/view/seller/category/add-category-view.dart';
import 'package:sugudeni/view/seller/category/seller-my-category-view.dart';
import 'package:sugudeni/view/seller/category/seller-sub-categories-view.dart';
import 'package:sugudeni/view/seller/health/seller-account-health-view.dart';
import 'package:sugudeni/view/seller/income/seller-income-view.dart';
import 'package:sugudeni/view/seller/me/seller-profile-view.dart';
import 'package:sugudeni/view/seller/messages/seller-message-detailed-screen.dart';
import 'package:sugudeni/view/seller/orders/seller-orders-view.dart';
import 'package:sugudeni/view/seller/orders/seller-return-order-view.dart';
import 'package:sugudeni/view/seller/products/seller-add-product-view.dart';
import 'package:sugudeni/view/seller/products/seller-my-products-view.dart';
import 'package:sugudeni/view/seller/review/seller-manage-review-view.dart';
import 'package:sugudeni/view/seller/setting/seller-setting-view.dart';
import 'package:sugudeni/view/splash/splash-view.dart';
import 'package:sugudeni/view/notifications/notifications-view.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case RoutesNames.splashView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SplashView());
 case RoutesNames.selectRoleView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SelectRoleView());
        case RoutesNames.signUpView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SignUpView());

      case RoutesNames.forgetPasswordEmailView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const ForgetPasswordEmailView());
      case RoutesNames.forgetPasswordPhoneView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const ForgetPasswordPhoneView());

      case RoutesNames.resetPasswordView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const ResetPasswordView());

      case RoutesNames.enterCodeView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const EnterCodeView());

      case RoutesNames.loginView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const MainLoginView());


      case RoutesNames.loginWithEmailView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LoginWithEmailView());

      case RoutesNames.loginWithPhoneView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LoginWithPhoneView());

      case RoutesNames.enterOTPView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const EnterOtpView());


        /// divers
      case RoutesNames.driverSignUpView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const DriverSignUpView());
        case RoutesNames.driverHomeView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const DriverHomeView());
      case RoutesNames.driverProfileView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const DriverProfileView());
        case RoutesNames.driverPrivacyPolicy:
        return MaterialPageRoute(
            builder: (BuildContext context) => const DriverPrivacyPolicyView());
        case RoutesNames.driverTermAndConditions:
        return MaterialPageRoute(
            builder: (BuildContext context) => const DriverTermAndConditionView());
        case RoutesNames.driverNewOrderView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const DriverNewOrderView(),settings: routeSettings);
        case RoutesNames.arrivedAtCustomer:
        return MaterialPageRoute(
            builder: (BuildContext context) => const ArrivedAtCustomer(),settings: routeSettings);
        case RoutesNames.arrivedAtVendor:
        return MaterialPageRoute(
            builder: (BuildContext context) => const ArrivedAtVendor(),settings: routeSettings);
      case RoutesNames.driverHelpCenterView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const HelpCenterView());
      case RoutesNames.driverPendingDeliveriesView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const DriverPendingShipmentView());
      case RoutesNames.driverCompletedDeliveryView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const DriverCompletedShipmentView());
        /// seller routes
      case RoutesNames.sellerBottomNav:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const SellerBottomNavBarView());

      case RoutesNames.sellerAddProductView:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const SellerAddProductView());

      case RoutesNames.sellerMyProductsView:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const SellerMyProductsView());
      case RoutesNames.sellerMyCategoriesView:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const SellerMyCategoriesView());
      case RoutesNames.sellerAddCategoryView:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const SellerAddCategoryView());
        case RoutesNames.sellerSubCategoryView:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const SellerSubCategoriesView(),settings: routeSettings);

      case RoutesNames.sellerAccountSettingView:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const SellerAccountSettingView());

      case RoutesNames.sellerOrdersView:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const SellerOrderView());

      case RoutesNames.sellerReturnOrdersView:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const SellerReturnOrderView());

      case RoutesNames.sellerManageReviewView:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const SellerManageReviewView());

      case RoutesNames.sellerIncomeView:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const SellerIncomeView());

      case RoutesNames.sellerContactHelpCenterView:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const Scaffold());

      case RoutesNames.sellerAccountHealthView:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const SellerAccountHealthView());


      case RoutesNames.sellerBankDetailView:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const SellerBankDetailView());
      case RoutesNames.sellerSettingView:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const SellerProfileView());
      case RoutesNames.sellerAddressView:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const SellerAddressView());
      case RoutesNames.sellerAddAddressView:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const SellerAddAddressView());
      case RoutesNames.notificationsView:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const NotificationsView());
        // case RoutesNames.sellerMessageDetailDetailView:
        // return MaterialPageRoute(
        //     builder: (BuildContext context) =>  const SellerMessageDetailView(),settings: routeSettings);

        /// customer routes
      case RoutesNames.customerBottomNav:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const CustomerBottomNavBar());
      case RoutesNames.customerProductDetailView:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const CustomerProductDetailPage(),settings: routeSettings);
      case RoutesNames.customerProductQuestionView:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const CustomerProductQuestionView());
      case RoutesNames.customerProductReviewView:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const CustomerProductReviewView());
      case RoutesNames.customerVisitStoreView:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const CustomerVisitStoreView(),settings: routeSettings);
      case RoutesNames.customerCheckoutView:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const CustomerCheckOutView());
      case RoutesNames.customerSelectPaymentMethodView:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const CustomerSelectPaymentMethodView());
      case RoutesNames.customerAddCardView:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const CustomerAddCardView());
      case RoutesNames.customerCashOnDeliveryView:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const CustomerCashOnDeliveryView());

      case RoutesNames.customerPayAtYourAddressView:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const CustomerPayAtYourAddress());

      case RoutesNames.customerAddAddressView:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const CustomerAddAddressView());

      case RoutesNames.customerAddressView:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const CustomerAddressView());

      case RoutesNames.customerChatWithOwnerView:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const ChatWithOwnerView());
      case RoutesNames.customerToReceiveView:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const CustomerToReceiveOrderView());
      case RoutesNames.customerHelpCenterView:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const CustomerHelpCenterOneView());
        case RoutesNames.customerTermAndConditionView:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const CustomerTermAndConditionView());


 case RoutesNames.customerSettingView:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const CustomerSettingView());
case RoutesNames.customerProfileSettingView:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const CustomerProfileSettingView());

case RoutesNames.customerPaymentMethodsView:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const CustomerPaymentMethodView());

      case RoutesNames.customerOrderTrackingStepOneViewView:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const CustomerOrderTrackingStepOne(),settings: routeSettings);
      case RoutesNames.customerAccountView:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  const CustomerAccountView());

      case RoutesNames.customerOrderTrackingStepTwoViewView:
        return customPageRouteFade(const CustomerOrderTrackingStepTwo(), routeSettings);

      case RoutesNames.customerOrderTrackingStepThreeViewView:
        return customPageRouteFade(const CustomerOrderTrackingStepThree(), routeSettings);
  case RoutesNames.customerToDeliverViewView:
        return customPageRouteFade(const CustomerToDeliveredView(), routeSettings);


      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text('No routes defined'),
            ),
          );
        });
    }
  }
}

class ApiEndpoints{
  //static const String baseUrl = 'http://16.16.26.46:3000/api/v1';
  static const String baseUrl = 'https://api.sugudeni.com/api/v1';
  static const String productUrl = 'https://api.sugudeni.com/';
 // static const String productUrl = 'http://16.16.26.46:3000/';

  /// auth
  static const String signup = 'auth/signup';
  static const String signin = 'auth/signin';
  static const String verifySignUpOtp = 'auth/verifySignupOtp';
  static const String verifySigninOtp = 'auth/verifySigninOtp';

  static const String googleLogin = 'auth/googleLogin';
  static const String twitterLogin = 'auth/twitterLogin';
  static const String appleLogin = 'auth/appleLogin';
  static const String resetPassword = 'auth/resetPasswordRequest';
  static const String verifyResetPasswordOtp = 'auth/verifyPasswordOtp';
  static const String newPassword = 'auth/newPassword';
  static const String setFcmToken = 'auth/setFcmToken';

  ///driver
  static const String updateDriver = 'users/updateDriver';
  static const String toggleDriver = 'users/driver/online';

  ///products
  static const String products = 'products';

  ///categories
  static const String categories = 'categories';
  static const String subcategories = 'subcategories';
  static const String getCategoryProducts = 'products/category';
  static const String getSubCategoryProducts = 'products/subcategory';

  /// sellers
  static const String sellerProducts = 'products/seller';
  static const String updateSellerSetting = 'users/updateSellerSettings';

  ///chat
  static const String chat='chat';
  /// threads
  static const String threads = '$chat/threads';

  ///users
  static const String users = 'users';
  static const String updateCustomerProfile = '$users/profilePic';


  ///activity
  static const String activity = 'activity/user';

  ///address
  static const String address = 'address';

  ///chats history
  static const String chatHistory = '$chat/chatHistory';

  /// unread counts
  static const String unreadCounts = '$chat/unreadCount';
  static const String markAsUnread = '$chat/markAsRead';

  ///carts
  static const String   carts = 'carts';
  static const String   applyCoupons = '$carts/apply-coupon';


  ///orders
  static const String orders = 'orders';
  static const String allOrders = '$orders/all';
  static const String allSellersOrders = '$orders/seller';
  static const String allCustomersOrders = '$orders/user';
  static const String createCheckoutForStripe = '$orders/checkout';
  static const String createCheckoutForOrangeMoney = '$orders/checkout-orangemoney';
  static const String reorder = '$orders/reorder';
  static const String readytoship = '$orders/readytoship';
  static const String sellerStats = 'orders/seller/stats';
  static const String acceptDeliveryToShip = 'orders/accept-shipment';
  static const String shipmentPicket = 'orders/shipment-picked';
  static const String updateShipment = 'orders/update-shipment';
  static const String allAvailableShipments = 'orders/shipments/all';
  static const String driverShipments = 'orders/driver-shipment';
  static const String deliverShipment = 'orders/deliver-shipment';
  static const String deliveryFailed = 'orders/fail-shipment';

  ///wishlist
  static const String wishlist = 'wishlist';

 ///sales
  static const String sale = 'sale';

  ///reviews
  static const String review = 'review';
  static const String productReviews = '$review/product';
  static const String sellerReviews = '$review/seller';
  static const String addReviewToDelivery = '$orders/rate-delivery';

  ///delivery
  static const String deliveryslot = 'deliveryslot';




}

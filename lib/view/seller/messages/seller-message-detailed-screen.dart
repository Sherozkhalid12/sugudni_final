import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/models/messages/ChatHistoryModel.dart';
import 'package:sugudeni/providers/chatSocketProvider/chat-socket-provider.dart';
import 'package:sugudeni/providers/customer-chat-add-doc-provider.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/customWidgets/cached-network-image.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/dialog-extension.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/utils/customWidgets/shimmer-widgets.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/constants/colors.dart';
import '../products/seller-my-products-view.dart';
import '../orders/seller-orders-view.dart';
import '../../customer/chat/select-order-modal.dart';
import '../../customer/chat/select-product-modal.dart';
import '../../customer/chat/chat-attachment-card.dart';
import '../../../models/orders/GetAllOrdersCutomerModel.dart';
import '../../../repositories/orders/customer-order-repository.dart';
import 'select-seller-product-modal.dart';
import 'select-seller-order-modal.dart';
import '../../../models/orders/GetAllOrderSellerResponseModel.dart';
import '../../../repositories/orders/seller-order-repository.dart';

class SellerMessageDetailView extends StatefulWidget {
  final String receiverName;
  final String receiverId;
  final String senderId;
  const SellerMessageDetailView({super.key, required this.receiverName, required this.receiverId, required this.senderId});

  @override
  State<SellerMessageDetailView> createState() => _SellerMessageDetailViewState();
}

class _SellerMessageDetailViewState extends State<SellerMessageDetailView> {
  GetCustomerAllOrderResponseModel? _cachedOrders;
  bool _ordersLoaded = false;
  GetAllOrderSellerResponse? _cachedSellerOrders;
  bool _sellerOrdersLoaded = false;
  // Note: _cachedOrders is kept for compatibility but not loaded for sellers

  @override
  void initState() {
    super.initState();
    
    // Ensure socket is initialized before connecting
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final chatProvider = context.read<ChatSocketProvider>();
      
      // Connect to socket if not already connected
      chatProvider.connectSocketInInitial(context);
      
      // Wait a bit for socket to initialize
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Always fetch chat history when page loads (force reload)
      await chatProvider.getChatHistory(context, widget.receiverId, widget.senderId, forceReload: true);
      
      // Connect socket for this conversation (this sets up listeners)
      chatProvider.connectSocket(widget.receiverId, widget.senderId, context);
      
      // Mark as unread
      chatProvider.markAsUnread(widget.senderId, widget.receiverId, context);
      
      // Pre-load seller orders data for seller side chats only
      // Note: Sellers should not load customer orders as they don't have access
      _loadSellerOrdersData();
    });
  }

  // Removed _loadOrdersData() - sellers should not load customer orders
  // This was causing authorization errors

  Future<void> _loadSellerOrdersData() async {
    if (_sellerOrdersLoaded) return;
    try {
      _cachedSellerOrders = await SellerOrderRepository.allSellerOrders(context);
      if (mounted) {
        setState(() {
          _sellerOrdersLoaded = true;
        });
      }
    } catch (e) {
      customPrint('Error loading seller orders: $e');
    }
  }

  void _showOrderSelectionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SelectSellerOrderModal(
        onOrderSelected: (order) {
          final chatProvider = context.read<ChatSocketProvider>();
          final mediaProvider = context.read<SellerChatAddDocProvider>();
          
          // Close bottom sheet
          mediaProvider.reset();
          
          // Ensure message controller is clear for attachment
          chatProvider.messageController.clear();
          
          // Create attachment data - for order, orderid is the actual order id, productid is empty string
          Map<String, dynamic> attachmentData = {
            'attachmentType': 'order',
            'orderid': order.id,
            'productid': '', // Empty string when sending order
          };
          
          customPrint('Sending order attachment - orderId: ${order.id}');
          
          chatProvider.sendMessage(
            widget.receiverId,
            widget.senderId,
            attachment: true,
            attachmentData: attachmentData,
          );
        },
      ),
    );
  }

  void _showProductSelectionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SelectSellerProductModal(
        onProductSelected: (productId, product) {
          final chatProvider = context.read<ChatSocketProvider>();
          final mediaProvider = context.read<SellerChatAddDocProvider>();
          
          // Close bottom sheet
          mediaProvider.reset();
          
          // Ensure message controller is clear for attachment
          chatProvider.messageController.clear();
          
          // Create attachment data - for product, productid is the actual product id, orderid is empty string
          // Include full product object for optimistic display
          Map<String, dynamic> attachmentData = {
            'attachmentType': 'product',
            'orderid': '', // Empty string when sending product
            'productid': productId,
            'product': {
              '_id': product.id, // Use _id to match Product.fromJson expectations
              'title': product.title,
              'imgCover': product.imgCover,
              'price': product.price,
              'priceAfterDiscount': product.priceAfterDiscount,
              'description': product.description,
              'quantity': product.quantity,
              'sold': product.sold,
              'status': product.status,
              'sku': product.sku,
              'supplier_name': product.supplierName, // Use snake_case to match Product.fromJson
              'brand': product.brand,
              'weight': product.weight,
              'color': product.color,
              'size': product.size,
              'images': product.images,
              'createdAt': product.createdAt.toIso8601String(),
              'updatedAt': product.updatedAt.toIso8601String(),
            },
          };
          
          customPrint('Sending product attachment - productId: $productId');
          
          chatProvider.sendMessage(
            widget.receiverId,
            widget.senderId,
            attachment: true,
            attachmentData: attachmentData,
          );
        },
      ),
    );
  }



  @override
  void dispose() {
    // TODO: implement dispose
    // context.read<ChatSocketProvider>().disconnectSocket();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    customPrint("Reciver id=====================================${widget.receiverId}");
    customPrint("Sender id=====================================${widget.senderId}");
    final mediaProvider=Provider.of<SellerChatAddDocProvider>(context,listen: false);
    const adminId = '67e26686ea078c3a5fdc0698';
    final isSupportChat = widget.receiverId == adminId;
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
      //  Provider.of<ChatSocketProvider>(context,listen: false).disconnectSocket();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 70.h,
          flexibleSpace: Container(
            color: whiteColor,
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(onPressed: (){
                Navigator.pop(context);
              }, icon: const Icon(Icons.arrow_back_ios)),
              const Spacer(),
              MyText(text: capitalizeFirstLetter(widget.receiverName),size: 16.sp,fontWeight: FontWeight.w600,),
              50.width,
              const Spacer(),
              // Image.asset(AppAssets.shopHomePageIcon,scale: 2,width: 20.w,height: 20.h,color: primaryColor,),
              // 10.width,
              // Image.asset(AppAssets.gridIcon,scale: 2,width: 20.w,height: 20.h,color: primaryColor,),

            ],
          ),
        ),
        body: Consumer<ChatSocketProvider>(builder: (context,chatProvider,child){
          return Column(
            children: [

              chatProvider.isLoading==true? Column(
                children: List.generate(5, (index) => const ListItemShimmer(height: 80)),
              ): chatProvider.chatHistoryResponse == null || chatProvider.chatHistoryResponse!.chat.isEmpty
                  ? Expanded(
                      flex: 9,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 64.sp,
                              color: textPrimaryColor.withOpacity(0.3),
                            ),
                            16.height,
                            MyText(
                              text: 'No messages yet',
                              size: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: textPrimaryColor.withOpacity(0.6),
                            ),
                            8.height,
                            MyText(
                              text: 'Start the conversation by sending a message',
                              size: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: textPrimaryColor.withOpacity(0.5),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Expanded(
                  flex: 9,
                  child: SymmetricPadding(
                    child: ListView.builder(
                        itemCount: chatProvider.chatHistoryResponse!.chat.length,
                        scrollDirection: Axis.vertical,
                        controller: chatProvider.scrollController,
                        reverse: true, // Newest messages at bottom
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context,index){
                          // Sort messages newest first for proper chat flow
                          var sortedMessages = List<ChatMessage>.from(chatProvider.chatHistoryResponse!.chat)
                            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
                          var messageData=sortedMessages[index];
                          bool isSender=messageData.senderId==widget.senderId;
                          
                          // Check if message has attachment
                          if (messageData.attachment == true) {
                            return isSender == false
                                ? Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 40.h,
                                          width: 40.w,
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: roundProfileColor
                                          ),
                                          child: Center(
                                            child: MyText(text: firstTwoLetters(widget.receiverName),color: whiteColor,size: 12.sp,fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        5.width,
                                        ChatAttachmentCard(
                                          message: messageData,
                                          isSender: false,
                                          cachedOrders: _cachedOrders,
                                          cachedSellerOrders: _cachedSellerOrders,
                                        ),
                                      ],
                                    ),
                                  )
                                : Align(
                                    alignment: Alignment.centerRight,
                                    child: ChatAttachmentCard(
                                      message: messageData,
                                      isSender: true,
                                      cachedOrders: _cachedOrders,
                                      cachedSellerOrders: _cachedSellerOrders,
                                    ),
                                  );
                          }
                          
                          return isSender==false?
                          Align(
                            alignment: Alignment.centerLeft,

                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 40.h,
                                  width: 40.w,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: roundProfileColor
                                  ),
                                  child: Center(
                                    child: MyText(text: firstTwoLetters(widget.receiverName),color: whiteColor,size: 12.sp,fontWeight: FontWeight.w600),
                                  ),
                                ),
                                5.width,
                               messageData.contentType.isEmpty? Flexible(
                                  child: GestureDetector(
                                    onLongPress: (){
                                      context.showConfirmationDialog(title: AppLocalizations.of(context)!.areyousuretodelete,onYes: (){
                                        chatProvider.deleteMessage(messageData.id, widget.receiverId, widget.senderId);
                                        Navigator.pop(context);
                                      },onNo: (){});

                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(vertical: 5.h),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5.sp),
                                          color: whiteColor,
                                          border: Border.all(color: primaryColor,width: 1)
                                      ),
                                      child: Padding(
                                        padding:EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
                                        child: MyText(
                                          text: messageData.message,
                                          color: blackColor,
                                          fontWeight: FontWeight.w500,
                                          size: 11.sp,
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                    ),
                                  ),
                                ):Padding(
                                 padding: const EdgeInsets.only(top: 8.0),
                                 child: GestureDetector(
                                     onLongPress: (){
                                       context.showConfirmationDialog(title: AppLocalizations.of(context)!.areyousuretodelete,onYes: (){
                                         chatProvider.deleteMessage(messageData.id, widget.receiverId, widget.senderId);
                                         Navigator.pop(context);
                                       },onNo: (){});

                                     },
                                     onTap: (){
                                       Navigator.push(context, MaterialPageRoute(builder: (context)=>Scaffold(
                                         body: InteractiveViewer(
                                           minScale: 1,
                                           maxScale: 10,
                                           child: MyCachedNetworkImage(
                                               height: double.infinity,
                                               width: double.infinity,
                                               fit: BoxFit.contain,
                                               imageUrl: "${ApiEndpoints.productUrl}/${messageData.contentURL}"),
                                         ),
                                       )));
                                     },
                                     child: MyCachedNetworkImage(imageUrl: "${ApiEndpoints.productUrl}/${messageData.contentURL}")),
                               ),
                              ],
                            ),
                          ) :
                          Align(
                            alignment: Alignment.centerRight,
                            child:messageData.contentType.isEmpty? GestureDetector(
                              onLongPress: (){
                                context.showConfirmationDialog(title: AppLocalizations.of(context)!.areyousuretodelete,onYes: (){
                                  chatProvider.deleteMessage(messageData.id, widget.receiverId, widget.senderId);
                                  Navigator.pop(context);
                                },onNo: (){});

                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 5.h),

                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.sp),
                                    color: whiteColor,
                                    border: Border.all(color: const Color(0xffD5FF00),width: 1)

                                ),
                                child: Padding(
                                  padding:EdgeInsets.symmetric(horizontal: 10.w,vertical: 15.h),
                                  child: MyText(
                                    text: messageData.message,
                                    color: blackColor,
                                    fontWeight: FontWeight.w500,
                                    size: 11.sp,
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ),
                            ):Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: GestureDetector(
                                  onLongPress: (){
                                    context.showConfirmationDialog(title: AppLocalizations.of(context)!.areyousuretodelete,onYes: (){
                                      chatProvider.deleteMessage(messageData.id, widget.receiverId, widget.senderId);
                                      Navigator.pop(context);
                                    },onNo: (){});

                                  },
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Scaffold(
                                      body: InteractiveViewer(
                                        minScale: 1,
                                        maxScale: 10,
                                        child: MyCachedNetworkImage(
                                            height: double.infinity,
                                            width: double.infinity,
                                            fit: BoxFit.contain,
                                            imageUrl: "${ApiEndpoints.productUrl}/${messageData.contentURL}"),
                                      ),
                                    )));
                                  },
                                  child: MyCachedNetworkImage(imageUrl: "${ApiEndpoints.productUrl}/${messageData.contentURL}")),
                            ),
                          );
                        }),
                  )),
              const Spacer(),
              Consumer<SellerChatAddDocProvider>(builder: (context,provider,child){
                return Container(
                  // height: 75.h,
                  width: double.infinity,
                  color: whiteColor,
                  child: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 12.w,vertical: 15.h),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 20.h,
                      children: [
                       provider.image!=null? Container(height: 100,width: 100,decoration: BoxDecoration(
                         image: DecorationImage(image: FileImage(File(provider.image!.path)))
                       ),):const SizedBox(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Hide plus button for support chat
                            if (!isSupportChat) ...[
                              provider.isOpenDoc==false?
                              GestureDetector(
                                onTap: (){
                                  provider.toggle();
                                },
                                child: Container(
                                  height: 42.h,
                                  width: 58.w,
                                  decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(10.r),
                                      image: const DecorationImage(image: AssetImage(AppAssets.addIcon),scale: 3)
                                  ),
                                ),
                              ):
                              GestureDetector(
                                onTap: (){
                                  provider.toggle();
                                },
                                child: Image.asset(AppAssets.cancelIcon,scale: 1.3,),
                              ),
                              7.width,
                              
                            ],
                            // Hide text field and send button when bottom sheet is open
                            if (!provider.isOpenDoc) ...[
                              Flexible(
                                  child: TextFormField(
                                    controller: chatProvider.messageController,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10.sp,
                                        color: const Color(0xff545454)
                                    ),
                                    decoration: InputDecoration(
                                      hintText: AppLocalizations.of(context)!.typeyourmessage,
                                      //suffixIcon: Image.asset(AppAssets.emojiIcon,scale: 2,),
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.w500,color: const Color(0xff545454)
                                    ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12.r),
                                        borderSide: const BorderSide(
                                          color: primaryColor,

                                        ),
                                      ),
                                      enabledBorder:OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12.r),
                                        borderSide: const BorderSide(
                                          color: primaryColor,

                                        ),
                                      ) ,
                                      focusedBorder:OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12.r),
                                        borderSide: const BorderSide(
                                          color: primaryColor,
                                        ),
                                      ),
                                    ),
                                  )),
                              7.width,
                              GestureDetector(
                                onTap: (){
                                  if(mediaProvider.image==null){
                                     chatProvider.sendMessage(widget.receiverId, widget.senderId);

                                  }else{
                                    chatProvider.sendMedia(widget.receiverId, widget.senderId, context);

                                  }

                                },
                                child: Container(
                                  height: 42.h,
                                  width: 58.w,
                                  decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(10.r),
                                      image: const DecorationImage(image: AssetImage(AppAssets.sendIcon),scale: 3)
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),

                        // Hide media options for support chat
                        (!isSupportChat && provider.isOpenDoc)
                        ? Column(
                          children: [
                            // Cancel button at the top
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: (){
                                  provider.toggle();
                                  // Clear any selected image when canceling
                                  provider.reset();
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 10.h),
                                  child: Image.asset(AppAssets.cancelIcon, scale: 1.3),
                                ),
                              ),
                            ),
                            // Bottom sheet options
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    provider.pickImage(ImageSource.camera);
                                  },
                                  child: Column(
                                    spacing: 10.h,
                                    children: [
                                      Image.asset(AppAssets.cameraImg,scale: 3,),
                                      MyText(text: AppLocalizations.of(context)!.camera,size: 10.sp,fontWeight: FontWeight.w500,color: const Color(0xff545454),)
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    provider.pickImage(ImageSource.gallery);
                                  },
                                  child: Column(
                                    spacing: 10.h,
                                    children: [
                                      Image.asset(AppAssets.photosImg,scale: 3,),
                                      MyText(text: AppLocalizations.of(context)!.photos,size: 10.sp,fontWeight: FontWeight.w500,color: const Color(0xff545454),)
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    provider.toggle(); // Close bottom sheet
                                    _showProductSelectionModal(context);
                                  },
                                  child: Column(
                                    spacing: 10.h,
                                    children: [
                                      Image.asset(AppAssets.productChatImg, scale: 3),
                                      MyText(
                                        text: AppLocalizations.of(context)!.products,
                                        size: 10.sp,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xff545454),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    provider.toggle(); // Close bottom sheet
                                    _showOrderSelectionModal(context);
                                  },
                                  child: Column(
                                    spacing: 10.h,
                                    children: [
                                      Image.asset(AppAssets.ordersChatImg, scale: 3),
                                      MyText(
                                        text: AppLocalizations.of(context)!.orders,
                                        size: 10.sp,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xff545454),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                        : const SizedBox()
                      ],
                    ),
                  ),
                );
              })
            ],
          );
        }),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/models/messages/ChatHistoryModel.dart';
import 'package:sugudeni/providers/chatSocketProvider/chat-socket-provider.dart';
import 'package:sugudeni/providers/customer-chat-add-doc-provider.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/cached-network-image.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/utils/sharePreference/save-user-token.dart';

import '../../../l10n/app_localizations.dart';
import '../chat/select-order-modal.dart';
import '../chat/select-product-modal.dart';
import '../chat/chat-attachment-card.dart';
import '../../../models/orders/GetAllOrdersCutomerModel.dart';
import '../../../repositories/orders/customer-order-repository.dart';

class CustomerSupportChatView extends StatefulWidget {
  const CustomerSupportChatView({super.key});

  @override
  State<CustomerSupportChatView> createState() => _CustomerSupportChatViewState();
}

class _CustomerSupportChatViewState extends State<CustomerSupportChatView> {
  // Admin user ID for support chat
  static const String adminUserId = '67e26686ea078c3a5fdc0698';

  String? currentUserId;
  bool _isInitialized = false;
  GetCustomerAllOrderResponseModel? _cachedOrders;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    if (!mounted) return;

    try {
      currentUserId = await getUserId();
      customPrint('Support Chat - Current User ID: $currentUserId');
      customPrint('Support Chat - Admin User ID: $adminUserId');

      if (currentUserId != null && currentUserId!.isNotEmpty) {
        final chatProvider = context.read<ChatSocketProvider>();

        // Connect to socket if not already connected
        chatProvider.connectSocketInInitial(context);

        // Get chat history between current user and admin (only once)
        if (chatProvider.chatHistoryResponse == null) {
          await chatProvider.getChatHistory(context, adminUserId, currentUserId!);
        }

        // Connect socket for this conversation
        chatProvider.connectSocket(adminUserId, currentUserId!, context);
        
        // Pre-load orders data to prevent reloads
        _loadOrdersData();

        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      customPrint('Error initializing support chat: $e');
    }
  }

  @override
  void dispose() {
    // Don't disconnect socket here as it might be used elsewhere
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Support Chat'),
          backgroundColor: primaryColor,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }


    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 70.h,
        flexibleSpace: Container(
          color: whiteColor,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios),
            ),
            const Spacer(),
            MyText(
              text: "Support Chat",
              size: 16.sp,
              fontWeight: FontWeight.w600,
            ),
            const Spacer(),
            Container(
              width: 40.w,
              height: 40.h,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: roundProfileColor,
              ),
              child: Center(
                child: MyText(
                  text: "AD",
                  color: whiteColor,
                  size: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Consumer<ChatSocketProvider>(
        builder: (context, chatProvider, child) {
          return Column(
            children: [
              // Messages List
              Expanded(
                child: chatProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildMessagesList(chatProvider),
              ),

              // Message Input
              // const Spacer(),
              Consumer<SellerChatAddDocProvider>(builder: (context, provider, child) {
                return _buildMessageInput(chatProvider, provider);
              }),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120.w,
            height: 120.h,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.support_agent,
              size: 64.sp,
              color: textPrimaryColor.withOpacity(0.3),
            ),
          ),
          24.height,
          MyText(
            text: 'Welcome to Support Chat',
            size: 18.sp,
            fontWeight: FontWeight.w600,
            color: textPrimaryColor,
          ),
          12.height,
          MyText(
            text: 'How can we help you today?',
            size: 14.sp,
            fontWeight: FontWeight.w400,
            color: textPrimaryColor.withOpacity(0.6),
            textAlignment: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList(ChatSocketProvider chatProvider) {
    if (chatProvider.chatHistoryResponse == null || chatProvider.chatHistoryResponse!.chat.isEmpty) {
      return _buildEmptyState();
    }

    // Sort messages by creation date (newest first for proper chat flow)
    var sortedMessages = List<ChatMessage>.from(chatProvider.chatHistoryResponse!.chat)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return SymmetricPadding(
      child: ListView.builder(
        controller: chatProvider.scrollController,
        itemCount: sortedMessages.length,
        scrollDirection: Axis.vertical,
        reverse: true, // Newest messages at bottom
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          var messageData = sortedMessages[index];
          bool isSender = messageData.senderId == currentUserId;

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
                          color: roundProfileColor,
                        ),
                        child: Center(
                          child: MyText(
                            text: "AD",
                            color: whiteColor,
                            size: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      5.width,
                      messageData.attachment == true
                          ? ChatAttachmentCard(
                              message: messageData,
                              isSender: false,
                              cachedOrders: _cachedOrders,
                            )
                          : messageData.contentType.isEmpty
                              ? Flexible(
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 5.h),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.sp),
                                      color: whiteColor,
                                      border: Border.all(color: primaryColor, width: 1),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                                      child: MyText(
                                        text: messageData.message,
                                        color: blackColor,
                                        fontWeight: FontWeight.w500,
                                        size: 11.sp,
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => _buildImageViewer("${ApiEndpoints.productUrl}/${messageData.contentURL}"),
                                        ),
                                      );
                                    },
                                    child: MyCachedNetworkImage(
                                      imageUrl: "${ApiEndpoints.productUrl}/${messageData.contentURL}",
                                      height: 200.h,
                                      width: 200.w,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                    ],
                  ),
                )
              : Align(
                  alignment: Alignment.centerRight,
                  child: messageData.attachment == true
                      ? ChatAttachmentCard(
                          message: messageData,
                          isSender: true,
                          cachedOrders: _cachedOrders,
                        )
                      : messageData.contentType.isEmpty
                          ? Container(
                              margin: EdgeInsets.symmetric(vertical: 5.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.sp),
                                color: whiteColor,
                                border: Border.all(color: const Color(0xffD5FF00), width: 1),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
                                child: MyText(
                                  text: messageData.message,
                                  color: blackColor,
                                  fontWeight: FontWeight.w500,
                                  size: 11.sp,
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => _buildImageViewer("${ApiEndpoints.productUrl}/${messageData.contentURL}"),
                                    ),
                                  );
                                },
                                child: MyCachedNetworkImage(
                                  imageUrl: "${ApiEndpoints.productUrl}/${messageData.contentURL}",
                                  height: 200.h,
                                  width: 200.w,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                );
        },
      ),
    );
  }


  Widget _buildMessageInput(ChatSocketProvider chatProvider, SellerChatAddDocProvider provider) {
    return Container(
      width: double.infinity,
      color: whiteColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20.h,
          children: [
            provider.image != null
                ? Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: FileImage(provider.image!)),
                    ),
                  )
                : const SizedBox(),
            // Show text input when bottom sheet is closed
            provider.isOpenDoc == false
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          provider.toggle();
                        },
                        child: Container(
                          height: 42.h,
                          width: 58.w,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: whiteColor,
                            size: 20,
                          ),
                        ),
                      ),
                      7.width,
                      Flexible(
                        child: TextFormField(
                          controller: chatProvider.messageController,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 10.sp,
                            color: const Color(0xff545454),
                          ),
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.typeyourmessage,
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 10.sp,
                              color: const Color(0xff545454),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: const BorderSide(
                                color: primaryColor,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: const BorderSide(
                                color: primaryColor,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: const BorderSide(
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      7.width,
                      GestureDetector(
                        onTap: () {
                          if (provider.image == null) {
                            if (chatProvider.messageController.text.trim().isNotEmpty) {
                              chatProvider.sendMessage(adminUserId, currentUserId!);
                              chatProvider.messageController.clear();
                            }
                          } else {
                            chatProvider.sendMedia(adminUserId, currentUserId!, context);
                            // Clear the image after sending
                            provider.reset();
                          }
                        },
                        child: Container(
                          height: 42.h,
                          width: 58.w,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: const Icon(
                            Icons.send,
                            color: whiteColor,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  )
                : // Show bottom sheet with cancel button when opened
                Column(
                  children: [
                    // Cancel button at the top
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
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
                          onTap: () {
                            provider.pickImage(ImageSource.camera);
                          },
                          child: Column(
                            spacing: 10.h,
                            children: [
                              Image.asset(AppAssets.cameraImg, scale: 3),
                              MyText(
                                text: AppLocalizations.of(context)!.camera,
                                size: 10.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff545454),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            provider.pickImage(ImageSource.gallery);
                          },
                          child: Column(
                            spacing: 10.h,
                            children: [
                              Image.asset(AppAssets.photosImg, scale: 3),
                              MyText(
                                text: AppLocalizations.of(context)!.photos,
                                size: 10.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff545454),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
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
                          onTap: () {
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
                ),
          ],
        ),
      ),
    );
  }

  void _showOrderSelectionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SelectOrderModal(
        onOrderSelected: (order) {
          final chatProvider = context.read<ChatSocketProvider>();
          // Ensure message controller is clear for attachment
          chatProvider.messageController.clear();
          
          // Create attachment data
          Map<String, dynamic> attachmentData = {
            'attachmentType': 'order',
            'orderid': order.id,
          };
          
          customPrint('Sending order attachment - orderId: ${order.id}');
          
          chatProvider.sendMessage(
            adminUserId,
            currentUserId!,
            attachment: true,
            attachmentData: attachmentData,
          );
        },
      ),
    );
  }

  Future<void> _loadOrdersData() async {
    try {
      _cachedOrders = await CustomerOrderRepository.allCustomersOrders(context);
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      customPrint('Error loading orders: $e');
    }
  }

  void _showProductSelectionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SelectProductModal(
        onProductSelected: (orderId, productId) {
          final chatProvider = context.read<ChatSocketProvider>();
          // Ensure message controller is clear for attachment
          chatProvider.messageController.clear();
          
          // Create attachment data
          Map<String, dynamic> attachmentData = {
            'attachmentType': 'product',
            'orderid': orderId,
            'productid': productId,
          };
          
          customPrint('Sending product attachment - orderId: $orderId, productId: $productId');
          
          chatProvider.sendMessage(
            adminUserId,
            currentUserId!,
            attachment: true,
            attachmentData: attachmentData,
          );
        },
      ),
    );
  }

  Widget _buildImageViewer(String imageUrl) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Image',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(
        //       Icons.download,
        //       color: Colors.white,
        //     ),
        //     onPressed: () {
        //       // TODO: Implement download functionality
        //     },
        //   ),
        //   IconButton(
        //     icon: const Icon(
        //       Icons.share,
        //       color: Colors.white,
        //     ),
        //     onPressed: () {
        //       // TODO: Implement share functionality
        //     },
        //   ),
        // ],
      ),
      body: Container(
        color: Colors.black,
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: Center(
            child: MyCachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.contain,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
      ),
    );
  }

}

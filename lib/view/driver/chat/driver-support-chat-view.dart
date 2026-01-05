import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/models/messages/ChatHistoryModel.dart';
import 'package:sugudeni/providers/chatSocketProvider/chat-socket-provider.dart';
import 'package:sugudeni/utils/customWidgets/cached-network-image.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/utils/sharePreference/save-user-token.dart';

import '../../../utils/constants/colors.dart';

class DriverSupportChatView extends StatefulWidget {
  const DriverSupportChatView({super.key});

  @override
  State<DriverSupportChatView> createState() => _DriverSupportChatViewState();
}

class _DriverSupportChatViewState extends State<DriverSupportChatView> {
  // Fixed support ID
  static const String supportId = '67e26686ea078c3a5fdc0698';
  String? driverId;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    driverId = await getUserId();
    if (driverId != null && mounted) {
      final chatProvider = context.read<ChatSocketProvider>();
      // Initialize socket connection first
      chatProvider.connectSocketInInitial(context);
      // Wait a bit for socket to connect
      await Future.delayed(const Duration(milliseconds: 500));
      // Then connect to the specific chat
      chatProvider.connectSocket(supportId, driverId!, context);
      // Load chat history
      chatProvider.getChatHistory(context, supportId, driverId!);
      // Mark as unread
      chatProvider.markAsUnread(driverId!, supportId, context);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        // Handle back navigation if needed
      },
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 80.h,
          flexibleSpace: Container(
            color: whiteColor,
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back arrow
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios, color: textPrimaryColor),
              ),
              // Title and subtitle
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      text: 'Chat Bot',
                      size: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: textPrimaryColor,
                    ),
                    2.height,
                    MyText(
                      text: 'Customer Care Service',
                      size: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: textSecondaryColor,
                    ),
                  ],
                ),
              ),
              // Shopping bag icon
              Container(
                width: 40.w,
                height: 40.w,
                margin: EdgeInsets.only(right: 10.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: whiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: blackColor.withAlpha(getAlpha(0.1)),
                      spreadRadius: 1,
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.shopping_bag,
                    color: primaryColor,
                    size: 20.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Consumer<ChatSocketProvider>(
          builder: (context, chatProvider, child) {
            if (driverId == null) {
              return Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: primaryColor),
                          20.height,
                          MyText(
                            text: 'Initializing chat...',
                            size: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: textSecondaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Input bar always visible
                  _buildInputBar(chatProvider),
                ],
              );
            }

            return Column(
              children: [
                // Chat messages area
                Expanded(
                  child: chatProvider.isLoading == true
                      ? _buildLoadingState()
                      : chatProvider.chatHistoryResponse == null ||
                              chatProvider.chatHistoryResponse!.chat.isEmpty
                          ? _buildWelcomeMessage()
                          : SymmetricPadding(
                              child: ListView.builder(
                                padding: EdgeInsets.only(
                                  top: 10.h,
                                  bottom: 20.h, // Space from bottom
                                ),
                                itemCount: chatProvider.chatHistoryResponse!.chat.length,
                                scrollDirection: Axis.vertical,
                                controller: chatProvider.scrollController,
                                itemBuilder: (context, index) {
                                  var sortedMessages = chatProvider.chatHistoryResponse!.chat
                                    ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
                                  var messageData = sortedMessages[index];
                                  bool isSender = messageData.senderId == driverId;
                                  return _buildMessageBubble(messageData, isSender);
                                },
                              ),
                            ),
                ),
                // Input bar - always visible outside loading area
                _buildInputBar(chatProvider),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Loading indicator with text
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: primaryColor,
                  strokeWidth: 3,
                ),
                20.height,
                MyText(
                  text: 'Loading messages...',
                  size: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: textSecondaryColor,
                ),
              ],
            ),
          ),
          40.height,
          // Shimmer loading for message bubbles
          ...List.generate(3, (index) {
            // Alternate between left and right side messages
            bool isRight = index % 2 == 0;
            return Container(
              margin: EdgeInsets.only(bottom: 15.h),
              child: Row(
                mainAxisAlignment: isRight ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  if (isRight) ...[
                    Flexible(
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 20.h,
                          ),
                        ),
                      ),
                    ),
                    10.width,
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 22.w,
                        height: 22.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                  ] else ...[
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                        child: Container(
                          width: 150.w,
                          height: 20.h,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildWelcomeMessage() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        children: [
          // Welcome message from support
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.only(bottom: 15.h),
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: primaryColor.withOpacity(0.15), width: 1),
              ),
              child: MyText(
                text: 'Hello! Welcome to Customer Care Service. We will be happy to help you. Please, provide us more details about your issue before we can start.',
                size: 14.sp,
                fontWeight: FontWeight.w400,
                color: textPrimaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage messageData, bool isSender) {
    bool hasImage = messageData.contentType.isNotEmpty && messageData.contentURL.isNotEmpty;
    
    if (isSender) {
      // Driver's message (right side, orange background with checkmark)
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: EdgeInsets.only(bottom: 12.h, left: 50.w, top: 5.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: hasImage
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Scaffold(
                                body: InteractiveViewer(
                                  minScale: 1,
                                  maxScale: 10,
                                  child: MyCachedNetworkImage(
                                    height: double.infinity,
                                    width: double.infinity,
                                    fit: BoxFit.contain,
                                    imageUrl: "${ApiEndpoints.productUrl}/${messageData.contentURL}",
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.r),
                          child: MyCachedNetworkImage(
                            imageUrl: "${ApiEndpoints.productUrl}/${messageData.contentURL}",
                            width: 200.w,
                            height: 200.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: MyText(
                          text: messageData.message,
                          color: whiteColor,
                          fontWeight: FontWeight.w500,
                          size: 14.sp,
                          overflow: TextOverflow.clip,
                        ),
                      ),
              ),
              10.width,
              // Checkmark icon in orange circle
              Container(
                width: 22.w,
                height: 22.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor,
                ),
                child: Icon(
                  Icons.check,
                  color: whiteColor,
                  size: 16.sp,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // Support's message (left side, white background)
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.only(bottom: 12.h, right: 50.w, top: 5.h),
          child: hasImage
              ? GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
                          body: InteractiveViewer(
                            minScale: 1,
                            maxScale: 10,
                            child: MyCachedNetworkImage(
                              height: double.infinity,
                              width: double.infinity,
                              fit: BoxFit.contain,
                              imageUrl: "${ApiEndpoints.productUrl}/${messageData.contentURL}",
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: MyCachedNetworkImage(
                      imageUrl: "${ApiEndpoints.productUrl}/${messageData.contentURL}",
                      width: 200.w,
                      height: 200.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: primaryColor.withOpacity(0.15), width: 1),
                  ),
                  child: MyText(
                    text: messageData.message,
                    color: textPrimaryColor,
                    fontWeight: FontWeight.w500,
                    size: 14.sp,
                    overflow: TextOverflow.clip,
                  ),
                ),
        ),
      );
    }
  }

  Widget _buildInputBar(ChatSocketProvider chatProvider) {
    return Container(
      width: double.infinity,
      color: whiteColor,
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
      child: Row(
        children: [
          // Text input field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: primaryColor.withOpacity(0.3), width: 1),
              ),
              child: TextFormField(
                controller: chatProvider.messageController,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13.sp,
                  color: textPrimaryColor,
                ),
                decoration: InputDecoration(
                  hintText: 'Type your message',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 13.sp,
                    color: textSecondaryColor,
                  ),
                  suffixIcon: Icon(
                    Icons.sentiment_satisfied_alt,
                    color: textSecondaryColor,
                    size: 20.sp,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
                ),
              ),
            ),
          ),
          10.width,
          // Send button
          GestureDetector(
            onTap: () {
              if (driverId != null) {
                chatProvider.sendMessage(supportId, driverId!);
              }
            },
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.send,
                color: whiteColor,
                size: 20.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


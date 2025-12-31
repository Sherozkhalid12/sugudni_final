import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/models/messages/ChatHistoryModel.dart';
import 'package:sugudeni/providers/chatSocketProvider/chat-socket-provider.dart';
import 'package:sugudeni/providers/customer-chat-add-doc-provider.dart';
import 'package:sugudeni/repositories/messages/seller-messages-repository.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/customWidgets/cached-network-image.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/dialog-extension.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/utils/customWidgets/shimmer-widgets.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:sugudeni/utils/sharePreference/save-user-token.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/constants/colors.dart';

class SellerMessageDetailView extends StatefulWidget {
  final String receiverName;
  final String receiverId;
  final String senderId;
  const SellerMessageDetailView({super.key, required this.receiverName, required this.receiverId, required this.senderId});

  @override
  State<SellerMessageDetailView> createState() => _SellerMessageDetailViewState();
}

class _SellerMessageDetailViewState extends State<SellerMessageDetailView> {
  @override
  void initState() {
    super.initState();

    context.read<ChatSocketProvider>().connectSocket(widget.receiverId, widget.senderId,context);
  //  context.read<ChatSocketProvider>().aboutMessages(widget.receiverId, widget.senderId);
    context.read<ChatSocketProvider>().getChatHistory(context, widget.receiverId, widget.senderId);
    context.read<ChatSocketProvider>().markAsUnread(widget.senderId, widget.receiverId, context);

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
              ): Expanded(
                  flex: 9,
                  child: SymmetricPadding(
                    child: ListView.builder(
                        itemCount:chatProvider.chatHistoryResponse!.chat.length,
                        scrollDirection: Axis.vertical,
                        controller: chatProvider.scrollController,
                        itemBuilder: (context,index){
                          var sortedMessages = chatProvider.chatHistoryResponse!.chat
                            ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
                          var messageData=sortedMessages[index];
                          bool isSender=messageData.senderId==widget.senderId;
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
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10.sp,
                                        color: const Color(0xff545454)
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
                            provider.isOpenDoc==false?
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
                            ):const SizedBox(),
                          ],
                        ),

                        provider.isOpenDoc?
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                            Column(
                              spacing: 10.h,
                              children: [
                                Image.asset(AppAssets.productChatImg,scale: 3,),
                                MyText(text: AppLocalizations.of(context)!.products,size: 10.sp,fontWeight: FontWeight.w500,color: const Color(0xff545454),)
                              ],
                            ),
                            Column(
                              spacing: 10.h,
                              children: [
                                Image.asset(AppAssets.ordersChatImg,scale: 3,),
                                MyText(text: AppLocalizations.of(context)!.orders,size: 10.sp,fontWeight: FontWeight.w500,color: const Color(0xff545454),)
                              ],
                            )

                            ,                    ],
                        ):const SizedBox()
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

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/providers/customer-chat-add-doc-provider.dart';
import 'package:sugudeni/providers/chatSocketProvider/chat-socket-provider.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/utils/routes/routes-name.dart';
import 'package:sugudeni/utils/sharePreference/save-user-token.dart';
import 'package:sugudeni/view/customer/chat/select-order-modal.dart';
import 'package:sugudeni/view/customer/chat/select-product-modal.dart';
import 'package:sugudeni/view/customer/chat/chat-attachment-preview.dart';
import 'package:sugudeni/repositories/orders/customer-order-repository.dart';
import 'package:sugudeni/models/orders/GetAllOrdersCutomerModel.dart';

import '../../../utils/constants/colors.dart';

class ChatWithOwnerView extends StatefulWidget {
  const ChatWithOwnerView({super.key});

  @override
  State<ChatWithOwnerView> createState() => _ChatWithOwnerViewState();
}

class _ChatWithOwnerViewState extends State<ChatWithOwnerView> {
  GetCustomerAllOrderResponseModel? _cachedOrders;
  bool _ordersLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadOrdersData();
  }

  Future<void> _loadOrdersData() async {
    try {
      _cachedOrders = await CustomerOrderRepository.allCustomersOrders(context);
      if (mounted) {
        setState(() {
          _ordersLoaded = true;
        });
      }
    } catch (e) {
      customPrint('Error loading orders: $e');
    }
  }

  void _showOrderSelectionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => SelectOrderModal(
        onOrderSelected: (order) {
          Navigator.of(modalContext).pop();
          final chatProvider = context.read<ChatSocketProvider>();
          
          Map<String, dynamic> attachmentData = {
            'attachmentType': 'order',
            'orderid': order.toJson(),
            'productid': '',
          };
          
          customPrint('Order selected - orderId: ${order.id}');
          chatProvider.setPendingAttachment(attachmentData);
          
          final provider = context.read<SellerChatAddDocProvider>();
          if (provider.isOpenDoc) {
            provider.toggle();
          }
          provider.reset();
        },
      ),
    );
  }

  void _showProductSelectionModal(BuildContext context) {
    if (!_ordersLoaded || _cachedOrders == null) {
      // Load orders if not loaded
      _loadOrdersData().then((_) {
        if (mounted && _cachedOrders != null) {
          _showProductSelectionModal(context);
        }
      });
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => SelectProductModal(
        onProductSelected: (orderId, productId, product, order) {
          Navigator.of(modalContext).pop();
          final chatProvider = context.read<ChatSocketProvider>();
          
          Map<String, dynamic> attachmentData = {
            'attachmentType': 'product',
            'orderid': order.toJson(),
            'productid': {
              '_id': product.id,
              'title': product.title,
              'imgCover': product.imgCover,
              'price': product.price,
              'description': product.description ?? '',
              'weight': product.weight,
              'color': product.color,
              'size': product.size,
              'images': product.images,
              'quantity': product.quantity,
              'sold': product.sold,
              'status': product.status,
              'category': product.category != null ? product.category!.toJson() : null,
              'sellerid': product.sellerId.toJson(),
              'sellerId': product.sellerId.toJson(),
            },
          };
          
          customPrint('Product selected - orderId: $orderId, productId: $productId');
          chatProvider.setPendingAttachment(attachmentData);
          
          final provider = context.read<SellerChatAddDocProvider>();
          if (provider.isOpenDoc) {
            provider.toggle();
          }
          provider.reset();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String,dynamic>> messageList=[
      {
        'text':"Hi, I hope you are good",
        'isSender':false
      },
      {
        'text':"I have facing some issues.",
        'isSender':false
      },
      {
        'text':'Red chili is a vibrant spice known for its intense heat and rich flavor, making it a staple in cuisines worldwide. Packed with capsaicin, it not only enhances taste but also offers health benefits like improved metabolism and antioxidants. Red chili is a vibrant spice known for its intense heat and rich flavor, making it a staple in cuisines worldwide. Packed with capsaicin, it not only enhances taste but also offers health benefits like improved ',
        'isSender':true
      },
      {
        'text':"That's good to know.",
        'isSender':false
      },
      {
        'text':"Thank you so much for your help! I appreciate it.",
        'isSender':false
      },
      {
        'text':"You're very welcome!\nIf you have any more questions in the future or need assistance with anything else, feel free to reach out.",
        'isSender':true
      },
      {
        'text':'Happy shopping!',
        'isSender':true
      },
    ];
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
            IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: const Icon(Icons.arrow_back_ios)),
            const Spacer(),
            MyText(text: "AMY Online\nShopping Store",size: 16.sp,fontWeight: FontWeight.w600,),
            const Spacer(),
            Image.asset(AppAssets.shopHomePageIcon,scale: 2,width: 20.w,height: 20.h,color: primaryColor,),
            10.width,
            Image.asset(AppAssets.gridIcon,scale: 2,width: 20.w,height: 20.h,color: primaryColor,),

          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 9,
              child: SymmetricPadding(
                child: ListView.builder(
                    itemCount: messageList.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context,index){
                      var messageData=messageList[index];
                      bool isSender=messageData['isSender'];
                      return isSender==true?
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
                                child: MyText(text: "AMY",color: whiteColor,size: 12.sp,fontWeight: FontWeight.w600),
                              ),
                            ),
                            5.width,
                            Flexible(
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
                                    text: messageData['text'],
                                    color: blackColor,
                                    fontWeight: FontWeight.w500,
                                    size: 11.sp,
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ) :
                      Align(
                        alignment: Alignment.centerRight,
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
                              text: messageData['text'],
                              color: blackColor,
                              fontWeight: FontWeight.w500,
                              size: 11.sp,
                              overflow: TextOverflow.clip,
                            ),
                          ),
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
                child: Column(
                  spacing: 20.h,
                  children: [
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
                          child: Image.asset(AppAssets.cancelIcon,scale: 2.5,),
                        ),
                        7.width,
                        Flexible(
                            child: Consumer<ChatSocketProvider>(
                              builder: (context, chatProvider, child) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Show preview of pending attachment
                                    const ChatAttachmentPreview(),
                                    TextFormField(
                                      controller: chatProvider.messageController,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10.sp,
                                          color: const Color(0xff545454)
                                      ),
                                      decoration: InputDecoration(
                                        hintText: "Type your message",
                                        suffixIcon: Image.asset(AppAssets.emojiIcon,scale: 2,),
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
                                    ),
                                  ],
                                );
                              },
                            )),
                        7.width,
                        provider.isOpenDoc==false?
                        Consumer<ChatSocketProvider>(
                          builder: (context, chatProvider, child) {
                            return GestureDetector(
                              onTap: () async {
                                // Note: This view needs receiverId to be passed or stored
                                // For now, we'll get senderId and leave receiverId empty
                                // The actual implementation should get receiverId from route args or provider
                                final senderId = await getUserId();
                                
                                if (senderId != null) {
                                  // Get receiverId from provider's current conversation or route args
                                  // For now, using empty string - this needs to be fixed based on app flow
                                  final receiverId = chatProvider.currentReceiverId ?? '';
                                  
                                  if (receiverId.isNotEmpty && (chatProvider.hasPendingAttachment || chatProvider.messageController.text.trim().isNotEmpty)) {
                                    chatProvider.sendMessage(receiverId, senderId);
                                    chatProvider.messageController.clear();
                                  } else if (receiverId.isEmpty) {
                                    // Show error if receiverId is not available
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Receiver ID not available')),
                                    );
                                  }
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
                            );
                          },
                        ):const SizedBox(),
                      ],
                    ),

                    provider.isOpenDoc?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          spacing: 10.h,
                          children: [
                            Image.asset(AppAssets.cameraImg,scale: 3,),
                            MyText(text: "Camera",size: 10.sp,fontWeight: FontWeight.w500,color: const Color(0xff545454),)
                          ],
                        ),
                        Column(
                          spacing: 10.h,
                          children: [
                            Image.asset(AppAssets.photosImg,scale: 3,),
                            MyText(text: "Photos",size: 10.sp,fontWeight: FontWeight.w500,color: const Color(0xff545454),)
                          ],
                        ),
                      ],
                    ):const SizedBox()
                  ],
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}

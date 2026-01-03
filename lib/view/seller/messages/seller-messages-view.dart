import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/api/network/api-client.dart';
import 'package:sugudeni/providers/chatSocketProvider/chat-socket-provider.dart';
import 'package:sugudeni/providers/messages/seller-messages-provider.dart';
import 'package:sugudeni/repositories/messages/seller-messages-repository.dart';
import 'package:sugudeni/models/messages/SellerThreadsResponse.dart';
import 'package:sugudeni/repositories/user-repository.dart';
import 'package:sugudeni/utils/customWidgets/cached-network-image.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/user-profile-widget.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/utils/sharePreference/save-user-token.dart';
import 'package:sugudeni/utils/shimmer/shimmer-effects.dart';
import 'package:sugudeni/utils/customWidgets/shimmer-widgets.dart';
import 'package:sugudeni/utils/customWidgets/empty-state-widget.dart';
import 'package:sugudeni/utils/customWidgets/spinkit-loader.dart';
import 'package:sugudeni/view/seller/messages/seller-message-detailed-screen.dart';

import '../../../l10n/app_localizations.dart';
import '../../../providers/seller-scroll-tab-provider.dart';
import '../../../utils/constants/app-assets.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/customWidgets/tab-bar-widget.dart';
import '../../../utils/routes/routes-name.dart';
import '../products/seller-my-products-view.dart';

class SellerMessagesView extends StatefulWidget {
  const SellerMessagesView({super.key});

  @override
  State<SellerMessagesView> createState() => _SellerMessagesViewState();
}

class _SellerMessagesViewState extends State<SellerMessagesView> {
  @override
  void initState() {
    super.initState();

    context.read<ChatSocketProvider>().fetchThreads(context);
    context.read<ChatSocketProvider>().aboutThreads(context);

  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        //Provider.of<ChatSocketProvider>(context,listen: false).disconnectSocket();
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80.h,
          forceMaterialTransparency: true,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.messages,
                  style: GoogleFonts.roboto(
                      color: primaryColor,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w600)),
              RoundIconButton(onPressed: (){
                Navigator.pushNamed(context, RoutesNames.sellerSettingView);
              },iconUrl: AppAssets.settingIcon),
            ],
          ),

        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               FutureBuilder(
                   future:SellerMessagesRepository.getUnreadCount(context),
                   builder: (context,snapshot){
                     if(snapshot.connectionState==ConnectionState.waiting){
                       return const SizedBox();
                     }
                     final totalUnread = snapshot.data?.count ?? 0;
                     
                     return Consumer2<ChatSocketProvider, SellerMessagesProvider>(
                       builder: (context, chatProvider, messagesProvider, _) {
                         // Calculate unread counts dynamically from threads (only customer threads)
                         const adminId = '67e26686ea078c3a5fdc0698';
                         final threads = chatProvider.sellerThreads?.threads ?? [];
                         final customerThreads = threads.where((thread) {
                           // Check if thread involves admin
                           final participants = thread.participants.map((p) => p.userId).toList();
                           final hasAdmin = participants.contains(adminId);
                           
                           // Filter to only customer threads for unread count
                           // Exclude system threads AND admin threads
                           if (thread.threadType != null) {
                             return thread.threadType!.toLowerCase() != 'system' && !hasAdmin;
                           }
                           // If threadType is not available, check by admin ID
                           return !hasAdmin;
                         }).toList();
                         
                         // Deduplicate threads by ID to avoid counting the same thread multiple times
                         final seenIds = <String>{};
                         final deduplicatedThreads = customerThreads.where((thread) {
                           if (seenIds.contains(thread.id)) {
                             return false;
                           }
                           seenIds.add(thread.id);
                           return true;
                         }).toList();
                         
                         // Count conversations with unread messages (not total unread messages)
                         final conversationsWithUnread = deduplicatedThreads.where((thread) => thread.unreadCount > 0).length;
                         
                         // Use conversation count if available, otherwise use API count
                         final displayCount = deduplicatedThreads.isNotEmpty ? conversationsWithUnread : totalUnread;
                         
                         return Row(
                           children: [
                             SellerTabBarWidget(
                                 onPressed: () {
                                   messagesProvider.changeMessageTab(SellerMessagesTabs.customer);
                                 },
                                 width: 70.w,
                                 selected:
                                 messagesProvider.selectMessageTab == SellerMessagesTabs.customer,
                                 title: "${AppLocalizations.of(context)!.customer} ($displayCount)"),
                             40.width,
                             SellerTabBarWidget(
                                 onPressed: () {
                                   messagesProvider.changeMessageTab(SellerMessagesTabs.system);
                                 },
                                 width: 50.w,
                                 selected:
                                 messagesProvider.selectMessageTab == SellerMessagesTabs.system,
                                 title: AppLocalizations.of(context)!.system),
                           ],
                         );
                       }
                     );
                   }),


              ],
            ),
            Expanded(
              child: Consumer2<ChatSocketProvider, SellerMessagesProvider>(builder: (context, provider, messagesProvider, child){
                if (provider.isLoading) {
                  return FullScreenSpinKitLoader(
                    message: 'Loading messages...',
                  );
                }

                if (provider.errorMessage != null) {
                  return Center(
                    child: Text(provider.errorMessage!,
                        style: const TextStyle(color: Colors.red)),
                  );
                }

                // Check which tab is selected first
                final isCustomerTab = messagesProvider.selectMessageTab == SellerMessagesTabs.customer;
                const adminId = '67e26686ea078c3a5fdc0698';
              
                // If no threads at all, show appropriate empty state based on tab
                if (provider.sellerThreads == null ||
                    provider.sellerThreads!.threads.isEmpty) {
                  // If system tab and no threads, show "Start Chat" button
                  if (!isCustomerTab) {
                    return FutureBuilder(
                      future: getUserId(),
                      builder: (context, userIdSnapshot) {
                        final sellerId = userIdSnapshot.data ?? '';
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(40.sp),
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
                                    size: 60.sp,
                                    color: primaryColor,
                                  ),
                                ),
                                24.height,
                                MyText(
                                  text: 'No System Messages',
                                  size: 20.sp,
                                  fontWeight: FontWeight.w700,
                                  color: textPrimaryColor,
                                ),
                                12.height,
                                MyText(
                                  text: 'Start a conversation with our support team to get help with your account, products, or any questions you may have.',
                                  size: 13.sp,
                                  fontWeight: FontWeight.w400,
                                  color: textPrimaryColor.withOpacity(0.7),
                                  textAlignment: TextAlign.center,
                                ),
                                32.height,
                                ElevatedButton(
                                  onPressed: () async {
                                    final adminName = 'Support';
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SellerMessageDetailView(
                                          receiverId: adminId,
                                          receiverName: adminName,
                                          senderId: sellerId,
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 16.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    elevation: 2,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.chat_bubble_outline, color: whiteColor, size: 20.sp),
                                      12.width,
                                      MyText(
                                        text: 'Start Chat with Support',
                                        size: 15.sp,
                                        fontWeight: FontWeight.w600,
                                        color: whiteColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                  // If customer tab and no threads, show generic empty state
                  return EmptyStateWidget(
                    title: AppLocalizations.of(context)!.nochatfound,
                    description: 'You don\'t have any conversations yet. Messages from customers will appear here once they contact you.',
                    icon: Icons.chat_bubble_outline,
                  );
                }
              
              // Filter threads based on selected tab
              final allThreads = provider.sellerThreads!.threads;
              
              final filteredThreads = allThreads.where((thread) {
                // Check if this thread involves the admin
                final participants = thread.participants.map((p) => p.userId).toList();
                final hasAdmin = participants.contains(adminId);
                
                // If threadType is available in the API response, use it
                if (thread.threadType != null) {
                  if (isCustomerTab) {
                    // Customer tab: exclude system threads and admin threads
                    return thread.threadType!.toLowerCase() != 'system' && !hasAdmin;
                  } else {
                    // System tab: include system threads OR admin threads
                    return thread.threadType!.toLowerCase() == 'system' || hasAdmin;
                  }
                }
                // Fallback: If threadType is not available, check by admin ID
                if (isCustomerTab) {
                  return !hasAdmin; // Exclude admin threads from customer tab
                } else {
                  return hasAdmin; // Include admin threads in system tab
                }
              }).toList();
              
              // For system tab, if no threads found, check if admin thread exists in all threads
              if (!isCustomerTab && filteredThreads.isEmpty) {
                // Check if there's a thread with admin in all threads
                Thread? adminThread;
                try {
                  adminThread = allThreads.firstWhere(
                    (thread) {
                      final participants = thread.participants.map((p) => p.userId).toList();
                      return participants.contains(adminId);
                    },
                  );
                } catch (e) {
                  adminThread = null;
                }
                
                // If no admin thread exists, show "Start Chat" button
                if (adminThread == null) {
                  return FutureBuilder(
                    future: getUserId(),
                    builder: (context, userIdSnapshot) {
                      final sellerId = userIdSnapshot.data ?? '';
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(40.sp),
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
                                  size: 60.sp,
                                  color: primaryColor,
                                ),
                              ),
                              24.height,
                              MyText(
                                text: 'No System Messages',
                                size: 20.sp,
                                fontWeight: FontWeight.w700,
                                color: textPrimaryColor,
                              ),
                              12.height,
                              MyText(
                                text: 'Start a conversation with our support team to get help with your account, products, or any questions you may have.',
                                size: 13.sp,
                                fontWeight: FontWeight.w400,
                                color: textPrimaryColor.withOpacity(0.7),
                                textAlignment: TextAlign.center,
                              ),
                              32.height,
                              ElevatedButton(
                                onPressed: () async {
                                  // Navigate directly to chat with admin
                                  // The chat screen will handle creating the thread when first message is sent
                                  final adminName = 'Support';
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SellerMessageDetailView(
                                        receiverId: adminId,
                                        receiverName: adminName,
                                        senderId: sellerId,
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 16.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  elevation: 2,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.chat_bubble_outline, color: whiteColor, size: 20.sp),
                                    12.width,
                                    MyText(
                                      text: 'Start Chat with Support',
                                      size: 15.sp,
                                      fontWeight: FontWeight.w600,
                                      color: whiteColor,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  // Admin thread exists but wasn't in filtered threads - add it
                  filteredThreads.add(adminThread);
                }
              }
              
              if (filteredThreads.isEmpty) {
                return EmptyStateWidget(
                  title: isCustomerTab ? 'No Customer Messages' : 'No System Messages',
                  description: isCustomerTab 
                      ? 'You don\'t have any customer conversations yet.'
                      : 'You don\'t have any system messages yet.',
                  icon: Icons.chat_bubble_outline,
                );
              }
              
                return FutureBuilder(
                    future: getUserId(),
                    builder: (context,userIdGet){
                      String userId=userIdGet.data ??'';
                      return RefreshIndicator(
                        onRefresh: () => provider.fetchThreads(context),
                        child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: filteredThreads.length,
                            itemBuilder: (context,index){
                              final sortedThreads = List.from(filteredThreads);
                              sortedThreads.sort((a, b) => b.lastMessageTimestamp.compareTo(a.lastMessageTimestamp));

                              final data=sortedThreads[index];
                              String receiverId=data.participants.first.userId==userId ?data.participants.last.userId:data.participants.first.userId;
                              const adminId = '67e26686ea078c3a5fdc0698';
                              final isAdminChat = receiverId == adminId;
                              final displayName = isAdminChat ? 'Support' : null;
                              
                              return  FutureBuilder(
                                  future: isAdminChat ? null : UserRepository.getUserNameAndId(receiverId, context),
                                  builder: (context,snapshot){
                                    if(!isAdminChat && snapshot.connectionState==ConnectionState.waiting){
                                      return  ShimmerEffects().shimmerForChats();
                                    }
                                    // if(snapshot.data!.message=='success'){
                                    //   return  ShimmerEffects().shimmerForChats();
                                    // }
                                    var receiverData = isAdminChat ? null : snapshot.data;
                                    final nameToDisplay = displayName ?? (receiverData?.user.name ?? '');
                                    
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Material(

                                        elevation: 2,
                                        child: GestureDetector(
                                          onTap: ()async{
                                            String senderId=await getUserId();
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                                SellerMessageDetailView(receiverId: receiverId, receiverName: nameToDisplay, senderId: userId,)));
                                            //    Navigator.pushNamed(context, RoutesNames.sellerMessageDetailDetailView,arguments: receiverData!.user.name);
                                          },
                                          child: Container(
                                            // height: 67.h,
                                            color: whiteColor,
                                            child: Padding(
                                              padding:  EdgeInsets.symmetric(horizontal: 12.w,vertical: 10.h),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  isAdminChat || data.participants.last.profilePic.isEmpty?
                                                  UserNameProfileWidget(name: nameToDisplay): MyCachedNetworkImage(
                                                      height: 40.h,
                                                      width: 40.w,
                                                      radius: 140.r,
                                                      imageUrl: "${ApiEndpoints.productUrl}/${data.participants.last.profilePic}"),

                                                  10.width,
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        MyText(text: capitalizeFirstLetter(nameToDisplay),size: 14.sp,fontWeight: FontWeight.w700,),
                                                        // MyText(text: data.participants.last.userId,size: 18.sp,fontWeight: FontWeight.w700,),
                                                        MyText(text: data.lastMessage.isNotEmpty?data.lastMessage:AppLocalizations.of(context)!.media,size: 11.sp,fontWeight: FontWeight.w400,),
                                                      ],
                                                    ),
                                                  ),
                                                  MyText(text: timeFormat(data.lastMessageTimestamp),size: 10.sp,fontWeight: FontWeight.w400,),


                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            }),
                      );
                    });
              })
            )
          ],
        ),

      ),
    );
  }
}


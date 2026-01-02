import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/api/network/api-client.dart';
import 'package:sugudeni/providers/chatSocketProvider/chat-socket-provider.dart';
import 'package:sugudeni/providers/messages/seller-messages-provider.dart';
import 'package:sugudeni/repositories/messages/seller-messages-repository.dart';
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
                         // Calculate unread counts dynamically from threads
                         final threads = chatProvider.sellerThreads?.threads ?? [];
                         final totalThreadUnread = threads.fold<int>(0, (sum, thread) => sum + thread.unreadCount);
                         
                         // Use thread unread if available, otherwise use API count
                         final displayCount = threads.isNotEmpty ? totalThreadUnread : totalUnread;
                         
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
            Consumer2<ChatSocketProvider, SellerMessagesProvider>(builder: (context, provider, messagesProvider, child){
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

              if (provider.sellerThreads == null ||
                  provider.sellerThreads!.threads.isEmpty) {
                return EmptyStateWidget(
                  title: AppLocalizations.of(context)!.nochatfound,
                  description: 'You don\'t have any conversations yet. Messages from customers will appear here once they contact you.',
                  icon: Icons.chat_bubble_outline,
                );
              }
              
              // For now, show all threads in customer tab (system tab implementation pending API support)
              final allThreads = provider.sellerThreads!.threads;
              final filteredThreads = allThreads;
              
              if (filteredThreads.isEmpty) {
                final isCustomerTab = messagesProvider.selectMessageTab == SellerMessagesTabs.customer;
                return EmptyStateWidget(
                  title: isCustomerTab ? 'No Customer Messages' : 'No System Messages',
                  description: isCustomerTab 
                      ? 'You don\'t have any customer conversations yet.'
                      : 'You don\'t have any system messages yet.',
                  icon: Icons.chat_bubble_outline,
                );
              }
              
              return  Expanded(
                child: FutureBuilder(
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
                              return  FutureBuilder(
                                  future: UserRepository.getUserNameAndId(receiverId, context),
                                  builder: (context,snapshot){
                                    if(snapshot.connectionState==ConnectionState.waiting){
                                      return  ShimmerEffects().shimmerForChats();
                                    }
                                    // if(snapshot.data!.message=='success'){
                                    //   return  ShimmerEffects().shimmerForChats();
                                    // }
                                    var receiverData=snapshot.data;
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Material(

                                        elevation: 2,
                                        child: GestureDetector(
                                          onTap: ()async{
                                            String senderId=await getUserId();
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                                SellerMessageDetailView(receiverId: receiverId, receiverName: receiverData.user.name, senderId: userId,)));
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
                                                  data.participants.last.profilePic.isEmpty?

                                                  UserNameProfileWidget(name: receiverData!.user.name): MyCachedNetworkImage(
                                                      height: 40.h,
                                                      width: 40.w,
                                                      radius: 140.r,
                                                      imageUrl: "${ApiEndpoints.productUrl}/${data.participants.last.profilePic}"),

                                                  10.width,
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      MyText(text: capitalizeFirstLetter(receiverData!.user.name),size: 14.sp,fontWeight: FontWeight.w700,),
                                                      // MyText(text: data.participants.last.userId,size: 18.sp,fontWeight: FontWeight.w700,),
                                                      MyText(text: data.lastMessage.isNotEmpty?data.lastMessage:AppLocalizations.of(context)!.media,size: 11.sp,fontWeight: FontWeight.w400,),
                                                    ],
                                                  ),
                                                  const Spacer(),
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
                    }),
              );
            })
          ],
        ),

      ),
    );
  }
}

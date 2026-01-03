
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:flutter/material.dart';
import 'package:sugudeni/models/messages/ChatHistoryModel.dart';
import 'package:sugudeni/models/messages/MarkAsUnreadModel.dart';
import 'package:sugudeni/models/messages/SellerThreadsResponse.dart';
import 'package:sugudeni/providers/customer-chat-add-doc-provider.dart';
import 'package:sugudeni/repositories/messages/seller-messages-repository.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/utils/sharePreference/save-user-token.dart';

import '../../utils/constants/colors.dart';

class ChatSocketProvider extends ChangeNotifier{
bool isLoading=false;
 IO.Socket? socket;
ChatHistoryResponse? chatHistoryResponse;
final ScrollController scrollController = ScrollController();
TextEditingController messageController = TextEditingController();
String? errorMessage;
SellerThreadResponse? sellerThreads;

Future<void> fetchThreads(BuildContext context) async {
  try {
    isLoading = true;
    errorMessage = null;


    sellerThreads = await SellerMessagesRepository.getThreadsForSeller(context);
    customPrint("Threads data=================================${sellerThreads!.threads}");
    notifyListeners();
  } catch (e) {
    errorMessage = e.toString();
  } finally {
    isLoading = false;
    notifyListeners();
  }
}
void scrollToBottom() {
  if (scrollController.hasClients) {
    // For reversed ListView, scroll to top (position 0) to show newest messages
    scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }
}
getChatHistory(BuildContext context,String receiverId,String senderId)async{
  isLoading=true;
  chatHistoryResponse=await SellerMessagesRepository.getChatHistory(context, receiverId,senderId);
  isLoading=false;
  WidgetsBinding.instance
      .addPostFrameCallback((_) => scrollToBottom());
  notifyListeners();
}
void connectSocket(String receiverId,String senderId,BuildContext context) async{
  customPrint('Socket is going to connect===============');
  String userId=await getUserId();
  socket!.onConnect((_) {
    customPrint('Connected to socket');
    socket!.emit('seeMessage', {
      'senderid': senderId,
      'userid': receiverId,
    });

  });
  setupSocketListeners(userId,context);
  socket!.onDisconnect((_) {
    customPrint('Disconnected from the socket server');
  });
}
void connectSocketInInitial(BuildContext context) async {
  String userId=await getUserId();
  if(userId.isEmpty){
    return;
  }
  if (socket != null && socket!.connected) {
    customPrint("Socket is already connected, skipping connection.");
    return;
  }

  customPrint("Connecting=======================================");

  socket = IO.io(
    'https://api.sugudeni.com',
    IO.OptionBuilder().setTransports(['websocket']).setAuth({
      'userid': userId,
    }).build(),
  );

  socket!.connect();
}
void setupSocketListeners(String? currentUserId,BuildContext context) {
  if (socket == null) return;

  // Remove previous listeners to prevent duplication
  socket!.off('newMessage');
  socket!.off('newMedia');
  socket!.off('messageDeleted');
  socket!.off('seenMessage');
  socket!.off('deliveredMessage');
  socket!.off('unreadMessagesCount');

  // Now, add fresh listeners
  socket!.on('newMessage', (data) {
    customPrint("New message =================================$data");
  var value=ChatMessage(
          id: data['_id'],
          senderId: data['senderid'],
          receiverId: data['receiverid'],
          message: data['message'],
          likedBy: [],
          replyOf: [],
          read: false,
          delivered: false,
          seen: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          contentURL: '',
          contentType: '',
          liked: false);
  chatHistoryResponse?.chat.add(value);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => scrollToBottom());
    notifyListeners();

  });
  socket!.on('newMedia', (data) {
    customPrint("New Media =================================$data");
    var value=ChatMessage(
        id: data['_id'],
        senderId: data['senderid'],
        receiverId: data['receiverid'],
        message: '',
        likedBy: [],
        replyOf: [],
        read: false,
        delivered: false,
        seen: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        contentURL: data['contentURL'],
        contentType: data['contentType'],
        liked: false);
    chatHistoryResponse?.chat.add(value);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => scrollToBottom());
    notifyListeners();
    context.read<SellerChatAddDocProvider>().reset();

  });
  socket!.on('messageDeleted', (data) {
    customPrint("Message Deleted =================================$data");
  });
  socket!.on('seenMessage', (data) {
    customPrint(" seen Message  =================================$data");

  });
  socket!.on('deliveredMessage', (data) {

    customPrint("================================= Deliver message $data");
    customPrint('Message delivered to ${data['receiverid']}');
  });
  socket!.on('unreadMessagesCount', (data) {
    customPrint("Unread message count =================================  $data");
  });
}

void aboutThreads(BuildContext context) async{
  if (socket == null) return;

  // Remove previous listeners to prevent duplication
  socket!.off('threadUpdate');
  socket!.off('newThread');
  socket!.off('unreadMessagesCount');
  String userId=await getUserId();
  customPrint("Connecting=======================================");
  socket = IO.io(
    'https://api.sugudeni.com',
    IO.OptionBuilder().setTransports(['websocket']).setAuth({
      'userid': userId,
    }).build(),
  );
  socket!.connect();
  socket!.on('threadUpdate', (data)async {
    sellerThreads = await SellerMessagesRepository.getThreadsForSeller(context);
    notifyListeners();
    customPrint("Thread Update =================================$data");
  });
  socket!.on('newThread', (data) {
    customPrint("New Thread =================================$data");
  });
  socket!.on('unreadMessagesCount', (data) {
    customPrint("Unread message count =================================$data");
  });
}
Future<void> updateLastMessage(String threadId, String newMessage)async {
  var userId=await getUserId();

  for (var thread in sellerThreads!.threads) {
    if (thread.id == threadId) {
      thread = Thread(
        id: thread.id,
        participants: thread.participants,
        lastMessage: newMessage,
        lastMessageSenderId: userId,
        lastMessageTimestamp: DateTime.now(),
        contentType: thread.contentType,
        unreadCount: thread.unreadCount,
        threadType: thread.threadType,
      );
      break;

    }
  }
}
void sendMessage(String receiverId,String senderId) {
  if (messageController.text.isNotEmpty) {
    String message = messageController.text;
    // String messageId = DateTime.now().millisecondsSinceEpoch.toString();

    socket!.emit('sendMessage', {
      // 'messageid': messageId,
      'senderid': senderId,
      'receiverid': receiverId,
      'message': message,
    });
    socket!.emit('newThread', {
      'receiverid':receiverId
    });

    WidgetsBinding.instance
        .addPostFrameCallback((_) => scrollToBottom());
    messageController.clear();
  }
}
void sendMedia(String receiverId,String senderId,BuildContext context) {


    socket!.emit('sendMedia', {
      // 'messageid': messageId,
      'senderid': senderId,
      'receiverid': receiverId,
      'mimeType':getMimeType(context.read<SellerChatAddDocProvider>().image!.path),
      'file':context.read<SellerChatAddDocProvider>().image!.readAsBytesSync(),
      'filename':context.read<SellerChatAddDocProvider>().image!.path,
    });
    socket!.emit('newThread', {
      'receiverid':receiverId
    });

    WidgetsBinding.instance
        .addPostFrameCallback((_) => scrollToBottom());
    // Don't clear messageController for media sending

}
void removeMessageById(String messageId) {
  chatHistoryResponse!.chat.removeWhere((message) => message.id == messageId);
  notifyListeners();
}
void deleteMessage(String id,receiverId,String senderId ){
  socket!.emit('deleteMessage', {
    'chatid': id,
    'senderid': senderId,
    'receiverid': receiverId,
  });
  removeMessageById(id);
}


Future<void>markAsUnread(String userid,String otherUserid,BuildContext context)async{
  var model=MarkAsUnreadModel(userid: userid, otherUserid: otherUserid);
  await SellerMessagesRepository.markAsUnread(model, context);
}
void disconnectSocket(){

  socket!.disconnect();
  socket!.close();
  socket!.clearListeners();

  customPrint("Socket disconnected");
}
}

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
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }
}
getChatHistory(BuildContext context,String receiverId,String senderId)async{
  isLoading=true;
  notifyListeners();
  try {
    chatHistoryResponse=await SellerMessagesRepository.getChatHistory(context, receiverId,senderId);
  } catch (e) {
    // If chat history fails (e.g., new chat with no history), initialize with empty list
    chatHistoryResponse = ChatHistoryResponse(chat: []);
    customPrint('Error loading chat history, initializing empty: $e');
  }
  isLoading=false;
  WidgetsBinding.instance
      .addPostFrameCallback((_) => scrollToBottom());
  notifyListeners();
}
void connectSocket(String receiverId,String senderId,BuildContext context) async{
  customPrint('Socket is going to connect===============');
  String userId=await getUserId();
  
  // Ensure socket is initialized
  if (socket == null) {
    connectSocketInInitial(context);
    await Future.delayed(const Duration(milliseconds: 500));
  }
  
  // Wait for socket to be ready
  if (socket == null) {
    customPrint('Socket is still null, cannot connect');
    return;
  }
  
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
  
  // Connect if not already connected
  if (!socket!.connected) {
    socket!.connect();
  }
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
    
    // Initialize chatHistoryResponse if null
    if (chatHistoryResponse == null) {
      chatHistoryResponse = ChatHistoryResponse(chat: []);
    }
    
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
    
    // Check if message already exists by ID (avoid duplicates)
    if (chatHistoryResponse!.chat.any((msg) => msg.id == value.id)) {
      customPrint('Message already exists, skipping duplicate');
      return;
    }
    
    // Check if this is a duplicate of an optimistic message (same content, sender, receiver, recent)
    // Remove optimistic message if found and replace with real one
    String? optimisticMessageId;
    for (var msg in chatHistoryResponse!.chat) {
      // First check if content matches (same sender, receiver, message)
      bool matchesContent = msg.senderId == value.senderId &&
                           msg.receiverId == value.receiverId &&
                           msg.message == value.message;
      
      if (matchesContent) {
        // Check if this is an optimistic message (ID is a timestamp string, not a MongoDB ObjectId)
        // Optimistic messages have numeric IDs (timestamps), real messages have MongoDB ObjectIds (24 hex chars)
        bool isOptimistic = msg.id.length >= 10 && 
                           int.tryParse(msg.id) != null &&
                           !msg.id.contains(RegExp(r'[a-fA-F]')); // No hex chars = not MongoDB ID
        
        if (isOptimistic) {
          // Check if message was sent recently (within last 10 seconds to be safe)
          try {
            DateTime optimisticTime = DateTime.fromMillisecondsSinceEpoch(int.parse(msg.id));
            if (DateTime.now().difference(optimisticTime).inSeconds < 10) {
              optimisticMessageId = msg.id;
              customPrint('Found matching optimistic message: $optimisticMessageId (sent ${DateTime.now().difference(optimisticTime).inSeconds}s ago)');
              break;
            }
          } catch (e) {
            // If parsing fails, still remove if content matches (fallback for safety)
            optimisticMessageId = msg.id;
            customPrint('Found matching optimistic message (fallback): $optimisticMessageId');
            break;
          }
        }
      }
    }
    
    // Remove optimistic message if found
    if (optimisticMessageId != null) {
      chatHistoryResponse!.chat.removeWhere((msg) => msg.id == optimisticMessageId);
      customPrint('Removed optimistic message: $optimisticMessageId');
    }
    
    // Add the real message from server
    chatHistoryResponse!.chat.add(value);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => scrollToBottom());
    notifyListeners();
  });
  socket!.on('newMedia', (data) {
    customPrint("New Media =================================$data");
    
    // Initialize chatHistoryResponse if null
    if (chatHistoryResponse == null) {
      chatHistoryResponse = ChatHistoryResponse(chat: []);
    }
    
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
    
    // Check if message already exists by ID (avoid duplicates)
    if (chatHistoryResponse!.chat.any((msg) => msg.id == value.id)) {
      customPrint('Media message already exists, skipping duplicate');
      context.read<SellerChatAddDocProvider>().reset();
      return;
    }
    
    // Check if this is a duplicate of an optimistic media message
    // Remove optimistic message if found and replace with real one
    String? optimisticMessageId;
    for (var msg in chatHistoryResponse!.chat) {
      // First check if content matches (same sender, receiver, content type)
      bool matchesContent = msg.senderId == value.senderId &&
                           msg.receiverId == value.receiverId &&
                           msg.contentType == value.contentType;
      
      if (matchesContent) {
        // Check if this is an optimistic message (ID is a timestamp string, not a MongoDB ObjectId)
        // Optimistic messages have numeric IDs (timestamps), real messages have MongoDB ObjectIds (24 hex chars)
        bool isOptimistic = msg.id.length >= 10 && 
                           int.tryParse(msg.id) != null &&
                           !msg.id.contains(RegExp(r'[a-fA-F]')); // No hex chars = not MongoDB ID
        
        if (isOptimistic) {
          // Check if message was sent recently (within last 10 seconds to be safe)
          try {
            DateTime optimisticTime = DateTime.fromMillisecondsSinceEpoch(int.parse(msg.id));
            if (DateTime.now().difference(optimisticTime).inSeconds < 10) {
              optimisticMessageId = msg.id;
              customPrint('Found matching optimistic media message: $optimisticMessageId (sent ${DateTime.now().difference(optimisticTime).inSeconds}s ago)');
              break;
            }
          } catch (e) {
            // If parsing fails, still remove if content matches (fallback for safety)
            optimisticMessageId = msg.id;
            customPrint('Found matching optimistic media message (fallback): $optimisticMessageId');
            break;
          }
        }
      }
    }
    
    // Remove optimistic message if found
    if (optimisticMessageId != null) {
      chatHistoryResponse!.chat.removeWhere((msg) => msg.id == optimisticMessageId);
      customPrint('Removed optimistic media message: $optimisticMessageId');
    }
    
    // Add the real message from server
    chatHistoryResponse!.chat.add(value);
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
    String tempMessageId = DateTime.now().millisecondsSinceEpoch.toString();
    
    // Initialize chatHistoryResponse if null (for new chats)
    if (chatHistoryResponse == null) {
      chatHistoryResponse = ChatHistoryResponse(chat: []);
    }
    
    // Add optimistic message to UI immediately
    final optimisticMessage = ChatMessage(
      id: tempMessageId,
      senderId: senderId,
      receiverId: receiverId,
      message: message,
      likedBy: [],
      replyOf: [],
      read: false,
      delivered: false,
      seen: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      contentURL: '',
      contentType: '',
      liked: false,
    );
    chatHistoryResponse!.chat.add(optimisticMessage);
    notifyListeners();
    WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());
    
    messageController.clear();
    notifyListeners();
    
    // Check if socket is connected before sending
    if (socket == null || !socket!.connected) {
      customPrint('Socket not connected, message will be sent when socket connects');
      // Wait a bit and retry (socket should be initialized by the chat screen)
      Future.delayed(const Duration(milliseconds: 500), () {
        if (socket != null && socket!.connected) {
          _sendMessageToSocket(receiverId, senderId, message);
        } else {
          customPrint('Failed to connect socket, removing optimistic message');
          chatHistoryResponse!.chat.removeWhere((m) => m.id == tempMessageId);
          notifyListeners();
        }
      });
    } else {
      _sendMessageToSocket(receiverId, senderId, message);
    }
  }
}

void _sendMessageToSocket(String receiverId, String senderId, String message) {
  if (socket == null || !socket!.connected) {
    customPrint('Cannot send message: socket is null or not connected');
    return;
  }
  
  socket!.emit('sendMessage', {
    'senderid': senderId,
    'receiverid': receiverId,
    'message': message,
  });
  socket!.emit('newThread', {
    'receiverid': receiverId
  });
}
void sendMedia(String receiverId,String senderId,BuildContext context) {
  final imageProvider = context.read<SellerChatAddDocProvider>();
  if (imageProvider.image == null) {
    customPrint('No image to send');
    return;
  }
  
  String tempMessageId = DateTime.now().millisecondsSinceEpoch.toString();
  
  // Initialize chatHistoryResponse if null (for new chats)
  if (chatHistoryResponse == null) {
    chatHistoryResponse = ChatHistoryResponse(chat: []);
  }
  
  // Add optimistic media message to UI immediately
  final optimisticMessage = ChatMessage(
    id: tempMessageId,
    senderId: senderId,
    receiverId: receiverId,
    message: '',
    likedBy: [],
    replyOf: [],
    read: false,
    delivered: false,
    seen: false,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    contentURL: imageProvider.image!.path, // Temporary local path
    contentType: getMimeType(imageProvider.image!.path) ?? '',
    liked: false,
  );
  chatHistoryResponse!.chat.add(optimisticMessage);
  notifyListeners();
  WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());
  
  messageController.clear();
  notifyListeners();
  
  // Check if socket is connected before sending
  if (socket == null || !socket!.connected) {
    customPrint('Socket not connected, media will be sent when socket connects');
    // Wait a bit and retry (socket should be initialized by the chat screen)
    Future.delayed(const Duration(milliseconds: 500), () {
      if (socket != null && socket!.connected) {
        _sendMediaToSocket(receiverId, senderId, context);
      } else {
        customPrint('Failed to connect socket, removing optimistic message');
        chatHistoryResponse!.chat.removeWhere((m) => m.id == tempMessageId);
        notifyListeners();
      }
    });
  } else {
    _sendMediaToSocket(receiverId, senderId, context);
  }
}

void _sendMediaToSocket(String receiverId, String senderId, BuildContext context) {
  if (socket == null || !socket!.connected) {
    customPrint('Cannot send media: socket is null or not connected');
    return;
  }
  
  final imageProvider = context.read<SellerChatAddDocProvider>();
  if (imageProvider.image == null) {
    return;
  }
  
  socket!.emit('sendMedia', {
    'senderid': senderId,
    'receiverid': receiverId,
    'mimeType': getMimeType(imageProvider.image!.path) ?? 'image/jpeg',
    'file': imageProvider.image!.readAsBytesSync(),
    'filename': imageProvider.image!.path,
  });
  socket!.emit('newThread', {
    'receiverid': receiverId
  });
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
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


class ChatSocketProvider extends ChangeNotifier{
bool isLoading=false;
 IO.Socket? socket;
ChatHistoryResponse? chatHistoryResponse;
final ScrollController scrollController = ScrollController();
TextEditingController messageController = TextEditingController();
String? errorMessage;
SellerThreadResponse? sellerThreads;
String? _currentReceiverId;
String? _currentSenderId;
// Track processed message IDs to avoid duplicates
final Set<String> _processedMessageIds = <String>{};
// Track pending text messages: localId -> receiverId
final Map<String, String> _pendingTextMessages = <String, String>{};

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
    // For reversed ListView (reverse: true), scroll to position 0.0 to show newest messages
    // Position 0.0 is at the bottom for reversed ListViews
    scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }
}
getChatHistory(BuildContext context,String receiverId,String senderId, {bool forceReload = false})async{
  // Don't reload if we already have chat history for the same conversation (unless forceReload is true)
  if (!forceReload && chatHistoryResponse != null && 
      _currentReceiverId == receiverId && 
      _currentSenderId == senderId) {
    customPrint('Chat history already loaded for this conversation, skipping reload');
    return;
  }
  
  _currentReceiverId = receiverId;
  _currentSenderId = senderId;
  
  isLoading=true;
  notifyListeners();
  try {
    final history = await SellerMessagesRepository.getChatHistory(context, receiverId, senderId);
    
    // Mark all loaded messages as processed to avoid duplicates
    for (var msg in history.chat) {
      if (msg.id.isNotEmpty && !msg.id.startsWith('local-') && !msg.id.startsWith('temp-')) {
        _processedMessageIds.add(msg.id);
      }
    }
    
    chatHistoryResponse = history;
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
  
  // Set up socket listeners before connecting
  setupSocketListeners(userId, context);
  
  socket!.onConnect((_) {
    customPrint('Connected to socket');
    socket!.emit('seeMessage', {
      'senderid': senderId,
      'userid': receiverId,
    });
  });
  
  socket!.onDisconnect((_) {
    customPrint('Disconnected from the socket server');
  });
  
  // Add error handling for socket errors
  socket!.onError((error) {
    customPrint('Socket error: $error');
    // Handle different error types safely
    if (error is Map<String, dynamic>) {
      customPrint('Socket error (Map): $error');
    } else if (error is Exception || error is Error) {
      // Handle SocketException and other exceptions
      customPrint('Socket exception: ${error.toString()}');
    } else {
      // Handle any other error type
      customPrint('Socket error (unknown type): ${error.toString()}');
    }
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
  socket!.off('error');
  socket!.off('sendMessageError');
  
  // Ensure chatHistoryResponse is initialized
  if (chatHistoryResponse == null) {
    chatHistoryResponse = ChatHistoryResponse(chat: []);
  }

  // Now, add fresh listeners
  socket!.on('newMessage', (data) async {
    final messageId = data['_id']?.toString();
    
    // Skip if message already processed (avoid duplicates)
    if (messageId != null && _processedMessageIds.contains(messageId)) {
      return;
    }
    
    // Get current user ID for comparison
    final currentUserId = await getUserId();
    
    // Check if this message belongs to the current conversation
    final messageSenderId = data['senderid']?.toString() ?? '';
    final messageReceiverId = data['receiverid']?.toString() ?? '';
    final isSent = messageSenderId == currentUserId;
    final partnerId = isSent ? messageReceiverId : messageSenderId;
    
    // Only process if this message is for the current conversation
    bool belongsToCurrentConversation = false;
    if (_currentReceiverId != null && _currentSenderId != null) {
      belongsToCurrentConversation = 
          (messageSenderId == _currentReceiverId && messageReceiverId == _currentSenderId) ||
          (messageSenderId == _currentSenderId && messageReceiverId == _currentReceiverId);
    }
    
    if (!belongsToCurrentConversation) {
      return;
    }
    
    // Initialize chatHistoryResponse if null
    if (chatHistoryResponse == null) {
      chatHistoryResponse = ChatHistoryResponse(chat: []);
    }
    
    // Check if this is confirmation of a pending message we sent (text or attachment)
    String? foundLocalId;
    if (isSent && messageId != null) {
      // First, check for pending text messages
      for (var entry in _pendingTextMessages.entries) {
        if (entry.value == partnerId) {
          foundLocalId = entry.key;
          _pendingTextMessages.remove(entry.key);
          break;
        }
      }
      
      // If not found in text messages, check for optimistic attachment messages
      if (foundLocalId == null && data['attachment'] == true) {
        // Find optimistic attachment message for this conversation
        final attachmentMessages = chatHistoryResponse!.chat
            .where((m) => m.id.startsWith('local-attachment-') && 
                          m.senderId == messageSenderId && 
                          m.receiverId == messageReceiverId)
            .toList();
        if (attachmentMessages.isNotEmpty) {
          // Get the most recent one (last in sorted list)
          foundLocalId = attachmentMessages.last.id;
        }
      }
      
      // If found, replace optimistic message in place
      if (foundLocalId != null) {
        final msgIndex = chatHistoryResponse!.chat.indexWhere((m) => m.id == foundLocalId);
        if (msgIndex != -1) {
          // Parse createdAt and updatedAt from server data
          DateTime createdAt;
          DateTime updatedAt;
          try {
            if (data['createdAt'] != null) {
              createdAt = data['createdAt'] is String 
                  ? DateTime.parse(data['createdAt'] as String)
                  : DateTime.parse(data['createdAt'].toString());
            } else {
              createdAt = DateTime.now();
            }
            if (data['updatedAt'] != null) {
              updatedAt = data['updatedAt'] is String
                  ? DateTime.parse(data['updatedAt'] as String)
                  : DateTime.parse(data['updatedAt'].toString());
            } else {
              updatedAt = DateTime.now();
            }
          } catch (e) {
            createdAt = DateTime.now();
            updatedAt = DateTime.now();
          }
          
          // Replace optimistic message with real one
          chatHistoryResponse!.chat[msgIndex] = ChatMessage(
            id: messageId,
            senderId: data['senderid'],
            receiverId: data['receiverid'],
            message: data['message'] ?? '',
            likedBy: data['likedBy'] as List<dynamic>? ?? [],
            replyOf: data['replyof'] as List<dynamic>? ?? [],
            read: data['read'] as bool? ?? false,
            delivered: data['delivered'] as bool? ?? false,
            seen: data['seen'] as bool? ?? false,
            createdAt: createdAt,
            updatedAt: updatedAt,
            contentURL: data['media'] as String? ?? '',
            contentType: data['contentType'] as String? ?? '',
            liked: data['liked'] as bool? ?? false,
            attachment: data['attachment'] as bool? ?? false,
            attachmentData: data['attachmentData'] != null 
                ? Map<String, dynamic>.from(data['attachmentData'])
                : null,
          );
          
          // Mark as processed
          _processedMessageIds.add(messageId);
          
          // Sort and notify
          chatHistoryResponse!.chat.sort((a, b) => a.createdAt.compareTo(b.createdAt));
          notifyListeners();
          WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());
          return;
        }
      }
    }
    
    // Not a pending message confirmation → add as new message (incoming or fallback)
    if (messageId != null) {
      _processedMessageIds.add(messageId);
    }
    
    // Parse createdAt and updatedAt from server data
    DateTime createdAt;
    DateTime updatedAt;
    try {
      if (data['createdAt'] != null) {
        createdAt = data['createdAt'] is String 
            ? DateTime.parse(data['createdAt'] as String)
            : DateTime.parse(data['createdAt'].toString());
      } else {
        createdAt = DateTime.now();
      }
      if (data['updatedAt'] != null) {
        updatedAt = data['updatedAt'] is String
            ? DateTime.parse(data['updatedAt'] as String)
            : DateTime.parse(data['updatedAt'].toString());
      } else {
        updatedAt = DateTime.now();
      }
    } catch (e) {
      createdAt = DateTime.now();
      updatedAt = DateTime.now();
    }
    
    final newMessage = ChatMessage(
      id: messageId ?? 'temp-${DateTime.now().millisecondsSinceEpoch}',
      senderId: data['senderid'],
      receiverId: data['receiverid'],
      message: data['message'] ?? '',
      likedBy: data['likedBy'] as List<dynamic>? ?? [],
      replyOf: data['replyof'] as List<dynamic>? ?? [],
      read: data['read'] as bool? ?? false,
      delivered: data['delivered'] as bool? ?? false,
      seen: data['seen'] as bool? ?? false,
      createdAt: createdAt,
      updatedAt: updatedAt,
      contentURL: data['media'] as String? ?? '',
      contentType: data['contentType'] as String? ?? '',
      liked: data['liked'] as bool? ?? false,
      attachment: data['attachment'] as bool? ?? false,
      attachmentData: data['attachmentData'] != null 
          ? Map<String, dynamic>.from(data['attachmentData'])
          : null,
    );
    
    // Check if message already exists (avoid duplicates)
    if (chatHistoryResponse!.chat.any((msg) => msg.id == newMessage.id)) {
      return;
    }
    
    // Add the new message
    chatHistoryResponse!.chat.add(newMessage);
    // Sort messages by createdAt to maintain chronological order
    chatHistoryResponse!.chat.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    // Notify listeners immediately to update UI
    notifyListeners();
    // Scroll to bottom after UI updates
    WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());
  });
  socket!.on('newMedia', (data) {
    customPrint("New Media =================================$data");
    
    // Check if this message belongs to the current conversation
    final messageSenderId = data['senderid']?.toString() ?? '';
    final messageReceiverId = data['receiverid']?.toString() ?? '';
    
    // Only process if this message is for the current conversation
    // Message should be from current receiver to current sender, or vice versa
    bool belongsToCurrentConversation = false;
    if (_currentReceiverId != null && _currentSenderId != null) {
      belongsToCurrentConversation = 
          (messageSenderId == _currentReceiverId && messageReceiverId == _currentSenderId) ||
          (messageSenderId == _currentSenderId && messageReceiverId == _currentReceiverId);
    }
    
    if (!belongsToCurrentConversation) {
      customPrint('Media message not for current conversation - sender: $messageSenderId, receiver: $messageReceiverId');
      customPrint('Current conversation - sender: $_currentSenderId, receiver: $_currentReceiverId');
      return;
    }
    
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
  
  // Error listeners - only log
  socket!.on('error', (error) {
    customPrint("Socket error event: $error");
  });
  
  // Listen for sendMessage specific errors - only log
  socket!.on('sendMessageError', (error) {
    customPrint("Send message error: $error");
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
  socket!.on('newThread', (data) async {
    customPrint("New Thread =================================$data");
    // Fetch updated threads to refresh the count
    if (context.mounted) {
      sellerThreads = await SellerMessagesRepository.getThreadsForSeller(context);
      notifyListeners();
    }
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
Future<void> sendMessage(String receiverId, String senderId, {bool? attachment, Map<String, dynamic>? attachmentData}) async {
  // Allow sending even if message is empty (for attachments)
  String message = messageController.text;
  
  // Initialize chatHistoryResponse if null (for new chats)
  if (chatHistoryResponse == null) {
    chatHistoryResponse = ChatHistoryResponse(chat: []);
  }
  
  // Add optimistic message for both text messages and attachments
  String? localMessageId;
  if (attachment == true && attachmentData != null) {
    // Generate unique local ID for optimistic attachment message
    localMessageId = 'local-attachment-${DateTime.now().millisecondsSinceEpoch}-${senderId}';
    
    final optimisticMessage = ChatMessage(
      id: localMessageId,
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
      contentURL: '',
      contentType: '',
      liked: false,
      attachment: true,
      attachmentData: attachmentData,
    );
    
    chatHistoryResponse!.chat.add(optimisticMessage);
    // Sort messages by createdAt to maintain chronological order
    chatHistoryResponse!.chat.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    // Notify listeners immediately to show message in UI
    notifyListeners();
    // Scroll to bottom after UI updates
    WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());
  } else if (attachment != true && message.trim().isNotEmpty) {
    // Generate unique local ID for optimistic text message
    localMessageId = 'local-text-${DateTime.now().millisecondsSinceEpoch}-${senderId}';
    
    // Track this pending message
    _pendingTextMessages[localMessageId] = receiverId;
    
    final optimisticMessage = ChatMessage(
      id: localMessageId,
      senderId: senderId,
      receiverId: receiverId,
      message: message.trim(),
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
      attachment: false,
      attachmentData: null,
    );
    
    chatHistoryResponse!.chat.add(optimisticMessage);
    // Sort messages by createdAt to maintain chronological order
    chatHistoryResponse!.chat.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    // Notify listeners immediately to show message in UI
    notifyListeners();
    // Scroll to bottom after UI updates
    WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());
  }
  
  messageController.clear();
  notifyListeners();
  
  // Check if socket is connected before sending
  if (socket == null || !socket!.connected) {
    customPrint('Socket not connected, message cannot be sent');
    // Remove optimistic message and pending tracking if socket not connected
    if (localMessageId != null) {
      chatHistoryResponse!.chat.removeWhere((m) => m.id == localMessageId);
      _pendingTextMessages.remove(localMessageId);
      notifyListeners();
    }
  } else {
    _sendMessageToSocket(receiverId, senderId, message, attachment: attachment, attachmentData: attachmentData);
  }
}

void _sendMessageToSocket(String receiverId, String senderId, String message, {bool? attachment, Map<String, dynamic>? attachmentData}) {
  Map<String, dynamic> messageData = {
    'senderid': senderId,
    'receiverid': receiverId,
    'message': message,
  };
  
  // Add attachment data if present - send exactly as provided (server will handle it)
  if (attachment == true && attachmentData != null) {
    messageData['attachment'] = true;
    messageData['attachmentData'] = attachmentData;
  }
  
  socket!.emit('sendMessage', messageData);
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
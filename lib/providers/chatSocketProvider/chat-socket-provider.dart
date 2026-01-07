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
  String? get currentReceiverId => _currentReceiverId;
  String? get currentSenderId => _currentSenderId;
// Track processed message IDs to avoid duplicates
  final Set<String> _processedMessageIds = <String>{};
  // Track pending text messages: localId -> receiverId
  final Map<String, String> _pendingTextMessages = <String, String>{};
  // Track pending attachment (product/order) - only send when user taps send button
  Map<String, dynamic>? _pendingAttachment;
  bool get hasPendingAttachment => _pendingAttachment != null;
  Map<String, dynamic>? get pendingAttachment => _pendingAttachment;

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
  
  // Preserve optimistic messages with attachmentData before fetching
  final optimisticMessages = chatHistoryResponse?.chat
      .where((msg) => (msg.id.startsWith('local-attachment-') || msg.id.startsWith('local-text-')) && 
                      msg.attachment == true && 
                      msg.attachmentData != null)
      .toList() ?? [];
  
  customPrint('Preserving ${optimisticMessages.length} optimistic attachment messages before fetching chat history');
  
  isLoading=true;
  notifyListeners();
  try {
    final history = await SellerMessagesRepository.getChatHistory(context, receiverId, senderId);
    
    // Log attachment messages in fetched history
    final attachmentMessages = history.chat.where((msg) => msg.attachment == true).toList();
    customPrint('Fetched chat history - total messages: ${history.chat.length}, attachment messages: ${attachmentMessages.length}');
    for (var msg in attachmentMessages) {
      customPrint('Attachment message from server - id: ${msg.id}, hasAttachmentData: ${msg.attachmentData != null}');
      if (msg.attachmentData != null) {
        customPrint('  - attachmentType: ${msg.attachmentData!['attachmentType']}');
      } else {
        customPrint('  - ✗✗✗ CRITICAL WARNING: Attachment message but attachmentData is null! ✗✗✗');
        customPrint('  - This means the server is NOT storing/returning attachmentData in the API response');
        customPrint('  - The attachment cannot be displayed without this data');
        customPrint('  - Server needs to be fixed to store and return attachmentData');
      }
    }
    
    // CRITICAL: Filter out attachment messages without attachmentData
    // These are useless and will cause errors in the UI
    final validMessages = history.chat.where((msg) {
      if (msg.attachment == true && msg.attachmentData == null) {
        customPrint('Filtering out attachment message without attachmentData - id: ${msg.id}');
        return false; // Don't include messages with attachment=true but no attachmentData
      }
      return true;
    }).toList();
    
    customPrint('After filtering - valid messages: ${validMessages.length}, filtered out: ${history.chat.length - validMessages.length}');
    
    // Update history with filtered messages
    history.chat.clear();
    history.chat.addAll(validMessages);
    
    // Merge optimistic messages with server messages
    // CRITICAL: Never lose optimistic messages with attachmentData
    final mergedChat = <ChatMessage>[];
    final serverMessageIds = history.chat.map((m) => m.id).toSet();
    
    // Add all server messages first
    mergedChat.addAll(history.chat);
    
    // Process optimistic messages - preserve them if server doesn't have attachmentData
    for (var optimisticMsg in optimisticMessages) {
      bool foundServerEquivalent = false;
      bool serverHasAttachmentData = false;
      
      // Look for server message with same sender/receiver and similar timestamp
      for (var serverMsg in history.chat) {
        if (serverMsg.senderId == optimisticMsg.senderId &&
            serverMsg.receiverId == optimisticMsg.receiverId &&
            serverMsg.attachment == true) {
          // Check if timestamps are close (within 10 seconds to be safe)
          final timeDiff = (serverMsg.createdAt.difference(optimisticMsg.createdAt)).abs();
          if (timeDiff.inSeconds < 10) {
            foundServerEquivalent = true;
            serverHasAttachmentData = serverMsg.attachmentData != null;
            
            // If server message doesn't have attachmentData but optimistic does, UPDATE server message
            if (!serverHasAttachmentData && optimisticMsg.attachmentData != null) {
              customPrint('CRITICAL: Server message missing attachmentData, updating with optimistic data - serverId: ${serverMsg.id}');
              // Update server message with optimistic attachmentData
              final updatedMsg = ChatMessage(
                id: serverMsg.id,
                senderId: serverMsg.senderId,
                receiverId: serverMsg.receiverId,
                message: serverMsg.message,
                likedBy: serverMsg.likedBy,
                replyOf: serverMsg.replyOf,
                read: serverMsg.read,
                delivered: serverMsg.delivered,
                seen: serverMsg.seen,
                createdAt: serverMsg.createdAt,
                updatedAt: serverMsg.updatedAt,
                contentURL: serverMsg.contentURL,
                contentType: serverMsg.contentType,
                liked: serverMsg.liked,
                attachment: serverMsg.attachment,
                attachmentData: Map<String, dynamic>.from(optimisticMsg.attachmentData!),
              );
              // Replace in mergedChat
              final index = mergedChat.indexWhere((m) => m.id == serverMsg.id);
              if (index != -1) {
                mergedChat[index] = updatedMsg;
                customPrint('Updated server message with optimistic attachmentData');
              }
            } else if (serverHasAttachmentData) {
              customPrint('Server message has attachmentData, using server version');
            }
            break;
          }
        }
      }
      
      // If no server equivalent found OR server doesn't have attachmentData, KEEP the optimistic message
      if (!foundServerEquivalent || !serverHasAttachmentData) {
        if (!foundServerEquivalent) {
          customPrint('Keeping optimistic message (no server equivalent) - id: ${optimisticMsg.id}');
        } else {
          customPrint('Keeping optimistic message (server missing attachmentData) - id: ${optimisticMsg.id}');
        }
        // Only add if not already in mergedChat (avoid duplicates)
        if (!mergedChat.any((m) => m.id == optimisticMsg.id)) {
          mergedChat.add(optimisticMsg);
        }
      }
    }
    
    // Mark all loaded messages as processed to avoid duplicates
    for (var msg in mergedChat) {
      if (msg.id.isNotEmpty && !msg.id.startsWith('local-') && !msg.id.startsWith('temp-')) {
        _processedMessageIds.add(msg.id);
      }
    }
    
    chatHistoryResponse = ChatHistoryResponse(chat: mergedChat);
    customPrint('Merged chat history - total messages: ${mergedChat.length}');
  } catch (e) {
    // If chat history fails (e.g., new chat with no history), keep optimistic messages
    if (optimisticMessages.isNotEmpty) {
      chatHistoryResponse = ChatHistoryResponse(chat: optimisticMessages);
      customPrint('Error loading chat history, keeping ${optimisticMessages.length} optimistic messages: $e');
    } else {
      chatHistoryResponse = ChatHistoryResponse(chat: []);
      customPrint('Error loading chat history, initializing empty: $e');
    }
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
    customPrint('Received newMessage event - data keys: ${data is Map ? (data as Map).keys.toList() : 'not a map'}');
    if (data is Map && data['attachment'] == true) {
      customPrint('Received attachment message - hasAttachmentData: ${data.containsKey('attachmentData')}');
      if (data['attachmentData'] != null) {
        customPrint('AttachmentData type: ${data['attachmentData'].runtimeType}');
        if (data['attachmentData'] is Map) {
          customPrint('AttachmentData keys: ${(data['attachmentData'] as Map).keys.toList()}');
        }
      } else {
        customPrint('WARNING: Received attachment message but attachmentData is null!');
      }
    }
    
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
    // BUT: Always process attachment messages to ensure they're not lost
    bool belongsToCurrentConversation = false;
    if (_currentReceiverId != null && _currentSenderId != null) {
      belongsToCurrentConversation = 
          (messageSenderId == _currentReceiverId && messageReceiverId == _currentSenderId) ||
          (messageSenderId == _currentSenderId && messageReceiverId == _currentReceiverId);
    }
    
    // Log conversation check for debugging
    final isAttachmentMessage = data['attachment'] == true;
    customPrint('Message conversation check - senderId: $messageSenderId, receiverId: $messageReceiverId, currentReceiverId: $_currentReceiverId, currentSenderId: $_currentSenderId, belongsToConversation: $belongsToCurrentConversation, isAttachment: $isAttachmentMessage');
    
    // CRITICAL: Always process attachment messages even if conversation check fails
    // This ensures receiver gets the attachment
    if (!belongsToCurrentConversation && !isAttachmentMessage) {
      customPrint('Message not for current conversation and not attachment, skipping');
      return;
    }
    
    if (!belongsToCurrentConversation && isAttachmentMessage) {
      customPrint('WARNING: Attachment message not for current conversation, but processing anyway to prevent loss');
      // Update current conversation IDs to match this attachment message
      // This ensures the receiver can see the attachment
      _currentReceiverId = messageReceiverId;
      _currentSenderId = messageSenderId;
      customPrint('Updated conversation IDs to match attachment message - receiverId: $_currentReceiverId, senderId: $_currentSenderId');
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
        // Sort by createdAt to get the most recent
        final attachmentMessages = chatHistoryResponse!.chat
            .where((m) => m.id.startsWith('local-attachment-') && 
                          m.senderId == messageSenderId && 
                          m.receiverId == messageReceiverId &&
                          m.attachment == true &&
                          m.attachmentData != null)
            .toList();
        
        if (attachmentMessages.isNotEmpty) {
          // Sort by createdAt and get the most recent one
          attachmentMessages.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          foundLocalId = attachmentMessages.first.id;
          customPrint('Found optimistic attachment message to replace - id: $foundLocalId');
        } else {
          customPrint('No optimistic attachment message found for replacement');
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
          // Preserve attachmentData from optimistic message if server doesn't send it back
          Map<String, dynamic>? finalAttachmentData;
          final optimisticMsg = chatHistoryResponse!.chat[msgIndex];
          
          if (data['attachmentData'] != null) {
            try {
              finalAttachmentData = Map<String, dynamic>.from(data['attachmentData']);
              customPrint('Server sent attachmentData, using it - type: ${finalAttachmentData['attachmentType']}');
            } catch (e) {
              customPrint('Error parsing server attachmentData: $e');
              // Fallback to optimistic data
              if (optimisticMsg.attachmentData != null) {
                finalAttachmentData = Map<String, dynamic>.from(optimisticMsg.attachmentData!);
                customPrint('Using optimistic attachmentData as fallback');
              }
            }
          } else if (optimisticMsg.attachment == true && optimisticMsg.attachmentData != null) {
            // CRITICAL: Optimistic message has attachment data - ALWAYS preserve it
            // Even if server says attachment=false, we know it's an attachment from optimistic message
            finalAttachmentData = Map<String, dynamic>.from(optimisticMsg.attachmentData!);
            customPrint('✓✓✓ CRITICAL: Server didn\'t send attachmentData, preserving from optimistic message ✓✓✓');
            customPrint('✓ Preserved attachmentType: ${finalAttachmentData['attachmentType']}');
            customPrint('✓ Server attachment flag: ${data['attachment']}, but optimistic says: ${optimisticMsg.attachment}');
            customPrint('✓ This ensures attachment data is NEVER lost even if server doesn\'t store it');
          } else if (data['attachment'] == true) {
            customPrint('✗✗✗ ERROR: Server says attachment=true but no attachmentData AND no optimistic data! ✗✗✗');
          }
          
          // Determine final attachment flag - if optimistic says attachment=true, it's an attachment
          // Even if server says false, we trust the optimistic message
          final finalAttachment = (optimisticMsg.attachment == true) || (data['attachment'] == true);
          
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
            attachment: finalAttachment, // Use optimistic attachment flag if available
            attachmentData: finalAttachmentData,
          );
          
          customPrint('✓✓✓ Replaced optimistic message - finalAttachment: $finalAttachment, hasData: ${finalAttachmentData != null} ✓✓✓');
          if (finalAttachmentData != null) {
            customPrint('✓ Final attachmentType: ${finalAttachmentData['attachmentType']}');
          } else {
            customPrint('✗ WARNING: Final message has no attachmentData!');
          }
          
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
    
    // Handle attachmentData - ensure it's properly parsed
    Map<String, dynamic>? parsedAttachmentData;
    if (data['attachment'] == true) {
      customPrint('Processing incoming attachment message (receiver side)...');
      if (data['attachmentData'] != null) {
        try {
          // Deep copy the attachmentData to ensure it's properly preserved
          final rawAttachmentData = data['attachmentData'];
          if (rawAttachmentData is Map) {
            parsedAttachmentData = Map<String, dynamic>.from(rawAttachmentData);
            customPrint('Received attachment message with attachmentData - type: ${parsedAttachmentData['attachmentType']}');
            customPrint('AttachmentData keys: ${parsedAttachmentData.keys.toList()}');
            
            // Log the actual data for debugging
            if (parsedAttachmentData['attachmentType'] == 'product') {
              customPrint('Product attachment - productid type: ${parsedAttachmentData['productid'].runtimeType}');
              if (parsedAttachmentData['productid'] is Map) {
                customPrint('Product data keys: ${(parsedAttachmentData['productid'] as Map).keys.toList()}');
              }
            } else if (parsedAttachmentData['attachmentType'] == 'order') {
              customPrint('Order attachment - orderid type: ${parsedAttachmentData['orderid'].runtimeType}');
              if (parsedAttachmentData['orderid'] is Map) {
                customPrint('Order data keys: ${(parsedAttachmentData['orderid'] as Map).keys.toList()}');
              }
            }
          } else {
            customPrint('WARNING: attachmentData is not a Map, it is: ${rawAttachmentData.runtimeType}');
          }
        } catch (e, stackTrace) {
          customPrint('Error parsing attachmentData: $e');
          customPrint('Stack trace: $stackTrace');
        }
      } else {
        customPrint('WARNING: Received attachment message but attachmentData is null!');
        customPrint('Data keys: ${data is Map ? (data as Map).keys.toList() : 'not a map'}');
      }
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
      attachmentData: parsedAttachmentData,
    );
    
    if (data['attachment'] == true) {
      customPrint('Created new attachment message (receiver) - hasData: ${parsedAttachmentData != null}, messageId: ${newMessage.id}');
      if (parsedAttachmentData != null) {
        customPrint('AttachmentData preserved in message - type: ${parsedAttachmentData['attachmentType']}');
      } else {
        customPrint('ERROR: Attachment message created but attachmentData is null!');
      }
    }
    
    // Check if message already exists (avoid duplicates)
    if (chatHistoryResponse!.chat.any((msg) => msg.id == newMessage.id)) {
      customPrint('Message ${newMessage.id} already exists, skipping duplicate');
      return;
    }
    
    // CRITICAL: Final check for attachment messages - log warning if attachmentData is missing
    if (newMessage.attachment == true && newMessage.attachmentData == null) {
      customPrint('✗✗✗ CRITICAL WARNING: Attachment message received but attachmentData is null! ✗✗✗');
      customPrint('✗ Message ID: ${newMessage.id}, senderId: ${newMessage.senderId}, receiverId: ${newMessage.receiverId}');
      customPrint('✗ Server should have sent attachmentData but it is null');
      customPrint('✗ Message will still be added, but attachment cannot be displayed');
      customPrint('✗ This usually means the server is not storing/sending attachmentData correctly');
      // Still add the message - the UI will show an error message
    }
    
    // Add the new message
    chatHistoryResponse!.chat.add(newMessage);
    customPrint('Added new message to chat history - messageId: ${newMessage.id}, attachment: ${newMessage.attachment}, hasAttachmentData: ${newMessage.attachmentData != null}');
    if (newMessage.attachment == true && newMessage.attachmentData != null) {
      customPrint('✓✓✓ Attachment message added successfully ✓✓✓');
      customPrint('✓ Type: ${newMessage.attachmentData!['attachmentType']}');
      customPrint('✓ Message will be displayed in chat');
    }
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
// Set pending attachment (product/order) - will be sent when user taps send button
void setPendingAttachment(Map<String, dynamic> attachmentData) {
  _pendingAttachment = Map<String, dynamic>.from(attachmentData);
  customPrint('Pending attachment set - type: ${_pendingAttachment!['attachmentType']}');
  notifyListeners();
}

// Clear pending attachment
void clearPendingAttachment() {
  _pendingAttachment = null;
  customPrint('Pending attachment cleared');
  notifyListeners();
}

Future<void> sendMessage(String receiverId, String senderId, {bool? attachment, Map<String, dynamic>? attachmentData}) async {
  // Check if there's a pending attachment to send
  Map<String, dynamic>? finalAttachmentData = attachmentData;
  bool finalAttachment = attachment == true;
  
  if (_pendingAttachment != null) {
    customPrint('Found pending attachment, using it for this message');
    finalAttachmentData = Map<String, dynamic>.from(_pendingAttachment!);
    finalAttachment = true;
    _pendingAttachment = null; // Clear after using
    notifyListeners();
  }
  
  // Allow sending even if message is empty (for attachments)
  String message = messageController.text;
  
  // Initialize chatHistoryResponse if null (for new chats)
  if (chatHistoryResponse == null) {
    chatHistoryResponse = ChatHistoryResponse(chat: []);
  }
  
  // Add optimistic message for both text messages and attachments
  String? localMessageId;
  if (finalAttachment == true && finalAttachmentData != null) {
    // Generate unique local ID for optimistic attachment message
    localMessageId = 'local-attachment-${DateTime.now().millisecondsSinceEpoch}-${senderId}';
    
    customPrint('Creating optimistic attachment message - type: ${finalAttachmentData['attachmentType']}');
    customPrint('Optimistic attachment data keys: ${finalAttachmentData.keys}');
    
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
      attachmentData: Map<String, dynamic>.from(finalAttachmentData!), // Ensure it's a copy
    );
    
    customPrint('Optimistic attachment message created with ID: $localMessageId');
    
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
    // CRITICAL: Log before sending to verify parameters
    customPrint('About to call _sendMessageToSocket - finalAttachment: $finalAttachment, finalAttachmentData: ${finalAttachmentData != null ? 'present (${finalAttachmentData.keys.length} keys)' : 'null'}');
    if (finalAttachment == true && finalAttachmentData != null) {
      customPrint('✓ Parameters verified - attachment: true, attachmentData has ${finalAttachmentData.keys.length} keys');
    } else {
      customPrint('✗ WARNING: Parameters might be incorrect - attachment: $finalAttachment, attachmentData: ${finalAttachmentData != null ? 'present' : 'null'}');
    }
    _sendMessageToSocket(receiverId, senderId, message, attachment: finalAttachment, attachmentData: finalAttachmentData);
  }
}

void _sendMessageToSocket(String receiverId, String senderId, String message, {bool? attachment, Map<String, dynamic>? attachmentData}) {
  customPrint('_sendMessageToSocket called - attachment: $attachment, attachmentData: ${attachmentData != null ? 'present' : 'null'}');
  if (attachmentData != null) {
    customPrint('attachmentData keys: ${attachmentData.keys.toList()}');
    customPrint('attachmentData type: ${attachmentData['attachmentType']}');
  }
  
  Map<String, dynamic> messageData = {
    'senderid': senderId,
    'receiverid': receiverId,
    'message': message,
  };
  
  // CRITICAL: Add attachment data if present - ALWAYS check both conditions
  // Use explicit boolean check to handle null cases
  final isAttachment = attachment == true;
  final hasAttachmentDataParam = attachmentData != null && attachmentData.isNotEmpty;
  
  customPrint('Attachment check - isAttachment: $isAttachment, hasAttachmentDataParam: $hasAttachmentDataParam');
  
  if (isAttachment && hasAttachmentDataParam) {
    messageData['attachment'] = true;
    // Deep copy attachmentData to ensure it's sent correctly
    messageData['attachmentData'] = Map<String, dynamic>.from(attachmentData!);
    customPrint('✓✓✓ Sending attachment message to socket ✓✓✓');
    customPrint('✓ attachmentType: ${attachmentData['attachmentType']}');
    customPrint('✓ Attachment data keys: ${attachmentData.keys.toList()}');
    customPrint('✓ Full message data keys: ${messageData.keys.toList()}');
    customPrint('✓ messageData[attachment]: ${messageData['attachment']}');
    customPrint('✓ messageData has attachmentData: ${messageData.containsKey('attachmentData')}');
  } else if (isAttachment && !hasAttachmentDataParam) {
    customPrint('✗✗✗ CRITICAL ERROR: attachment is true but attachmentData is null or empty! ✗✗✗');
    customPrint('✗ attachmentData value: $attachmentData');
    customPrint('✗ This message will be sent WITHOUT attachment data!');
  } else {
    customPrint('Not an attachment message (attachment: $attachment)');
  }
  
  // Final verification before sending
  final hasAttachment = messageData['attachment'] == true;
  final hasAttachmentDataInMessage = messageData.containsKey('attachmentData') && messageData['attachmentData'] != null;
  customPrint('Final check before emit - hasAttachment: $hasAttachment, hasAttachmentDataInMessage: $hasAttachmentDataInMessage');
  
  if (attachment == true && (!hasAttachment || !hasAttachmentDataInMessage)) {
    customPrint('✗✗✗ CRITICAL ERROR: Attachment message but data not properly set! ✗✗✗');
    customPrint('✗✗✗ This message will be sent WITHOUT attachment data! ✗✗✗');
  }
  
  customPrint('Emitting sendMessage - messageData keys: ${messageData.keys.toList()}');
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
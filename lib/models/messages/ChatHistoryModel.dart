class ChatHistoryResponse {
  final List<ChatMessage> chat;

  ChatHistoryResponse({required this.chat});

  factory ChatHistoryResponse.fromJson(Map<String, dynamic> json) {
    return ChatHistoryResponse(
      chat: (json['chat'] as List<dynamic>)
          .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chat': chat.map((e) => e.toJson()).toList(),
    };
  }
}

class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final List<dynamic> likedBy;
  final List<dynamic> replyOf;
  final bool read;
  final bool delivered;
  final bool seen;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String contentURL;
  final String contentType;
  final bool liked;
  final bool? attachment;
  final Map<String, dynamic>? attachmentData;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.likedBy,
    required this.replyOf,
    required this.read,
    required this.delivered,
    required this.seen,
    required this.createdAt,
    required this.updatedAt,
    required this.contentURL,
    required this.contentType,
    required this.liked,
    this.attachment,
    this.attachmentData,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['_id'] as String,
      senderId: json['senderid'] as String,
      receiverId: json['receiverid'] as String,
      message: json['message'] as String? ?? '',
      likedBy: json['likedBy'] as List<dynamic>? ?? [],
      replyOf: json['replyof'] as List<dynamic>? ?? [],
      read: json['read'] as bool? ?? false,
      delivered: json['delivered'] as bool? ?? false,
      seen: json['seen'] as bool? ?? false,
      createdAt: json['createdAt'] != null 
          ? (json['createdAt'] is String 
              ? DateTime.parse(json['createdAt'] as String)
              : DateTime.parse(json['createdAt'].toString()))
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] is String
              ? DateTime.parse(json['updatedAt'] as String)
              : DateTime.parse(json['updatedAt'].toString()))
          : DateTime.now(),
      contentURL: json['media'] as String? ?? '',
      contentType: json['contentType'] as String? ?? '',
      liked: json['liked'] as bool? ?? false,
      attachment: json['attachment'] as bool? ?? false,
      attachmentData: json['attachmentData'] != null
          ? (json['attachmentData'] is Map
              ? Map<String, dynamic>.from(json['attachmentData'] as Map)
              : null)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'senderid': senderId,
      'receiverid': receiverId,
      'message': message,
      'likedBy': likedBy,
      'replyof': replyOf,
      'read': read,
      'delivered': delivered,
      'seen': seen,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'media': contentURL,
      'contentType': contentType,
      'liked': liked,
      'attachment': attachment ?? false,
      'attachmentData': attachmentData,
    };
  }
}

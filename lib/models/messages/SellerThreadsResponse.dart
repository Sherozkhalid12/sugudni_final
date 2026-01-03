class SellerThreadResponse {
  final List<Thread> threads;

  SellerThreadResponse({required this.threads});

  factory SellerThreadResponse.fromJson(Map<String, dynamic> json) {
    return SellerThreadResponse(
      threads: (json['threads'] as List)
          .map((thread) => Thread.fromJson(thread))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'threads': threads.map((thread) => thread.toJson()).toList(),
    };
  }
}

class Thread {
  final String id;
  final List<Participant> participants;
  final String lastMessage;
  final String lastMessageSenderId;
  final DateTime lastMessageTimestamp;
  final String contentType;
  final int unreadCount;
  final String? threadType;

  Thread({
    required this.id,
    required this.participants,
    required this.lastMessage,
    required this.lastMessageSenderId,
    required this.lastMessageTimestamp,
    required this.contentType,
    required this.unreadCount,
    this.threadType,
  });

  factory Thread.fromJson(Map<String, dynamic> json) {
    return Thread(
      id: json['_id'] as String,
      participants: (json['participants'] as List)
          .map((participant) => Participant.fromJson(participant))
          .toList(),
      lastMessage: json['last_message'] as String,
      lastMessageSenderId: json['last_message_sender_id'] as String,
      lastMessageTimestamp: DateTime.parse(json['last_message_timestamp']),
      contentType: json['contentType'] as String,
      unreadCount: json['unreadCount'] as int,
      threadType: json['threadType'] as String? ?? json['thread_type'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'participants': participants.map((participant) => participant.toJson()).toList(),
      'last_message': lastMessage,
      'last_message_sender_id': lastMessageSenderId,
      'last_message_timestamp': lastMessageTimestamp.toIso8601String(),
      'contentType': contentType,
      'unreadCount': unreadCount,
      'threadType': threadType,
    };
  }
}

class Participant {
  final String userId;
  final String profilePic;

  Participant({required this.userId, required this.profilePic});

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      userId: json['userid'] as String,
      profilePic: json['profilePic'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userid': userId,
      'profilePic': profilePic,
    };
  }
}

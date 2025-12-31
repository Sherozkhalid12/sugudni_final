import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/utils/global-functions.dart';

class ChatScreen extends StatefulWidget {
  final String senderId;
  final String receiverId;

  const ChatScreen({super.key, required this.senderId, required this.receiverId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late IO.Socket socket;
  TextEditingController messageController = TextEditingController();
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    connectSocket();
  }

  void connectSocket() {
    customPrint("Connecting=======================================");
    socket = IO.io('http://16.16.26.46:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      print('Connected to socket');
      socket.emit('seeMessage', {
        'senderid': widget.senderId,
        'userid': widget.receiverId,
      });
    });

    socket.on('newMessage', (data) {
      setState(() {
        messages.add({
          'message': data['message'],
          'senderid': data['senderid'],
        });
      });
    });

    socket.on('deliveredMessage', (data) {
      print('Message delivered to ${data['receiverid']}');
    });
  }

  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      String message = messageController.text;
      String messageId = DateTime.now().millisecondsSinceEpoch.toString();

      socket.emit('sendMessage', {
        'messageid': messageId,
        'senderid': widget.senderId,
        'receiverid': widget.receiverId,
        'message': message,
      });

      setState(() {
        messages.add({
          'message': message,
          'senderid': widget.senderId,
        });
      });
      messageController.clear();
    }
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Align(
                    alignment: messages[index]['senderid'] == widget.senderId
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: messages[index]['senderid'] == widget.senderId
                            ? Colors.blue
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        messages[index]['message'],
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Enter message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

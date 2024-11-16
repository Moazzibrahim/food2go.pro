import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/chat/chat_delivery_provider.dart';

class ChatScreen extends StatefulWidget {
  final String userName;
  final String? userImage;
  final int userid;
  final int orderid;

  const ChatScreen({
    required this.userName,
    this.userImage,
    super.key,
    required this.userid,
    required this.orderid,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    log(widget.userid.toString());
    log(widget.orderid.toString());

    super.initState();
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.fetchChat(context, widget.orderid, widget.userid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: Row(
          children: [
            if (widget.userImage != null)
              CircleAvatar(
                backgroundImage: NetworkImage(widget.userImage!),
              ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Chat with ${widget.userName}',
                style: const TextStyle(color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          if (chatProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (chatProvider.errorMessage != null) {
            log(chatProvider.errorMessage.toString());
            return Center(child: Text(chatProvider.errorMessage!));
          }

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE6E9F0), Color(0xFFF5F7FA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    itemCount: chatProvider.messages.length,
                    itemBuilder: (context, index) {
                      final message = chatProvider.messages[index];
                      bool isMe =
                          message.userSender == 1; // If userSender is an int
                      return Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue[400] : Colors.grey[300],
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(15),
                              topRight: const Radius.circular(15),
                              bottomLeft: isMe
                                  ? const Radius.circular(15)
                                  : Radius.zero,
                              bottomRight: isMe
                                  ? Radius.zero
                                  : const Radius.circular(15),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 5,
                                offset: const Offset(2, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message.message,
                                style: TextStyle(
                                  color: isMe ? Colors.white : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                message.createdAt != null
                                    ? message.createdAt!
                                        .toLocal()
                                        .toString()
                                        .substring(0, 19)
                                    : 'No timestamp',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isMe
                                      ? Colors.white.withOpacity(0.8)
                                      : Colors.black.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(height: 1, thickness: 1),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            hintStyle: const TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.blue,
                        child: IconButton(
                          icon: const Icon(Icons.send, color: Colors.white),
                          onPressed: () {
                            // Add functionality for sending messages here
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

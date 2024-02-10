import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/provider/chat_provider.dart';

class ChatPage extends StatefulWidget {
  final String name;
  final String profileUrl;
  final String receiverEmail;
  const ChatPage({
    super.key,
    required this.name,
    required this.profileUrl,
    required this.receiverEmail,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final messageController = TextEditingController();
  final scrollController = ScrollController();
  final focusNode = FocusNode();

  void scrollDown() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }

  @override
  void initState() {
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
      }
    });
    Future.delayed(const Duration(milliseconds: 500), () => scrollDown());

    Provider.of<ChatProvider>(context, listen: false).getMessages(
      senderEmail: FirebaseAuth.instance.currentUser!.email.toString(),
      receiverEmail: widget.receiverEmail,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              foregroundImage: NetworkImage(widget.profileUrl),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(widget.name),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Icon(Icons.info_outline_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 6.0, vertical: 12),
              child: Consumer<ChatProvider>(
                builder: (context, provider, child) {
                  return ListView.builder(
                    controller: scrollController,
                    itemCount: provider.messagesList.length,
                    itemBuilder: (context, index) {
                      final messages = provider.messagesList;
                      bool currentUser =
                          FirebaseAuth.instance.currentUser!.email ==
                              messages[index].senderEmail;
                      return Column(
                        crossAxisAlignment: currentUser
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          // Siz
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8,
                              right: 8,
                              top: 1,
                            ),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.sizeOf(context).width / 2,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  color: currentUser
                                      ? Colors.blue.shade400
                                      : Colors.grey.shade700,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    messages[index].message,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(32),
              ),
              child: SizedBox(
                height: 30,
                width: MediaQuery.sizeOf(context).width * 0.7,
                child: TextField(
                  focusNode: focusNode,
                  controller: messageController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.image_outlined),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        if (messageController.text.isEmpty) {
                          return;
                        }
                        context.read<ChatProvider>().addMessage(
                              MessageModel(
                                message: messageController.text,
                                senderEmail: FirebaseAuth
                                    .instance.currentUser!.email
                                    .toString(),
                                receiverEmail: widget.receiverEmail,
                                messageSent: Timestamp.now().toString(),
                              ),
                            );
                        messageController.clear();
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          borderRadius:
                              BorderRadius.all(Radius.elliptical(32, 32)),
                        ),
                        child: const Icon(Icons.send_rounded),
                      ),
                    ),
                    hintText: "Start a message",
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

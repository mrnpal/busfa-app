import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:async';

class GroupChatPage extends StatefulWidget {
  @override
  _GroupChatPageState createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;
  final ScrollController _scrollController = ScrollController();

  late StreamSubscription _typingStatusSub;

  bool _isTyping = false;
  bool _someoneTyping = false;
  String _typingUserName = '';

  @override
  void initState() {
    super.initState();
    _listenTypingStatus();
  }

  void _listenTypingStatus() {
    _typingStatusSub = FirebaseFirestore.instance
        .collection('typingStatus')
        .snapshots()
        .listen((snapshot) {
          final docs = snapshot.docs;
          for (var doc in docs) {
            if (doc.id != user?.uid && doc['isTyping'] == true) {
              setState(() {
                _someoneTyping = true;
                _typingUserName = doc['name'] ?? 'Alumni';
              });
              return;
            }
          }
          setState(() {
            _someoneTyping = false;
            _typingUserName = '';
          });
        });
  }

  void _updateTypingStatus(bool isTyping) async {
    if (user == null) return;

    final uid = user!.uid;
    final nameSnapshot =
        await FirebaseFirestore.instance
            .collection('alumniVerified')
            .doc(uid)
            .get();
    final name =
        nameSnapshot.exists
            ? (nameSnapshot.data()?['name'] ?? 'Alumni')
            : 'Alumni';

    await FirebaseFirestore.instance.collection('typingStatus').doc(uid).set({
      'isTyping': isTyping,
      'name': name,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  void sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final uid = user?.uid;
    if (uid == null) return;

    final doc =
        await FirebaseFirestore.instance
            .collection('alumniVerified')
            .doc(uid)
            .get();

    final name = doc.exists ? (doc.data()?['name'] ?? 'Alumni') : 'Alumni';
    final photoUrl = doc.data()?['photoUrl'] ?? null;

    await FirebaseFirestore.instance.collection('groupChats').add({
      'senderId': uid,
      'senderName': name,
      'photoUrl': photoUrl,
      'message': _messageController.text.trim(),
      'timestamp': FieldValue.serverTimestamp(),
    });

    _messageController.clear();
    _updateTypingStatus(false);

    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    final now = DateTime.now();
    final date = timestamp.toDate();
    final diff = now.difference(date);

    if (diff.inDays > 7) {
      return DateFormat('MMM d, y').format(date);
    } else if (diff.inDays > 0) {
      return '${diff.inDays}d ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Form Alumni',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade700, Colors.blue.shade500],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('groupChats')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;

                if (messages.isEmpty) {
                  return Center(
                    child: Text(
                      'Mulai percakapan dengan alumni lainnya!',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final data = messages[index].data() as Map<String, dynamic>;
                    final isMe = data['senderId'] == user?.uid;

                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child: Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!isMe)
                              CircleAvatar(
                                radius: 20,
                                backgroundImage:
                                    data['photoUrl'] != null
                                        ? NetworkImage(data['photoUrl'])
                                        : AssetImage(
                                              'assets/images/profile-icon.png',
                                            )
                                            as ImageProvider,
                              ),
                            if (!isMe) SizedBox(width: 8),
                            Flexible(
                              child: Column(
                                crossAxisAlignment:
                                    isMe
                                        ? CrossAxisAlignment.end
                                        : CrossAxisAlignment.start,
                                children: [
                                  if (!isMe)
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 4),
                                      child: Text(
                                        data['senderName'] ?? '',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Colors.blue.shade800,
                                        ),
                                      ),
                                    ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color:
                                          isMe
                                              ? Colors.blue.shade500
                                              : Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16),
                                        bottomLeft:
                                            isMe
                                                ? Radius.circular(16)
                                                : Radius.circular(4),
                                        bottomRight:
                                            isMe
                                                ? Radius.circular(4)
                                                : Radius.circular(16),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 16,
                                    ),
                                    child: Text(
                                      data['message'] ?? '',
                                      style: TextStyle(
                                        color:
                                            isMe
                                                ? Colors.white
                                                : Colors.black87,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 4),
                                    child: Text(
                                      data['timestamp'] != null
                                          ? _formatTimestamp(
                                            data['timestamp'] as Timestamp,
                                          )
                                          : '',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          if (_someoneTyping)
            FadeIn(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '$_typingUserName sedang mengetik...',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Tulis pesan...',
                        border: InputBorder.none,
                      ),
                      style: TextStyle(fontSize: 16),
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (val) {
                        final isNowTyping = val.trim().isNotEmpty;
                        if (_isTyping != isNowTyping) {
                          _isTyping = isNowTyping;
                          _updateTypingStatus(isNowTyping);
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade600, Colors.blue.shade400],
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _updateTypingStatus(false);
    _typingStatusSub.cancel(); // <-- Tambahkan ini
    super.dispose();
  }
}

// lib/services/chat_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/chat_message_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ============================================
  // SEND MESSAGES
  // ============================================

  /// Send message to admin
  Future<void> sendMessageToAdmin({
    required String userId,
    required String userName,
    String? userPhotoUrl,
    required String message,
  }) async {
    final conversationId = 'admin_$userId';

    // Add message
    await _firestore.collection('messages').add({
      'conversationId': conversationId,
      'senderId': userId,
      'senderName': userName,
      'senderPhotoUrl': userPhotoUrl,
      'receiverId': 'admin',
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': false,
      'isFromAdmin': false,
    });

    // Update or create conversation
    await _firestore.collection('conversations').doc(conversationId).set({
      'userId': userId,
      'userName': userName,
      'userPhotoUrl': userPhotoUrl,
      'lastMessage': message,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'unreadCount': FieldValue.increment(1),
      'isAdminConversation': true,
    }, SetOptions(merge: true));
  }

  /// Admin sends message to user
  Future<void> adminSendMessage({
    required String userId,
    required String adminName,
    required String message,
  }) async {
    final conversationId = 'admin_$userId';

    // Add message
    await _firestore.collection('messages').add({
      'conversationId': conversationId,
      'senderId': 'admin',
      'senderName': adminName,
      'receiverId': userId,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': false,
      'isFromAdmin': true,
    });

    // Update conversation
    await _firestore.collection('conversations').doc(conversationId).update({
      'lastMessage': message,
      'lastMessageTime': FieldValue.serverTimestamp(),
    });
  }

  // ============================================
  // GET MESSAGES
  // ============================================

  /// Get messages for a conversation
  Stream<List<ChatMessageModel>> getMessages(String userId) {
    final conversationId = 'admin_$userId';

    return _firestore
        .collection('messages')
        .where('conversationId', isEqualTo: conversationId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ChatMessageModel.fromFirestore(doc))
        .toList());
  }

  /// Get all conversations for admin
  Stream<List<ConversationModel>> getAllConversations() {
    return _firestore
        .collection('conversations')
        .where('isAdminConversation', isEqualTo: true)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ConversationModel.fromFirestore(doc))
        .toList());
  }

  /// Get unread count for user
  Stream<int> getUnreadCount(String userId) {
    final conversationId = 'admin_$userId';

    return _firestore
        .collection('messages')
        .where('conversationId', isEqualTo: conversationId)
        .where('receiverId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  /// Mark messages as read
  Future<void> markMessagesAsRead(String userId, bool isAdmin) async {
    final conversationId = 'admin_$userId';
    final receiverId = isAdmin ? 'admin' : userId;

    final messages = await _firestore
        .collection('messages')
        .where('conversationId', isEqualTo: conversationId)
        .where('receiverId', isEqualTo: receiverId)
        .where('isRead', isEqualTo: false)
        .get();

    final batch = _firestore.batch();
    for (var doc in messages.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();

    // Reset unread count in conversation
    if (isAdmin) {
      await _firestore.collection('conversations').doc(conversationId).update({
        'unreadCount': 0,
      });
    }
  }
}
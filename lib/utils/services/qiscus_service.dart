// import 'dart:developer';
// import 'package:get/get.dart';
// import 'package:qiscus_chat_sdk/qiscus_chat_sdk.dart';

// class QiscusService extends GetxService {
//   static final _qiscus = QiscusSDK();

//   static Future<void> setUser({
//     required String userId,
//     required String userKey,
//     String? username,
//   }) async {
//     var account = await _qiscus.setUser(
//       userId: userId,
//       userKey: userKey,
//       username: username,
//     );
//     log("ACCOUNT $account");
//   }

//   static bool get hasSetupUser {
//     return _qiscus.hasSetupUser();
//   }

//   static Future<QChatRoom> chatUser(String userId) async {
//     return await _qiscus.chatUser(userId: userId);
//   }

//   static Future<QChatRoom> chatUsers(String name, List<String> userIds) async {
//     return await _qiscus.createGroupChat(name: name, userIds: userIds);
//   }

//   static Future<List<QChatRoom>> getRooms() async {
//     return _qiscus.getAllChatRooms(showParticipant: true, showEmpty: true);
//   }

//   static Future<QChatRoomWithMessages> getRoom(int roomId) async {
//     return await _qiscus.getChatRoomWithMessages(roomId: roomId);
//   }

//   static Future<List<QParticipant>> getParticipants(String roomUniqueId) async {
//     return await _qiscus.getParticipants(roomUniqueId: roomUniqueId);
//   }

//   static Future<List<QParticipant>> addParticipant(
//       List<String> userIds, int roomId) async {
//     return await _qiscus.addParticipants(userIds: userIds, roomId: roomId);
//   }

//   static Future<void> removeParticipant(
//       List<String> userIds, int roomId) async {
//     await _qiscus.removeParticipants(userIds: userIds, roomId: roomId);
//   }

//   static void Function(QChatRoom) get subscribeRoom =>
//       _qiscus.subscribeChatRoom;

//   static void Function(QChatRoom) get unsubscribeRoom =>
//       _qiscus.unsubscribeChatRoom;

//   static Future<void> clearUser() async {
//     await _qiscus.clearUser();
//   }

//   static QAccount? get currentUser {
//     return _qiscus.currentUser;
//   }

//   static Stream<QMessage> get messageStream {
//     return _qiscus.onMessageReceived();
//   }

//   static QMessage sendMessage({required String text, required int roomId}) {
//     var message = _qiscus.generateMessage(
//       text: text,
//       chatRoomId: roomId,
//     );

//     _qiscus.sendMessage(message: message);

//     return message;
//   }

//   Future<QiscusService> initiateQiscus() async {
//     try {
//       await _qiscus.setup(GeneralConsts.qiscusAppId);
//       return this;
//     } on Exception {
//       rethrow;
//     }
//   }
// }

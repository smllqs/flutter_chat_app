import 'package:flutter_chat_app/models/chat.dart';
import 'package:flutter_chat_app/models/local_message.dart';

abstract class IDataSource {
  Future<void> addChat(Chat chat);
  Future<List<Chat>> findAllChats();
  Future<void> addMessage(LocalMessage message);
  Future<Chat?> findChat(String chatId);
  Future<List<LocalMessage>> findMessages(String chatId);
  Future<void> updateMessage(LocalMessage message);
  Future<void> deteleChat(String chatId);
}

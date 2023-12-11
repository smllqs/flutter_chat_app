import 'package:flutter_chat_app/data/data_source/data_source_contract.dart';
import 'package:flutter_chat_app/models/chat.dart';
import 'package:flutter_chat_app/models/local_message.dart';
import 'package:sqflite/sqlite_api.dart';

class SQfliteDataSource implements IDataSource {
  final Database _db;

  const SQfliteDataSource(this._db);
  @override
  Future<void> addChats(Chat chat) async {
    await _db.insert('chats', chat.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> addMessage(LocalMessage message) async {
    await _db.insert('message', message.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> deteleChat(String chatId) {
    // TODO: implement deteleChat
    throw UnimplementedError();
  }

  @override
  Future<List<Chat>> findAllChats() {
    // TODO: implement findAllChats
    throw UnimplementedError();
  }

  @override
  Future<Chat> findChat(String chatId) {
    // TODO: implement findChat
    throw UnimplementedError();
  }

  @override
  Future<List<LocalMessage>> findMessages(String chatId) {
    // TODO: implement findMessages
    throw UnimplementedError();
  }

  @override
  Future<void> updateMessage(LocalMessage message) {
    // TODO: implement updateMessage
    throw UnimplementedError();
  }
}

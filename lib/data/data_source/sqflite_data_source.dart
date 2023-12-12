import 'dart:js_interop_unsafe';

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
  Future<void> deteleChat(String chatId) async {
    final batch = _db.batch();
    batch.delete('messages', where: 'chat_id = ?', whereArgs: [chatId]);
    batch.delete('chats', where: 'id = ?', whereArgs: [chatId]);
    await batch.commit(noResult: true);
  }

  @override
  Future<List<Chat>> findAllChats() {
    return _db.transaction((txn) async {
      final chatsWithLatestMessage = await txn.rawQuery('''
            SELECT messages.* FROM
            (
              SELECT chat_id, MAX(created_at) AS created_at
              FROM messages
              GROUP BY chat_id
            ) AS latest_messages
            INNER JOIN  messages
            ON latest_messages.chat_id = messages.chat_id
            AND latest_messages.created_at = messages.created_at
            ''');

      final chatsWithUnreadMessages = await txn.rawQuery('''
              SELECT chat_id, count(*) AS unread
              FROM messages
              WHERE receipt = ?
              GROUP BY chat_id
            ''', ['delivered']);

      return chatsWithLatestMessage.map<Chat>((row) {
        final int? unread = int.tryParse(chatsWithUnreadMessages.firstWhere(
            (ele) => row['chat_id'] == ele['chat_id'],
            orElse: () => {'unread': 0})['unread'] as String);
        
        final 
      }).toList();
    });
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

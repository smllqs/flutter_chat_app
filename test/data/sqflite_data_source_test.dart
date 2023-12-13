import 'package:chat/chat.dart';
import 'package:flutter_chat_app/data/data_source/sqflite_data_source.dart';
import 'package:flutter_chat_app/models/chat.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
// import 'package:sqflite/sqflite.dart';

// class MockSqfliteDatabase extends Mock implements Database {}

// class MockBatch extends Mock implements Batch {}

import 'package:mockito/annotations.dart';
import 'package:sqflite/sqflite.dart';

import 'sqflite_data_source_test.mocks.dart';

@GenerateMocks([Database, Batch])
void main() {
  late SQfliteDataSource sut;
  late MockDatabase database;
  // MockBatch batch;
  setUp(() {
    print('object');
    database = MockDatabase();
    // batch = MockBatch();
    sut = SQfliteDataSource(database);
  });

  final message = Message.fromJson({
    'from': '111',
    'to': '222',
    'contents': 'hey',
    'timestamp': DateTime.parse("2023-12-12"),
    'id': '4444'
  });

  test('should perform insert of chat to the database', () async {
    final chat = Chat('1234');
    // print(database.isOpen);
    when(database.insert('chats', chat.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace))
        .thenAnswer((_) async => 1);

    await sut.addChat(chat);

    verify(database.insert('chats', chat.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace))
        .called(1);
  });
}
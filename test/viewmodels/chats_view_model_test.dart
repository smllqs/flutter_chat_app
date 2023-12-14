import 'package:chat/chat.dart';
import 'package:flutter_chat_app/data/data_source/data_source_contract.dart';
import 'package:flutter_chat_app/models/chat.dart';
import 'package:flutter_chat_app/viewmodels/chats_view_model.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'chats_view_model_test.mocks.dart';

@GenerateMocks([IDataSource])
void main() {
  late ChatsViewModel sut;
  late MockIDataSource mockIDataSource;

  setUp(() {
    mockIDataSource = MockIDataSource();
    sut = ChatsViewModel(mockIDataSource);
  });

  final message = Message.fromJson({
    'from': '111',
    'to': '222',
    'contents': 'hey',
    'timestamp': DateTime.parse("2023-12-14"),
    'id': '4444'
  });

  test('initial chats return empty list', () async {
    when(mockIDataSource.findAllChats()).thenAnswer((_) async => []);
    expect(await sut.getChats(), isEmpty);
  });

  test('return list of chats', () async {
    final chat = Chat('123');
    when(mockIDataSource.findAllChats()).thenAnswer((_) async => [chat]);

    final chats = await sut.getChats();
    expect(await sut.getChats(), isNotEmpty);
  });

  test('creates a new chat when receiving message for the first time',
      () async {
    when(mockIDataSource.findChat(any)).thenAnswer((_) async => null);
    await sut.receivedMessage(message);
    verify(mockIDataSource.addChat(any)).called(1);
  });

  test('add new message to existing chat', () async {
    final chat = Chat('123');
    when(mockIDataSource.findChat(any)).thenAnswer((_) async => chat);
    await sut.receivedMessage(message);
    verifyNever(mockIDataSource.addChat(any));
    verify(mockIDataSource.addMessage(any)).called(1);
  });
}

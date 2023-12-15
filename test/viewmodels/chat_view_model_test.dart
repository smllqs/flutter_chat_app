import 'package:chat/chat.dart';
import 'package:flutter_chat_app/models/chat.dart';
import 'package:flutter_chat_app/models/local_message.dart';
import 'package:flutter_chat_app/viewmodels/chat_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'chats_view_model_test.mocks.dart';

void main() {
  late ChatViewModel sut;
  late MockIDataSource mockIDataSource;

  setUp(() {
    mockIDataSource = MockIDataSource();
    sut = ChatViewModel(mockIDataSource);
  });

  final message = Message.fromJson({
    'from': '111',
    'to': '222',
    'contents': 'hey',
    'timestamp': DateTime.parse("2023-12-14"),
    'id': '4444'
  });

  test('initial messages return empty list', () async {
    when(mockIDataSource.findMessages(any)).thenAnswer((_) async => []);
    expect(await sut.getMessages('123'), isEmpty);
  });

  test('returns list of messages from local storage', () async {
    final chat = Chat('123');
    final localMessage =
        LocalMessage(chat.id, message, ReceiptStatus.delivered);
    when(mockIDataSource.findMessages(chat.id))
        .thenAnswer((_) async => [localMessage]);
    final messages = await sut.getMessages(chat.id);
    expect(messages, isNotEmpty);
    expect(messages.first.chatId, '123');
  });

  test('creates a new chat when sending first message', () async {
    when(mockIDataSource.findChat(any)).thenAnswer((_) async => null);
    await sut.sentMessage(message);
    verify(mockIDataSource.addChat(any)).called(1);
  });

  test('add new sent message to the chat', () async {
    final chat = Chat(message.to);
    final localMesssage =
        LocalMessage(chat.id, message, ReceiptStatus.delivered);
    when(mockIDataSource.findMessages(chat.id))
        .thenAnswer((_) async => [localMesssage]);
    when(mockIDataSource.findChat(chat.id)).thenAnswer((_) async => chat);

    await sut.getMessages(chat.id);
    await sut.sentMessage(message);

    verifyNever(mockIDataSource.addChat(any));
    verify(mockIDataSource.addMessage(any)).called(1);
  });

  test('add new received message to the chat', () async {
    final chat = Chat(message.from);
    final localMessage =
        LocalMessage(chat.id, message, ReceiptStatus.delivered);
    when(mockIDataSource.findMessages(chat.id))
        .thenAnswer((_) async => [localMessage]);
    when(mockIDataSource.findChat(chat.id)).thenAnswer((_) async => chat);

    await sut.getMessages(chat.id);
    await sut.receivedMessage(message);

    verifyNever(mockIDataSource.addChat(any));
    verify(mockIDataSource.addMessage(any)).called(1);
  });

  test('create new chat  when message received is not part of this chat',
      () async {
    final chat = Chat('123');
    final localMessage =
        LocalMessage(chat.id, message, ReceiptStatus.delivered);
    when(mockIDataSource.findMessages(chat.id)).thenAnswer(
      (_) async => [localMessage],
    );
    when(mockIDataSource.findChat(chat.id)).thenAnswer((_) async => null);
    when(mockIDataSource.findChat(message.from)).thenAnswer((_) async => null);

    await sut.getMessages(chat.id);
    await sut.receivedMessage(message);

    verify(mockIDataSource.addChat(any)).called(1);
    verify(mockIDataSource.addMessage(any)).called(1);
    expect(sut.otherMessages, 1);
  });
}

import 'package:chat/chat.dart';
import 'package:flutter_chat_app/state_management/message/message_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'message_bloc_test.mocks.dart';

@GenerateMocks([IMessageService])
void main() {
  late MessageBloc sut;
  late IMessageService messageService;
  late User user;

  setUp(() {
    messageService = MockIMessageService();
    user = User(
        username: 'test',
        photoUrl: 'url',
        active: true,
        lastSeen: DateTime.now());
    sut = MessageBloc(messageService);
  });

  // tearDown(() => sut.close());

  test('should emit initial state only without subscription', () {
    expect(sut.state, MessageInitial());
  });

  test('should emit message sent state when message is sent', () {
    final message = Message(
        from: '123',
        to: '456',
        contents: 'test message',
        timestamp: DateTime.now());

    when(messageService.send(message)).thenAnswer((_) async => true);
    sut.add(MessageEvent.onMessageSent(message));
    expectLater(sut.stream, emits(MessageState.sent(message)));
  });
}

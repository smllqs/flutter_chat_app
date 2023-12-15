part of 'message_bloc.dart';

abstract class MessageState extends Equatable {
  const MessageState();

  factory MessageState.initial() => MessageInitial();
  factory MessageState.sent(Message message) => MessageSentSuccesss(message);
  factory MessageState.received(Message message) =>
      MessageReceivedSuccesss(message);
  @override
  List<Object> get props => [];
}

class MessageInitial extends MessageState {}

class MessageSentSuccesss extends MessageState {
  final Message message;
  const MessageSentSuccesss(this.message);

  @override
  List<Object> get props => [message];
}

class MessageReceivedSuccesss extends MessageState {
  final Message message;
  const MessageReceivedSuccesss(this.message);

  @override
  List<Object> get props => [message];
}

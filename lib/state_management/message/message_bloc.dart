import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat/chat.dart';
import 'package:equatable/equatable.dart';

part 'message_state.dart';
part 'messasge_event.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final IMessageService _messageService;
  late StreamSubscription? _subscription;

  MessageBloc(this._messageService) : super(MessageState.initial()) {
    // ignore: void_checks
    // on<MessageSent>((event, emit) async* {
    //   emit(event);
    // });
    on<Subscribed>((event, emit) async {
      await _subscription?.cancel();
      _subscription = _messageService
          .messages(activeUser: event.user)
          .listen((message) => add(_MessageReceived(message)));
      emit(MessageInitial());
    });
    on<MessageSent>((event, emit) async {
      await _messageService.send(event.message);
      emit(MessageSentSuccesss(event.message));
      // yield MessageState.sent(event.message);
    });
    on<_MessageReceived>((event, emit) {
      emit(MessageReceivedSuccesss(event.message));
    });
  }

  Stream<MessageState> mapEventToState(MessageEvent event) async* {
    if (event is Subscribed) {
      await _subscription?.cancel();
      _subscription = _messageService
          .messages(activeUser: event.user)
          .listen((message) => add(_MessageReceived(message)));
    }

    if (event is _MessageReceived) {
      yield MessageState.received(event.message);
    }

    if (event is MessageSent) {
      await _messageService.send(event.message);
      yield MessageState.sent(event.message);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _messageService.dispose();
    return super.close();
  }
}
